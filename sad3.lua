if not game:IsLoaded() then
	game.Loaded:Wait()
end

if getgenv().TE == nil then
	getgenv().TE = os.clock()
end

game.StarterGui:SetCore("SendNotification", {
	Title = "Time Elapsed",
	Text = tostring(os.clock() - getgenv().TE)) .. " Seconds;"),
	Duration = 10,
})

local Directory = "TempCode"
if not isfolder(Directory) then
	makefolder(Directory)
end

script_key = "a"
local function ServerHop()
	local ScriptFile = Directory .. "/Dropfarm.lua"

	local ScriptSaved = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/TempIsGay/queue_test/main/sad3.lua"))()]] 
	writefile(ScriptFile, ScriptSaved)
	local Queue = [[
	    getgenv().TE = "]]..  tostring(getgenv().TE) ..[[";
        script_key = "]]..script_key..[[";
        loadstring(readfile("]] .. ScriptFile .. [["))()
    ]]	

	print(Queue)
	queue_on_teleport(Queue)

	while true do		
		pcall(function()
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
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Server.id, game:GetService("Players").LocalPlayer)
			end

			task.wait(10)
		end)
	end
end

task.delay(10, function()
	ServerHop()
end)
