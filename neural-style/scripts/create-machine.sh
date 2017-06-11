#!/bin/bash
# Creates aws host machine and installs dependencies.

if [[$# -lt 1]] then 
 echo "Creates aws host machine and install dependencies for neural-style"
 echo "USAGE: create-machine.sh [vpc-id] [machine-name]"
 exit 1   
fi

MACHINE_NAME="aws-neural-style-01"
if ![[ -z "$2"]]  then
 MACHINE_NAME="$2"
fi

# check pems
if groups $USER | grep &>/dev/null 'bdocker\b'; then SU=""
else SU="sudo"; 
fi

# create machine
$SU docker-machine create --driver amazonec2 \
                      --amazonec2-region us-west-2 \
                      --amazonec2-zone b \
                      --amazonec2-ami ami-efd0428f \
                      --amazonec2-instance-type p2.xlarge \
                      --amazonec2-vpc-id $2 \
#                      --amazonec2-access-key  AKI*** \
#                      --amazonec2-secret-key *** \
                      $MACHINE_NAME
$SU docker-machine restart $MACHINE_NAME

# install deps
#SU docker-machine ssh $MACHINE_NAME
mkdir dockerfiles
curl -L https://api.github.com/repos/maxmurder/dockerfiles/tarball/master | tar -xzf - -C dockerfiles --strip-components 1
sh dockerfiles/neural-style/install-instance-deps.sh
sudo nvidia-docker build -t neural-style dockerfiles/neuralstyle/
exit

$SU docker-machine restart 

# set environment
eval $(docker-machine env $MACHINE_NAME)
export NV_HOST="ssh://ubuntu@$(docker-machine ip $MACHINE_NAME):"
ssh-add ~/.docker/machine/machines/$MACHINE_NAME/id_rsa

#test
$SU nvidia-docker run --rm nvidia/cuda nvidia-smi
