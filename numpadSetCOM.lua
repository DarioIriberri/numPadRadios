acr = ipc.get("ACTIVE_RADIO")
ipc.set("KEY_STR", 0)
ipc.set("KEY_POS", 1)
ipc.set("DECIMAL_SET", false)

onoff = ipc.get("ONOFF")

if (not(onoff == nil) and onoff == "OFF") then
	return
end

if ipcPARAM == 1 then 
	acr = "COM_2"
else 
	if ipcPARAM == 2 then 
		acr = "COM_1"
	end
end

if not(acr == nil) and acr == "COM_1" then 
	nacr = "COM_2" 
	b1 = ipc.readUB(0x3118)
	b2 = ipc.readUB(0x3119)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(0x311C)
	b4 = ipc.readUB(0x311D)
	
	n3 = logic.And(b3, 15)
	n4 = logic.And(b4, 15)
	
	ipc.writeSTR(0x3380, nacr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
else 
	nacr = "COM_1"
	b1 = ipc.readUB(0x034E)
	b2 = ipc.readUB(0x034F)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(0x311A)
	b4 = ipc.readUB(0x311B)
	
	n3 = logic.And(b3, 15)
	n4 = logic.And(b4, 15)
	
	ipc.writeSTR(0x3380, nacr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
end 
ipc.set("ACTIVE_RADIO", nacr);

ipc.writeSW(0x32FA, 8);
