#!/usr/bin/env python

from json import dumps
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))
from splunklib.searchcommands import \
    dispatch, StreamingCommand, Configuration, Option, validators


@Configuration()
class HECCollectCommand(StreamingCommand):
    """ %(synopsis)
    ##Syntax
    %(syntax)
    ##Description
    %(description)
    """
    def stream(self, events):
       # Put your event transformation code here
        with open('/tmp/heccollect.stash_hec', 'a') as outputfile:
            for event in events:
                print(dumps(
                    {
                        'event': event['_raw'],
                        'fields': {},
                        'host': event['host'],
                        'index': 'umb_bots',
                        'source': event['source'],
                        'sourcetype': event['sourcetype'],
                        'time': event['_time'],
                    }), file=outputfile)
                yield event

dispatch(HECCollectCommand, sys.argv, sys.stdin, sys.stdout, __name__)
