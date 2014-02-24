This mod adds a powered mese tube, digiline detector tube, and digi filter.

IMPORTANT!:(you must rename this folder to "dpm_addon")

Instructions: Rename this folder to "dpm_addon" and add this folder into the 
"mods" directory of your minetest directory. This mod requires three other mods
to function; Digilines, Pipeworks, and Mesecons.

********************************************************************************
Powered Mese Tube:
        Powered mese tubes are almost identical to regular mese tubes in 
operation except that they use mese signals to turn "on" and "off". You may load
the tube with an inventory for filtering or leave it blank to allow any item to 
pass through the respective junction. To turn any particular junction "on" you 
must attach a conductor tube to the side you wish to power. Then apply power to
the conductor tube for operation. When the junction side/color is "on" that side
will change textures to indicate the change of state. Also, inside the inventory
menu, the color indicator will have a yellow bracket around it when powered. The
junction side/color will remain "on" for as long as there is mese power flowing
into it. When the power is removed the side/color will be "off". Basically, this 
is just a hacked mese tube with mese power instead of a formspec on/off button.
********************************************************************************

################################################################################
Digiline Detector Tube:
        Digiline detector tubes are tubes that use the digiline mod to send 
messages through digilines about the contents and quantities passing through 
them.After constructing a tube you should activate the tube and set the channel 
to something unique. Whenever something passes through the tube a message will 
be sent through that tubes channel containing the item's name and count. So the 
message you receive through the digiline should look something like 
"default:stone 3". Like any digiline mod, you will need to connect the device to
a digiline to receive message events. Some example code as fallows:

if event.type == "digiline" and event.channel == "mydigilinedetector" then
        print(event.msg)
end

 Digiline detector tubes won't work until a channel is set. If you're still 
unsure as to how the tubes operate then you should probably check Mesecons' lua
controller tutorial.
################################################################################

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
Digi Filter:
        Digi filters are programmable filters that use the Digiline mod. 
Messages are sent to the filter about the item quantity you wish them to inject 
into the tubes they are connected to. These messages are somewhat flexible in 
their specifications. You can: Send a specific item from an inventory, send an 
item from a specific slot in an inventory, send the first item in an inventory, 
or send every item in the inventory. Just as the item specifications are 
somewhat flexible, so are the quantity specifications. You may have every item 
of a particular stack sent, send every item of a specific type in any stack, 
send a specific amount,or send none at all and merely check the contents of an 
inventory.

Digi Filter Channels:
 Digi filters require a channel to operate. The digi filter will send and 
receive messages on this channel. To set the digi filter channel, activate the
filter just as you would activate any inventory/formspec. If the filter's 
channel is set there is a special channel available called "ALL FILTERS". This 
is a reserved channel that you may not use. If messages are sent on this channel
every filter that is set and connected will attempt to carry out the commands in 
the message. Basically, it is a global channel for mass purges, checks, and 
such..

Digi Filter Commands and Return Messages:
 Commands are messages sent through the digiline on the filter's channel.
When a digi filter receives a command it will send a return message on the same
channel(except ALL FILTERS).These return messages have a semi-fixed length to
aid in parsing. The format of the commands are <command><space><quantity>. The
format of the return message will either be a single word with no numbers or it
will contain <sign><five digit number><item name>. <sign> will be a plus for 
for items that are sent  and a hyphen for number items it lacked to carry out 
the request. The five digit number will contain leading zeros for place-holders.
 The quantities can be a number or a special quantity command. There 3 special
quantities. ALL, and CHECK can be used with any item command. PURGE can only be
used with a specific item command.

Specific Names:
 Specific names are the registered names for nodes and items in Minetest. (eg 
"default:stone"). After the specific name you should specify a quantity. With 
specific names there are some special behaviors and commands for quantities. If 
you specify "default:stone 40" and the first stack only has 20, the filter will 
continue to search the inventory for stone until it has found a total of forty 
stone or it exhausts it search.If the first stack only has twenty but the second
has forty the filter will remove all the first stack and twenty from the second.
When ALL is used in place of the quantity number, the digi filter will remove 
the entire stack of the first stack encountered of the specific type. If PURGE 
is specified the digi filter will remove every stack of the item specified in 
the entire inventory. PURGE can only be used with the specific name command.
CHECK or 0 will check the contents of the entire inventory and return the total 
number of instances of the specific item.

--get 10 stone
digiline_send("filterchan","default:stone 10")

--get every stone in the entire inventory 
digiline_send("filterchan","default:stone PURGE")

 --get all stone in 1st stack found 
digiline_send("filterchan","default:stone ALL")

--do not get. just check and return quantity
digiline_send("filterchan","default:stone CHECK")

--same as CHECK 
digiline_send("filterchan","default:stone 0")


Indexed Items:
 Indexed items are simply the items gathered by their inventory slot number. If 
you specify 2 then the filter will process the quantity for inventory slot 
number two. The numbered quantiles for for indexed items behave slightly 
different than specific names. If the indexed item does not contain an adequate 
quantity(one which is greater than or equal to the one you specified) the filter
will not proceed to the next inventory slot in search of an adequate quantity. 
If insufficient it will simply return the lacking amount. CHECK and ALL behave 
just as they do in any other command.

