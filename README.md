# mailer

## Usage

[mark-usage-start]::
```shell
usage: mailer [<command>] [<arguments>]

COMMANDS:

    file filepath         Set the content of mail from file.
    text text             Set the content of mail.
    update                Updates mailer. (Run as root)

ARGUMENTS:

    --to mail             Set the receiver.
    --subject subject     Set the subject of the mail.
    --headline headline   Set the headline inside the mail.
    --footer footer       Set the footer inside the mail.

    --help, -h            Print this help text and exit
    --version, -v         Print version and exit


```
[mark-usage-end]::


## Install

##### Install `mailer` with ([`install-mailer.sh`](https://raw.githubusercontent.com/lukasdanckwerth/mailer/main/install-mailer.sh)) script

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/mailer/main/install-mailer.sh)"
```
