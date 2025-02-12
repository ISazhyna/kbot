
APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=irynasazhyna
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=${OS} #linux darwin windows
TARGETARCH=amd64 
BUILDOS=linux # ${ARCH} arm64

format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v
get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o kbot -ldflags "-X="github.com/isazhyna/kbot/cmd.appVersion=${VERSION}

image:

	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg arch=${TARGETARCH} --build-arg os=${BUILDOS}

linux:
    
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg arch=${TARGETARCH} --build-arg os=linux

windows:
	
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg arch=${TARGETARCH} --build-arg os=windows
darwin:
   
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg arch=${TARGETARCH} --build-arg os=darwin

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
