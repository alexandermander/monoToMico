#!/bin/bash

# get current directory
DIR=$(pwd)

cd $DIR/react-app/

rm .env.monolith

#NAME         TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)        AGE
#kubernetes   ClusterIP      10.96.0.1        <none>           443/TCP        22h
#monolith     LoadBalancer   10.101.159.224   10.101.159.224   80:31865/TCP   21h
#orders       LoadBalancer   10.96.238.186    10.96.238.186    80:32743/TCP   22h
#products     LoadBalancer   10.107.8.234     10.107.8.234     80:31415/TCP   22h

#get the ip address of the orders service and products service
ORDERS_IP=$(kubectl get svc orders -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PRODUCTS_IP=$(kubectl get svc products -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "REACT_APP_ORDERS_URL=http://$ORDERS_IP/api/orders
REACT_APP_PRODUCTS_URL=http://$PRODUCTS_IP/api/products" > .env.monolith

cat .env.monolith
#REACT_APP_ORDERS_URL=http://10.96.238.186/api/orders
#REACT_APP_PRODUCTS_URL=http://10.107.8.234/api/products
#

npm run build:monolith

cd $DIR/monolith/

docker build -t monolith:2.0.0 .

minikube image load monolith:2.0.0

kubectl create deployment monolith --image=monolith:2.0.0
kubectl expose deployment monolith --type=LoadBalancer --port 80 --target-port 8080

echo "The frontend that uses the microservices is now deployed to Kubernetes."
echo "You can access it by visiting the following URL in your web browser:"

kubectl get service monolith




