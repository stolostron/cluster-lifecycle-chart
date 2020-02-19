CHART_NAME ?= rcm
STABLE_CHART ?= stable/$(CHART_NAME)
ARTIFACTORY_URL ?= https://na.artifactory.swg-devops.com/artifactory
ARTIFACTORY_REPO ?= hyc-cloud-private-integration-helm-local
STABLE_BUILD_DIR = repo/stable
GITHUB_USER    := $(shell echo $(GITHUB_USER) | sed 's/@/%40/g')
GITHUB_TOKEN   ?=

SHELL := /bin/bash

-include $(shell curl -fso .build-harness -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3.raw" "https://raw.github.ibm.com/ICP-DevOps/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)

VERSION ?= ${SEMVERSION}
CHART_FILE ?= $(CHART_NAME)-$(VERSION).tgz

.PHONY: build lint setup build archive copyright-check

default: build

.PHONY: init\:
init::
	@mkdir -p variables
ifndef GITHUB_USER
	$(info GITHUB_USER not defined)
	exit -1
endif
	$(info Using GITHUB_USER=$(GITHUB_USER))
ifndef GITHUB_TOKEN
	$(info GITHUB_TOKEN not defined)
	exit -1
endif

CHART_VERSION := $(SEMVERSION)
CHART_NAME ?= kui-web-terminal


setup:
	helm init -c

lint: setup
	helm lint $(STABLE_CHART)

.PHONY: build
## Packages helm-api folder into chart archive
build: lint
	mkdir -p repo/stable
	@echo "BUILD CHART_NAME: $(CHART_NAME)"
	@echo "BUILD CHART_VERSION: 99.99.99"
	helm package --version 99.99.99 $(STABLE_CHART) -d $(STABLE_BUILD_DIR)

.PHONY: build
## Pushes chart to Artifactory repository.
release-chart:
	$(eval VERSION_NUMBER ?= ${VERSION})
	$(eval NAME := $(notdir $(CHART_NAME)))
	$(eval FILE_NAME := $(NAME)-$(VERSION_NUMBER).tgz)
	$(eval URL := $(ARTIFACTORY_URL)/$(ARTIFACTORY_REPO))
	curl -H "X-JFrog-Art-Api: $(ARTIFACTORY_APIKEY)" -T $(STABLE_BUILD_DIR)/$(FILE_NAME) $(URL)/$(FILE_NAME)


.PHONY: tool
## Download helm for linting and packaging
tool:
	curl -fksSL https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz | sudo tar --strip-components=1 -xvz -C /usr/local/bin/ linux-amd64/helm
