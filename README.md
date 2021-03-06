# CockroachDB on Fly.io

> **Note:** this app requires version 0.0.223 or greater of the Fly CLI. Run `flyctl version update` before you follow these instructions.

This is an example CockroachDB cluster that runs on multiple Fly.io regions.

Deploying this app is relatively simple:

1. Clone this repository
2. [Install the `fly` CLI](https://fly.io/docs/hands-on/installing/)
2. Run `fly launch`.
    1. Pick "yes" to copy existing configuration
    2. When it asks if you want to deploy, say no
3. Create volumes:
    ```bash
    # one in Chicago
    fly volumes create cdb_data --region ord --size 10
    # one in Paris
    fly volumes create cdb_data --region cdg --size 10
    # one in Singapore
    fly volumes create cdb_data --region sin --size 10
    ```
4. Deploy an empty node
    ```bash
    > fly deploy
    ```
5. Init the cluster:
    ```bash
    > fly ssh console -C '/cockroach/init_cluster.sh'
    Connecting to cockroachdb-example.internal... complete
    Cluster successfully initialized
    ```
6. Scale to 3 nodes
    ```bash
    > fly scale count 3
    Count changed to 3
    ```
7. View CockroachDB status
   ```bash
   fly ssh console -C '/cockroach/cockroach node status --insecure'
   ```

## Hook up Grafana

This example exports metrics for [Fly.io to scrape](https://fly.io/blog/hooking-up-fly-metrics/). You can import [CockroachDB's Grafana dashboards](https://github.com/cockroachdb/cockroach/tree/master/monitoring/grafana-dashboards) to see how your cluster is doing.