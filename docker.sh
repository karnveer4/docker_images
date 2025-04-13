#!/bin/bash
#author Name : Karnveer Singh
#author Email : k.singh@outlook.com

DOCKER_IMG="owrt_builder"

if ! command -v docker >/dev/null; then
	echo "Install docker.io"
fi

if ! docker run hello-world >/dev/null; then
	echo "Docker not configured properly"
	echo "Configure as (https://docs.docker.com/engine/install/linux-postinstall/)"
fi

build_docker_image()
{
	echo "building docker image ${DOCKER_IMG}, (this may take some time)"
	docker build -t "${DOCKER_IMG}" .
	echo "${DOCKER_IMG} built successfully"
	exit 0
}


start_container_from_image()
{
	docker run -it --network=host --rm -v "${PWD}:/home/$USER" -v "${HOME}/.ssh:/home/$USER/.ssh" -u $(id -u):$(id -g) ${DOCKER_IMG} "$@"
}

usage_and_exit()
{
	cat <<MAYDAY
	USAGE:
  	$0 [OPTIONS] <docker_image_name>

  	OPTIONS:
  		-b - Creates and deploys a docker sdk builder (Should only done once)
  		-h - Display this help message and exit.

  	DESCRIPTION:
  		This script is for building/running sdk builder for ${DOCKER_IMG}.

  	EXAMPLES:
  		$0 -b                  : build docker sdk builder for ${DOCKER_IMG}
  		$0                     : Starts a docker container for compilation
MAYDAY
	exit 1
}

main()
{
	while getopts "bb:h" opt; do
		case $opt in
			b)
				if [ -n "${OPTARG}" ]; then
					DOCKER_IMG="${OPTARG}"
				fi
				build_docker_image
				;;
			h)
				usage_and_exit
				;;
			*)
				usage_and_exit
				;;
		esac
	done

	if [ "$(docker image inspect ${DOCKER_IMG} -f true)" != "true" ]; then
		echo "     *********************************************************************"
		echo "     docker image ${DOCKER_IMG} does not exist on local HOST machine, please use -b option to build it first time"
		echo "     -b option with different can be used to spawn multiple containers "
		echo "     *********************************************************************"
		exit 1
	fi

	start_container_from_image $@
}

main $@
