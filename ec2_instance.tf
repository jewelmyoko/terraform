/*
data "aws_availability_zones" "my_az" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
*/

resource "aws_instance" "ydn-test-ec2" {
  ami = data.aws_ami.amzlinux2.id
  #instance_type          = var.instance_type
  #instance_type          = var.instance_type_list[0] #For List
  instance_type          = var.instance_type_map["dev"] #For List
  user_data              = file("${path.module}/app1_install.sh")
  key_name               = var.instance_keypair
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  #for_each               = toset(data.aws_availability_zones.my_az.names)
  for_each          = toset(keys({ for az, details in data.aws_ec2_instance_type_offerings.my_ins_type : az => details.instance_types if length(details.instance_types) != 0 }))
  availability_zone = each.key
  tags = {
    "Name" = "ydn_ec2_test_${each.key}"
  }
}
