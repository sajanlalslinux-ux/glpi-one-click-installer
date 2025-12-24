# GLPI Agent - One-Command Interactive Installer

🚀 **Install and configure GLPI Agent with a single command!**

## ✨ Features

- ✅ **Interactive Setup** - Simple questions to configure everything
- ✅ **Auto-Updates** - Updates GLPI every 5 minutes (configurable)
- ✅ **Impact Analysis** - Automatic data collection for impact visualization
- ✅ **Real-Time Metrics** - CPU, Memory, Disk, Network monitoring
- ✅ **One Command Install** - Perfect for administrators
- ✅ **Multi-OS Support** - Debian, Ubuntu, RHEL, CentOS, Fedora, etc.
- ✅ **No API Required** - Direct integration with GLPI

## 🎯 Quick Start

### Single Command Installation

```bash
curl -sSL https://raw.githubusercontent.com/sajanlalslinux-ux/glpi-one-click-installer/main/glpi-agent-installer.sh | sudo bash
```

Or download and run:

```bash
wget https://raw.githubusercontent.com/sajanlalslinux-ux/glpi-one-click-installer/main/glpi-agent-installer.sh
chmod +x glpi-agent-installer.sh
sudo ./glpi-agent-installer.sh
```

## 📋 What It Does

The installer will ask you a few simple questions:

1. **GLPI Server URL** - Your GLPI server address 
2. **Computer Name** - How this computer should appear in GLPI
3. **Update Interval** - How often to send updates (default: 5 minutes)
4. **Tag** - Group identifier (e.g., `production`, `office`, `servers`)

Then it automatically:
- ✅ Installs GLPI Agent
- ✅ Configures connection to your GLPI server
- ✅ Sends first inventory
- ✅ Sets up automatic updates
- ✅ Installs metrics collector
- ✅ Enables impact analysis data
- ✅ Starts the service

## 📊 Features Included

### Automatic Inventory
- Hardware detection (CPU, RAM, Disks)
- Software inventory
- Network interfaces
- Operating system details
- Updates every 5 minutes (configurable)

### Real-Time Monitoring
- CPU usage percentage
- Memory usage (MB and %)
- Disk space usage
- Network traffic (RX/TX)
- Process count
- System uptime
- System temperature (if available)

### Impact Analysis
- Automatic data collection
- Relationship mapping
- Dependency tracking
- Visual impact graphs in GLPI

## 🖥️ Supported Operating Systems

| OS | Version | Status |
|---|---|---|
| Ubuntu | 18.04+ | ✅ Tested |
| Debian | 9+ | ✅ Tested |
| Linux Mint | 20+ | ✅ Tested |
| RHEL | 7+ | ✅ Supported |
| CentOS | 7+ | ✅ Supported |
| Rocky Linux | 8+ | ✅ Supported |
| AlmaLinux | 8+ | ✅ Supported |
| Fedora | 35+ | ✅ Supported |

## 📖 Usage Examples

### Basic Installation

```bash
sudo ./glpi-agent-installer.sh
```

Follow the prompts:
```
GLPI Server URL: https://glpi.yourcompany.com/
Computer Name [current-hostname]: my-server
Update Interval [300]: 300
Tag [auto-deployed]: production
```

### View Current Metrics

```bash
glpi-metrics-collector
```

Output:
```
# GLPI System Metrics
# Generated: 2025-12-24 11:00:00

cpu_usage_percent=25.5
memory_usage_percent=45.2
disk_root_usage_percent=60
network_rx_mb=1024.50
network_tx_mb=512.30
processes_total=156
uptime_days=5
```

### Check Agent Status

```bash
systemctl status glpi-agent
```

### Force Update

```bash
sudo glpi-agent --force
```

### View Logs

```bash
# Agent logs
sudo journalctl -u glpi-agent -f

# Metrics history
sudo tail -f /var/log/glpi-metrics.log
```

## 🔧 Manual Configuration

After installation, you can edit the configuration:

```bash
sudo nano /etc/glpi-agent/agent.cfg
```

Then restart:
```bash
sudo systemctl restart glpi-agent
```

## 📁 File Locations

| File/Directory | Purpose |
|---|---|
| `/usr/local/bin/glpi-metrics-collector` | Metrics collection script |
| `/etc/glpi-agent/agent.cfg` | Main configuration file |
| `/var/log/glpi-metrics.log` | Metrics history log |
| `/etc/cron.d/glpi-metrics` | Automatic metrics logging |

## 🎨 In GLPI Web Interface

After installation, go to your GLPI server:

1. **Assets** > **Computers**
2. Find your computer by name
3. View tabs:
   - **Main** - Basic info and last update time
   - **Components** - Hardware details
   - **Software** - Installed programs
   - **Impact analysis** - Visual relationship map
   - **Management** - Collect data (if configured)

## 🔄 Automatic Updates

The agent automatically updates GLPI with:
- New hardware changes
- Software installations/removals
- Network configuration changes
- System metrics

Update frequency: **Every 5 minutes** (configurable during installation)

## 🛠️ Troubleshooting

### Agent not connecting?

```bash
# Test connection
curl https://your-glpi-server.com/

# Check configuration
cat /etc/glpi-agent/agent.cfg

# View detailed logs
sudo glpi-agent --force --debug
```

### Computer not appearing in GLPI?

```bash
# Force immediate inventory
sudo glpi-agent --server=https://your-glpi-server.com/ --force

# Check logs for errors
sudo journalctl -u glpi-agent -n 50
```

## 📝 Requirements

- Linux operating system (Debian/Ubuntu/RHEL/CentOS/Fedora)
- Root access (sudo)
- Internet connection
- GLPI server (version 9.5+  recommended)

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - feel free to use in your organization!

## 🆘 Support

- **Issues**: Report bugs via GitHub Issues
- **Documentation**: See [GLPI Agent Documentation](https://glpi-agent.readthedocs.io/)
- **GLPI**: Visit [GLPI Project](https://glpi-project.org/)

## 🌟 Why Use This Installer?

| Feature | This Installer | Manual Setup |
|---|---|---|
| Installation Time | 2 minutes | 30+ minutes |
| Configuration | Interactive prompts | Manual editing |
| Error-prone | No | Yes |
| Metrics Collection | ✅ Included | ❌ Manual setup |
| Impact Analysis | ✅ Auto-enabled | ❌ Manual setup |
| Updates | ✅ Automatic | ⚠️ Manual |
| Multi-OS | ✅ Yes | ⚠️ OS-specific |

## 📊 Example Impact Analysis

After installation, GLPI will automatically build impact analysis showing:
- Connected network devices
- Dependent services
- Related applications
- User assignments
- Hardware relationships

## 🎯 Perfect For

- ✅ IT Administrators managing multiple computers
- ✅ Organizations with large IT infrastructure
- ✅ Asset management and inventory tracking
- ✅ Automated monitoring solutions
- ✅ Quick deployment scenarios

---

**Made with ❤️ for easy GLPI deployment**

*Last updated: 2025-12-24*
