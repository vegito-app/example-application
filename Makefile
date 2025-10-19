VEGITO_PROJECT_NAME := example-application
LOCAL_DIR := $(CURDIR)/local
GIT_HEAD_VERSION ?= $(shell git describe --tags --abbrev=7 --match "v*" 2>/dev/null)

EXAMPLE_APPLICATION_VERSION ?= $(GIT_HEAD_VERSION)
ifeq ($(EXAMPLE_APPLICATION_VERSION),)
EXAMPLE_APPLICATION_VERSION := latest
endif

VERSION ?= $(EXAMPLE_APPLICATION_VERSION)

export

INFRA_PROJECT_NAME := moov

DEV_GOOGLE_CLOUD_PROJECT_ID := moov-dev-439608

LOCAL_ROBOTFRAMEWORK_TESTS_DIR := $(LOCAL_DIR)/robotframework

LOCAL_DOCKER_BUILDX_BAKE = docker buildx bake \
	-f $(LOCAL_DIR)/docker/docker-bake.hcl \
	-f $(LOCAL_DIR)/docker-bake.hcl \
	$(LOCAL_DOCKER_BUILDX_BAKE_IMAGES:%=-f $(LOCAL_DIR)/%/docker-bake.hcl) \
	-f $(LOCAL_ANDROID_DIR)/docker-bake.hcl \
	$(LOCAL_ANDROID_DOCKER_BUILDX_BAKE_IMAGES:%=-f $(LOCAL_ANDROID_DIR)/%/docker-bake.hcl) \
	-f $(CURDIR)/docker-bake.hcl \
	$(VEGITO_EXAMPLE_APPLICATION_DOCKER_BUILDX_BAKE_IMAGES:%=-f $(VEGITO_EXAMPLE_APPLICATION_DIR)/%/docker-bake.hcl) \
	-f $(LOCAL_DIR)/github-actions/docker-bake.hcl

LOCAL_DOCKER_COMPOSE = docker compose \
    -f $(CURDIR)/docker-compose.yml \
    -f $(LOCAL_DIR)/docker-compose.yml \
    -f $(CURDIR)/.docker-compose-services-override.yml \
    -f $(CURDIR)/.docker-compose-networks-override.yml \
    -f $(CURDIR)/.docker-compose-gpu-override.yml

LOCAL_ANDROID_DOCKER_COMPOSE_SERVICES = \
  studio

-include example-application.mk
-include nodejs.mk
-include go.mk
-include git.mk

node-modules: local-node-modules
.PHONY: node-modules

images: example-application-docker-images
.PHONY: images

images-ci: example-application-docker-images-ci
.PHONY: images-ci

images-pull: local-docker-images-pull-parallel example-application-local-docker-images-pull-parallel
.PHONY: images-pull

images-push: local-docker-images-push example-applicationdocker-images-push
.PHONY: images-push

dev: local-containers-up local-android-containers-up example-application-containers-up
.PHONY: dev

dev-rm: example-application-containers-rm local-containers-rm local-android-containers-rm
.PHONY: dev-rm

dev-ci: images-pull local-containers-up-ci example-application-containers-up-ci
	@echo "🟢 Development environment is up and running in CI mode."
.PHONY: dev-ci

dev-ci-rm: local-dev-container-image-pull local-containers-rm-ci example-application-containers-rm-ci
.PHONY: dev-ci-rm

logs: local-dev-container-logs-f
.PHONY: logs

tests: local-robotframework-tests-container-run
	@echo "Tests completed successfully."
.PHONY: tests
