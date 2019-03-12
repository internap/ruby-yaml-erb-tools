FROM ruby-yaml-erb-tools-test AS builder

COPY config.yaml example.txt.erb ./

RUN mkdir -p output/

RUN /bin/bash -c "./config.rb --yaml config.yaml example.txt.erb > output/example.txt";

RUN /bin/bash -c "./print_key.rb --yaml config.yaml parent.child > output/key.txt";


FROM alpine

COPY --from=builder /workspace/output/* /processed/
