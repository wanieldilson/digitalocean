-include .env
export

build-cluster:
	terraform apply --auto-approve
set-kubeconfig:
	doctl kubernetes cluster kubeconfig save wanielnetes
deploy-kubernetes:
	./scripts/deploy_kubernetes.sh





.PHONY: set-kubeconfig