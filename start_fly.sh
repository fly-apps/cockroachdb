#!/bin/sh

set -eu

echo "Saving certificates to file system ..."
mkdir -p /cockroach/cockroach-certs
echo "${DB_CA_CRT}" > /cockroach/cockroach-certs/ca.crt
echo "${DB_NODE_CRT}" > /cockroach/cockroach-certs/node.crt
echo "${DB_NODE_KEY}" > /cockroach/cockroach-certs/node.key
chmod 0600 /cockroach/cockroach-certs/node.key

echo "Starting on Fly ..."
echo exec /cockroach/cockroach start \
  --logtostderr \
  --certs-dir=/cockroach/cockroach-certs \
  --cluster-name=$FLY_APP_NAME \
  --locality=region=$FLY_REGION \
  --advertise-addr=$(hostname -s).vm.$FLY_APP_NAME.internal \
  --http-addr 0.0.0.0 \
  --join=$FLY_APP_NAME.internal
exec /cockroach/cockroach start \
  --logtostderr \
  --certs-dir=/cockroach/cockroach-certs \
  --cluster-name=$FLY_APP_NAME \
  --locality=region=$FLY_REGION \
  --advertise-addr=$(hostname -s).vm.$FLY_APP_NAME.internal \
  --http-addr 0.0.0.0 \
  --join=$FLY_APP_NAME.internal