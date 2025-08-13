#!/data/data/com.termux/files/usr/bin/bash

# 欢迎信息和安装流程提示
echo "欢迎使用phira-mp服务器一键安装脚本！"
echo "本脚本将自动检测并安装所需依赖，克隆phira-mp仓库，构建并启动服务器。"
echo "安装过程中请不要关闭Termux窗口，保持网络连接稳定。"
echo "----------------------------------------"

# 步骤1：更新软件包列表
echo "正在更新软件包列表..."
pkg update -y
echo "软件包列表更新完成。"
echo "----------------------------------------"

# 步骤2：安装必要的构建工具和依赖
echo "正在检查并安装必要的构建工具和依赖..."

# 检查并安装git
if ! command -v git &> /dev/null; then
    echo "git未安装，正在安装..."
    pkg install -y git
    echo "git安装完成。"
else
    echo "git已安装，跳过安装。"
fi

# 检查并安装Rust工具链
if ! command -v rustc &> /dev/null; then
    echo "Rust未安装，正在安装..."
    pkg install -y rust
    echo "Rust安装完成。"
else
    echo "Rust已安装，跳过安装。"
fi

# 检查并安装cargo（通常Rust安装会包含cargo，但为了确保）
if ! command -v cargo &> /dev/null; then
    echo "cargo未安装，正在安装..."
    pkg install -y cargo
    echo "cargo安装完成。"
else
    echo "cargo已安装，跳过安装。"
fi

# 安装其他必要的构建工具（如gcc、make等）
echo "正在安装其他必要的构建工具..."
pkg install -y build-essential
echo "所有必要的构建工具安装完成。"
echo "----------------------------------------"

# 步骤3：克隆phira-mp仓库
echo "正在克隆phira-mp仓库..."
git clone https://github.com/TeamFlos/phira-mp.git
echo "仓库克隆完成。"
echo "----------------------------------------"

# 步骤4：进入phira-mp目录并构建
echo "进入phira-mp目录..."
cd phira-mp

echo "正在更新依赖包..."
cargo update
echo "依赖包更新完成。"

echo "正在以release模式构建phira-mp-server..."
cargo build --release -p phira-mp-server
echo "构建完成。"
echo "----------------------------------------"

# 步骤5：配置启动提示
echo "正在配置Termux启动提示..."
echo 'echo "输入RUST_LOG=info target/release/phira-mp-server开始服务"' >> ~/.bashrc
echo "配置完成。下次启动Termux时会显示启动提示。"
echo "----------------------------------------"

# 步骤6：启动服务器
echo "所有准备工作完成，正在启动phira-mp服务器..."
echo "服务器启动后将持续运行，按Ctrl+C可终止服务。"
echo "如需在后台运行，请按Ctrl+Z，然后输入bg。"
echo "----------------------------------------"

# 启动服务器并记录日志
RUST_LOG=info target/release/phira-mp-server
