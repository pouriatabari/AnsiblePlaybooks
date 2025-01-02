#!/bin/bash
# Webhook Port Settings
webhook_port=5000

# Start listening for webhook data
echo "Starting webhook listener on port $webhook_port..."
nc -lk -p $webhook_port | while read line; do
  echo "Received data: $line"

  # Parse the incoming JSON to extract alert details
  alert_status=$(echo "$line" | jq -r '.status')
  alert_name=$(echo "$line" | jq -r '.alerts[0].labels.alertname')

  echo "Alert Name: $alert_name, Status: $alert_status"

  # Check if the alert is firing and matches the desired alert
  if [[ "$alert_status" == "firing" && "$alert_name" == "WebServerDown" ]]; then
    echo "Alert indicates server down, checking replacement container..."

    # Check if the replacement container is already running
    if [ -z "$(docker ps -q -f name=webserver_replacement)" ]; then
      echo "Starting a new replacement container with the same configuration..."

      # Define the same configuration for the new container (example: using the same image, port mappings, etc.)
      docker run -d --name webserver_replacement -p 8080:80 nginx
      echo "Replacement container started on port 8080."
    else
      echo "Replacement container is already running. No action taken."
    fi
  else
    echo "No matching alert or not firing. No action taken."
  fi
done
