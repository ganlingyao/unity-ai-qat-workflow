#!/bin/bash
# ============================================================================
# Unity AI QAT Workflow - Installation Script
# 
# Remote install: curl -fsSL https://raw.githubusercontent.com/ganlingyao/unity-ai-qat-workflow/main/install.sh | bash
# Local install: ./install.sh [target project path]
# ============================================================================

# Don't use set -e, handle errors manually for better error messages
# set -e

# Configuration
REPO_URL="https://raw.githubusercontent.com/ganlingyao/unity-ai-qat-workflow/main"

# Cursor command files
COMMANDS_DIR=".cursor/commands"
COMMANDS=(
    "debug.md"
    "fixer.md"
    "tester.md"
    "plan-workflow.md"
)

# Built-in standard documents
STANDARDS_DIR=".cursor/standards"
STANDARDS=(
    "csharp-coding-standard.md"
    "development-standard.md"
)

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
INSTALL_MODE=""        # "local" or "remote"
LOCAL_REPO_DIR=""      # Local repository directory
TARGET_PROJECT_DIR=""  # Target project directory

# Print colored messages
print_info() {
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

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Show Banner
show_banner() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║         Unity AI QAT Workflow - Installer                     ║"
    echo "║         Install Unity Development Commands for Cursor         ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Check if path is absolute (supports Unix and Windows formats)
is_absolute_path() {
    local path="$1"
    # Unix absolute path: /xxx
    # Windows absolute path: C:/xxx, D:\xxx, /c/xxx (Git Bash format)
    if [[ "$path" = /* ]] || [[ "$path" =~ ^[A-Za-z]:[\\/] ]] || [[ "$path" =~ ^[A-Za-z]: ]]; then
        return 0
    fi
    return 1
}

# Validate if directory exists
validate_directory() {
    local path="$1"
    if [[ -d "$path" ]]; then
        return 0
    fi
    return 1
}

# Resolve and validate target path
resolve_target_path() {
    local input_path="$1"
    local resolved_path=""
    
    # If absolute path, validate directly
    if is_absolute_path "$input_path"; then
        if validate_directory "$input_path"; then
            # Try to get canonical path
            resolved_path="$(cd "$input_path" 2>/dev/null && pwd)" || resolved_path="$input_path"
            echo "$resolved_path"
            return 0
        else
            return 1
        fi
    else
        # Relative path, need to resolve
        resolved_path="$(cd "$input_path" 2>/dev/null && pwd)" || return 1
        echo "$resolved_path"
        return 0
    fi
}

# Detect installation mode (local or remote)
detect_install_mode() {
    # Get script directory
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if script directory has commands/ directory (means running from repo)
    if [[ -d "$script_dir/commands" && -d "$script_dir/standards" ]]; then
        INSTALL_MODE="local"
        LOCAL_REPO_DIR="$script_dir"
        
        print_info "Detected local repository: $LOCAL_REPO_DIR"
        
        # If argument provided, use it as target directory
        if [[ -n "$1" ]]; then
            local input_path="$1"
            print_info "Target path argument: $input_path"
            
            # Resolve target path
            TARGET_PROJECT_DIR="$(resolve_target_path "$input_path")"
            if [[ -z "$TARGET_PROJECT_DIR" ]]; then
                print_error "Target directory does not exist: $input_path"
                echo ""
                echo "Please check if the path is correct."
                echo "Tip: In Git Bash, Windows paths can be written as:"
                echo "  D:/Work/MyProject or /d/Work/MyProject"
                exit 1
            fi
            
            # Check if target directory is the repo directory itself
            if [[ "$TARGET_PROJECT_DIR" == "$LOCAL_REPO_DIR" ]]; then
                print_error "Cannot install to the repository directory itself!"
                print_info "Please specify your Unity project directory"
                exit 1
            fi
        else
            # No argument provided, must prompt user for target path
            echo ""
            echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
            echo -e "${CYAN}📦 Local installation mode detected${NC}"
            echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
            echo ""
            echo "You are running the install script from the local repository."
            echo ""
            echo -e "${YELLOW}Please enter the Unity project directory path to install to:${NC}"
            echo "(e.g., ../my-unity-game or D:/Work/MyProject)"
            echo ""
            read -p "Project path: " input_path
            
            if [[ -z "$input_path" ]]; then
                print_error "Path cannot be empty"
                echo ""
                echo "Usage: ./install.sh <target project path>"
                echo "Example: ./install.sh ../my-unity-project"
                echo "Example: ./install.sh D:/Work/MyProject"
                exit 1
            fi
            
            # Resolve target path
            TARGET_PROJECT_DIR="$(resolve_target_path "$input_path")"
            if [[ -z "$TARGET_PROJECT_DIR" ]]; then
                print_error "Directory does not exist: $input_path"
                exit 1
            fi
            
            # Check if target directory is the repo directory itself
            if [[ "$TARGET_PROJECT_DIR" == "$LOCAL_REPO_DIR" ]]; then
                print_error "Cannot install to the repository directory itself!"
                print_info "Please specify your Unity project directory"
                exit 1
            fi
        fi
        
        print_info "Local installation mode"
        print_info "Source: $LOCAL_REPO_DIR"
        print_info "Target: $TARGET_PROJECT_DIR"
        
        # Switch to target project directory
        if ! cd "$TARGET_PROJECT_DIR" 2>/dev/null; then
            print_error "Cannot enter directory: $TARGET_PROJECT_DIR"
            exit 1
        fi
        
        print_success "Switched to target directory"
    else
        INSTALL_MODE="remote"
        TARGET_PROJECT_DIR="$(pwd)"
        print_info "Remote installation mode"
    fi
}

# Check if in project root directory
check_project_root() {
    # Check if common project identifier files exist
    if [[ ! -d ".git" && ! -f "package.json" && ! -d "Assets" && ! -f "*.sln" ]]; then
        print_warning "Current directory may not be a project root: $(pwd)"
        print_info "It is recommended to run this script in the project root"
        read -p "Continue installation? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
}

# Detect download tool (only needed for remote mode)
detect_downloader() {
    if [[ "$INSTALL_MODE" == "local" ]]; then
        return
    fi
    
    if command -v curl &> /dev/null; then
        DOWNLOADER="curl"
    elif command -v wget &> /dev/null; then
        DOWNLOADER="wget"
    else
        print_error "Neither curl nor wget found, please install one of them"
        exit 1
    fi
    print_info "Using $DOWNLOADER to download files"
}

# Download file (remote mode)
download_file() {
    local url="$1"
    local output="$2"
    
    if [[ "$DOWNLOADER" == "curl" ]]; then
        curl -fsSL "$url" -o "$output"
    else
        wget -q "$url" -O "$output"
    fi
}

# Copy file (local mode)
copy_file() {
    local src="$1"
    local dst="$2"
    
    if [[ -f "$src" ]]; then
        cp "$src" "$dst"
        return 0
    else
        return 1
    fi
}

# Get file (choose download or copy based on mode)
get_file() {
    local remote_path="$1"  # e.g., "commands/debug-console.md"
    local output="$2"
    
    if [[ "$INSTALL_MODE" == "local" ]]; then
        local src="$LOCAL_REPO_DIR/$remote_path"
        copy_file "$src" "$output"
    else
        local url="$REPO_URL/$remote_path"
        download_file "$url" "$output"
    fi
}

# Create target directory
create_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        print_info "Creating directory: $dir"
        mkdir -p "$dir"
    fi
}

# Backup existing file
backup_existing() {
    local filepath="$1"
    
    if [[ -f "$filepath" ]]; then
        local backup_name="${filepath}.backup.$(date +%Y%m%d%H%M%S)"
        print_warning "File exists, backing up to: $backup_name"
        mv "$filepath" "$backup_name"
    fi
}

# Install Cursor command files
install_commands() {
    print_step "Installing Cursor command files..."
    echo ""
    
    create_dir "$COMMANDS_DIR"
    
    local success_count=0
    local fail_count=0
    local action_word=$([[ "$INSTALL_MODE" == "local" ]] && echo "Copying" || echo "Downloading")
    
    for cmd in "${COMMANDS[@]}"; do
        local output="$COMMANDS_DIR/$cmd"
        
        # Backup existing file
        backup_existing "$output"
        
        echo -n "  $action_word $cmd ... "
        if get_file "commands/$cmd" "$output" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
            ((success_count++))
        else
            echo -e "${RED}✗${NC}"
            ((fail_count++))
        fi
    done
    
    echo ""
    print_info "Cursor commands: ${success_count} succeeded, ${fail_count} failed"
}

# Install built-in standard documents
install_standards() {
    print_step "Installing standard documents..."
    echo ""
    
    create_dir "$STANDARDS_DIR"
    
    local success_count=0
    local fail_count=0
    local action_word=$([[ "$INSTALL_MODE" == "local" ]] && echo "Copying" || echo "Downloading")
    
    for doc in "${STANDARDS[@]}"; do
        local output="$STANDARDS_DIR/$doc"
        
        # Backup existing file
        backup_existing "$output"
        
        echo -n "  $action_word $doc ... "
        if get_file "standards/$doc" "$output" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
            ((success_count++))
        else
            echo -e "${RED}✗${NC}"
            ((fail_count++))
        fi
    done
    
    echo ""
    print_info "Standard documents: ${success_count} succeeded, ${fail_count} failed"
}

# Show installation result
show_result() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    print_success "Installation complete!"
    echo ""
    echo "Install location: $TARGET_PROJECT_DIR"
    echo ""
    echo "Installed Cursor commands:"
    echo "  /debug          - Unity console debugging"
    echo "  /fixer          - Fix console errors"
    echo "  /tester         - Run tests and generate report"
    echo "  /plan-workflow  - Development workflow planning"
    echo ""
    echo "Installed standard documents:"
    echo "  .cursor/standards/csharp-coding-standard.md  - C# coding standard"
    echo "  .cursor/standards/development-standard.md    - Development workflow standard"
    echo ""
    echo "Usage: Type /command-name in Cursor to trigger"
    echo ""
    echo "First time using /plan-workflow:"
    echo "  - You will be prompted to configure design docs, output docs, and standard docs paths"
    echo "  - If no project standards exist, built-in standards will be used"
    echo ""
    echo -e "${YELLOW}⚠️  Prerequisites:${NC}"
    echo "  - Unity MCP >= 8.3.0: https://github.com/CoplayDev/unity-mcp"
    echo "  - /run-tests-report command requires Unity MCP 8.3.0+ run_tests feature"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
}

# Main function
main() {
    show_banner
    detect_install_mode "$1"
    check_project_root
    detect_downloader
    install_commands
    install_standards
    show_result
}

# Run main function, pass first argument as target directory
main "$1"
