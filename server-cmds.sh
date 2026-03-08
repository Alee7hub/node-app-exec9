export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PASS=$3

docker login -u $DOCKER_USER -p $DOCKER_PASS
docker-compose -f docker-compose.yaml up --detach
echo "success"