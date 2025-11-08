#!/bin/sh
# 启用 TCP BBR + fq（根据当前状态有选择地切换）

echo "=== 检查当前队列规则和拥塞控制算法 ==="
current_qdisc=$(sysctl -n net.core.default_qdisc)
current_cc=$(sysctl -n net.ipv4.tcp_congestion_control)

echo "当前队列规则: $current_qdisc"
echo "当前拥塞控制算法: $current_cc"

# 判断并切换队列规则
if [ "$current_qdisc" = "fq" ]; then
    echo "✅ 队列规则已是 fq，无需修改"
else
    echo "=== 切换队列规则为 fq ==="
    sysctl -w net.core.default_qdisc=fq
fi

# 判断并切换拥塞控制算法
if [ "$current_cc" = "bbr" ]; then
    echo "✅ 拥塞控制算法已是 bbr，无需修改"
else
    echo "=== 切换拥塞控制算法为 bbr ==="
    sysctl -w net.ipv4.tcp_congestion_control=bbr
fi

echo "=== 切换后再次检测 ==="
new_qdisc=$(sysctl -n net.core.default_qdisc)
new_cc=$(sysctl -n net.ipv4.tcp_congestion_control)

echo "当前队列规则: $new_qdisc"
echo "当前拥塞控制算法: $new_cc"

if [ "$new_qdisc" = "fq" ] && [ "$new_cc" = "bbr" ]; then
    echo "🎉 切换成功，已启用 fq + BBR"
else
    echo "⚠️ 切换未完全成功，当前为 $new_qdisc + $new_cc"
fi

echo "ℹ️ 注意：此设置为临时启用，重启后将恢复默认网络参数"
