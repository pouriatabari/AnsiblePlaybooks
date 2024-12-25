#!/bin/bash

# Webhook Port Settings
webhook_port=5000

# Receive Webhook Data and Process Alerts
nc -l -p $webhook_port -q 1 | while read line; do
  echo $line;
  # echo "Received alert: $line"

  # # Extract the alert status (you may need to adjust this according to the exact structure of your alert)
  # alert_status=$(echo "$line" | jq -r '.alerts[0].labels.status')

  # # Check if the alert indicates that the server is down (you may need to adjust this based on the alert structure)
  # if [[ "$alert_status" == "down" ]]; then
  #   echo "Alert indicates server down, replacing container..."

  #   # Check if the replacement container is already running
  #   if ! docker ps -q -f name=webserver_replacement; then
  #     echo "Starting a new replacement container with the same configuration..."

  #     # Define the same configuration for the new container (example: using the same image, port mappings, etc.)
  #     docker run -d --name webserver_replacement -p 80:80 nginx
  #     echo "Replacement container started."
  #   else
  #     echo "Container already exists, skipping replacement."
  #   fi
  # else
  #   echo "Alert is not for server down. No action taken."
  # fi
done
