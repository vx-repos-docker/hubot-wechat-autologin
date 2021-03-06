FROM mkenney/npm
MAINTAINER Ranger.Huang <killua.vx@gmail.com>
ENV REFRESH_AT 2016-09-02

USER root

RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g coffee-script yo generator-hubot

RUN mkdir -p /home/hubot
RUN adduser --home /home/hubot --shell /bin/bash --disabled-password hubot
RUN echo "hubot ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R hubot:hubot /home/hubot

WORKDIR /home/hubot
USER hubot

ENV BOT_NAME "bot"
ENV BOT_OWNER "No owner specified"
ENV BOT_DESC "bot~"

ENV EXTERNAL_SCRIPTS=hubot-diagnostics,hubot-help,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit
RUN echo n | yo hubot --owner="$BOT_OWNER" --name="$BOT_NAME" --description="$BOT_DESC" --defaults
RUN npm install hubot-weixin

# Define environment variables.
ENV HUBOT_LOG_LEVEL debug

USER root
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo '* */2 * * *  /usr/sbin/ntpdate 210.72.145.44 > /dev/null 2>&1' | tee -a /etc/crontab
ENV LC_ALL="C.UTF-8" LANG="zh_CN.UTF-8"


# ====================================================================================================
RUN apt-get update && apt-get install -y python-dev python-pip && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./zbar.sh .
RUN sh zbar.sh

WORKDIR /home/hubot
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./reconfig.py .
COPY ./docker-entrypoint.sh .
RUN chmod a+x docker-entrypoint.sh

# fix reinstall node_modules package to rename directory
COPY ./rename.js /usr/local/lib/node_modules/npm/lib/utils/rename.js
#COPY ./rename.js /usr/lib/node_modules/npm/lib/utils/rename.js

USER hubot
CMD ""
ENTRYPOINT [ "/home/hubot/docker-entrypoint.sh" ]
