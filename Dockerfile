FROM python:3.6.9-buster

WORKDIR /app

RUN apt-get update && \
  apt-get install -y --no-install-recommends apache2 apache2-dev locales \
  libmemcached-dev less vim && \
  apt-get clean && \
  rm -r /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen
ENV LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  PYTHONUNBUFFERED=1

ARG TINI_VERSION=0.18.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY requirements.txt /app/requirements.txt
RUN python3 -m venv env && \
  . env/bin/activate && \
  pip install --no-cache-dir -U -r requirements.txt

COPY . /app

ARG LOG_FILE=mysite.log
RUN touch "$LOG_FILE" && \
  chmod a+rw "$LOG_FILE"

EXPOSE 80 22

ENTRYPOINT [ "/app/start" ]