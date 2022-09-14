import time
import requests, json
from pymongo import MongoClient
from bson.objectid import ObjectId

client = MongoClient()
db = client.sahamyab

tic = time.time()
result = db.tweets.find({ 'mediaContentType': 'image/jpeg', 'parentId': {'$ne': None} })
for tweet in result:
    print(tweet['senderName'])
toc = time.time()
print("time:", toc - tic)

