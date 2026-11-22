#!/usr/bin/env bash
set -u
pkill -x rustkey-linux
rm -f "$HOME/.local/bin/rustkey-linux" "$HOME/.config/autostart/rustkey.desktop"
/usr/bin/python3 - <<'P'
from gi.repository import Gio, GLib
ID, RK = "org.cinnamon.desktop.input-sources", ("ibus", "rustkey")
if Gio.SettingsSchemaSource.get_default().lookup(ID, True):
    s = Gio.Settings.new(ID)
    s.set_value("sources", GLib.Variant("a(ss)", [x for x in s.get_value("sources").unpack() if x != RK]))
    s.set_uint("current", 0)
    Gio.Settings.sync()
P
echo "Đã gỡ. Chạy 'im-config -n fcitx5' (hoặc ibus) nếu muốn đổi lại bộ gõ rồi đăng nhập lại."
