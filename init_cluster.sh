#!/bin/sh

set -eu

exec /cockroach/cockroach init --insecure --cluster-name=$FLY_APP_NAME