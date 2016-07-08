require 'json'

json = File.read('TESTANU.json')
player = JSON.parse(json)

champs=Hash.new
itens=Hash.new
role = Hash.new


#O QUE FALTA
#SOMAR APENAS OS DADOS DESEJADOS, NADA DE CHAMPID, TEAMID e etc...
player.each do |played|
	if champs.has_key?(played['championId'])


		#Cria array loco
		array_itens=Hash.new
		roles=Hash.new

		#Remove os campos desnecessários
		played.delete("firstBloodKill")
		played.delete("firstBloodAssist")
		played.delete("firstTowerKill")
		played.delete("firstTowerAssist")
		played.delete("firstInhibitorKill")
		played.delete("firstInhibitorAssist")
		played.delete("teamId")
		
		roles = role[played['championId']]
		if played['lane'] == "BOTTOM"
			roles.has_key?(played['role']) ? roles[played['role']]+=1 : roles[played['role']]=1
		else
			roles.has_key?(played['lane']) ? roles[played['lane']]+=1 : roles[played['lane']]=1
		end
		role[played['championId']] = roles 
		#Recebe o vetor de itens atual do campeão
		array_itens = itens[played['championId']]

		
		#Incrementa a contagem do item dentro do hash. Se o item estiver ele aumenta 1, caso contrario seta para 1
		array_itens.has_key?(played['item0']) ? array_itens[played['item0']]+=1 : array_itens[played['item0']]=1
		array_itens.has_key?(played['item1']) ? array_itens[played['item1']]+=1 : array_itens[played['item1']]=1
		array_itens.has_key?(played['item2']) ? array_itens[played['item2']]+=1 : array_itens[played['item2']]=1
		array_itens.has_key?(played['item3']) ? array_itens[played['item3']]+=1 : array_itens[played['item3']]=1
		array_itens.has_key?(played['item4']) ? array_itens[played['item4']]+=1 : array_itens[played['item4']]=1
		array_itens.has_key?(played['item5']) ? array_itens[played['item5']]+=1 : array_itens[played['item5']]=1
		array_itens.has_key?(played['item6']) ? array_itens[played['item6']]+=1 : array_itens[played['item6']]=1
		
		#Vetor de itens é o vetor antigo + os 6 novos dessa partida
		itens[played['championId']]=array_itens
		
		#FAZ UM SOMATORIO DOS BIXO CERTO
		champs[played['championId']] = champs[played['championId']].merge(played) {|key,val1,val2| val1+val2 if val1.is_a?(Integer) }
		#Se o cara ganhou, seta 1 para wins, caso contrario seta 1 para lose
		if played['winner'] == true
			champs[played['championId']]['wins'] += 1
		else
			champs[played['championId']]['loses'] += 1
		end
	
		#adiciona quantas partidas o cara jogou
		champs[played['championId']]['count'] += 1

	else
		#Cria vetor de itens e roles
		array_itens=Hash.new
		roles=Hash.new
		
		#remove campos desnecessarios
		played.delete("firstBloodKill")
		played.delete("firstBloodAssist")
		played.delete("firstTowerKill")
		played.delete("firstTowerAssist")
		played.delete("firstInhibitorKill")
		played.delete("firstInhibitorAssist")

		if played['lane'] == "BOTTOM"
			roles.has_key?(played['role']) ? roles[played['role']]+=1 : roles[played['role']]=1
		else
			roles.has_key?(played['lane']) ? roles[played['lane']]+=1 : roles[played['lane']]=1
		end

		role[played['championId']] = roles 

		#define que o vetor de itens são os 6 itens da 1º partida
		array_itens.has_key?(played['item0']) ? array_itens[played['item0']]+=1 : array_itens[played['item0']]=1
		array_itens.has_key?(played['item1']) ? array_itens[played['item1']]+=1 : array_itens[played['item1']]=1
		array_itens.has_key?(played['item2']) ? array_itens[played['item2']]+=1 : array_itens[played['item2']]=1
		array_itens.has_key?(played['item3']) ? array_itens[played['item3']]+=1 : array_itens[played['item3']]=1
		array_itens.has_key?(played['item4']) ? array_itens[played['item4']]+=1 : array_itens[played['item4']]=1
		array_itens.has_key?(played['item5']) ? array_itens[played['item5']]+=1 : array_itens[played['item5']]=1
		array_itens.has_key?(played['item6']) ? array_itens[played['item6']]+=1 : array_itens[played['item6']]=1

		itens[played['championId']]=array_itens
		
		#todos os dados sao passados (1º partida)
		champs[played['championId']] = played

		#quantidade de jogos = 1
		champs[played['championId']]['count'] = 1
		#seta quantidade de wins e loses
		if played['winner'] == true
			champs[played['championId']]['wins'] = 1
			champs[played['championId']]['loses'] = 0
		else
			champs[played['championId']]['loses'] = 1
			champs[played['championId']]['wins'] = 0
		end
	end
end
#JA TENHO A SOMA DOS NEGOCIO CERTO
#JA TENHO A CONTAGEM DOS ITENS USADOS
#falta calcular a média
#falta colocar os itens

vetor = Hash.new
itens.map do |key,value|
	vetor[key]=value.max_by(7){|x,y| y}
end

roles_pt2 = Hash.new
role.map do |key,value|
	roles_pt2[key]=value.max_by(1){|x,y| y}
end
#puts vetor
#vetor[60].size.times do |x|
	#TOP 6 ITENS DO CHAMP 60	
#	puts vetor[60][x][0]
#end
champs.each do |x|
	vetor[x[0]].size.times do |y|
		x[1]["item#{y}"]=vetor[x[0]][y].empty? ? 0 : vetor[x[0]][y][0]
	end
	x[1]['champLevel'] = x[1]['champLevel']/x[1]['count']  
	x[1]['winrate']=(x[1]['wins'].to_f/x[1]['count'].to_f).round(2)
	
	x[1]['goldEarned']=(x[1]['goldEarned'].to_f/x[1]['count'].to_f).round(2)

	x[1]['magicDamageDealtToChampions']=(x[1]['magicDamageDealtToChampions'].to_f/x[1]['count'].to_f).round(2)
	x[1]['physicalDamageDealtToChampions']=(x[1]['physicalDamageDealtToChampions'].to_f/x[1]['count'].to_f).round(2)
	x[1]['trueDamageDealtToChampions']=(x[1]['trueDamageDealtToChampions'].to_f/x[1]['count'].to_f).round(2)
	x[1]['magicDamageTaken']=(x[1]['magicDamageTaken'].to_f/x[1]['count'].to_f).round(2)
	x[1]['physicalDamageTaken']=(x[1]['physicalDamageTaken'].to_f/x[1]['count'].to_f).round(2)
	x[1]['totalTimeCrowdControlDealt']=(x[1]['totalTimeCrowdControlDealt'].to_f/x[1]['count'].to_f).round(2)	
	x[1]['duration']=(x[1]['duration'].to_f/x[1]['count'].to_f).round(2)	
	x[1]['deaths']=(x[1]['deaths'].to_f/x[1]['count'].to_f).round(2)
	x[1]['assists']=(x[1]['assists'].to_f/x[1]['count'].to_f).round(2)
	x[1]['kills']=(x[1]['kills'].to_f/x[1]['count'].to_f).round(2)
	x[1]['championId']=x[0]
	x[1]['role']=roles_pt2[x[0]][0][0]
	
		
	
	

	x[1].delete('winner')
	x[1].delete('lane')

end
champs = champs.to_json
fJson2 = File.open("ENOIS.json","w:UTF-8")
fJson2.write(champs)
fJson2.close
