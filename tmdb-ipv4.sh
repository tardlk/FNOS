#!/bin/sh
# RunLast 自动绑定 TMDB 域名到 IPv4（重启后失效）

echo "=== 准备绑定 TMDB 域名到 IPv4 ==="
HOSTS_FILE="/etc/hosts"
API_IP="18.244.214.44"
IMAGE_IP="143.244.50.82"

# 处理 api.themoviedb.org
if grep -qw "api.themoviedb.org" "$HOSTS_FILE"; then
    echo "=== 更新 api.themoviedb.org 绑定 ==="
    sed -i "s/.*api\.themoviedb\.org/$API_IP api.themoviedb.org/" "$HOSTS_FILE"
else
    echo "=== 添加 api.themoviedb.org 绑定 ==="
    echo "$API_IP api.themoviedb.org" >> "$HOSTS_FILE"
fi

# 处理 image.tmdb.org
if grep -qw "image.tmdb.org" "$HOSTS_FILE"; then
    echo "=== 更新 image.tmdb.org 绑定 ==="
    sed -i "s/.*image\.tmdb\.org/$IMAGE_IP image.tmdb.org/" "$HOSTS_FILE"
else
    echo "=== 添加 image.tmdb.org 绑定 ==="
    echo "$IMAGE_IP image.tmdb.org" >> "$HOSTS_FILE"
fi

echo "🎉 已成功绑定 TMDB 域名到 IPv4"
echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认 hosts 文件"
exit 0
