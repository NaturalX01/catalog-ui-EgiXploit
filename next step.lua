local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

local Theme = {
    BgMain       = Color3.fromRGB(14, 10, 12),
    BgPanel      = Color3.fromRGB(20, 14, 17),
    BgCard       = Color3.fromRGB(28, 19, 23),
    BgInput      = Color3.fromRGB(25, 16, 20),
    Accent       = Color3.fromRGB(210, 35, 55),
    AccentDark   = Color3.fromRGB(135, 20, 35),
    Stroke       = Color3.fromRGB(75, 25, 35),
    TextPrimary  = Color3.fromRGB(245, 240, 242),
    TextMuted    = Color3.fromRGB(165, 140, 148),
    LimitedColor = Color3.fromRGB(255, 201, 74)
}

local function GetUIParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return plr:WaitForChild("PlayerGui")
end

local UIParent = GetUIParent()
if UIParent:FindFirstChild("CatalogV3_RedDark") then
    UIParent.CatalogV3_RedDark:Destroy()
end
if UIParent:FindFirstChild("EgiXploit_CatalogSplash") then
    UIParent.EgiXploit_CatalogSplash:Destroy()
end

local function AddStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function MakeDraggable(target, handle, onTap)
    handle = handle or target
    local dragging = false
    local moved = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragInput = inp
            dragStart = inp.Position
            startPos = target.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 6 then
                moved = true
            end
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            dragInput = nil
            if not moved and onTap then
                onTap()
            end
        end
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "CatalogV3_RedDark"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = UIParent

local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 145, 0, 34)
openBtn.Position = UDim2.new(0.5, -72, 0, 10)
openBtn.Text = "EgiXploit | Catalog"
openBtn.BackgroundColor3 = Theme.BgPanel
openBtn.TextColor3 = Theme.TextPrimary
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 12
openBtn.AutoButtonColor = false
openBtn.Visible = false
openBtn.Parent = gui
AddCorner(openBtn, 10)
AddStroke(openBtn, Theme.Accent, 1.5)

local openBtnScale = Instance.new("UIScale")
openBtnScale.Scale = 0.85
openBtnScale.Parent = openBtn

local main = Instance.new("Frame")
main.Size = UDim2.new(0.92, 0, 0.88, 0)
main.Position = UDim2.new(0.04, 0, 0.06, 0)
main.BackgroundColor3 = Theme.BgMain
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
AddCorner(main, 16)
AddStroke(main, Theme.Stroke, 1.5)

local mainScale = Instance.new("UIScale")
mainScale.Scale = 0.88
mainScale.Parent = main

local savedMainPos = UDim2.new(0.04, 0, 0.06, 0)
local uiAnimating = false

