#!/bin/bash
sudo yum install httpd wget unzip vim -y
sudo systemctl start httpd
sudo systemctl enabled httpd
sudo mkdir -p /tmp/website
cd /tmp/website
sudo wget https://www.tooplate.com/zip-templates/2134_gotto_job.zip
sudo unzip -o 2134_gotto_job.zip
sudo cp -r 2134_gotto_job/* /var/www/html
sudo systemctl restart httpd

