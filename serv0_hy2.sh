#!/bin/sh
set -e
export UUID=${UUID:-'a03e977f-6491-42a2-b56d-abbab6c3a9ac'} 
USERNAME=$(whoami)

WORK_DIR="./sing-box"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

# 下载并解压缩文件
echo "下载 s-box.zip..."
wget -O 's-box.zip' 'https://raw.githubusercontent.com/1774293824/Actions-public/main/sing-box.zip' && unzip s-box.zip

# 获取用户输入的函数
prompt_for_input() {
    local prompt_msg=$1
    local default_value=$2
    read -p "$(echo -e '\033[0;32m'"$prompt_msg"' (默认 '"$default_value"'): \033[0m')" input
    echo "${input:-$default_value}"
}

IP=$(prompt_for_input "请输入 IP地址" '31.186.87.205')
PORT1=$(prompt_for_input "请输入 hysteria2 端口号" '21382')
PORT2=$(prompt_for_input "请输入 vless 端口号" '23517')
PORT3=$(prompt_for_input "请输入 tuic 端口号" '12225')

# 替换配置文件中的占位符
CONFIG_FILE="config.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "替换配置文件中的占位符..."
    sed -i '' "s/{{IP}}/$IP/g; s/33333/$PORT1/g; s/44444/$PORT2/g; s/55555/$PORT3/g" "$CONFIG_FILE"
else
    echo "配置文件 $CONFIG_FILE 不存在！"
    exit 1
fi

# 设置文件权限
echo "设置文件权限 'box'..."
chmod 755 box

# 启动服务
echo "启动服务..."
screen -dmS box /home/${USERNAME}//box run

echo "服务已成功启动。要重新附加到屏幕会话，请使用：screen -r box"
echo "请测试下面的订阅:"
echo ""
echo -e "\033[0;32m hysteria2://$UUID@$IP:$PORT1/?sni=www.bing.com&alpn=h3&insecure=1#${USERNAME} \033[0m"
echo ""
echo -e "\033[0;32m vless://$UUID@$IP:$PORT2?encryption=none&flow=xtls-rprx-vision&security=reality&sni=www.ups.com&fp=chrome&pbk=SxBMcWxdxYBAh_IUSsiCDk6UHIf1NA1O8hUZ2hbRTFE&type=tcp&headerType=none#${USERNAME} \033[0m"
echo ""
echo -e "\033[0;32m tuic://$UUID:password123@$IP:$PORT3?sni=www.bing.com&alpn=h3&congestion_control=bbr#${USERNAME} \033[0m"
echo ""