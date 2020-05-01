BACKEND?=docker
CONCURRENCY?=1

# Abs path only. It gets copied in chroot in pre-seed stages
LUET?=/usr/bin/luet
export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DESTINATION?=$(ROOT_DIR)/output
TARGET?=targets
COMPRESSION?=gzip
CLEAN?=true
TREE?=./
BUILD_ARGS?=
SUDO?=sudo
export LUET_BIN?=$(LUET)

.PHONY: all
all: deps build

.PHONY: deps
deps:
	@echo "Installing luet"
	go get -u github.com/mudler/luet

.PHONY: clean
clean:
	$(SUDO) rm -rf build/ *.tar *.metadata.yaml

.PHONY: build
build: clean
	mkdir -p $(ROOT_DIR)/build
	$(SUDO) $(LUET) build $(BUILD_ARGS) --clean=$(CLEAN) --tree=$(TREE)  `cat $(ROOT_DIR)/$(TARGET) | xargs echo` --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: build-all
build-all: clean
	mkdir -p $(ROOT_DIR)/build
	$(SUDO) $(LUET) build $(BUILD_ARGS) --clean=$(CLEAN) --tree=$(TREE) --all --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)
	rm -rf $(ROOT_DIR)/build/*.image.tar

.PHONY: rebuild
rebuild:
	$(SUDO) $(LUET) build $(BUILD_ARGS) --clean=$(CLEAN) --tree=$(TREE) `cat $(ROOT_DIR)/$(TARGET) | xargs echo` --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: rebuild-all
rebuild-all:
	$(SUDO) $(LUET) build $(BUILD_ARGS) --clean=$(CLEAN) --tree=$(TREE) --all --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: create-repo
create-repo:
	$(SUDO) $(LUET) create-repo --tree "$(TREE)" \
    --output $(ROOT_DIR)/build \
    --packages $(ROOT_DIR)/build \
    --name "luet-official" \
    --descr "Luet official repository" \
    --urls "http://localhost:8000" \
    --tree-compression gzip \
    --type http

.PHONY: serve-repo
serve-repo:
	LUET_NOLOCK=true $(LUET) serve-repo --port 8000 --dir $(ROOT_DIR)/build

.PHONY: auto-bump
auto-bump:
	$(ROOT_DIR)/scripts/auto-bump.sh

