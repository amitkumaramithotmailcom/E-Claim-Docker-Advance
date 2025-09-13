# Run eClaimApp, eClaimApi, SQL Server, and Redis in Docker container 

## Run containers using docker compose (App, Api, SQL Server, Redis)
#### 1. Stop containers if running
    Stop all containers:
	# docker stop $(docker ps -aq)

    Stop single containers:
	# docker stop <ContainerId>

#### 2. Remove containers
    Remove single containers:
	$ docker rm <RepositoryName>

    Remove all containers:
	docker rm $(docker ps -aq)	

#### 3. Remove images
    Remove single image:
    $ docker rmi <RepositoryName>

    Remove all images:
    docker rmi $(docker images -aq)

    Remove all images (force remove, even if containers are using the image):
	docker rmi -f $(docker images -aq)

#### 4. API & APP - Move on docker-compose.yml file folder
    $ cd E-Claim-Docker-Advance
    E-Claim-Docker-Advance $ cd Compose

    docker-compose.yml file : [text](https://github.com/amitkumaramithotmailcom/E-Claim-Docker-Advance/blob/main/Compose/docker-compose.yml)

#### 5. Run docker-compose command
    $ docker-compose up -d

#### 6. Check app running status
    $ docker ps 

#### 7. execute docker-compose command for down images
	$ docker-compose down

#### 8. execute docker logs command for show container logs
	$ docker logs dd66691aacc8






