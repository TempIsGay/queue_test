if not game:IsLoaded() then
	while not game:IsLoaded() do
		task.wait(1)
	end
end

repeat wait() until game:IsLoaded()

script_key = "a"
local function ServerHop()
	local ScriptFile = Directory .. "/Dropfarm.lua"

	local ScriptSaved = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/TempIsGay/queue_test/main/sad.lua"))()]] 
	writefile(ScriptFile, ScriptSaved)
	local Queue = [[
        script_key = "]]..script_key..[[";
        loadstring(readfile("]] .. ScriptFile .. [["))()
    ]]

	print(Queue)
	queue_on_teleport(Queue)


	while true do		
		local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		local Server, Next = nil, nil

		local function ListServers(cursor)
			local Raw = game:HttpGet(Servers .. ((cursor and "&cursor="..cursor) or ""))

			return game:GetService("HttpService"):JSONDecode(Raw)
		end

		repeat
			local Servers = ListServers(Next)
			Server = Servers.data[math.random(1, (#Servers.data / 3))]
			Next = Servers.nextPageCursor
		until Server

		if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
			pcall(function()
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Server.id, player)
			end)
		end

		task.wait(10)
	end
end

task.delay(10, function()
    ServerHop()
end)


print("hello, world, hello, queue!")

local Directory = "TempCode"
if not isfolder(Directory) then
	makefolder(Directory)
end

ServerHop()
