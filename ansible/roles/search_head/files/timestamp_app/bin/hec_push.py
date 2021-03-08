from json import loads
from splunk_http_event_collector import http_event_collector

http_event_collector_key = "e84c9688-998c-4d9c-a715-64a0a87d1570"
http_event_collector_host = "localhost"

hec = http_event_collector(http_event_collector_key, http_event_collector_host)

with open('/tmp/heccollect.stash_hec', 'r') as collected:
    for event in collected:
        hec.batchEvent(loads(event))

hec.flushBatch()


