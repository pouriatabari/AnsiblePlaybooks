#!/bin/bash

# Web Server Address List
webservers=("http://192.168.72.20" "http://192.168.72.21" "http://192.168.72.22")

# Push Gateway Address
pushgateway_url="http://192.168.72.23:9091/metrics/job/webserver_health"

# Loop through each server to check health status
for server in "${webservers[@]}"; do
  # Web Server Health check
  if curl -s --head --request GET "$server" | grep "200 OK" > /dev/null; then
    status=1
    # Sending Metrics to the Push Gateway
    metric_data="webserver_health{server=\"$server\",instance=\"$server\"} $status"
    echo "$metric_data" | curl -X POST --data-binary @- "$pushgateway_url"
    echo "Health status of $server: $status"
  else
    status=0
    # Sending Metrics to the Push Gateway
    metric_data="webserver_health{server=\"$server\",instance=\"$server\"} $status"
    echo "$metric_data" | curl -X POST --data-binary @- "$pushgateway_url"
    echo "Health status of $server: $status"
  fi


done
