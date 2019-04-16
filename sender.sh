#!/bin/bash
WATCHED_DIR="/data/logs/output/"
DEST=${@:1:1}
PREFIXES=${@:2}


while true
do
    sleep 5
    for PREFIX in $PREFIXES; do
        ls $WATCHED_DIR$PREFIX* | head -n -1 | xargs -I{} bash -c "echo {} && clickhouse-client --format_csv_delimiter='|' --query='INSERT INTO $DEST FORMAT CSV' < {} && rm {}"
    done
done
