DEVENVDIR := ../devenv/

.PHONY: all
all: run

.PHONY: run
run: disk.img 
	qemu-system-x86_64 \
	--drive if=pflash,file=$(DEVENVDIR)/OVMF_CODE.fd \
	--drive if=pflash,file=$(DEVENVDIR)/OVMF_VARS.fd \
	-hda disk.img

disk.img: create-diskimg.sh hello.efi
	./create-diskimg.sh

.PHONY: clean
clean:
	sudo umount mnt || :
	$(RM) disk.img
