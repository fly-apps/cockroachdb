# CockroachDB on Fly.io

> **Note:** this app requires version 0.0.261 or greater of the Fly CLI. Run `flyctl version update` before you follow these instructions.

This is an example CockroachDB cluster that runs on multiple Fly.io regions.

Deploying this app is relatively simple:

1. Clone this repository
2. [Install the `cockroach` CLI](https://www.cockroachlabs.com/docs/stable/install-cockroachdb.html)
3. [Install the `fly` CLI](https://fly.io/docs/hands-on/installing/)
4. Run `fly launch`.
    1. Pick "yes" to copy existing configuration
    2. When it asks if you want to deploy, say no
5. Generate the Certificate Authority certificate and keypair (can reuse existing CA but don't share CA between production and non-production environments)
    ```bash
    > cockroach cert create-ca --certs-dir=<absolute_path_to_certificates_directory> --ca-key=<absolute_path_to_ca_key_file>
    ```
6. Generate the Node certificate and keypair

    _When generating the certificate, you can add external domains as well, e.g. `db.example.com`_

    ```bash
    > cockroach cert create-node --certs-dir=<absolute_path_to_certificates_directory> --ca-key=<absolute_path_to_ca_key_file> 127.0.0.1 localhost <app_name>.internal "*.vm.<app_name>.internal" "*.nearest.of.<app_name>.internal" <app_name>.fly.dev
    ```
7. Generate the root user certificate and keypair
    ```bash
    > cockroach cert create-client --certs-dir=<absolute_path_to_certificates_directory> --ca-key=<absolute_path_to_ca_key_file> root
    ```
8. Upload the certificates and keypair
    ```bash
    > base64 <path_to_ca.crt> | fly secrets set DB_CA_CRT=-
    > base64 <path_to_node.crt> | fly secrets set DB_NODE_CRT=-
    > base64 <path_to_node.key> | fly secrets set DB_NODE_KEY=-
    ```
9. Create volumes:
    ```bash
    # for single region, minimum 3 nodes required
    > fly volumes create crdb_data --region <region> --size 100
    > fly volumes create crdb_data --region <region> --size 100
    > fly volumes create crdb_data --region <region> --size 100

    # for multi-region, minimum 3 regions required
    > fly volumes create crdb_data --region <region1> --size 100
    > fly volumes create crdb_data --region <region2> --size 100
    > fly volumes create crdb_data --region <region3> --size 100
    ```
10. Set VM size and scale to desired node count
    ```bash
    > fly scale vm <size> --memory <memory_in_megabytes>
    Scaled VM Type to
     <size>
      CPU Cores: <number_of_cores>
         Memory: <memory> GB
    > fly scale count <node_count>
    Count changed to <node_count>
    ```
11. Deploy nodes
    ```bash
    > fly deploy
    ```
12. Init the cluster:
    ```bash
    > cockroach init --cluster-name=<app_name> --host=<app_name>.fly.dev:10000 --certs-dir=<absolute_path_to_certificates_directory>
    Cluster successfully initialized
    ```
13. View CockroachDB status
   ```bash
   > cockroach node status --host=<app_name>.fly.dev:10000 --certs-dir=<absolute_path_to_certificates>
   ```

## Hook up Grafana

This example exports metrics for [Fly.io to scrape](https://fly.io/blog/hooking-up-fly-metrics/). You can import [CockroachDB's Grafana dashboards](https://github.com/cockroachdb/cockroach/tree/master/monitoring/grafana-dashboards) to see how your cluster is doing.