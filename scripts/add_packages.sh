#!/bin/bash

# {{ Add luci-app-diskman
(cd friendlywrt && {
    mkdir -p package/luci-app-diskman
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile.old -O package/luci-app-diskman/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_luci-i18n-diskman-zh-cn=y
CONFIG_PACKAGE_smartmontools=y
# === 主流网卡支持 ===
# Realtek 系（常见 USB 网卡）
CONFIG_PACKAGE_kmod-rtl8188eu=y
CONFIG_PACKAGE_kmod-rtl8192cu=y
CONFIG_PACKAGE_kmod-rtl8192eu=y
CONFIG_PACKAGE_kmod-rtl8812au-ct=y
CONFIG_PACKAGE_kmod-rtl8821cu=y
CONFIG_PACKAGE_kmod-rtl8xxxu=y

# Mediatek 系（MT7601/MT7610 等）
CONFIG_PACKAGE_kmod-mt7601u=y
CONFIG_PACKAGE_kmod-mt76=y
CONFIG_PACKAGE_kmod-mt76x2=y
CONFIG_PACKAGE_kmod-mt76x0=y

# Qualcomm Atheros 系（AR9271、QCA 系）
CONFIG_PACKAGE_kmod-ath=y
CONFIG_PACKAGE_kmod-ath9k=y
CONFIG_PACKAGE_kmod-ath9k-htc=y
CONFIG_PACKAGE_kmod-ath10k=y

# Ralink（老芯片）
CONFIG_PACKAGE_kmod-rt2800-usb=y
CONFIG_PACKAGE_kmod-rt2x00-usb=y

# Intel（主要用于 x86 平台）
CONFIG_PACKAGE_kmod-iwlwifi=y
CONFIG_PACKAGE_kmod-iwlwifi-firmware=y

# USB 通用支持
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb3=y
CONFIG_PACKAGE_kmod-usb-net=y
CONFIG_PACKAGE_kmod-usb-net-rtl8152=y
CONFIG_PACKAGE_kmod-usb-net-rtl8150=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_kmod-usb-serial=y
CONFIG_PACKAGE_kmod-usb-serial-ch341=y
CONFIG_PACKAGE_kmod-usb-serial-pl2303=y
# 存储扩展支持
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-fs-exfat=y
CONFIG_PACKAGE_kmod-fs-ntfs3=y
CONFIG_PACKAGE_mount-utils=y
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_fdisk=y

# === 主流翻墙软件 ===
CONFIG_PACKAGE_luci-app-v2raya=y
CONFIG_PACKAGE_v2raya=y
CONFIG_PACKAGE_xray-core=y

CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-i18n-v2raya-zh-cn=y
CONFIG_PACKAGE_trojan-plus=y
CONFIG_PACKAGE_brook=y

CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_shadowsocks-libev-ss-local=y
CONFIG_PACKAGE_shadowsocks-libev-ss-redir=y
# DNS 优化（避免污染）
CONFIG_PACKAGE_luci-app-smartdns=y
CONFIG_PACKAGE_smartdns=y

CONFIG_PACKAGE_kmod-tun=y
CONFIG_PACKAGE_kmod-tcp-bbr=y
CONFIG_PACKAGE_kmod-inet-diag=y
CONFIG_PACKAGE_kmod-nft-tproxy=y
CONFIG_PACKAGE_kmod-nft-socket=y
CONFIG_PACKAGE_kmod-ipt-socket=y
CONFIG_PACKAGE_iptables-mod-socket=y
CONFIG_PACKAGE_ip-full=y
CONFIG_PACKAGE_ca-bundle=y
# 网络调试工具（如 ping、traceroute、nslookup）
CONFIG_PACKAGE_iputils-ping=y
CONFIG_PACKAGE_traceroute=y
CONFIG_PACKAGE_bind-dig=y
# 网络相关增强
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_ipset=y
# aria2下载器及常用软件
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_tcpdump=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_wget=y
CONFIG_PACKAGE_luci-app-aria2=y
CONFIG_PACKAGE_aria2=y
CONFIG_PACKAGE_luci-i18n-aria2-zh-cn=y

EOL
# }}

# {{ Add luci-theme-argon
(cd friendlywrt/package && {
    [ -d luci-theme-argon ] && rm -rf luci-theme-argon
    git clone https://github.com/jerrykuku/luci-theme-argon.git --depth 1 -b master
})
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> configs/rockchip/01-nanopi
sed -i -e 's/function init_theme/function old_init_theme/g' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
cat > /tmp/appendtext.txt <<EOL
function init_theme() {
    if uci get luci.themes.Argon >/dev/null 2>&1; then
        uci set luci.main.mediaurlbase="/luci-static/argon"
        uci commit luci
    fi
}
EOL
sed -i -e '/boardname=/r /tmp/appendtext.txt' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
# }}
