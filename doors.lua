--overwrite the locked doors section of the doors mod

local function check_player_privs(pos, player)

		if not def.only_placer_can_open then
			return true
		end
		--------------------------------------
		local meta = minetest.env:get_meta(pos)
		if player:get_wielded_item():get_tool_capabilities().groupcaps.locked then
			minetest.chat_send_player(meta:get_string("doors_owner"), "Someone picked your door's lock at "..minetest.pos_to_string(pos))
			return true
		end
		--------------------------------------
		local pn = player:get_player_name()
		return meta:get_string("doors_owner") == pn
		
	end
	
local function on_rightclick(pos, dir, check_name, replace, replace_dir, params)
		pos.y = pos.y+dir
		if not minetest.env:get_node(pos).name == check_name then
			return
		end
		local p2 = minetest.env:get_node(pos).param2
		p2 = params[p2+1]
		
		local meta = minetest.env:get_meta(pos):to_table()
		minetest.env:set_node(pos, {name=replace_dir, param2=p2})
		minetest.env:get_meta(pos):from_table(meta)
		
		pos.y = pos.y-dir
		meta = minetest.env:get_meta(pos):to_table()
		minetest.env:set_node(pos, {name=replace, param2=p2})
		minetest.env:get_meta(pos):from_table(meta)

		local snd_1 = "_close"
		local snd_2 = "_open"
		if params[1] == 3 then
			snd_1 = "_open"
			snd_2 = "_close"
		end

		if is_right(pos) then
			minetest.sound_play("door"..snd_1, {pos = pos, gain = 0.3, max_hear_distance = 10})					
		else
			minetest.sound_play("door"..snd_2, {pos = pos, gain = 0.3, max_hear_distance = 10})
		end
	end
	
minetest.override_item("doors:door_steel_b_1", {
	can_dig = check_player_privs,
	on_rightclick = function(pos, node, clicker)
		if check_player_privs(pos, clicker) then
			on_rightclick(pos, 1, "door_steel_t_1", "door_steel_b_2", "door_steel_t_2", {1,2,3,0})
		end
	end,
}) 
minetest.override_item("doors:door_steel_t_1", {
	can_dig = check_player_privs,
	on_rightclick = function(pos, node, clicker)
		if check_player_privs(pos, clicker) then
			on_rightclick(pos, -1, "door_steel_b_1", "door_steel_t_2", "door_steel_b_2", {1,2,3,0})
		end
	end,
})
minetest.override_item("doors:door_steel_b_2", {
	can_dig = check_player_privs,
	on_rightclick = function(pos, node, clicker)
		if check_player_privs(pos, clicker) then
			on_rightclick(pos, 1, "door_steel_t_2", "door_steel_b_1", "door_steel_t_1", {3,0,1,2})
		end
	end,
})
minetest.override_item("doors:door_steel_t_2", {
	can_dig = check_player_privs,
	on_rightclick = function(pos, node, clicker)
		if check_player_privs(pos, clicker) then
			on_rightclick(pos, -1, "door_steel_b_2", "door_steel_t_1", "door_steel_b_1", {3,0,1,2})
		end
	end,
})