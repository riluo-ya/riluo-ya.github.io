#!/data/data/com.termux/files/usr/bin/bash
# Phira-MP Termux 一键构建脚本
# 如果访问 GitHub 慢，可以手动设置镜像：export GITHUB_MIRROR=https://ghproxy.com/https://github.com

set -e                          # 遇到错误立即退出
trap 'echo "❌ 脚本运行失败，请检查日志" >&2' ERR

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}==> 1. 更新 Termux 软件包${NC}"
pkg update -y && pkg upgrade -y

echo -e "${GREEN}==> 2. 安装系统依赖${NC}"
pkg install -y \
    git curl build-essential openssl-tool \
    pkg-config libssl-dev proot-distro

echo -e "${GREEN}==> 3. 安装 Rust（若已安装则跳过）${NC}"
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust 已安装，跳过"
fi

# 选择仓库（支持 IPv6 的镜像）
REPO_URL="https://github.com/afoim/phira-mp-autobuild.git"
DIR_NAME="phira-mp-autobuild"

echo -e "${GREEN}==> 4. 克隆仓库${NC}"
if [[ -d "$DIR_NAME" ]]; then
    echo "目录已存在，拉取最新代码..."
    cd "$DIR_NAME"
    git pull --ff-only
else
    git clone --depth=1 "$REPO_URL" "$DIR_NAME"
    cd "$DIR_NAME"
fi

echo -e "${GREEN}==> 5. 更新并构建 phira-mp-server${NC}"
cargo update
cargo build --release -p phira-mp-server

echo -e "${GREEN}==> 6. 启动服务器${NC}"
echo -e "${YELLOW}默认监听 12345 端口，如需自定义，请 Ctrl+C 后手动加参数：${NC}"
echo -e "   RUST_LOG=info ./target/release/phira-mp-server --port 8080\n"

# 直接运行
RUST_LOG=info ./target/release/phira-mp-server
