vbox_p4
=======

Rails development VM environment vagrant and chef configs for
the project [p4](https://github.com/Zloy/p4-site.git)

It installs nginx, redis, postgresql and configures them.

It expects RAILS application to be in ```../``` folder

It doesn't require any configuration to start RAILS application, 
except of gem installation and database preparation. 

## Prerequisites

These packages should be installed on Host machine

  * **ruby** 2.0
  * **librarian-chef** gem should be installed as system gem or in default gemset.
  * **VirtualBox**
  * **vagrant** see [here](https://www.vagrantup.com/downloads.html)

## Using

### Setup DB user an password

Check out application DB user and its password in `vbox/roles/db-master.json`, and set them in `RAILS_ROOT/config/database.yml`, or change them in `vbox/roles/db-master.json` 

### Create a box

Assume you got `my_src` folder and  there is `p4-site` folder inside it.

```
cd my_src
git clone git@github.com:Zloy/vbox_p4.git
cd vbox_p4
gem install librarian-chef
librarian-chef install
vagrant up
vagrant ssh
```

### Setup the application

Being logged in to the box, execute:

```
cd ~/p4-site
bundle install

bundle exec rake db:setup
bundle exec rails s
```

## TODO

* add `apache2-utils` package
* configure redis
* configure nginx
* set ~/.irbrc and ~/.irb_history

## Notes

Be patient, It took  vagrant up about **20 minutes** to complete

To speed up developing the box [vagrant snapshot plugin](https://github.com/dergachev/vagrant-vbox-snapshot) is a must have tool. It allows you to make a VM snapshot after all working recipies apllied, and before *work in progress recipe* run. Next time *work in progress recipe* failed, just run `vagrant snapshot go` to revert changes introduced by *work in progress recipe* execution, edit *work in progress recipe* and run it again. Repeat until succeded.

## Error: version `LIBXML2_2.9.0' not found

$ export NOKOGIRI_USE_SYSTEM_LIBRARIES=1 && gem pristine nokogiri
