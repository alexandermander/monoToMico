#!/bin/bash

#get current directory
#
DIR=$(pwd)
#
#cd ~/dsys/monolith-to-microservices/microservices/src/orders
cd $DIR/microservices/src/orders
docker build -t orders:2.0.0 .  # Or replace with "products:1.0.0" or "frontend:1.0.0" for each service

cd $DIR/microservices/src/products
docker build -t products:1.0.0 .  

minikube image load products:1.0.0
minikube image load orders:1.0.0

kubectl create deployment orders --image=orders:1.0.0
kubectl expose deployment orders --type=LoadBalancer --port 80 --target-port 8081


kubectl create deployment products --image=products:1.0.0
kubectl expose deployment products --type=LoadBalancer --port 80 --target-port 8082

kubectl get service 
#REACT_APP_ORDERS_URL=/service/orders
#REACT_APP_PRODUCTS_URL=/service/products



