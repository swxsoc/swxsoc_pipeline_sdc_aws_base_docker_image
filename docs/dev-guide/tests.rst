.. _testing:

**************************************
CI/CD Pipeline and Testing Guidelines
**************************************

This section describes the testing framework and format standards for tests.
For testing of the container images, we make use of Container Structure Tests framework that allows us to test the structure of the image. The tests are written in YAML format and are executed by the framework. 

To learn more about the framework, please refer to the official documentation:
`Container Structure Tests <https://github.com/GoogleContainerTools/container-structure-test>`_


Writing tests
=============

Where to put tests
------------------

The cst_config.yaml file is where all of the CST tests are defined. The file is divided into three sections: ``schemaVersion``,  ``commandTests`` and ``fileExistenceTests``. 

Scripts that you'd like to run as part of the testing process can be placed into the ``container-tests`` directory. But to actually run the scripts you must make sure to include them in the ``commandTests`` section of the ``cst_config.yaml`` file.

schemaVersion
-------------
The ``schemaVersion`` is used to specify the version of the CST framework that is used to run the tests. We are currently using the **2.0.0** version of the framework.

commandTests
------------
The ``commandTests`` section is where the tests for the commands are defined. This is also where you can write a command to run a Python script that you've placed in the container-tests folder as well. The tests are defined in the following format::
    
        - name: "Test for command"
        command: ["command", "arg1", "arg2"]
        expectedOutput: ["expected output"]
        exitCode: 0

The name of the test is specified in the ``name`` field. The command to be tested is specified in the ``command`` field. The expected output of the command is specified in the ``expectedOutput`` field. The exit code of the command is specified in the ``exitCode`` field.

fileExistenceTests
------------------
The ``fileExistenceTests`` section is where the tests for the file existence are defined. The tests are defined in the following format::
        
            - name: "Test for file existence"
            path: "/path/to/file"
            shouldExist: true

The name of test is specified in the ``name`` field. The path to the file is specified in the ``path`` field. The ``shouldExist`` field is used to specify whether the file should exist or not. If the file should exist, then the value of the field should be ``true``. If the file should not exist, then the value of the field should be ``false``.

More options available
----------------------
The Container Structure Tests framework provides more options for testing. For more information on the options available, please refer to the official documentation:
`Container Structure Tests <https://github.com/GoogleContainerTools/container-structure-test>`_

**Note:** Feel free to update this section if more options are used in the tests in the future.


Bugs Testing
------------

In addition to writing unit tests new functionality, it is also a good practice to write a unit test each time a bug is found, and submit the unit test along with the fix for the problem.
This way we can ensure that the bug does not re-emerge at a later time.

CI/CD Pipeline
==============

The CI/CD Pipeline is used to build and test the container images. There are two different pipelines that are used, one for pull requests made and one for merges into the master branch.

Pull Request Pipeline
---------------------

The Pull Request Pipeline is used to build and test the container images when a pull request is made. The pipeline is triggered when a pull request is made to the master branch and used Github Actions. The pipeline is defined in the ``.github/workflows/container-image-testing.yml`` file. The pipeline is defined in the following format::

    name: Pull Request Pipeline

    on:
      pull_request:
        branches:
          - master

    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - name: Build and test the container image
            run: |
              make build
              make test

For this repository currently the pipeline only builds and tests the container image. But in the future, if more steps are added to the pipeline, they can be added to the ``steps`` section of the pipeline.

To learn more about Github Actions, please refer to the official documentation:
`Github Actions <https://docs.github.com/en/actions>`_

Merge Pipeline
--------------
The Merge Pipeline is used to build, test and push the container images to the `Public ECR repository <https://gallery.ecr.aws/w5r9l1c8/swsoc-docker-lambda-base>`_ when a pull request is merged into the master branch. This Pipeline uses AWS Codebuild. The pipeline is defined in the ``buildspec.yml`` file. The pipeline is defined in the following format::

    version: 0.2

    phases:

      pre_build:
        commands:
          - echo Prebuild Section...
          - aws --version

      build:
        commands:
          - echo Build started on `date`
          - echo Building the Docker image...

      post_build:
        commands:
          - echo Build completed on `date`
          - echo Pushing the Docker image...

For this repository currently the pipeline only builds, tests and pushes the container image to ECR. But in the future, if more steps are added to the pipeline, they can be added to the ``build`` section of the pipeline.

To learn more about AWS Codebuild, please refer to the official documentation:
`AWS Codebuild <https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html>`_

Diagram of Full CI/CD Pipeline
------------------------------
.. graphviz::

   digraph CI_CD_Pipeline {
   
      a  [ label="Pull Request opened", color=blue, style=filled, fillcolor=lightblue];
      a -> b [label="Triggers PR CI/CD Pipeline"];
      b  [shape=polygon,sides=4, label="Start Pull Request Pipeline (Github Actions)",];
        b -> c [label="Triggers container image testing"];
        c  [shape=polygon,sides=4, label="Builds and tests container image",];
          c  [shape=polygon,sides=6]
        b -> d [label="Triggers automated documentation testing"];
        d  [shape=polygon,sides=4, label="Builds and tests container image",];
          d  [shape=polygon,sides=6]
            c -> e [label="Passes", color=darkgreen];
            d -> e [label="Passes", color=darkgreen];
                e  [ label="Passes all CI/CD Tests", color=green, style=filled, fillcolor=lightgreen];
                e->f [];
                f  [ label="Pull Request approved and merged", color=blue, style=filled, fillcolor=lightblue];
                f -> b2 [label="Triggers Merge CI/CD Pipeline"];
            c -> g [label="Fails", color=darkred];
            d -> g [label="Fails", color=darkred];
                g  [ label="Fails any CI/CD Tests", color=red, style=filled, fillcolor=red];
                g -> b [label="Push changes and re-run CI/CD Pipeline"];

      b2  [shape=polygon,sides=4, label="Start Merge Pipeline (AWS Codebuild)",];
        b2 -> c2 [label="Triggers container image testing"];
        c2  [shape=polygon,sides=4, label="Builds and tests container image",];
          c2  [shape=polygon,sides=6]
        b2 -> d2 [label="Triggers automated documentation testing"];
        d2  [shape=polygon,sides=4, label="Builds and tests container image",];
          d2  [shape=polygon,sides=6]
            c2 -> e2 [label="Passes", color=darkgreen];
            d2 -> e2 [label="Passes", color=darkgreen];
                e2  [ label="Passes all CI/CD Tests", color=green, style=filled, fillcolor=lightgreen];
                e2->f2 [label="Pushes container image to ECR"];
                f2  [shape=polygon,sides=4,  label="ECR Public Repo"];
            c2 -> g2 [label="Fails", color=darkred];
            d2 -> g2 [label="Fails", color=darkred];
                g2  [ label="Fails any CI/CD Tests", color=red, style=filled, fillcolor=red];
                g2 -> a [label="Open new PR and make changes and re-run CI/CD Pipeline"];
      }

**Note:** The Merge Pipeline can also be started manually via Codebuild

Manually initiating the CI/CD Pipeline
--------------------------------------
It is possible to manually initiate the Merge CI/CD Pipeline with the latest changes in the master branch. This can be done by going to the `AWS Codebuild console <https://console.aws.amazon.com/codebuild/home?region=us-east-2#/projects/build_sdc_aws_base_docker_image>`_ and clicking on the ``Start build`` button. This will start the pipeline with the latest changes in the master branch. 