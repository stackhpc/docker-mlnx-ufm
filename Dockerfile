# Docker image for Mellanox UFM.

FROM centos/systemd
MAINTAINER StackHPC

# UFM software version. Example: 5.9.6-8.el7.x86_64.
ARG ufm_version

# URL of UFM software tarball.
ARG ufm_tarball_url

# URL of OFED yum repo.
ARG ofed_repo_url

# Configure CentOS repositories.
ARG centos_version
ENV centos_version=$centos_version
ADD centos-repos.sh /
RUN /centos-repos.sh

# Add a useful label.
LABEL com.stackhpc.mlnx-ufm.version=$ufm_version

# Set an environment variable to tell systemd it's running under Docker.
ENV container=docker

# Systemd does not terminate on SIGTERM.
STOPSIGNAL SIGRTMIN+3

# Create a yum repository file for OFED.
ADD create-ofed-repo.sh /
ENV ofed_repo_url=$ofed_repo_url
RUN /create-ofed-repo.sh \
    && rm /create-ofed-repo.sh

# Install Mellanox OFED package group.
RUN yum install -y \
    mlnx-ofed-hpc \
    && yum clean all

# Install latest version of php
RUN yum install epel-release yum-utils -y &&\ 
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php72 
    
# Dependencies listed in UFM install guide.
RUN yum install -y \
    httpd \
    mariadb \
    mariadb-server \
    MySQL-python \
    php \
    net-snmp \
    net-snmp-libs \
    mod_ssl \
    iptables \
    pexpect \
    telnet \
    pyOpenSSL \
    libxml2 \
    libxslt \
    unixODBC \
    infiniband-diags \
    cairo \
    sudo \
    psmisc \
    bc \
    python-dateutil \
    && yum clean all

#Hide default http welcome page
RUN mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.bak

#Modify the config to allow us to restric access to root html directory
#We need to search the config file for the relevant options and then
#modify the second one, to minimize the possibility of a change to the
#structure of the config file breaking this command
RUN export LN=$(grep -n "AllowOverride None" /etc/httpd/conf/httpd.conf | sed '2q;d' | awk -F  ":" '{ print $1}') && \
    sed -i "${LN}s/.*/    AllowOverride All/" httpd.conf 

#Add access list to root directory
COPY httpd/.htaccess /var/www/html/

# Additional UFM dependencies found through testing.
RUN yum install -y \
    net-tools \
    net-snmp-utils \
    pyparsing \
    python-setuptools \
    which \
    && yum clean all

# Install pip.
RUN easy_install pip

# Remove conflicting packages.
RUN yum remove -y \
    kmod-kernel-mft-mlnx \
    mft \
    opensm \
    && yum clean all

# Download the UFM tarball.
ADD $ufm_tarball_url /

# Extract the UFM tarball.
RUN mv $(basename $ufm_tarball_url) /ufm.tgz \
    && mv /ufm.tgz /ufm-${ufm_version}.tgz \
    && tar -xzf /ufm-${ufm_version}.tgz \
    && rm /ufm-${ufm_version}.tgz

# Install UFM.
RUN /ufm-${ufm_version}/install.sh -o ib

# Add a noop startup configuration script. This can be customised by bind
# mounting a script to /usr/bin/mlnx-ufm-configure.
ADD mlnx-ufm-configure /usr/bin/mlnx-ufm-configure
RUN chmod +x /usr/bin/mlnx-ufm-configure

# Add a systemd unit for running the startup configuration script.
ADD mlnx-ufm-configure.service /usr/lib/systemd/system/

# Configure UFM and UFM startup configuration script to run on startup.
RUN systemctl enable ufmd mlnx-ufm-configure

# Various systemd services aren't required in a container.
RUN systemctl disable network openibd
