local TheNet = GLOBAL.TheNet
local SpawnPrefab = GLOBAL.SpawnPrefab
local DeathRespawn = GLOBAL.require("prefabs/player_common")

PrefabFiles = {
	"deathamulet",
}

reds = {}
blues = {}


function TeamBattleSetup(inst)
	if TheNet:GetServerGameMode() == "team_battle" then
		print("### Team Battle ###")

local function ondeath(inst)
   
   if inst.lives > 1 then
		print("lives>1")
		local amulet = SpawnPrefab("deathamulet")
		if amulet ~= nil then
			local x, y, z = inst.Transform:GetWorldPosition()
			amulet.Transform:SetPosition(x, y, z)
			print("amulet spawned")
		end
		inst.lives = inst.lives - 1
		if inst.lives > 1 then
			TheNet:Announce(inst:GetDisplayName().." has got " .. tostring(inst.lives) .." lives remaining!")
		end
		if inst.lives == 1 then
			TheNet:Announce(inst:GetDisplayName().." has got only one life remaining. Be careful!")
		end
	elseif inst.lives == 1 then
		TheNet:Announce(inst:GetDisplayName().." died. Rest in peace.")		
	elseif inst.lives == -1 then
		print("lives=-1")
    	local amulet = SpawnPrefab("deathamulet")
		if amulet ~= nil then
			local x, y, z = inst.Transform:GetWorldPosition()
			amulet.Transform:SetPosition(x, y, z)
			print("amulet spawned")
		end
	end
end

function IntroMessage(inst)
	if inst.lives < 0 then
	TheNet:Announce(inst:GetDisplayName().." has entered the Battle Royale!")
	TheNet:Announce("Overcome your enemies in this neverending fight!")	
	end
	if inst.lives == 1 then
	TheNet:Announce(inst:GetDisplayName().." entered the Battle Royale with only one life left.")
	TheNet:Announce("Will he manage to survive?")	
	end
	if inst.lives > 1 then
	TheNet:Announce(inst:GetDisplayName().." entered the Battle Royale!")
 	TheNet:Announce(inst:GetDisplayName().." fights with " .. tostring(inst.lives) .." lives.")
 	end
end

function GetTeams(inst)
	local player = GLOBAL.ThePlayer
	print(player)
	print(number_of_reds)
	print(number_of_blues)
	if number_of_reds == number_of_blues then
	local random_number = math.random(2)
	print(random_number)
		if random_number == 1 then
			if not reds[player.userid] and not blues[player.userid] then
					reds[player.userid] = true
					number_of_reds = number_of_reds + 1
					TheNet:Announce(inst:GetDisplayName().." joined team Red")
					print("added to reds")
					for key,value in pairs(reds) do print(key,value) end
			end
		end	
		if random_number == 2 then
			if not blues[player.userid] and not reds[player.userid] then
					blues[player.userid] = true
					number_of_blues = number_of_blues + 1
					TheNet:Announce(inst:GetDisplayName().." joined team Blue")
					print("added to blues")
					for key,value in pairs(blues) do print(key,value) end
			end	
		end	
	elseif number_of_reds < number_of_blues then
		if not reds[player.userid] and not blues[player.userid] then
					reds[player.userid] = true
					number_of_reds = number_of_reds + 1
					TheNet:Announce(inst:GetDisplayName().." joined team Red")
					print("added to reds")
					for key,value in pairs(reds) do print(key,value) end
		end
	elseif number_of_blues < number_of_reds then
		if not blues[player.userid] and not reds[player.userid] then
					blues[player.userid] = true
					number_of_blues = number_of_blues + 1
					TheNet:Announce(inst:GetDisplayName().." joined team Blue")
					print("added to blues")
					for key,value in pairs(blues) do print(key,value) end
		end	
	end
	
end	
	
local OnPlayerActivated = function(inst)
	--IntroMessage(inst)
	print(inst:GetDisplayName().." activated")
	GetTeams(inst)
end

local OnPlayerSpawn = function(inst)
	print(inst:GetDisplayName().." spawned")
end	

local function onpreload(inst, data)
    if data ~= nil and data.lives ~= nil then
        inst.lives = data.lives
    end
	if data ~= nil and data.reds ~= nil then
        reds = data.reds
    end
	if data ~= nil and data.blues ~= nil then
        blues = data.blues
    end
	if data ~= nil and data.number_of_reds ~= nil then
        number_of_reds = data.number_of_reds
    end
	if data ~= nil and data.number_of_blues ~= nil then
        number_of_blues = data.number_of_blues
    end
end

local function onsave(inst, data)
    data.lives = inst.lives
	data.reds = reds
	data.blues = blues
	data.number_of_reds = number_of_reds
	data.number_of_blues =  number_of_blues
	
end

local function checkdeath(inst)
	if inst.lives == nil then
		print("LIVES e nil")
		inst.lives = GetModConfigData("lives_number")
	end
	if number_of_reds == nil then
		number_of_reds = 0
	end
	if number_of_blues == nil then
		number_of_blues = 0
	end
	inst.OnPreLoad = onpreload
	inst.OnSave = onsave
	print("check death")
	inst:ListenForEvent("death", ondeath)
	inst:ListenForEvent("playeractivated", OnPlayerActivated)
	
	if TheNet:GetIsServer() then
	print("this is server")
	inst:ListenForEvent("ms_playerjoined", OnPlayerSpawn, TheWorld)
	end
	
	end

AddPlayerPostInit(checkdeath)

	else
		print("Not enabling Team Battle because the server game mode isn't matching.")
	end
end

AddPrefabPostInit("world_network", TeamBattleSetup)


local team_battle = AddGameMode( "team_battle", "Team Battle" )
team_battle.ghost_sanity_drain = false
team_battle.spawn_mode = "scatter"
team_battle.resource_renewal = false
team_battle.ghost_enabled = true
team_battle.portal_rez = false
team_battle.reset_time = nil

