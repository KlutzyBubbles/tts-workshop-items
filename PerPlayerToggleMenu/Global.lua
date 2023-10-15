--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    setupUiPanels()
    refreshUiPanels()
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate ()
    --[[ print('onUpdate loop!') --]]
end

uiPanels = {
    buttonsLayout = {
        visibility = {
            White = true,
            Brown = true,
            Red = true,
            Orange = true,
            Yellow = true,
            Green = true,
            Teal = true,
            Blue = true,
            Purple = true,
            Pink = true,
            Grey = false,
            Black = false
        },
        disabled = {
            black = true,
            grey = true
        },
        panel = "buttonsGrid"
    }
}

function setupUiPanels()
    for buttonName, v in pairs(uiPanels) do
        self.UI.setAttribute(buttonName, "onClick", "clickUiButton")
        setVisibility(uiPanels[buttonName].visibility, buttonName)
    end
end

function clickUiButton(player, mouseButton, id)
    if tostring(mouseButton) == "-1" or tostring(mouseButton) == "1" then -- Only run when left click is used or single click
        if type(uiPanels[id]) == "table" then
            if uiPanels[id].disabled[player.color] == true then
                uiPanels[id].visibility[player.color] = false
            else
                uiPanels[id].visibility[player.color] = not uiPanels[id].visibility[player.color]
            end
            setVisibility(uiPanels[id].visibility, uiPanels[id].panel)
        end
    end
end

function setVisibility(colors, panel)
    attribute = ""
    prefix = ""
    for color, visible in pairs(colors) do
        if visible then
            attribute = attribute .. prefix .. color
            prefix = "|"
        end
    end
    self.UI.setAttribute(panel, "visibility", attribute)
end

function refreshUiPanels()
    for index, color in pairs(getDifference(Player.getAvailableColors(), getPlayerColors())) do
        -- This loops through all colors that dont have anyone seated
        for buttonName, v in pairs(uiPanels) do
            if uiPanels[buttonName].disabled[color] ~= true then
                uiPanels[buttonName].visibility[color] = true
            end
            self.UI.setAttribute(buttonName, "onClick", "clickUiButton")
            setVisibility(uiPanels[buttonName].visibility, buttonName)
        end
    end
    for buttonName, v in pairs(uiPanels) do
        setVisibility(uiPanels[buttonName].visibility, uiPanels[buttonName].panel)
    end
end

function getPlayerColors()
    colors = {}
    for key, value in pairs(Player.getPlayers()) do
        table.insert(colors, value.color)
    end
    return colors
end

function getDifference(bigTable, smallTable)
    outputTable = {}
    for key, value in pairs(bigTable) do
        local smallTableContains = false
        for subKey, subValue in pairs(smallTable) do
            if value == subValue then
                smallTableContains = true
            end
        end
        if not smallTableContains then
            outputTable[key] = value
        end
    end
    return outputTable
end

function onPlayerChangeColor()
    refreshUiPanels()
end

function clickButton(player, mouseButton, id)
    print(player.color)
    print(mouseButton)
    print(id)
end
