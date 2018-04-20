# Docker image for Mellanox UFM.

FROM centos/systemd
MAINTAINER StackHPC

# UFM software version. Example: 5.9.6-8.el7.x86_64.
ARG ufm_version

# URL of UFM software tarball.
ARG ufm_tarball_url

# URL of OFED yum repo.
ARG ofed_repo_url

# Add a useful label.
LABEL com.stackhpc.mlnx-ufm.version=$ufm_version

# Set an environment variable to tell systemd it's running under Docker.
ENV container=docker

# Create a yum repository file for OFED.
ADD create-ofed-repo.sh /
ENV ofed_repo_url=$ofed_repo_url
RUN /create-ofed-repo.sh \
    && rm /create-ofed-repo.sh

# Install Mellanox OFED package group.
RUN yum install -y \
    mlnx-ofed-hpc \
    && yum clean all
    
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

# Additional UFM dependencies found through testing.
RUN yum install -y \
    net-tools \
    net-snmp-utils \
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

# Configure UFM to run on startup.
RUN systemctl enable ufmd
