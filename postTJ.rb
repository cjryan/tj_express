require 'csv'
require 'open-uri'
require 'nokogiri'
require 'date'

#updated 5-28-14 by GLP
#Create a temporary csv file to save the updated information
postTJ_pitch_csv = CSV.open('../postTJ_pitch.csv', 'w')
#Create the CSV headers
postTJ_pitch_csv << ['Player', 'Player ID', 'TJ Surgery Date', 'End date', 'Team', 'Majors', '# of pitches', 'FB%', 'FBv', 'SL%', 'SLv', 'CT%', 'CTv', 'CB%', 'CBv', 'CH%', 'CHv', 'SF%', 'SFv', 'KN%', 'KNv', 'XX%']
#get the number of pitches per player
players = CSV.foreach('../updated_tjanalysis.csv', headers:true) do |row|
	#grab player id from the csv, form the url, get the page, pass it to Nokogiri
	if row['Majors'] == 'N'
		next
	else
		id = row['Player ID']

		#Convert date. The given date from the CSV is 5/20/2014. It needs to be
		#2014-05-19 for the url. 
		raw_start_date = row['TJ Surgery Date']
		start_date = Date.strptime(raw_start_date, '%m/%d/%Y').strftime('%Y-%m-%d')
		raw_end_date = row['End date']
		end_date = Date.strptime(raw_end_date, '%m/%d/%Y').strftime('%Y-%m-%d')
		url = "http://www.fangraphs.com/statsd.aspx?playerid=#{id}&position=P&type=4&gds=#{start_date}&gde=#{end_date}&season=all"
		puts url
		html = open(url)
		pitcher_page = Nokogiri::HTML(html)

		#The //table/tbody is xpath syntax, the @ is a look up 
		#where @id is the id of the row, and td[15] is the 15th cell, 
		#or the pitching total.
		total_pitches = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[15]').text
		puts row['Player'] + " " + total_pitches
		
		url = "http://www.fangraphs.com/statsd.aspx?playerid=#{id}&position=P&type=6&gds=#{start_date}&gde=#{end_date}&season=all"
		puts url
		html = open(url)
		pitcher_page= Nokogiri::HTML(html)
		
		pitch_type_1 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[5]').text
		pitch_type_2 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[6]').text
		pitch_type_3 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[7]').text
		pitch_type_4 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[8]').text
		pitch_type_5 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[9]').text
		pitch_type_6 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[10]').text
		pitch_type_7 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[11]').text
		pitch_type_8 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[12]').text
		pitch_type_9 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[13]').text
		pitch_type_10 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[14]').text
		pitch_type_11 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[15]').text
		pitch_type_12 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[16]').text
		pitch_type_13 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[17]').text
		pitch_type_14 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[18]').text
		pitch_type_15 = pitcher_page.xpath('//table/tbody/tr[@id="DailyStats1_dgSeason1_ctl00__0"]/td[19]').text

		puts row['Player'] + " " + total_pitches + pitch_type_1 + pitch_type_2 + pitch_type_3 + pitch_type_4 + pitch_type_5 + pitch_type_6 + pitch_type_7 + pitch_type_8 + pitch_type_9 + pitch_type_10 + pitch_type_11 + pitch_type_12 + pitch_type_13 + pitch_type_14 + pitch_type_15
		#Write to the new csv file
		updated_row =  [row['Player'], id, row['TJ Surgery Date'], row['Team'], row['Majors'], total_pitches, pitch_type_1, pitch_type_2, pitch_type_3, pitch_type_4, pitch_type_5, pitch_type_6, pitch_type_7, pitch_type_8, pitch_type_9, pitch_type_10, pitch_type_11, pitch_type_12, pitch_type_13, pitch_type_14, pitch_type_15]
		postTJ_pitch_csv.puts updated_row
	end
end