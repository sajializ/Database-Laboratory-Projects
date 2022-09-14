import time
from elasticsearch import Elasticsearch
import requests
import logging
import sys
import re
url = 'https://sahamyab.com/guest/twiter/list?v=0.1'
total = 500
api_sleep = 30
def connect_elasticsearch():
    _es = None
    _es = Elasticsearch([{'host': 'localhost', 'port': 9200}])
    if _es.ping():
        print('Connected')
    else:
        print('Failed!')
    return _es

es = connect_elasticsearch()

def find_hashtags(text):
    return re.findall(r"#(\w+)", text)

def store_record(elastic_object, index_name, record):
    try:
        outcome = elastic_object.index(index=index_name, doc_type='twitter', body=record)
    except Exception as ex:
        print('Error in indexing data')
        print(str(ex))

res = 0
while res < total:
    response = requests.request('GET', url, headers={'User-Agent': 'Chrome/61'})
    if response.status_code == requests.codes.ok:
        data = response.json()['items']
        for d in data:
            if ('advertise' in d and d['advertise']):
                continue
            d['hashtags'] = find_hashtags(d['content'])
            store_record(elastic_object=es, index_name='twitter', record=d)
        res = es.search(index='twitter', body={'query':{'match_all':{}}})['hits']['total']['value']
    else:
        print("Response code error: " + str(response.status_code))
    print('Fetched and inserted {} tweets so far'.format(res))
    print('Waiting for {} seconds...'.format(api_sleep))
    time.sleep(api_sleep)