require 'json'
require 'rest-client'
json = File.read('ENOIS.json')
player = JSON.parse(json)
hello=Array.new
player.each do |x|
	hello << x[1]
end

champlist = RestClient.get 'https://global.api.pvp.net/api/lol/static-data/br/v1.2/champion?champData=all&api_key=6dbf72c8-3990-4820-a58a-21e020c0cbdb'
#Save Json
fJson = File.open("champ_list.json","w:UTF-8")
fJson.write(champlist)
fJson.close

#Get Json
json = File.read('champ_list.json')
champs = JSON.parse(json)
#puts champs['keys'].size

hello.each do |champ|
	if champs['keys'].has_key?(champ['championId'].to_s)
		champ['championId'] = champs['keys'][champ['championId'].to_s]

	end
	puts champ
end


hello = hello.to_json
fJson2 = File.open("ENOIS.json","w:UTF-8")
fJson2.write(hello)
fJson2.close

