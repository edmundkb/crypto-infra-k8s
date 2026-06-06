#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting local crypto pipeline deployment..."

# 1. Point terminal to Minikube's internal Docker daemon
echo "Connecting to Minikube Docker environment..."
eval $(minikube docker-env)

# 2. Apply core infrastructure manifests (Database, Broker, and Services)
echo "Applying Kubernetes manifests..."
cd manifests/
kubectl apply -f services.yaml
kubectl apply -f rabbitmq.yaml
kubectl apply -f postgres-infra.yaml
cd ..

echo "Building updated application images..."
echo "-> Building market-feeder..."
docker build -t market-feeder:latest ../crypto-market-feeder

echo "-> Building crypto-alert-engine..."
docker build -t crypto-alert-engine:latest ../crypto-alert-engine

# 4. Restart the application pods to pick up the fresh images instantly
echo "Rolling out updated application deployments..."
cd manifests/
if [ -f market-feeder.yaml ]; then kubectl apply -f market-feeder.yaml; fi
if [ -f crypto-alert-engine.yaml ]; then kubectl apply -f crypto-alert-engine.yaml; fi
cd ..

echo "✔️ Deployment complete!"