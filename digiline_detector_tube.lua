local detector_plain_textures = {"pipeworks_digiline_detector_tube_plain.png", "pipeworks_digiline_detector_tube_plain.png", "pipeworks_digiline_detector_tube_plain.png",
                                         "pipeworks_digiline_detector_tube_plain.png", "pipeworks_digiline_detector_tube_plain.png", "pipeworks_digiline_detector_tube_plain.png"}
local noctr_textures = {"pipeworks_digiline_detector_tube_noctr.png", "pipeworks_digiline_detector_tube_noctr.png", "pipeworks_digiline_detector_tube_noctr.png",
                        "pipeworks_digiline_detector_tube_noctr.png", "pipeworks_digiline_detector_tube_noctr.png", "pipeworks_digiline_detector_tube_noctr.png"}
local end_textures = {"pipeworks_digiline_detector_tube_end.png", "pipeworks_digiline_detector_tube_end.png", "pipeworks_digiline_detector_tube_end.png",
                      "pipeworks_digiline_detector_tube_end.png", "pipeworks_digiline_detector_tube_end.png", "pipeworks_digiline_detector_tube_end.png"}
local short_texture = "pipeworks_digiline_detector_tube_short.png"
local inv_texture = "pipeworks_digiline_detector_tube_inv.png"                                           
local detector_inv_texture = "pipeworks_digiline_detector_tube_inv.png"
        pipeworks.register_tube("dpm_addon:digiline_detector_tube", "Digiline detector tube segment", detector_plain_textures, noctr_textures,
                                end_textures, short_texture, detector_inv_texture,
                                --{
                                {tube = 
                                        {can_go = function(pos, node, velocity, stack)
                                                 local meta = minetest.get_meta(pos)
                                                 local channel = meta:get_string("channel")
                                                 --local name = minetest.get_node(pos).name
                                                 --local nitems = meta:get_int("nitems")+1
                                                 local Sname = stack:get_name()
                                                 local Scount = stack:get_count()
                                                 --print(Sname..Scount)
                                                 if channel ~= nil then
                                                        local msg = Sname.." "..tostring(Scount)
                                                        digiline:receptor_send(pos,digiline.rules.default,channel,msg)
                                                 end
                                                 return pipeworks.notvel(pipeworks.meseadjlist,velocity)
                                        end},
                                        digiline = {receptor = {},
                                                    effector = {action = function(pos,node,channel,msg) end}},
                                 on_construct = function(pos)
                                         local meta = minetest.get_meta(pos)
                                         meta:set_string("formspec","size[4,1]".."field[.5,.5;3.5,1;channel;Channel;${channel}]")
                                end,
                                on_receive_fields = function(pos, formname, fields, sender)
                                        local meta = minetest.get_meta(pos)
                                        meta:set_string("channel", fields.channel)
                                end
                                }--close tube=
                        )--closemeta
                        

minetest.register_craft({
        output = 'dpm_addon:digiline_detector_tube_1 1',
        recipe = {
                {                  '',       'digilines:wire_std_00000000',                  ''              },
                {'digilines:wire_std_00000000', 'pipeworks:detector_tube_off_1','digilines:wire_std_00000000'},
                {                '',           'digilines:wire_std_00000000',                ''              }
        }
        });
