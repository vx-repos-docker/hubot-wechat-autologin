#!/usr/bin/env sh
node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
    npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))")


export CONFIG_FILE='./node_modules/hubot-weixin/config.yaml'
python reconfig.py $CONFIG_FILE && bin/hubot -n $BOT_NAME -a weixin