RUN = bazel run --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64

build:
	bazel run :snykly

image:
	$(RUN) :bundle

push:
	$(RUN) :push_gcr
	$(RUN) :push_docker_hub

test:
	bazel test --test_output=all :snykly_test

deps:
	bazel run //:gazelle -- update-repos -from_file=go.mod

config:
	$(RUN) :dev

deploy:
	$(RUN) :dev.apply

delete:
	$(RUN) :dev.delete

describe:
	$(RUN) :dev.describe

clean: delete
	bazel clean


.PHONY: build image push test deps config deploy delete describe clean
