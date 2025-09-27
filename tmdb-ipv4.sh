#!/bin/sh
# RunLast 自动绑定 TMDB 域名到 IPv4（重启后失效）

echo "=== 检查是否为 root 用户 ==="
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ 请以 root 用户运行此脚本"
    exit 3
fi

echo "=== 准备绑定 TMDB 域名到 IPv4 ==="
HOSTS_FILE="/etc/hosts"
API_IP="18.244.214.44"
IMAGE_IP="143.244.50.82"

# 检查是否已绑定
api_bound=$(grep -w "api.themoviedb.org" "$HOSTS_FILE" | grep "$API_IP")
image_bound=$(grep -w "image.tmdb.org" "$HOSTS_FILE" | grep "$IMAGE_IP")

if [ -n "$api_bound" ] && [ -n "$image_bound" ]; then
    echo "✅ 已绑定 TMDB 域名，无需重复设置"
    echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认 hosts 文件"
    exit 0
fi

echo "=== 添加绑定记录到 /etc/hosts ==="
echo "" >> "$HOSTS_FILE"
echo "# TMDB IPv4 临时绑定" >> "$HOSTS_FILE"
echo "$API_IP api.themoviedb.org" >> "$HOSTS_FILE"
echo "$IMAGE_IP image.tmdb.org" >> "$HOSTS_FILE"

echo "🎉 已成功绑定 TMDB 域名到 IPv4"
echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认 hosts 文件"
exit 0
