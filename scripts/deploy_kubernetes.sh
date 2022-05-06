#!/bin/bash

set -euo pipefail

install_dependent_helm_chart() {
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo add jetstack https://charts.jetstack.io
  helm repo add external-dns https://kubernetes-sigs.github.io/external-dns
  helm repo update
}

deploy_ingress_nginx() {
  printf "\nInstalling/ upgrading NGINX Ingress chart\n\n"
  helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx
}

deploy_cert_manager() {
  printf "\nInstalling/ upgrading cert-manager chart\n\n"
  helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.0 \
  --set installCRDs=true
}

deploy_external_dns() {
  printf "\nInstalling/ upgrading external DNS chart\n\n"
  helm upgrade --install godaddy-external-dns external-dns/external-dns \
  --set provider=godaddy \
  --set godaddy-api-name=wanielnetes \
  --set godaddy-api-key=$PROD_GODADDY_API_KEY \
  --set godaddy-api-secret=$PROD_GODADDY_API_SECRET \
  --set source=ingress \
  --set domain-filter=$GODADDY_DOMAIN 
}

deploy_wanielnetes_chart() {
  printf "\nInstalling/ upgrading wanielnetes helmchart"
  helm upgrade --install wanielnetes --namespace production --create-namespace ./wanielnetes --set \
  --set email=$EMAIL_ADDRESS \
  --set godaddyApiKey=$PROD_GODADDY_API_KEY \
  --set godaddyApiSecret=$PROD_GODADDY_API_SECRET \
  --set godaddyDomain=$GODADDY_DOMAIN
}

main(){
  install_dependent_helm_chart
  deploy_ingress_nginx
  deploy_cert_manager
  deploy_external_dns

  # Display all Pods
  printf "\nList of Pods:\n\n"
  kubectl get pods --namespace default
}

main
