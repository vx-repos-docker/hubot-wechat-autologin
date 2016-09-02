#!/usr/bin/env sh
npm config set registry https://registry.npm.taobao.org
node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
    npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))")

python reconfig.py
bin/hubot -n $BOT_NAME -a weixin
