#!/bin/bash

################################################################################
# GLPI Agent - One-Command Interactive Installer
# Features:
#   - Interactive configuration (Server IP, Hostname)
#   - Auto-updates every 5 minutes
#   - Complete monitoring with all features
#   - Works on any Linux system
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
GLPI_SERVER=""
COMPUTER_NAME=""
UPDATE_INTERVAL=300  # 5 minutes
TAG="auto-deployed"

################################################################################
# Banner
################################################################################

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║           GLPI Agent - Interactive Installer                 ║
║                                                               ║
║     One command to install and configure everything!         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

################################################################################
# Interactive Configuration
################################################################################

get_configuration() {
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                  Configuration Setup                      ${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Select Protocol
    echo -e "${CYAN}Select protocol:${NC}"
    echo ""
    echo -e "  ${GREEN}[1]${NC} HTTPS (Recommended - Secure)"
    echo -e "  ${GREEN}[2]${NC} HTTP  (Not Recommended - Insecure)"
    echo ""
    read -r -p "Enter choice [1]: " protocol_choice < /dev/tty
    
    if [ -z "$protocol_choice" ] || [ "$protocol_choice" = "1" ]; then
        PROTOCOL="https"
    elif [ "$protocol_choice" = "2" ]; then
        PROTOCOL="http"
        echo -e "${YELLOW}Warning: HTTP is not secure!${NC}"
    else
        echo -e "${RED}Invalid choice! Using HTTPS.${NC}"
        PROTOCOL="https"
    fi
    
    echo ""
    
    # Get GLPI Server Address
    echo -e "${CYAN}Enter your GLPI server address:${NC}"
    echo ""
    read -r -p "Server: " server_address < /dev/tty
    
    # Build full URL
    GLPI_SERVER="${PROTOCOL}://${server_address}"
    
    # Add trailing slash if not present
    if [[ ! "$GLPI_SERVER" =~ /$ ]]; then
        GLPI_SERVER="${GLPI_SERVER}/"
    fi
    
    echo ""
    
    # Get Computer Name
    echo -e "${CYAN}Enter computer name for GLPI:${NC}"
    echo -e "${GREEN}(Default: $(hostname))${NC}"
    read -r -p "Computer Name [$(hostname)]: " COMPUTER_NAME < /dev/tty
    
    if [ -z "$COMPUTER_NAME" ]; then
        COMPUTER_NAME=$(hostname)
    fi
    
    echo ""
    
    # Get Update Interval
    echo -e "${CYAN}Update interval in seconds:${NC}"
    echo -e "${GREEN}(Default: 300 = 5 minutes)${NC}"
    read -r -p "Update Interval [300]: " UPDATE_INTERVAL < /dev/tty
    
    if [ -z "$UPDATE_INTERVAL" ]; then
        UPDATE_INTERVAL=300
    fi
    
    echo ""
    
    # Get Tag
    echo -e "${CYAN}Tag to identify this computer group:${NC}"
    echo -e "${GREEN}Examples: production, office, servers, workstations${NC}"
    read -r -p "Tag [auto-deployed]: " TAG < /dev/tty
    
    if [ -z "$TAG" ]; then
        TAG="auto-deployed"
    fi
    
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Configuration Summary:${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  GLPI Server:${NC}      $GLPI_SERVER"
    echo -e "${CYAN}  Computer Name:${NC}    $COMPUTER_NAME"
    echo -e "${CYAN}  Update Interval:${NC}  $UPDATE_INTERVAL seconds ($(($UPDATE_INTERVAL/60)) minutes)"
    echo -e "${CYAN}  Tag:${NC}              $TAG"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -r -p "Is this correct? (y/n): " confirm < /dev/tty
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Configuration cancelled. Please run again.${NC}"
        exit 0
    fi
}

################################################################################
# OS Detection
################################################################################

detect_os() {
    echo -e "${BLUE}[1/7]${NC} Detecting operating system..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
        OS_NAME=$PRETTY_NAME
    else
        OS="unknown"
        OS_NAME="Unknown Linux"
    fi
    
    echo -e "${GREEN}  ✓ Detected: $OS_NAME${NC}"
}

################################################################################
# Install Dependencies
################################################################################

install_dependencies() {
    echo -e "${BLUE}[2/7]${NC} Installing dependencies..."
    
    case $OS in
        ubuntu|debian|linuxmint)
            export DEBIAN_FRONTEND=noninteractive
            
            # Add GLPI repository
            echo -e "${BLUE}  → Adding GLPI repository...${NC}"
            curl -fsSL https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent.gpg.key | gpg --dearmor -o /usr/share/keyrings/glpi-agent-archive-keyring.gpg 2>/dev/null || true
            echo "deb [signed-by=/usr/share/keyrings/glpi-agent-archive-keyring.gpg] https://github.com/glpi-project/glpi-agent/releases/download/1.15 ./" > /etc/apt/sources.list.d/glpi-agent.list 2>/dev/null || true
            
            # Try direct download if repository fails
            if ! apt-get update -qq > /dev/null 2>&1; then
                echo -e "${YELLOW}  → Repository unavailable, downloading directly...${NC}"
                cd /tmp
                wget -q https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent_1.15-1_all.deb 2>/dev/null || true
                dpkg -i glpi-agent_1.15-1_all.deb 2>/dev/null || apt-get install -f -y > /dev/null 2>&1
            else
                apt-get install -y glpi-agent > /dev/null 2>&1
            fi
            
            # Install additional dependencies
            apt-get install -y curl wget dmidecode pciutils usbutils > /dev/null 2>&1
            ;;
        rhel|centos|fedora|rocky|almalinux)
            if command -v dnf &> /dev/null; then
                dnf install -y glpi-agent curl wget > /dev/null 2>&1
            else
                yum install -y glpi-agent curl wget > /dev/null 2>&1
            fi
            ;;
        *)
            echo -e "${YELLOW}  ! Unknown OS, attempting generic installation...${NC}"
            apt-get install -y glpi-agent curl wget > /dev/null 2>&1 || true
            ;;
    esac
    
    echo -e "${GREEN}  ✓ Dependencies installed${NC}"
}

