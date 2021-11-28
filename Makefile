.DEFAULT_GOAL := manual
.SILENT: manual
.ONESHELL: install

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ML_DIR := "/etc/mailer"
ML_USER := $(shell whoami)

manual:
	@echo "make <command>"
	@echo ""
	@echo "install:  creates a link to mailer at /usr/local/bin/mailer"
	@echo "remove:  removes the link at /usr/local/bin/mailer"
	@echo ""

install:
ifneq ($(ML_USER),root)
	@echo "run as root"
	exit
endif

	cp -nf "${ROOT_DIR}/mailer" /usr/local/bin/mailer
	[ -d /etc/mailer ] || sudo mkdir /etc/mailer
	[ -f /etc/mailer/mailer.conf ] || sudo cp "${ROOT_DIR}/mailer.conf" /etc/mailer/mailer.conf
	cp -nf "${ROOT_DIR}/mail.html" /etc/mailer/mail.html
	sudo git rev-parse HEAD >/etc/mailer/.version

remove:
	[ -f /usr/local/bin/mailer ] && sudo rm -rf /usr/local/bin/mailer
	[ -d /etc/mailer ] && sudo rm -rf /etc/mailer
