-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

--------------------------------------------------
-- GUI
--------------------------------------------------

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BekaMrazPremium"
ScreenGui.ResetOnSpawn = false

-- OPEN BUTTON (IMAGE ICON)
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,55,0,55)
OpenBtn.Position = UDim2.new(0,10,0.4,0)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Image = "rbxassetid://120242451572198"
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)

-- MAIN FRAME
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,260,0,360)
Main.Position = UDim2.new(0.5,-130,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- HEADER
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,40)
Header.Text = "BEKA MRAZ PREMIUM"
Header.BackgroundColor3 = Color3.fromRGB(150,0,0)
Header.TextColor3 = Color3.new(1,1,1)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 18
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

-- SCROLL
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1,-10,1,-50)
Scroll.Position = UDim2.new(0,5,0,45)
Scroll.CanvasSize = UDim2.new(0,0,10,0)
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

--------------------------------------------------
-- STATES
--------------------------------------------------

local infJump, legitSpeed, noclip, magnet, walkFling,
	aimbot, fly, killAura, orbit =
	false,false,false,false,false,
	false,false,false,false

--------------------------------------------------
-- FEATURES BUTTONS
--------------------------------------------------

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if infJump then
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

CreateButton("INFINITE JUMP", nil, function()
	infJump = not infJump
end)

-- Speed
CreateButton("LEGIT SPEED", nil, function()
	legitSpeed = not legitSpeed
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = legitSpeed and 22 or 16 end
end)

-- Noclip
CreateButton("NOCLIP", nil, function()
	noclip = not noclip
end)

-- ESP
CreateButton("ESP", nil, function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and not p.Character:FindFirstChild("ESP") then
			local h = Instance.new("Highlight", p.Character)
			h.Name = "ESP"
			h.FillColor = Color3.fromRGB(255,0,0)
		end
	end
end)

-- Aimbot
CreateButton("AIMBOT", nil, function()
	aimbot = not aimbot
end)

-- Magnet
CreateButton("MAGNET", nil, function()
	magnet = not magnet
end)

-- Walk Fling
CreateButton("WALK FLING", Color3.fromRGB(120,0,0), function()
	walkFling = not walkFling
end)

-- Fly
CreateButton("FLY (MOBILE)", nil, function()
	fly = not fly
end)

-- Teleport
CreateButton("TAP TELEPORT", nil, function()
	local mouse = LP:GetMouse()
	local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
	end
end)

-- Kill Aura
CreateButton("KILL AURA", Color3.fromRGB(120,0,0), function()
	killAura = not killAura
end)

-- Orbit Blocks (Saturn)
CreateButton("ORBIT BLOCKS", Color3.fromRGB(100,0,150), function()
	orbit = not orbit
	orbitParts = {}
end)

-- Delete GUI
CreateButton("DELETE GUI", Color3.fromRGB(150,0,0), function()
	ScreenGui:Destroy()
end)

--------------------------------------------------
-- MOBILE FLY CONTROLS
--------------------------------------------------

local FlyGui = Instance.new("Frame", ScreenGui)
FlyGui.Size = UDim2.new(0,180,0,180)
FlyGui.Position = UDim2.new(1,-190,1,-200)
FlyGui.BackgroundTransparency = 1
FlyGui.Visible = false

local function FlyBtn(txt, pos)
	local b = Instance.new("TextButton", FlyGui)
	b.Size = UDim2.new(0,50,0,50)
	b.Position = pos
	b.Text = txt
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 22
	b.BackgroundColor3 = Color3.fromRGB(150,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
	return b
end

local up = FlyBtn("↑", UDim2.new(0.33,0,0,0))
local down = FlyBtn("↓", UDim2.new(0.33,0,0.66,0))
local left = FlyBtn("←", UDim2.new(0,0,0.33,0))
local right = FlyBtn("→", UDim2.new(0.66,0,0.33,0))
local top = FlyBtn("+", UDim2.new(0.66,0,0,0))
local bottom = FlyBtn("-", UDim2.new(0,0,0.66,0))

for _,b in pairs(FlyGui:GetChildren()) do
	if b:IsA("TextButton") then
		b.MouseButton1Down:Connect(function() b:SetAttribute("Hold", true) end)
		b.MouseButton1Up:Connect(function() b:SetAttribute("Hold", false) end)
	end
end

--------------------------------------------------
-- ORBIT SETTINGS
--------------------------------------------------

orbitParts = {}
local orbitRadius = 8
local orbitSpeed = 3
local orbitAngle = 0

local function getNearbyBlocks(hrp, char)
	orbitParts = {}
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart")
		and not v.Anchored
		and not v:IsDescendantOf(char)
		and (v.Position - hrp.Position).Magnitude < 25 then
			table.insert(orbitParts, v)
			if #orbitParts >= 12 then break end
		end
	end
end

--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------

local function getClosest()
	local closest, dist = nil, 150
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
			local pos, on = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if on then
				local mag = (Vector2.new(pos.X,pos.Y) - Camera.ViewportSize/2).Magnitude
				if mag < dist then
					dist = mag
					closest = p.Character.Head
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function(dt)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	FlyGui.Visible = fly

	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end

	if magnet then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local prp = p.Character.HumanoidRootPart
				if (prp.Position - hrp.Position).Magnitude < 25 then
					prp.CFrame = prp.CFrame:Lerp(hrp.CFrame * CFrame.new(0,0,-3), 0.1)
				end
			end
		end
	end

	if walkFling then
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

	if killAura then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LP and p.Character then
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				local prp = p.Character:FindFirstChild("HumanoidRootPart")
				if hum and prp and hum.Health > 0 then
					if (prp.Position - hrp.Position).Magnitude <= 15 then
						hum.Health = 0
					end
				end
			end
		end
	end

	-- FLY
	if fly then
		local bv = hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", hrp)
		bv.Name = "FlyBV"
		bv.MaxForce = Vector3.new(1e9,1e9,1e9)

		local bg = hrp:FindFirstChild("FlyBG") or Instance.new("BodyGyro", hrp)
		bg.Name = "FlyBG"
		bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
		bg.CFrame = Camera.CFrame

		local dir = Vector3.zero
		if up:GetAttribute("Hold") then dir += Camera.CFrame.LookVector end
		if down:GetAttribute("Hold") then dir -= Camera.CFrame.LookVector end
		if left:GetAttribute("Hold") then dir -= Camera.CFrame.RightVector end
		if right:GetAttribute("Hold") then dir += Camera.CFrame.RightVector end
		if top:GetAttribute("Hold") then dir += Vector3.new(0,1,0) end
		if bottom:GetAttribute("Hold") then dir -= Vector3.new(0,1,0) end

		bv.Velocity = dir * 60
	else
		if hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
		if hrp:FindFirstChild("FlyBG") then hrp.FlyBG:Destroy() end
	end

	-- ORBIT BLOCKS
	if orbit then
		if #orbitParts == 0 then
			getNearbyBlocks(hrp, char)
		end

		orbitAngle += orbitSpeed * dt

		for i,part in ipairs(orbitParts) do
			if part and part.Parent then
				part.Velocity = Vector3.zero
				local angle = orbitAngle + (math.pi * 2 / #orbitParts) * i
				local offset = Vector3.new(
					math.cos(angle) * orbitRadius,
					2,
					math.sin(angle) * orbitRadius
				)
				part.CFrame = CFrame.new(hrp.Position + offset)
			end
		end
	else
		orbitParts = {}
	end
end)