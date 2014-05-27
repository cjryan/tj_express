require 'csv'
require 'open-uri'
require 'nokogiri'

#Create a temporary csv file to save the updated information
total_pitch_csv = CSV.open('../total_pitch.csv', 'w')
#Create the CSV headers
total_pitch_csv << ['Player', 'Player ID', 'TJ Surgery Date', 'Team', 'Majors', 'Pitches', 'FB%', 'FBv', 'SL%', 'SLv', 'CT%', 'CTv', 'CB%', 'CBv', 'CH%', 'CHv', 'SF%', 'SFv', 'KN%', 'KNv', 'XX%']
#get the number of pitches per player
players = CSV.foreach('../updated_tjanalysis.csv', headers:true) do |row|
	#grab player id from the csv, form the url, get the page, pass it to Nokogiri
	if row['Majors'] == 'N'
		next
	else
		id = row['Player ID']

		#Convert date. The given date from the CSV is 5/20/2014. It needs to be
		#2014-05-19 for the url. 
		raw_end_date = r-ow['TJ Surgery Date']
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

		url2= "http://www.fangraphs.com/statsd.aspx?playerid=#{id}&position=P&type=6&gds=&gde#{end_date}=&season=all"
		puts url2
		html = open(url2)
		pitchtype_page = Nokogiri::HTML(html)
		fbper=[]
		puts fbper[5]
		for i in 5..19
			fbper[i] = pitchtype_page.xpath('//table/tbody/tr
[@id="DailyStats1_dgSeason1_ct100__0"]/td[i]').text
		puts row['Player'] + " " + fbper[i]
		end

		#Write to the new csv file
		updated_row =  [row['Player'], id, row['TJ Surgery Date'], row['Team'], row['Majors'], total_pitches, fbper[5], fbper[6],fbper[7], fbper[8], fbper[9], fpber[10], fbper[11]
fbper[12], fbper[13], fbper[14], fbper[15], fbper[16], fbper[17], fbper[18], fbper[19]]
		total_pitch_csv.puts updated_row
	end
end
