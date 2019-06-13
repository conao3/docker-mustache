# -*- mode: Makefile; -*-

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the Affero GNU General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the Affero GNU General Public License for more details.
# 
#  You should have received a copy of the Affero GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

all:

TAG ?= latest
TAGS := latest

DIRS := .make

##################################################

all: $(DIRS)
	@echo "Commands:"
	@echo "  make                   - mkdirs and show this message"
	@echo "  make allbuild          - build all docker images"
	@echo "  make allpush           - push all docker images"
	@echo ""
	@echo "  make .make/build-<TAG> - build docker image using TAGed source"
	@echo "  make .make/push-<TAG>  - push latest docker image"
	@echo ""
	@echo "Options:"
	@echo "  <TAG> = {$(TAGS)}"

allbuild: $(TAGS:%=.make/build-%)
allpush: $(TAGS:%=.make/push-%)

build: .make/build-$(TAG)
push: .make/push-$(TAG)

##################################################

.make/build-latest: Dockerfiles/Dockerfile-latest
	docker image build -t conao3/mustache:latest -f $< .
	docker container run --rm -it conao3/mustache:latest -v
	touch $@

.make/push-latest: .make/build-latest
	docker tag conao3/mustache:latest conao3/mustache:alpine-latest
        docker push conao3/mustache:latest
	docker push conao3/mustache:alpine-latest

##################################################

$(DIRS):
	mkdir -p $@

clear-image:
	docker image ls conao3/mustache\* -q | xargs docker image rm -f

clean:
	rm -rf $(DIRS)

##################################################

ci-checkout:
	git checkout master
	git checkout -b travis-$$TRAVIS_JOB_NUMBER
	echo "job $$TRAVIS_JOB_NUMBER at $(DATEDETAIL)" >> commit.log

ci-merge:
	git checkout master
	git merge --no-ff travis-$$TRAVIS_JOB_NUMBER -m "merge travis-$$TRAVIS_JOB_NUMBER [skip ci]"

ci-push:
	git push origin master
