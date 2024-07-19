# 删除旧的存储节点
rm -rf /root/0g-storage-node
# 安装依赖
sudo apt-get update
sudo apt-get install clang cmake build-essential git screen cargo -y
# 安装 Go
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.22.0.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
source $HOME/.bash_profile
# 克隆仓库
git clone -b v0.3.4 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
# 构建代码
cargo build --release
# 修改配置文件
sed -i '
s|# rpc_listen_address = ".*"|rpc_listen_address = "0.0.0.0:5678"|
s|# network_boot_nodes = \[\]|network_boot_nodes = \[\"/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps\",\"/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS\",\"/ip4/18.167.69.68/udp/1234/p2p/16Uiu2HAm2k6ua2mGgvZ8rTMV8GhpW71aVzkQWy7D37TTDuLCpgmX\"\]|
s|# log_contract_address = ""|log_contract_address = "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"|
s|# mine_contract_address = ""|mine_contract_address = "0x85F6722319538A805ED5733c5F4882d96F1C7384"|
s|# blockchain_rpc_endpoint = ".*"|blockchain_rpc_endpoint = "https://rpc-testnet.0g.ai"|
s|# log_sync_start_block_number = 0|log_sync_start_block_number = 802|
' $HOME/0g-storage-node/run/config.toml
# 修改日志级别
echo "error,hyper=info,h2=info" > $HOME/0g-storage-node/run/log_config
