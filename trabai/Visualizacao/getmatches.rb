require 'rest-client'
require 'json'

#Get Json
json = File.read('challenger_list.json')
challengers = JSON.parse(json)


#Key: Name, Value: Matches
#The user's name will be the Key because we'll need his name to make the visualization
matches_by_player = Hash.new

#Count matches :p
count = 0
#Count Players
player_c = 1

#Get challengers matches
#add "take()" function to get a fix number of players
#Ex: challengers.take(10).each will get top 10 players
challengers.each do |player|

	#Temporary hash to save user's matchlist
	match_list_by_user = Hash.new

	#Request to API passing the playerID
	begin
		RestClient.get("https://br.api.pvp.net/api/lol/br/v2.2/matchlist/by-summoner/#{player[0]}?rankedQueues=TEAM_BUILDER_DRAFT_RANKED_5x5&seasons=SEASON2016&api_key=6dbf72c8-3990-4820-a58a-21e020c0cbdb") { |response, request, result, &block|
		case response.code
		when 200
			#Json comes like a string, this will transform him to Hash
			matches_json = JSON.parse(response)
			#Adding each match to Hash of matches(eliminating ununsed variables)
			matches_json['matches'].each do |matches|
				match_list_by_user[count] = matches 
				count+=1
			end
			#reset matches's count
			count = 0
	
			#Set player matches to Hash
			matches_by_player[player[1]] = match_list_by_user
			#Sleep - we don't want break the API :p
			#sleep 1
			puts "Collecting #{player[1]}'s matches - #{player_c} of #{challengers.size} players"
			player_c += 1
		else
			puts "Limit rate - Sleep 10sec"
			sleep 15

			match_list = RestClient.get("https://br.api.pvp.net/api/lol/br/v2.2/matchlist/by-summoner/#{player[0]}?rankedQueues=TEAM_BUILDER_DRAFT_RANKED_5x5&seasons=SEASON2016&api_key=6dbf72c8-3990-4820-a58a-21e020c0cbdb")

			matches_json = JSON.parse(match_list)
			#Adding each match to Hash of matches(eliminating unused attributes)
			matches_json['matches'].each do |matches|
				match_list_by_user[count] = matches 
				count+=1
			end
			#reset matches's count
			count = 0
			
			#Player's matches set to Hash
			matches_by_player[player[1]] = match_list_by_user
			puts "Collecting #{player[1]} matches - #{player_c} of #{challengers.size} players"
			player_c += 1
		end
		}
	rescue SocketError => e
		puts e
	end

	
end
	#save final hash to json
	matches_by_player = matches_by_player.to_json
	teste = File.open("teste.json","w")
	teste.write(matches_by_player)
	teste.close


