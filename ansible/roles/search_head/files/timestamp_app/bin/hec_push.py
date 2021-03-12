#!/usr/bin/env python3
from json import loads
from datetime import datetime
from splunk_http_event_collector import http_event_collector

 

http_event_collector_key = "e84c9688-998c-4d9c-a715-64a0a87d1570"
http_event_collector_host = "localhost"

 

hec = http_event_collector(http_event_collector_key, http_event_collector_host)

 

count = 0
now = datetime.now().timestamp()
with open('/tmp/tmp/heccollect.stash_hec', 'r') as collected:
    for event in collected:
        try:
            parsed = loads(event)
            timestamp = float(parsed['time'])
            days_diff = (now - timestamp)//86400
            parsed['time'] = str(timestamp + (days_diff * 86400))
            hec.batchEvent(parsed)

 

        except Exception as e:
            print(e)
            continue
        else:
            count += 1

 

hec.flushBatch()
print(f"Imported {count} events")
