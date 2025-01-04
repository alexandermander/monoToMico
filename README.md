# To create the local cluster you need to run the following command:

first you need to install the following tools:\
docker\
nvm\
npm\
minikube\
kubectl

## The steps to create the local cluster are the following:
start running the minikube cluster with the docker driver


```bash
minikube start --driver=docker
```

if minikube doesn't work use the:
```bash
sudo usermod -aG docker $USER && newgrp docker
```


## Open a new terminal run
```bash
minikube tunnel
```
this will create a tunnel to the minikube cluster


## After this run the 'setup.sh' script
```bash
./setup.sh
```
if it runs successfully you should see the following output:
```bash
Setup completed successfully!
```

## After running the 'setup.sh'
cd into `~/monolith-to-microservices/microservices/src/orders`\
and run the following command to build the docker image for the orders service:
```bash
docker build -t orders:2.0.0 . 
minikube load docker-image orders:2.0.0
```
do the same for the products services\
cd into `~/monolith-to-microservices/microservices/src/products`
```bash
docker build -t products:1.0.0 .
minikube load docker-image products:1.0.0
```

## Now update the api endpoints in the frontend service insde in the react-app


First cd into the `~/monolith-to-microservices/react-app`
and open the file .env.monolith
bit cofusing taht the file is called .env.monolith since we are not using a monolith anymore\
but keep the name for now\
run the following command to get the external ip of the minikube cluster
```bash
kubectl get services
```
note the external ip of the orders and products services

change the following lines in the file in any text editor
and add the external ip of the orders and products services respectively
```bash
REACT_APP_ORDERS_URL=http://<EXTERNAL_IP>/api/orders
REACT_APP_PRODUCTS_URL=http://<EXTERNAL_IP>/api/products
```

## Next, build the react-app:
```bash
npm run build:monolith
```

## Now set up the react-app deployment and service
```bash
cd ~/monolith-to-microservices/react-app
```
and run the following command to build the docker image for the react-app
```bash
docker build -t monolith:1.0.0 .
```

## Now load the docker image into the minikube cluster
```bash
minikube load docker-image monolith:1.0.0
```

## Finally, run the kubectl create and expose the deployment for the monolith service
```bash
kubectl create deployment monolith --image=monolith:1.0.0
kubectl expose deployment monolith --type=LoadBalancer --port=80 --target-port=80
```


