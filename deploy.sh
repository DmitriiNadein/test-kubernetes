#!/bin/bash
#-----------------------------------------------------------------------
# Test task performed by Dmitrii Nadein
#-----------------------------------------------------------------------

## Setting vars
DOCKER_REPO="epamdmitriinadein/goapp-repo"
DOCKER_TAG="1.23.4"

## Verify minikube is installed
minikube version
if [ $? -eq 0 ] 
then 
  echo "minikube is found, proceed..." 
else 
  echo "ERROR: minikube is not installed on your system!"
  exit
fi

## Create k8s cluster in minikube (on MacOS ARM64 Apple CPU only support docker driver)
minikube start --driver=docker
minikube status

## TODO: Docker build and push
docker build -t $DOCKER_REPO .
docker tag $DOCKER_REPO:latest $DOCKER_REPO:$DOCKER_TAG
docker push $DOCKER_REPO:$DOCKER_TAG

## Creating namespace myns
kubectl create namespace myns
kubectl get ns
kubectl get po -A

## TODO: Deploy k8s manifests (uncomment below to deploy manifests)
# kubectl apply -f ./manifests/deployment.yaml --namespace=myns
# kubectl apply -f ./manifests/service.yaml --namespace=myns
# kubectl get po -A

## Deploy k8s with Helm
helm install api ./api-0.1.0.tgz --namespace=myns
sleep 5
kubectl get po -A

## for minikube with docker driver we need to expose service with below command
kubectl port-forward service/api 3000:3000 --namespace=myns
