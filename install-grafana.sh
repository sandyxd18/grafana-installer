#!/bin/bash

set -eE

error_handler() {
  echo -e "\n❌ There was an error on line ${BASH_LINENO[0]}: '${BASH_COMMAND}'"
  echo "Please check your internet connection, repository, or sudo permissions."
  exit 1
}

trap error_handler ERR

echo "🔧 [5%] Start installing Grafana..."

echo "🔧 [10%] Installing initial dependencies..."
sudo apt-get install -y apt-transport-https software-properties-common wget > /dev/null 2>&1

echo "🔧 [25%] Preparing keyrings directory..."
sudo mkdir -p /etc/apt/keyrings/

echo "🔧 [35%] Importing Grafana GPG key..."
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null 2>&1

echo "🔧 [45%] Adding Grafana repository..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list > /dev/null

echo "🔧 [60%] Updating package list..."
sudo apt-get update > /dev/null 2>&1

echo "🔧 [75%] Installing Grafana..."
sudo apt-get install grafana -y > /dev/null 2>&1

echo "🔧 [90%] Enabling and starting Grafana service..."
sudo systemctl enable grafana-server > /dev/null 2>&1
sudo systemctl start grafana-server > /dev/null 2>&1

echo "✅ [100%] Grafana has been successfully installed and is running on port 3000"