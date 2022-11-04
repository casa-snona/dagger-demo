# Dagger Demonstration

## Example01 Gradle Build

```bash
cd ex01_build
```

```bash
dagger project init
dagger project update
dagger do gradle_build
```

```bash
java -jar build/libs/spring-boot-0.0.1-SNAPSHOT.jar
```

## Example02 Docker Image Build

```bash
cd ex02_image_build
```

```bash
docker images
```

```bash
dagger project init
dagger project update
dagger do image_build
```

```bash
docker images
```

## Example03 Docker Image Load

```bash
cd ex03_image_load
```

```bash
docker images
```

```bash
dagger project init
dagger project update
dagger do image_load
```

```bash
docker images
```

```bash
docker run --rm -p 8080:8080 dagger/sample
```

## Example04 Docker Image Push

```bash
cd ex04_image_push
```

```bash
export AWS_ACCOUNT=xxxxxxxxxxxx
export AWS_DEFAULT_REGION=ap-northeast-1
export DOCKER_LOGIN_PASSWORD=`aws ecr get-login-password --region ${AWS_DEFAULT_REGION}`
```

```bash
dagger project init
dagger project update
dagger do image_push
```

## Example05 GitHub Actions

Will Continue On The Demonstration.