#!/system/bin/sh
# OTG 角色切换守护进程
# 背景：本机 USB-C 的 typec/UCSI 栈在 recovery 里不完整，插 U 盘时
# dwc3 不会自动从 peripheral 切到 host，导致 xhci 不 probe、U 盘不枚举。
# 这里轮询 VBUS 与 typec partner：
#   - 有对端且无 VBUS（U 盘/键鼠等不自供电的外设） -> 切 host
#   - 有对端且 VBUS 有电（电脑/充电器）            -> 切回 device 并重配 gadget
#   - 无对端（拔线）                               -> 保持现状

ROLE=/sys/class/usb_role/a600000.ssusb-role-switch/role
VBUS=/sys/class/power_supply/usb/online
PARTNER=/sys/class/typec/port0-partner

# 等 USB gadget 与 typec 完成初始化
sleep 3

while true; do
    online=$(cat "$VBUS" 2>/dev/null)
    [ -z "$online" ] && online=0

    if [ -d "$PARTNER" ]; then
        if [ "$online" = "0" ]; then
            want=host
        else
            want=device
        fi
        cur=$(cat "$ROLE" 2>/dev/null)
        if [ "$cur" != "$want" ]; then
            echo "$want" > "$ROLE" 2>/dev/null
            if [ "$want" = "device" ]; then
                sleep 1
                setprop sys.usb.config none
                setprop sys.usb.config adb
            fi
        fi
    fi

    sleep 1
done
