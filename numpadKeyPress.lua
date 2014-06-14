onoff = ipc.get("ONOFF")
acr = ipc.get("ACTIVE_RADIO")
keystr = ipc.get("KEY_STR")
keypos = ipc.get("KEY_POS")
decimalset = ipc.get("DECIMAL_SET")

require "numPadLib"

if not onoff then 
	ipc.set("ONOFF", "ON")
end

if ipcPARAM == TOGGLE_ON_OFF then
	textOnOff = "***** ENABLED ******"
	if onoff == nil or onoff == "ON" then 
		ipc.set("ONOFF", "OFF")
		textOnOff = "DISABLED"
	else
		ipc.set("ONOFF", "ON")
	end
	
	printLine("Numpad Radios " .. VERSION .. " " .. textOnOff)
		
	return
end

if onoff and onoff == "OFF" then
	return
end

if acr == nil then 
	acr = COM_1
	ipc.set("ACTIVE_RADIO", COM_1)
end

if keystr == nil then
	keystr = 0
	ipc.set("KEY_STR", 0)
end

if keypos == nil then
	keypos = 1
	ipc.set("KEY_POS", 1)
end

if decimalset == nil then
	decimalset = false
	ipc.set("DECIMAL_SET", false)
end

skip = false 
set = false

if ipcPARAM == RESET then
	ipc.set("KEY_STR", 0)
	ipc.set("KEY_POS", 1)
	ipc.set("DECIMAL_SET", false)
	
	printOutputMap(acr)
	
	return

elseif ipcPARAM == SWAP then

	swapOutputMap(acr)
	
	return
	
----------------------------------------------------------------------------------------------------------	
-------------------------------------   COM / NAV block   ------------------------------------------------	
----------------------------------------------------------------------------------------------------------
	
else
	if acr == COM_1 or acr == COM_2 or acr == NAV_1 or acr == NAV_2 then
		if keypos == 1 and not ipcPARAM == 1 then 
		   return 
		end

		if (keypos == 1) then 
			keystr = ipcPARAM 
		
		elseif keypos == 4 and ipcPARAM == 10 then
			keyout = keystr .. "."
			skip = true
		
		elseif ipcPARAM == 10 then 
			return
			
		elseif keypos == 4 then 
			if ipcPARAM == 0 then
				keyout = keystr .. ".0"
				ipc.set("KEY_POS", keypos + 1)
				skip = true
			end
			
			keystr = keystr * 10 + ipcPARAM
			keystr = keystr / 10 
		
		elseif keypos == 5 then 
			keystr = keystr * 100 + ipcPARAM
			keystr = keystr / 100 
			
		else 
			keystr = keystr * 10 + ipcPARAM	
			
			--ipc.log("1 " .. keystr)
			
			if notInValidRange(acr, keypos, keystr) then
				return
			end
		end
					
		if keypos == 5 then 
			set = true
			
			keystr = (keystr - 100) * 100
			
			digitOutputMap(acr, keystr)
		end

----------------------------------------------------------------------------------------------------------	
----------------------------------------   ADF block   ---------------------------------------------------	
----------------------------------------------------------------------------------------------------------

	elseif acr == ADF_1 or acr == ADF_2 then 
		if keypos == 1 and not (ipcPARAM > 1) then 
			keystr = ipcPARAM 
		
		elseif decimalset == 0 and ipcPARAM == 10 then
			if (keystr < 100) then 
				return
			end
				
			decimalset = true
			ipc.set("DECIMAL_SET", true)
			--keystr = keystr .. "."
			keypos = 5
			ipc.set("KEY_POS", 5)
			
			skip = true
				
		elseif decimalset == 1 and ipcPARAM == 10 then 
			return
			
		else 
			keystr = keystr * 10 + ipcPARAM
			
			if keypos == 4 and (keystr > 1799 or keystr < 100) then
				return
			end
				
			if keypos == 5 then 
				set = true
				keystr = keystr / 10
				
				mil = math.floor(keystr / 1000)
				mid = math.floor(keystr) - (mil * 1000)
				dec = tonumber(string.format("%." .. 0 .. "f", (10 * (keystr - math.floor(keystr))))) 
				
				-- Sets the corresponding ADF frequency
				if acr == ADF_1 then 
					ipc.writeUB(0x0357, mil)
					ipc.writeUW(0x034C, "0x0" .. mid) 
					ipc.writeUB(0x0356, dec)			

				elseif acr == ADF_2 then 
					ipc.writeUB(0x02D7, mil)
					ipc.writeUW(0x02D4, "0x0" .. mid) 
					ipc.writeUB(0x02D6, dec)			

				end
				
				ipc.sleep(50)				
				printOutputMap(acr)
			end
		end
		
		-- Format the ADF frequency with leading zeros
		keyout = string.format("%04d", keystr)
		if skip then
			keyout = keyout .. "."
		end
----------------------------------------------------------------------------------------------------------	
-----------------------------------   Transponder block   ------------------------------------------------	
----------------------------------------------------------------------------------------------------------
	
	elseif acr == SQK then
		if ipcPARAM > 7 then 
			return
			
		elseif (keypos == 1) then 
			keystr = ipcPARAM 
		else
			keystr = keystr * 10 + ipcPARAM
			if keypos == 4 then 
				set = true
				printTransponderCode(true, keystr)
			end
		end
		
		-- Format the transponder code with leading zeros
		keystr = string.format("%04d", keystr)
	end

----------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------

	if keyout == nil then 
		keyout = keystr 
	end

	if not skip then 
		ipc.set("KEY_POS", keypos + 1) 
	end

	if set then 
		ipc.set("KEY_POS", 1) 
		ipc.set("KEY_STR", 0)
		ipc.set("DECIMAL_SET", false)
	else 
		ipc.set("KEY_STR", keystr)
		printLine(acr .. " -> " .. keyout)
	end
end