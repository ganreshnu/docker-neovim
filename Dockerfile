FROM neovim-base

RUN --mount=type=secret,id=gpgkey,uid=1000 . /etc/profile.d/xdgenv.sh && \
	gpg --batch --import /run/secrets/gpgkey

