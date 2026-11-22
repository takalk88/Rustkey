#!/usr/bin/env bash
# Rustkey cho Linux Mint (Cinnamon, X11). Cài ở mức người dùng, không cần sudo, trừ bước im-config nếu có.
set -euo pipefail
cd "$(dirname "$0")"
cargo build --release -p rustkey-linux
install -Dm755 target/release/rustkey-linux "$HOME/.local/bin/rustkey-linux"
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/rustkey.desktop" <<D
[Desktop Entry]
Type=Application
Name=Rustkey
Exec=$HOME/.local/bin/rustkey-linux --replace --own-session-name
X-GNOME-Autostart-enabled=true
NoDisplay=true
D
# Ứng dụng phải dùng giao thức IBus; Rustkey thay ibus-daemon.
# im-config chạy ibus-daemon và chiếm tên org.freedesktop.IBus; chỉ đặt biến môi trường.
cat > "$HOME/.xinputrc" <<X
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export CLUTTER_IM_MODULE=ibus
export SDL_IM_MODULE=ibus
X
# Tắt autostart của ibus-daemon/fcitx để không tranh nhau.
for f in org.fcitx.Fcitx5 fcitx5 ibus-daemon; do
  [ -e "/etc/xdg/autostart/$f.desktop" ] && printf '[Desktop Entry]\nHidden=true\n' > "$HOME/.config/autostart/$f.desktop"
done
# Panel VN/EN: applet bàn phím của Cinnamon hiện nhãn VN/EN và menu của Rustkey khi rustkey là nguồn nhập đang dùng.
# Python của hệ thống mới có python3-gi; python3 trong PATH có thể là bản khác.
/usr/bin/python3 - <<'P'
from gi.repository import Gio, GLib
ID, RK = "org.cinnamon.desktop.input-sources", ("ibus", "rustkey")
if Gio.SettingsSchemaSource.get_default().lookup(ID, True):
    s = Gio.Settings.new(ID)
    rest = [x for x in s.get_value("sources").unpack() if x != RK]
    s.set_value("sources", GLib.Variant("a(ss)", [RK] + rest))
    s.set_uint("current", 0)
    Gio.Settings.sync()
P
echo "Xong. Đăng xuất rồi đăng nhập lại. Cần gói ibus, ibus-gtk3 (và ibus-gtk4 nếu dùng GTK4)."
