-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BekaMrazPremium"
ScreenGui.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.Position = UDim2.new(0,10,0.4,0)
OpenBtn.Text = "БМ"
OpenBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 24
OpenBtn.Draggable = true
OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,260,0,360)
Main.Position = UDim2.new(0.5,-130,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Visible = false
Main.Draggable = true
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,40)
Header.Text = "BEKA MRAZ PREMIUM"
Header.BackgroundColor3 = Color3.fromRGB(150,0,0)
Header.TextColor3 = Color3.new(1,1,1)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 18
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1,-10,1,-50)
Scroll.Position = UDim2.new(0,5,0,45)
Scroll.CanvasSize = UDim2.new(0,0,6,0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0,6)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUTTON CREATOR
local function CreateButton(txt, color, callback)
	local b = Instance.new("TextButton", Scroll)
	b.Size = UDim2.new(0,220,0,36)
	b.Text = txt
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color or Color3.fromRGB(45,45,45)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.MouseButton1Click:Connect(callback)
	return b
end

-- STATES
local infJump, legitSpeed, noclip, magnet, walkFling, aimbot = false,false,false,false,false,false

-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
	if infJump then
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

CreateButton("INFINITE JUMP", nil, function()
	infJump = not infJump
end)

-- LEGIT SPEED
CreateButton("LEGIT SPEED", nil, function()
	legitSpeed = not legitSpeed
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = legitSpeed and 22 or 16 end
end)

-- SAFE NOCLIP
CreateButton("NOCLIP (SAFE)", nil, function()
	noclip = not noclip
end)

-- ESP + HP BAR
local function addESP(p)
	if not p.Character or p.Character:FindFirstChild("ESP") then return end
	local h = Instance.new("Highlight", p.Character)
	h.Name = "ESP"
	h.FillColor = Color3.fromRGB(255,0,0)

	local head = p.Character:FindFirstChild("Head")
	if not head then return end

	local bb = Instance.new("BillboardGui", head)
	bb.Size = UDim2.new(4,0,0.4,0)
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true

	local bg = Instance.new("Frame", bb)
	bg.Size = UDim2.new(1,0,1,0)
	bg.BackgroundColor3 = Color3.fromRGB(40,40,40)

	local bar = Instance.new("Frame", bg)
	bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
	bar.Size = UDim2.new(1,0,1,0)

	local hum = p.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.HealthChanged:Connect(function()
			bar.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
		end)
	end
end

CreateButton("ESP + HP BAR", nil, function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP then addESP(p) end
	end
end)

-- AIMBOT (SOFT)
CreateButton("AIMBOT", nil, function()
	aimbot = not aimbot
end)

local function getClosest()
	local closest, dist = nil, 150
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
			local pos, on = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if on then
				local mag = (Vector2.new(pos.X,pos.Y)
					- Camera.ViewportSize/2).Magnitude
				if mag < dist then
					dist = mag
					closest = p.Character.Head
				end
			end
		end
	end
	return closest
end

-- MAGNET
CreateButton("MAGNET (SOFT)", nil, function()
	magnet = not magnet
end)

-- WALK FLING
CreateButton("WALK FLING", Color3.fromRGB(120,0,0), function()
	walkFling = not walkFling
end)

-- HP BOOST
CreateButton("HP x2 (SELF)", nil, function()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.MaxHealth = hum.MaxHealth * 2
		hum.Health = hum.MaxHealth
	end
end)

-- DELETE GUI
CreateButton("DELETE GUI", Color3.fromRGB(150,0,0), function()
	ScreenGui:Destroy()
end)

-- MAIN LOOP (OPTIMIZED)
RunService.RenderStepped:Connect(function()
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if noclip and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end

	if magnet and hrp then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local prp = p.Character.HumanoidRootPart
				if (prp.Position-hrp.Position).Magnitude < 25 then
					prp.CFrame = prp.CFrame:Lerp(hrp.CFrame * CFrame.new(0,0,-3),0.1)
				end
			end
		end
	end

	if walkFling and hrp and hrp.Velocity.Magnitude > 2 then
		hrp.Velocity = hrp.CFrame.LookVector * 150
	end

	if aimbot then
		local t = getClosest()
		if t then
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position, t.Position), 0.08
			)
		end
	end
end)

-- AUTO OFF ON DEATH
LP.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid").Died:Connect(function()
		infJump,legitSpeed,noclip,magnet,walkFling,aimbot =
		false,false,false,false,false,false
	end)
end)