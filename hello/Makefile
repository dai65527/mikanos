DEVENVDIR := ../devenv

CC := clang
CFLAGS := -target x86_64-pc-win32-coff \
			-mno-red-zone \
			-fno-stack-protector \
			-fshort-wchar \
			-Wall

.PHONY: all
all: run

.PHONY: run
run: disk.img 
	qemu-system-x86_64 \
	--drive if=pflash,file=$(DEVENVDIR)/OVMF_CODE.fd \
	--drive if=pflash,file=$(DEVENVDIR)/OVMF_VARS.fd \
	-hda disk.img

hello.efi: hello.o
	lld-link /subsystem:efi_application /entry:EfiMain /out:$@ $<

disk.img: create-diskimg.sh hello.efi
	./create-diskimg.sh

.PHONY: clean
clean:
	sudo umount mnt || :
	$(RM) disk.img hello.o hello.efi

.PHONY:
re: clean all
