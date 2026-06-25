#================================================================================================
# Pokémon Twilight - Luma > Moves Definitions > Status Luma Move
#================================================================================================

module Battle
  class Move
    class StatusLumaMove < LumaMove
      private

      # Function that deals the status changes to all foes
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_status(user, actual_targets)
        super(user, @logic.foes_of(user))
      end
    end
    Move.register(:s_status_luma_move, StatusLumaMove)
  end
end