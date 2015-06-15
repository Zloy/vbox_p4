#!/bin/bash

node="$1"
json="$2"

if [ "$node" = "" ];
then
    echo "Usage: $0 node file"
    exit 1
fi

echo "install.sh started working on node $node"
source /etc/profile

if ! [ -x "$(command -v chef-solo 2> /dev/null)" ];
then
    apt-get update
    apt-get upgrade

    source_rvm_cmd="source /usr/local/rvm/scripts/rvm"
    if grep -Fxq "$source_rvm_cmd" /etc/profile
    then
        # code if found
        echo "rvm found!"
    else
        # code if not found
        apt-get install -y curl
        curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
        curl -sSL https://get.rvm.io | bash -s stable
        echo "$source_rvm_cmd" >> /etc/profile
        source /etc/profile
    fi
    rvm install ruby-2.0.0-p645 --default
    echo "Installing chef gem..."
    gem install chef --no-rdoc --no-ri --version="12.3.0"
fi

export LANGUAGE="en_US.UTF-8"
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

echo "Processing cokbooks with Chef..."
chef-solo -c solo.rb -j "$json" -E staging
