#!/bin/bash
# hello.efiからqemu imageを作成する
# みかん本 1.4
# https://zenn.dev/karaage0703/articles/1bdb8930182c6c#1.4-%E3%82%A8%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%BF%E3%81%A7%E3%81%AE%E3%82%84%E3%82%8A%E6%96%B9

set -eux

# 200MBの空のディスクイメージのを作る
# Arguments
#   - -f raw: Rawディスクイメージフォーマット
#   - disk.img: 出力ファイル名
#   - 200M: ディスクイメージのサイズ
# 参考
#   - https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/5/html/virtualization/sect-virtualization-tips_and_tricks-using_qemu_img
#   - https://docs.fedoraproject.org/ja-JP/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Tips_and_tricks-Using_qemu_img.html
# MEMO
#   - このコマンドで作られるdisk.imgはただ0で埋められたファイルだった
#   ```
#   $ qemu-img create -f raw disk.img 200M
#   Formatting 'disk.img', fmt=raw size=209715200
#   $ hexdump disk.img 
#   0000000 0000 0000 0000 0000 0000 0000 0000 0000
#   *
#   c800000
#   ```
qemu-img create -f raw disk.img 200M

# disk.imgをFATイメージにフォーマットする
# Arguments
#   - -n volume name: ボリュームの名前
#   - -s 2: ディスクセクタの数 (?)
#   - -f 2: File Allocation Tableの数 (?)
#   - -R 32: 予約セクタ数 (?)
#   - -F 32: FAT32でフォーマット
# MEMO
#  - FAT: File Allocation Table (FAT) はコンピュータファイルシステムの構造であり、その構造を利用する業界標準のファイルシステムを指す
#  - USBメモリの代わりにディスクイメージを作ってフォーマットするようなイメージかな？
mkfs.fat -n 'MIKAN OS' -s 2 -f 2 -R 32 -F 32 disk.img

# mntディレクトリを作成(disk.imgのマウント先)
mkdir -p mnt

# disk.imgを./mntにディレクトリにマウントする
# Arguments
#   - -o loop: ループバックマウントするためのオプション
#              https://oplern.hatenablog.com/entry/2017/06/30/231027
#              https://qiita.com/aki3061/items/55e0061e6d5fca78631f#%E3%83%AB%E3%83%BC%E3%83%97%E3%83%90%E3%83%83%E3%82%AF%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AE%E6%B4%BB%E7%94%A8
#   - disk.img: ディスクイメージのパス
#   - mnt: マウント先のパス
sudo mount -o loop disk.img mnt

# マウントしたdisk.imgにバイナリを書き込む
# mnt/EFI/BOOT/BOOTX64.EFI
sudo mkdir -p mnt/EFI/BOOT
sudo cp hello.efi mnt/EFI/BOOT/BOOTX64.EFI

# アンマウント
sudo umount mnt
