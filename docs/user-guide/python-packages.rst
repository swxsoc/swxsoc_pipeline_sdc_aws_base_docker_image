.. _python_packages:

Python Package Guide
====================

This guide is to let you know the basics of a Python package. As well as how to add a new Python Package to the base image.

What is a Python Package
------------------------
A Python package is a collection of Python modules. A Python module is a single Python file, which can define functions, classes and variables. A package can contain sub-packages, and sub-packages can contain sub-packages themselves. A collection of sub-packages is called a Python distribution.

How to add a Package to the Base Image
--------------------------------------
To add a new Python package to the base image, you need to add the package to the ``requirements.txt`` file. This file is used by the ``pip`` command to install the packages. The ``pip`` command is used to install Python packages from the Python Package Index and other indexes.

To Verify the Package is Installed
----------------------------------
To verify the package is installed on the image, you must first rebuilt the image with the updated ``requirements.txt`` file. Once the image is rebuilt, you can run the image and verify the package is installed.