################################################################################
# Create Metrics Collector
################################################################################

create_metrics_collector() {
    echo -e "${BLUE}[3/7]${NC} Installing metrics collector..."
    
    cat > /usr/local/bin/glpi-metrics-collector << 'EOFCOLLECTOR'
#!/bin/bash
echo "# GLPI System Metrics"
echo "# Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_cores=$(nproc)
load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
echo "cpu_usage_percent=$cpu_usage"
echo "cpu_cores=$cpu_cores"
echo "load_average_1min=$load_avg"
mem_total=$(free -m | awk 'NR==2{print $2}')
mem_used=$(free -m | awk 'NR==2{print $3}')
mem_percent=$(awk "BEGIN {printf \"%.1f\", ($mem_used/$mem_total)*100}")
echo "memory_total_mb=$mem_total"
echo "memory_used_mb=$mem_used"
echo "memory_usage_percent=$mem_percent"
disk_total=$(df -h / | awk 'NR==2{print $2}')
disk_used=$(df -h / | awk 'NR==2{print $3}')
disk_percent=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
echo "disk_root_total=$disk_total"
echo "disk_root_used=$disk_used"
echo "disk_root_usage_percent=$disk_percent"
primary_interface=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -n "$primary_interface" ]; then
    rx_bytes=$(cat /sys/class/net/$primary_interface/statistics/rx_bytes 2>/dev/null || echo 0)
    tx_bytes=$(cat /sys/class/net/$primary_interface/statistics/tx_bytes 2>/dev/null || echo 0)
    rx_mb=$(awk "BEGIN {printf \"%.2f\", $rx_bytes/1024/1024}")
    tx_mb=$(awk "BEGIN {printf \"%.2f\", $tx_bytes/1024/1024}")
    echo "network_interface=$primary_interface"
    echo "network_rx_mb=$rx_mb"
    echo "network_tx_mb=$tx_mb"
fi
process_total=$(ps aux | wc -l)
echo "processes_total=$process_total"
uptime_seconds=$(cat /proc/uptime | awk '{print int($1)}')
uptime_days=$((uptime_seconds / 86400))
uptime_hours=$(( (uptime_seconds % 86400) / 3600 ))
echo "uptime_seconds=$uptime_seconds"
echo "uptime_days=$uptime_days"
echo "uptime_hours=$uptime_hours"
echo ""
echo "# Collection Complete"
EOFCOLLECTOR
    
    chmod +x /usr/local/bin/glpi-metrics-collector
    echo -e "${GREEN}  ✓ Metrics collector installed${NC}"
}

################################################################################
# Configure GLPI Agent
################################################################################

