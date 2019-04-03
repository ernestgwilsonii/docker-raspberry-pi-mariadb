#!/bin/bash

sudo -u root mkdir -p /opt/mysql/var/lib/mysql
sudo -u root chmod a+rw -R /opt/mysql
sudo -u root chown -R 101:101 /opt/mysql
