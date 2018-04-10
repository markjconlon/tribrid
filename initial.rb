require 'open-uri'
require 'json'
require 'csv'
require 'httparty'

def fetch
  taas_eth = HTTParty.get("http://api.liqui.io/api/3/depth/taas_eth?limit=10")["taas_eth"]
  eth_usdt = HTTParty.get("http://api.liqui.io/api/3/depth/eth_usdt?limit=10")["eth_usdt"]
  taas_usdt = HTTParty.get("http://api.liqui.io/api/3/depth/taas_usdt?limit=10")["taas_usdt"]

  sell_usdt_for_eth = eth_usdt["asks"][0]
  sell_eth_for_taas = taas_eth["asks"][0]
  sell_taas_for_usdt = taas_usdt["asks"][0]
  #scenario one
  s_one = {
    eth_per_usdt: (1/(sell_usdt_for_eth[0].to_f)),
    taas_per_eth: (1/(sell_eth_for_taas[0].to_f)),
    usdt_per_taas: (sell_taas_for_usdt[0].to_f)
  }

  start_usdt = 10
  tFee = 1 - 0.0025
  end_usdt = start_usdt * s_one[:eth_per_usdt] * s_one[:taas_per_eth] * s_one[:usdt_per_taas] * tFee ** 3
  puts "Scenario One"
  puts end_usdt

  if end_usdt > start_usdt
    data = [start_usdt, end_usdt, s_one[:eth_per_usdt], s_one[:taas_per_eth], s_one[:usdt_per_taas], "Scenario 1" ]
    write_to_csv(data)
  end
end

def fetchTwo
  #scenario two
end

def write_to_csv(data)
  CSV.open('profitsThreeWay.csv', 'a+') do |csv|
    csv << data
  end
end

def clock
  trades = fetch()
  sleep(rand(8..13))
  clock()
end
clock()
