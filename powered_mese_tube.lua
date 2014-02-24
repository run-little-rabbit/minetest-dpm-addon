--operates similarly to a mese tube except it uses mesecon power to switch
--on and off.Just hook up a conductor tube to the side you wish to power and
--power the corresponding conductor tube to switch the color/side on=on;off=off
    local groups1
for white = 0, 1 do 
for black = 0, 1 do
for green = 0, 1 do
for yellow = 0, 1 do
for blue = 0, 1 do
for red = 0, 1 do         
        local NN = red..blue..yellow..green..black..white
        local mese_noctr_textures = {"pipeworks_powered_mese_tube_noctr_1_000000.png", "pipeworks_powered_mese_tube_noctr_2_000000.png", "pipeworks_powered_mese_tube_noctr_3_000000.png",
                                     "pipeworks_powered_mese_tube_noctr_4_000000.png", "pipeworks_powered_mese_tube_noctr_5_000000.png", "pipeworks_powered_mese_tube_noctr_6_000000.png"}
        local mese_plain_textures = {"pipeworks_powered_mese_tube_plain_1_000000.png", "pipeworks_powered_mese_tube_plain_2_000000.png", "pipeworks_powered_mese_tube_plain_3_000000.png",
                                     "pipeworks_powered_mese_tube_plain_4_000000.png", "pipeworks_powered_mese_tube_plain_5_000000.png", "pipeworks_powered_mese_tube_plain_6_000000.png"}
        local mese_end_textures = {"pipeworks_powered_mese_tube_end.png", "pipeworks_powered_mese_tube_end.png", "pipeworks_powered_mese_tube_end.png",
                                   "pipeworks_powered_mese_tube_end.png", "pipeworks_powered_mese_tube_end.png", "pipeworks_powered_mese_tube_end.png"}
        local mese_short_texture = "pipeworks_powered_mese_tube_short.png"
        local mese_inv_texture = "pipeworks_powered_mese_tube_inv.png"
        if white == 1 then
        --pipeworks_white.png
        white_TX = "pipeworks_white_on.png"
                for i = 1, 4 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_000001.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_000001.png"
                end
        end 
        if black == 1 then
                black_TX = "pipeworks_black_on.png"
                for i = 1, 4 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_000010.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_000010.png"
                end
        end
        if green == 1 then
                green_TX = "pipeworks_green_on.png"
                for i = 1, 2 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_000100.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_000100.png"
                end
                for i = 5, 6 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_000100.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_000100.png"
                end
        end
        if yellow == 1 then
                yellow_TX = "pipeworks_yellow_on.png"
                for i = 1, 2 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_001000.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_001000.png"
                end
                for i = 5, 6 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_001000.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_001000.png"
                end
        end
        if blue == 1 then
                blue_TX = "pipeworks_blue_on.png"
                for i = 3, 6 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_010000.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_010000.png"
                end
        end
        if red == 1 then
                red_TX = "pipeworks_red_on.png"
                for i = 3, 6 do
                        mese_noctr_textures[i] = mese_noctr_textures[i].."^pipeworks_powered_mese_tube_noctr_"..i.."_100000.png"
                        mese_plain_textures[i] = mese_plain_textures[i].."^pipeworks_powered_mese_tube_plain_"..i.."_100000.png"
                end
        end 
        if NN ~= "000000" then
                groups1 = {mesecon = 2,not_in_creative_inventory=1}
        else
                groups1 = {mesecon = 2}
        end
        --print("this is the node register!!---->"..NN)
        pipeworks.register_tube("dpm_addon:powered_mese_tube_"..NN, "Powered Mese pneumatic tube segment", mese_plain_textures, mese_noctr_textures,
                                mese_end_textures, mese_short_texture, mese_inv_texture,
                                        { groups = groups1,
                                        drop = "dpm_addon:powered_mese_tube_000000_000000",
                                mesecons = {effector = {rules=dpm_addon.mesecons_rules,
                                                        action_change = function (pos, node)
                                                        local white_TX = "pipeworks_white.png"
                                                        local black_TX = "pipeworks_black.png"
                                                        local green_TX = "pipeworks_green.png"
                                                        local yellow_TX = "pipeworks_yellow.png"
                                                        local blue_TX = "pipeworks_blue.png"
                                                        local red_TX = "pipeworks_red.png"
                                                        local meta = minetest.get_meta(pos)
                                                        local suffix = ""
                                                        local node = minetest.get_node(pos)
                                                        local name = node.name
                                                        local post_suffix = string.sub(name,-7)
                                                        if mesecon:is_powered(pos,{x=0,y=0,z=1}) then
                                                                meta:set_int("l1s", 1)
                                                                suffix = suffix.."1"
                                                                white_TX = "pipeworks_white_on.png"
                                                                --white
                                                        else
                                                                meta:set_int("l1s", 0)
                                                                suffix = suffix.."0"
                                                                white_TX = "pipeworks_white.png"
                                                        end 
                                                        if mesecon:is_powered(pos,{x=0,y=0,z=-1}) then
                                                                meta:set_int("l2s", 1)
                                                                suffix = suffix.."1"
                                                                black_TX = "pipeworks_black_on.png"
                                                                -- black
                                                        else
                                                                meta:set_int("l2s", 0)
                                                                suffix = suffix.."0"
                                                                black_TX = "pipeworks_black.png"
                                                        end
                                                        if mesecon:is_powered(pos,{x=0,y=1,z=0}) then
                                                                meta:set_int("l3s", 1)
                                                                suffix = suffix.."1"
                                                                green_TX = "pipeworks_green_on.png"
                                                                -- green
                                                        else
                                                                meta:set_int("l3s", 0)
                                                                suffix = suffix.."0"
                                                                green_TX = "pipeworks_green.png"
                                                        end 
                                                        if mesecon:is_powered(pos,{x=0,y=-1,z=0}) then
                                                                meta:set_int("l4s", 1)
                                                                suffix = suffix.."1"
                                                                yellow_TX = "pipeworks_yellow_on.png"
                                                                -- yellow
                                                        else
                                                                meta:set_int("l4s", 0)
                                                                suffix = suffix.."0"
                                                                yellow_TX = "pipeworks_yellow.png"
                                                        end 
                                                        if mesecon:is_powered(pos,{x=1,y=0,z=0}) then
                                                                meta:set_int("l5s", 1)
                                                                suffix = suffix.."1"
                                                                blue_TX = "pipeworks_blue_on.png"
                                                                -- blue
                                                        else
                                                                meta:set_int("l5s", 0)
                                                                suffix = suffix.."0"
                                                                blue_TX = "pipeworks_blue.png"
                                                        end 
                                                        if mesecon:is_powered(pos,{x=-1,y=0,z=0}) then
                                                                meta:set_int("l6s", 1)
                                                                suffix = suffix.."1"
                                                                red_TX = "pipeworks_red_on.png"
                                                                -- red
                                                        else
                                                                meta:set_int("l6s", 0)
                                                                suffix = suffix.."0"
                                                                red_TX = "pipeworks_red.png"       
                                                        end
                                                        
                                                        local newname = "dpm_addon:powered_mese_tube_"..string.reverse(suffix)..post_suffix
                                                        if name ~= newname then
                                                                minetest.swap_node(pos, {name = newname, param2 = node.param2})
                                                                local meta = minetest.get_meta(pos)
                                                                meta:set_string("formspec",
                                                                "size[8,11]"..
                                                                "list[current_name;line1;1,0;6,1;]"..
                                                                "list[current_name;line2;1,1;6,1;]"..
                                                                "list[current_name;line3;1,2;6,1;]"..
                                                                "list[current_name;line4;1,3;6,1;]"..
                                                                "list[current_name;line5;1,4;6,1;]"..
                                                                "list[current_name;line6;1,5;6,1;]"..
                                                                "image[0,0;1,1;"..white_TX.."]"..
                                                                "image[0,1;1,1;"..black_TX.."]"..
                                                                "image[0,2;1,1;"..green_TX.."]"..
                                                                "image[0,3;1,1;"..yellow_TX.."]"..
                                                                "image[0,4;1,1;"..blue_TX.."]"..
                                                                "image[0,5;1,1;"..red_TX.."]"..
                                                                "list[current_player;main;0,7;8,4;]")
                                                                
                                                        end
                                                        
                                                end } },
                                                                
                                tube = {can_go = function(pos, node, velocity, stack)
                                                 local tbl = {}
                                                 local meta = minetest.get_meta(pos)
                                                 local inv = meta:get_inventory()
                                                 local found = false
                                                 local name = stack:get_name()
                                                 for i, vect in ipairs(pipeworks.meseadjlist) do
                                                         if meta:get_int("l"..tostring(i).."s") == 1 then
                                                                 for _, st in ipairs(inv:get_list("line"..tostring(i))) do
                                                                         if st:get_name() == name then
                                                                                 found = true
                                                                                 table.insert(tbl, vect)
                                                                         end
                                                                 end
                                                         end
                                                 end
                                                 if found == false then
                                                         for i, vect in ipairs(pipeworks.meseadjlist) do
                                                                 if meta:get_int("l"..tostring(i).."s") == 1 then
                                                                         if inv:is_empty("line"..tostring(i)) then
                                                                                 table.insert(tbl, vect)
                                                                         end
                                                                 end
                                                         end
                                                 end
                                                 return tbl
                                        end},
                                 on_construct = function(pos)
                                        --print(white_TX)
                                         local meta = minetest.get_meta(pos)
                                         local inv = meta:get_inventory()
                                         for i = 1, 6 do
                                                 meta:set_int("l"..tostring(i).."s", 0)
                                                 inv:set_size("line"..tostring(i), 6*1)
                                         end
                                         meta:set_string("formspec",
                                                         "size[8,11]"..
                                                         "list[current_name;line1;1,0;6,1;]"..
                                                         "list[current_name;line2;1,1;6,1;]"..
                                                         "list[current_name;line3;1,2;6,1;]"..
                                                         "list[current_name;line4;1,3;6,1;]"..
                                                         "list[current_name;line5;1,4;6,1;]"..
                                                         "list[current_name;line6;1,5;6,1;]"..
                                                         "image[0,0;1,1;pipeworks_white.png]"..
                                                         "image[0,1;1,1;pipeworks_black.png]"..
                                                         "image[0,2;1,1;pipeworks_green.png]"..
                                                         "image[0,3;1,1;pipeworks_yellow.png]"..
                                                         "image[0,4;1,1;pipeworks_blue.png]"..
                                                         "image[0,5;1,1;pipeworks_red.png]"..
                                                         "list[current_player;main;0,7;8,4;]")
                                         meta:set_string("infotext", "Powered mese pneumatic tube")
                                 end,
                                 on_receive_fields = function(pos, formname, fields, sender)
                                        --print(white_TX)
                                         local meta = minetest.get_meta(pos)
                                         --print(dump(meta:to_table()))
                                         local i
                                         if fields.quit then return end
                                         for key, _ in pairs(fields) do i = key end
                                         if i == nil then return end
                                         i = string.sub(i,-1)
                                         local frm = "size[8,11]"..
                                                 "list[current_name;line1;1,0;6,1;]"..
                                                 "list[current_name;line2;1,1;6,1;]"..
                                                 "list[current_name;line3;1,2;6,1;]"..
                                                 "list[current_name;line4;1,3;6,1;]"..
                                                 "list[current_name;line5;1,4;6,1;]"..
                                                 "list[current_name;line6;1,5;6,1;]"..
                                                 "image[0,0;1,1;"..white_TX.."]"..
                                                 "image[0,1;1,1;"..black_TX.."]"..
                                                 "image[0,2;1,1;"..green_TX.."]"..
                                                 "image[0,3;1,1;"..yellow_TX.."]"..
                                                 "image[0,4;1,1;"..blue_TX.."]"..
                                                 "image[0,5;1,1;"..red_TX.."]"
                                         frm = frm.."list[current_player;main;0,7;8,4;]"
                                         meta:set_string("formspec", frm)
                                 end,
                                 can_dig = function(pos, player)
                                         local meta = minetest.get_meta(pos)
                                         local inv = meta:get_inventory()
                                         return (inv:is_empty("line1") and inv:is_empty("line2") and inv:is_empty("line3") and
                                                         inv:is_empty("line4") and inv:is_empty("line5") and inv:is_empty("line6"))
                                 end
                                }, true) -- Must use old tubes, since the textures are rotated with 6d ones


end --white
end --black
end --green
end --yellow
end --blue
end --red
    
    minetest.register_craft({
        output = 'dpm_addon:powered_mese_tube_000000_000000 1',
        recipe = {
                {                  '','mesecons:mesecon',''                  },
                {'mesecons:mesecon', 'pipeworks:mese_tube_000000','mesecons:mesecon'},
                {                '', 'mesecons:mesecon',''                   },
        }
        });
