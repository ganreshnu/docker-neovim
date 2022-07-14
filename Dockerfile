FROM neovim

RUN --mount=type=secret,id=gpgkey,uid=1000 . /etc/profile.d/1-xdgenv.sh && \
	gpg --batch --import /run/secrets/gpgkey && \
	rm ${GNUPGHOME}/S.*

