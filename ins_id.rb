require 'csv'

player_avail = []
playerids = []
play_count = 0
#read in players file, get player id
players_file = File.open('../players.txt')

#sort out the known and unknown ids
players_file.readlines.each do |line|
	if line !~ /playerid/
		playerids << "unknown"
	else
		playerid = line.scan(/playerid=(\w+)/)
		playerids << playerid[0]
	end
end

updated_csv = CSV.open('../updated_tjanalysis.csv', 'w')
updated_csv << ['Player', 'Player ID', 'TJ Surgery Date', 'Team', 'Majors']
players = CSV.foreach('../tjanalysis.csv', headers:true) do |row|
	updated_row =  [row['Player'], playerids[play_count][0], row['TJ Surgery Date'], row['Team'], row['Majors']]
	updated_csv.puts updated_row
	play_count = play_count + 1
end
