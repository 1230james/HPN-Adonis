client = nil
service = nil
cPcall = nil
Pcall = nil
Routine = nil
GetEnv = nil
origEnv = nil
logError = nil

--// Core
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
	
	client.Core = {
		Name = script.Name;
		Special = script.Name;
		MakeGui = client.UI.Make;
		GetGui = client.UI.Get;
		RemoveGui = client.UI.Remove;
		ScriptCache = {};
		
		GetEvent = function()
			if client.Core.RemoteEvent then
				client.Core.RemoteEvent.Event:disconnect()
				client.Core.RemoteEvent.Security:disconnect()
				client.Core.RemoteEvent = nil
			end
			
			client.Core.RemoteEvent = {}
			
			local rindex = 0
			local firstSearch
			local timer = 1
			local prevTime = 0
			local start = os.time()
			local events = {}
			local found
			
			local function finishEvent(event)
				if event then
					client.Core.RemoteEvent.Object = event
					client.Core.RemoteEvent.FireServer = event.FireServer
					client.Core.RemoteEvent.Event = event.OnClientEvent:connect(client.Process.Remote)--]]
					client.Core.RemoteEvent.Security = event.Changed:connect(function(p)
						if p == "RobloxLocked" and client.Anti.RLocked(event) then
							client.Kill("RemoteEvent Locked")
						elseif not event or not event.Parent then
							client.Core.GetEvent()
						end
					end)
					
					--client.SetFireServer(service.MetaFunc(event.FireServer))
					
					if not client.Core.Key then
						client.Remote.Fire(client.DepsName.."GET_KEY")
					end
				else
					client.Kill("RemoteEvent not found")
				end
			end
			
			local function search()
				local children = {}
				for i,child in next,service.JointsService:GetChildren() do
					if string.sub(child.Name,1,#client.RemoteName) == client.RemoteName then
						table.insert(children, child)
					end
				end
				
				for ind,e in next,events do 
					e.Event:disconnect() events[ind] = nil
				end
				
				for i,child in next,children do
					if not client.Anti.ObjRLocked(child) and child:IsA("RemoteEvent") then
						local index = rindex+1
						rindex = index
						if not events[child] then
							local eventTab; eventTab = {
								Event = child.OnClientEvent:connect(function(com, ...)
									if com == "TrustCheck" and select(1,...) == client.Core.Special and not found then
										found = child
										client.Core.RemoteEvent.Event = eventTab.Event
										finishEvent(child)
										for ind,e in next,events do 
											if ind ~= child then
												e.Event:disconnect() events[ind] = nil
											end
										end
									elseif found and found == child then
										--client.Process.Remote(com, ...)
									end
								end);
								Object = child;
							}
							events[child] = eventTab
						end
						
						child:FireServer(client.Module, "TrustCheck")
					end
				end
			end
			
			repeat 
				if os.time() > prevTime then 
					prevTime = os.time() 
					timer = timer+1 
					if timer%10 == 0 or not firstSearch then 
						firstSearch = true
						local event = service.JointsService:FindFirstChild(client.RemoteName)
						if event then
							found = event
							finishEvent(event)
						end
						--search() 
					end 
				end 
				
			until found or not wait(0.01)
		end;
		
		LoadPlugin = function(plugin)
			local plug = require(plugin)
			local func = setfenv(plug,GetEnv(getfenv(plug)))
			cPcall(func)
		end;
		
		LoadBytecode = function(str, env)
			return require(client.Deps.Rerubi)(str, env)
		end;
		
		LoadCode = function(str, env)
			return client.Core.LoadBytecode(str, env)
		end;
		
		CheckClient = function()
			if tick() - client.Core.LastUpdate >= 55 then
				wait(math.random()) --// De-sync everyone's client checks
				local returner = math.random()
				local ret = client.Remote.Send("ClientCheck", {Sent = 0;--[[client.Remote.Sent]] Received = client.Remote.Received}, client.DepsName, returner)
				--[[if ret and ret == returner then
					client.Core.LastUpdate = tick()
				else
					client.Kill("Client check failed")
				end--]]
			end
		end;
		
		StartAPI = function()
			local ScriptCache = client.Core.ScriptCache
			local Rerubi = client.Deps.Rerubi
			local Get = client.Remote.Get
			local G_API = client.G_API
			local Allowed_API_Calls = client.Allowed_API_Calls
			local NewProxy = service.NewProxy
			local MetaFunc = service.MetaFunc
			local ReadOnly = service.ReadOnly
			local StartLoop = service.StartLoop
			local ReadOnly = service.ReadOnly
			local UnWrap = service.UnWrap
			local service = nil
			local client = nil
			local _G = _G
			local setmetatable = setmetatable
			local type = type
			local print = print
			local error = error
			local pairs = pairs
			local warn = warn
			local next = next
			local table = table
			local rawset = rawset
			local rawget = rawget
			local getfenv = getfenv
			local setfenv = setfenv
			local require = require
			local tostring = tostring
			local client = client
			local Routine = Routine
			local cPcall = cPcall
			
			--// Get Settings
			local API_Special = {
				
			}
			
			setfenv(1,setmetatable({}, {__metatable = getmetatable(getfenv())}))
			
			local API_Specific = {
				API_Specific = {
					Test = function()
						print("We ran the api specific stuff")
					end
				};
				Service = service;
			}
			
			local API = {
				Access = ReadOnly({}, nil, nil, true);
				--[[
				Access = service.MetaFunc(function(...)
					local args = {...}
					local key = args[1]
					local ind = args[2]
					local targ
					
					setfenv(1,setmetatable({}, {__metatable = getmetatable(getfenv())}))
					
					if API_Specific[ind] then 
						targ = API_Specific[ind] 
					elseif client[ind] and client.Allowed_API_Calls[ind] then
						targ = client[ind]
					end
					
					if client.G_Access and key == client.G_Access_Key and targ and client.Allowed_API_Calls[ind] then
						if type(targ) == "table" then
							return service.NewProxy {
								__index = function(tab,inde)
									if targ[inde] ~= nil and API_Special[inde] == nil or API_Special[inde] == true then
										if targ[inde]~=nil and type(targ[inde]) == "table" and client.G_Access_Perms == "Read" then
											return service.ReadOnly(targ[inde])
										else
											return targ[inde]
										end
									elseif API_Special[inde] == false then
										error("Access Denied: "..tostring(inde))
									else
										error("Could not find "..tostring(inde))
									end
								end;
								__newindex = function(tabl,inde,valu)
									error("Read-only")
								end;
								__metatable = true;
							}
						end
					else
						error("Incorrect key or G_Access is disabled")
					end
				end);
				--]]
				
				Scripts = ReadOnly({
					ExecutePermission = MetaFunc(function(code)
						local exists;
						
						for i,v in next,ScriptCache do
							if UnWrap(v.Script) == getfenv(2).script then
								exists = v
							end
						end
						
						if exists and exists.noCache ~= true and (not exists.runLimit or (exists.runLimit and exists.Executions <= exists.runLimit)) then
							exists.Executions = exists.Executions+1
							return exists.Source, exists.Loadstring
						end
						
						local data = Get("ExecutePermission",UnWrap(getfenv(3).script), code, true)
						if data and data.Source then
							local module;
							if not exists then
								module = require(Rerubi:Clone())
								table.insert(ScriptCache,{
									Script = getfenv(2).script; 
									Source = data.Source; 
									Loadstring = module;
									noCache = data.noCache;
									runLimit = data.runLimit;
									Executions = data.Executions;
								})
							else
								module = exists.Loadstring
								exists.Source = data.Source
							end
							return data.Source, module
						end
					end);
					
					ReportLBI = MetaFunc(function(scr, origin)
						if origin == "Local" then
							return true
						end
					end);
				}, nil, nil, true);
			}
			
			AdonisGTable = NewProxy{
				__index = function(tab,ind)
					if ind == "Scripts" then
						return API.Scripts
					elseif G_API and Allowed_API_Calls.Client == true then
						if type(API[ind]) == "function" then
							return MetaFunc(API[ind])
						else
							return API[ind]
						end
					else
						error("_G API is disabled")
					end
				end;
				__newindex = function(tabl,ind,new)
					error("Read-only")
				end;
				__metatable = "API";
			}
			
			if not _G.Adonis then
				rawset(_G,"Adonis",AdonisGTable)
				StartLoop("APICheck",1,function()
					rawset(_G,"Adonis",AdonisGTable)
				end, true)
			end
		end;
	};
end