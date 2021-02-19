require 'open-uri'
require 'nokogiri'
require 'json'

sagar = {umhl: 24, sjcl: 20, sgi: 10, rhpl: 40, hdhpc: 50, gic: 10, pli: 10, name: 'Sagar'}
nabin = {sjcl: 40, rhpl: 70, name: 'Nabin'}

def find_share_value(my_shares)
	total = 0
	share_prices = []
	my_shares.each do |stock, quantity|
		p quantity.class
		if quantity.class == Integer
			url = 'http://www.nepalstock.com/todaysprice?stock-symbol='+stock.to_s
			html = open(url)
			doc = Nokogiri::HTML(html)
			table = doc.at('table.table')
			row = table.search('tr')[2]
			cell = row.search('td')
			p stock
			p quantity

			price = cell[5]&.inner_text&.to_i
			p cell[5]&.inner_text

			total += quantity * price rescue 0
		end
	end

	p "#{my_shares[:name]} worth would have been Rs.#{total}"
end

find_share_value(sagar)
find_share_value(nabin)
