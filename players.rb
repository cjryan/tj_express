require 'open-uri'
require 'nokogiri'

no_data = []
avail_data = []
playerids = []

#read in players file, get player id
players_file = File.open('../players.txt')

players_file.readlines.each do |line|
	if line !~ /playerid/
		no_data << line
	else
		avail_data << line
	end
end

avail_data.each do |player_url|
	#TODO: Add error handling for player ids, like sa381627
	#full url is different, too. must change regex to \w+
	playerid = player_url.scan(/playerid=(\d+)/)
  if playerid[0] == nil
		next
	else
		playerids << playerid[0]
	end
end

#get the number of pitches per player
playerids.each do |id|
  id = id[0]
	url = "http://www.fangraphs.com/statsd.aspx?playerid=#{id}&position=P&type=4&gds=&gde=&season=all"
	html = open(url)
	pitcher_page = Nokogiri::HTML(html)
	total_pitches = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[15]').text
	puts total_pitches
end