--get 10 of whatever is in the first inventory slot
digiline_send("filterchan","1 10")

--get the entire stack in slot number four 
digiline_send("filterchan","4 ALL")

--do not get. just check and return quantity 
digiline_send("filterchan","1 CHECK")

--same as CHECK 
digiline_send("filterchan","1 0")

If you attempt to index with a number outside the inventory size you will 
recieve an "ERROR" return message(unless your digi filter is set to silent).

First Items:
 First items are the items which occupy the least numerically significant 
inventory slot. This is the same behavior for listless pipeworks filters. They 
just grab the first item encountered and dump it into the tube. You can specify 
first items with the command, "ANYTHING". The quantities behave the same as 
indexed items for the special quantity, ANYTHING.

--get 10 of whatever is in the first occupied inventory slot
digiline_send("filterchan","ANYTHING 10")

--get the entire stack in the first occupied inventory slot 
digiline_send("filterchan","ANYTHING ALL")

--do not get. just return name and quantity in the first occupied inventory slot 
digiline_send("filterchan","ANYTHING CHECK")

--same as CHECK
digiline_send("filterchan","ANYTHING 0")


Mass Inventory Processing:
 Inventories can be manipulated on a larger scale using the command "EVERYTHING"
.This command will process the entire inventory list with the quantity specifier
. EVERYTHING doesn't use enumerated quantities. Only the special quantities 
CHECK(and 0) and ALL. ALL will empty the entire inventory when used in 
conjunction with EVERYTHING. CHECK behaves as the others, just with every single 
inventory slot.
 Mass Inventory return messages are different than all other commands. Instead 
of sending one message at a time for each slot it will generate a complete list
for occupied or unoccupied slot in the inventory. The return message will start 
with "TABLE=" with either a signed five digit number or the word "EMPTY" 
fallowed by a comma. This return message will be in the form of string.


--get all of everything
digiline_send("filterchan","EVERYTHING ALL") 

--do not get. just return name and quantity in the first occupied inventory slot
digiline_send("filterchan","EVERYTHING CHECK")

--same as CHECK
digiline_send("filterchan","EVERYTHING 0")


Special Commands:
 At the moment, there is only one special command: "SILENT". SILENT is used with
a quantity. This quantity should either be 1 or 0."SILENT 1" will set the digi
filter to silent-mode and "SILENT 0" will set the filter to verbose-mode. 
In silent-mode there are no return messages sent. Commands are carried out or 
ignored just as with verbose-mode but with less digiline chatter. The default 
for every digi filter is verbose-mode("SILENT 0").

--set the filter to silent-mode
digiline_send("filterchan","SILENT 1")


Special Channels:
 Every digi filter has it's own unique channel that you must specify. However,
all digi-filters have a special channel called "ALL FILTERS". This channel can
be used to send commands to every filter that you have connected to your 
digiline. If a filter is on verbose-mode and a command is sent through the "ALL 
FILTERS" channel, the digi filter will send it's response through it's own 
channel.

--Send all of everything in the inventory(use with caution).
digiline_send("ALL FILTERS","EVERYTHING ALL")

--set all the filters to silent mode.
digiline_send("ALL FILTERS","SILENT 1")

Return Messages:
 You can use these to create inventory lists, throw exception events, and 
numerous other things with your lua controller. If your request was successful,
the first character will contain a "+" sign indicating that the items were sent
through the connecting tube while a "-" indicates there were not enough item of
that type to process your request. The amount when a "-" is present in the 
return message indicates how many you were lacking to process your request. The 
exception to this is when the special quantity "CHECK" or "0" is
used. Then the sign will be a "+" for the total number of items that the 
inventory slot or item name contains/totals. After the sign character there will
be five numbers, likely with leading zeros. Fallowing that, the name of the item
which was processed.
 If the return message does not begin with a sign it will either be of some type
of status(ERROR, EMPTY, NOT_FOUND) or it will be a list. Lists always begin with
"TABLE=".

Lacking...(-)
 Lacking is a return message that is sent when your quantity was greater than 
what was available in the inventory. It will always be the first character in 
the return message.

event.msg="-00011default:stone"


Sent...(+)
  Sent is a return message that is sent when your quantity was less than or 
equal to what was available in the inventory. It will always be the first 
character in the return message.
 
event.msg="+00099default:stone"

Empty...(EMPTY)
 Empty is only returned when the entire inventory is empty or if the indexed 
slot that you requested is unoccupied.

event.msg="EMPTY"

Not Found..(NOT_FOUND)
 Not found is returned when the specific item you requested does not reside 
within the inventory.

event.msg="NOT_FOUND"

Error..(ERROR)
 There was an error in your request and it could not be processed. It doesn't
specify the cause, which might be malformed request(command lacking a space), no 
chest attached to filter, incorrect usage ("EVERYTHING PURGE") or numerous 
others..

event.msg="ERROR"

 I've tried to hack out a feature rich device for pipeworks and digilines. If 
you just scrolled to the bottom and said "forget that". I totally understand. If
you've glanced through this and said, "this may be adequate for my new dynamic 
sorting machine", please enjoy.
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
