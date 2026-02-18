.. _coding_standards:

****************
Coding Standards
****************

The purpose of the page is to describe the standards that are expected of all the code in this repository.
All developers should read and abide by the following standards.
Code which does not follow these standards closely will generally not be accepted.

For the base Dockerfile we try to follow the best practice conventions proposed by the official Docker documentation. `Docker Best Practices <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>`_

We also try to closely follow the Python Script coding style and conventions proposed by `Astropy <https://docs.astropy.org/en/stable/development/codeguide.html#coding-style-conventions>`_.

Language Standard
=================

* All code must be compatible with Python 3.7 and later.

* The new Python 3 formatting style should be used (i.e.
  ``"{0:s}".format("spam")`` instead of ``"%s" % "spam"``).

Coding Style/Conventions
========================

* The Dockerfile will follow best practices outlined in the `Dockerfile Best Practices <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>`_.

* Python script code will follow the standard `PEP8 Style Guide for Python Code <https://www.python.org/dev/peps/pep-0008/>`_.
  In particular, this includes using only 4 spaces for indentation, and never tabs.

* **Follow the existing coding style** within a file and avoid making changes that are purely stylistic.
  Please try to maintain the style when adding or modifying code.

* When writing Python code, following PEP8's recommendation, absolute imports are to be used in general.
  We allow relative imports within a module to avoid circular import chains.

* The ``import numpy as np``, ``import matplotlib as mpl``, and ``import matplotlib.pyplot as plt`` naming conventions should be used wherever relevant.
  ``from packagename import *`` should never be used (except in ``__init__.py``)

* Classes should either use direct variable access, or Python's property mechanism for setting object instance variables.

* Classes should use the builtin `super` function when making calls to methods in their super-class(es) unless there are specific reasons not to.
  `super` should be used consistently in all subclasses since it does not work otherwise.

* Multiple inheritance should be avoided in general without good reason.

* ``__init__.py`` files for modules should not contain any significant implementation code. ``__init__.py`` can contain docstrings and code for organizing the module layout.

Testing
=======

Automate
--------

There is some linting and testing automation that occurs during the CI/CD Pipeline to ensure that the code is up to standard and doesn't break any of existing functionality. 

By Hand
-------

To run CST tests locally ensure you have the Container Structure Tests installed and available on your path. Then run the following command from the root of the repository::

    $ container-structure-test test --image swsoc-docker-lambda-base:latest --config cst_config.yaml

**To learn more about testing on this repository:** :ref:`testing`

Documentation
=========================

* American English is the default language for all documentation strings and inline commands.
  Variables names should also be based on English words.

* Dockerfiles should be properly commented to explain the purpose of each line.

* Documentation strings must be present for all public classes/methods/functions in Python scripts, and must follow the form outlined in the :ref:`docs_guidelines` page.
  Additionally, examples or tutorials in the package documentation are strongly recommended.

**To learn more about documentation on this repository:** :ref:`docs_guidelines`