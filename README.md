# Rustkey

Fork của [Rustype](https://github.com/tr-nam/rustype) (MIT, © NamTr_n) cho **Linux Mint Cinnamon / X11**.
Lõi Telex/VNI và máy chủ giao thức IBus giữ nguyên; bỏ phần phụ thuộc GNOME (gsettings, extension, systemd drop-in).
`rustkey-linux` thay `ibus-daemon`, mặc định bật tiếng Việt.

Cài: `./install.sh` (cần Rust, `ibus`, `ibus-gtk3`), rồi đăng xuất/đăng nhập. Gỡ: `./uninstall.sh`.
Panel: `install.sh` đặt rustkey làm nguồn nhập đầu tiên của Cinnamon; applet bàn phím có sẵn hiện nhãn VN/EN, bấm vào để bật/tắt tiếng Việt hoặc chọn Telex/VNI. Ctrl+Shift vẫn đổi được.
Chưa làm: `--doctor`/`--activate` vẫn là bản GNOME.
