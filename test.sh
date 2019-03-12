#!/usr/bin/env bash -eux

docker build --tag ruby-yaml-erb-tools-test .

(cd test && docker build --tag processor .)

[[ "This is the value" == "$(docker run -it --rm processor cat /processed/example.txt | tr -d '\r?\n')" ]]
[[ "value" == "$(docker run -it --rm processor cat /processed/key.txt | tr -d '\r?\n')" ]]

echo Test Pass!
