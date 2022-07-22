# Build all images
docker build -t scotchcurry/multi-client:latest -t scotchcurry/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t scotchcurry/multi-server:latest -t scotchcurry/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t scotchcurry/multi-worker:latest -t scotchcurry/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# Push images to docker hub
docker push scotchcurry/multi-client:latest
docker push scotchcurry/multi-server:latest
docker push scotchcurry/multi-worker:latest

docker push scotchcurry/multi-client:$SHA
docker push scotchcurry/multi-server:$SHA
docker push scotchcurry/multi-worker:$SHA

# Apply kube
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=scotchcurry/multi-server:$SHA
kubectl set image deployments/client-deployment client=scotchcurry/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=scotchcurry/multi-worker:$SHA
