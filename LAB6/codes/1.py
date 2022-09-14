import requests, json
response = requests.get('https://www.sahamyab.com/guest/twiter/list?v=0.1', headers={'User-Agent': 'Chrome/61'})
data = json.loads(response.text)
print(data)
with open('data.json', 'w', encoding='utf-8') as f:
    json.dump(data['items'], f, indent=2, ensure_ascii = False)
