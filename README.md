Dockerfile for a Boost Emulator API

 * JDK 8
 * Nginx
 * git
 * Maven

Prerequisites
-----

Install docker.

Build
-----

Steps to build a Docker image:

1. Clone this repo

2. Configure Environment variables in Dockerfile.

3. Build the image

        cd ..
        docker build -t="emulator-api" emulator-api

4. Run the image's default command, which should start everything up. The `-p` option forwards the container's port 80 to port 8000 on the host. (Note that the host will actually be a guest if you are using boot2docker, so you may need to re-forward the port in VirtualBox.)

        docker run -p="8000:80" emulator-api

5. Once everything has started up, you should be able to access the webapp on port 8000 with the ip of your container.
Mine is http://192.168.59.103:8000/
