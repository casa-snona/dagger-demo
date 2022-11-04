package sample

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
	"universe.dagger.io/docker/cli"
)

#ImageBuild: {
	current_fs: dagger.#FS
	image:      _build.output
	_build:     docker.#Build & {
		steps: [
			docker.#Pull & {
				source: "amazoncorretto:17"
			},
			docker.#Copy & {
				contents: current_fs
				source:   "/build/libs/*.jar"
				dest:     "/app.jar"
			},
			docker.#Set & {
				config: entrypoint: ["java", "-jar", "app.jar"]
			},
		]
	}
}

dagger.#Plan & {
	client: {
		filesystem: {
			"./": read: contents: dagger.#FS
		}
		network: "unix:///var/run/docker.sock": connect: dagger.#Socket
	}

	actions: {
		image_build: #ImageBuild & {
			current_fs: client.filesystem."./".read.contents
		}

		image_load: cli.#Load & {
			image: image_build.image
			host:  client.network."unix:///var/run/docker.sock".connect
			tag:   "dagger/sample:latest"
		}
	}
}
