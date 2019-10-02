#!/bin/bash

set -e

if [[ -z $centos_version ]]; then
    exit 0
fi

cat << EOF > /etc/yum.repos.d/CentOS-Vault-${centos_version}.repo
# C$centos_version
[C$centos_version-base]
name=CentOS-$centos_version - Base
baseurl=http://vault.centos.org/$centos_version/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

[C$centos_version-updates]
name=CentOS-$centos_version - Updates
baseurl=http://vault.centos.org/$centos_version/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

[C$centos_version-extras]
name=CentOS-$centos_version - Extras
baseurl=http://vault.centos.org/$centos_version/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

[C$centos_version-centosplus]
name=CentOS-$centos_version - CentOSPlus
baseurl=http://vault.centos.org/$centos_version/centosplus/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=0

[C$centos_version-fasttrack]
name=CentOS-$centos_version - Fasttrack
baseurl=http://vault.centos.org/$centos_version/fasttrack/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=0
EOF

yum -y install yum-utils
yum-config-manager --disable base updates extras
