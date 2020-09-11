#!/bin/sh
export DATA_SOURCE_NAME="postgresql://postgres:postgres@172.16.8.4:5432/optima?sslmode=disable"

bin/postgres_exporter_v0.8.0_linux-amd64/postgres_exporter --disable-default-metrics --disable-settings-metrics  --extend.query-path=./queries-optima.yaml    

