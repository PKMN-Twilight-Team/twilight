#================================================================================================
# Pokémon Twilight - Luma > Moves Definitions > Luma Move
#================================================================================================

module Battle
  class Move
    class LumaMove < Basic
      # Original move linked to this Luma Move
      # @return [Battle::Move]
      attr_reader :original_move

      # Create a new Luma Move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      def initialize(db_symbol, original_move, scene)
        @original_move = original_move
        @is_luma = true
        super(db_symbol, original_move.pp, original_move.ppmax, scene)
      end

      # Is the skill physical?
      # @return [Boolean]
      def physical?
        return original_move.physical?
      end

      # Is the skill special?
      # @return [Boolean]
      def special?
        return original_move.special?
      end
      
      # Checks if the move overwhelms protected targets and does some damage through protect-like effects
      # @return [Boolean] If the move is overwhelming
      def overwhelms_protect?
        return true
      end
    end
    Move.register(:s_luma_move, LumaMove)
  end
end