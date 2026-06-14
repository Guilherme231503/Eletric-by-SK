local p = game.Players.LocalPlayer
local g = Instance.new("ScreenGui", p.PlayerGui)
g.ResetOnSpawn = false

local f = Instance.new("Frame", g)
f.Size = UDim2.new(0, 260, 0, 320)
f.Position = UDim2.new(0, 10, 0, 100)
f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local m = Instance.new("TextButton", f)
m.Size = UDim2.new(.2, 0, 0, 20)
m.Text = "-"

local r = Instance.new("TextButton", f)
r.Size = UDim2.new(.4, 0, 0, 20)
r.Position = UDim2.new(.2, 0, 0, 0)
r.Text = "REFRESH"

-- Dropdown for selection type
local dropdown = Instance.new("TextButton", f)
dropdown.Size = UDim2.new(.4, 0, 0, 20)
dropdown.Position = UDim2.new(.6, 0, 0, 0)
dropdown.Text = "Current Tool"

local optionsFrame = Instance.new("Frame", f)
optionsFrame.Size = UDim2.new(.4, 0, 0, 80)
optionsFrame.Position = UDim2.new(.6, 0, 0, 20)
optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
optionsFrame.Visible = false

local toolOption = Instance.new("TextButton", optionsFrame)
toolOption.Size = UDim2.new(1, 0, 0, 20)
toolOption.Text = "Current Tool"
toolOption.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local inventoryOption = Instance.new("TextButton", optionsFrame)
inventoryOption.Size = UDim2.new(1, 0, 0, 20)
inventoryOption.Position = UDim2.new(0, 0, 0, 20)
inventoryOption.Text = "Inventory"
inventoryOption.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local mapOption = Instance.new("TextButton", optionsFrame)
mapOption.Size = UDim2.new(1, 0, 0, 20)
mapOption.Position = UDim2.new(0, 0, 0, 40)
mapOption.Text = "Map Items"
mapOption.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local playersOption = Instance.new("TextButton", optionsFrame)
playersOption.Size = UDim2.new(1, 0, 0, 20)
playersOption.Position = UDim2.new(0, 0, 0, 60)
playersOption.Text = "Players"
playersOption.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local selectionType = "tool" -- tool, inventory, map, players
local selectedItem = nil

-- Toggle dropdown
dropdown.MouseButton1Click:Connect(function()
    optionsFrame.Visible = not optionsFrame.Visible
end)

-- Selection options
toolOption.MouseButton1Click:Connect(function()
    selectionType = "tool"
    dropdown.Text = "Current Tool"
    optionsFrame.Visible = false
    R()
end)

inventoryOption.MouseButton1Click:Connect(function()
    selectionType = "inventory"
    dropdown.Text = "Inventory"
    optionsFrame.Visible = false
    R()
end)

mapOption.MouseButton1Click:Connect(function()
    selectionType = "map"
    dropdown.Text = "Map Items"
    optionsFrame.Visible = false
    R()
end)

playersOption.MouseButton1Click:Connect(function()
    selectionType = "players"
    dropdown.Text = "Players"
    optionsFrame.Visible = false
    R()
end)

local s = Instance.new("ScrollingFrame", f)
s.Position = UDim2.new(0, 0, 0, 20)
s.Size = UDim2.new(1, 0, 1, -20)
s.CanvasSize = UDim2.new()

local z = false
m.MouseButton1Click:Connect(function()
    z = not z
    s.Visible = not z
    f.Size = z and UDim2.new(0, 260, 0, 20) or UDim2.new(0, 260, 0, 320)
end)

local function C(t)
    pcall(function()
        setclipboard(t)
    end)
end

