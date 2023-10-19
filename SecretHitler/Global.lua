--Defining GUIDs
setupButton_GUID = "033a80"

palpatineRole_GUID = "ba07c3"
seperatistsRole_GUID = "dc7b36"
loyalistsRole_GUID = "32d4dc"
seperatistMembership_GUID = "55638a"
loyalistMembership_GUID = "43e798"
seperatistPolicy_GUID = "dd6596"
loyalistPolicy_GUID = "385734"
voteYes_GUID = "1a6a4a"
voteNo_GUID = "06cad6"
confirmedNotPalpatine_GUID = "90b6be"
token_GUID = "7603d0"
vice_GUID = "fdd748"
vicePrev_GUID = "b7f6b3"
chancellor_GUID = "6e6604"
chancellorPrev_GUID = "c56b63"
death1_GUID = "e5b494"
death2_GUID = "0c49a4"
death3_GUID = "8f85c8"
death4_GUID = "e994b6"
death5_GUID = "b3bc95"
loyalistBoard_GUID = "228efa"
seperatistBoard56_GUID = "cd67ea"
seperatistBoard78_GUID = "a0d5a0"
seperatistBoard910_GUID = "d82ef9"
dice_GUID = "bd3606"

drawPile_GUID = "dce854"
discardPile_GUID = "852ae3"

handCardScale = {2, 1, 2}
policyCardScale = {1.5, 1, 1.5}
tokenScale = {0.25, 1, 0.25}

loyalistBoardPosition = {0, 1, -6}
seperatistBoardPosition = {0, 1, 6}

boardRotation = {0, 180, 0}

offScreenPosition = {0, 500, 500}

loyalistPolicyCount = 6
seperatistPolicyCount = 11

function onSave()
    savedData = JSON.encode({resetState=resetState})
    return savedData
end

function onLoad(savedData)
    -- Load save states
    if savedData ~= "" then
        local loadedData = JSON.decode(savedData)
        resetState = loadedData.resetState
    else
        resetState = true
    end

    -- Getting Objects from GUID
    setupButton = getObjectFromGUID(setupButton_GUID)
    setupButton.setScale({1, 0.1, 1})

    palpatineRole = getObjectFromGUID(palpatineRole_GUID)
    palpatineRole.setScale(handCardScale)

    seperatistsRole = getObjectFromGUID(seperatistsRole_GUID)
    loyalistsRole = getObjectFromGUID(loyalistsRole_GUID)

    seperatistsRole.setScale(handCardScale)
    loyalistsRole.setScale(handCardScale)

    seperatistMembership = getObjectFromGUID(seperatistMembership_GUID)
    loyalistMembership = getObjectFromGUID(loyalistMembership_GUID)

    seperatistMembership.setScale(handCardScale)
    loyalistMembership.setScale(handCardScale)

    seperatistPolicy = getObjectFromGUID(seperatistPolicy_GUID)
    loyalistPolicy = getObjectFromGUID(loyalistPolicy_GUID)

    seperatistPolicy.setScale(policyCardScale)
    loyalistPolicy.setScale(policyCardScale)

    voteYes = getObjectFromGUID(voteYes_GUID)
    voteNo = getObjectFromGUID(voteNo_GUID)

    voteYes.setScale(handCardScale)
    voteNo.setScale(handCardScale)

    confirmedNotPalpatine = getObjectFromGUID(confirmedNotPalpatine_GUID)
    confirmedNotPalpatine.setScale(handCardScale)

    token = getObjectFromGUID(token_GUID)
    token.setScale(tokenScale)
    vice = getObjectFromGUID(vice_GUID)
    vicePrev = getObjectFromGUID(vicePrev_GUID)
    chancellor = getObjectFromGUID(chancellor_GUID)
    chancellorPrev = getObjectFromGUID(chancellorPrev_GUID)
    death1 = getObjectFromGUID(death1_GUID)
    death2 = getObjectFromGUID(death2_GUID)
    death3 = getObjectFromGUID(death3_GUID)
    death4 = getObjectFromGUID(death4_GUID)
    death5 = getObjectFromGUID(death5_GUID)

    drawPile = getObjectFromGUID(drawPile_GUID)
    discardPile = getObjectFromGUID(discardPile_GUID)

    loyalistBoard = getObjectFromGUID(loyalistBoard_GUID)

    seperatistBoard56 = getObjectFromGUID(seperatistBoard56_GUID)
    seperatistBoard78 = getObjectFromGUID(seperatistBoard78_GUID)
    seperatistBoard910 = getObjectFromGUID(seperatistBoard910_GUID)

    dice = getObjectFromGUID(dice_GUID)

    seperatistBoardObjects = {
        seperatistBoard56,
        seperatistBoard78,
        seperatistBoard910
    }

    otherResetObjects = {
        palpatineRole,
        seperatistsRole,
        loyalistsRole,
        seperatistMembership,
        loyalistMembership,
        seperatistPolicy,
        loyalistPolicy,
        voteYes,
        voteNo,
        confirmedNotPalpatine,
        loyalistBoard,
        token,
        vice,
        vicePrev,
        chancellor,
        chancellorPrev,
        death1,
        death2,
        death3,
        death4,
        death5,
        drawPile,
        discardPile,
        dice
    }

    if resetState then
        reset()
    end
