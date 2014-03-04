--this function is a strait copy and paste from pipeworks..thanks to whoever wrote this :)
local function facedir_to_right_dir(facedir)
    
    --find the other directions
    local backdir = minetest.facedir_to_dir(facedir)
    local topdir = ({[0]={x=0, y=1, z=0},
                                    {x=0, y=0, z=1},
                                    {x=0, y=0, z=-1},
                                    {x=1, y=0, z=0},
                                    {x=-1, y=0, z=0},
                                    {x=0, y=-1, z=0}})[math.floor(facedir/4)]
    
    --return a cross product
        return {x=topdir.y*backdir.z - backdir.y*topdir.z,
                        y=topdir.z*backdir.x - backdir.z*topdir.x,
                        z=topdir.x*backdir.y - backdir.x*topdir.y}
end

local function convert(Rcount)
        if not tonumber(Rcount) then
                Rcount = string.upper(Rcount)
                if Rcount == "ALL" then
                        return "ALL"
                elseif Rcount == "PURGE" then
                        return "PURGE"
                elseif Rcount == "CHECK" then
                        return 0
                else
                        return "ERROR"
                end
        else
                return math.abs(tonumber(Rcount))
        end
end--function

local function formatted(stringy)
        local size
        local sign
        stringy = tonumber(stringy)
        if stringy == 0 then
                sign = "-"
                stringy = tostring(stringy)
                size = string.len(stringy)
        elseif stringy > 0 then
                sign = "+"
                stringy = tostring(stringy)
                size = string.len(stringy)
        else
                sign = "-"
                stringy = math.abs(stringy)
                stringy = tostring(stringy)
                size = string.len(stringy)
        end
        if size == 1 then
                stringy = sign.."0000"..stringy
        elseif size == 2 then
                stringy = sign.."000"..stringy
        elseif size == 3 then
                stringy = sign.."00"..stringy
        elseif size == 4 then
                stringy = sign.."0"..stringy
        elseif size == 5 then
                stringy = sign..stringy
        elseif size >= 6 then
                stringy = sign.."99999"
        else
                stringy = "-".."0"
        end
        return stringy
end

local function take (dir,idef,frominv,frompos,frominvname,stack,index,Rcount,maker)--return bool
        --this function used to return true or false. but for now it only returns true..
        local item = stack:take_item(Rcount)
        frominv:set_stack(frominvname, index, stack)
        if idef.allow_metadata_inventory_take then
                idef.on_metadata_inventory_take(frompos, "main", index, item, maker)
        end
        local item1 = pipeworks.tube_item(vector.add(frompos, vector.multiply(dir, 1.4)), item)
        item1:get_luaentity().start_pos = vector.add(frompos, dir)
        item1:setvelocity(dir)
        item1:setacceleration({x=0, y=0, z=0})
        return true
end--take                       
                    
