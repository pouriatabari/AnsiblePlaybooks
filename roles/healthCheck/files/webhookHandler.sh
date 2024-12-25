#!/bin/bash

# Webhook Port Settings
webhook_port=5000

# Create simple Server to receive Webhook
response=$(timeout 1 nc -l -p $webhook_port)

if [ -n "$response" ]; then
  echo "Received alert: $response"

  # Check Alert and Replace Damaged Containers
  if echo "$response" | grep -q "server"; then
    echo "Replacing container..."
    docker run -d --name webserver_replacement -p 80:80 nginx
    echo "Replacement container started."
  fi
fi
