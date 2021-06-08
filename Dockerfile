FROM cockroachdb/cockroach:v21.1.2

ADD init_cluster.sh /cockroach/
ADD start_fly.sh /cockroach/