# Create an EC2 instance
resource "aws_instance" "bookapp_instance" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  
  subnet_id     = "subnet-0ad812240ac7ad07c"  # Replace with the ID of your desired subnet
  
  tags = {
    Name = "bookapp_instance"
  }

  # Declare your input variables
variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  volume_tags = {
    Name = "bookapp_instance"
  }

  # Specify the user_data script to run during instance startup
  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo apt-get install -y git
sudo npm install -g pm2
sudo git clone "https://github.com/ammulu02/Book_App-using_DynamoDB.git"
cd "bookapp"
sudo tee .env > /dev/null << EOL
PORT=3000
AWS_ACCESS_KEY_ID=${var.aws_access_key}
AWS_SECRET_ACCESS_KEY=${var.aws_secret_key}
EOL
sudo npm install
sudo pm2 start server.js
EOF
}
