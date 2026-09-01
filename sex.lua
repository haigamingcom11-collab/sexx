-- [[ ALB HUB - DOGGY SEX V3 👽 ]]
-- Optimized for Delta X & Mobile Controls

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local TargetPlayer = nil
local DoggyActive = false
local Connection = nil
local OriginalRootC0 = nil
local ThrustSpeed = 25 -- Tốc độ nhấp mặc định (Hỗ trợ Max tốc độ)

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "ALB HUB | Doggy Sex V3 👽",
    LoadingTitle = "ALB HUB Loading...",
    LoadingSubtitle = "by Rayfield & Neon Theme",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Base Theme Styling (Black & Purple Neon Visuals)
local UIContainer = game:GetService("CoreGui"):FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")

-- Automatic Animated Neon Purple LED Effect
task.spawn(function()
    local hue = 0.75 -- Base purple hue
    while task.wait(0.05) do
        hue = 0.73 + (math.sin(tick() * 4) * 0.05)
        local neonColor = Color3.fromHSV(hue, 1, 1)
        
        -- Custom LED Border Pulse effect for Rayfield Frame if exists
        pcall(function()
            if UIContainer then
                for _, v in pairs(UIContainer:GetDescendants()) do
                    if v:IsA("UIStroke") then
                        v.Color = neonColor
                    end
                end
            end
        end)
    end
end)

---------------------------------------------------------
-- TAB 1: MAIN DOGGY SYSTEM
---------------------------------------------------------
local Tab1 = Window:CreateTab("Doggy Main 👽", 4483362458)

-- Target Selector Dropdown Logic
local PlayerList = {}
local function UpdatePlayerList()
    PlayerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(PlayerList, p.Name)
        end
    end
    return PlayerList
end

local Dropdown = Tab1:CreateDropdown({
    Name = "Select Target Player",
    Options = UpdatePlayerList(),
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Option)
        TargetPlayer = Players:FindFirstChild(Option[1])
    end,
})

-- Nút Loading/Làm mới lại danh sách người chơi
Tab1:CreateButton({
    Name = "🔄 Reload Player List",
    Callback = function()
        Dropdown:Refresh(UpdatePlayerList())
        Rayfield:Notify({Title = "Player List", Content = "Refreshed player list successfully!", Duration = 2})
    end,
})

-- Auto refresh player list when players join/leave
Players.PlayerAdded:Connect(function() Dropdown:Refresh(UpdatePlayerList()) end)
Players.PlayerRemoving:Connect(function() Dropdown:Refresh(UpdatePlayerList()) end)

-- Thanh kéo chỉnh tốc độ nhấp (Hỗ trợ kéo tới Max)
Tab1:CreateSlider({
    Name = "Thrust Speed (Tốc độ nhấp Max)",
    Range = {1, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 25,
    Flag = "ThrustSpeedSlider",
    Callback = function(Value)
        ThrustSpeed = Value
    end,
})

-- Main Doggy Toggle & Logic Loop
local Toggle = Tab1:CreateToggle({
    Name = "Enable Doggy Loop (Auto Teleport & Motion)",
    CurrentValue = false,
    Flag = "DoggyToggle",
    Callback = function(Value)
        DoggyActive = Value
        
        local Char = LocalPlayer.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        local Root = Char.HumanoidRootPart
        local Waist = Char:FindFirstChild("Waist", true) or Char:FindFirstChild("RootJoint", true)

        if DoggyActive then
            if not TargetPlayer or not TargetPlayer.Character or not TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Rayfield:Notify({Title = "Error", Content = "Please select a valid player first!", Duration = 3})
                return
            end

            -- Save original joint CFrame for reset
            if Waist and not OriginalRootC0 then
                OriginalRootC0 = Waist.C0
            end

            local TargetRoot = TargetPlayer.Character.HumanoidRootPart
            local timer = 0

            -- Main Loop (Step Motion & Offset Attachment)
            Connection = RunService.RenderStepped:Connect(function(delta)
                if not DoggyActive or not TargetPlayer.Character or not TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if Connection then Connection:Disconnect() end
                    return
                end

                timer = timer + (delta * ThrustSpeed)
                local thrustOffset = math.sin(timer) * 0.75 -- Forward/Backward motion amplitude

                -- Position behind target, attaching close to abdomen/back
                local targetCFrame = TargetRoot.CFrame * CFrame.new(0, -0.2, 1.1 + thrustOffset)
                Root.CFrame = targetCFrame

                -- Tilt Lower Body 45 degrees forward
                if Waist then
                    Waist.C0 = OriginalRootC0 * CFrame.Angles(math.rad(45), 0, 0)
                end
            end)
        else
            -- Cleanup on Disable
            if Connection then 
                Connection:Disconnect() 
                Connection = nil
            end
            if Waist and OriginalRootC0 then
                Waist.C0 = OriginalRootC0
                OriginalRootC0 = nil
            end
        end
    end,
})

---------------------------------------------------------
-- TAB 2: EXTRA SCRIPTS & LOADS
---------------------------------------------------------
local Tab2 = Window:CreateTab("Scripts Hub 📜", 4483362458)

Tab2:CreateButton({
    Name = "Load External Script",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
        end)
        Rayfield:Notify({Title = "Script Executed", Content = "Loaded script successfully!", Duration = 3})
    end,
})

---------------------------------------------------------
-- MOBILE OPTIMIZATION & GUI MINIMIZER CONTROL
---------------------------------------------------------
-- Anti-Reset Gui logic (Keep UI active after death)
if UIContainer then
    for _, gui in pairs(UIContainer:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui.ResetOnSpawn = false
        end
    end
end

-- Floating Toggle Button for Mobile Screen Corner (Allows minimizing to corner)
local ScreenGui = Instance.new("ScreenGui")
local CornerBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "ALB_MobileToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

CornerBtn.Name = "ToggleIcon"
CornerBtn.Parent = ScreenGui
CornerBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
CornerBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
CornerBtn.Size = UDim2.new(0, 45, 0, 45)
CornerBtn.Font = Enum.Font.SourceSansBold
CornerBtn.Text = "👽"
CornerBtn.TextColor3 = Color3.fromRGB(180, 0, 255)
CornerBtn.TextSize = 24
CornerBtn.Active = true
CornerBtn.Draggable = true -- Mobile dragging support

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = CornerBtn

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(180, 0, 255)
UIStroke.Parent = CornerBtn

-- Toggle GUI Visibility via Floating Corner Button
local guiVisible = true
CornerBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    if UIContainer then
        for _, v in pairs(UIContainer:GetChildren()) do
            if v:IsA("Frame") or v:IsA("ScreenGui") then
                v.Enabled = guiVisible
            end
        end
    end
end)
