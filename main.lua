--// SERVICES
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BekaMrazPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

--// OPEN BUTTON
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.Position = UDim2.new(0,10,0.45,0)
OpenBtn.Text = "БМ"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 22
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(140,0,0)
OpenBtn.Draggable = true
OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)

--// MAIN WINDOW
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,270,0,380)
Main.Position = UDim2.new(0.5,-135,0.25,0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

--// HEADER
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,45)
Header.Text = "БЕКА МРАЗЬ PREMIUM"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.TextColor3 = Color3.new(1,1,1)
Header.BackgroundColor3 = Color3.fromRGB(140,0,0)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,12)

--// SCROLL
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Position = UDim2.new(0,8,0,55)
Scroll.Size = UDim2.new(1,-16,1,-65)
Scroll.CanvasSize = UDim2.new()
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

--// TOGGLE WINDOW
OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

--// UI HELPERS
local function Label(text)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0,230,0,25)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(180,180,180)
	l.Font = Enum.Font.Gotham
	l.TextSize = 13
	l.Parent = Scroll
	return l
end

local function Button(text,color,callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,230,0,36)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color or Color3.fromRGB(45,45,45)
	b.Parent = Scroll
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(callback)
	return b
end

--// TELEPORT SECTION
Label("— ТЕЛЕПОРТ К ИГРОКАМ —")

local function RefreshPlayers()
	for _,v in pairs(Scroll:GetChildren()) do
		if v.Name == "TP" then v:Destroy() end
	end

	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP then
			local btn = Button("К: "..p.DisplayName, Color3.fromRGB(60,60,60), function()
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character then
					LP.Character.HumanoidRootPart.CFrame =
						p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
				end
			end)
			btn.Name = "TP"
		end
	end
end

Button("ОБНОВИТЬ СПИСОК", Color3.fromRGB(0,120,0), RefreshPlayers)

--// CHEATS
Label("— ЧИТЫ —")

-- SPEED
Button("SPEED 100", nil, function()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = 100 end
end)

-- NOCLIP
local noclip = false
local ncConn

Button("NOCLIP", nil, function()
	noclip = not noclip
	if noclip then
		ncConn = RS.Stepped:Connect(function()
			if LP.Character then
				for _,p in pairs(LP.Character:GetDescendants()) do
					if p:IsA("BasePart") then
						p.CanCollide = false
					end
				end
			end
		end)
	else
		if ncConn then ncConn:Disconnect() ncConn = nil end
	end
end)

-- ESP
Button("ESP", nil, function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and not p.Character:FindFirstChild("ESP") then
			local h = Instance.new("Highlight")
			h.Name = "ESP"
			h.FillColor = Color3.fromRGB(255,0,0)
			h.OutlineColor = Color3.fromRGB(255,255,255)
			h.Parent = p.Character
		end
	end
end)

-- DELETE GUI
Button("УДАЛИТЬ МЕНЮ", Color3.fromRGB(140,0,0), function()
	ScreenGui:Destroy()
end)

-- INIT
RefreshPlayers()