local function OpenMainUI()
    if uiAnimating then return end
    uiAnimating = true

    if openBtn.Visible then
        TweenService:Create(openBtnScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.8 }):Play()
        task.wait(0.14)
        openBtn.Visible = false
    end

    main.Position = UDim2.new(savedMainPos.X.Scale, savedMainPos.X.Offset, savedMainPos.Y.Scale, savedMainPos.Y.Offset - 24)
    mainScale.Scale = 0.88
    main.Visible = true

    TweenService:Create(main, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = savedMainPos
    }):Play()
    TweenService:Create(mainScale, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    task.wait(0.34)
    uiAnimating = false
end

local function CloseMainUI()
    if uiAnimating then return end
    uiAnimating = true
    savedMainPos = main.Position

    TweenService:Create(main, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(savedMainPos.X.Scale, savedMainPos.X.Offset, savedMainPos.Y.Scale, savedMainPos.Y.Offset - 24)
    }):Play()
    TweenService:Create(mainScale, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Scale = 0.85
    }):Play()

    task.wait(0.24)
    main.Visible = false
    openBtnScale.Scale = 0.82
    openBtn.Visible = true
    TweenService:Create(openBtnScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    task.wait(0.26)
    uiAnimating = false
end

MakeDraggable(openBtn, openBtn, OpenMainUI)

-- Left Panel: Preview & Equipped
local left = Instance.new("Frame")
left.Size = UDim2.new(0.33, -8, 1, -16)
left.Position = UDim2.new(0, 8, 0, 8)
left.BackgroundColor3 = Theme.BgPanel
left.BorderSizePixel = 0
left.Parent = main
AddCorner(left, 12)
AddStroke(left, Theme.Stroke, 1)

local vpHeader = Instance.new("TextLabel")
vpHeader.Size = UDim2.new(1, -16, 0, 22)
vpHeader.Position = UDim2.new(0, 8, 0, 6)
vpHeader.Text = "AVATAR PREVIEW"
vpHeader.TextColor3 = Theme.Accent
vpHeader.Font = Enum.Font.GothamBlack
vpHeader.TextSize = 11
vpHeader.TextXAlignment = Enum.TextXAlignment.Left
vpHeader.BackgroundTransparency = 1
vpHeader.Active = true
vpHeader.Parent = left

MakeDraggable(main, vpHeader)

local viewport = Instance.new("ViewportFrame")
viewport.Size = UDim2.new(1, -16, 0.54, 0)
viewport.Position = UDim2.new(0, 8, 0, 30)
viewport.BackgroundColor3 = Theme.BgMain
viewport.Ambient = Color3.fromRGB(220, 200, 205)
viewport.LightColor = Color3.fromRGB(255, 240, 245)
viewport.BorderSizePixel = 0
viewport.Parent = left
AddCorner(viewport, 10)
AddStroke(viewport, Theme.Stroke, 1)

local vpWorld = Instance.new("WorldModel")
vpWorld.Parent = viewport

local cam = Instance.new("Camera")
cam.Parent = viewport
viewport.CurrentCamera = cam

local bottomLeft = Instance.new("Frame")
bottomLeft.Size = UDim2.new(1, -16, 0, 34)
bottomLeft.Position = UDim2.new(0, 8, 0.54, 36)
bottomLeft.BackgroundColor3 = Theme.BgCard
bottomLeft.Parent = left
AddCorner(bottomLeft, 8)
AddStroke(bottomLeft, Theme.Stroke, 1)

local function ActionBtn(txt, xScale, wScale, bg)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(wScale, -6, 1, -6)
    b.Position = UDim2.new(xScale, 3, 0, 3)
    b.Text = txt
    b.BackgroundColor3 = bg
    b.TextColor3 = Theme.TextPrimary
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Parent = bottomLeft
    AddCorner(b, 6)
    return b
end

local refreshBtn = ActionBtn("Sync Avatar", 0, 0.5, Theme.BgInput)
local resetBtn = ActionBtn("Clear All", 0.5, 0.5, Theme.AccentDark)

local eqLabel = Instance.new("TextLabel")
eqLabel.Size = UDim2.new(1, -16, 0, 16)
eqLabel.Position = UDim2.new(0, 8, 0.54, 74)
eqLabel.Text = "EQUIPPED ITEMS (Edit / Remove)"
eqLabel.TextColor3 = Theme.TextMuted
eqLabel.Font = Enum.Font.GothamBold
eqLabel.TextSize = 9
eqLabel.TextXAlignment = Enum.TextXAlignment.Left
eqLabel.BackgroundTransparency = 1
eqLabel.Parent = left

local equippedBar = Instance.new("ScrollingFrame")
equippedBar.Name = "EquippedBar"
equippedBar.Size = UDim2.new(1, -16, 0.46, -100)
equippedBar.Position = UDim2.new(0, 8, 0.54, 92)
equippedBar.BackgroundColor3 = Theme.BgMain
equippedBar.ScrollBarThickness = 4
equippedBar.ScrollBarImageColor3 = Theme.Accent
equippedBar.ScrollingDirection = Enum.ScrollingDirection.X
equippedBar.AutomaticCanvasSize = Enum.AutomaticSize.X
equippedBar.CanvasSize = UDim2.new(0, 0, 0, 0)
equippedBar.Parent = left
AddCorner(equippedBar, 9)
AddStroke(equippedBar, Theme.Stroke, 1)

local eqLayout = Instance.new("UIListLayout", equippedBar)
eqLayout.FillDirection = Enum.FillDirection.Horizontal
eqLayout.VerticalAlignment = Enum.VerticalAlignment.Center
eqLayout.Padding = UDim.new(0, 8)

local eqPad = Instance.new("UIPadding", equippedBar)
eqPad.PaddingLeft = UDim.new(0, 8)
eqPad.PaddingRight = UDim.new(0, 8)

-- Right Panel: Search, Tabs & Content Containers
local right = Instance.new("Frame")
right.Size = UDim2.new(0.67, -8, 1, -16)
right.Position = UDim2.new(0.33, 4, 0, 8)
right.BackgroundColor3 = Theme.BgPanel
right.BorderSizePixel = 0
right.ClipsDescendants = true
right.Parent = main
AddCorner(right, 12)
AddStroke(right, Theme.Stroke, 1)

local brandBadge = Instance.new("TextLabel")
brandBadge.Size = UDim2.new(0, 95, 0, 34)
brandBadge.Position = UDim2.new(0, 10, 0, 10)
brandBadge.Text = "EgiXploit"
brandBadge.BackgroundColor3 = Theme.AccentDark
brandBadge.TextColor3 = Theme.TextPrimary
brandBadge.Font = Enum.Font.GothamBlack
brandBadge.TextSize = 13
brandBadge.Active = true
brandBadge.Parent = right
AddCorner(brandBadge, 9)

MakeDraggable(main, brandBadge)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -160, 0, 34)
searchBox.Position = UDim2.new(0, 112, 0, 10)
searchBox.PlaceholderText = "Search catalog items (e.g. Dominus, Fedora, Valkyrie)..."
searchBox.PlaceholderColor3 = Theme.TextMuted
searchBox.Text = ""
searchBox.BackgroundColor3 = Theme.BgInput
searchBox.TextColor3 = Theme.TextPrimary
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.ClearTextOnFocus = false
searchBox.Parent = right
AddCorner(searchBox, 9)
AddStroke(searchBox, Theme.Stroke, 1)

