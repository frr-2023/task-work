from flask import Flask
import redis
import os
from prometheus_client import start_http_server
from prom_metrics import gauge_hits
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app
app = Flask(__name__)
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})
@app.route('/')
def index():
    # Task4: Initiate prometheus

    username = os.environ['REDIS_USERNAME']
    password = os.environ['REDIS_PASSWORD']
    host = os.environ['REDIS_HOST']
    port = os.environ['REDIS_PORT']
    db = os.environ['REDIS_DB']
    client = redis.Redis(username=username, password=password, host=host, port=port, db=db)

    key = 'HIT_COUNT'
    try:
        count = int(client.get(key))
    except TypeError:
        count = 0
    count += 1
    response = f'Hello FELFEL. The count is: {count}'

    client.set(key, count)
    gauge_hits.set(count)
    return response
start_http_server(9090)
app.run(host='0.0.0.0', port=8080)

