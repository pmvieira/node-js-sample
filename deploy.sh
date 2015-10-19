#!/bin/bash

# Exit on any error
set -e

# We need to configure the cluster and pods
# KUBE_CMD=${KUBERNETES_ROOT:-~/kubernetes}/cluster/kubecfg.sh

# Deploy image to private GCS-backed registry
gcloud docker push $GCR_HOST/$IMAGE:$CIRCLE_SHA1

# Configure kubectl
gcloud config set compute/zone europe-west1-d
gcloud config set project quill-software
gcloud container clusters get-credentials $IMAGE

echo "debug1"

rc=$(kubectl get rc | grep $IMAGE | awk {'print $1'})

# Update Kubernetes replicationController
envsubst < gke/app-controller.json.template > app-controller.json

echo "debug2"
#$KUBE_CMD -c app-controller.json \
#    update replicationControllers/app-controller
kubectl replace -f app-controller.json

echo "app-controller.json"
# Roll over Kubernetes pods
#$KUBE_CMD rollingupdate app-controller
kubectl rolling-update $rc
