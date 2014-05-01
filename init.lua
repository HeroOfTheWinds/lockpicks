--lockpicks v0.8 by HeroOfTheWinds
--Adds a variety of lockpicks and redefines most locked objects to allow them to be 'picked' and unlocked.

local breakexp = .66 --exponent for tools to determine 

--lockpick definitions
minetest.register_tool("lockpicks:lockpick_wood", {
	description="Wooden Lockpick",
	inventory_image = "wooden_lockpick.png",
	tool_capabilities = {
		max_drop_level = 1,
		groupcaps = {locked={maxlevel=1, uses=10, times={[3]=5.00}}}
	}
})
minetest.register_tool("lockpicks:lockpick_steel", {
	description="Steel Lockpick",
	inventory_image = "steel_lockpick.png",
	tool_capabilities = {
		max_drop_level = 2,
		groupcaps = {locked={maxlevel=2, uses=20, times={[2]=7.00,[3]=4.50}}}
	}
})
minetest.register_tool("lockpicks:lockpick_copper", {
	description="Copper Lockpick",
	inventory_image = "copper_lockpick.png",
	tool_capabilities = {
		max_drop_level = 3,
		groupcaps = {locked={maxlevel=2, uses=30, times={[2]=6.00,[3]=4.00}}}
	}
})
minetest.register_tool("lockpicks:lockpick_silver", {
	description="Silver Lockpick",
	inventory_image = "silver_lockpick.png",
	tool_capabilities = {
		max_drop_level = 4,
		groupcaps = {locked={maxlevel=3, uses=40, times={[1]=20.00,[2]=5.00,[3]=3.00}}}
	}
})
minetest.register_tool("lockpicks:lockpick_gold", {
	description="Gold Lockpick",
	inventory_image = "gold_lockpick.png",
	tool_capabilities = {
		max_drop_level = 5,
		groupcaps = {locked={maxlevel=3, uses=50, times={[1]=15.00,[2]=4.50,[3]=2.00}}}
	}
})
minetest.register_tool("lockpicks:lockpick_mithril", {
	description="Mithril Lockpick",
	inventory_image = "mithril_lockpick.png",
	tool_capabilities = {
		max_drop_level = 6,
		groupcaps = {locked={maxlevel=3, uses=50, times={[1]=10.00,[2]=4.00,[3]=1.00}}}
	}
})

--self-explanatory - taken from original locked chest code
local function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end


--locked node definitions

--load technic chests
modpath=minetest.get_modpath("lockpicks")

-- chests
if (minetest.get_modpath("technic")) then
	dofile(modpath.."/chest_commons.lua")
	dofile(modpath.."/iron_chest.lua")
	dofile(modpath.."/copper_chest.lua")
	dofile(modpath.."/silver_chest.lua")
	dofile(modpath.."/gold_chest.lua")
	dofile(modpath.."/mithril_chest.lua")
end

--redefine original locked chest
dofile(modpath.."/default_chest.lua")

--redefine the locks mod's shared chest
if (minetest.get_modpath("locks")) then
	dofile(modpath.."/locks.lua")
end

--if mesecons installed, define trap chests and mesecons chests
if (minetest.get_modpath("mesecons")) then
	dofile(modpath.."/trap_chest.lua")
end

--pick recipe definitions
minetest.register_craft({
	output = "lockpicks:lockpick_wood",
	recipe = {
		{"", "default:stick", "default:stick"},
		{"", "default:stick", ""},
		{"", "default:wood", ""}
	}
})
minetest.register_craft({
	output = "lockpicks:lockpick_steel",
	recipe = {
		{"", "default:steel_ingot", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
		{"", "default:wood", ""}
	}
})
minetest.register_craft({
	output = "lockpicks:lockpick_copper",
	recipe = {
		{"", "default:copper_ingot", "default::copper_ingot"},
		{"", "default::copper_ingot", ""},
		{"", "default:steel_ingot", ""}
	}
})
minetest.register_craft({
	output = "lockpicks:lockpick_silver",
	recipe = {
		{"", "moreores:silver_ingot", "moreores:silver_ingot"},
		{"", "moreores:silver_ingot", ""},
		{"", "default:steel_ingot", ""}
	}
})
minetest.register_craft({
	output = "lockpicks:lockpick_gold",
	recipe = {
		{"", "default:gold_ingot", "default:gold_ingot"},
		{"", "default:gold_ingot", ""},
		{"", "default:steel_ingot", ""}
	}
})
minetest.register_craft({
	output = "lockpicks:lockpick_mithril",
	recipe = {
		{"", "moreores:mithril_ingot", "moreores:mithril_ingot"},
		{"", "moreores:mithril_ingot", ""},
		{"", "default:steel_ingot", ""}
	}
})