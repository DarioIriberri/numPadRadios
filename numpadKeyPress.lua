onoff = ipc.get("ONOFF")
acr = ipc.get("ACTIVE_RADIO")
keystr = ipc.get("KEY_STR")
keypos = ipc.get("KEY_POS")
decimalset = ipc.get("DECIMAL_SET")

--ipc.display(ipc.readUB(0x3122))

if onoff == nil then 
	ipc.set("ONOFF", "ON")
end

if ipcPARAM == 13 then
	textOnOff = "***** ENABLED ******"
	if onoff == nil or onoff == "ON" then 
		ipc.set("ONOFF", "OFF")
		textOnOff = "DISABLED"
	else
		ipc.set("ONOFF", "ON")
	end
		ipc.writeSTR(0x3380, "Numpad Radios " .. textOnOff);
		ipc.writeSW(0x32FA, 8);
	return
end

if (not(onoff == nil) and onoff == "OFF") then
	return
end

if acr == nil then 
	acr = "COM_1"
	ipc.set("ACTIVE_RADIO", "COM_1")
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

if ipcPARAM == 12 then
	ipc.set("KEY_STR", 0)
	ipc.set("KEY_POS", 1)
	ipc.set("DECIMAL_SET", false)
	
	if acr == "COM_1" then 
		b1 = ipc.readUB(0x034E)
		b2 = ipc.readUB(0x034F)
		
		n1 = logic.And(b1, 15)
		n2 = logic.And(b2, 15)
		
		b3 = ipc.readUB(0x311A)
		b4 = ipc.readUB(0x311B)
		
		n3 = logic.And(b3, 15)
		n4 = logic.And(b4, 15)
		
		ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
			
	else
		if acr == "COM_2" then
			b1 = ipc.readUB(0x3118)
			b2 = ipc.readUB(0x3119)
			
			n1 = logic.And(b1, 15)
			n2 = logic.And(b2, 15)
			
			b3 = ipc.readUB(0x311C)
			b4 = ipc.readUB(0x311D)
			
			n3 = logic.And(b3, 15)
			n4 = logic.And(b4, 15)
			
			ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
			
		else
			if acr == "NAV_1" then
				b1 = ipc.readUB(0x0350)
				b2 = ipc.readUB(0x0351)
				
				n1 = logic.And(b1, 15)
				n2 = logic.And(b2, 15)
				
				b3 = ipc.readUB(0x311E)
				b4 = ipc.readUB(0x311F)
				
				n3 = logic.And(b3, 15)
				n4 = logic.And(b4, 15)
				
				ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
								
			else
				if acr == "NAV_2" then
					b1 = ipc.readUB(0x0352)
					b2 = ipc.readUB(0x0353)
					
					n1 = logic.And(b1, 15)
					n2 = logic.And(b2, 15)
					
					b3 = ipc.readUB(0x3120)
					b4 = ipc.readUB(0x3121)
					
					n3 = logic.And(b3, 15)
					n4 = logic.And(b4, 15)
					
					ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
									
				else 
					if acr == "ADF_1" then 
						b1 = ipc.readUB(0x034C)
						b2 = ipc.readUB(0x034D)
						
						n1 = logic.And(b1, 15)
						n2 = logic.And(b2, 15)
						
						b3 = ipc.readUB(0x0356)
						b4 = ipc.readUB(0x0357)
						
						ipc.writeSTR(0x3380, acr .. ":  " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3);
					else 
						if acr == "ADF_2" then 
							b1 = ipc.readUB(0x02D4)
							b2 = ipc.readUB(0x02D5)
							
							n1 = logic.And(b1, 15)
							n2 = logic.And(b2, 15)
							
							b3 = ipc.readUB(0x02D6)
							b4 = ipc.readUB(0x02D7)			
							
							ipc.writeSTR(0x3380, acr .. ":  " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3);
						else 
							if acr == "SQK" then
								b1 = ipc.readUB(0x0354);
								b2 = ipc.readUB(0x0355);

								n4 = logic.And(b1, 15)
								n2 = logic.And(b2, 15)
								n3 = logic.Shr(b1, 4)
								n1 = logic.Shr(b2, 4)

								ipc.writeSTR(0x3380, "SQK: " .. n1 .. n2 .. n3 .. n4);
							end		
						end
					end
				end
			end
		end
	end
	ipc.writeSW(0x32FA, 8);
	return
