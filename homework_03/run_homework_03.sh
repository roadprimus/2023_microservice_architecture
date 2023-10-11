echo 'create cluster'
kind create cluster --config kind-config.yaml
echo 'deploy ingress-nginx'
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
echo 'sleep 120 (running ingress-nginx)'
sleep 120
echo 'run helm'
HELM_NAME=$(helm install helm --generate-name | grep NAME: | cut -d: -f 2)
echo 'sleep 120 (running pods)'
sleep 120
echo 'run tests'
cd tests
newman run crud.postman_collection.json -e crud.postman_environment.json
echo 'delete helm'
helm delete $HELM_NAME
echo 'delete cluster'
kind delete cluster --name my-cluster-name