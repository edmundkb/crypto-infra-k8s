#!/usr/bin/env bash

set -e

echo "Starting local crypto pipeline deployment..."

# 1. Compile applications natively on your Mac (Fast and low resource)
echo "Compiling crypto-market-feeder locally..."
cd ../crypto-market-feeder
./mvnw clean package -DskipTests

echo "Compiling crypto-alert-engine locally..."
cd ../crypto-alert-engine
./mvnw clean package -DskipTests

# 2. Point terminal to Minikube's internal Docker daemon
echo "Connecting to Minikube Docker environment..."
cd ../crypto-infra-k8s
eval $(minikube docker-env)

# 3. Apply core infrastructure manifests
echo "Applying Kubernetes manifests..."
cd manifests/
kubectl apply -f services.yaml
kubectl apply -f rabbitmq.yaml
kubectl apply -f postgres-infra.yaml
cd ..

# 4. Build lightweight Docker images using the pre-compiled JARs
echo "Building updated application images..."
echo "-> Building market-feeder..."
docker build -t market-feeder:latest ../crypto-market-feeder

echo "-> Building crypto-alert-engine..."
docker build -t crypto-alert-engine:latest ../crypto-alert-engine

echo "Rolling out updated application deployments..."
cd manifests/
if [ -f market-feeder.yaml ]; then kubectl apply -f market-feeder.yaml; fi
if [ -f crypto-alert-engine.yaml ]; then kubectl apply -f crypto-alert-engine.yaml; fi
cd ..

echo "✔️ Deployment complete!"