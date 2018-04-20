=========================
Mellanox UFM Docker Image
=========================

This repository provides tooling to build a Docker image for the Mellanox UFM
Infiniband fabric manager.

The image is based on the ``centos/systemd`` image, in order to run multiple
UFM services in a single container, using the existing UFM init scripts.

Usage
=====

Compiling from Source
---------------------

If the running kernel does not match the kernel on which the UFM packages were
built, it may be necessary to rebuild the UFM packages from source. A script is
provided to rebuild the packages using a Docker container. Set the following
environment variables to configure the script:

* ``$KERNEL_VERSION``: optional kernel version to compile against
* ``$UFM_VERSION``: required UFM software version
* ``$UFM_TARBALL_URL``: required UFM tarball URL
* ``$UFM_COMPILE_IMAGE_TAG:``: optional UFM compilation image tag

Building the Image
------------------

The Dockerfile expects a tarball containing the UFM software to be available
via HTTP. The URL of this tarball should be set via ``$UFM_TARBALL_URL``.

The UFM software version should be set via ``$UFM_VERSION``.

A Mellanox OFED yum repository should be made available via HTTP and set via
``$OFED_REPO_URL``.

By default, the built image will be tagged as ``mlnx-ufm:latest``. To use a
different tag, set ``$UFM_IMAGE_TAG``.

Run the ``build.sh`` script to build a Docker image.

Running a Container from the Image
----------------------------------

By default the image tagged as ``mlnx-ufm:latest`` will be used to create the
container. To use a different image, set ``$UFM_IMAGE_NAME``.

By default, the container will be named ``mlnx_ufm``. To use a different name,
set ``$UFM_CONTAINER_NAME``.

One or more UFM licenses should be made available in a directory on the host
running docker. The path to this directory should be set via
``$UFM_LICENSES_PATH``.

It may be desirable to apply additional configuration to UFM prior to running
the ufmd service. This can be done by setting ``$UFM_STARTUP_CONFIG_PATH`` to
the path of a script.

Run the ``run.sh`` script to create a Docker container. The container will be
privileged, and use host networking.
