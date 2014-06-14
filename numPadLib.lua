----------------------------------------------------------------------------------------------------------	
-------------------------------------   Constants   ------------------------------------------------------	
----------------------------------------------------------------------------------------------------------

VERSION = 1.4

SWAP 			= 11
RESET 			= 12	
TOGGLE_ON_OFF	= 13	

COM_1 = "COM 1"
COM_2 = "COM 2"
NAV_1 = "NAV 1"
NAV_2 = "NAV 2"
ADF_1 = "ADF 1"
ADF_2 = "ADF 2"
SQK   = "SQK"

----------------------------------------------------------------------------------------------------------	
-------------------------------------   Local functions   ------------------------------------------------	
----------------------------------------------------------------------------------------------------------

local function printComOutput(acr, byte1, byte2, byte3, byte4, swap, highlight, keystr)
	if swap then
		ipc.control(swap, 1)
		ipc.sleep(100)
	end
	
	if keystr then
		ipc.writeUW(byte3, "0x" .. keystr) 
	end
	
	b1 = ipc.readUB(byte1)
	b2 = ipc.readUB(byte1 + 1)
	
	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	
	b3 = ipc.readUB(byte3)
	b4 = ipc.readUB(byte3 + 1)
	
	n3 = logic.And(b3, 15)
	n4 = logic.And(b4, 15)

	if not highlight then
		printLine(acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
	elseif highlight == 1 then
		printLine(acr .. ":  * 1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. " *  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
	else
		printLine(acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  * " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3 .. " *");
	end
end

local function printAdfOutput(acr, byte1, byte2, byte3, byte4, highlight)
	b1 = ipc.readUB(byte1)
	b2 = ipc.readUB(byte2)

	n1 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)

	b3 = ipc.readUB(byte3)
	b4 = ipc.readUB(byte4)
	
	if not highlight then
		printLine(acr .. ":  " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3);
	else
		printLine(acr .. ": * " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3 .. " * ");
	end
end

local function printTransponderOutput(acr, highlight, keystr)
	if keystr then
		ipc.writeUW(0x0354, "0x" .. keystr)
	end
			
	b1 = ipc.readUB(0x0354);
	b2 = ipc.readUB(0x0355);

	n4 = logic.And(b1, 15)
	n2 = logic.And(b2, 15)
	n3 = logic.Shr(b1, 4)
	n1 = logic.Shr(b2, 4)

	if highlight then	
		printLine(acr .. ": * " .. n1 .. n2 .. n3 .. n4 .. " *");
	else
		printLine(acr .. ": " .. n1 .. n2 .. n3 .. n4);
	end
end

----------------------------------------------------------------------------------------------------------	
-------------------------------------   Function / argument mappings   -----------------------------------	
----------------------------------------------------------------------------------------------------------

printOutputMapT = {
	[COM_1] = { ["function"] = printComOutput, ["arguments"] = { COM_1, 0x034E, 0x034F, 0x311A, 0x311B } },     
	[COM_2] = { ["function"] = printComOutput, ["arguments"] = { COM_2, 0x3118, 0x3119, 0x311C, 0x311D } },
	[NAV_1] = { ["function"] = printComOutput, ["arguments"] = { NAV_1, 0x0350, 0x0351, 0x311E, 0x311F } },  
	[NAV_2] = { ["function"] = printComOutput, ["arguments"] = { NAV_2, 0x0352, 0x0353, 0x3120, 0x3121 } },
	[ADF_1] = { ["function"] = printAdfOutput, ["arguments"] = { ADF_1, 0x034C, 0x034D, 0x0356, 0x0357 } },
	[ADF_2] = { ["function"] = printAdfOutput, ["arguments"] = { ADF_2, 0x02D4, 0x02D5, 0x02D6, 0x02D7 } },
	[SQK]   = { ["function"] = printTransponderOutput, ["arguments"] = { SQK, false } }
}

swapOutputMapT = {
	[COM_1] = { ["function"] = printComOutput, ["arguments"] = { COM_1, 0x034E, 0x034F, 0x311A, 0x311B, 66372, 1 } },     
	[COM_2] = { ["function"] = printComOutput, ["arguments"] = { COM_2, 0x3118, 0x3119, 0x311C, 0x311D, 66444, 2 } },
	[NAV_1] = { ["function"] = printComOutput, ["arguments"] = { NAV_1, 0x0350, 0x0351, 0x311E, 0x311F, 66448, 1 } },  
	[NAV_2] = { ["function"] = printComOutput, ["arguments"] = { NAV_2, 0x0352, 0x0353, 0x3120, 0x3121, 66452, 2 } }
}

digitOutputMapT = {
	[COM_1] = { ["function"] = printComOutput, ["arguments"] = { COM_1, 0x034E, 0x034F, 0x311A, 0x311B, nil, 2 } },     
	[COM_2] = { ["function"] = printComOutput, ["arguments"] = { COM_2, 0x3118, 0x3119, 0x311C, 0x311D, nil, 2 } },
	[NAV_1] = { ["function"] = printComOutput, ["arguments"] = { NAV_1, 0x0350, 0x0351, 0x311E, 0x311F, nil, 2 } },  
	[NAV_2] = { ["function"] = printComOutput, ["arguments"] = { NAV_2, 0x0352, 0x0353, 0x3120, 0x3121, nil, 2 } },
	[ADF_1] = { ["function"] = printAdfOutput, ["arguments"] = { ADF_1, 0x034C, 0x034D, 0x0356, 0x0357, true } },
	[ADF_2] = { ["function"] = printAdfOutput, ["arguments"] = { ADF_2, 0x02D4, 0x02D5, 0x02D6, 0x02D7, true } }
}

----------------------------------------------------------------------------------------------------------	
-------------------------------------   Public functions   ------------------------------------------------	
----------------------------------------------------------------------------------------------------------

function printLine(line)
	ipc.writeSTR(0x3380, line);
	ipc.writeSW(0x32FA, 8);
end

function printOutputMap(acr)
	printOutputMapT[acr]["function"](unpack(printOutputMapT[acr]["arguments"]))
end

function printTransponderCode(highlight, keystr)
	printTransponderOutput(SQK, highlight, keystr)
end

function swapOutputMap(acr)
	if swapOutputMapT[acr] then 
		swapOutputMapT[acr]["function"](unpack(swapOutputMapT[acr]["arguments"]))
	end
end

function digitOutputMap(acr, keystr)
	args = digitOutputMapT[acr]["arguments"]
	
	if keystr then 
		table.insert(args, keystr)
	end
	
	digitOutputMapT[acr]["function"](unpack(args))
end

function initDevice(dev_1, dev_2) 
	ipc.set("KEY_STR", 0)
	ipc.set("KEY_POS", 1)
	ipc.set("DECIMAL_SET", false)
	
	acr = ipc.get("ACTIVE_RADIO")
	onoff = ipc.get("ONOFF")

	if onoff and onoff == "OFF" then
		return
	end

	if dev_2 then
		if ipcPARAM == 1 then 
			acr = dev_1
		elseif ipcPARAM == 2 then 
			acr = dev_2
		else
			acr = acr == dev_1 and dev_2 or dev_1
		end
	else
		acr = dev_1
	end
		
	printOutputMap(acr) 

	ipc.set("ACTIVE_RADIO", acr);
end

-- Checks is the frequency is in a valid range. Returns true if it's not
function notInValidRange(acr, keypos, keystr)
	if keypos == 2 and (acr == COM_1 or acr == COM_2) and (keystr > 13 or keystr < 11) then
		return true
	end
	
	if keypos == 3 and (acr == COM_1 or acr == COM_2) and (keystr > 136 or keystr < 118) then
		return true
	end
	
	if keypos == 2 and (acr == NAV_1 or acr == NAV_2) and (keystr > 11 or keystr < 10) then
		return true
	end
	
	if keypos == 3 and (acr == NAV_1 or acr == NAV_2) and (keystr > 117 or keystr < 108) then
		return true
	end
	
	return false
end