FROM ruby:latest AS config-builder

RUN mkdir /workspace/
WORKDIR /workspace/

COPY ./tools/* ./
