#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
sudo rm /var/www/html/*.html
sudo git clone https://github.com/sambarnavyasri/food.git /var/www/html

