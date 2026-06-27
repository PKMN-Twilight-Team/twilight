#================================================================================================
# Pokémon Twilight - Luma > AI
#================================================================================================

module Battle
  module AI
    class Base
      module LumaScripts
        # Try to find the battle action for a dedicated pokemon, extended to evaluate Luma
        # @param pokemon [PFM::PokemonBattler]
        # @return [Actions::Base, Array<Actions::Base>]
        def battle_action_for(pokemon)
          return super(pokemon) unless @can_luma
          return super(pokemon) unless @scene.logic.luma.can_ai_pokemon_luma?(pokemon)

          result = super(pokemon)

          # If the AI would rather switch, revert the moveset and skip Loma
          if result.is_a?(Actions::Switch)
            pokemon.reset_to_original_moveset
            return result
          end

          return [Actions::Luma.new(@scene, pokemon), result]
        end
      end
      prepend LumaScripts
    end

    # Module that enables Luma Move usage for an AI level
    module LumaCapability
      private

      def init_capability
        super
        @can_luma = true
      end
    end

    TrainerLv4.prepend(LumaCapability)
    TrainerLv5.prepend(LumaCapability)
    TrainerLv6.prepend(LumaCapability)
    TrainerLv7.prepend(LumaCapability)
  end
end