#!/bin/bash
#
# author: Gary A. Stafford
# site: https://programmaticponderings.com
# license: MIT License
# purpose: Install Istio 1.1.0

# set -ex

readonly ISTIO_HOME='/Applications/istio-1.1.0'

# helm repo add istio.io https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts
# helm repo list

kubectl apply -f ${ISTIO_HOME}/install/kubernetes/helm/helm-service-account.yaml

helm init --service-account tiller

# Wait for Tiller pod to come up
# Error: could not find a ready tiller pod
sleep 15

helm install ${ISTIO_HOME}/install/kubernetes/helm/istio-init \
  --name istio-init \
  --namespace istio-system

helm install ${ISTIO_HOME}/install/kubernetes/helm/istio \
  --name istio \
  --namespace istio-system \
  --set prometheus.enabled=true \
  --set grafana.enabled=true \
  --set kiali.enabled=true \
  --set tracing.enabled=true

kubectl apply --namespace istio-system -f ./resources/secrets/kiali.yaml
# kubectl apply --namespace istio-system -f ./resources/secrets/grafana.yaml

kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l

kubectl get svc -n istio-system
kubectl get pods -n istio-system
helm list istio