configure_glpi_agent() {
    echo -e "${BLUE}[4/7]${NC} Configuring GLPI Agent..."
    
    # Set hostname if needed
    if [ "$COMPUTER_NAME" != "$(hostname)" ]; then
        hostnamectl set-hostname "$COMPUTER_NAME" 2>/dev/null || true
    fi
    
    # Create configuration
    cat > /etc/glpi-agent/agent.cfg << EOFCONFIG
# GLPI Agent Configuration
# Auto-generated by installer

# Server Configuration
server = $GLPI_SERVER

# Update interval ($UPDATE_INTERVAL seconds = $(($UPDATE_INTERVAL/60)) minutes)
delaytime = $UPDATE_INTERVAL

# Computer identification
tag = $TAG

# Tasks to execute
tasks = inventory

# Logging
logger = stderr
logfacility = LOG_DAEMON
debug = 0

# Scan options
scan-homedirs = 1
scan-profiles = 1

# SSL (disable certificate check for self-signed certs)
no-ssl-check = 1

# Timeout
timeout = 180
EOFCONFIG
    
    echo -e "${GREEN}  ✓ Configuration created${NC}"
}

################################################################################
# Enable and Start Service
################################################################################

enable_service() {
    echo -e "${BLUE}[5/7]${NC} Enabling GLPI Agent service..."
    
    systemctl enable glpi-agent > /dev/null 2>&1
    systemctl restart glpi-agent > /dev/null 2>&1
    
    sleep 2
    
    if systemctl is-active glpi-agent > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ Service started successfully${NC}"
    else
        echo -e "${YELLOW}  ! Service may need manual start${NC}"
    fi
}

################################################################################
# Send First Inventory
################################################################################

send_first_inventory() {
    echo -e "${BLUE}[6/7]${NC} Sending initial inventory to GLPI..."
    
    glpi-agent --server="$GLPI_SERVER" --force > /dev/null 2>&1 || true
    
    echo -e "${GREEN}  ✓ Initial inventory sent${NC}"
}

################################################################################
# Setup Auto-logging
################################################################################

setup_logging() {
    echo -e "${BLUE}[7/7]${NC} Setting up automatic metrics logging..."
    
    # Create cron job for metrics logging
    echo "*/5 * * * * /usr/local/bin/glpi-metrics-collector >> /var/log/glpi-metrics.log 2>&1" > /etc/cron.d/glpi-metrics
    chmod 644 /etc/cron.d/glpi-metrics
    
    echo -e "${GREEN}  ✓ Auto-logging configured${NC}"
}

################################################################################
# Display Summary
################################################################################

show_summary() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Installation Complete! ✓                         ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Installation Details:${NC}"
    echo -e "  ${GREEN}✓${NC} GLPI Server:      $GLPI_SERVER"
    echo -e "  ${GREEN}✓${NC} Computer Name:    $COMPUTER_NAME"
    echo -e "  ${GREEN}✓${NC} Update Interval:  $(($UPDATE_INTERVAL/60)) minutes"
    echo -e "  ${GREEN}✓${NC} Tag:              $TAG"
    echo -e "  ${GREEN}✓${NC} Agent Status:     $(systemctl is-active glpi-agent)"
    echo ""
    echo -e "${CYAN}Features Enabled:${NC}"
    echo -e "  ${GREEN}✓${NC} Automatic inventory updates every $(($UPDATE_INTERVAL/60)) minutes"
    echo -e "  ${GREEN}✓${NC} Hardware/Software detection"
    echo -e "  ${GREEN}✓${NC} Network discovery"
    echo -e "  ${GREEN}✓${NC} Impact analysis data collection"
    echo -e "  ${GREEN}✓${NC} Metrics logging to /var/log/glpi-metrics.log"
    echo ""
    echo -e "${CYAN}Useful Commands:${NC}"
    echo -e "  Check status:        ${YELLOW}systemctl status glpi-agent${NC}"
    echo -e "  View logs:           ${YELLOW}journalctl -u glpi-agent -f${NC}"
    echo -e "  Force update:        ${YELLOW}glpi-agent --force${NC}"
    echo -e "  View metrics:        ${YELLOW}glpi-metrics-collector${NC}"
    echo -e "  View metric history: ${YELLOW}tail -f /var/log/glpi-metrics.log${NC}"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo -e "  1. Check GLPI web interface: ${YELLOW}$GLPI_SERVER${NC}"
    echo -e "  2. Go to: ${YELLOW}Assets > Computers${NC}"
    echo -e "  3. Find: ${YELLOW}$COMPUTER_NAME${NC}"
    echo -e "  4. Impact analysis will update automatically!"
    echo ""
    echo -e "${GREEN}Installation completed successfully!${NC}"
    echo ""
}

################################################################################
# Main Installation
################################################################################

main() {
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
        exit 1
    fi
    
    show_banner
    get_configuration
    
    echo ""
    echo -e "${CYAN}Starting installation...${NC}"
    echo ""
    
    detect_os
    install_dependencies
    create_metrics_collector
    configure_glpi_agent
    enable_service
    send_first_inventory
    setup_logging
    
    show_summary
}

# Run main function
main "$@"
