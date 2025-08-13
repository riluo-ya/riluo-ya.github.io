#!/data/data/com.termux/files/usr/bin/bash
# ======================================================
#  phira-mp-server 一键部署脚本 for Termux
#  2025-08-13
# ======================================================

set -e   # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 开始 phira-mp-server 一键部署 …${NC}"

# ------------------------------------------------------
# 1. 更新 Termux 仓库并安装系统依赖
# ------------------------------------------------------
echo -e "${YELLOW}[1/5] 更新 Termux 软件源并安装依赖 …${NC}"
pkg update -y && pkg upgrade -y
pkg install -y git curl build-essential pkg-config openssl openssl-tool openssl-dev

# ------------------------------------------------------
# 2. 检查并安装 Rust（若未安装）
# ------------------------------------------------------
if ! command -v rustc &> /dev/null; then
    echo -e "${YELLOW}[2/5] 未检测到 Rust，开始安装 …${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${YELLOW}[2/5] Rust 已安装，跳过 …${NC}"
fi

# 确保 cargo 在 PATH
export PATH="$HOME/.cargo/bin:$PATH"

# ------------------------------------------------------
# 3. 克隆/更新 phira-mp 仓库
# ------------------------------------------------------
REPO_DIR="$HOME/phira-mp"

if [[ -d "$REPO_DIR/.git" ]]; then
    echo -e "${YELLOW}[3/5] 仓库已存在，拉取最新代码 …${NC}"
    cd "$REPO_DIR"
    git pull --ff-only
else
    echo -e "${YELLOW}[3/5] 克隆 phira-mp 仓库 …${NC}"
    git clone https://github.com/TeamFlos/phira-mp.git "$REPO_DIR"
    cd "$REPO_DIR"
fi

# ------------------------------------------------------
# 4. 更新依赖并编译
# ------------------------------------------------------
echo -e "${YELLOW}[4/5] 更新依赖并编译 phira-mp-server …${NC}"
cargo update
cargo build --release -p phira-mp-server

# ------------------------------------------------------
# 5. 运行服务器
# ------------------------------------------------------
echo -e "${GREEN}[5/5] 编译完成，启动服务器 …${NC}"
echo -e "${GREEN}------------------------------------------------------${NC}"
RUST_LOG=info ./target/release/phira-mp-server