local searchPad = Instance.new("UIPadding", searchBox)
searchPad.PaddingLeft = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0, 10)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Theme.Accent
closeBtn.TextColor3 = Theme.TextPrimary
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = right
AddCorner(closeBtn, 9)

closeBtn.MouseButton1Click:Connect(CloseMainUI)

local tabs = {"All", "Hats", "Hair", "Face", "Back", "Clothing", "Larp", "Body", "Limited", "Anim", "Music"}

local tabBar = Instance.new("ScrollingFrame")
tabBar.Size = UDim2.new(1, -20, 0, 34)
tabBar.Position = UDim2.new(0, 10, 0, 50)
tabBar.BackgroundTransparency = 1
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.ScrollBarThickness = 0
tabBar.Parent = right

local tabIndicator = Instance.new("Frame")
tabIndicator.Name = "ActiveTabIndicator"
tabIndicator.Size = UDim2.new(0, 76, 0, 3)
tabIndicator.Position = UDim2.new(0, 0, 0, 29)
tabIndicator.BackgroundColor3 = Theme.Accent
tabIndicator.BorderSizePixel = 0
tabIndicator.ZIndex = 5
tabIndicator.Parent = tabBar
AddCorner(tabIndicator, 2)

local tabBtns = {}
for idx, t in ipairs(tabs) do
    local xPos = (idx - 1) * 82
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 76, 0, 26)
    b.Position = UDim2.new(0, xPos, 0, 0)
    b.Text = t
    b.BackgroundColor3 = (t == "All") and Theme.Accent or Theme.BgCard
    b.TextColor3 = Theme.TextPrimary
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    b.Parent = tabBar
    AddCorner(b, 7)

    local bScale = Instance.new("UIScale")
    bScale.Scale = 1
    bScale.Parent = b
    tabBtns[t] = { Button = b, Scale = bScale, Index = idx, XPos = xPos }
end

local grid = Instance.new("ScrollingFrame")
grid.Size = UDim2.new(1, -20, 1, -156)
grid.Position = UDim2.new(0, 10, 0, 90)
grid.BackgroundTransparency = 1
grid.ScrollBarThickness = 4
grid.ScrollBarImageColor3 = Theme.Accent
grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
grid.CanvasSize = UDim2.new(0, 0, 0, 0)
grid.Parent = right

local gridLayout = Instance.new("UIGridLayout", grid)
gridLayout.CellSize = UDim2.new(0, 106, 0, 134)
gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)

