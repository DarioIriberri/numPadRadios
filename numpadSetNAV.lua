acr = ipc.get("ACTIVE_RADIO")
ipc.set("KEY_STR", 0)
ipc.set("KEY_POS", 1)
ipc.set("DECIMAL_SET", false)

onoff = ipc.get("ONOFF")

if (not(onoff == nil) and onoff == "OFF") then
	return
end

if ipcPARAM == 1 then 
	acr = "NAV_2"
else 
	if ipcPARAM == 2 then 
		acr = "NAV_1"
	end
end

if not(acr == nil) and acr == "NAV_1" then 
	nacr = "NAV_2" 
	b1 = ipc.readUB(0x0352)
	b2 = ipc.readUB(0x0353)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(0x3120)
	b4 = ipc.readUB(0x3121)
	
	n3 = logic.And(b3, 15)
	n4 = logic.And(b4, 15)
	
	ipc.writeSTR(0x3380, nacr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
else 
	nacr = "NAV_1"
	b1 = ipc.readUB(0x0350)
	b2 = ipc.readUB(0x0351)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(0x311E)
	b4 = ipc.readUB(0x311F)
	
	n3 = logic.And(b3, 15)
	n4 = logic.And(b4, 15)
	
	ipc.writeSTR(0x3380, nacr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
end 
ipc.set("ACTIVE_RADIO", nacr);

ipc.writeSW(0x32FA, 8);
