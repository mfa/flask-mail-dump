# -*- coding: utf-8 -*-
#!/usr/bin/env python

# Flask
from flask import Flask, request, abort
app = Flask(__name__)

import os
import os.path
import json
import codecs
import datetime
import hashlib

from config import KEY, EMAIL


@app.route('/')
def index():
    return "nothing to see here ..."


@app.route('/email/', methods=['POST'])
def email_in():
    if not request.args.get('key', '') == KEY:
        abort(403)

    sender = request.form.get('sender')
    recipient = request.form.get('recipient')

    body_plain = request.form.get('body-plain', '')

    fn = hashlib.sha1(datetime.datetime.now().isoformat().encode('utf-8')).hexdigest()
    fn = request.form.get('signature', fn)
    if sender and recipient:
        dirname = os.path.join(os.path.dirname(__file__), 'mail_default')
        if EMAIL in recipient:
            dirname = os.path.join(os.path.dirname(__file__), 'mail_filtered')
        with codecs.open(os.path.join(dirname, fn + '.mail'),
                         'w', encoding="utf-8") as fp:
            fp.write(body_plain)
    dirname = os.path.join(os.path.dirname(__file__), 'logs')
    with codecs.open(os.path.join(dirname, fn + '.log'),
                     'w', encoding="utf-8") as fp:
        fp.write(json.dumps(request.form))

    # Returned text is ignored but HTTP status code matters:
    # Mailgun wants to see 2xx,
    # otherwise it will make another attempt in 5 minutes
    return "OK"


if __name__ == "__main__":
    app.debug = True
    app.run("0.0.0.0")
        