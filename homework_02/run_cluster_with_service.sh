echo 'create cluster'
kind create cluster --config kind-config.yaml
echo 'deploy ingress-nginx'
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
echo 'sleep 60'
sleep 60
cd manifests
echo 'apply namespace'
kubectl apply -f namespace.yaml
echo 'apply deployment'
kubectl apply -f deployment.yaml
echo 'apply service'
kubectl apply -f service.yaml
echo 'apply ingress'
kubectl apply -f ingress.yaml
echo 'sleep 20'
sleep 20
echo 'curl http://arch.homework/health/'
curl http://arch.homework/health/
echo 'curl http://arch.homework/otusapp/surname/health/'
curl http://arch.homework/otusapp/surname/health/