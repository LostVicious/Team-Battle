-- This information tells other players more about the mod
name = "Team Battle"
description = "Team battle"

author = "Vicious"
version = "0.5"

-- This is the URL name of the mod's thread on the forum; the part after the index.php? and before the first & in the URL
-- Example:
-- http://forums.kleientertainment.com/index.php?/files/file/202-sample-mods/
-- becomes
-- /files/file/202-sample-mods/
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

---- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"

--This lets the clients know that they need to download the mod before they can join a server that is using it.
all_clients_require_mod = true

--This lets the game know that this mod doesn't need to be listed in the server's mod listing
client_only_mod = false

--Let the mod system know that this mod is functional with Don't Starve Together
dst_compatible = true

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"team battle", "gamemode", "game mode"}


configuration_options =
{
    {
        name = "lives_number",
        label = "Number of lives",
        options = 
        {
            {description = "1 life", data = 1},
            {description = "3 lives", data = 3},
            {description = "5 lives", data = 5},
            {description = "10 lives", data = 10},
            {description = "Endless", data = -1 },
        },
        default = 1,
    }
}
