#!/bin/bash
# ============================================================================
# Unity AI QAT Workflow - 一键安装脚本
# 
# 远程安装: curl -fsSL https://raw.githubusercontent.com/ganlingyao/unity-ai-qat-workflow/main/install.sh | bash
# 本地安装: ./install.sh [目标项目路径]
# ============================================================================

# 不使用 set -e，手动处理错误以提供更好的错误信息
# set -e

# 配置
REPO_URL="https://raw.githubusercontent.com/ganlingyao/unity-ai-qat-workflow/main"

# Cursor 指令文件
COMMANDS_DIR=".cursor/commands"
COMMANDS=(
    "debug.md"
    "fixer.md"
    "tester.md"
    "plan-workflow.md"
)

# 内置规范文档
STANDARDS_DIR=".cursor/standards"
STANDARDS=(
    "csharp-coding-standard.md"
    "development-standard.md"
)

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 全局变量
INSTALL_MODE=""        # "local" 或 "remote"
LOCAL_REPO_DIR=""      # 本地仓库目录
TARGET_PROJECT_DIR=""  # 目标项目目录

# 打印带颜色的消息
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

# 显示 Banner
show_banner() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║         Unity AI QAT Workflow - 安装程序                      ║"
    echo "║         为 Cursor 安装 Unity 开发辅助指令                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
}

