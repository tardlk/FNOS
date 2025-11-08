#!/bin/sh
# 启用 TCP BBR

echo "=== 设置队列规则和拥塞控制算法 ==="
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr

echo "=== 当前拥塞控制算法: $(sysctl -n net.ipv4.tcp_congestion_control) ==="
echo "🎉 已尝试启用 BBR（注意：此设置为临时启用，重启后将恢复默认网络参数）"
