REPO := $(CURDIR)
HELPER_MAKEFILES := $(REPO)/.makefiles

#git
GIT_USER_NAME = changeme
GIT_USER_EMAIL = changeme

#k8s
PROD_CLUSTER_NAME := 
PROD_RESOURCE_GROUP := 
PROD_SUBSCRIPTION_ID := 
DEV_CLUSTER_NAME := 
DEV_RESOURCE_GROUP := 
DEV_SUBSCRIPTION_ID := 

define print_help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort
endef

.PHONY: help
help: ## Display this help
	@echo
	@echo "Usage: make [target]"
	@echo
	@echo "Possible targets:"
	$(call print_help)


# Makefile includes
include $(HELPER_MAKEFILES)/k8s.mk
include $(HELPER_MAKEFILES)/git.mk
include $(HELPER_MAKEFILES)/pwsh.mk
include $(HELPER_MAKEFILES)/bicep.mk