--.....this spacing the original coder put is insane.....
minetest.register_node(":locks:shared_locked_chest", {
	description = "Shared locked chest",
	tiles      = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
                "default_chest_side.png", "default_chest_side.png", "default_chest_front.png"},
	paramtype2 = "facedir",
	groups     = {snappy=2,choppy=2,oddly_breakable_by_hand=2, locked=3},
	tube       = {
	insert_object = function(pos, node, stack, direction)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:add_item("main", stack)
	end,
	can_insert = function(pos, node, stack, direction)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:room_for_item("main", stack)
	end,
	input_inventory = "main",
	connect_sides = {left=1, right=1, back=1, front=1, bottom=1, top=1}
	},
	legacy_facedir_simple = true,

    on_construct = function(pos)
    	local meta = minetest.env:get_meta(pos)
        -- prepare the lock of the chest
        locks:lock_init( pos, 
        	"size[8,10]"..
--      	"field[0.5,0.2;8,1.0;locks_sent_lock_command;Locked chest. Type password, command or /help for help:;]"..
--      	"button_exit[3,0.8;2,1.0;locks_sent_input;Proceed]"..
        	"list[current_name;main;0,0;8,4;]"..
        	"list[current_player;main;0,5;8,4;]"..
        	"field[0.3,9.6;6,0.7;locks_sent_lock_command;Locked chest. Type /help for help:;]"..
        	"button_exit[6.3,9.2;1.7,0.7;locks_sent_input;Proceed]" );
--      	"size[8,9]"..
--      	"list[current_name;main;0,0;8,4;]"..
--      	"list[current_player;main;0,5;8,4;]");
        local inv = meta:get_inventory()
        inv:set_size("main", 8*4)
        end,
    after_place_node = function(pos, placer)

                if( locks.pipeworks_enabled ) then
		   pipeworks.scan_for_tube_objects( pos );
                end

                locks:lock_set_owner( pos, placer, "Shared locked chest" );
        end,
    can_dig = function(pos,player)
    			if player:get_wielded_item():get_tool_capabilities().groupcaps.locked then
             	 	if player:get_wielded_item():get_tool_capabilities().groupcaps.locked >= 1 then
						return true
					end
				end
                if( not(locks:lock_allow_dig( pos, player ))) then
                   return false;
                end
                local meta = minetest.env:get_meta(pos);
                local inv = meta:get_inventory()
                return inv:is_empty("main")
        end,
    on_receive_fields = function(pos, formname, fields, sender)
                locks:lock_handle_input( pos, formname, fields, sender );
        end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
                if( not( locks:lock_allow_use( pos, player ))) then
                   return 0;
                end
                return count;
        end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
                if( not( locks:lock_allow_use( pos, player ))) then
                   return 0;
                end
                return stack:get_count()
        end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
                if( not( locks:lock_allow_use( pos, player ))) then
                   return 0;
                end
                return stack:get_count()
        end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
                minetest.log("action", player:get_player_name()..
                                " moves stuff in locked shared chest at "..minetest.pos_to_string(pos))
        end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
                minetest.log("action", player:get_player_name()..
                                " moves stuff to locked shared chest at "..minetest.pos_to_string(pos))
        end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
                minetest.log("action", player:get_player_name()..
                                " takes stuff from locked shared chest at "..minetest.pos_to_string(pos))
        end,
    on_dig = function(pos, node, digger)
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local inv_list = inv:get_list("main")
		--if player dug chest with a lockpick
		if digger:get_wielded_item():get_tool_capabilities().groupcaps.locked then
			if digger:get_wielded_item():get_tool_capabilities().groupcaps.locked.maxlevel >= 1 then
				local wielditem = digger:get_wielded_item()
				local wieldlevel = digger:get_wielded_item():get_tool_capabilities().max_drop_level
				if math.random() > math.pow(.66, wieldlevel) then
					minetest.set_node(pos, {name="default:chest",paramtype2="facedir"})
					local n_meta = minetest.get_meta(pos)
					local n_inv = n_meta:get_inventory()
					n_inv:set_list("main", inv_list)
				else
					wielditem:clear()
					digger:set_wielded_item(wieldeditem)
					minetest.chat_send_player(digger:get_player_name(), "Your lockpick broke!")
				end
			end
		end
	end,
	after_dig_node = function( pos )
                if( locks.pipeworks_enabled ) then              
		   pipeworks.scan_for_tube_objects(pos)
                end
	end
})