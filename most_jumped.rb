require 'json'

file = File.read('./stock_informations.txt')

jumps = []

file.each_line do |line|
	data = JSON.parse line
	p data
	next if data["min_price"].nil? || data["max_price"].nil?
	data["difference_rate"] = (data["difference"].to_f * 100/data["min_price"]).round(2)
	jumps << data
end

sorted = jumps.sort {|x, y| y["difference_rate"] <=> x["difference_rate"]}

# p jumps

# p sorted

File.open('./most_jumped.txt', 'w') { |file|
	sorted.each do |sorted_data|
		file.puts(sorted_data.to_json)
	end
}
