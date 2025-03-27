local function getValidNum(prompt)
    local userInput = ""
    local outputNum = -1

    while outputNum <= -1 do
        userInput = vim.fn.input(prompt)

        -- Allow the user to quit early
        if userInput == "q" then
            vim.cmd("normal! :clear")
            return -1
        end

        local inputAsNum = tonumber(userInput)

        if inputAsNum ~= nil then
            outputNum = inputAsNum
        end
    end

    return outputNum
end

local function generateClamp()
    local minValue = getValidNum("Min Value (REM): ")
    if minValue == -1 then return end

    local maxValue = getValidNum("Max Value (REM): ")
    if maxValue == -1 then return end

    local minViewportWidth = getValidNum("Min Viewport Width (PX): ")
    if minViewportWidth == -1 then return end

    local maxViewportWidth = getValidNum("Max Viewport Width (PX): ")
    if maxViewportWidth == -1 then return end

    -- Convert from PX to REM; probably could make this configurable
    minViewportWidth = minViewportWidth / 16
    maxViewportWidth = maxViewportWidth / 16

    -- This formula yields the rate at which the size should increase or
    -- decrease as the viewport width changes
    local slope = (maxValue-minValue) / (maxViewportWidth-minViewportWidth)

    -- The y-axis intersection (B) indicates where the line representing our
    -- scaling factor intersects the y-axis
    local yIntercept = -minViewportWidth*slope + minValue

    local withRem = function(value)
        return tostring(value) .. "rem"
    end

    local slopeAsViewWidth = slope * 100

    local clamp_string_output = (
        "clamp(" .. withRem(minValue) .. ", " .. withRem(yIntercept) .. " + "
        .. slopeAsViewWidth .. "vw" .. ", " .. withRem(maxValue) .. ")"
    )

    vim.api.nvim_put({ clamp_string_output }, "c", true, true)
end


return {
    generateClamp = generateClamp
}

