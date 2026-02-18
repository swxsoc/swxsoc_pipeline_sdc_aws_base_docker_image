.. _changing_docker_file:

Dockerfile Guide
============================

This guide will walk you through the process of making changes to the
Dockerfile and rebuilding the image.

What is Docker
--------------
Docker is a tool that allows you to create, deploy, and run applications
by using containers. Containers allow a developer to package up an
application with all of the parts it needs, such as libraries and other
dependencies, and ship it all out as one package. By doing so, thanks to
the container, you can rest assured that the application will run on any
other Linux machine regardless of any customized settings that machine
might have that could differ from the machine used for writing and
testing the code. More information about Docker can be found at
https://www.docker.com/what-docker.

What is a Dockerfile
--------------------

A Dockerfile is a text document that contains all the commands a user could call
on the command line to assemble an image. Using docker build users can create an
automated build that executes several command-line instructions in succession.

Structure of a Dockerfile
-------------------------

Here is an example of a Dockerfile::

    # Image: Ubuntu 20.04 Stable, Official Image from Canonical
    FROM public.ecr.aws/lts/ubuntu:20.04_stable

    # Performs updates and installs git, make, curl, python3.8, python3-pip, python3.8-dev and pylint packages
    # Line 13 is required by the spacepy Python package
    # Line >=14 installs cdflib
    RUN apt-get update && \
        apt-get -y upgrade && \
        apt-get -y install --no-install-recommends -y python3.8 python3-pip python3.8-apt python3.8-distutils python3.8-dev pylint && \
        apt-get -y install git && \
        apt-get -y install make && \
        apt-get -y install curl && \
        apt-get -y install wget && \
        apt-get -y install gfortran && \
        wget https://spdf.gsfc.nasa.gov/pub/software/cdf/dist/cdf38_0/cdf38_0-dist-cdf.tar.gz && \
        tar zxvpf cdf38_0-dist-cdf.tar.gz && rm cdf38_0-dist-cdf.tar.gz && \
        apt-get -y install libncurses5-dev && \
        apt-get -y install gcc && \
        cd cdf38_0-dist && \
        make OS=linux ENV=gnu all && \
        make INSTALLDIR=/usr/local/cdf install && \
        cd ..

    # add cdf binaries to the path
    ENV PATH="${PATH}:/usr/local/cdf/bin"

    # Copy Python requirements.txt file into image (list of common dependencies)
    COPY requirements.txt  .

    # Copy test scripts
    COPY /container-tests  /container-tests

    # To fix spacepy dependency issue
    RUN  pip3 install --upgrade --force-reinstall setuptools==59.5.0

    # Install Python dependencies defined in requirements
    RUN  pip3 install -r requirements.txt --no-cache-dir

Common Docker Commands
----------------------

**Here are some common Docker commands you might need to use when working and 
making changes to the Dockerfile:**

* **FROM** - The FROM instruction initializes a new build stage and sets the Base Image for subsequent instructions. As such, a valid Dockerfile must have FROM as its first instruction. The image can be any valid image – it is especially easy to start by pulling an image from the Public Docker Hub Registry.

* **RUN** - The RUN instruction will execute any commands in a new layer on top of the current image and commit the results. The committed image will be used for the next step in the Dockerfile.

* **COPY** - The COPY instruction copies new files or directories from ``<src>`` and adds them to the filesystem of the container at the path ``<dest>``.

* **ENV** - The ENV instruction sets the environment variable ``<key>`` to the value ``<value>``. This value will be in the environment for all subsequent RUN, CMD, ENTRYPOINT, and COPY instructions in the Dockerfile.

* **WORKDIR** - The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile. If the WORKDIR doesn’t exist, it will be created even if it’s not used in any subsequent Dockerfile instruction.

* **CMD** - The main purpose of a CMD is to provide defaults for an executing container. These defaults can include an executable, or they can omit the executable, in which case you must specify an ENTRYPOINT instruction as well.

* **ENTRYPOINT** - An ENTRYPOINT allows you to configure a container that will run as an executable. The main purpose of a ENTRYPOINT is to ensure that the container will run as an executable.

Tips When Making Changes
------------------------

Order Matters
+++++++++++++
Order matters in a Dockerfile. If you change the order of the commands in the Dockerfile, you will need to rebuild the image. For example, if you change the order of the RUN commands, you will need to rebuild the image.

Rebuilding the Image
++++++++++++++++++++
Make sure to rebuild the image after making changes to the Dockerfile. To rebuild the image, run the following command from the root directory of the repository::

    docker build -t <image_name> .

Add Container Tests
+++++++++++++++++++
Make sure to add and write tests to prevent from future contributers from breaking the Dockerfile. To learn more about container tests as well as how they are run within the CI/CD Pipeline, see :ref:`testing`.

Add Python Packages via the requirements
++++++++++++++++++++++++++++++++++++++++
When adding Python packages, make use of the ``requirements.txt`` file that is located in the root of this directory. To learn more about python packages check out :ref:`python_packages`.
