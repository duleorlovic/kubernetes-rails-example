#!/bin/sh -ex
export KUBECONFIG=~/.kube/kubernetes-rails-example-kubeconfig.yaml
docker build -t duleorlovic/kubernetes-rails-example:latest .
docker push duleorlovic/kubernetes-rails-example:latest
kubectl create -f config/kube/migrate.yml
kubectl wait --for=condition=complete --timeout=600s job/migrate
kubectl delete job migrate
# kubectl delete pods -l app=rails-app
# kubectl delete pods -l app=sidekiq
# For Kubernetes >= 1.15 replace the last two lines with the following
# in order to have rolling restarts without downtime
kubectl rollout restart deployment/kubernetes-rails-example-deployment
kubectl rollout restart deployment/sidekiq
