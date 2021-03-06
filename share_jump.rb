require 'open-uri'
require 'nokogiri'
require 'json'

min = '2020-06-29'
max = '2020-12-31'

list_of_stock_symbol = []
File.open('./stock_symbols.txt', 'r') {|file|
	file.each_line { |line|
		list_of_stock_symbol << line.strip
	}
}

# list_of_stock_symbol = ['UMHL']

# p list_of_stock_symbol
stock_informations = []
list_of_stock_symbol.each do |symbol|
	p symbol
	stock_info = {symbol: symbol}
	base_url = 'http://www.nepalstock.com/todaysprice?'
	url =  base_url + "stock-symbol=#{symbol}" + "&startDate=#{min}"
	html = open(url)
	doc = Nokogiri::HTML(html)
	table = doc.at('table.table')
	row = table.search('tr')[2]
	cell = row.search('td')
	price = cell[5]&.inner_text&.to_i

	stock_info[:min_price] = price

	html = open(base_url + "stock-symbol=#{symbol}" + "&startDate=#{max}")
	doc = Nokogiri::HTML(html)
	table = doc.at('table.table')
	row = table.search('tr')[2]
	cell = row.search('td')
	price = cell[5]&.inner_text&.to_i

	stock_info[:max_price] = price
	stock_info[:difference] = stock_info[:max_price] - stock_info[:min_price] unless stock_info[:max_price].nil? || stock_info[:min_price].nil?

	stock_informations << stock_info

	File.open('./stock_informations.txt', 'a') { |file|
		file.puts(stock_info.to_json)
	}
end

File.open('./stock_informations_bundle.txt', 'w') { |file|
	file.puts(stock_informations.to_json)
}
