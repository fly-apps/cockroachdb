FROM cockroachdb/cockroach:v21.2.2

RUN microdnf install bind-utils

ADD start_fly.sh /cockroach/