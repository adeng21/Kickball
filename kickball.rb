require 'sinatra'
require 'CSV'
require 'pry'




#loads information from CSV into hash
def load_players
@players ={}
CSV.foreach('lackp_starting_rosters.csv', headers:true) do |row|
  full_name = row['first_name']+ row['last_name']
  @players[full_name] = row.to_hash
end
return @players
end

before do
  @players = load_players
end

def team_page(teamname)

  @first_name_array = []
  @last_name_array = []
  @position_array = []


    @players.each do |player, pos_team|

      if pos_team.key(teamname)

      @first_name_array << pos_team["first_name"]
      @last_name_array << pos_team["last_name"]
      @position_array << pos_team["position"]
      end
    end
end

def team_list

  team_array = []
    @players.each do |player, pos_team|
      team_array << pos_team['team']
    end
  @team_list= team_array.uniq
end

def position_list
  position_array = []
    @players.each do |player, pos_team|
      position_array << pos_team['position']
    end
    @position_list = position_array.uniq

end

def position_page(position)

  @first_name_array = []
  @last_name_array = []
  @team_array = []

  @players.each do |key, value|
    if value.key(position)
      @first_name_array << value["first_name"]
      @last_name_array << value["last_name"]
      @team_array << value["team"]
    end

  end

end


#mainpage for the 4 teams
get '/mainpage' do

  @headline = "League of Cool Kickball Professionals"
  @headline2 = "Teams"
  @headline3 = "Positions"

  team_list
  position_list

  erb :index
end

#team pages
get '/team/:team_name' do

  team_name = params[:team_name]


  @headline = team_name
  @headline2 = "First Name"
  @headline3 = "Last Name"
  @headline4 = "Position"

  team_page(team_name)


  erb :index_team

end

#position pages
get '/position/:position' do

  position = params[:position]

  @headline = position
  @headline2 = "First Name"
  @headline3 = "Last Name"
  @headline4 = "Teams"

  position_page(position)

  erb :index_position
end