# 检查路径是否是绝对路径（支持 Unix 和 Windows 格式）
is_absolute_path() {
    local path="$1"
    # Unix 绝对路径: /xxx
    # Windows 绝对路径: C:/xxx, D:\xxx, /c/xxx (Git Bash 格式)
    if [[ "$path" = /* ]] || [[ "$path" =~ ^[A-Za-z]:[\\/] ]] || [[ "$path" =~ ^[A-Za-z]: ]]; then
        return 0
    fi
    return 1
}

# 验证目录是否存在
validate_directory() {
    local path="$1"
    if [[ -d "$path" ]]; then
        return 0
    fi
    return 1
}

# 解析并验证目标路径
resolve_target_path() {
    local input_path="$1"
    local resolved_path=""
    
    # 如果是绝对路径，直接验证
    if is_absolute_path "$input_path"; then
        if validate_directory "$input_path"; then
            # 尝试获取规范化路径
            resolved_path="$(cd "$input_path" 2>/dev/null && pwd)" || resolved_path="$input_path"
            echo "$resolved_path"
            return 0
        else
            return 1
        fi
    else
        # 相对路径，需要解析
        resolved_path="$(cd "$input_path" 2>/dev/null && pwd)" || return 1
        echo "$resolved_path"
        return 0
    fi
}

# 检测安装模式（本地 or 远程）
detect_install_mode() {
    # 获取脚本所在目录
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 检查脚本所在目录是否有 commands/ 目录（说明在仓库中）
    if [[ -d "$script_dir/commands" && -d "$script_dir/standards" ]]; then
        INSTALL_MODE="local"
        LOCAL_REPO_DIR="$script_dir"
        
        print_info "检测到本地仓库目录: $LOCAL_REPO_DIR"
        
        # 如果提供了参数，使用参数作为目标目录
        if [[ -n "$1" ]]; then
            local input_path="$1"
            print_info "目标路径参数: $input_path"
            
            # 解析目标路径
            TARGET_PROJECT_DIR="$(resolve_target_path "$input_path")"
            if [[ -z "$TARGET_PROJECT_DIR" ]]; then
                print_error "目标目录不存在: $input_path"
                echo ""
                echo "请检查路径是否正确。"
                echo "提示：在 Git Bash 中，Windows 路径可以写成："
                echo "  D:/Work/MyProject 或 /d/Work/MyProject"
                exit 1
            fi
            
            # 检查目标目录是否就是仓库目录
            if [[ "$TARGET_PROJECT_DIR" == "$LOCAL_REPO_DIR" ]]; then
                print_error "不能安装到仓库目录本身！"
                print_info "请指定你的 Unity 项目目录"
                exit 1
            fi
        else
            # 没有提供参数，必须让用户输入目标路径
            echo ""
            echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
            echo -e "${CYAN}📦 检测到本地安装模式${NC}"
            echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
            echo ""
            echo "你正在从本地仓库运行安装脚本。"
            echo ""
            echo -e "${YELLOW}请输入要安装到的 Unity 项目目录路径：${NC}"
            echo "(例如: ../my-unity-game 或 D:/Work/MyProject)"
            echo ""
            read -p "项目路径: " input_path
            
            if [[ -z "$input_path" ]]; then
                print_error "路径不能为空"
                echo ""
                echo "用法: ./install.sh <目标项目路径>"
                echo "示例: ./install.sh ../my-unity-project"
                echo "示例: ./install.sh D:/Work/MyProject"
                exit 1
            fi
            
            # 解析目标路径
            TARGET_PROJECT_DIR="$(resolve_target_path "$input_path")"
            if [[ -z "$TARGET_PROJECT_DIR" ]]; then
                print_error "目录不存在: $input_path"
                exit 1
            fi
            
            # 检查目标目录是否就是仓库目录
            if [[ "$TARGET_PROJECT_DIR" == "$LOCAL_REPO_DIR" ]]; then
                print_error "不能安装到仓库目录本身！"
                print_info "请指定你的 Unity 项目目录"
                exit 1
            fi
        fi
        
        print_info "本地安装模式"
        print_info "源目录: $LOCAL_REPO_DIR"
        print_info "目标目录: $TARGET_PROJECT_DIR"
        
        # 切换到目标项目目录
        if ! cd "$TARGET_PROJECT_DIR" 2>/dev/null; then
            print_error "无法进入目录: $TARGET_PROJECT_DIR"
            exit 1
        fi
        
        print_success "已切换到目标目录"
    else
        INSTALL_MODE="remote"
        TARGET_PROJECT_DIR="$(pwd)"
        print_info "远程安装模式"
    fi
}

# 检查是否在项目根目录
check_project_root() {
    # 检查是否存在常见的项目标识文件
    if [[ ! -d ".git" && ! -f "package.json" && ! -d "Assets" && ! -f "*.sln" ]]; then
        print_warning "当前目录可能不是项目根目录: $(pwd)"
        print_info "建议在项目根目录运行此脚本"
        read -p "是否继续安装？(y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "安装已取消"
            exit 0
        fi
    fi
}

# 检测下载工具（仅远程模式需要）
detect_downloader() {
    if [[ "$INSTALL_MODE" == "local" ]]; then
        return
    fi
    
    if command -v curl &> /dev/null; then
        DOWNLOADER="curl"
    elif command -v wget &> /dev/null; then
        DOWNLOADER="wget"
    else
        print_error "未找到 curl 或 wget，请先安装其中一个"
        exit 1
    fi
    print_info "使用 $DOWNLOADER 下载文件"
}

# 下载文件（远程模式）
download_file() {
    local url="$1"
    local output="$2"
    
    if [[ "$DOWNLOADER" == "curl" ]]; then
        curl -fsSL "$url" -o "$output"
    else
        wget -q "$url" -O "$output"
    fi
}

# 复制文件（本地模式）
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

# 获取文件（根据模式选择下载或复制）
get_file() {
    local remote_path="$1"  # 如 "commands/debug-console.md"
    local output="$2"
    
    if [[ "$INSTALL_MODE" == "local" ]]; then
        local src="$LOCAL_REPO_DIR/$remote_path"
        copy_file "$src" "$output"
    else
        local url="$REPO_URL/$remote_path"
        download_file "$url" "$output"
    fi
}

# 创建目标目录
create_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        print_info "创建目录: $dir"
        mkdir -p "$dir"
    fi
}

# 备份已存在的文件
backup_existing() {
    local filepath="$1"
    
    if [[ -f "$filepath" ]]; then
        local backup_name="${filepath}.backup.$(date +%Y%m%d%H%M%S)"
        print_warning "文件已存在，备份到: $backup_name"
        mv "$filepath" "$backup_name"
    fi
}

# 安装 Cursor 指令文件
install_commands() {
    print_step "安装 Cursor 指令文件..."
    echo ""
    
    create_dir "$COMMANDS_DIR"
    
    local success_count=0
    local fail_count=0
    local action_word=$([[ "$INSTALL_MODE" == "local" ]] && echo "复制" || echo "下载")
    
    for cmd in "${COMMANDS[@]}"; do
        local output="$COMMANDS_DIR/$cmd"
        
        # 备份已存在的文件
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
    print_info "Cursor 指令: ${success_count} 成功, ${fail_count} 失败"
}

# 安装内置规范文档
install_standards() {
    print_step "安装内置规范文档..."
    echo ""
    
    create_dir "$STANDARDS_DIR"
    
    local success_count=0
    local fail_count=0
    local action_word=$([[ "$INSTALL_MODE" == "local" ]] && echo "复制" || echo "下载")
    
    for doc in "${STANDARDS[@]}"; do
        local output="$STANDARDS_DIR/$doc"
        
        # 备份已存在的文件
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
    print_info "规范文档: ${success_count} 成功, ${fail_count} 失败"
}

# 显示安装结果
show_result() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    print_success "安装完成！"
    echo ""
    echo "安装位置: $TARGET_PROJECT_DIR"
    echo ""
    echo "已安装的 Cursor 指令:"
    echo "  /debug          - Unity 控制台调试"
    echo "  /fixer          - 修复控制台错误"
    echo "  /tester         - 运行测试并生成报告"
    echo "  /plan-workflow  - 开发工作流规划"
    echo ""
    echo "已安装的内置规范文档:"
    echo "  .cursor/standards/csharp-coding-standard.md  - C# 代码规范"
    echo "  .cursor/standards/development-standard.md    - 开发流程规范"
    echo ""
    echo "使用方法: 在 Cursor 中输入 /指令名 即可触发"
    echo ""
    echo "首次使用 /plan-workflow 时:"
    echo "  - 会提示配置策划案地址、输出文档地址和规范文档地址"
    echo "  - 若项目无规范文档，将使用已安装的内置规范"
    echo ""
    echo -e "${YELLOW}⚠️  前置要求:${NC}"
    echo "  - Unity MCP >= 8.3.0: https://github.com/CoplayDev/unity-mcp"
    echo "  - /run-tests-report 指令需要 Unity MCP 8.3.0+ 的 run_tests 功能"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
}

# 主函数
main() {
    show_banner
    detect_install_mode "$1"
    check_project_root
    detect_downloader
    install_commands
    install_standards
    show_result
}

# 运行主函数，传入第一个参数作为目标目录
main "$1"
