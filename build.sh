#!/bin/bash

# Build an image containing the Mellanox UFM software stack.

set -e

dir=$(dirname ${BASH_SOURCE[0]})

ufm_version=${UFM_VERSION:?Set the UFM version via \$UFM_VERSION}
ufm_tarball_url=${UFM_TARBALL_URL:?Set the UFM software tarball URL via \$UFM_TARBALL_URL}
ofed_repo_url=${OFED_REPO_URL:?Set the OFED repo URL via \$OFED_REPO_URL}
ufm_image_tag=${UFM_IMAGE_TAG:-mlnx-ufm}

cd $dir

# Rebuild the UFM source.
docker build \
  -t $ufm_image_tag \
  --build-arg ufm_version=$ufm_version \
  --build-arg ufm_tarball_url=$ufm_tarball_url \
  --build-arg ofed_repo_url=$ofed_repo_url \
  .
