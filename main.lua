-- BekaMrazPremium | Optimized Main
-- Mobile friendly | Single RenderStepped | Safe values

-- SERVICES
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- STATE
local State = {
	InfJump = false,
	ESP = false,
	Aimbot = false,
}

-- GUI =========================
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "BekaMrazPremium"
Gui.ResetOnSpawn = false

local Open = Instance.new("TextButton", Gui)
Open.Size = UDim2.new(0,50,0,50)
Open.Position = UDim2.new(0,10,0.45,0)
Open.Text = "БМ"
Open.Font = Enum.Font.GothamBold
Open.TextSize = 20
Open.TextColor3 = Color3.new(1,1,1)
Open.BackgroundColor3 = Color3.fromRGB(140,0,0)
Open.Active, Open.Draggable = true, true
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,270,0,360)
Main.Position = UDim2.new(0.5,-135,0.25,0)
Main.Visible = false
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,42)
Header.Text = "BEKA MRAZ PREMIUM"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16
Header.TextColor3 = Color3.new(1,1,1)
Header.BackgroundColor3 = Color3.fromRGB(140,0,0)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,12)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Position = UDim2.new(0,8,0,50)
Scroll.Size = UDim2.new(1,-16,1,-58)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 8)
end)

Open.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

local function Button(text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,230,0,36)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.Parent = Scroll
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(callback)
	return b
end

-- INFINITE JUMP =================
UIS.JumpRequest:Connect(function()
	if State.InfJump then
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

Button("INFINITE JUMP", function()
	State.InfJump = not State.InfJump
end)

-- ESP + HP BAR ==================
local function addESP(plr)
	if not plr.Character or plr.Character:FindFirstChild("ESP") then return end
	local char = plr.Character
	local hum = char:FindFirstChildOfClass("Humanoid")
	local head = char:FindFirstChild("Head")
	if not hum or not head then return end

	local hl = Instance.new("Highlight")
	hl.Name = "ESP"
	hl.FillColor = Color3.fromRGB(255,0,0)
	hl.OutlineColor = Color3.fromRGB(255,255,255)
	hl.Parent = char

	local bb = Instance.new("BillboardGui", head)
	bb.Name = "HPBAR"
	bb.Size = UDim2.new(4,0,0.4,0)
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true

	local bg = Instance.new("Frame", bb)
	bg.Size = UDim2.new(1,0,1,0)
	bg.BackgroundColor3 = Color3.fromRGB(40,40,40)

	local bar = Instance.new("Frame", bg)
	bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
	bar.Size = UDim2.new(1,0,1,0)

	hum.HealthChanged:Connect(function()
		bar.Size = UDim2.new(math.clamp(hum.Health/hum.MaxHealth,0,1),0,1,0)
	end)
end

Button("ESP + HP BAR", function()
	State.ESP = not State.ESP
	if State.ESP then
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LP then addESP(p) end
		end
	end
end)

-- AIMBOT (SOFT) =================
local AIM_FOV = 140
local AIM_SMOOTH = 0.08

local function getTarget()
	local closest, dist = nil, AIM_FOV
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
			local pos, on = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if on then
				local m = (Vector2.new(pos.X,pos.Y)
					- Camera.ViewportSize/2).Magnitude
				if m < dist then
					dist = m
					closest = p.Character.Head
				end
			end
		end
	end
	return closest
end

Button("AIMBOT (SOFT)", function()
	State.Aimbot = not State.Aimbot
end)

-- HP BOOST ======================
Button("HP x2 (SELF)", function()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.MaxHealth = hum.MaxHealth * 2
		hum.Health = hum.MaxHealth
	end
end)

-- RENDER LOOP (ONE) ==============
RS.RenderStepped:Connect(function()
	if State.Aimbot then
		local t = getTarget()
		if t then
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position, t.Position),
				AIM_SMOOTH
			)
		end
	end
end)

-- CLEANUP =======================
LP.CharacterAdded:Connect(function()
	task.wait(1)
	if State.ESP then
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LP then addESP(p) end
		end
	end
end)

Button("DELETE MENU", function()
	Gui:Destroy()
end) LP.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").Died:Connect(function()
		noclip = false
		magnet = false
		walkFling = false
		legitSpeed = false
	end)
end) local walkFling = false

CreateButton("WALK FLING", Color3.fromRGB(120,0,0), Scroll, function()
	walkFling = not walkFling
end)

RS.RenderStepped:Connect(function()
	if walkFling and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LP.Character.HumanoidRootPart
		if hrp.Velocity.Magnitude > 2 then
			hrp.Velocity = hrp.CFrame.LookVector * 150
		end
	end
end) local magnet = false
CreateButton("MAGNET (SOFT)", nil, Scroll, function()
	magnet = not magnet
end)

RS.RenderStepped:Connect(function()
	if magnet and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LP.Character.HumanoidRootPart
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
				if dist < 25 then
					p.Character.HumanoidRootPart.CFrame =
						p.Character.HumanoidRootPart.CFrame:Lerp(hrp.CFrame * CFrame.new(0,0,-3), 0.1)
				end
			end
		end
	end
end) local noclip = false
local noclipConn

CreateButton("NOCLIP (SAFE)", nil, Scroll, function()
	noclip = not noclip
	if noclip and not noclipConn then
		noclipConn = RS.Stepped:Connect(function()
			local char = LP.Character
			if char then
				for _,v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end)
	elseif not noclip and noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
end) local legitSpeed = false
CreateButton("LEGIT SPEED", nil, Scroll, function()
	legitSpeed = not legitSpeed
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = legitSpeed and 22 or 16
	end
end)