#!/bin/bash

# CUE 言語インストール
go install cuelang.org/go/cmd/cue@latest

# Gradle インストール
sdk install gradle

# Dagger インストール
cd /usr/local
curl -L https://dl.dagger.io/dagger/install.sh | sudo sh
