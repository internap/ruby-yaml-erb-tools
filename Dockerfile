FROM ruby:2.7.5 AS config-builder

RUN mkdir /workspace/
WORKDIR /workspace/

COPY ./tools/* ./
