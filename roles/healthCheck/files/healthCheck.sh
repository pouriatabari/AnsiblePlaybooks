#!/bin/bash

# Web Server Address List
webservers=("http://192.168.72.20" "http://192.168.72.21" "http://192.168.72.22")

# Push Gateway Address List
pushgateway_url="http://192.168.72.23:9091/metrics/job/webserver_health"

while true; do
  for server in "${webservers[@]}"; do
    # Web Server Health check
    if curl -s --head --request GET "$server" | grep "200 OK" > /dev/null; then
      status=1
    else
      status=0
    fi

    # Sending Metrics to the Push Gateway
    metric_data="webserver_health{server=\"$server\"} $status"
    curl -X POST --data-binary "$metric_data" "$pushgateway_url"
    echo "Health status of $server: $status"
  done
  # Running Script every 60s
  sleep 60
done
