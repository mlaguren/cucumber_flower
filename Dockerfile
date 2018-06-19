FROM ubuntu:16.04
  
ENV LC_ALL C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing
RUN apt-get install -y libav-tools
RUN apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs xvfb vim
RUN apt-get install -y openssl
RUN apt-get install -y firefox
RUN apt-get install -y ruby
RUN apt-get install -y bundler
RUN gem pristine bundler
RUN gem pristine rake
RUN gem pristine thor
RUN gem update --system && gem install bundler
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

RUN mkdir cucumber_flower
WORKDIR /cucumber_flower
CMD /bin/bash ./bat_test.sh
