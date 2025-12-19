sudo sysctl -w net.core.default_qdisc=fq net.ipv4.tcp_congestion_control=bbr && \
sleep 120 && \
echo '0000:00:14.0' | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind >/dev/null && \
sleep 5 && \
echo '0000:00:14.0' | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind >/dev/null
