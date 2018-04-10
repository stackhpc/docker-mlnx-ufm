#!/bin/bash

set -e

ufm_path=/ufm-${ufm_version}

# Extract source RPM tarball.
mkdir /ufm-rpm-src
tar -C /ufm-rpm-src -zxf $ufm_path/ufm-rpm-src.tar.gz

# Build source RPMs.
mkdir /ufm-rpm
cd /ufm-rpm-src
if ! ./compile_rpm.sh -o /ufm-rpm -m ; then
    cat compile_rpm_*.log
    exit 1
fi

# Extract built RPMs.
kernel_version_dedashed=$(echo $kernel_version | sed 's/-/_/g')
rpm_tarball=/ufm-rpm/${kernel_version_dedashed}_rpms.tar.gz
cp $rpm_tarball $ufm_path
tar -C $ufm_path -xzf $rpm_tarball

# Clean up
cd /
rm -r /ufm-rpm /ufm-rpm-src
