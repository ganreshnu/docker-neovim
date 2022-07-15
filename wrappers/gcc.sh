#!/bin/bash

docker run --rm -t -v "$PWD":"$PWD" -w "$PWD" neovim-devel /usr/sbin/gcc $@
