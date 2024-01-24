sudo apt-get update
sudo apt-get install tmux libncurses-dev
cd ~
git clone https://github.com/vim/vim.git
git clone https://github.com/VundleVim/Vundle.vim.git
cd ~
mkdir ~/.vim
mkdir ~/.vim/bundle
cd ~
mv ~/Vundle.vim  ~/.vim/bundle
cd vim/
make clean distclean

./configure --with-python3-command=python3.7 \
			--with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
			--enable-python3interp \
			--enable-luainterp \
			--with-lua-prefix=/usr/lib/x86_64-linux-gnu/liblua5.3.so \
			--with-features=huge \
		    --enable-rubyinterp
            --enable-largefile \
            --disable-netbeans \
            --enable-perlinterp \
            --enable-gui=auto \
            --enable-fail-if-missing \
            --enable-cscope \
            --enable-multibyte
make
sudo make install
