#!/data/data/com.termux/files/usr/bin/bash

# 定义颜色变量
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
RESET="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"

# 定义分隔线函数
separator() {
    printf "${GREEN}%-${COLUMNS}s${RESET}\n" "" | tr ' ' '='
}

# 定义带颜色的标题函数
title() {
    local text="$1"
    separator
    echo -e "${BOLD}${CYAN}${text}${RESET}"
    separator
}

# 定义带颜色的信息提示函数
info() {
    local message="$1"
    echo -e "${GREEN}[INFO]${RESET} ${message}"
}

# 定义错误提示函数
error() {
    local message="$1"
    echo -e "${RED}[ERROR]${RESET} ${message}" >&2
    exit 1
}

# 定义警告提示函数
warning() {
    local message="$1"
    echo -e "${YELLOW}[WARNING]${RESET} ${message}"
}

# 定义成功提示函数
success() {
    local message="$1"
    echo -e "${GREEN}[SUCCESS]${RESET} ${message}"
}

# 检查是否在Termux环境中运行
if [ ! -d "/data/data/com.termux" ]; then
    error "本脚本必须在Termux环境中运行！"
fi

# 主函数
main() {
    title "phira-mp服务器一键安装脚本"
    
    info "本脚本将自动检测并安装所需依赖，克隆phira-mp仓库，构建并启动服务器。"
    info "安装过程中请不要关闭Termux窗口，保持网络连接稳定。"
    
    # 步骤1：更新软件包列表
    separator
    title "更新软件包列表"
    info "正在更新软件包列表..."
    pkg update -y || error "软件包更新失败！"
    success "软件包列表更新完成。"
    
    # 步骤2：安装必要的构建工具和依赖
    separator
    title "安装必要的构建工具和依赖"
    
    # 安装git
    info "正在检查并安装git..."
    if ! command -v git &> /dev/null; then
        pkg install -y git || error "git安装失败！"
        success "git安装完成。"
    else
        success "git已安装，跳过安装。"
    fi
    
    # 安装Rust工具链
    info "正在检查并安装Rust工具链..."
    if ! command -v rustc &> /dev/null; then
        pkg install -y rust || error "Rust安装失败！"
        success "Rust安装完成。"
    else
        success "Rust已安装，跳过安装。"
    fi
    
    # 安装其他必要的构建工具
    info "正在检查并安装其他必要的构建工具..."
    pkg install -y build-essential || error "构建工具安装失败！"
    success "所有必要的构建工具安装完成。"
    
    # 步骤3：克隆phira-mp仓库
    separator
    title "克隆phira-mp仓库"
    info "正在克隆phira-mp仓库..."
    git clone https://github.com/TeamFlos/phira-mp.git || error "仓库克隆失败！"
    success "仓库克隆完成。"
    
    # 步骤4：进入phira-mp目录并构建
    separator
    title "进入phira-mp目录并构建"
    info "进入phira-mp目录..."
    cd phira-mp || error "进入phira-mp目录失败！"
    
    info "正在更新依赖包..."
    cargo update || error "依赖包更新失败！"
    success "依赖包更新完成。"
    
    info "正在以release模式构建phira-mp-server..."
    cargo build --release -p phira-mp-server || error "构建失败！"
    success "构建完成。"
    
    # 步骤5：配置启动提示
    separator
    title "配置Termux启动提示"
    info "正在配置Termux启动提示..."
    if ! grep -q "RUST_LOG=info target/release/phira-mp-server" ~/.bashrc; then
        echo 'echo "输入RUST_LOG=info target/release/phira-mp-server开始服务"' >> ~/.bashrc
        success "配置完成。下次启动Termux时会显示启动提示。"
    else
        warning "启动提示已存在，跳过配置。"
    fi
    
    # 步骤6：设置开机自启
    separator
    title "设置开机自启"
    info "正在设置开机自启功能..."
    
    # 检查并安装Termux:Boot（如果未安装）
    if ! command -v termux-boot &> /dev/null; then
        warning "Termux:Boot未安装，将无法实现真正的开机自启！"
        warning "请安装Termux:Boot应用以支持开机自启功能。"
        warning "安装方法：在Termux中输入'pkg install termux-boot'。"
    fi
    
    # 创建.termux/boot目录（如果不存在）
    mkdir -p ~/.termux/boot
    
    # 创建启动脚本
    echo "RUST_LOG=info target/release/phira-mp-server" > ~/.termux/boot/phira-mp-start.sh
    
    # 赋予执行权限
    chmod +x ~/.termux/boot/phira-mp-start.sh
    
    success "开机自启配置完成。下次设备启动时，phira-mp-server将自动运行。"
    info "如果Termux:Boot未安装，开机自启功能将无法生效。"
    
    # 步骤7：启动服务器
    separator
    title "启动phira-mp服务器"
    info "所有准备工作完成，正在启动phira-mp服务器..."
    info "服务器启动后将持续运行，按Ctrl+C可终止服务。"
    info "如需在后台运行，请按Ctrl+Z，然后输入bg。"
    
    # 启动服务器并处理中断
    trap 'echo -e "\n${RED}[INFO]${RESET} 接收到中断信号，正在停止服务器..."; exit 0' INT
    RUST_LOG=info target/release/phira-mp-server
}

# 执行主函数
main
