# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  # Manager node.
  config.vm.define "manager", primary: true do |manager|
    manager.vm.hostname = "manager-0"
    manager.vm.network "private_network", ip: "192.168.56.10"
    manager.vm.network "forwarded_port", guest: 80, host: 8080
    manager.vm.network "forwarded_port", guest: 443, host: 8443

    manager.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/vagrant.yml"
      ansible.compatibility_mode = "2.0"
      ansible.inventory_path = "inventories/dev/hosts"
      # ansible.groups = {
      #     "vagrant" => ["default"]
      # }
      ansible.vault_password_file = ".vault"
      ansible.limit = "all"
      ansible.verbose = "vv"
    end
  end

  # Worker node.
  config.vm.define "worker" do |worker|
    worker.vm.hostname = "worker-0"
    worker.vm.network "private_network", ip: "192.168.56.11"
    worker.vm.network "forwarded_port", guest: 80, host: 8081
    worker.vm.network "forwarded_port", guest: 443, host: 8444
  end

  #config.vm.provision :shell, :inline => "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Europe/Rome /etc/localtime", run: "always"
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # https://github.com/Karandash8/virtualbox_WSL2
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.gui = true
  end
end