end

function reset()
    resetState = true
    for _, object in ipairs(getAllObjects()) do
        if object.hasTag("cloned") then
            object.destruct()
        end
    end
    for _, object in pairs(seperatistBoardObjects) do
        object.setLock(true)
        object.setPosition(offScreenPosition)
        object.setInvisibleTo(Player.getColors())
        object.setRotation(boardRotation)
    end
    for _, object in pairs(otherResetObjects) do
        object.setLock(true)
        object.setPosition(offScreenPosition)
        object.setInvisibleTo(Player.getColors())
    end
    loyalistBoard.setRotation(boardRotation)

    -- Create setup button
    setupButton.setPosition({0, 1, 0})
    setupButton.setInvisibleTo({})
    setupButton.setLock(true)
    setupButton.createButton({
        click_function = "setupClick",
        function_owner = nil,
        label          = "Setup",
        position       = {0,1,0},
        rotation       = {0,180,0},
        width          = 10000,
        height         = 10000,
        font_size      = 1000,
        tooltip        = "Setup the Game",
        color          = {0,0.67,0.5}
    })
end

function resetClick(player, _, idValuer)
    if permissionCheck(player.color) then
        reset()
    end
end

function setupClick(object, color)
    if not permissionCheck(color) then
        return
    end
    resetState = false
    -- Construct player / color information
    currentPlayers = Player.getPlayers()
    currentColors = {}
    playersIndexed = {}
    for _, player in pairs(currentPlayers) do
        table.insert(currentColors, player.color)
        playersIndexed[player.color] = player
    end

    -- TEMP OVERRIDE FOR TESTING
    -- tempHands = {
    --     "White",
    --     "Brown",
    --     "Red",
    --     "Orange",
    --     "Yellow",
    --     "Green"
    -- }
    -- currentColors = tempHands
    -- playersIndexed = {}
    -- for _, color in pairs(currentColors) do
    --     playersIndexed[color] = currentPlayers[1]
    -- end
    -- print("--- TEST MODE ---")

    -- Initiating variables
    local playerCount = tableLength(currentColors)

    -- Move boards into place
    if playerCount < 5 then
        print("Cannot start game, needs 5 or more players")
        reset()
        return
    elseif playerCount <= 6 then
        seperatistBoard56.setInvisibleTo({})
        seperatistBoard56.setPosition(seperatistBoardPosition)
        seperatistCount = 1
    elseif playerCount <= 8 then
        seperatistBoard78.setInvisibleTo({})
        seperatistBoard78.setPosition(seperatistBoardPosition)
        seperatistCount = 2
    else
        seperatistBoard910.setInvisibleTo({})
        seperatistBoard910.setPosition(seperatistBoardPosition)
        seperatistCount = 3
    end
    loyalistBoard.setInvisibleTo({})
    loyalistBoard.setPosition(loyalistBoardPosition)

    -- Move setup button
    setupButton.setLock(true)
    setupButton.setPosition(offScreenPosition)
    setupButton.setInvisibleTo(Player.getColors())
    setupButton.clearButtons()

    -- Cloned objects
    local clonedPalpatine = cloneWithTags(palpatineRole, { "seperatist", "palpatine" })
    local clonedSeperatistsRole = cloneWithTags(seperatistsRole, { "seperatist" })
    local clonedLoyalistsRole = cloneWithTags(loyalistsRole, { "loyalist" })
    local clonedSeperatistMembership = cloneWithTags(seperatistMembership, { "seperatist" })
    local clonedLoyalistMembership = cloneWithTags(loyalistMembership, { "loyalist" })
    local clonedLoyalistPolicy = cloneWithTags(loyalistPolicy)
    local clonedVoteYes = cloneWithTags(voteYes)
    local clonedVoteNo = cloneWithTags(voteNo)
    local clonedDrawPile = cloneWithTags(drawPile)
    local clonedDiscardPile = cloneWithTags(discardPile)
    local clonedConfirmedNotPalpatine = cloneWithTags(confirmedNotPalpatine)

    -- Prepare roles for distribution
    clonedSeperatistsRole.shuffle()
    local clonedRoles = clonedPalpatine
    clonedRoles.setLock(false)
    for i = 1, seperatistCount do
        local object = clonedSeperatistsRole.takeObject()
        object.addTag("cloned")
        object.addTag("seperatist")
        local temp = clonedRoles.putObject(object)
        if temp ~= nil then
            clonedRoles = temp
        end
    end

    clonedLoyalistsRole.shuffle()
    loyalistCount = (playerCount - seperatistCount) - 1
    for i = 1, loyalistCount do
        local object = clonedLoyalistsRole.takeObject()
        object.addTag("cloned")
        object.addTag("loyalist")
        local temp = clonedRoles.putObject(object)
        if temp ~= nil then
            clonedRoles = temp
        end
    end

    clonedRoles.setInvisibleTo({})
    clonedRoles.shuffle()

    -- Distribute roles and other cards
    local drawCount = 0
    local seperatistPlayers = {}
    local palpatinePlayer = ""
    for _, color in pairs(currentColors) do
        drawCount = drawCount + 1
        local dealingCard = clonedRoles.takeObject()
        local tempCard = {}
        if dealingCard.hasTag("seperatist") then
            tempCard = clonedSeperatistMembership.clone({
                position = offScreenPosition
            })
            if not dealingCard.hasTag("palpatine") then
                table.insert(seperatistPlayers, color)
            end
        else
            tempCard = clonedLoyalistMembership.clone({
                position = offScreenPosition
            })
        end
        if dealingCard.hasTag("palpatine") then
            palpatinePlayer = color
        end
        tempCard.setLock(false)
        tempCard.setInvisibleTo({})
        tempCard.deal(1, color)

        local yesCard = clonedVoteYes.clone({
            position = offScreenPosition
        })
        yesCard.setLock(false)
        yesCard.setInvisibleTo({})
        yesCard.deal(1, color)
        local noCard = clonedVoteNo.clone({
            position = offScreenPosition
        })
        noCard.setLock(false)
        noCard.setInvisibleTo({})
        noCard.deal(1, color)
        dealingCard.deal(1, color)
    end

    local clonedConfirmed = clonedConfirmedNotPalpatine
    clonedConfirmed.setLock(false)
    for i = 1, playerCount - 2 do
        local object = cloneWithTags(confirmedNotPalpatine)
        object.setLock(false)
        object.flip()
        local temp = clonedConfirmed.putObject(object)
        if temp ~= nil then
            clonedConfirmed = temp
        end
    end

    clonedConfirmed.setPosition({-24, 2, -6})
    clonedConfirmed.setInvisibleTo({})

    -- Setup draw and discard piles
    clonedDrawPile.setLock(true)
    clonedDrawPile.setPosition({-17, 1, -6})
    clonedDrawPile.setInvisibleTo({})
    clonedDrawPile.flip()

    clonedDiscardPile.setLock(true)
    clonedDiscardPile.setPosition({17, 1, -6})
    clonedDiscardPile.setInvisibleTo({})
    clonedDiscardPile.flip()

    -- Setup policy cards
    local clonedPolicies = clonedLoyalistPolicy
    clonedPolicies.setLock(false)
    for i = 1, loyalistPolicyCount - 1 do
        local object = cloneWithTags(loyalistPolicy)
        object.setLock(false)
        object.flip()
        local temp = clonedPolicies.putObject(object)
        if temp ~= nil then
            clonedPolicies = temp
        end
    end

    for i = 1, seperatistPolicyCount do
        local object = cloneWithTags(seperatistPolicy)
        object.setLock(false)
        local temp = clonedPolicies.putObject(object)
        if temp ~= nil then
            clonedPolicies = temp
        end
    end

    clonedPolicies.shuffle()
    clonedPolicies.setPosition({-17, 2, -6})
    clonedPolicies.setInvisibleTo({})
    clonedPolicies.flip()

    -- Move tokens to their correct locations
    local clonedToken = cloneWithTags(token)
    clonedToken.setPosition(loyalistBoard.getPosition() - loyalistBoard.getSnapPoints()[6].position)
    clonedToken.setRotation({0, -90, 0})
    clonedToken.setInvisibleTo({})
    clonedToken.setLock(false)

    math.randomseed(os.time())
    math.random(); math.random(); math.random()

    local randomChoice = math.random(1, playerCount)
    local currentCount = 1
    local randomColor = ""
    for _, value in pairs(currentColors) do
        if currentCount >= randomChoice then
            randomColor = value
            break
        end
        currentCount = currentCount + 1
    end
    local randomCount = 1
    for _, value in pairs(hands) do
        if value == randomColor then
            break
        end
        randomCount = randomCount + 1
    end
    local clonedVice = cloneWithTags(vice)
    clonedVice.setRotation(Global.getSnapPoints()[randomCount].rotation)
    clonedVice.setPosition(Global.getSnapPoints()[randomCount].position)
    clonedVice.setInvisibleTo({})
    clonedVice.setLock(false)
    local clonedVicePrev = cloneWithTags(vicePrev)
    clonedVicePrev.setRotation(Global.getSnapPoints()[4].rotation)
    clonedVicePrev.setPosition({ -22, 1, 6 })
    clonedVicePrev.setInvisibleTo({})
    clonedVicePrev.setLock(false)
    local clonedChancellor = cloneWithTags(chancellor)
    clonedChancellor.setRotation(Global.getSnapPoints()[4].rotation)
    clonedChancellor.setPosition({ -17, 1, 6 })
    clonedChancellor.setInvisibleTo({})
    clonedChancellor.setLock(false)
    local clonedChancellorPrev = cloneWithTags(chancellorPrev)
    clonedChancellorPrev.setRotation(Global.getSnapPoints()[4].rotation)
    clonedChancellorPrev.setPosition({ -27, 1, 6 })
    clonedChancellorPrev.setInvisibleTo({})
    clonedChancellorPrev.setLock(false)
    local clonedDeath1 = cloneWithTags(death1)
    clonedDeath1.setRotation(Global.getSnapPoints()[9].rotation)
    clonedDeath1.setPosition({ 17, 1, 4 })
    clonedDeath1.setInvisibleTo({})
    clonedDeath1.setLock(false)
    local clonedDeath2 = cloneWithTags(death2)
    clonedDeath2.setRotation(Global.getSnapPoints()[9].rotation)
    clonedDeath2.setPosition({ 17, 1, 8 })
    clonedDeath2.setInvisibleTo({})
    clonedDeath2.setLock(false)
    local clonedDeath3 = cloneWithTags(death3)
    clonedDeath3.setRotation(Global.getSnapPoints()[9].rotation)
    clonedDeath3.setPosition({ 21, 1, 2 })
    clonedDeath3.setInvisibleTo({})
    clonedDeath3.setLock(false)
    local clonedDeath4 = cloneWithTags(death4)
    clonedDeath4.setRotation(Global.getSnapPoints()[9].rotation)
    clonedDeath4.setPosition({ 21, 1, 6 })
    clonedDeath4.setInvisibleTo({})
    clonedDeath4.setLock(false)
    local clonedDeath5 = cloneWithTags(death5)
    clonedDeath5.setRotation(Global.getSnapPoints()[9].rotation)
    clonedDeath5.setPosition({ 21, 1, 10 })
    clonedDeath5.setInvisibleTo({})
    clonedDeath5.setLock(false)

    -- Send messages to seperatists
    local teamNamesString = ""
    local seperator = ""
    for _, color in pairs(seperatistPlayers) do
        teamNamesString = teamNamesString .. seperator .. color .. " (" .. playersIndexed[color].steam_name .. ")"
        seperator = ", "
    end
    for _, color in pairs(seperatistPlayers) do
        playersIndexed[color].print("Palpatine is " .. palpatinePlayer .. " (" .. playersIndexed[palpatinePlayer].steam_name .. "). Protect them from the loyalists!")
        playersIndexed[color].print("Your fellow seperatists are " .. teamNamesString .. ". Make sure to work together!")
    end
    if playerCount <= 6 then
        -- Also send message to palpatine
        playersIndexed[palpatinePlayer].print("Your fellow seperatists are " .. teamNamesString .. ". Make sure to work together!")
    end
end

function wait(time)
    local start = os.time()
    repeat coroutine.yield(0) until os.time() > start + time
end

function tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function permissionCheck(color)
    if Player[color].host==true or Player[color].promoted==true then
        return true
    else
        return false
    end
end

function cloneWithTags(object, extraTags)
    local cloned = object.clone({
        position = offScreenPosition
    })
    cloned.addTag('cloned')
    if extraTags ~= nil then
        for _, tag in ipairs(extraTags) do
            cloned.addTag(tag)
        end
    end
    return cloned
end

hands = {
    "White",
    "Brown",
    "Red",
    "Orange",
    "Yellow",
    "Green",
    "Teal",
    "Blue",
    "Purple",
    "Pink"
}