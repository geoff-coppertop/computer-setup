#!/usr/bin/env bash

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update
    brew upgrade
fi

brew install python@3.9
brew install git

initdir=$pwd
workdir="/tmp/computer-setup"
if [ -d "$workdir" ]; then
  rm -Rf $workdir
fi
mkdir -p $workdir && cd $workdir

git clone https://github.com/geoff-coppertop/computer-setup.git .

python3.9 -m pip install --upgrade pip
pip3 install virtualenv

venvdir="./.venv"
virtualenv $venvdir
source "$venvdir/bin/activate"

pip install -r ./requirements.txt
ansible-galaxy install -r ./requirements.yml

ansible-playbook ./playbooks/setup.yml -K

deactivate

cd $initdir
rm -rf $workdir
