require 'rest-client'
require 'json'

#Get Json
json = File.read('teste.json')
challengers = JSON.parse(json)
count =0
matches = Hash.new
challengers.each do |x|
	
	x[1].take(5).each do |y|
		begin
			RestClient.get("https://br.api.pvp.net/api/lol/br/v2.2/match/#{y[1]['matchId']}?api_key=6dbf72c8-3990-4820-a58a-21e020c0cbdb") 				{ |response, request, result, &block|

			case response.code
			when 200
				parse = JSON.parse(response)
				matches[count] = parse
				count+=1
				puts "Partida #{y[1]['matchId']}"
			else
				puts "Break API - wait 15"
				sleep 15
				response = RestClient.get("https://br.api.pvp.net/api/lol/br/v2.2/match/#{y[1]['matchId']}?api_key=6dbf72c8-3990-4820-a58a-21e020c0cbdb")
				parse = JSON.parse(response)
				matches[count] = parse
				count+=1
			end
			}
		rescue SocketError => e
			puts e
		end
	end

end
	puts matches
	matches = matches.to_json
	teste = File.open("FINAL.json","w")
	teste.write(matches)
	teste.close
