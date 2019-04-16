#!/bin/bash
bash -c "ssh $1 tail -F /data/nginx/logs/access.log" | mawk -f ~/work/logs/parser.awk -v "prefix=/data/logs/output/$1"
