package sample

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/docker"
	"universe.dagger.io/bash"
)

#GradleBuild: {
	current_fs: dagger.#FS
	_build:     docker.#Build & {
		steps: [
			docker.#Pull & {
				source: "gradle:7.5.1-jdk17"
			},
			docker.#Copy & {
				contents: current_fs
				dest:     "/"
				include: ["src", "build.gradle", "settings.gradle", "pom.xml"]
			},
			bash.#Run & {
				workdir: "/"
				script: contents: """
					gradle build
					"""
			},
		]
	}
	contents: core.#Subdir & {
		input: _build.output.rootfs
		path:  "build"
	}
}

dagger.#Plan & {
	client: {
		filesystem: {
			"./": read: contents:       dagger.#FS
			"./build": write: contents: actions.gradle_build.contents.output
		}
	}

	actions: {
		gradle_build: #GradleBuild & {
			current_fs: client.filesystem."./".read.contents
		}
	}
}
