# My stupid Dictionary API

Produces an API that runs on docker/podman container with the following functions currently:

* /randword?length=x will retrun a random word of that length  
* /randword?min_length=x&max_length=y will find a word between those lengths 
* /wordinfo?word=word will give you the info we have on that word.

## Installation/usage

### Prereqs
  You will want podman or docker installed locally. I suggest podman desktop for windows or mac:  
  https://podman-desktop.io/  


## Building the container

I will be using podman commands, but the docker commands should just require you to change "podman" to "docker".

In the root directory of this project run:
`podman build -t dictapi:local-latest ./`

This will build a local copy of the container based on the Dockerfile

## Running the container

Simply run: `podman run -p 8080:4567 localhost/dictapi:local-latest`

This should start the container, and you should see a log saying that it is up and listening. We are mapping port 8080 to the container, so you should then be able to connect to http://localhost:8080 to use it.

