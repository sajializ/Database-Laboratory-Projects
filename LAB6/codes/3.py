import time
import requests, json
from pymongo import MongoClient
from bson.objectid import ObjectId

client = MongoClient()
db = client.sahamyab

tic = time.time()
result = db.tweets.find({"content": { "$regex" : "#" }})
for tweet in result:
    hashtags = []
    splited_tweet = tweet['content'].split()
    for word in splited_tweet:
        if word[0] == '#':
            hashtags.append(word)
    db.tweets.update_one(
        {'_id': tweet['_id']},
        {'$set': {'hashtags': hashtags}}
    )
toc = time.time()
print("time:", toc - tic)


