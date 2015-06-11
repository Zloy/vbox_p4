Vagrant.configure("2") do |config|

  boxes = {
      "p4" => "10.2.2.15",
  }

  boxes.each do |box_name, box_ip|
    config.vm.define box_name do |config|
      #config.vm.box = "package.box"
      #config.vm.box_url = "./package.box" # some cookbooks applied
      config.vm.box = "trusty-64"
      config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      config.vm.hostname = "p4"
      config.vm.network :private_network, ip: box_ip
      config.vm.network "forwarded_port", guest: 3000, host: 3000
      config.vm.network "forwarded_port", guest: 3001, host: 3001
      config.vm.network "forwarded_port", guest: 3002, host: 3002
      config.vm.network "forwarded_port", guest: 3003, host: 3003
      
      config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.name = "p4"
      
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "1024"]
      end

      config.vm.synced_folder "../..", "/home/vagrant/my_src"
      config.ssh.forward_agent = true # to use host keys added to agent

      # provisioning
      config.vm.provision :shell, :inline => "sudo apt-get update"

      config.vm.provision "chef_solo" do |chef|
        chef.log_level = "info"
        chef.environment = "development"
        chef.environments_path = "environments"
        chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
        chef.roles_path = "roles"
        chef.data_bags_path = "data_bags"
        chef.json.merge!(JSON.parse(IO.read("nodes/#{box_ip}.json")))
      end

      config.exec.commands '*', directory: '/home/vagrant'
      config.exec.commands 'apt-get', prepend: 'sudo'
      config.exec.commands %w[rails rspec rake], prepend: 'bundle exec'
    end
  end
end
