# swxsoc_pipeline_sdc_aws_base_docker_image
Base Image used for `swxsoc_pipeline` missions 

### **Description**:
This repository is to define the image to be used for the development environments (vscode `.devcontainers`) as well as the base container for the lambda functions. It includes all needed packages for development.

This container is built and pushed to the public repo ECR automatically by AWS Codebuild.

### **Base Image**: Ubuntu 24.04 ([public.ecr.aws/lts/ubuntu:24.04_stable](https://gallery.ecr.aws/lts/ubuntu))

### **ECR Repo:** Docker Lambda Base Image ([public.ecr.aws/w5r9l1c8/dev-swxsoc-pipeline-docker-lambda-base:latest](https://gallery.ecr.aws/w5r9l1c8/dev-swxsoc-pipeline-docker-lambda-base))

### **Deployment contract**

CodeBuild publishes only an exact current `main` commit or a release tag.
Pull requests, stale commits, and other branches finish without publishing or
starting downstream builds. Development is the default; a release tag or
`CDK_ENVIRONMENT=PRODUCTION` selects the production repository.

Each build pushes a versioned image as well as the convenience `latest` alias.
The versioned public ECR URI is passed to Sorting, Processing, and Artifacts
using `PUBLIC_ECR_REPO`, together with the normalized `CDK_ENVIRONMENT`.
Downstream Lambda projects are always started from their `main` branch and
validate both values before building, preventing a production/dev crossover or
a stale Lambda source deployment.
The base repository's commit SHA is intentionally not passed as a downstream
source version because it does not exist in the Lambda repositories; each
Lambda build fetches and confirms its resolved SHA equals its own current
`origin/main` before publishing.

| Build source | Result |
| --- | --- |
| Current `main` | Publish the development base image and fan out development Lambda builds from exact Lambda `main` |
| Release tag | Publish the production base image and fan out production Lambda builds from exact Lambda `main` |
| Current `main` with `CDK_ENVIRONMENT=PRODUCTION` | Publish a versioned production rebuild and fan out production Lambda builds |
| Pull request, non-main branch, or stale commit | Skip publishing and downstream builds |

The fan-out sends one CodeBuild override list containing
`CDK_ENVIRONMENT` and the versioned `PUBLIC_ECR_REPO`; it never hands a
downstream build the mutable `latest` alias.

## Included OS Packages
- git
- wget
- unzip
- python3.12
- python3-pip
- pylint

## Included Python Packages
- swxsoc (For instrument packages)
- awslambdaric (For use with interfacing with AWS Lambda)

### **Tests:**
Checks whether the container contains the specified OS and Python requirements using the Container Structure Test ([CST testing suite](https://github.com/GoogleContainerTools/container-structure-test)). 

### **How to Contribute:**
To make a change to this container image, please `fork` this repo, make the requested change and create a `Pull Request` with the change. The PR will trigger a first set of tests to ensure your changes don't break anything in the environment. It will then require two formal reviews/approvals by the project admins. Once it's been approved it can then be **Squashed and Merged** into the main branch of the repo. The CI/CD pipeline from this point will re-run tests and push the image to ECR. After the image has been successfully pushed you can then rebuilt your container in your development environment or you can manually pull the image start to use it.

### **Development Environment Troubleshooting:**
If you experience any issues in your development environment (`.devcontainer` environment on VSCode) when pulling this image from ECR, ensure you have the latest build by rebuilding your container to pull from latest.

## Dockerfile Details
This Docker image is built from the official Canonical Ubuntu 24.04 image. It updates the system and installs necessary packages such as git, unzip, python3.12, python3-pip, and pylint. 

This Dockerfile also includes a process to download pre-built CDF binaries for data format support and copies a Python requirements.txt file into the image to be used for installing Python dependencies. 

Furthermore, it contains a test script to check if the container includes the specified OS and Python requirements using the Container Structure Test. 

The Dockerfile finally creates a user 'vscode' with sudo support to run the container.
