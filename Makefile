CHART_NAME ?= rcm
STABLE_CHART ?= stable/$(CHART_NAME)
ARTIFACTORY_URL ?= https://na.artifactory.swg-devops.com/artifactory
ARTIFACTORY_REPO ?= hyc-cloud-private-integration-helm-local
STABLE_BUILD_DIR = repo/stable
GITHUB_USER    := $(shell echo $(GITHUB_USER) | sed 's/@/%40/g')
GITHUB_TOKEN   ?=

SHELL := /bin/bash

# GITHUB_USER containing '@' char must be escaped with '%40'
GITHUB_USER := $(shell echo $(GITHUB_USER) | sed 's/@/%40/g')
GITHUB_TOKEN ?=

# Bootstrap (pull) the build harness
ifdef GITHUB_TOKEN
-include $(shell curl -H 'Authorization: token ${GITHUB_TOKEN}' -H 'Accept: application/vnd.github.v4.raw' -L https://api.github.com/repos/open-cluster-management/build-harness-extensions/contents/templates/Makefile.build-harness-bootstrap -o .build-harness-bootstrap; echo .build-harness-bootstrap)
endif

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
	#curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
	curl -fksSL https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz | sudo tar --strip-components=1 -xvz -C /usr/local/bin/ linux-amd64/helm
