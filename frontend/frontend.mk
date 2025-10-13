REACT_APP_VERSION = $(VERSION)

FRONTEND_BUILD_DIR = $(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend/build

example-application-frontend-build:$(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend/node_modules
	@cd $(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend && npm --loglevel=verbose run build
.PHONY: example-application-frontend-build

$(FRONTEND_BUILD_DIR): example-application-frontend-build

UI_JAVASCRIPT_SOURCE_FILE = $(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend/build/bundle.js

example-application-frontend-bundle: 
	@cd $(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend && npm run dev:server
.PHONY: example-application-frontend-bundle

$(UI_JAVASCRIPT_SOURCE_FILE): example-application-frontend-bundle

example-application-frontend-start:
	@cd $(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend && npm start
.PHONY: example-application-frontend-start

example-application-frontend-npm-ci:
	@cd $(VEGITO_EXAMPLE_APPLICATION_DIR)/frontend && npm ci
.PHONY: example-application-frontend-npm-ci