# Crypto Infra K8s

Local Kubernetes infrastructure and microservice pipeline deployment for the cryptocurrency alerting engine.

## 1. Prerequisites & Environment Setup

Always point your terminal shell to Minikube's internal Docker daemon before building images or managing resources:
```bash
eval $(minikube docker-env)

kubectl apply -f https://raw.githubusercontent.com/edmundkb/crypto-infra-k8s/main/manifests/argocd-app.yaml
