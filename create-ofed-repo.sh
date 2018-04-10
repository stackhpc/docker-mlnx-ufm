#!/bin/bash

cat << EOF > /etc/yum.repos.d/mlnx-ofed.repo
[MLNX-OFED]
name=MLNX-OFED
type=rpm-md
baseurl=${ofed_repo_url}/RPMS
gpgcheck=1
gpgkey=${ofed_repo_url}/RPM-GPG-KEY-Mellanox
enabled=1
EOF
