#!/bin/bash

# Web Server Health Variables
web01_health="http://192.168.72.51"
web02_health="http://192.168.72.52"
web03_health="http://192.168.72.53"

# Web Server Address List (Using Variable Names)
webservers=($web01_health $web02_health $web03_health)

# Push Gateway Address
pushgateway_url="http://192.168.72.54:9091/metrics/job/webserver_health"

# Loop through each server to check health status
for server in "${webservers[@]}"; do
  # Determine the variable name corresponding to the server
  case $server in
    $web01_health)
      metric_name="web01_health"
      ;;
    $web02_health)
      metric_name="web02_health"
      ;;
    $web03_health)
      metric_name="web03_health"
      ;;
  esac

  # Web Server Health check
  if curl -s --head --request GET "$server" | grep "200 OK" > /dev/null; then
    status=1
  else
    status=0
  fi

  # Sending Metrics to the Push Gateway
  metric_data="$metric_name{server=\"$server\",instance=\"$server\"} $status"
  echo "$metric_data" | curl -X POST --data-binary @- "$pushgateway_url"
  echo "Health status of $metric_name: $status"
done
