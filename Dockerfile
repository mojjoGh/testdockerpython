FROM python:3.7-alpine
MAINTAINER Antslab app dev

	# What this does is it tells Python to run in unbuffered mode which is recommended when running Python within
ENV PYTHONUNBUFFERED 1

# Install dependencies
	# What this does is it says copy from the directory adjacent to the Docker file, copy the requirements file that we're going to create here and copy it on the Docker image to /requirements.txt
COPY ./requirements.txt /requirements.txt
	# registry before we add it but this no cache means don't store the registry
RUN apk add --update --no-cache postgresql-client
	# --virtual - what this does is it sets up an alias for our dependencies that we can use to easily remove all those dependencies later.
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

# Setup directory structure
	# What this does is it creates a empty folder on our docket in the edge called forward slash at this location
RUN mkdir /apps
	# and then it switches to that as the default directory.
WORKDIR /apps
	# Next what it does is it copies from our local machine the app folder to the app follow that we've created
COPY ./apps/ /apps

	# which creates a user the hive Andy says create a user, that could run an application only, then switch to user
RUN adduser -D user
USER user