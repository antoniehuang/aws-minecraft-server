resource "aws_instance" "minecraft_server" {
  ami           = "ami-0c38b837cd80f13bb"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  security_groups = [aws_security_group.minecraft_server_security_group.name]

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_security_group" "minecraft_server_security_group" {
  name        = "minecraft_server_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0f1157a7164478653" # AWS eu-west-1 default VPC

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_minecraft_port" {
  security_group_id = aws_security_group.minecraft_server_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25565
  ip_protocol       = "tcp"
  to_port           = 25565

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_eu_west_1_instance_connect" {
  security_group_id = aws_security_group.minecraft_server_security_group.id
  cidr_ipv4         = "18.202.216.48/29"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.minecraft_server_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.minecraft_server_security_group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_ebs_volume" "minecraft_server_ebs" {
  availability_zone = aws_instance.minecraft_server.availability_zone
  size              = 8

  tags = {
    Name = "aws-minecraft-server-from-terraform"
  }
}

resource "aws_volume_attachment" "minecraft_server_ebs_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.minecraft_server_ebs.id
  instance_id = aws_instance.minecraft_server.id
}

