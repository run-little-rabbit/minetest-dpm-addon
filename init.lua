dpm_addon.modpath = minetest.get_modpath("dpm_addon")
dpm_addon.mesecons_rules = {{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=1,z=0},{x=0,y=-1,z=0}}
dofile(dpm_addon.modpath.."/powered_mese_tube.lua")
dofile(dpm_addon.modpath.."/digiline_detector_tube.lua")
dofile(dpm_addon.modpath.."/digi_filter.lua")
