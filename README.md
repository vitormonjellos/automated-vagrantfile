# Automated Vagrant file
Bash script that automates the Vagrantfile creation based on the vagrant-configfile.yaml variables.

## Usage
1. Ensure that you have the vagrant-configfile.yaml file in the same directory as the script.

2. Edit the vagrant-configfile.yaml with the necessary informations
The script retrieves the following configuration parameters from the vagrant-configfile.yaml file:

    `virtual_machines_total:` The total number of virtual machines to be created.  
    `virtual_machines_hostname:` The base hostname for the virtual machines.  
    `virtual_machine_image:` The VM image to be used.  
    `total_memory:` The amount of memory allocated to each VM.  
    `total_cpu:` The number of CPUs allocated to each VM.  
    `virtual_machine_eth01:` The IP address that the virtual machines will start at.  
    `virtual_machine_eth01_device_start:` The starting device ID for the virtual   

3. Make the script executable  

    ```
    chmod +x vagrant-generator.sh
    ```
4. Run the script: 
    ```
    ./vagrant-generator.sh
    ```

## Vagrantfile

After the Vagrant file generate, inside the directory, you can run a `vagrant validate` to validate the file and a `vagrant up` to start the machines. 