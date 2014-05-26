require 'csv'
require 'open-uri'
require 'nokogiri'

#Create a temporary csv file to save the updated information
total_pitch_csv = CSV.open('../total_pitch.csv', 'w')
#Create the CSV headers
total_pitch_csv << ['Player', 'Player ID', 'TJ Surgery Date', 'Team', 'Majors', '# of pitches']
#get the number of pitches per player
players = CSV.foreach('../updated_tjanalysis.csv', headers:true) do |row|
	#grab player id from the csv, form the url, get the page, pass it to Nokogiri
	id = row['Player ID']

	#Convert date. The given date from the CSV is 5/20/2014. It needs to be
	#2014-05-19 for the url. 
	raw_end_date = row['TJ Surgery Date']
	end_date = raw_end_date.split('/').reverse.join("-")
	url = "http://www.fangraphs.com/statsd.aspx?playerid=#{id}&position=P&type=4&gds=&gde=#{end_date}&season=all"
	puts url
	html = open(url)
	pitcher_page = Nokogiri::HTML(html)

	#The //table/tbody is xpath syntax, the @ is a look up 
	#where @id is the id of the row, and td[15] is the 15th cell, 
	#or the pitching total.
	total_pitches = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[15]').text
	puts row['Player'] + " " + total_pitches

	#Write to the new csv file
  updated_row =  [row['Player'], id, row['TJ Surgery Date'], row['Team'], row['Majors'], total_pitches]
  total_pitch_csv.puts updated_row
end
