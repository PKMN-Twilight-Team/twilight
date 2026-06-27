#================================================================================================
# Pokémon Twilight - Luma > Logic Luma
#================================================================================================

module Battle
  class Logic
    class Luma
      # List of tools that allow Luma
      # @return [Array<Symbol>]
      LUMA_TOOLS = %i[luma_ring]

      # List of Luma Moves by type
      # @return [Hash{Symbol => Symbol}]
      LUMA_MOVES = {
        fire: :luma_scorch,
        water: :luma_waves,
        ground: :luma_dust_devil,
        ice: :luma_whiteout,
        electric: :luma_thunderbolt,
        grass: :luma_thicket,
        fairy: :luma_comet_storm,
        psychic: :luma_psyop
      }

      # List of signature Luma Moves by species and type
      # @return [Hash{Symbol => {type: Symbol, move: Symbol}}]
      SIGNATURE_LUMA_MOVES = {
        exploud: { type: :normal, move: :luma_beat_drop }
      }

      # Create the Luma logic
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        @used_luma_tool_bags = []
      end

      # Marks the pokemon's trainer as having used Luma
      # @param pokemon [Pokemon] The pokemon that has used luma
      # @return [void]
      def mark_as_luma_used(pokemon)
        @used_luma_tool_bags << pokemon.bag
      end

      # Determines if a given pokemon can Luma
      # @param pokemon [Pokemon] The pokemon to check
      # @return [Boolean] True if the pokemon can Luma, false otherwise
      def can_pokemon_luma?(pokemon)
        return false unless LUMA_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.from_party? && any_luma_player_action?
        return false if pokemon.can_mega_evolve? || pokemon.mega_evolved?

        return !@used_luma_tool_bags.include?(pokemon.bag)
      end

      # Updates the moveset of a given pokemon
      # @param pokemon [Pokemon] The pokemon whose moveset is to be updated
      # @param luma_activated [Boolean] Whether to set the moveset to the Luma state or the original state
      def update_moveset(pokemon, luma_activated)
        return pokemon.reset_to_original_moveset unless luma_activated

        pokemon.effects.add(Effects::Lumanized.new(@scene.logic, pokemon))
        pokemon.moveset.each_with_index do |move, i|
          pokemon.original_moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene)

          if move.status?
            pokemon.moveset[i] = Battle::Move[:s_luma_dodge].new(:luma_dodge, @scene, move)
            pokemon.moveset[i].is_luma = true
          else
            pokemon.moveset[i] = replace_with_luma_move(pokemon, move)
          end
        end
      end

      # Get the Luma Move corresponding to a certain move
      # @param pokemon [Pokemon] The pokemon whose moveset is to be updated
      # @param move [Move] The move to be replaced with a Luma Move.
      # @return [Move] The corresponding Luma Move.
      def replace_with_luma_move(pokemon, move)
        move_type = data_move(move.db_symbol).type
        if SIGNATURE_LUMA_MOVES.key?(pokemon.db_symbol) && SIGNATURE_LUMA_MOVES[pokemon.db_symbol][:type] == move_type
          luma_move_symbol = SIGNATURE_LUMA_MOVES[pokemon.db_symbol][:move]
        else
          luma_move_symbol = LUMA_MOVES[move_type]
        end

        return Battle::Move[data_move(luma_move_symbol).be_method].new(luma_move_symbol, @scene, move)
      end

      # Checks whether a non-player pokemon can Luma
      # without requiring the Luma Ring in their bag
      # @param pokemon [PFM::PokemonBattler]
      # @return [Boolean]
      def can_ai_pokemon_luma(pokemon)
        return false unless LUMA_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.can_mega_evolve? || pokemon.mega_evolved?
        
        return !@used_luma_tool_bags.include?(pokemon.bag)
      end

      private

      # Function that checks if any action of the player is a Luma
      # @return [Boolean] true if any player action is a Luma command, false otherwise
      def any_luma_player_action?
        @scene.player_action.flatten.any? { |action| action.is_a?(Actions::Luma) } 
      end
    end
  end
end