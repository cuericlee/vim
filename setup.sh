#! /bin/bash

GOLANG_VERSION=${GOLANG_VERSION:-1.7.3}
GOLANG_TAR=${GOLANG_TAR:-go${GOLANG_VERSION}.linux-amd64.tar.gz}

echo "This won't be fast, take a seat and have a cup of tea:D"
if which apt-get >/dev/null; then
	sudo apt-get install -y wget vim vim-gnome ctags xclip astyle python-setuptools python-dev git
elif which yum >/dev/null; then
	sudo yum install -y wget gcc vim git ctags xclip astyle python-setuptools python-devel	
fi

##Add HomeBrew support on  Mac OS
if which brew >/dev/null;then
    echo "You are using HomeBrew tool"
    brew install vim ctags git astyle
fi

echo "Configuring golang environment, version ${GOLANG_VERSION}..."
if which go > /dev/null; then
    echo "Retain original golang Environment"
    echo `go version`
else
    wget https://storage.googleapis.com/golang/${GOLANG_TAR}
    sudo tar -C /usr/local -xzf ${GOLANG_TAR}
    cat >>~/.bashrc <<EOF

#export environment for golang
export GOPATH=\$HOME/go-project
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin/
EOF
fi

export GOPATH=$HOME/go-project
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin/

mkdir -p ${GOPATH}

sudo easy_install -ZU autopep8 
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
mv -f ~/vim ~/vim_old
cd ~/ && git clone https://github.com/Crazykev/vim.git
mv -f ~/.vim ~/.vim_old
mv -f ~/vim ~/.vim
mv -f ~/.vimrc ~/.vimrc_old
mv -f ~/.vim/.vimrc ~/
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
echo "Installing bundle ..." > crazykev
echo "Will exit when install finished" >> crazykev
echo "Please be patient" >> crazykev
vim crazykev -c "BundleInstall" -c "q" -c "q"
echo "Installing golang tools dependency binaries" >> crazykev
vim crazykev -c "GoInstallBinaries" -c "qa"
rm crazykev

echo "Install finished"

