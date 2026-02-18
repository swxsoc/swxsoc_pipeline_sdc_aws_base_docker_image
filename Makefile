# Make file for the sphinx documentation and docker image
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = docs
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Build the docker image for the base image
docker-build:
	docker build -t docker-base -f Dockerfile .

# Run the docker image for the base image as vscode user
docker-run:
	docker run -it --rm -v $(PWD):/home/vscode/workspace -u vscode docker-base

# Run as root
docker-run-root:
	docker run -d --rm -v $(PWD):/home/vscode/workspace docker-base
	docker exec -it $(shell docker ps -q) bash

# Clean up the docker image for the base image
docker-clean:
	docker rmi docker-base

# Install Container Structure Testing
cst-install:
	curl -LO https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64 && chmod +x container-structure-test-linux-amd64 && sudo mv container-structure-test-linux-amd64 /usr/local/bin/container-structure-test

# Run CST Container tests
cst-test:
	make docker-build
	container-structure-test test --image docker-base --config cst_config.yaml