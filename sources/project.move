module MyModule::GameRewards {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a player's achievements and earned tokens.
    struct Player has store, key {
        total_tokens: u64,   // Total tokens earned by the player
    }

    /// Function to register a new player.
    public fun register_player(game_owner: &signer, player_address: address) {
        let player = Player {
            total_tokens: 0,  // Start with 0 tokens
        };
        move_to(game_owner, player);
    }

    /// Function to reward tokens to a player for in-game achievements.
    public fun reward_player(game_owner: &signer, player_address: address, tokens: u64) acquires Player {
        let player = borrow_global_mut<Player>(player_address);

        // Transfer tokens from the game owner to the player
        let reward = coin::withdraw<AptosCoin>(game_owner, tokens);
        coin::deposit<AptosCoin>(player_address, reward);

        // Update the player's total earned tokens
        player.total_tokens = player.total_tokens + tokens;
    }
}
