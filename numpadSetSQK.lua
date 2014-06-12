acr = ipc.get("ACTIVE_RADIO")
ipc.set("KEY_STR", 0)
ipc.set("KEY_POS", 1)
ipc.set("DECIMAL_SET", false)

onoff = ipc.get("ONOFF")

if (not(onoff == nil) and onoff == "OFF") then
	return
end

ipc.set("ACTIVE_RADIO", "SQK");
b1 = ipc.readUB(0x0354);
b2 = ipc.readUB(0x0355);

n4 = logic.And(b1, 15)
n2 = logic.And(b2, 15)
n3 = logic.Shr(b1, 4)
n1 = logic.Shr(b2, 4)

ipc.writeSTR(0x3380, "SQK:  " .. n1 .. n2 .. n3 .. n4);
ipc.writeSW(0x32FA, 8);
