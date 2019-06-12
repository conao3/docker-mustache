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

##################################################

.make/build-%: Dockerfiles/Dockerfile-%
	docker image build -t conao3/mustache:$* -f $< .
	docker container run conao3/mustache:$* -v
	touch $@

.make/push-latest: .make/build-latest
	docker push conao3/mustache:latest

##################################################

$(DIRS):
	mkdir -p $@

clear:
	rm -rf $(DIRS)
