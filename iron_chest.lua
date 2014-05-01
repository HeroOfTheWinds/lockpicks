minetest.register_craft({
	output = 'technic:iron_chest 1',
	recipe = {
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
		{'default:steel_ingot','default:chest','default:steel_ingot'},
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
		{'default:steel_ingot','default:chest_locked','default:steel_ingot'},
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:iron_chest'},
	}
})


minetest.register_craftitem(":technic:iron_chest", {
	description = "Iron Chest",
	stack_max = 99,
})
minetest.register_craftitem(":technic:iron_locked_chest", {
	description = "Iron Locked Chest",
	stack_max = 99,
})

minetest.register_node(":technic:iron_chest", {
	description = "Iron Chest",
	tiles = {"technic_iron_chest_top.png", "technic_iron_chest_top.png", "technic_iron_chest_side.png",
		"technic_iron_chest_side.png", "technic_iron_chest_side.png", "technic_iron_chest_front.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[9,10;]"..
				"label[0,0;Iron Chest]"..
				"list[current_name;main;0,1;9,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;9.4,10.75;ui_form_bg.png]"..
				"background[0,1;9,4;ui_iron_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]")
		meta:set_string("infotext", "Iron Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 9*4)
	end,
	can_dig = chest_can_dig,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})

minetest.register_node(":technic:iron_locked_chest", {
	description = "Iron Locked Chest",
	tiles = {"technic_iron_chest_top.png", "technic_iron_chest_top.png", "technic_iron_chest_side.png",
		"technic_iron_chest_side.png", "technic_iron_chest_side.png", "technic_iron_chest_locked.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,tubedevice=1,tubedevice_receiver=1,locked=2},
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locked Iron Chest (owned by "..
		meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[9,10;]"..
				"label[0,0;Iron Locked Chest]"..
				"list[current_name;main;0,1;9,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;9.4,10.75;ui_form_bg.png]"..
				"background[0,1;9,4;ui_iron_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]")
		meta:set_string("infotext", "Iron Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 9*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if player:get_wielded_item():get_tool_capabilities().groupcaps.locked then
			if player:get_wielded_item():get_tool_capabilities().groupcaps.locked.maxlevel >= 2 then
				return true
			end
		end
		return inv:is_empty("main")
	end,
	on_punch = chest_on_punch,
	on_dig = function(pos, node, digger)
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local inv_list = inv:get_list("main")
		--if player dug chest with a lockpick
		if digger:get_wielded_item():get_tool_capabilities().groupcaps.locked then
			if digger:get_wielded_item():get_tool_capabilities().groupcaps.locked.maxlevel >= 2 then
				local wielditem = digger:get_wielded_item()
				local wieldlevel = digger:get_wielded_item():get_tool_capabilities().max_drop_level
				if math.random() > math.pow(.66, wieldlevel - 1) then --66% to the power of level difference
					minetest.set_node(pos, {name="technic:iron_chest",paramtype2="facedir"})
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
	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
