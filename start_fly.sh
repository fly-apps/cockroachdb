#!/bin/sh

set -eu

echo "Starting on Fly ..."
echo exec /cockroach/cockroach start \
  --insecure \
  --locality=fly_region=$FLY_REGION \
  --cluster-name=$FLY_APP_NAME \
  --join=$FLY_APP_NAME.internal
exec /cockroach/cockroach start \
  --insecure \
  --locality=fly_region=$FLY_REGION \
  --cluster-name=$FLY_APP_NAME \
  --join=$FLY_APP_NAME.internal