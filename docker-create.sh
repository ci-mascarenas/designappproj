#!/bin/sh
clear
PORT=5050
USERNAME="daUser"
CONTAINER_NAME="da"
PYTHON_FILE="design_app.py"
DOCKER_FOLDER="dockerFiles"
PIP_REQUIREMENTS="flask"
cat << EOF
Docker create
EOF
if (test -f $PYTHON_FILE)
then
    echo "Copying Python File"
    mkdir -p $DOCKER_FOLDER && cp $PYTHON_FILE $DOCKER_FOLDER/.
else
    echo "Error: No Python File found"
    exit 1
fi
if (test -d "templates/")
then
    echo "Copying Templates"
    mkdir -p $DOCKER_FOLDER/templates && cp templates/* $DOCKER_FOLDER/templates/.
else
    echo "Error: No Templates folder"
    exit 2
fi
if (test -d "static/")
then
    echo "Copying Static"
    mkdir -p $DOCKER_FOLDER/static && cp static/* $DOCKER_FOLDER/static/.
else
    echo "Error: No Static folder"
    exit 3
fi
cat << EOF > $DOCKER_FOLDER/Dockerfile
FROM python
RUN useradd -ms /bin/bash $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
ENV PATH="$PATH:/home/$USERNAME/.local/bin"
COPY . /home/$USERNAME/$CONTAINER_NAME
EXPOSE $PORT
RUN python3 -m pip --disable-pip-version-check --quiet install $PIP_REQUIREMENTS --upgrade pip
CMD python3 /home/$USERNAME/$CONTAINER_NAME/$PYTHON_FILE
EOF
cd $DOCKER_FOLDER
if !(test $(docker ps -aq -f name=$(echo "$CONTAINER_NAME" | tr '[:upper:]' '[:lower:]')))
then docker build --force-rm=true -t $(echo "$CONTAINER_NAME" | tr '[:upper:]' '[:lower:]') .
else
    echo "Deleting existing container"
    docker rm --force $(echo "$CONTAINER_NAME" | tr '[:upper:]' '[:lower:]')
    docker build --force-rm=true -t $(echo "$CONTAINER_NAME" | tr '[:upper:]' '[:lower:]') .
fi
if !(test $(netstat -tuln | grep LISTEN | awk '{print $4}' | grep -w "$PORT" | wc -l) -gt 0)
then docker run -dtp $PORT:$PORT --name $(echo "$CONTAINER_NAME" | tr '[:upper:]' '[:lower:]') $(echo "$CONTAINER_NAME" | tr '[:upper:]' '[:lower:]')
else
    echo "Error: Port $PORT is currently in use"
    exit 4
fi
exit 0