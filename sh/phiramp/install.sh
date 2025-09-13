#!/data/data/com.termux/files/usr/bin/bash

# 定义颜色与格式变量（确保Termux兼容）
RED="\033[1;31m"       # 鲜艳红色（加粗）
GREEN="\033[1;32m"     # 绿色（加粗）
YELLOW="\033[1;33m"    # 黄色（加粗）
BLUE="\033[1;34m"      # 蓝色（加粗）
PURPLE="\033[1;35m"    # 紫色（加粗）
CYAN="\033[1;36m"      # 青色（加粗）
RESET="\033[0m"        # 重置格式
BOLD="\033[1m"         # 加粗

# 定义分隔线（ASCII字符，避免乱码）
separator() {
    printf "${CYAN}=======================================================${RESET}\n"
}

# 标题显示函数
title() {
    local color="$1"
    local text="$2"
    separator
    echo -e "${BOLD}${color}${text}${RESET}"
    separator
}

# 信息提示函数（带颜文字）
info() {
    local color="$1"
    local message="$2"
    echo -e "${color}[信息]${RESET} ${message} (≧▽≦)"
}

# 错误提示函数
error() {
    local message="$1"
    echo -e "${RED}[错误]${RESET} ${message} (＞﹏＜)" >&2
    exit 1
}

# 成功提示函数
success() {
    local message="$1"
    echo -e "${GREEN}[成功]${RESET} ${message} (≧∇≦)ﾉ"
}

# 警告提示函数
warning() {
    local message="$1"
    echo -e "${YELLOW}[警告]${RESET} ${message} (ｏ・_・)ノ"
}

# 检查Termux环境
if [ ! -d "/data/data/com.termux" ]; then
    error "请在Termux中运行该脚本！"
fi

# 主流程
main() {
    title "$YELLOW" "Phira多人联机一键安装脚本"
    info "$CYAN" "即将自动安装依赖并构建服务，过程中请保持网络畅通~"
    echo
    # 添加作者信息
    info "$PURPLE" "作者: 日落-ya"
    echo
    # 等待三秒
    info "$YELLOW" "3秒后继续执行..."
    sleep 3
    echo

    # 步骤1：更新软件包
    title "$BLUE" "步骤1/6：更新软件包列表"
    sleep 1
    info "$YELLOW" "正在更新系统软件包..."
    pkg update -y || error "软件包更新失败"
    success "软件包列表更新完成"
    echo

    # 步骤2：安装依赖工具
    title "$BLUE" "步骤2/6：安装必要工具"
    sleep 1
    info "$YELLOW" "检查并安装git..."
    sleep 1
    if ! command -v git &> /dev/null; then
        pkg install -y git || error "git安装失败"
        success "git安装完成"
    else
        success "git已安装，跳过"
    fi

    info "$YELLOW" "检查并安装Rust工具链..."
    sleep 1
    if ! command -v rustc &> /dev/null; then
        pkg install -y rust || error "Rust安装失败"
        success "Rust安装完成"
    else
        success "Rust已安装，跳过"
    fi

    info "$YELLOW" "安装基础构建工具..."
    sleep 1
    pkg install -y build-essential || error "构建工具安装失败"
    success "所有依赖安装完成"
    echo

    # 步骤3：克隆仓库
    title "$BLUE" "步骤3/6：克隆phira-mp仓库"
    sleep 1
    info "$YELLOW" "正在克隆代码仓库..."
    sleep 1
    git clone https://github.com/TeamFlos/phira-mp.git || error "仓库克隆失败"
    success "仓库克隆完成"
    echo

    # 步骤4：进入目录并更新依赖
    title "$BLUE" "步骤4/6：更新项目依赖"
    sleep 1
    info "$YELLOW" "进入项目目录..."
    cd phira-mp || error "无法进入项目目录"

    info "$YELLOW" "正在更新依赖包..."
    sleep 1
    cargo update || error "依赖更新失败"
    success "依赖更新完成"
    echo

    # 步骤5：构建项目
    title "$BLUE" "步骤5/6：构建服务程序"
    sleep 1
    info "$YELLOW" "即将开始构建构建..."
    sleep 1
    title "$PURPLE" "注意:该过程耗时可能较长，请耐心等待"
    cargo build --release -p phira-mp-server || error "构建失败"
    success "程序构建完成"
    echo

    # 步骤6：配置启动提示
    title "$BLUE" "步骤6/6：配置启动交互"
    sleep 1
    info "$YELLOW" "设置启动提示与自动执行逻辑..."
    sleep 1

    # 定义启动提示与交互脚本（写入.bashrc）
start_script='
#Phira-mp启动
echo -e "\e[36m┌-----------------------------------------------------\e[0m"
echo -e "\e[1;32m|          Phira 多人联机启动器\e[0m"
echo -e "\e[33m|        按 [回车] 启动服务  (Ctrl+C 退出)\e[0m"
echo -e "\e[36m└-----------------------------------------------------\e[0m"
read -r

echo -e "\e[90m[一言]\e[0m $(curl -s https://api.nxvav.cn/api/yiyan/?encode=text)"
sleep 1

echo -e "\e[32m正在启动服务… (≧▽≦)\e[0m"
sleep 1

[[ -d phira-mp ]] && cd phira-mp && RUST_LOG=info target/release/phira-mp-server || {
    echo -e "\e[31m未找到 phira-mp 目录\e[0m"
    while true; do
        read -rn1 -p $'\e[33m是否重新安装？ [y/N]: \e[0m' choice && echo
        case $choice in
            [Yy]) curl -LO riluo-ya.github.io/sh/install.sh && bash install.sh; break ;;
            [Nn]|"") echo "已取消，脚本退出。"; exit 0 ;;
            *) echo "请输入 y 或 n。" ;;
        esac
    done
}
'

    # 避免重复添加
    if ! grep -q "phira-mp启动提示" ~/.bashrc; then
        echo -e "$start_script" >> ~/.bashrc
        success "启动交互已配置，下次打开Termux将显示启动提示"
    else
        warning "启动交互已存在，无需重复配置"
    fi
    echo

    # 安装完成提示
    title "$GREEN" "安装全部完成！"
    info "$YELLOW" "下次启动Termux时，将显示启动提示，按回车即可运行服务"
    sleep 1
    info "$YELLOW" "本次可直接按以下步骤启动："
    echo -e "${CYAN}1. 输入: cd phira-mp${RESET}"
    echo -e "${CYAN}2. 输入: RUST_LOG=info target/release/phira-mp-server${RESET}"
}

# 执行主函数
main
