#================================================================================================
# Pokémon Twilight - Luma > Moves Definitions > Terrain Luma Move
#================================================================================================

module Battle
  class Move
    class TerrainLumaMove < LumaMove
      TERRAIN_MOVES = {
        luma_thunderbolt: :electric_terrain,
        luma_thicket: :grassy_terrain,
        luma_comet_storm: :misty_terrain,
        luma_psyop: :psychic_terrain
      }

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        turn_count = user.hold_item?(:terrain_extender) ? 8 : 5
        @logic.fterrain_change_handler.fterrain_change_with_process(TERRAIN_MOVES[db_symbol], turn_count)
      end
    end
    Move.register(:s_terrain_luma_move, TerrainLumaMove)
  end
end