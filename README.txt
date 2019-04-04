############################################################
# MariaDB - MySQL (in a Docker Container) for Raspberry Pi #
#                                 REF: https://mariadb.org #
############################################################


###############################################################################
# Docker build
##############
ssh YourRaspberryPi
sudo bash
mkdir /opt/docker-compose && cd /opt/docker-compose
git clone https://github.com/ernestgwilsonii/docker-raspberry-pi-mariadb.git
cd docker-raspberry-pi-mariadb

# Build the Docker container
time docker build --no-cache -t ernestgwilsonii/docker-raspberry-pi-mariadb:10.1.37 -f Dockerfile.armhf .
docker images

# Verify 
docker run --name mysql -it -e MYSQL_ROOT_PASSWORD=SetThisToSomethingStrong! -p 3306:3306 ernestgwilsonii/docker-raspberry-pi-mariadb:10.1.37
# From another ssh session:
docker ps
docker exec -it $(docker ps | grep mysql | awk '{print $1}') bash
mysql -u root -p
SHOW DATABASES;
exit
exit
docker stop mysql && docker rm mysql

# Upload to Docker Hub
docker login
docker push ernestgwilsonii/docker-raspberry-pi-mariadb:10.1.37
###############################################################################


###############################################################################
# First time setup #
####################

# Create the bind mount directories and copy files to the correct node based on constraints in the docker-compose!
mkdir -p /opt/mysql/var/lib/mysql
chmod a+rw -R /opt/mysql
chown -R 101:101 /opt/mysql

##########
# Deploy #
##########
# Deploy the stack into a Docker Swarm
docker stack deploy -c docker-compose.yml mysql
#docker stack rm mysql

# Verify Docker
docker ps | grep -E "ID|mysql"
docker stack ls | grep -E "NAME|mysql"
docker service ls | grep -E "ID|mysql"
docker service logs -f mysql_mysql

# Verify MySQL
docker exec -it $(docker ps | grep mysql | awk '{print $1}') bash
mysql -u root -p
SHOW DATABASES;
exit
exit
###############################################################################
