
script.on_init(function(data)
	storage.players = {} --for storing mod data per player
end)


script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.entity
	local player_index = event.player_index
	if entity.type == "linked-belt" then
		
		local name = entity.name
		
		if not storage.players[player_index] then
			storage.players[player_index] = {}
		end
		if not storage.players[player_index][name] then
			storage.players[player_index][name] = {}
		end
		
		local handler = storage.players[player_index][name] -- unique for player and linked belt
		
		if (handler.last_belt and handler.last_belt.valid) and not (entity.linked_belt_neighbour) then -- sometimes already linked 0_o
			-- second linked belt
			handler.last_belt.linked_belt_type = "input"
			entity.linked_belt_type = "output"
			entity.connect_linked_belts(handler.last_belt)
			handler.render_obj.destroy() -- destroy the warning that the linked-belt is not linked yet.
			if entity.surface == handler.last_belt.surface then
				rendering.draw_line{
					color={1,1,1},
					width=1,
					from=handler.last_belt,
					to=entity,
					surface=entity.surface,
					time_to_live=600,
					forces={entity.force.name},
					only_in_alt_mode=true
				}
			end
			handler.last_belt=nil
			handler.render_obj=nil
		elseif not (entity.linked_belt_neighbour) then
			-- first linked belt
			entity.linked_belt_type = "input"
			handler.last_belt = entity
			handler.render_obj = rendering.draw_sprite{
				target=entity,
				sprite="utility/crafting_machine_recipe_not_unlocked",
				surface=entity.surface,
				forces={entity.force.name},
				only_in_alt_mode=true,
				x_scale=0.6, y_scale=0.6
			}
		else -- fast replace or upgrade or instant-blueprint-building
			game.print('fast replace or upgrade or paste')
			game.print(entity.name)
			game.print(entity.linked_belt_neighbour.name)
			local link_entity = entity.linked_belt_neighbour
			if link_entity.name ~= entity.name then
				game.print(link_entity.surface.create_entity{name=entity.name, position=link_entity.position, direction=link_entity.direction, fast_replaceable=true, player=player_index}) -- works for paste, but not if entity has been upgraded
			end
		end
	end
end)

script.on_event(defines.events.on_selected_entity_changed, function(event)
--Called after the selected entity changes for a given player.

--Contains
--player_index :: uint: The player whose selected entity changed.
--last_entity :: LuaEntity (optional): The last selected entity if it still exists and there was one.
	local player_index = event.player_index
	local player = game.players[player_index]
	local entity = player.selected
	if entity and entity.valid then
		if entity.type == "linked-belt" then
			local lbn = entity.linked_belt_neighbour
			if lbn and lbn.surface == entity.surface then
				rendering.draw_line{
					color={1,1,1},
					width=1,
					from=entity,
					to=lbn,
					surface=entity.surface,
					time_to_live=600,
					forces={entity.force.name},
					only_in_alt_mode=true
				}
			end
		end
	end
end)

-- By heinwintoe
script.on_event(defines.events.on_player_mined_entity, function(event) -- should also be called for .on_robot_mined_entity (and .on_space_platform_mined_entity?)
    local player_index = event.player_index
    local player = game.players[player_index]
    local entity = player.selected
    if entity and entity.valid then
        if entity.type == "linked-belt" then
            local lbn = entity.linked_belt_neighbour
            if lbn and lbn.surface == entity.surface then
                --Mark linked belt neighbour for deconstruction
                lbn.order_deconstruction(lbn.force, player)
            end
        end
    end

end)