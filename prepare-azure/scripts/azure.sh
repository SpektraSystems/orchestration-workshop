#!/bin/bash

source scripts/cli.sh

azure_display_rgs() {
    az resource group list -o table \
       --query '[].{name:name,location:location}'
}

azure_get_instance_ips_by_rg() { 
    RG=$1 

    if [ -z "$RG" ]; then
        az vm list-ip-addresses -o table \
           --query "[].{\
                 resourceGroup:virtualMachine.resourceGroup,\
                 name:virtualMachine.name,\
                 privateIP:virtualMachine.network.privateIpAddresses[0],\
                 publicIP:virtualMachine.network.publicIpAddresses[0].ipAddress \
               }"
    else
        az vm list-ip-addresses -g $RG -o table \
           --query "[].{\
                 resourceGroup:virtualMachine.resourceGroup,\
                 name:virtualMachine.name,\
                 privateIP:virtualMachine.network.privateIpAddresses[0],\
                 publicIP:virtualMachine.network.publicIpAddresses[0].ipAddress \
               }"
    fi
} 

azure_start_instances_by_rg() {
    RG=$1

    if [ -z "$RG" ]; then
        for ((i = 1; i <= $TRAINEE_COUNT; i++))
        do
            for ((j = 0; j < $CLUSTER_SIZE; j++))
            do
                echo "Starting vm trainee-vm-$j in docker-trainee-$i"
                az vm start -g docker-trainee-$i -n trainee-vm-$j
            done
        done
    else
        for ((j = 0; j < $CLUSTER_SIZE; j++))
        do
            echo "Starting vm trainee-vm-$j in $RG"
            az vm start -g $RG -n trainee-vm-$j
        done
    fi
}

azure_stop_instances_by_rg() {
    RG=$1

    if [ -z "$RG" ]; then
        for ((i = 1; i <= $TRAINEE_COUNT; i++)) 
        do
            for ((j = 0; j < $CLUSTER_SIZE; j++))
            do
                echo "Deallocating vm trainee-vm-$j in docker-trainee-$i"
                az vm deallocate -g docker-trainee-$i -n trainee-vm-$j
            done
        done
    else
        for ((j = 0; j < $CLUSTER_SIZE; j++))
        do
            echo "Deallocating vm trainee-vm-$j in $RG"
            az vm deallocate -g $RG -n trainee-vm-$j
        done
    fi
}

azure_kill_instances_by_rg() {
    RG=$1

    if [ -z "$RG" ]; then
        for ((i = 1; i <= $TRAINEE_COUNT; i++))
        do
            echo "Deleting resource group docker-trainee-$i"
            az resource group delete -n docker-trainee-$i
        done
    else
        echo "Deleting resource group $RG"
        az resource group delete -n $RG
    fi
}
