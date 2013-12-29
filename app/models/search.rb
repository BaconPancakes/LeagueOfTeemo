require 'vigor'
require 'settingslogic'

class Search
  SEARCH_DEPTH = 10
  attr_accessor :teemo_count_me, :teemo_count_total, :teemo_damage_dealt,
                :teemo_kills, :teemo_deaths, :teemo_damage_taken, :summoner,
                :teemo_turrets_killed, :teemo_minions_slain, :teemo_gold, :teemo_time, :teemo_assists, :teemo_CC
  def initialize(summoner, region)
    @teemo_count_me, @teemo_count_total, @teemo_damage_dealt,
        @teemo_kills, @teemo_deaths, @teemo_damage_taken, @teemo_turrets_killed, @teemo_gold,
        @teemo_minions_slain, @teemo_time, @teemo_assists, @teemo_CC = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    @summoner = summoner
    Vigor.configure(ENV['api_key'], region)
    begin
      summoner = Vigor.summoner(summoner)
    rescue Vigor::Error::SummonerNotFound
      @summoner = nil
    end
    if @summoner != nil
      self.analyze(summoner)
    end
  end

  #collect all the Teemo statistics
  def get_stats(game)
    game.stats.each do |stat|
      if stat['name'] == 'TOTAL_DAMAGE_DEALT_TO_CHAMPIONS'
        @teemo_damage_dealt += stat['value']
      end
      if stat['name'] == 'NUM_DEATHS'
        @teemo_deaths += stat['value']
      end
      if stat['name'] == 'TURRETS_KILLED'
        @teemo_turrets_killed += stat['value']
      end
      if stat['name'] == 'MINIONS_KILLED'
        @teemo_minions_slain += stat['value']
      end
      if stat['name'] == 'CHAMPIONS_KILLED'
        @teemo_kills += stat['value']
      end
      if stat['name'] == 'GOLD_EARNED'
        @teemo_gold += stat['value']
      end
      if stat['name'] == 'TIME_PLAYED'
        @teemo_time += stat['value']
      end
      if stat['name'] == 'TOTAL_DAMAGE_TAKEN'
        @teemo_damage_taken += stat['value']
      end
      if stat['name'] == 'ASSISTS'
        @teemo_assists += stat['value']
      end
      if stat['name'] == 'TOTAL_TIME_CROWD_CONTROL_DEALT'
        @teemo_CC += stat['value']
      end
    end
  end

  def fellow_player_search(game)
    game.fellow_players.each do |player|
      if @teemo_count_total <= SEARCH_DEPTH

        if player.champion_id == 17
          player.recent_games.each do |player_game|
            if @teemo_count_total <= SEARCH_DEPTH

              if player_game.champion_id == 17
                @teemo_count_total += 1
                get_stats(player_game)
              end
            end
          end
        end
      end
    end
  end

  def analyze(summoner)


    id = summoner.id
    recent_games = Vigor.recent_games(id)
    @summoner = summoner.name

    recent_games.each do |game|
      if game.champion_id == 17
        @teemo_count_me += 1
        @teemo_count_total += 1
        get_stats(game)
      end
      fellow_player_search(game)
    end
  end
end
