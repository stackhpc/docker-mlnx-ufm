#!/bin/bash

set -e

ufm_image_name=${UFM_IMAGE_NAME:-mlnx-ufm}
ufm_container_name=${UFM_CONTAINER_NAME:-mlnx_ufm}
ufm_licenses_path=${UFM_LICENSES_PATH:?Set the path to the UFM licenses via \$UFM_LICENSES_PATH}
ufm_startup_config_path=${UFM_STARTUP_CONFIG_PATH:-}

if [[ ! -d $ufm_licenses_path ]]; then
    echo "License directory $ufm_licenses_path does not exist"
    exit 1
fi

extra_volumes=""
if [[ -n $ufm_startup_config_path ]] then
   extra_volumes=" -v $ufm_startup_config_path:/usr/bin/mlnx-ufm-configure"
fi

docker run \
    --detach \
    --name mlnx_ufm \
    --network=host \
    --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v $ufm_licenses_path:/opt/ufm/files/licenses/:ro \
    $extra_volumes \
    $ufm_image_name
