#!/bin/bash
# Creates aws host machine and installs dependencies.

if [[ $# -lt 1 ]] 
 then 
 echo "Creates aws host machine and installs dependencies."
 echo "USAGE: create-machine.sh [vpc-id] [machine-name]"
 echo "vpc-id: id of VPC for us-west-2 region."
 exit 1
fi

MACHINE_NAME="aws-neural-style-01"
if ! [[ -z "$2" ]]
 then
 MACHINE_NAME="$2"
fi

# create machine
docker-machine create --driver amazonec2 \
                      --amazonec2-region us-west-2 \
                      --amazonec2-zone b \
                      --amazonec2-ami ami-01a4e5be5f289dd12 \
                      --amazonec2-instance-type p2.xlarge \
                      --amazonec2-root-size 100 \
                      --amazonec2-vpc-id $1 \
                      $MACHINE_NAME

# restart and test initilization
docker-machine restart $MACHINE_NAME
if [[ $(docker-machine status $MACHINE_NAME) != "Running" ]]
 then
 echo "$MACHINE_NAME did not start aborting."
 exit 1
fi 

# install deps on instance
echo "Installing Dependencies"
docker-machine ssh $MACHINE_NAME 'sudo usermod -aG docker $USER'
docker-machine ssh $MACHINE_NAME 'curl -L https://api.github.com/repos/maxmurder/dockerfiles/tarball/master | tar -xzf - --strip-components 1'
docker-machine ssh $MACHINE_NAME 'chmod +x neural-style/scripts/*.sh && ./neural-style/scripts/install-instance-deps.sh'
docker-machine ssh $MACHINE_NAME 'docker build -t neural-style neural-style/'
docker-machine ssh $MACHINE_NAME 'mkdir -p images/content images/styles images/output'
docker-machine restart $MACHINE_NAME 

#set up envinronment
eval $(docker-machine env $MACHINE_NAME)
export NV_HOST="ssh://ubuntu@$(docker-machine ip $MACHINE_NAME):"
ssh-add ~/.docker/machines/$MACHINE_NAME/id_rsa
