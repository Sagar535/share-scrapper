
require 'open-uri'
require 'nokogiri'
require 'json'

list_of_stock_symbol = []
File.open('./stock_symbols.txt', 'r') {|file|
	file.each_line { |line|
		list_of_stock_symbol << line.strip
	}
}

url = "https://merolagani.com/CompanyDetail.aspx?symbol="
pe_ratios = []

File.open('./pe_ratio.txt', 'w') do |f|
	list_of_stock_symbol.each do |symbol|
		begin
			div_class = '.panel-body'
			pe_position = 10
			dividend_position = 13
			bonus_position = 14
			table_id = '#accordion'

			html = open(url+symbol)
			doc = Nokogiri::HTML(html)

			pe_div = doc.search("div#{div_class} table#{table_id} tbody")[10]
			ltp_div = doc.search("div#{div_class} table#{table_id} tbody")[2]
			dividend_div = doc.search("div#{div_class} table#{table_id} tbody")[13]
			bonus_div = doc.search("div#{div_class} table#{table_id} tbody")[14]

			pe = pe_div.search('td')&.inner_text.strip
			dividend = dividend_div.search('td')&.inner_text.strip[0..5]
			bonus = bonus_div.search('td')&.inner_text.gsub('1.', '').strip[0..5]
			ltp = ltp_div.search('td')&.inner_text.strip[0..5]


			p symbol
			p pe

			pe_ratios << {symbol: symbol, pe_ratio: pe.gsub(',', '').to_f, dividend: dividend, bonus: bonus, ltp: ltp}
			f.puts({symbol: symbol, pe_ratio: pe, dividend: dividend, bonus: bonus, ltp: ltp}.to_json)
		rescue
			pe_ratios << {symbol: symbol, error: 'Server Error', pe_ratio: 0}
			f.puts({symbol: symbol, error: 'Server Error'}.to_json)
			next
		end
	end	
end

p pe_ratios

sorted = pe_ratios.sort {|x, y| y[:pe_ratio] <=> x[:pe_ratio]}

File.open("./pe_ratio_ordered.txt", 'w') do |f|
	sorted.each do |data|
		f.puts(data)
	end
end
