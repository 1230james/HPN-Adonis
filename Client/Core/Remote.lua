client = nil
service = nil
cPcall = nil
Pcall = nil
Routine = nil
GetEnv = nil
origEnv = nil
logError = nil

--// Remote
return function()
	local _G, game, script, getfenv, setfenv, workspace, 
		getmetatable, setmetatable, loadstring, coroutine, 
		rawequal, typeof, print, math, warn, error,  pcall, 
		ypcall, xpcall, select, rawset, rawget, ipairs, pairs, 
		next, Rect, Axes, os, tick, Faces, unpack, string, Color3, 
		newproxy, tostring, tonumber, Instance, TweenInfo, BrickColor, 
		NumberRange, ColorSequence, NumberSequence, ColorSequenceKeypoint, 
		NumberSequenceKeypoint, PhysicalProperties, Region3int16, 
		Vector3int16, elapsedTime, require, table, type, wait, 
		Enum, UDim, UDim2, Vector2, Vector3, Region3, CFrame, Ray, delay = 
		_G, game, script, getfenv, setfenv, workspace, 
		getmetatable, setmetatable, loadstring, coroutine, 
		rawequal, typeof, print, math, warn, error,  pcall, 
		ypcall, xpcall, select, rawset, rawget, ipairs, pairs, 
		next, Rect, Axes, os, tick, Faces, unpack, string, Color3, 
		newproxy, tostring, tonumber, Instance, TweenInfo, BrickColor, 
		NumberRange, ColorSequence, NumberSequence, ColorSequenceKeypoint, 
		NumberSequenceKeypoint, PhysicalProperties, Region3int16, 
		Vector3int16, elapsedTime, require, table, type, wait, 
		Enum, UDim, UDim2, Vector2, Vector3, Region3, CFrame, Ray, delay
		
	local script = script
	local service = service
	local client = client
	getfenv().client = nil
	getfenv().service = nil
	getfenv().script = nil
	
	client.Remote = {
		Returns = {};
		PendingReturns = {};
		EncodeCache = {};
		DecodeCache = {};
		Received = 0;
		Sent = 0;
		
		Returnables = {
			Test = function(args)
				return "HELLO FROM THE CLIENT SIDE :)! ", unpack(args)
			end;
			
			Ping = function(args)
				return client.Remote.Ping()
			end;
			
			ClientHooked = function(args)
				return client.Core.Special
			end;
			
			TaskManager = function(args)
				local action = args[1]
				if action == "GetTasks" then
					local tab = {}
					for i,v in next,service.GetTasks() do
						local new = {}
						new.Status = v.Status
						new.Name = v.Name
						new.Index = v.Index
						new.Created = v.Created
						new.CurrentTime = os.time()
						new.Function = tostring(v.Function)
						table.insert(tab,new)
					end
					return tab
				end
			end;
			
			LoadCode = function(args)
				local code = args[1]
				local func = client.Core.LoadCode(code, GetEnv())
				if func then
					return func()
				end
			end;
			
			Function = function(args)
				local func = client.Functions[args[1]]
				if func and type(func)=="function" then
					return func(unpack(args,2))
				end
			end;
			
			UIKeepAlive = function(args)
				if client.Variables.UIKeepAlive then
					for ind,g in pairs(client.GUIs) do
						if g.KeepAlive then
							if g.Class == "ScreenGui" or g.Class == "GuiMain" then
								g.Object.Parent = service.PlayerGui
							elseif g.Class == "TextLabel" then
								g.Object.Parent = client.UI.GetHolder()
							end
							g.KeepAlive = false
						else
							g.KeepAlive = false
						end
					end
				end
				return "Done"
			end;
			
			UI = function(args)
				local guiName = args[1]
				local themeData = args[2]
				local guiData = args[3]
				
				--client.Core.Theme = themeData
				return client.UI.Make(guiName,guiData,themeData)
			end;
			
			InstanceList = function(args)
				local objects = service.GetAdonisObjects()
				local temp = {}
				for i,v in next,objects do
					table.insert(temp, {
						Text = v:GetFullName();
						Desc = v.ClassName;
					})
				end
				return temp
			end;
			
			ClientLog = function(args)
				local temp={}
				local function toTab(str, desc, color)
					for i,v in next,service.ExtractLines(str) do
						table.insert(temp,{Text = v,Desc = desc..v, Color = color})
					end
				end
				
				for i,v in next,service.LogService:GetLogHistory() do
					if v.messageType==Enum.MessageType.MessageOutput then
						toTab(v.message, "Output: ")
						--table.insert(temp,{Text=v.message,Desc='Output: '..v.message})
					elseif v.messageType==Enum.MessageType.MessageWarning then
						toTab(v.message, "Warning: ", Color3.new(1,1,0))
						--table.insert(temp,{Text=v.message,Desc='Warning: '..v.message,Color=Color3.new(1,1,0)})
					elseif v.messageType==Enum.MessageType.MessageInfo then
						toTab(v.message, "Info: ", Color3.new(0,0,1))
						--table.insert(temp,{Text=v.message,Desc='Info: '..v.message,Color=Color3.new(0,0,1)})
					elseif v.messageType==Enum.MessageType.MessageError then
						toTab(v.message, "Error: ", Color3.new(1,0,0))
						--table.insert(temp,{Text=v.message,Desc='Error: '..v.message,Color=Color3.new(1,0,0)})
					end
				end
				
				return temp
			end;
		};
		
		UnEncrypted = {
			LightingChange = function(prop,val)
				print(prop)
				print("TICKLE ME!?")
				client.Variables.LightingChanged = true
				service.Lighting[prop] = val
				client.Anti.LastChanges.Lighting = prop
				wait(0.1)
				client.Variables.LightingChanged = false
				print("TICKLED :)")
				print(client.Variables.LightingChanged)
				if client.Anti.LastChanges.Lighting == prop then
					client.Anti.LastChanges.Lighting = nil
				end
			end;
		};
		
		Commands = {
			GetReturn = function(args)
				local com = args[1]
				local key = args[2]
				local parms = {unpack(args,3)}
				local retfunc = client.Remote.Returnables[com]
				local retable = (retfunc and {pcall(retfunc,parms)}) or {}
				if retable[1] ~= true then
					logError(retable[2])
				else
					client.Remote.Send("GiveReturn",key,unpack(retable,2))
				end
			end;
			
			GiveReturn = function(args)
				if client.Remote.PendingReturns[args[1]] then
					client.Remote.PendingReturns[args[1]] = nil
					service.Events[args[1]]:fire(unpack(args,2))
				end
			end;
			
			SetVariables = function(args)
				local vars = args[1]
				for var,val in pairs(vars) do
					client.Variables[var] = val
				end
			end;
			
			Print = function(args)
				print(unpack(args))
			end;
			
			FireEvent = function(args)
				service.FireEvent(unpack(args))
			end;
			
			Test = function(args)
				print("OK WE GOT COMMUNICATION!  ORGL: "..tostring(args[1]))
			end;
			
			TestError = function(args)
				error("THIS IS A TEST ERROR")
			end;
			
			TestEvent = function(args)
				client.Remote.PlayerEvent(args[1],unpack(args,2))
			end;
			
			LoadCode = function(args)
				local code = args[1]
				local func = client.Core.LoadCode(code, GetEnv())
				if func then
					return func()
				end
			end;
			
			LaunchAnti = function(args)
				client.Anti.Launch(args[1],args[2])
			end;
			
			UI = function(args)
				local guiName = args[1]
				local themeData = args[2]
				local guiData = args[3]
				
				--client.Core.Theme = themeData
				client.UI.Make(guiName,guiData,themeData)
			end;
			
			RemoveUI = function(args)
				client.UI.Remove(args[1],args[2])
			end;
			
			StartLoop = function(args)
				local name = args[1]
				local delay = args[2]
				local code = args[3]
				local func = client.Core.LoadCode(code, GetEnv())
				if name and delay and code and func then
					service.StartLoop(name,delay,func)
				end
			end;
			
			StopLoop = function(args)
				service.StopLoop(args[1])
			end;
			
			Function = function(args)
				local func = client.Functions[args[1]]
				if func and type(func)=="function" then
					Pcall(func,unpack(args,2))
				end
			end;
		};
		
		Fire = function(...)
			local RemoteEvent = client.Core.RemoteEvent
			if RemoteEvent and RemoteEvent.Object then
				client.Remote.Sent = client.Remote.Sent+1
				RemoteEvent.Object:FireServer({Module = client.Module, Loader = client.Loader, Sent = client.Remote.Sent, Received = client.Remote.Received},...)
			end
		end;
		
		Send = function(com,...)
			client.Core.LastUpdate = tick()
			client.Remote.Fire(client.Remote.Encrypt(com,client.Core.Key),...)
		end;
		
		Get = function(com,...)
			local returns
			local key = client.Functions:GetRandom()
			local event = service.Events[key]:Connect(function(...) returns = {...} end)
			
			client.Remote.PendingReturns[key] = true
			client.Remote.Send("GetReturn",com,key,...)
			
			if not returns then
				returns = {event:Wait()}
			end
			
			event:Disconnect()
			
			if returns then
				return unpack(returns)
			else
				return nil
			end
		end;
		
		Ping = function()
			local t = tick()
			local ping = client.Remote.Get("Ping")
			if not ping then return false end
			local t2 = tick()
			local mult = 10^3
			local ms = ((math.floor((t2-t)*mult+0.5)/mult)*100)
			return ms
		end;
		
		PlayerEvent = function(event,...)
			client.Remote.Send("PlayerEvent",event,...)
		end;
		
		Encrypt = function(str, key, cache)
			local cache = cache or client.Remote.EncodeCache or {}
			if not key or not str then 
				return str
			elseif cache[key] and cache[key][str] then
				return cache[key][str]
			else
				local keyCache = cache[key] or {}
				local tobyte = string.byte
				local abs = math.abs
				local sub = string.sub
				local len = string.len
				local char = string.char
				local strBytes = {}
				local endStr = ""
				local byte = function(str, pos)
					return tobyte(sub(str, pos, pos))
				end
				
				for i = 1,len(str) do
					if i%len(str) > 0 then
						if byte(str, i) + byte(key, (i%len(key))+1) > 255 then
							strBytes[i] = abs(byte(str,i) - byte(key, (i%len(key))+1))
						else
							strBytes[i] = abs(byte(key, (i%len(key))+1) + byte(str, i))
						end
					else
						if byte(str, i) + byte(key, 1) > 255 then
							strBytes[i] = abs(byte(str, i) - byte(key, 1))
						else
							strBytes[i] = abs(byte(key, 1) + byte(str, i))
						end
					end
				end
				
				for i = 1,#strBytes do endStr = endStr .. char(strBytes[i]) end
				cache[key] = keyCache
				keyCache[str] = endStr
				return endStr
			end
		end;
		
		Decrypt = function(str, key, cache)
			local cache = cache or client.Remote.DecodeCache or {}
			if not key or not str then 
				return str 
			elseif cache[key] and cache[key][str] then
				return cache[key][str]
			else
				local keyCache = cache[key] or {}
				local tobyte = string.byte
				local abs = math.abs
				local sub = string.sub
				local len = string.len
				local char = string.char
				local strBytes = {}
				local endStr = ""
				local byte = function(str, pos)
					return tobyte(sub(str, pos, pos))
				end
				
				for i = 1,len(str) do
					if i%len(str) > 0 then
						if byte(str, i) + byte(key, (i%len(key))+1) > 255 then
							strBytes[i] = abs(byte(str,i) - byte(key, (i%len(key))+1))
						else
							strBytes[i] = abs(byte(key, (i%len(key))+1) - byte(str, i))
						end
					else
						if byte(str, i) + byte(key, 1) > 255 then
							strBytes[i] = abs(byte(str, i) - byte(key, 1))
						else
							strBytes[i] = abs(byte(key, 1) - byte(str, i))
						end
					end
				end
				
				for i = 1,#strBytes do endStr = endStr .. char(strBytes[i]) end
				cache[key] = keyCache
				keyCache[str] = endStr
				return endStr
			end
		end;
	};
end