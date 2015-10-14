#!/bin/bash

# Exit on any error
set -e

# We need to configure the cluster and pods
# KUBE_CMD=${KUBERNETES_ROOT:-~/kubernetes}/cluster/kubecfg.sh

# Deploy image to private GCS-backed registry
gcloud docker push $GCR_HOST/$IMAGE:$CIRCLE_SHA1

echo "debug1"

# Update Kubernetes replicationController
envsubst < gke/app-controller.json.template > app-controller.json

echo "debug2"
#$KUBE_CMD -c app-controller.json \
#    update replicationControllers/app-controller
kubectl replace -f app-controller.json

echo "debug3"
# Roll over Kubernetes pods
#$KUBE_CMD rollingupdate app-controller
kubectl rolling-update $IMAGE:$CIRCLE_SHA1 -f app-controller.json
