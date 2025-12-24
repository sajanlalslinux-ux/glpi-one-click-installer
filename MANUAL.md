# GLPI Agent Installer - Complete User Manual

<div align="center">

![GLPI Logo](https://glpi-project.org/wp-content/uploads/2023/01/glpi-logo.png)

**One-Command Interactive Installer for GLPI Agent**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)]()
[![GLPI](https://img.shields.io/badge/GLPI-9.5%2B-green.svg)]()

[Quick Start](#quick-start) • [Features](#features) • [Documentation](#documentation) • [Support](#support)

</div>

---

## 📖 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Installation Guide](#installation-guide)
- [Configuration](#configuration)
- [Usage](#usage)
- [GLPI Integration](#glpi-integration)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [Advanced Topics](#advanced-topics)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

The **GLPI Agent Installer** is an interactive, one-command solution for deploying GLPI Agent across your infrastructure. It simplifies the installation process by asking simple questions and automatically configuring everything.

### Why Use This Installer?

| Problem | This Solution |
|---------|---------------|
| Manual configuration is complex | ✅ Interactive prompts guide you |
| Different OS require different steps | ✅ Auto-detects and adapts to your OS |
| Impact analysis setup is manual | ✅ Automatically enabled |
| Metrics collection requires setup | ✅ Pre-configured and ready |
| Takes 30+ minutes to configure | ✅ Complete in 2 minutes |

---

## ✨ Features

### 🚀 Core Features

- **Interactive Setup** - Simple questions, automatic configuration
- **Multi-OS Support** - Works on Debian, Ubuntu, RHEL, CentOS, Fedora, Rocky Linux, AlmaLinux
- **Auto-Updates** - Configurable interval (default: 5 minutes)
- **Impact Analysis** - Automatic data collection for relationship mapping
- **Real-Time Metrics** - CPU, Memory, Disk, Network, Temperature, Uptime
- **One Command Install** - Perfect for mass deployment
- **No API Required** - Direct GLPI integration

### 📊 Monitoring Capabilities

#### System Metrics (Auto-Collected)
- ✅ CPU usage percentage
- ✅ Memory usage (MB and %)
- ✅ Disk space usage
- ✅ Network traffic (RX/TX)
- ✅ Process count
- ✅ System uptime
- ✅ System temperature
- ✅ Load average

#### Inventory Data
- ✅ Hardware components (CPU, RAM, Disks, Motherboard)
- ✅ Installed software (complete list)
- ✅ Network interfaces and configuration
- ✅ Operating system details
- ✅ Serial numbers and asset tags
- ✅ Peripheral devices

---

## 📋 Requirements

### System Requirements

| Component | Requirement |
|-----------|-------------|
| **OS** | Linux (Debian/Ubuntu/RHEL/CentOS/Fedora) |
| **Privileges** | Root access (sudo) |
| **Network** | Internet connection |
| **GLPI Server** | Version 9.5 or later |
| **Disk Space** | 50 MB minimum |
| **RAM** | 512 MB minimum |

### Supported Operating Systems

#### ✅ Fully Tested
- Ubuntu 18.04, 20.04, 22.04, 24.04
- Debian 9, 10, 11, 12
- Linux Mint 20, 21, 22

#### ✅ Supported
- RHEL 7, 8, 9
- CentOS 7, 8, 9 (Stream)
- Rocky Linux 8, 9
- AlmaLinux 8, 9
- Fedora 35+

---

## 🚀 Quick Start

### Method 1: One-Command Install (From GitHub)

```bash
curl -sSL https://raw.githubusercontent.com/sajanlalslinux-ux/glpi-one-click-installer/main/glpi-agent-installer.sh | sudo bash
```

### Method 2: Download and Run

```bash
# Download
wget https://raw.githubusercontent.com/sajanlalslinux-ux/glpi-one-click-installer/main/glpi-agent-installer.sh

# Make executable
chmod +x glpi-agent-installer.sh

# Run with sudo
sudo ./glpi-agent-installer.sh
```

### Method 3: Clone Repository

```bash
# Clone
git clone https://github.com/sajanlalslinux-ux/glpi-one-click-installer.git

# Navigate
cd glpi-agent-installer

# Run
sudo ./glpi-agent-installer.sh
```

---

## 📚 Installation Guide

### Step-by-Step Installation

#### 1. Run the Installer

```bash
sudo ./glpi-agent-installer.sh
```

You'll see a welcome banner:

```
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║           GLPI Agent - Interactive Installer                 ║
║                                                               ║
║     One command to install and configure everything!         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

#### 2. Answer Configuration Questions

##### **Question 1: GLPI Server URL**

```
Enter your GLPI server address:
Examples:
  - https://10.31.5.171/
  - http://glpi.yourcompany.com/
  - https://glpi.example.com/glpi/

GLPI Server URL: _
```

**Enter your GLPI server URL** (must start with http:// or https://)

##### **Question 2: Computer Name**

```
Enter computer name for GLPI:
(Default: your-current-hostname)
Computer Name [your-hostname]: _
```

**Press Enter** to use current hostname, or **type a new name**

##### **Question 3: Update Interval**

```
Update interval in seconds:
(Default: 300 = 5 minutes)
Update Interval [300]: _
```

**Press Enter** for 5 minutes, or **enter custom seconds**

Common values:
- `300` = 5 minutes (recommended)
- `600` = 10 minutes
- `1800` = 30 minutes
- `3600` = 1 hour

##### **Question 4: Tag/Group**

```
Tag to identify this computer group:
Examples: production, office, servers, workstations
Tag [auto-deployed]: _
```

**Press Enter** for default, or **enter a tag** (e.g., "production", "office")

#### 3. Confirm Configuration

```
═══════════════════════════════════════════════════════════
Configuration Summary:
═══════════════════════════════════════════════════════════
  GLPI Server:      https://glpi.company.com/
  Computer Name:    web-server-01
  Update Interval:  300 seconds (5 minutes)
  Tag:              production
═══════════════════════════════════════════════════════════

Is this correct? (y/n): _
```

**Type `y`** and press Enter to proceed

#### 4. Automatic Installation

The installer will now:

```
[1/7] Detecting operating system...
  ✓ Detected: Ubuntu 22.04 LTS

[2/7] Installing dependencies...
  ✓ Dependencies installed

[3/7] Installing metrics collector...
  ✓ Metrics collector installed

[4/7] Configuring GLPI Agent...
  ✓ Configuration created

[5/7] Enabling GLPI Agent service...
  ✓ Service started successfully

[6/7] Sending initial inventory to GLPI...
  ✓ Initial inventory sent

[7/7] Setting up automatic metrics logging...
  ✓ Auto-logging configured
```

#### 5. Installation Complete!

```
╔═══════════════════════════════════════════════════════════════╗
║              Installation Complete! ✓                         ║
╚═══════════════════════════════════════════════════════════════╝

Installation Details:
  ✓ GLPI Server:      https://glpi.company.com/
  ✓ Computer Name:    web-server-01
  ✓ Update Interval:  5 minutes
  ✓ Tag:              production
  ✓ Agent Status:     active
```

---

## ⚙️ Configuration

### Configuration File Location

After installation, the main configuration file is at:
```
/etc/glpi-agent/agent.cfg
```

### View Current Configuration

```bash
cat /etc/glpi-agent/agent.cfg
```

### Edit Configuration

```bash
sudo nano /etc/glpi-agent/agent.cfg
```

### Common Configuration Options

```ini
# GLPI Server (required)
server = https://glpi.company.com/

# Update interval in seconds
delaytime = 300

# Computer tag/group
tag = production

# Tasks to execute
tasks = inventory

# Debug mode (0=off, 1=basic, 2=verbose)
debug = 0

# SSL certificate verification
no-ssl-check = 1

# Timeout in seconds
timeout = 180
```

### Apply Configuration Changes

After editing, restart the service:

```bash
sudo systemctl restart glpi-agent
```

---

## 💻 Usage

### Common Commands

#### Check Service Status

```bash
systemctl status glpi-agent
```

Expected output:
```
● glpi-agent.service - GLPI agent
   Active: active (running) since ...
```

#### Force Immediate Update

```bash
sudo glpi-agent --force
```

#### View Real-Time Metrics

```bash
glpi-metrics-collector
```

Output example:
```
# GLPI System Metrics
# Generated: 2025-12-24 11:00:00

cpu_usage_percent=25.5
cpu_cores=8
memory_total_mb=16384
memory_used_mb=8192
memory_usage_percent=50.0
disk_root_usage_percent=45
...
```

#### View Agent Logs

```bash
# Live logs
sudo journalctl -u glpi-agent -f

# Last 100 lines
sudo journalctl -u glpi-agent -n 100

# Logs from today
sudo journalctl -u glpi-agent --since today
```

#### View Metrics History

```bash
sudo tail -f /var/log/glpi-metrics.log
```

### Service Management

#### Start Service

```bash
sudo systemctl start glpi-agent
```

#### Stop Service

```bash
sudo systemctl stop glpi-agent
```

#### Restart Service

```bash
sudo systemctl restart glpi-agent
```

#### Enable at Boot

```bash
sudo systemctl enable glpi-agent
```

#### Disable at Boot

```bash
sudo systemctl disable glpi-agent
```

---

## 🔌 GLPI Integration

### Viewing Your Computer in GLPI

1. **Login to GLPI** web interface
2. Navigate to **Assets** > **Computers**
3. Search for your computer name
4. Click on the computer to view details

### Available Information Tabs

#### **Main Tab**
- Computer name
- Serial number
- Model information
- **Last inventory date** (heartbeat) ⭐
- Status and location

#### **Components Tab**
- CPU details (model, speed, cores)
- Memory (RAM modules, capacity)
- Hard drives (model, capacity, serial)
- Network cards
- Graphics cards
- Motherboard information
- BIOS version

#### **Software Tab**
- Complete list of installed software
- Version numbers
- Installation dates
- Publishers

#### **Network Ports Tab**
- Network interfaces
- IP addresses
- MAC addresses
- Connection status
- Speed and duplex

#### **Impact Analysis Tab** ⭐
- Visual relationship map
- Connected devices
- Dependencies
- Services
- Applications
- **Auto-updates with each inventory!**

#### **Management Tab**
- Financial information
- Contracts
- Documents
- **Collect data** (if configured)

### Setting Up Collect for Metrics

To see real-time metrics in GLPI:

1. Go to **Setup** > **Collect**
2. Click **Add**
3. Configure:
   - **Name**: `System Metrics`
   - **Active**: ✓ Yes
   - **Type**: Registry

4. Add collection items:

| Name | Path | Key |
|------|------|-----|
| CPU Usage | `/usr/local/bin/glpi-metrics-collector` | `cpu_usage_percent` |
| Memory Usage | `/usr/local/bin/glpi-metrics-collector` | `memory_usage_percent` |
| Disk Usage | `/usr/local/bin/glpi-metrics-collector` | `disk_root_usage_percent` |
| Network RX | `/usr/local/bin/glpi-metrics-collector` | `network_rx_mb` |
| Network TX | `/usr/local/bin/glpi-metrics-collector` | `network_tx_mb` |
| Uptime | `/usr/local/bin/glpi-metrics-collector` | `uptime_days` |

5. Associate with computers:
   - Go to **Assets** > **Computers** > Your computer
   - **Management** tab > **Collect**
   - Click **Associate** and select your collection

---

## 📊 Monitoring

### Real-Time Monitoring

#### View Current System Status

```bash
glpi-metrics-collector
```

#### Monitor Specific Metrics

```bash
# CPU usage only
glpi-metrics-collector | grep cpu_usage_percent

# Memory usage only
glpi-metrics-collector | grep memory_usage_percent

# All metrics with timestamp
glpi-metrics-collector | head -n 3
```

### Historical Data

Metrics are automatically logged every 5 minutes to:
```
/var/log/glpi-metrics.log
```

#### View Recent History

```bash
# Last 20 lines
sudo tail -n 20 /var/log/glpi-metrics.log

# Live monitoring
sudo tail -f /var/log/glpi-metrics.log

# Search for specific time
sudo grep "2025-12-24 10:" /var/log/glpi-metrics.log
```

### Creating Dashboards in GLPI

1. Go to **Home** > **Dashboard**
2. Click **Add Widget**
3. Select **Collect** widget type
4. Choose:
   - **Computer**: Your computer name
   - **Collection**: System Metrics
   - **Metric**: CPU Usage (or any metric)
5. Customize visualization:
   - Graph type (line, bar, gauge)
   - Time range
   - Refresh interval
6. Click **Save**

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Issue: Computer Not Appearing in GLPI

**Solution:**

```bash
# Force immediate inventory
sudo glpi-agent --server=https://your-glpi-server.com/ --force --debug

# Check for errors in output
# Look for "sending" messages
```

#### Issue: Service Won't Start

**Solution:**

```bash
# Check service status
sudo systemctl status glpi-agent

# View detailed logs
sudo journalctl -u glpi-agent -n 50

# Validate configuration
cat /etc/glpi-agent/agent.cfg

# Test manual run
sudo glpi-agent --no-fork --debug
```

#### Issue: Can't Connect to GLPI Server

**Solution:**

```bash
# Test network connectivity
ping your-glpi-server.com

# Test HTTP/HTTPS connection
curl https://your-glpi-server.com/

# Check firewall
sudo iptables -L

# Verify server URL in config
grep "^server" /etc/glpi-agent/agent.cfg
```

#### Issue: Metrics Not Collecting

**Solution:**

```bash
# Test metrics collector
glpi-metrics-collector

# Check if executable
ls -l /usr/local/bin/glpi-metrics-collector

# Check permissions
sudo chmod +x /usr/local/bin/glpi-metrics-collector

# View cron job
cat /etc/cron.d/glpi-metrics
```

#### Issue: SSL Certificate Errors

**Solution:**

Edit `/etc/glpi-agent/agent.cfg` and ensure:
```ini
no-ssl-check = 1
```

Then restart:
```bash
sudo systemctl restart glpi-agent
```

### Debug Mode

Enable debug mode for detailed troubleshooting:

```bash
# Edit configuration
sudo nano /etc/glpi-agent/agent.cfg

# Change debug line to:
debug = 1

# Restart service
sudo systemctl restart glpi-agent

# View debug logs
sudo journalctl -u glpi-agent -f
```

### Log Files

| File | Purpose |
|------|---------|
| `/var/log/glpi-metrics.log` | Metrics history |
| `journalctl -u glpi-agent` | Agent logs |
| `/etc/glpi-agent/agent.cfg` | Configuration |

---

## 🔬 Advanced Topics

### Custom Update Intervals

To change update frequency after installation:

```bash
# Edit configuration
sudo nano /etc/glpi-agent/agent.cfg

# Change delaytime (in seconds)
delaytime = 600  # 10 minutes

# Restart
sudo systemctl restart glpi-agent
```

### Multiple GLPI Servers

Configure failover servers:

```ini
server = https://glpi-primary.com/
server = https://glpi-backup.com/
```

### Custom Tags

Change or add multiple tags:

```ini
tag = production
tag = datacenter-1
tag = web-servers
```

### Excluding Categories from Inventory

To skip certain inventory categories:

```ini
no-category = printer,software
```

### Local Inventory Mode

Save inventory locally instead of sending to server:

```ini
local = /var/lib/glpi-agent/
```

### Proxy Configuration

If using a proxy server:

```ini
proxy = http://proxy.company.com:8080
proxy-user = username
proxy-password = password
```

---

## ❓ FAQ

### General Questions

**Q: Does this work on Windows?**
A: No, this installer is for Linux systems only. For Windows, use the official GLPI Agent MSI installer.

**Q: Can I run this on multiple computers?**
A: Yes! That's the main purpose. Use the same command on all computers.

**Q: Will it overwrite existing GLPI Agent?**
A: Yes, it will reconfigure the existing installation with your new settings.

**Q: Is internet required?**
A: Yes, for downloading the GLPI Agent package. After installation, only access to your GLPI server is needed.

### Technical Questions

**Q: What user does the agent run as?**
A: The agent runs as root to access all system information.

**Q: How much bandwidth does it use?**
A: Minimal. Each inventory is typically 50-200 KB depending on installed software.

**Q: Can I change the computer name later?**
A: Yes, edit `/etc/glpi-agent/agent.cfg` and change the server name setting, or run `hostnamectl set-hostname new-name`.

**Q: How do I uninstall?**
A: See the [Uninstall](#uninstall) section below.

### Troubleshooting Questions

**Q: Why isn't my computer showing up in GLPI?**
A: Check firewall settings, verify server URL, and ensure the GLPI server is accessible.

**Q: How do I know when the last inventory was sent?**
A: Check `journalctl -u glpi-agent | grep "sending"` or view "Last inventory" in GLPI web interface.

**Q: Can I run inventory manually?**
A: Yes, use `sudo glpi-agent --force`

---

## 🗑️ Uninstall

To completely remove GLPI Agent:

```bash
# Stop and disable service
sudo systemctl stop glpi-agent
sudo systemctl disable glpi-agent

# Remove packages (Ubuntu/Debian)
sudo apt remove --purge glpi-agent

# Remove packages (RHEL/CentOS)
sudo yum remove glpi-agent

# Remove configuration
sudo rm -rf /etc/glpi-agent

# Remove metrics collector
sudo rm /usr/local/bin/glpi-metrics-collector

# Remove cron job
sudo rm /etc/cron.d/glpi-metrics

# Remove logs (optional)
sudo rm /var/log/glpi-metrics.log
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🆘 Support

### Get Help

- **Issues**: [GitHub Issues](https://github.com/sajanlalslinux-ux/glpi-one-click-installer/issues)
- **Documentation**: [GLPI Agent Docs](https://glpi-agent.readthedocs.io/)
- **GLPI Project**: [https://glpi-project.org/](https://glpi-project.org/)

### Reporting Bugs

When reporting issues, please include:
- Operating system and version
- GLPI server version
- Error messages from logs
- Steps to reproduce

---

## 🙏 Acknowledgments

- GLPI Project for the excellent asset management system
- GLPI Agent developers for the inventory agent
- Community contributors

---

<div align="center">

**Made with ❤️ for easy GLPI deployment**

[⬆ Back to Top](#glpi-agent-installer---complete-user-manual)

</div>
