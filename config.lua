--[[ DON'T EDIT THIS // NE PAS MODIFIER ]]--
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
--[[ DON'T EDIT THIS // NE PAS MODIFIER ]]--

Config                          = {}
Config.lang                     = 'en' --[[ YOU CAN CHOOSE YOUR LANGUAGE BETWEEN fr AND en // VOUS POUVEZ CHOISIR VOTRE LANGUE ENTRE fr ET en ]]--
Language                        = Locales[Config.lang]                    
Config.notificationTexture      = "CHAR_MANUEL"
Config.notificationIconType     = 1
Config.DrawDistance             = 25.0          --[[ MARKER DRAW DISTANCE // DISTANCE D'AFFICHAGE DES MARKER ]]--

Config.keys                     = {
    ["interact"]                = Keys["E"],       -- Key for interact
}
Config.Markets                  = {
    {
        blipEnabled     = true,         -- IF YOU WANT A BLIP IN YOUR MAP
        blip            = {
            Pos     = { x = 81.776, y = -1615.182, z = 28.591 },
            Sprite  = 59,
            Display = 4,
            Scale   = 1.0,
            Colour  = 1,
            label   = Language["blipName_market"],
        },
        OpeningTime     = {
            enabled = true,
            OpenHours = 7,
            CloseHours = 19,
        },
        items           = {
            {
                item    = "meat",
                label   = "Meat",
                price   = 3,
            },
        },
        location        = {
            position = {
                { x = 81.776, y = -1615.182, z = 28.601}, --[[ ADD THIS IF YOU WANT ANOTHER MARKET ]]
            },
            Size    = { x = 2.5, y = 2.5, z = 1.0 },
            Color   = { r = 231, g = 76, b = 60 },
            Type    = 27,
        },
    },
}