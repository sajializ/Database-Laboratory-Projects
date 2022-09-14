import time
import requests, json
from pymongo import MongoClient

client = MongoClient()
db = client.sahamyab
url = 'https://www.sahamyab.com/guest/twiter/list?v=0.1'
max_count = 500
interval = 60
counter = db.tweets.count_documents({})
while counter < max_count:
    response = requests.request('GET', url, headers={'User-Agent':'Chrome/61'})
    result = response.status_code
    data = response.json()['items']
    for d in data:
        if db.tweets.count_documents({'id':d['id']}) == 0:
            db.tweets.insert_one(d)

    counter = db.tweets.count_documents({})
    print(f'Fetched tweets: {counter}')
    time.sleep(interval)
    