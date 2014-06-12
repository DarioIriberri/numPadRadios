acr = ipc.get("ACTIVE_RADIO")
ipc.set("KEY_STR", 0)
ipc.set("KEY_POS", 1)
ipc.set("DECIMAL_SET", false)

onoff = ipc.get("ONOFF")

if (not(onoff == nil) and onoff == "OFF") then
	return
end

if ipcPARAM == 1 then 
	acr = "ADF_2"
else 
	if ipcPARAM == 2 then 
		acr = "ADF_1"
	end
end

if not(acr == nil) and acr == "ADF_1" then 
	nacr = "ADF_2" 
	b1 = ipc.readUB(0x02D4)
	b2 = ipc.readUB(0x02D5)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(0x02D6)
	b4 = ipc.readUB(0x02D7)
	
	ipc.writeSTR(0x3380, nacr .. ":  " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3);

else 
	nacr = "ADF_1"
	b1 = ipc.readUB(0x034C)
	b2 = ipc.readUB(0x034D)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(0x0356)
	b4 = ipc.readUB(0x0357)
	
	ipc.writeSTR(0x3380, nacr .. ":  " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3);
end 
ipc.set("ACTIVE_RADIO", nacr);

ipc.writeSW(0x32FA, 8);
