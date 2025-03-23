
#!/bin/bash

# Update and install necessary packages
sudo pkg update
sudo pkg install -y wget

# Download and install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xvzf node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/

# Run Node Exporter
nohup /usr/local/bin/node_exporter --web.disable-tls --web.enable-http2=false &
