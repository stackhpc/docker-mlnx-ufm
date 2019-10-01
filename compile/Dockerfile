# Docker image for compiling UFM source RPMs.

FROM centos:7
MAINTAINER StackHPC

# Pass this in via --build-arg kernel_version=$(uname -r)
ARG kernel_version
ENV kernel_version=$kernel_version

ARG ufm_version
ENV ufm_version=$ufm_version

ARG ufm_tarball_url
ENV ufm_tarball_url=$ufm_tarball_url

ADD $ufm_tarball_url /

RUN tar -xzf /$(basename $ufm_tarball_url) \                                                                                                                                        │······················
    && rm /$(basename $ufm_tarball_url)

# Buld UFM RPMs. Required if the following is seen during installation:
# ERROR:
#   UFM installation is missing kernel-dependent mft rpm for local kernel 3.10.0-693.11.1.el7.x86_64.
# Copy /ufm-5.9.6-8.el7.x86_64/ufm-rpm-src.tar.gz file to a machine with C compiler. Open the file and run the "compile_rpm.sh -o <output dir> -m " command.
# Copy the created tar file back to /ufm-5.9.6-8.el7.x86_64 directory and run install again.

# Install RPM build dependencies.
RUN yum install -y \
    gcc \
    kernel-$kernel_version \
    kernel-devel-$kernel_version \
    kernel-headers-$kernel_version \
    kernel-modules-$kernel_version \
    make \
    rpm-build \
    && yum clean all

# Build RPMs.
ADD compile-rpms.sh /
RUN /compile-rpms.sh

# Create a tarball containing the new RPMs.
RUN tar -C / -czf /ufm-${ufm_version}.tgz ufm-${ufm_version} 