local function extract(pos,dir,Sitem,Rcount,maker)
        local frompos = {x=pos.x - dir.x, y=pos.y - dir.y, z=pos.z - dir.z}
        local fromnode=minetest.get_node(frompos)
        local idef = minetest.registered_nodes[fromnode.name]
        local tube = idef.tube
        if not (tube and tube.input_inventory) then
                --print("tube,input_iventory")
                return "ERROR"
        end
        local frominvname = minetest.registered_nodes[fromnode.name].tube.input_inventory
        local frommeta = minetest.get_meta(frompos)
        --check for protection or owner
        --local owner = frommeta:get_string("owner")
        --if owner then
                --if not(owner == maker or owner == "") then
                        --print("owner")
                        --return "ERROR" --you don't own this chest..
                --end
        --end
        --if minetest.is_protected(frompos, maker) then
                --return "ERROR"
        --end
        local frominv = frommeta:get_inventory()
        local empty1 = true
        if Sitem == "ANYTHING" then--grab the first occupied slot
                for index, stack in ipairs(frominv:get_list(frominvname)) do
                        local count = stack:get_count()
                        if not stack:is_empty() then
                                empty1 = false
                                if not tonumber(Rcount) then
                                        if Rcount == "ALL" then
                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,count,maker) then
                                                        local R = formatted(count)..stack:get_name()
                                                        return R
                                                else
                                                        return "ERROR"
                                                end
                                        end--if Rcount == "ALL" then
                                else
                                        if Rcount == 0 then
                                                local R = formatted(count)..stack:get_name()
                                                return R
                                        elseif Rcount < count then
                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,Rcount,maker) then
                                                        local R = formatted(Rcount)..stack:get_name()
                                                        return R
                                                else
                                                        return "ERROR"
                                                end
                                        elseif Rcount > count then
                                                local R = formatted(count-Rcount)..stack:get_name()
                                                return R
                                        end--Rcount == (a number) then
                                end--if not tonumber(Rcount) then
                        end--if stack:get_name() ~= "" then
                end--for index, stack in ipairs(frominv:get_list(frominvname)) do
                if empty1 then
                        return "EMPTY"
                end
        elseif Sitem == "EVERYTHING" then--grab every slot
                local ething = {}
                local everything = "TABLE="
                local cue = {}
                local Icue={}
                for index, stack in ipairs(frominv:get_list(frominvname)) do
                        local count = stack:get_count()
                        local Sname = stack:get_name()
                        if not stack:is_empty() then
                                if not tonumber(Rcount) then
                                        if Rcount=="ALL" then
                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,count,maker) then
                                                        ething[#ething+1]= formatted(count)..Sname
                                                else
                                                        return "ERROR"
                                                end
                                        end
                                else
                                        if Rcount == 0 then
                                                ething[#ething+1] = formatted(count)..Sname
                                        end--if Rcount==(a number) then
                                end--if not tonumber(Rcount)
                        else
                                ething[#ething+1]="EMPTY"
                        end--if Sname ~= "" then
                end--for index, stack in ipairs(frominv:get_list(frominvname)) do
                for i, Titem in ipairs(ething) do
                        if everything ~= "TABLE=" then
                                everything = everything..","..Titem
                        else
                                everything = everything..Titem
                        end
                end
                return everything
        elseif tonumber(Sitem) then--grab a specific slot
                Sitem = tonumber(Sitem)
                if Sitem > frominv:get_size(frominvname) or Sitem == 0 then
                        return "ERROR"
                end
                stack = frominv:get_stack(frominvname,Sitem)
                local count = stack:get_count()
                if not stack:is_empty() then
                        if not tonumber(Rcount) then
                                if Rcount == "ALL" then
                                        if take(dir,idef,frominv,frompos,frominvname,stack,Sitem,count,maker) then
                                                local R = formatted(count)..stack:get_name()
                                                return R
                                        else
                                                return "ERROR"
                                        end
                                end
                        else
                                if Rcount == 0 then
                                        local R = formatted(count)..stack:get_name()
                                        return R
                                elseif Rcount > count then
                                        local R = formatted(count - Rcount)..stack:get_name()
                                        return R
                                elseif Rcount <= count then
                                        if take(dir,idef,frominv,frompos,frominvname,stack,Sitem,Rcount,maker) then
                                                local R = formatted(Rcount)..stack:get_name()
                                                return R
                                        else
                                                return "ERROR"
                                        end
                                end--if Rcount == 0 then
                        end--not tonumber(Rcount) then
                else
                        return "EMPTY"
                end--if not stack:is_empty() then
        else
                local every1 = 0
                local Ccheck = 0
                local purge = 0
                local cue = {}
                local Icue = {}
                for index, stack in ipairs(frominv:get_list(frominvname)) do
                        local count = stack:get_count()
                        local Sname = stack:get_name()
                        if not stack:is_empty() then
                                if Sname == Sitem then
                                        if not tonumber(Rcount) then
                                                if Rcount == "PURGE" then
                                                        if take(dir,idef,frominv,frompos,frominvname,stack,index,count,maker) then
                                                                purge = purge + count
                                                        else
                                                                return "ERROR"
                                                        end
                                                elseif Rcount == "ALL" and Sname == Sitem then
                                                        if take(dir,idef,frominv,frompos,frominvname,stack,index,count,maker) then
                                                                local R = formatted(count)..Sname
                                                                return R
                                                        else
                                                                return "ERROR"
                                                        end
                                                end
                                        else
                                                if Rcount == 0 then
                                                        Ccheck = Ccheck + count
                                                elseif Rcount > count and Sname == Sitem then
                                                        every1 = every1 + count
                                                        Icue[#Icue+1] = index
                                                        if Rcount <= every1 then
                                                                every1 = 0
                                                                for i, index in ipairs(Icue) do
                                                                        stack = frominv:get_stack(frominvname,index)
                                                                        count = stack:get_count()
                                                                        if i < #Icue then
                                                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,count,maker) then
                                                                                        every1 = every1 + count
                                                                                else
                                                                                        return "ERROR"
                                                                                end
                                                                        else
                                                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,Rcount - every1,maker) then
                                                                                        local R = formatted(Rcount)..Sitem
                                                                                        return R
                                                                                else
                                                                                        return "ERROR"
                                                                                end
                                                                        end
                                                                end--for i in ipairs(Icue) do
                                                               --print("this loop should never exit")
                                                        end--if Rcount > every1 then
                                                elseif Rcount <= count then
                                                        if every1 ~= 0 then--we were lacking in the other stacks but the current one has enough..grab the lacking ones first
                                                                every1 = 0
                                                                for i,index2 in ipairs(Icue) do
                                                                        local Tstack = frominv:get_stack(frominvname,index2)
                                                                        local Tcount = Tstack:get_count()
                                                                        if take(dir,idef,frominv,frompos,frominvname,Tstack,index2,Tcount,maker) then
                                                                                every1 = every1 + Tcount
                                                                        else
                                                                                return "ERROR"
                                                                        end
                                                                end--for i in Icue do
                                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,Rcount - every1,maker) then
                                                                        local R = formatted(Rcount)..Sitem
                                                                        return R
                                                                else
                                                                        return "ERROR"
                                                                end
                                                        else
                                                                if take(dir,idef,frominv,frompos,frominvname,stack,index,Rcount,maker) then
                                                                        local R = formatted(Rcount)..Sitem
                                                                        return R
                                                                else
                                                                        return "ERROR"
                                                                end
                                                        end--if every1 ~= 0 then
                                                end--if Rcount == (a number)
                                        end--if not tonumber(Rcount) then
                                end--if Sname == Sitem then
                        end --if not stack:is_empty() then
                end --for index, stack in ipairs(frominv:get_list(frominvname)) do
                if Ccheck > 0 then
                        local R = formatted(Ccheck)..Sitem
                        return R 
                end
                if every1 > 0 then
                        local R = formatted(every1-Rcount)..Sitem
                        return R
                end
                if purge > 0 then
                        local R = formatted(purge)..Sitem
                        return R
                end
                return "NOT_FOUND"
        end--if Sitem == "ANYTHING" then
end --extract function   

minetest.register_node("dpm_addon:digi_filter", {
    description = "Digi filter",
    tiles = {"pipeworks_digi_filter_top.png", "pipeworks_digi_filter_top.png", "pipeworks_digi_filter_output.png",
        "pipeworks_digi_filter_input.png", "pipeworks_digi_filter_side.png", "pipeworks_digi_filter_top.png"},
    paramtype2 = "facedir",
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,tubedevice=1},
    legacy_facedir_simple = true,
    sounds = default.node_sound_wood_defaults(),
    digiline = {receptor = {},
    effector = {action = function(pos,node,channel,msg)
                local meta = minetest.get_meta(pos)
                local localchan = meta:get_string("channel")
                if localchan == channel or channel == "ALL FILTERS" or not localchan == nil or not localchan == "" then
                        local maker = meta:get_string("maker")
                        local silent = meta:get_int("silent")
                        local space = string.find(msg,"%s")
                        if not space then
                               digiline:receptor_send(pos, digiline.rules.default, localchan,"ERROR")
                               return
                        end
                        local Sitem = string.sub(msg,1,space - 1)
                        local Rcount = string.sub(msg,space + 1)
                        Rcount = convert(Rcount)
                        local dir = facedir_to_right_dir(node.param2)
                        if Sitem == "SILENT" then
                                if Rcount == 1 and silent == 0 then
                                        meta:set_int("silent",1)
                                elseif Rcount == 0 and silent == 1  then
                                        meta:set_int("silent",0)
                                end
                        else 
                                if silent == 0 then
                                        if Rcount == "ERROR" then
                                                digiline:receptor_send(pos, digiline.rules.default, localchan,"ERROR")
                                                return
                                        end
                                        local digi_return = extract(pos,dir,Sitem,Rcount,maker)
                                        digiline:receptor_send(pos, digiline.rules.default, localchan, digi_return)
                                end--ifsilent
                        end --Sitem
                end-- localchan
        end}},--function____|}~
        on_construct = function(pos)
                local meta = minetest.get_meta(pos)
                meta:set_string("formspec","size[4,1]".."field[.5,.5;3.5,1;channel;Channel;${channel}]")
                meta:set_string("infotext", "Digi filter")
                meta:set_int("silent",0)
        end,
        on_receive_fields = function(pos, formname, fields, sender)
                if fields.channel == "ALL FILTERS" then
                        fields.channel = ""
                end
        minetest.get_meta(pos):set_string("channel", fields.channel)
        end,
        after_place_node = function(pos,placer)
                pipeworks.scan_for_tube_objects(pos)
                local meta = minetest.get_meta(pos)
                meta:set_string("maker",placer:get_player_name() or "")
        end,
        after_dig_node = function(pos)
                pipeworks.scan_for_tube_objects(pos)
        end,
        tube={connect_sides={right=1}}
})

minetest.register_craft( {
        type = "shapeless",
        output = 'dpm_addon:digi_filter',
        recipe = {
                'pipeworks:filter',
                'mesecons_luacontroller:luacontroller0000'
        },
});
