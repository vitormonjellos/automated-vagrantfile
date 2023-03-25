#!/bin/bash
set -e

green=$(tput setaf 2)
bold=$(tput bold)
normal=$(tput sgr0)

vm_total=$(grep -i "virtual_machines_total: " vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_hostname=$(grep -i "^virtual_machines_hostname:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_image=$(grep -i "^virtual_machine_image:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_image=$(grep -i "^virtual_machine_image:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_memory=$(grep -i "^total_memory:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_cpu=$(grep -i "^total_cpu:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_ip=$(grep -i "^virtual_machine_eth01:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')
vm_id_device_field=$(grep -i "^virtual_machine_eth01_device_start:" vagrant-configfile.yaml | cut -d ':' -f 2 | tr -d ' "')

printf "             Vagrant summary\n"
printf "${bold}===========================================${normal}\n"
printf "${bold}Total of Virtual Machines${normal}: ${green} %d\n${normal}" "$vm_total"
printf "${bold}Base hostname${normal}: ${green}%s\n${normal}" "$vm_hostname"
printf "${bold}Virtual Machine Image${normal}: ${green}%s\n${normal}" "$vm_image"
printf "${bold}Total memory for each${normal}: ${green}%s\n${normal}" "$vm_memory"
printf "${bold}Total CPU for each${normal}: ${green}%d\n${normal}" "$vm_cpu"
printf "${bold}IP will start At${normal}: ${green}%s%s\n${normal}" "$vm_ip$vm_id_device_field"


cat << EOF > Vagrantfile  
(1..$vm_total).each do |i|
  Vagrant.configure("2") do |config|
    config.vm.define "$vm_hostname-#{i}" do |node|
      node.vm.box = "$vm_image"
      node.vm.hostname = "$vm_hostname-#{i}"
      node.vm.network "private_network", ip: "$vm_ip#{$vm_id_device_field + i}"
      node.vm.provider :libvirt do |libvirt|
        libvirt.driver = "kvm"
        libvirt.memory = $vm_memory
        libvirt.cpus = $vm_cpu
      end
      node.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get upgrade -y
      SHELL
    end
  end
end
EOF