.. _dev_env:

Developer Environment
=====================

Understanding the Basics
------------------------

**Before you begin setting up your development environment and contributing, you should have a basic understanding of the following:**

* **Git** - Git is a version control system that allows you to track changes to files and collaborate with other developers. `You can read more about Git here  <https://git-scm.com/docs/gittutorial>`_.

* **Docker** - Docker is a platform for developers and sysadmins to develop, deploy, and run applications with containers. The use of Linux containers to deploy applications is called containerization. Containers are not new, but their use for easily deploying applications is. You build Docker images using a Dockerfile, this is what is currently being version controlled in this repository. `You can read more about Dockerfiles here <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>`_.


* **CI/CD Pipelines** - CI/CD Pipelines automate the process of building, testing, and deploying code. CI/CD Pipelines are a critical part of the software development lifecycle. They allow you to rapidly and reliably deliver applications to your users. This repository contains a CI/CD Pipeline that is used to build and deploy the Dockerfile to a public ECR repo. `You can read more about how CI/CD Pipelines work here <https://docs.aws.amazon.com/whitepapers/latest/practicing-continuous-integration-continuous-delivery/what-is-continuous-integration-and-continuous-deliverydeployment.html>`_.


* **AWS ECR Image Repository** - An ECR Image Repository is a private Docker registry that is hosted on AWS. This repository contains the Dockerfile that is used to build the Docker image and the CI/CD Pipeline pushes the built image to the repository once it's completes it's tests. `You can read more about ECR Image Repositories here <https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html>`_.

Setting Up Your Development Environment
---------------------------------------
**This section will walk you through setting up your development environment to be able to contribute to this repository.**

1. **Install Git** - You can install Git on your local machine by following the instructions here: `Link to Install Git <https://git-scm.com/book/en/v2/Getting-Started-Installing-Git>`_

2. **Install Docker** - You can install Docker on your local machine by following the instructions here: `Link to Install Docker <https://docs.docker.com/get-docker/>`_

3. **Install VSCode** - You can install VSCode on your local machine by following the instructions here: `Link to Install VSCode <https://code.visualstudio.com/download>`_

4. **Clone the Repository** - You can clone the repository by running the following command in your terminal: ``git clone https://github.com/HERMES-SOC/sdc_aws_base_docker_image.git``

5. **Open the Repository in VSCode** - Once cloned you can open the repository in VSCode by running the following command in your terminal: ``code sdc_aws_base_docker_image``

6. **Build the Docker Image** - You can build the Docker image to test the changes you've made to the set-up by running the following command in your terminal within the sdc_aws_base_docker_image: ``docker build -t sdc_aws_base_docker_image .``

Once you've completed the above steps you should be able to make changes to the Dockerfile and test them locally. You can also run the Docker image locally by running the following command in your terminal: ``docker run -it sdc_aws_base_docker_image``


**Next Steps:**
Now you are ready to me a maintainer! Follow these steps to learn more about the maintainer workflow: :ref:`maintainer_workflow`
