#================================================================================================
# Pokémon Twilight - Luma > Moves Definitions > Weather Luma Move
#================================================================================================

module Battle
  class Move
    class WeatherLumaMove < LumaMove
      WEATHER_MOVES = {
        luma_scorch: :sunny,
        luma_waves: :rain,
        luma_dust_devil: :sandstorm,
        luma_whiteout: :hail
      }

      WEATHER_ITEMS = {
        sunny_day: :heat_rock,
        rain_dance: :damp_rock,
        sandstorm: :smooth_rock,
        hail: :icy_rock
      }

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        nb_turn = user.hold_item?(WEATHER_ITEMS[db_symbol]) ? 8 : 5
        @logic.weather_change_handler.weather_change_with_process(WEATHER_MOVES[db_symbol], nb_turn)
      end
    end
    Move.register(:s_weather_luma_love, WeatherLumaMove)
  end
end