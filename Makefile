.DEFAULT_GOAL := install
.SILENT: install remove
.ONESHELL: install remove

ML_ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ML_LOCAL_VER := $(shell cat /etc/mailer/.version)
ML_REMOTE_VER := $(shell git rev-parse HEAD)
ML_USER := $(shell whoami)

install:
ifneq ($(ML_USER),root)
	@echo "[install]  run as root"
	exit
endif
ifeq ($(ML_LOCAL_VER),$(ML_REMOTE_VER))
	@echo "[install]  version ($(ML_LOCAL_VER)) already up-to-date"
	exit
endif

	echo "[install]  copy mailer to /usr/local/bin/mailer"
	cp -nf "${ML_ROOT_DIR}/mailer" /usr/local/bin/mailer

	echo "[install]  configure /etc/mailer directory"
	[ -d /etc/mailer ] || sudo mkdir /etc/mailer

	echo "[install]  guard config (/etc/mailer/mailer.conf) existence"
	[ -f /etc/mailer/mailer.conf ] || sudo cp "${ML_ROOT_DIR}/mailer.conf" /etc/mailer/mailer.conf

	echo "[install]  copy mail template"
	cp -nf "${ML_ROOT_DIR}/mail.html" /etc/mailer/mail.html

	sudo git rev-parse HEAD >/etc/mailer/.version
	echo "[install]  installed version:" $(shell cat /etc/mailer/.version)

remove:
ifneq ($(ML_USER),root)
	@echo "[remove]  run as root"
	exit
endif

	echo "[remove]  removing /usr/local/bin/mailer"
	[ -f /usr/local/bin/mailer ] && sudo rm -rf /usr/local/bin/mailer

	echo "[remove]  removing /etc/mailer"
	[ -d /etc/mailer ] && sudo rm -rf /etc/mailer
