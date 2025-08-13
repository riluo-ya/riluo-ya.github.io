#!/data/data/com.termux/files/usr/bin/bash

# 自动检测并安装所需工具
if ! command -v git &> /dev/null; then
    pkg update -y
    pkg install -y git
fi

if ! command -v rustc &> /dev/null; then
    pkg install -y rust
fi

# 克隆phira-mp仓库
git clone https://github.com/TeamFlos/phira-mp.git
cd phira-mp

# 更新依赖并构建项目
cargo update
cargo build --release -p phira-mp-server

# 添加启动提示到bashrc文件
echo 'echo "输入RUST_LOG=info target/release/phira-mp-server开始服务"' >> ~/.bashrc

echo "构建完成！现在可以输入RUST_LOG=info target/release/phira-mp-server开始服务"
