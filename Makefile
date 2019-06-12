TAG ?= latest

build: Dockerfile
	docker image build -t conao3/mustache:$(TAG) .

push: build
	docker push conao3/mustache:$(TAG)
