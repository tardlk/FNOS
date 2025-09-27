#!/bin/sh
# RunLast 自动检测并启用 TCP BBR（重启后失效）

echo "=== 检查是否为 root 用户 ==="
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ 请以 root 用户运行此脚本"
    exit 3
fi

echo "=== 检查内核是否支持 BBR ==="
available_cc=$(sysctl -n net.ipv4.tcp_available_congestion_control 2>/dev/null)

if echo "$available_cc" | grep -qw bbr; then
    echo "✅ 检测到内核支持 BBR"
else
    echo "❌ 当前内核不支持 BBR，无法启用"
    exit 1
fi

echo "=== 检查当前是否已启用 BBR ==="
current_cc=$(sysctl -n net.ipv4.tcp_congestion_control)
if [ "$current_cc" = "bbr" ]; then
    echo "✅ 当前已启用 BBR，无需重复设置"
    echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认网络参数"
    exit 0
fi

echo "=== 尝试加载 BBR 模块（如果是模块形式） ==="
if modprobe tcp_bbr 2>/dev/null; then
    echo "BBR 模块加载成功（或已加载）"
else
    echo "BBR 模块可能是内建的，无需加载"
fi

echo "=== 设置队列规则和拥塞控制算法 ==="
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr

current_cc=$(sysctl -n net.ipv4.tcp_congestion_control)
echo "=== 当前拥塞控制算法: $current_cc ==="

if [ "$current_cc" = "bbr" ]; then
    echo "🎉 BBR 已成功启用"
    echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认网络参数"
    exit 0
else
    echo "⚠️ BBR 启用失败"
    exit 2
fi
