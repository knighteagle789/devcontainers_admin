.PHONY: az-login
az-login: ## Login to Azure
	@if az account show > /dev/null 2>&1; then \
		echo "Already logged into Azure."; \
	else \
		az login --use-device-code; \
	fi

.PHONY: prod-az-subscription
prod-az-subscription:
	az account set --subscription 1ab09d86-1d66-4aa4-ae4b-ea0188962c24

.PHONY: dev-az-subscription
dev-az-subscription:
	az account set --subscription 6adc60b9-ad64-4f70-ab19-613894d1888f

.PHONY: k8-prod-login
k8-prod-login: 
	make az-login 
	make prod-az-subscription ## logs into the k8s cluster
	az aks get-credentials --resource-group $(PROD_RESOURCE_GROUP) --name $(PROD_CLUSTER_NAME) --overwrite-existing
	make kubelogin

.PHONY: k8-dev-login
k8-dev-login: 
	make az-login 
	make dev-az-subscription ## logs into the k8s cluster
	az aks get-credentials --resource-group $(DEV_RESOURCE_GROUP) --name $(DEV_CLUSTER_NAME) --overwrite-existing
	make kubelogin

.PHONY: kubelogin
kubelogin: 
	make install-kubelogin ## kubelogin for az
	kubelogin convert-kubeconfig -l azurecli

.PHONY: install-kubelogin
install-kubelogin: ## install-homebrew ## installs the kubelogin CLI
	@if ! command -v kubelogin >/dev/null; then \
		echo "kubelogin not found, installing using Homebrew..."; \
		brew install Azure/kubelogin/kubelogin; \
	else \
		echo "kubelogin is already installed."; \
	fi

.PHONY: k9s-prod
k9s-prod: k8-prod-login ## opens k9s in the prod environment
	k9s

.PHONY: k9s-dev
k9s-dev: k8-dev-login ## opens k9s in the prod environment
	k9s