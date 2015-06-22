#!/bin/bash
export PYTHONUNBUFFERED=0
mkdir -p /opt/code/logs
exec uwsgi --http 0.0.0.0:5000 --module main --master --processes 1 --threads 2 --callable app
