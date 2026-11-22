#!/usr/bin/env bash
set -u
pkill -x rustkey-linux
rm -f "$HOME/.local/bin/rustkey-linux" "$HOME/.config/autostart/rustkey.desktop"
echo "Đã gỡ. Chạy 'im-config -n fcitx5' (hoặc ibus) nếu muốn đổi lại bộ gõ rồi đăng nhập lại."
