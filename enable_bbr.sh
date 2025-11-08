#!/bin/sh
# 启用 TCP BBR

echo "=== 检查当前 TCP 拥塞控制算法 ==="
current_cc=$(sysctl -n net.ipv4.tcp_congestion_control)
echo "当前算法: $current_cc"

echo "=== 尝试切换到 BBR ==="
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr

echo "=== 切换后再次检测 ==="
new_cc=$(sysctl -n net.ipv4.tcp_congestion_control)
echo "当前算法: $new_cc"

if [ "$new_cc" = "bbr" ]; then
    echo "🎉 切换成功，已启用 BBR"
else
    echo "⚠️ 切换失败，仍然是 $new_cc"
fi

echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认网络参数"
