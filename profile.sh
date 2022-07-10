###
### neovim alias
###
alias nvim='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):$(pwd) -w $(pwd) neovim nvim'

# vim: ff=unix
