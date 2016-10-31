#!/bin/bash

source scripts/cli.sh

azure_display_rgs() {
    az resource group list -o table \
       --query '[].{name:name,location:location}'
}

azure_get_instance_ips_by_rg() { 
    RG=$1 
    need_rg $RG

    az vm list-ip-addresses -g $RG -o table \
       --query "[].{\
                 name:virtualMachine.name,\
                 privateIP:virtualMachine.network.privateIpAddresses[0],\
                 publicIP:virtualMachine.network.publicIpAddresses[0].ipAddress \
               }"
} 

