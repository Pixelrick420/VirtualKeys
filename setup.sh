#!/bin/bash

# VirtualKeys Setup Script for KDE Plasma Kubuntu
# This script installs all dependencies, clones the repo, sets up venv, and creates desktop shortcut

set -e  

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/Pixelrick420/VirtualKeys"
APP_NAME="VirtualKeys"
INSTALL_DIR="$HOME/Applications/$APP_NAME"
DESKTOP_FILE="$HOME/Desktop/VirtualKeys.desktop"
APPLICATIONS_DIR="$HOME/.local/share/applications"

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_package() {
    local package=$1
    if ! dpkg -l | grep -q "^ii  $package "; then
        print_status "Installing $package..."
        sudo apt update >/dev/null 2>&1
        sudo apt install -y "$package"
        print_success "$package installed successfully"
    else
        print_status "$package is already installed"
    fi
}

install_dependencies() {
    print_status "Checking and installing system dependencies..."
    
    print_status "Updating package list..."
    sudo apt update
    
    if ! command_exists git; then
        print_status "Git not found. Installing git..."
        install_package git
    else
        print_success "Git is already installed"
    fi
    
    if ! command_exists python3; then
        print_status "Python3 not found. Installing python3..."
        install_package python3
    else
        print_success "Python3 is already installed"
    fi
    
    if ! command_exists pip3; then
        print_status "pip3 not found. Installing python3-pip..."
        install_package python3-pip
    else
        print_success "pip3 is already installed"
    fi
    
    if ! python3 -c "import venv" 2>/dev/null; then
        print_status "python3-venv not found. Installing python3-venv..."
        install_package python3-venv
    else
        print_success "python3-venv is already available"
    fi
    
    print_status "Installing additional dependencies for PyQt5..."
    install_package python3-dev
    install_package python3-distutils
    install_package build-essential
    
    install_package qtbase5-dev
    install_package qttools5-dev-tools
    
    print_success "All system dependencies installed successfully"
}

clone_repository() {
    print_status "Setting up application directory..."
    
    mkdir -p "$HOME/Applications"
    
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Existing installation found. Removing..."
        rm -rf "$INSTALL_DIR"
    fi
    
    print_status "Cloning VirtualKeys repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    
    if [ -d "$INSTALL_DIR" ]; then
        print_success "Repository cloned successfully to $INSTALL_DIR"
    else
        print_error "Failed to clone repository"
        exit 1
    fi
}

setup_virtual_environment() {
    print_status "Setting up Python virtual environment..."
    
    cd "$INSTALL_DIR"

    python3 -m venv venv

    source venv/bin/activate
    
    print_status "Upgrading pip in virtual environment..."
    pip install --upgrade pip
    
    print_status "Installing application requirements..."
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        print_warning "requirements.txt not found. Installing PyQt5 manually..."
        pip install PyQt5==5.15.11
    fi
    
    deactivate
    print_success "Virtual environment setup completed"
}

create_desktop_shortcut() {
    print_status "Creating desktop shortcut..."
    
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=VirtualKeys
Comment=Virtual Keyboard for KDE Plasma
Exec=bash -c "cd '$INSTALL_DIR' && source venv/bin/activate && python run.py"
Icon=$INSTALL_DIR/app/icon.png
Terminal=false
Categories=Utility;Accessibility;
Keywords=keyboard;virtual;accessibility;
StartupNotify=true
EOF
    chmod +x "$DESKTOP_FILE"
    
    mkdir -p "$APPLICATIONS_DIR"
    cp "$DESKTOP_FILE" "$APPLICATIONS_DIR/VirtualKeys.desktop"
    
    if [ ! -f "$INSTALL_DIR/app/icon.png" ]; then
        print_warning "Icon file not found. Creating a placeholder icon reference..."
        sed -i "s|Icon=.*|Icon=input-keyboard|" "$DESKTOP_FILE"
        sed -i "s|Icon=.*|Icon=input-keyboard|" "$APPLICATIONS_DIR/VirtualKeys.desktop"
    fi
    
    print_success "Desktop shortcut created successfully"
    print_status "Shortcut location: $DESKTOP_FILE"
    print_status "Applications menu entry: $APPLICATIONS_DIR/VirtualKeys.desktop"
}

create_launcher_script() {
    print_status "Creating launcher script..."
    
    cat > "$INSTALL_DIR/launch_virtualkeys.sh" << 'EOF'
#!/bin/bash
# VirtualKeys Launcher Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Activate virtual environment and run the application
source venv/bin/activate
python run.py
EOF

    chmod +x "$INSTALL_DIR/launch_virtualkeys.sh"
    print_success "Launcher script created: $INSTALL_DIR/launch_virtualkeys.sh"
}

test_installation() {
    print_status "Testing installation..."
    
    cd "$INSTALL_DIR"
    source venv/bin/activate
    
    if python -c "import PyQt5.QtWidgets; print('PyQt5 import successful')" 2>/dev/null; then
        print_success "PyQt5 installation verified"
    else
        print_error "PyQt5 installation test failed"
        return 1
    fi
    
    if [ -f "run.py" ] && [ -r "run.py" ]; then
        print_success "Main application script found and accessible"
    else
        print_error "Main application script (run.py) not found or not readable"
        return 1
    fi
    
    deactivate
    print_success "Installation test completed successfully"
}

main() {
    print_status "Starting VirtualKeys installation..."
    echo "=================================="
    
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run this script as root (don't use sudo)"
        exit 1
    fi
    
    if ! command_exists sudo; then
        print_error "sudo is required but not installed. Please install sudo first."
        exit 1
    fi
    
    print_status "Checking sudo access..."
    if ! sudo -n true 2>/dev/null; then
        print_warning "This script requires sudo access to install system packages."
        print_status "You may be prompted for your password."
        sudo -v
    fi
    
    install_dependencies
    clone_repository
    setup_virtual_environment
    create_launcher_script
    create_desktop_shortcut
    test_installation
    
    echo "=================================="
    print_success "VirtualKeys installation completed successfully!"
    echo ""
    print_status "Installation Summary:"
    echo "  • Application installed in: $INSTALL_DIR"
    echo "  • Desktop shortcut created: $DESKTOP_FILE"
    echo "  • Applications menu entry created"
    echo "  • Launcher script: $INSTALL_DIR/launch_virtualkeys.sh"
    echo ""
    print_status "To run VirtualKeys:"
    echo "  1. Double-click the desktop shortcut"
    echo "  2. Find 'VirtualKeys' in your applications menu"
    echo "  3. Run: $INSTALL_DIR/launch_virtualkeys.sh"
    echo "  4. Or manually: cd '$INSTALL_DIR' && source venv/bin/activate && python run.py"
    echo ""
    print_warning "Note: If you encounter any Qt-related issues, you may need to install additional Qt packages."
    print_status "Installation log completed at $(date)"
}

trap 'print_error "Installation interrupted by user"; exit 130' INT
main "$@"