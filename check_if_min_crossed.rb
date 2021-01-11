require 'json'
require 'open-uri'
require 'nokogiri'

file = File.open('./most_jumped.txt')
line_no = 1

file.each_line do |line|
	if line_no <= 80
		data = JSON.parse line
		stock = data["symbol"]
		p stock

		url = 'http://www.nepalstock.com/todaysprice?stock-symbol='+stock.to_s
		html = open(url)
		doc = Nokogiri::HTML(html)
		table = doc.at('table.table')
		row = table.search('tr')[2]
		cell = row.search('td')
		price = cell[5]&.inner_text&.to_i

		p "The point is reached for #{stock} at price Rs.#{price}" if  !price.nil? && price<= data["min_price"]
	end
	line_no += 1
end
