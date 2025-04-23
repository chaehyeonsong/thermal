FROM ruby:3.1-slim-bullseye

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    git \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN gem update --system && gem install jekyll && gem cleanup

EXPOSE 4000

WORKDIR /srv/jekyll
RUN git config --global --add safe.directory /srv/jekyll

ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]