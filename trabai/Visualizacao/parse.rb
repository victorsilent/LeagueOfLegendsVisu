require 'json'

json = File.read('FINAL.json')
matches = JSON.parse(json)


count = 0
jogadores = Array.new
teste = Hash.new
matches.each do |match|
    duration = match[1]['matchDuration']
    for i in 0..9 do
        teste = match[1]['participants'][i]['stats']
        teste['championId'] = match[1]['participants'][i]['championId']
        teste['teamId'] = match[1]['participants'][i]['teamId']
        teste['role'] = match[1]['participants'][i]['timeline']['role']
        teste['lane'] = match[1]['participants'][i]['timeline']['lane']
        teste['duration'] = duration
        jogadores << teste
    end
    
end
=begin
    duration = matches['0']['matchDuration']

    correct[count] = matches['0']['participants'][0]['stats']
    correct[count]['championId'] = matches['0']['participants'][0]['championId']
    correct[count]['teamId'] = matches['0']['participants'][0]['teamId']
    correct[count]['role'] = matches['0']['participants'][0]['timeline']['role']
    correct[count]['lane'] = matches['0']['participants'][0]['timeline']['lane']
=end





jogadores = jogadores.to_json
fJson2 = File.open("TESTANU.json","w:UTF-8")
fJson2.write(jogadores)
fJson2.close

