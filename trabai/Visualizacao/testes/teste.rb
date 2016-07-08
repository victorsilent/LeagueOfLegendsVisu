hash = Hash.new
hash['dano'] = 10
hash['vida'] = 20
hash2 = Hash.new
hash2['dano'] = 30
hash2['vida'] = 40

array = Hash.new
array.merge(hash)
array.merge(hash2)

puts array

