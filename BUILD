load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library", "go_test")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")
load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push", "container_bundle")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")
load("@bazel_gazelle//:def.bzl", "gazelle")
load("@bazel_gazelle//:deps.bzl", "go_repository")

gazelle(
    name = "gazelle",
    prefix = "github.com/garethr/snykly",
)

go_image(
    name = "image_base",
    goarch = "amd64",
    goos = "linux",
    embed = [":go_default_library"],
)

container_image(
    name = "image",
    base = ":image_base",
    ports = ["8080"],
    env = {
        "GIN_MODE": "release",
    },
    stamp = True,
)

container_bundle(
    name = "bundle",
    images = {
        "garethr/snykly": ":image",
    },
)

container_push(
    name = "push_docker_hub",
    format = "Docker",
    image = ":image",
    registry = "index.docker.io",
    repository = "garethr/snykly",
    tag = "latest",
)

container_push(
    name = "push_gcr",
    format = "Docker",
    image = ":image",
    registry = "gcr.io",
    repository = "garethr/snykly",
    tag = "latest",
)

go_library(
    name = "go_default_library",
    srcs = ["main.go"],
    importpath = "github.com/garethr/snykly",
    deps = [
        "@com_github_gin_gonic_gin//:go_default_library",
    ],
)

go_binary(
    name = "snykly",
    embed = [":go_default_library"],
)

go_test(
    name = "snykly_test",
    size = "small",
    srcs = ["main_test.go"],
    embed = [":go_default_library"],
    deps = [
        "@com_github_stretchr_testify//assert:go_default_library",
    ],
)

k8s_object(
  name = "dev",
  kind = "deployment",
  template = ":deployment.yaml",
  images = {
    "garethr/snykly": ":image"
  },
  cluster = "docker-desktop",
)
