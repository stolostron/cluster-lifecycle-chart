# Copyright Contributors to the Open Cluster Management project

CHART_NAME ?= cluster-lifecycle
STABLE_CHART ?= stable/$(CHART_NAME)

SHELL := /bin/bash

VERSION ?= ${SEMVERSION}
CHART_FILE ?= $(CHART_NAME)-$(VERSION).tgz

.PHONY: build lint 

CHART_VERSION := $(SEMVERSION)

lint:
	helm lint $(STABLE_CHART)

.PHONY: build
## Packages helm-api folder into chart archive
build: lint
	mkdir -p repo/stable
	@echo "BUILD CHART_NAME: $(CHART_NAME)"
	@echo "BUILD CHART_VERSION: 99.99.99"
	helm package --version 99.99.99 $(STABLE_CHART) -d $(STABLE_BUILD_DIR)


.PHONY: tool
## Download helm for linting and packaging
tool:
	#curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
	curl -fksSL https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz | sudo tar --strip-components=1 -xvz -C /usr/local/bin/ linux-amd64/helm