else

if ipcPARAM == 11 then
	if acr == "COM_1" then 
		--ipc.setbitsUB(0x3123, 8)
		ipc.control(66372, 1)
		
		ipc.sleep(100)
		
		b1 = ipc.readUB(0x034E)
		b2 = ipc.readUB(0x034F)
		
		n1 = logic.And(b1, 15)
		n2 = logic.And(b2, 15)
		
		b3 = ipc.readUB(0x311A)
		b4 = ipc.readUB(0x311B)
		
		n3 = logic.And(b3, 15)
		n4 = logic.And(b4, 15)
		
		ipc.writeSTR(0x3380, acr .. ":  * 1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. " *  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
			
	else
		if acr == "COM_2" then
			--ipc.setbitsUB(0x3123, 4)
			ipc.control(66444, 1)
			
			ipc.sleep(100)
			
			b1 = ipc.readUB(0x3118)
			b2 = ipc.readUB(0x3119)
			
			n1 = logic.And(b1, 15)
			n2 = logic.And(b2, 15)
			
			b3 = ipc.readUB(0x311C)
			b4 = ipc.readUB(0x311D)
			
			n3 = logic.And(b3, 15)
			n4 = logic.And(b4, 15)
			
			ipc.writeSTR(0x3380, acr .. ":  * 1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. " *  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
			
		else
			if acr == "NAV_1" then
				--ipc.setbitsUB(0x3123, 2)
				ipc.control(66448, 1)
					
				ipc.sleep(100)
					
				b1 = ipc.readUB(0x0350)
				b2 = ipc.readUB(0x0351)
				
				n1 = logic.And(b1, 15)
				n2 = logic.And(b2, 15)
				
				b3 = ipc.readUB(0x311E)
				b4 = ipc.readUB(0x311F)
				
				n3 = logic.And(b3, 15)
				n4 = logic.And(b4, 15)
				
				ipc.writeSTR(0x3380, acr .. ":  * 1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. " *  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
								
			else
				if acr == "NAV_2" then
					--ipc.setbitsUB(0x3123, 1)
					ipc.control(66452, 1)
						
					ipc.sleep(100)
					
					b1 = ipc.readUB(0x0352)
					b2 = ipc.readUB(0x0353)
					
					n1 = logic.And(b1, 15)
					n2 = logic.And(b2, 15)
					
					b3 = ipc.readUB(0x3120)
					b4 = ipc.readUB(0x3121)
					
					n3 = logic.And(b3, 15)
					n4 = logic.And(b4, 15)
					
					ipc.writeSTR(0x3380, acr .. ":  * 1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. " *  -  " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3);
									
				else 
					return
				end
			end
		end
	end
	ipc.writeSW(0x32FA, 8);
else

if acr == "COM_1" or acr == "COM_2" or acr == "NAV_1" or acr == "NAV_2" then
	if keypos == 1 and not (ipcPARAM == 1) then 
	   return 
	end

	if (keypos == 1) then keystr = ipcPARAM else 
		if keypos == 4 and ipcPARAM == 10 then
			keyout = keystr .. "."
			skip = true
		else 
			if ipcPARAM == 10 then return
			else
				if keypos == 4 then 
					if ipcPARAM == 0 then
						keyout = keystr .. ".0"
						ipc.set("KEY_POS", keypos + 1)
						skip = true
					end
					
					keystr = keystr * 10 + ipcPARAM
					keystr = keystr / 10 
				else
					if keypos == 5 then 
						keystr = keystr * 100 + ipcPARAM
						keystr = keystr / 100 
						
					else 
						keystr = keystr * 10 + ipcPARAM	
						
						ipc.log("1 " .. keystr)
						
						if keypos == 2 and (acr == "COM_1" or acr == "COM_2") and (keystr > 13 or keystr < 11) then
							return
						end
						
						if keypos == 3 and (acr == "COM_1" or acr == "COM_2") and (keystr > 136 or keystr < 118) then
							return
						end
						
						if keypos == 2 and (acr == "NAV_1" or acr == "NAV_2") and (keystr > 11 or keystr < 10) then
							return
						end
						
						if keypos == 3 and (acr == "NAV_1" or acr == "NAV_2") and (keystr > 117 or keystr < 108) then
							return
						end
					end
				end
				
				if keypos == 5 then 
					set = true
					
					keystr = (keystr - 100) * 100
					
					if acr == "COM_1" then 
						ipc.writeUW(0x311A, "0x" .. keystr) 
						
						b1 = ipc.readUB(0x034E)
						b2 = ipc.readUB(0x034F)
						
						n1 = logic.And(b1, 15)
						n2 = logic.And(b2, 15)
						
						b3 = ipc.readUB(0x311A)
						b4 = ipc.readUB(0x311B)
						
						n3 = logic.And(b3, 15)
						n4 = logic.And(b4, 15)
						
						ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  * " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3 .. " *");
						
					else 
						if acr == "COM_2" then 
							ipc.writeUW(0x311C, "0x" .. keystr)
								
							b1 = ipc.readUB(0x3118)
							b2 = ipc.readUB(0x3119)
							
							n1 = logic.And(b1, 15)
							n2 = logic.And(b2, 15)
							
							b3 = ipc.readUB(0x311C)
							b4 = ipc.readUB(0x311D)
							
							n3 = logic.And(b3, 15)
							n4 = logic.And(b4, 15)
							
							ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  * " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3 .. " *");
							
						else 
							if acr == "NAV_1" then	
								ipc.writeUW(0x311E, "0x" .. keystr)
								
								b1 = ipc.readUB(0x0350)
								b2 = ipc.readUB(0x0351)
								
								n1 = logic.And(b1, 15)
								n2 = logic.And(b2, 15)
								
								b3 = ipc.readUB(0x311E)
								b4 = ipc.readUB(0x311F)
								
								n3 = logic.And(b3, 15)
								n4 = logic.And(b4, 15)
								
								ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  * " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3 .. " *");
								
							else 
								if acr == "NAV_2" then	
									ipc.writeUW(0x3120, "0x" .. keystr)
									
									b1 = ipc.readUB(0x0352)
									b2 = ipc.readUB(0x0353)
									
									n1 = logic.And(b1, 15)
									n2 = logic.And(b2, 15)
									
									b3 = ipc.readUB(0x3120)
									b4 = ipc.readUB(0x3121)
									
									n3 = logic.And(b3, 15)
									n4 = logic.And(b4, 15)
									
									ipc.writeSTR(0x3380, acr .. ":  1" .. logic.Shr(b2, 4) .. n2 .. "." .. logic.Shr(b1, 4) .. n1 .. "  -  * " .. "1" .. logic.Shr(b4, 4) .. n4 .. "." .. logic.Shr(b3, 4) .. n3 .. " *");
									
								end
							end
						end
					end
					ipc.writeSW(0x32FA, 8);		 
				end
			end
		end
	end
	
	else if acr == "ADF_1" or acr == "ADF_2" then 
		if (keypos == 1 and not (ipcPARAM > 1)) then keystr = ipcPARAM else
			if not decimalset and ipcPARAM == 10 then
				if (keystr < 100) then 
					return
				end
				
				decimalset = true
				ipc.set("DECIMAL_SET", true)
				keyout = keystr .. "."
				keypos = 5
				ipc.set("KEY_POS", 5)
				
				skip = true
			else 
				if ipcPARAM == 10 and decimalset then return
				else 
					keystr = keystr * 10 + ipcPARAM
					
					-- if keypos == 2 and (keystr > 17 or keystr < 1) then
						-- return
					-- end
						
					-- if keypos == 3 and (keystr > 179 or keystr < 10) then
						-- return
					-- end
					
					if keypos == 4 and (keystr > 1799 or keystr < 100) then
						return
					end
						
					if keypos == 5 then 
						set = true
						keystr = keystr / 10
						
						mil = math.floor(keystr / 1000)
						mid = math.floor(keystr) - (mil * 1000)
						dec = tonumber(string.format("%." .. 0 .. "f", (10 * (keystr - math.floor(keystr))))) 
						
						if acr == "ADF_1" then 
							ipc.writeUB(0x0357, mil)
							ipc.writeUW(0x034C, "0x0" .. mid) 
							ipc.writeUB(0x0356, dec)			

							ipc.sleep(100)
							
							b1 = ipc.readUB(0x034C)
							b2 = ipc.readUB(0x034D)
							
							n1 = logic.And(b1, 15)
							n2 = logic.And(b2, 15)
							
							b3 = ipc.readUB(0x0356)
							b4 = ipc.readUB(0x0357)
							
							ipc.writeSTR(0x3380, acr .. ": * " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3 .. " * ");
						else 
							if acr == "ADF_2" then 
								ipc.writeUB(0x02D7, mil)
								ipc.writeUW(0x02D4, "0x0" .. mid) 
								ipc.writeUB(0x02D6, dec)			
																
								ipc.sleep(100)
								
								b1 = ipc.readUB(0x02D4)
								b2 = ipc.readUB(0x02D5)
								
								n1 = logic.And(b1, 15)
								n2 = logic.And(b2, 15)
								
								b3 = ipc.readUB(0x02D6)
								b4 = ipc.readUB(0x02D7)
								
								ipc.writeSTR(0x3380, acr .. ": * " .. b4 .. n2 .. logic.Shr(b1, 4) .. n1 .. "." .. b3 .. " * ");
							end
						end
						
						ipc.writeSW(0x32FA, 8);
					end
				end
			end
		end
		
		if skip then 
			if keystr < 10 then 
				keyout = "000" .. keyout 
			else 
				if keystr < 100 then 
					keyout = "00" .. keyout 
				else
					if keystr < 1000 then 
						keyout = "0" .. keyout 
					end
				end
			end
		else
			if keystr < 10 then 
				keyout = "000" .. keystr 
			else 
				if keystr < 100 then 
					keyout = "00" .. keystr 
				else
					if keystr < 1000 then 
						keyout = "0" .. keystr 
					end
				end
			end
		end
		
		else if acr == "SQK" then
			if ipcPARAM > 7 then return
			else
				if (keypos == 1) then keystr = ipcPARAM 
				else
					keystr = keystr * 10 + ipcPARAM
					if keypos == 4 then 
					    set = true
						ipc.writeUW(0x0354, "0x" .. keystr)
						
						b1 = ipc.readUB(0x0354);
						b2 = ipc.readUB(0x0355);

						n4 = logic.And(b1, 15)
						n2 = logic.And(b2, 15)
						n3 = logic.Shr(b1, 4)
						n1 = logic.Shr(b2, 4)

						ipc.writeSTR(0x3380, "SQK: * " .. n1 .. n2 .. n3 .. n4 .. " *");
						ipc.writeSW(0x32FA, 8);
					end
				end
			end
			
			if keystr < 10 then 
				keystr = "000" .. keystr 
			else 
				if keystr < 100 then 
					keystr = "00" .. keystr 
				else
					if keystr < 1000 then 
						keystr = "0" .. keystr 
					end
				end
			end
		end
	end
end

if keyout == nil then keyout = keystr end
	
if not skip then ipc.set("KEY_POS", keypos + 1) end

if set then 
	ipc.set("KEY_POS", 1) 
	ipc.set("KEY_STR", 0)
else 
	ipc.set("KEY_STR", keystr)
	ipc.writeSTR(0x3380, acr .. " -> " .. keyout);
	ipc.writeSW(0x32FA, 8);
end
end
end

