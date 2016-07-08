require 'rest-client'
require 'json'

puts 'Requesting Challengers List'
chlist = RestClient.get 'https://br.api.pvp.net/api/lol/br/v2.5/league/challenger?type=RANKED_SOLO_5x5&api_key=6dbf72c8-3990-4820-a58a-21e020c0cbdb'

#Save Json
fJson = File.open("temp.json","w:UTF-8")
fJson.write(chlist)
fJson.close

#Get Json
json = File.read('temp.json')
obj = JSON.parse(json)

#Hash to make challengers hash map
challengers = Hash.new

#For each challenger at obj make playerID as Key and playerName as Value, 
#this hash will be used to make a next and complete hashmap
obj['entries'].each do |player|
	challengers[player['playerOrTeamId']] = player['playerOrTeamName']
end

#Convert hash into Json
challengerMap = challengers.to_json

#Save Json
fJson2 = File.open("challenger_list.json","w:UTF-8")
fJson2.write(challengerMap)
fJson2.close


