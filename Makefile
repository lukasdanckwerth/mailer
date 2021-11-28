.DEFAULT_GOAL := manual
.SILENT: manual
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

manual:
	@echo "make <command>"
	@echo ""
	@echo "install:  creates a link to mailer at /usr/local/bin/mailer"
	@echo "remove:  removes the link at /usr/local/bin/mailer"
	@echo ""

install:
	sudo cp -nf "${ROOT_DIR}/mailer" /usr/local/bin/mailer
	[ -d /etc/mailer ] || sudo mkdir /etc/mailer
	[ -f /etc/mailer/mailer.conf ] || sudo cp "${ROOT_DIR}/mailer.conf" /etc/mailer/mailer.conf

remove:
	[ -f /usr/local/bin/mailer ] && sudo rm -rf /usr/local/bin/mailer
	[ -f /etc/mailer.conf ] && sudo rm -rf /etc/mailer
