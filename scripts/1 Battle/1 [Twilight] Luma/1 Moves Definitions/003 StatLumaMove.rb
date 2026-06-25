#================================================================================================
# Pokémon Twilight - Luma > Moves Definitions > Stat Luma Move
#================================================================================================

module Battle
  class Move
    class StatLumaMove < LumaMove
      private

      # Function that deals the stat changes to all foes
      def deal_stats(user, actual_targets)
        super(user, @logic.foes_of(user))
      end
    end
    Move.register(:s_stat_luma_move, StatLumaMove)
  end
end