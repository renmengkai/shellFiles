# 安装go
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
# 安装rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
# 安装其他依赖
apt-get install clang cmake build-essential screen git -y
# 下载源码
git clone https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
# Build in release mode
cargo build --release
sed -i "s/miner_id = .*/miner_id = \"$(openssl rand -hex 32)\"/" run/config.toml
read -p "请输入miner_key(私钥，不以0x开头): " miner_key
sed -i "s/miner_key = .*/miner_key = \"$miner_key\"/" run/config.toml
cd run
screen -dmS 0g_storage ../target/release/zgs_node --config config.toml
