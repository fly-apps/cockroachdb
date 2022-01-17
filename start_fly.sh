#!/bin/sh

set -eu

echo "Saving certificates to file system ..."
mkdir -p /cockroach/cockroach-certs
echo "${DB_CA_CRT}" | base64 --decode --ignore-garbage > /cockroach/cockroach-certs/ca.crt
echo "${DB_NODE_CRT}" | base64 --decode --ignore-garbage > /cockroach/cockroach-certs/node.crt
echo "${DB_NODE_KEY}" | base64 --decode --ignore-garbage > /cockroach/cockroach-certs/node.key
chmod 0600 /cockroach/cockroach-certs/node.key

echo "Building list of regional join nodes..."
JOIN_NODES=$(dig +short TXT regions.$FLY_APP_NAME.internal | sed -E 's/(")//g;s/([a-z]*)/\1.'"$FLY_APP_NAME"'.internal/g')

echo "Starting on Fly ..."
echo exec /cockroach/cockroach start \
  --logtostderr \
  --certs-dir=/cockroach/cockroach-certs \
  --cluster-name=$FLY_APP_NAME \
  --locality=region=$FLY_REGION \
  --advertise-addr=$(hostname -s).vm.$FLY_APP_NAME.internal \
  --http-addr 0.0.0.0 \
  --join=$JOIN_NODES,top10.nearest.of.$FLY_APP_NAME.internal,$FLY_APP_NAME.fly.dev
exec /cockroach/cockroach start \
  --logtostderr \
  --certs-dir=/cockroach/cockroach-certs \
  --cluster-name=$FLY_APP_NAME \
  --locality=region=$FLY_REGION \
  --advertise-addr=$(hostname -s).vm.$FLY_APP_NAME.internal \
  --http-addr 0.0.0.0 \
  --join=$JOIN_NODES,top10.nearest.of.$FLY_APP_NAME.internal,$FLY_APP_NAME.fly.dev