local bodyPanel = Instance.new("ScrollingFrame")
bodyPanel.Size = UDim2.new(1, -20, 1, -156)
bodyPanel.Position = UDim2.new(0, 10, 0, 90)
bodyPanel.BackgroundTransparency = 1
bodyPanel.ScrollBarThickness = 4
bodyPanel.ScrollBarImageColor3 = Theme.Accent
bodyPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
bodyPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
bodyPanel.Visible = false
bodyPanel.Parent = right

local bodyLayout = Instance.new("UIListLayout", bodyPanel)
bodyLayout.Padding = UDim.new(0, 10)

local animPanel = Instance.new("ScrollingFrame")
animPanel.Name = "AnimPanel"
animPanel.Size = UDim2.new(1, -20, 1, -156)
animPanel.Position = UDim2.new(0, 10, 0, 90)
animPanel.BackgroundTransparency = 1
animPanel.ScrollBarThickness = 4
animPanel.ScrollBarImageColor3 = Theme.Accent
animPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
animPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
animPanel.Visible = false
animPanel.Parent = right

local animLayout = Instance.new("UIListLayout", animPanel)
animLayout.Padding = UDim.new(0, 6)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -105, 0, 18)
statusLbl.Position = UDim2.new(0, 10, 1, -58)
statusLbl.Text = "Ready | Click an item to wear"
statusLbl.TextColor3 = Theme.TextMuted
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.BackgroundTransparency = 1
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = right

local nextPageBtn = Instance.new("TextButton")
nextPageBtn.Size = UDim2.new(0, 80, 0, 20)
nextPageBtn.Position = UDim2.new(1, -90, 1, -60)
nextPageBtn.Text = "Next Page >"
nextPageBtn.BackgroundColor3 = Theme.BgCard
nextPageBtn.TextColor3 = Theme.TextPrimary
nextPageBtn.Font = Enum.Font.GothamBold
nextPageBtn.TextSize = 10
nextPageBtn.Parent = right
AddCorner(nextPageBtn, 6)
AddStroke(nextPageBtn, Theme.Stroke, 1)

local linkBox = Instance.new("TextBox")
linkBox.Size = UDim2.new(1, -105, 0, 30)
linkBox.Position = UDim2.new(0, 10, 1, -36)
linkBox.PlaceholderText = "Paste Asset ID or Roblox Link..."
linkBox.PlaceholderColor3 = Theme.TextMuted
linkBox.Text = ""
linkBox.BackgroundColor3 = Theme.BgInput
linkBox.TextColor3 = Theme.TextPrimary
linkBox.Font = Enum.Font.Gotham
linkBox.TextSize = 11
linkBox.Parent = right
AddCorner(linkBox, 8)
AddStroke(linkBox, Theme.Stroke, 1)

local linkPad = Instance.new("UIPadding", linkBox)
linkPad.PaddingLeft = UDim.new(0, 10)

local wearIdBtn = Instance.new("TextButton")
wearIdBtn.Size = UDim2.new(0, 80, 0, 30)
wearIdBtn.Position = UDim2.new(1, -90, 1, -36)
wearIdBtn.Text = "Wear ID"
wearIdBtn.BackgroundColor3 = Theme.Accent
wearIdBtn.TextColor3 = Theme.TextPrimary
wearIdBtn.Font = Enum.Font.GothamBold
wearIdBtn.TextSize = 11
wearIdBtn.Parent = right
AddCorner(wearIdBtn, 8)

return {
    UIParent = UIParent,
    Theme = Theme,
    AddCorner = AddCorner,
    AddStroke = AddStroke,
    MakeDraggable = MakeDraggable,
    gui = gui,
    openBtn = openBtn,
    main = main,
    left = left,
    viewport = viewport,
    vpWorld = vpWorld,
    cam = cam,
    refreshBtn = refreshBtn,
    resetBtn = resetBtn,
    equippedBar = equippedBar,
    right = right,
    searchBox = searchBox,
    closeBtn = closeBtn,
    tabs = tabs,
    tabBar = tabBar,
    tabIndicator = tabIndicator,
    tabBtns = tabBtns,
    grid = grid,
    bodyPanel = bodyPanel,
    animPanel = animPanel,
    statusLbl = statusLbl,
    nextPageBtn = nextPageBtn,
    linkBox = linkBox,
    wearIdBtn = wearIdBtn,
    OpenMainUI = OpenMainUI,
    CloseMainUI = CloseMainUI
}
