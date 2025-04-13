# Use the official Ubuntu base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install basic packages
RUN apt-get update && \
    apt-get install -y \
	rsync \
	make \
	cmake \
        curl \
	gawk \
        wget \
        git \
	unzip \
	bzip2 \
	file \
        vim \
	python3 \
        net-tools \
        iputils-ping \
	device-tree-compiler \
	build-essential \
	libncurses5-dev libncursesw5-dev \
	&& rm -rf /var/lib/apt/lists/*

# Define the username as a build-time variable
ARG USERNAME=$USER

# Set environment variable (optional)
ENV USER=$USERNAME

# Set the working directory inside the container
WORKDIR /home/$USERNAME

# Default command to run when starting the container
CMD ["bash"]

