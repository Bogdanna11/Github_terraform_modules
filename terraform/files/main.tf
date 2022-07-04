#launch a server on aws

#who is the cloud provider

# where do we w 

# what type of server -ubuntu 18.04 LTS - ami 

#size of the server t2 micro 

# do we need it to have a public access ?

# what do we want to name it 
  

module "key" {
 source = "./key"

resource "aws_instance" "app_instance" {

 ami = "ami-0b47105e3d7fc023e"
 instance_type = "t2.micro"
 associate_public_ip_address = true
 vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public_eu_west_1c.id

 tags = {

     Name = "Eng114_bogdana_terraform"
 }

}
}
