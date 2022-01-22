FROM cockroachdb/cockroach:v21.2.4

RUN microdnf install bind-utils

ADD start_fly.sh /cockroach/