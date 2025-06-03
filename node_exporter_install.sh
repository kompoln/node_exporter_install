#!/bin/bash

set -e

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

echo "Detected architecture: $ARCH"

LATEST_VERSION=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep tag_name | cut -d '"' -f4)
echo "Latest version: $LATEST_VERSION"

URL="https://github.com/prometheus/node_exporter/releases/download/${LATEST_VERSION}/node_exporter-${LATEST_VERSION#v}.linux-${ARCH}.tar.gz"
TMP_DIR=$(mktemp -d)
echo "Downloading: $URL"
curl -L "$URL" -o "$TMP_DIR/node_exporter.tar.gz"

echo "Extracting..."
tar -xzf "$TMP_DIR/node_exporter.tar.gz" -C "$TMP_DIR"

echo "Installing to /usr/local/bin"
install "$TMP_DIR"/node_exporter-*/node_exporter /usr/local/bin/node_exporter

echo "Creating systemd service..."

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nobody
Group=nogroup
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Starting node_exporter..."
systemctl daemon-reload
systemctl enable --now node_exporter

echo "node_exporter installed and running!"
systemctl status node_exporter --no-pager
