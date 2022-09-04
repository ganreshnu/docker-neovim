#!/bin/bash -il

function showhelp() {
	cat << EOD
Usage: nvim [OPTIONS] COMMAND

A docker container for Neovim.

Options:
  --update	Updates the configuration
  --git-name	Git configuration user.name
  --get-email	Git configuration user.email
  --help	Show this message

In order to use gpg, you must either build an additional container or bind mount
the correct sockets.

# with the host gpg-agent
alias nvim='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "\$PWD":"\$PWD" -w "\$PWD" -v "\$(gpgconf --list-dir agent-extra-socket)":"$(gpgconf --list-dir agent-socket)" -v "\$(gpgconf --list-dir agent-ssh-socket)":"$(gpgconf --list-dir agent-ssh-socket)" neovim --git-name "\$(git config user.name)" --git-email "\$(git config user.email)" nvim'

# with the container gpg-agent
alias nvim='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "\$PWD":"\$PWD" -w "\$PWD" neovim --git-name "\$(git config user.name)" --git-email "\$(git config user.email)" nvim'

To build the key into a container, clone https://github.com/ganreshnu/docker-neovim.git and run:

. .env && build --help
EOD
}

if [ $# -eq 0 ]; then
	showhelp
	exit 1
fi

wanthelp=0
while :
do
	if [[ "$1" == --* ]]; then
		case "$1" in
			--help )
				wanthelp=1
				shift
				;;
			--git-name )
				git config --global user.name "$2"
				shift 2
				;;
			--git-email )
				git config --global user.email "$2"
				shift 2
				;;
			--update )
				for i in ${XDG_CONFIG_HOME}/*; do
					git -C $i pull --quiet
				done
				git -C ${HOME}/.ssh pull --quiet
				nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
				shift
				;;
			* )
				>&2 echo "unknown option: $1"
				wanthelp=2
				shift
				;;
		esac
	else
		break
	fi
done

[ $wanthelp -eq 1 ] && showhelp && exit
[ $wanthelp -eq 2 ] && showhelp && exit 1

sudo chown root:neovim /var/run/docker.sock

exec $@
