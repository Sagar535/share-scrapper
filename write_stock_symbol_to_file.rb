require 'open-uri'
require 'nokogiri'

# Write stock symbols to file.. Run every now and then to accomodate for the new stocks coming to market

def write_stock_symbol_to_file
	list_of_stock_symbol = []
	url = 'http://www.nepalstock.com/todaysprice?'
	form_id = "news_info-filter"
	select_id = 'stock-symbol'

	html = open(url)
	doc = Nokogiri::HTML(html)

	form = doc.at("form##{form_id}")
	stock_select = form.search("select##{select_id}")[0]
	options = stock_select.search('option')

	options.each do |option|
		list_of_stock_symbol << option&.inner_text
		p option&.inner_text
	end

	File.open('./stock_symbols.txt', 'w') { |file|
		list_of_stock_symbol.each { |symbol| 
			p symbol
			file.puts(symbol)
		} 
	}
end

write_stock_symbol_to_file
