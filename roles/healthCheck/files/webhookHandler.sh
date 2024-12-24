#!/bin/bash

# Webhook Port Settings
webhook_port=5000

# Create simple Server to receive Webhook
nc -l -p $webhook_port | while read line; do
  echo "Received alert: $line"

  # Check Alart and Rerplace Damaged Containers
  if echo "$line" | grep -q "server"; then
    echo "Replacing container..."
    docker run -d --name webserver_replacement -p 80:80 nginx
    echo "Replacement container started."
  fi
done
