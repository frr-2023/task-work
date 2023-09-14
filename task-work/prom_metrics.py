# File for defining the metrics that are used in the app
from prometheus_client import Gauge

gauge_hits = Gauge('hits', 'Number of visits in the app')