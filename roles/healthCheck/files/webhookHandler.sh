#!/bin/bash

# Webhook Port Settings
webhook_port=5000

# Receive Webhook Data and Process Alerts
nc -l -p $webhook_port -q 1 | while read line; do
  echo "Received alert: $line"

  # Check Alert and Replace Damaged Containers
  if echo "$line" | grep -q "server"; then
    echo "Replacing container..."
    docker run -d --name webserver_replacement -p 80:80 nginx
    echo "Replacement container started."
  fi
done
