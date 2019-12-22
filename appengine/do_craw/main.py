# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gae_flex_quickstart]
import logging
import pprint

from flask import Flask
from flask import request

from google.cloud import storage
import googleapiclient.discovery


app = Flask(__name__)

PROJECT = "youzhi-lab"
ZONE = "asia-east1-b"
INSTANCE_NAME = "crawler-tw"

@app.route('/hello')
def hello():
    """Return a friendly HTTP greeting."""
    storage_client = storage.Client()
    buckets = list(storage_client.list_buckets())
    buckets_str = str(buckets)
    #print(buckets)
    #return buckets_str
    return 'Hello World!'

# This app just starts the VM, and the VM's start-up script would do the rest
@app.route('/')
def do_craw():
    compute = googleapiclient.discovery.build('compute', 'v1')

    project = request.args.get('project')
    if not project:
        project = PROJECT
    
    zone = request.args.get('zone')
    if not zone:
        zone = ZONE
    
    instance = request.args.get('instance')
    if not instance:
        instance = INSTANCE_NAME
    


    result = compute.instances().start(
        project=PROJECT, 
        zone=ZONE, 
        instance=INSTANCE_NAME).execute()

    result = pprint.pformat(result)

    #result = project + zone + instance
    return "Completed\n" + result


@app.errorhandler(500)
def server_error(e):
    logging.exception('An error occurred during a request.')
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500


if __name__ == '__main__':
    # This is used when running locally. Gunicorn is used to run the
    # application on Google App Engine. See entrypoint in app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
# [END gae_flex_quickstart]