-- Function to inspect tools
local function inspectTool(t)
    local y = 0
    local nameBtn = Instance.new("TextButton", s)
    nameBtn.Size = UDim2.new(1, 0, 0, 20)
    nameBtn.Position = UDim2.new(0, 0, 0, y)
    nameBtn.Text = t.Name
    nameBtn.MouseButton1Click:Connect(function()
        C(t.Name)
    end)
    y = y + 22

    local cloneBtn = Instance.new("TextButton", s)
    cloneBtn.Size = UDim2.new(1, 0, 0, 20)
    cloneBtn.Position = UDim2.new(0, 0, 0, y)
    cloneBtn.Text = "CLONE TOOL"
    cloneBtn.MouseButton1Click:Connect(function()
        t:Clone().Parent = p.Backpack
    end)
    y = y + 24

    for a, v in pairs(t:GetAttributes()) do
        local label = Instance.new("TextButton", s)
        label.Size = UDim2.new(.4, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = a
        label.MouseButton1Click:Connect(function()
            C(a .. ": " .. tostring(v))
        end)

        local edit = Instance.new("TextBox", s)
        edit.Size = UDim2.new(.6, 0, 0, 20)
        edit.Position = UDim2.new(.4, 0, 0, y)
        edit.Text = tostring(v)
        edit.FocusLost:Connect(function()
            local nv = edit.Text
            if typeof(v) == "number" then
                nv = tonumber(nv) or v
            elseif typeof(v) == "boolean" then
                nv = nv == "true"
            end
            pcall(function()
                t:SetAttribute(a, nv)
            end)
        end)
        y = y + 22
    end

    for _, d in ipairs(t:GetDescendants()) do
        if d:IsA("ValueBase") then
            local label = Instance.new("TextButton", s)
            label.Size = UDim2.new(.4, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, y)
            label.Text = d.Name
            label.MouseButton1Click:Connect(function()
                C(d.Name .. ": " .. tostring(d.Value))
            end)

            local edit = Instance.new("TextBox", s)
            edit.Size = UDim2.new(.6, 0, 0, 20)
            edit.Position = UDim2.new(.4, 0, 0, y)
            edit.Text = tostring(d.Value)
            edit.FocusLost:Connect(function()
                pcall(function()
                    if d:IsA("StringValue") then
                        d.Value = edit.Text
                    elseif d:IsA("BoolValue") then
                        d.Value = edit.Text == "true"
                    else
                        d.Value = tonumber(edit.Text) or d.Value
                    end
                end)
            end)
            y = y + 22
        end
    end
    return y
end

-- Function to inspect any item (for inventory and map)
local function inspectGenericItem(item)
    local y = 0
    local nameBtn = Instance.new("TextButton", s)
    nameBtn.Size = UDim2.new(1, 0, 0, 20)
    nameBtn.Position = UDim2.new(0, 0, 0, y)
    nameBtn.Text = item.Name
    nameBtn.MouseButton1Click:Connect(function()
        C(item.Name)
    end)
    y = y + 22

    for a, v in pairs(item:GetAttributes()) do
        local label = Instance.new("TextButton", s)
        label.Size = UDim2.new(.4, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = a
        label.MouseButton1Click:Connect(function()
            C(a .. ": " .. tostring(v))
        end)

        local edit = Instance.new("TextBox", s)
        edit.Size = UDim2.new(.6, 0, 0, 20)
        edit.Position = UDim2.new(.4, 0, 0, y)
        edit.Text = tostring(v)
        edit.FocusLost:Connect(function()
            local nv = edit.Text
            if typeof(v) == "number" then
                nv = tonumber(nv) or v
            elseif typeof(v) == "boolean" then
                nv = nv == "true"
            end
            pcall(function()
                item:SetAttribute(a, nv)
            end)
        end)
        y = y + 22
    end
    return y
end

-- Function to inspect players
local function inspectPlayer(player)
    local y = 0
    local nameBtn = Instance.new("TextButton", s)
    nameBtn.Size = UDim2.new(1, 0, 0, 20)
    nameBtn.Position = UDim2.new(0, 0, 0, y)
    nameBtn.Text = player.Name
    nameBtn.MouseButton1Click:Connect(function()
        C(player.Name)
    end)
    y = y + 22

    local character = player.Character
    if character then
        local hpBtn = Instance.new("TextButton", s)
        hpBtn.Size = UDim2.new(1, 0, 0, 20)
        hpBtn.Position = UDim2.new(0, 0, 0, y)
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            hpBtn.Text = "Health: " .. tostring(humanoid.Health) .. "/" .. tostring(humanoid.MaxHealth)
            hpBtn.MouseButton1Click:Connect(function()
                C("Health: " .. humanoid.Health .. "/" .. humanoid.MaxHealth)
            end)
            y = y + 22
        end
    end

    local team = player.Team
    if team then
        local teamBtn = Instance.new("TextButton", s)
        teamBtn.Size = UDim2.new(1, 0, 0, 20)
        teamBtn.Position = UDim2.new(0, 0, 0, y)
        teamBtn.Text = "Team: " .. team.Name
        teamBtn.MouseButton1Click:Connect(function()
            C("Team: " .. team.Name)
        end)
        y = y + 22
    end
    return y
end

local function R()
    for _, v in ipairs(s:GetChildren()) do
        if v:IsA("GuiObject") then
            v:Destroy()
        end
    end

    local totalHeight = 0
    
    if selectionType == "tool" then
        local c = p.Character
        if c then
            local t = c:FindFirstChildOfClass("Tool")
            if t then
                totalHeight = inspectTool(t)
            else
                local noTool = Instance.new("TextLabel", s)
                noTool.Size = UDim2.new(1, 0, 0, 20)
                noTool.Text = "No tool equipped"
                noTool.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                totalHeight = 22
            end
        end
        
    elseif selectionType == "inventory" then
        local backpack = p.Backpack
        local tools = backpack:GetChildren()
        local y = 0
        for _, tool in ipairs(tools) do
            if tool:IsA("Tool") then
                local toolBtn = Instance.new("TextButton", s)
                toolBtn.Size = UDim2.new(1, 0, 0, 20)
                toolBtn.Position = UDim2.new(0, 0, 0, y)
                toolBtn.Text = tool.Name
                toolBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                toolBtn.MouseButton1Click:Connect(function()
                    -- Expand to show tool details
                    for _, v in ipairs(s:GetChildren()) do
                        if v:IsA("GuiObject") then
                            v:Destroy()
                        end
                    end
                    inspectTool(tool)
                    s.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
                end)
                y = y + 22
                totalHeight = y
            end
        end
        if y == 0 then
            local empty = Instance.new("TextLabel", s)
            empty.Size = UDim2.new(1, 0, 0, 20)
            empty.Text = "Inventory empty"
            empty.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            totalHeight = 22
        end
        
    elseif selectionType == "map" then
        local workspaceItems = workspace:GetDescendants()
        local y = 0
        for _, item in ipairs(workspaceItems) do
            if item:IsA("BasePart") or item:IsA("Model") then
                if not item:IsA("Terrain") and not item.Name:find("Humanoid") then
                    local itemBtn = Instance.new("TextButton", s)
                    itemBtn.Size = UDim2.new(1, 0, 0, 20)
                    itemBtn.Position = UDim2.new(0, 0, 0, y)
                    itemBtn.Text = item.Name
                    itemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    itemBtn.MouseButton1Click:Connect(function()
                        for _, v in ipairs(s:GetChildren()) do
                            if v:IsA("GuiObject") then
                                v:Destroy()
                            end
                        end
                        inspectGenericItem(item)
                        s.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
                    end)
                    y = y + 22
                    totalHeight = y
                    if y >= 200 then break end -- Limit items shown
                end
            end
        end
        if y == 0 then
            local empty = Instance.new("TextLabel", s)
            empty.Size = UDim2.new(1, 0, 0, 20)
            empty.Text = "No map items found"
            empty.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            totalHeight = 22
        end
        
    elseif selectionType == "players" then
        local players = game.Players:GetPlayers()
        local y = 0
        for _, player in ipairs(players) do
            local playerBtn = Instance.new("TextButton", s)
            playerBtn.Size = UDim2.new(1, 0, 0, 20)
            playerBtn.Position = UDim2.new(0, 0, 0, y)
            playerBtn.Text = player.Name
            playerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            playerBtn.MouseButton1Click:Connect(function()
                for _, v in ipairs(s:GetChildren()) do
                    if v:IsA("GuiObject") then
                        v:Destroy()
                    end
                end
                inspectPlayer(player)
                s.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
            end)
            y = y + 22
            totalHeight = y
        end
    end
    
    s.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

r.MouseButton1Click:Connect(R)
R()
