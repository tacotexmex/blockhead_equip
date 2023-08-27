local new_on_secondary_use = function(itemstack, user, pointed_thing)
	local name = user:get_player_name()
	if user:get_player_control().sneak then
		pcall(minetest.registered_chatcommands["blockhead"].func, name, "")
	else
		pcall(minetest.registered_chatcommands["blockhead"].func, name, "-t")
	end
	if blockhead.get_state(user) then
        return nil
    else
        return itemstack
    end
end

minetest.register_on_mods_loaded(function()
	for nodename, def in pairs(minetest.registered_nodes) do
		if not def.on_secondary_use then
			minetest.override_item(nodename, { on_secondary_use = new_on_secondary_use })
		end
	end
end)

local def = minetest.registered_items[""]
local old_on_secondary_use
if def.on_secondary_use then
	old_on_secondary_use = def.on_secondary_use
	def.on_secondary_use = function(itemstack, user, pointed_thing)
		old_on_secondary_use(itemstack, user, pointed_thing)
		new_on_secondary_use(itemstack, user, pointed_thing)
	end
end

minetest.override_item("", { on_secondary_use = def.on_secondary_use })

-- TODO Use avatar hud to indicate reskinning
