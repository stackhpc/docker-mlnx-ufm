#!/bin/bash

# Build UFM RPMs from source.

set -e

dir=$(dirname ${BASH_SOURCE[0]})

# Compile UFM RPMs for the running kernel.
kernel_version=${KERNEL_VERSION:-$(uname -r)}
ufm_version=${UFM_VERSION:?Set the UFM software version via \$UFM_VERSION. Example: 5.9.6-8.el7.x86_64}
ufm_tarball_url=${UFM_TARBALL_URL:?Set the UFM tarball URL via \$UFM_TARBALL_URL}
ufm_compile_image_tag=${UFM_COMPILE_IMAGE_TAG:-mlnx-ufm-compile}

cd $dir

# Rebuild the UFM source.
docker build \
  -t $ufm_compile_image_tag \
  --build-arg kernel_version=$kernel_version \
  --build-arg ufm_version=$ufm_version \
  --build-arg ufm_tarball_url=$ufm_tarball_url \
  .

# Copy out the tarball from the image.
docker run \
    --rm \
    -v $(pwd):/pwd \
    $ufm_compile_image_tag \
    bash -c "cp /ufm-${ufm_version}.tgz /pwd"

echo UFM tarball is at $(pwd)/ufm-${ufm_version}.tgz
