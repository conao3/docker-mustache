all:

TAG ?= latest
TAGS := alpine-latest

DIRS := .make

##################################################

all: $(DIRS)
	@echo "make                 - mkdirs and show this message"
	@echo "make build           - build docker image using latest source"
	@echo "make build TAG=<TAG> - build docker image using TAGed source"
	@echo "make push            - push latest docker image"
	@echo "make push TAG=<TAG>  - push TAGed docker image"
	@echo ""
	@echo "make allbuild        - build all docker images"
	@echo "make allpush         - push all docker images"
	@echo "  <TAG> = {$(TAGS)}"

build: $(TAGS:%=.make/build-%)

##################################################

.make/build-%: Dockerfiles/Dockerfile-%
	docker image build -t conao3/mustache:$(TAG) .

push: build
	docker push conao3/mustache:$(TAG)

##################################################

$(DIRS):
	mkdir -p $@
