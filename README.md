# Crypto Infra K8s

Local Kubernetes infrastructure and microservice pipeline deployment for the cryptocurrency alerting engine.

## 1. Prerequisites & Environment Setup

Always point your terminal shell to Minikube's internal Docker daemon before building images or managing resources:
```bash
eval $(minikube docker-env)

kubectl apply -f rabbitmq-statefulset.yaml

kubectl apply -f services.yaml

# Pause Applications
kubectl scale deployment crypto-alert-engine --replicas=0
kubectl scale deployment market-feeder --replicas=0

# Pause Infrastructure
kubectl scale statefulset rabbitmq --replicas=0

# Wipe Applications
kubectl delete -f /Users/edmundkirkby-bott/git/crypto-infra-k8s/services.yaml

# Wipe Specific Deployments Directly
kubectl delete deployment crypto-alert-engine
kubectl delete deployment market-feeder

# Wipe Infrastructure
kubectl delete statefulset rabbitmq

# Watch pod lifecycle state transitions live
kubectl get pods -w

# Inspect comprehensive cluster object statuses
kubectl get pods,svc,deploy,statefulset
