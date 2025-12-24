# GLPI Agent Installer - Debugging Guide

## 🔍 How to Check What Failed

### Method 1: Run with Debug Output (Recommended)

Instead of hiding errors, run with visible output:

```bash
# Remove "> /dev/null 2>&1" redirections manually
# Or use this debug command:
sudo bash -x glpi-agent-installer.sh 2>&1 | tee install-debug.log
```

This will:
- Show every command being executed (`-x`)
- Save output to `install-debug.log`
- Display errors in real-time

---

### Method 2: Check Specific Steps

#### Step 1: Check if GLPI Agent Package Exists

```bash
# Try to download manually
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent_1.15-1_all.deb

# Check if download worked
ls -lh glpi-agent_*.deb
```

#### Step 2: Check Repository Access

```bash
# Test internet connection
ping -c 3 github.com

# Try adding repository manually
sudo curl -fsSL https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent.gpg.key

# Check if curl/wget installed
which curl wget
```

#### Step 3: Check Dependencies

```bash
# Check what's installed
dpkg -l | grep glpi

# Check for errors
sudo apt-get update
sudo apt-get install -f
```

---

### Method 3: Run Each Command Manually

```bash
# 1. Update packages
sudo apt-get update

# 2. Install curl/wget
sudo apt-get install -y curl wget

# 3. Try to install GLPI agent
sudo apt-get install -y glpi-agent

# If that fails, download directly:
cd /tmp
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent_1.15-1_all.deb
sudo dpkg -i glpi-agent_1.15-1_all.deb

# Fix dependencies if needed
sudo apt-get install -f -y
```

---

## 🐛 Common Failures and Solutions

### Error: "Package glpi-agent not found"

**Cause**: Repository not accessible or package name changed

**Solution**:
```bash
# Download directly
cd /tmp
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent_1.15-1_all.deb
sudo dpkg -i glpi-agent_1.15-1_all.deb
sudo apt-get install -f -y
```

---

### Error: "No space left on device"

**Cause**: Disk full

**Solution**:
```bash
# Check disk space
df -h

# Clean old packages
sudo apt-get clean
sudo apt-get autoremove
```

---

### Error: "Permission denied"

**Cause**: Not running as root

**Solution**:
```bash
# Always use sudo
sudo bash glpi-agent-installer.sh
```

---

### Error: "Cannot connect to repository"

**Cause**: Network issues or firewall

**Solution**:
```bash
# Check internet
ping -c 3 google.com

# Check DNS
nslookup github.com

# Try with different DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

---

### Error: Input not working over SSH

**Cause**: TTY issues (already fixed in latest version)

**Solution**:
- Make sure you're using the latest version with `/dev/tty` redirects
- Or run: `ssh -t user@host sudo bash script.sh`

---

## 📝 Debug Log Analysis

After running with `bash -x`, look for:

### 1. Last Successful Command
```bash
# Find the last "+" line before error
grep "^+" install-debug.log | tail -n 20
```

### 2. Error Messages
```bash
# Find error lines
grep -i "error\|fail\|cannot" install-debug.log
```

### 3. Package Installation Issues
```bash
# Check apt errors
grep -i "apt-get\|dpkg" install-debug.log
```

---

## 🔧 Create Debug Version

Create a debug version of the installer:

```bash
#!/bin/bash
# Debug version - shows all output

set -e  # Stop on error
set -x  # Show commands

# Run normal installer but without silent redirects
# Edit glpi-agent-installer.sh and remove all:
# > /dev/null 2>&1

# Or replace with:
# 2>&1 | tee -a /var/log/glpi-install.log
```

---

## 📊 Check System Requirements

```bash
# Check OS version
cat /etc/os-release

# Check architecture
uname -m

# Check available space
df -h /

# Check memory
free -h

# Check if systemd available
systemctl --version
```

---

## 🚀 Quick Debug Commands

Run these on the remote system:

```bash
# 1. System info
echo "=== System Info ==="
cat /etc/os-release
uname -a

# 2. Network test
echo "=== Network Test ==="
ping -c 2 github.com
curl -I https://github.com

# 3. Package manager test
echo "=== Package Manager ==="
sudo apt-get update
apt-cache policy glpi-agent

# 4. Check existing installation
echo "=== Existing GLPI ==="
which glpi-agent
systemctl status glpi-agent
```

---

## 📞 Share Debug Info

If you need help, collect this info:

```bash
# Create debug report
cat > glpi-debug-report.txt << EOF
OS: $(cat /etc/os-release | grep PRETTY_NAME)
Kernel: $(uname -r)
Arch: $(uname -m)
Space: $(df -h / | awk 'NR==2{print $4}')
Memory: $(free -h | awk 'NR==2{print $4}')
Network: $(ping -c 2 github.com && echo "OK" || echo "FAIL")
GLPI: $(dpkg -l | grep glpi || echo "Not installed")
EOF

cat glpi-debug-report.txt
```

---

## ✅ Successful Installation Check

After installation completes, verify:

```bash
# 1. Package installed
dpkg -l | grep glpi-agent

# 2. Service running
systemctl status glpi-agent

# 3. Configuration exists
cat /etc/glpi-agent/agent.cfg

# 4. Can execute
glpi-agent --version

# 5. Can collect metrics
/usr/local/bin/glpi-metrics-collector
```

---

## 🎯 Most Common Issue: Wrong Command

**Wrong:**
```bash
bash glpi-agent-installer.sh  # Missing sudo
```

**Correct:**
```bash
sudo bash glpi-agent-installer.sh
```

---

**For more help, check the logs in real-time:**
```bash
sudo journalctl -u glpi-agent -f
```
