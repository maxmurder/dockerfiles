# neural-style

Dockerized neural style transfer algorithm [jcjohnson/neural-style](https://github.com/jcjohnson/neural-style), intended for use with AWS p2 instances.

### Requirements
* [docker](https://www.docker.com/)
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
* Appropriate nvidia drivers for your GPU hardware.

##### AWS
* AWS account with ability to create p2xlarge instances.

### Installation
##### Local
* build docker image
	nvidia-docker build -t neural-style neural-style/
* run
	nvidia-docker --rm -v $(pwd):/images --content_image content_iamge.jpg --style_image style_image.jpg --output_image neural_output.png

##### AWS
* Set up AWS user
1. <i>Identity and Access Management > Users </i>
2. Create a new user
3. Save the generated keypair <b> Access Key / Secret Key </b>
4. Add policy AmazonEC2FullAccess to user permissions.

* Get VPC ID
1. <i> VPC > Subnets </i>
2. Select Region US-West-2 (Oregon) 
3. Copy VPC ID

* Create host machine. Replace [VPC ID] with your VPC ID.
	sudo ./scripts/create-machine.sh [VPC ID]
* SSH into machine
	sudo docker-machine ssh aws-neural-style-01

