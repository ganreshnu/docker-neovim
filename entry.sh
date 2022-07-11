#!/bin/bash -il

function showhelp() {
	cat << 'EOD'
This is the help.
EOD
}

for i in ${XDG_CONFIG_HOME}/*; do
	git -C $i pull --quiet
done
git -C ${HOME}/.ssh pull --quiet

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

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
			* )
				echo "unknown option $1"
				wanthelp=1
				shift
				;;
		esac
	else
		break
	fi
done

if [ $wanthelp -eq 1 ]; then
	showhelp
	exit
fi

#
# Add these lines to your .bashrc
#
#alias nvim='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "\$PWD":"\$PWD" -w "\$PWD" -v "\$(gpgconf --list-dir agent-extra-socket)":"$(gpgconf --list-dir agent-socket)" -v "\$(gpgconf --list-dir agent-ssh-socket)":"$(gpgconf --list-dir agent-ssh-socket)" neovim nvim'
#alias nvim='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "\$PWD":"\$PWD" -w "\$PWD" neovim bash'

exec $@
