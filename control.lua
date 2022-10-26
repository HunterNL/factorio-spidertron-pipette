local function find_remote_in_inventory(inventory, spider_entity)
    for i = 1, #inventory do
        if inventory[i].connected_entity == spider_entity then
            return inventory[i], { inventory = inventory.index, slot = i }
        end
    end
end

local function is_hand_empty(player)
    return player.cursor_stack.count == 0; -- Any better way?
end

local function fetch_remote(player_index)
    local player = game.get_player(player_index);
    local selected_entity = player.selected; -- entity under mouse cursor

    if not is_hand_empty(player) then
        return
    end

    if selected_entity == nil then
        return
    end

    if selected_entity.type ~= "spider-vehicle" then
        return
    end

    local player_inventory = player.get_main_inventory();
    local remote, location = find_remote_in_inventory(player_inventory, selected_entity);

    if remote == nil then
        return
    end

    player.cursor_stack.transfer_stack(remote)
    player.hand_location = location -- reserves the slot in inventory, with a hand icon
end

script.on_event("hunter:remote-picker", function(event)
    fetch_remote(event.player_index)
end)
