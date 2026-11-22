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
im-config -n ibus
# Tắt autostart của ibus-daemon/fcitx để không tranh nhau.
for f in org.fcitx.Fcitx5 fcitx5 ibus-daemon; do
  [ -e "/etc/xdg/autostart/$f.desktop" ] && printf '[Desktop Entry]\nHidden=true\n' > "$HOME/.config/autostart/$f.desktop"
done
echo "Xong. Đăng xuất rồi đăng nhập lại. Cần gói ibus, ibus-gtk3 (và ibus-gtk4 nếu dùng GTK4)."
