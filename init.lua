local config = simply_lib.loadConfig("simply_tips") or {}
local tips_file = minetest.get_worldpath() .. "/simply_mods/simply_tips_tips.txt"
local S = core.get_translator("simply_lib")

local tips = {}
local f = io.open(tips_file, "r")
if f then
    for line in f:lines() do
        line = line:trim()
        if line ~= "" then
            table.insert(tips, line)
        end
    end
    f:close()
else
    minetest.log("warning", "[simply_tips] No tips.txt found at " .. tips_file)
end

local function get_random_tip()
    if #tips == 0 then
        return S("No tips available.")
    end
    return tips[math.random(#tips)]
end

if next(config) == nil then
	-- file does not exist, so create it
	-- more convinient for users lol
	simply_lib.saveConfig("simply_tips", {})
end

if config.enableTips == false then
	print("[Simply tips] Tips are disabled!")
end

local function showTipGui(playerName)
    local random_tip = get_random_tip()
    local tips_formspec = table.concat({
        "formspec_version[6]",
        "size[10,7]",
        "hypertext[2,3;6,1;title;<b>Tip of the day!</b>]",
        "label[2,4;" .. minetest.formspec_escape(random_tip) .. "]",
        "button_exit[2,5;2,1;exit;Ok]"
    })
end

minetest.register_chatcommand("tips", {
    description = "Show the tip of the day",
    func = function(name, param)
        if not name then
            return false, "Could not get your player name."
        end
        core.show_formspec(name, "simply_tips:tips_formspec", tips_formspec)
        return true, S("Selecting random tip...")
    end,
})

local tipsEnabled = true

if tipsEnabled == true then
	-- show tips
	minetest.register_on_joinplayer(function(player)
    local pname = (type(player) == "string") and player or (player.get_player_name and player:get_player_name())
    if not pname then return end
        showTipGui(pname)
    end)

end