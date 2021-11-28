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
	sudo ln -s "${ROOT_DIR}/mailer" /usr/local/bin/mailer

remove:
	rm -rf /usr/local/bin/mailer
