Node Exporter Install Script
============================

This script automates the installation of the latest stable version of Prometheus Node Exporter for Linux systems. It supports automatic architecture detection (amd64, arm64), downloads the latest release from the official GitHub repository, installs the binary, creates a systemd service, and starts it.

Usage:
1. Download the script:
```
curl -O https://raw.githubusercontent.com/kompoln/node_exporter_install/main/node_exporter_install.sh
```
2. Make it executable:
```
chmod +x node_exporter_install.sh
```
3. Run the script as root:
```
sudo ./node_exporter_install.sh
```
After installation, Node Exporter will be running on port 9100.
