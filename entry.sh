#!/bin/bash -il

for i in ${XDG_CONFIG_HOME}/*; do
	git -C $i pull --quiet
done
git -C ${HOME}/.ssh pull --quiet

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

if [[ $1 == 'powershell-alias' ]]; then
	cat "/usr/share/alias.ps1"
	exit
fi

if [[ $1 == 'bash-alias' ]]; then
	cat "/usr/share/alias.sh"
	exit
fi

exec $@
