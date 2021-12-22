#!/usr/bin/env bash -eux

docker build --tag ruby-yaml-erb-tools-test .

(cd test && docker build --tag processor .)

error=false

if [ "This is the value value_1 value_2 value_2_common" != "$(docker run -it --rm processor cat /processed/example.txt | tr -d '\r?\n')" ]; then
    echo "Error in config.rb test"
    error=true
fi

if [ "value" != "$(docker run -it --rm processor cat /processed/key.txt | tr -d '\r?\n')" ]; then
    echo "Error in print_key.rb test"
    error=true
fi

if [ "$error" = true ]; then
  echo Fail!
  exit 1
fi
echo Test Pass!
