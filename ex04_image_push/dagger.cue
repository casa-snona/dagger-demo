package sample

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
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
		env: {
			AWS_ACCOUNT:           string
			AWS_DEFAULT_REGION:    string
			DOCKER_LOGIN_PASSWORD: dagger.#Secret
		}
		filesystem: {
			"./": read: contents: dagger.#FS
		}
	}

	actions: {
		image_build: #ImageBuild & {
			current_fs: client.filesystem."./".read.contents
		}

		image_push: docker.#Push & {
			image: image_build.image
			dest:  "\(client.env.AWS_ACCOUNT).dkr.ecr.\(client.env.AWS_DEFAULT_REGION).amazonaws.com/dagger/sample"
			auth: {
				username: "AWS"
				secret:   client.env.DOCKER_LOGIN_PASSWORD
			}
		}
	}
}
