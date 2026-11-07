-- will change a lot overtime, maybe even changing the entire structure
-- add the loadstring if you want it forever (in case theres an update this gets fixed fast, so that's why you put the loadstring)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/lqdxt/Executors/refs/heads/main/Reskins/Delta/Volt.luau"))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local LogService = game:GetService("LogService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LP = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G
local root = (gethui and gethui()) or game:GetService("CoreGui")

if env.__VoltUnload then pcall(env.__VoltUnload) end
if env.__VoltConns then
 for _, c in ipairs(env.__VoltConns) do pcall(function() c:Disconnect() end) end
end
for _, d in ipairs(root:GetChildren()) do
 if d.Name == "VoltUI" then pcall(function() d:Destroy() end) end
end

local conns = {}
env.__VoltConns = conns
local function Bind(sig, fn)
 local c = sig:Connect(fn)
 conns[#conns + 1] = c
 return c
end

env.__VoltLoadUpdated = function()
  local colorMap = {}

  local function Reg(r1, g1, b1, r2, g2, b2)
   colorMap[r1 .. "," .. g1 .. "," .. b1] = Color3.fromRGB(r2, g2, b2)
  end

  Reg(26, 28, 36, 12, 12, 16)
  Reg(26, 27, 36, 12, 12, 16)
  Reg(24, 25, 33, 14, 14, 19)
  Reg(32, 35, 46, 17, 17, 23)
  Reg(34, 41, 50, 19, 19, 26)
  Reg(38, 41, 49, 20, 20, 27)
  Reg(38, 41, 50, 20, 20, 27)
  Reg(31, 37, 47, 14, 14, 19)
  Reg(41, 44, 52, 24, 24, 32)
  Reg(41, 45, 58, 24, 24, 32)
  Reg(51, 56, 70, 28, 28, 38)
  Reg(59, 63, 74, 30, 30, 40)
  Reg(59, 64, 79, 32, 32, 44)
  Reg(59, 71, 90, 30, 30, 42)
  Reg(61, 66, 81, 32, 32, 44)
  Reg(22, 22, 30, 11, 11, 15)
  Reg(34, 160, 255, 150, 75, 255)
  Reg(59, 139, 254, 150, 75, 255)
  Reg(60, 137, 196, 125, 60, 215)
  Reg(86, 173, 239, 170, 110, 255)
  Reg(94, 136, 169, 90, 50, 160)
  Reg(31, 51, 80, 52, 28, 92)
  Reg(69, 97, 119, 60, 38, 105)
  Reg(185, 211, 230, 205, 205, 220)
  Reg(190, 206, 232, 210, 210, 225)
  Reg(103, 109, 126, 105, 105, 120)
  Reg(104, 120, 144, 105, 105, 122)
  Reg(126, 139, 176, 125, 120, 150)
  Reg(136, 140, 151, 130, 130, 142)
  Reg(137, 144, 163, 140, 140, 155)
  Reg(138, 146, 167, 140, 140, 156)
  Reg(157, 162, 199, 160, 150, 195)
  Reg(161, 167, 182, 160, 160, 175)
  Reg(115, 127, 152, 115, 115, 132)
  Reg(129, 143, 164, 135, 135, 150)
  Reg(140, 206, 255, 190, 150, 255)
  Reg(162, 191, 212, 185, 185, 200)

  local function Key(c)
   return math.round(c.R * 255) .. "," .. math.round(c.G * 255) .. "," .. math.round(c.B * 255)
  end

  local outputs = {}
  for _, v in pairs(colorMap) do outputs[Key(v)] = true end

  local fallbackCache = {}
  local PURPLE_HUE = 0.755

  local function Remap(c)
   local k = Key(c)
   local hit = colorMap[k]
   if hit then return hit end
   if outputs[k] then return nil end
   local cached = fallbackCache[k]
   if cached ~= nil then return cached or nil end
   local h, s, v = c:ToHSV()
   if s < 0.12 or h < 0.5 or h > 0.7 then
    fallbackCache[k] = false
    return nil
   end
   local new = Color3.fromHSV(PURPLE_HUE, math.clamp(s * 1.05, 0, 1), math.clamp(v * 0.95, 0, 1))
   outputs[Key(new)] = true
   fallbackCache[k] = new
   return new
  end

  local COLOR_PROPS = {
   "BackgroundColor3",
   "TextColor3",
   "ImageColor3",
   "BorderColor3",
   "PlaceholderColor3",
   "TextStrokeColor3",
   "ScrollBarImageColor3",
  }

  local env = (getgenv and getgenv()) or _G
  if env.__VoltConns then
   for _, c in ipairs(env.__VoltConns) do pcall(function() c:Disconnect() end) end
  end
  local conns = {}
  env.__VoltConns = conns

  local patched = 0
  local hooked = setmetatable({}, { __mode = "k" })

  local function Apply(inst, prop)
   local ok, val = pcall(function() return inst[prop] end)
   if not ok or typeof(val) ~= "Color3" then return end
   local new = Remap(val)
   if new and new ~= val then
    if pcall(function() inst[prop] = new end) then patched += 1 end
   end
  end

  local function PropsFor(inst)
   if inst:IsA("Color3Value") then return { "Value" } end
   if inst:IsA("UIStroke") then return { "Color" } end
   return COLOR_PROPS
  end

  local function Rebrand(inst)
   if inst:IsA("TextLabel") or inst:IsA("TextButton") then
    local function Fix()
     local ok, t = pcall(function() return inst.Text end)
     if ok and type(t) == "string" and t:find("Delta", 1, true) then
      pcall(function() inst.Text = (t:gsub("Delta", "Volt")) end)
     end
    end
    Fix()
    if not hooked[inst] then
     local ok, sig = pcall(function() return inst:GetPropertyChangedSignal("Text") end)
     if ok and sig then table.insert(conns, sig:Connect(Fix)) end
    end
   elseif inst:IsA("TextBox") then
    local ok, p = pcall(function() return inst.PlaceholderText end)
    if ok and type(p) == "string" and p:find("Delta", 1, true) then
     pcall(function() inst.PlaceholderText = "Welcome to Volt" end)
    end
   end
  end

  local function PatchInstance(inst)
   Rebrand(inst)
   local props = PropsFor(inst)
   for _, prop in ipairs(props) do
    Apply(inst, prop)
   end
   if hooked[inst] then return end
   hooked[inst] = true
   for _, prop in ipairs(props) do
    local ok, sig = pcall(function() return inst:GetPropertyChangedSignal(prop) end)
    if ok and sig then
     local ok2, val = pcall(function() return inst[prop] end)
     if ok2 and typeof(val) == "Color3" then
      table.insert(conns, sig:Connect(function() Apply(inst, prop) end))
     end
    end
   end
  end

  local root = gethui()

  for _, inst in ipairs(root:GetDescendants()) do
   PatchInstance(inst)
  end

  table.insert(conns, root.DescendantAdded:Connect(function(inst)
   task.defer(PatchInstance, inst)
  end))

  print(string.format("[Volt] %d changes", patched))


  local HIGHLIGHTER_URL = "https://raw.githubusercontent.com/lqdxt/Scripts/main/Highlighter.lua"
  local MAX_CHARS = 60000

  local Palette = {
   keyword = "#FF6EC7",
   string = "#FFA760",
   value = "#5ED8F0",
   comment = "#6E6E7C",
   builtin = "#7FD0FF",
   property = "#5ED8F0",
   method = "#FFE6A8",
   identifier = "#D8E4FF",
   plain = "#6EA8FF",
  }

  local CURSOR = {
   Color = Color3.fromRGB(190, 140, 255),
   Width = 2,
   CornerRadius = 1,
   Smooth = true,
   SmoothTime = 0.07,
   Blink = true,
   BlinkRate = 0.53,
   YBias = 0,
   FollowCursor = true,
   ScrollMarginLines = 1.5,
   ScrollMarginX = 40,
   TapPlacesCursor = true,
   TapSlop = 12,
  }

  local LAYOUT = {
   PadX = 8,
   PadY = 4,
   Gutter = 46,
   GutterColor = Color3.fromRGB(88, 88, 102),
   GutterActiveColor = Color3.fromRGB(240, 240, 248),
   LineHighlight = Color3.fromRGB(255, 255, 255),
   LineHighlightTransparency = 0.86,
   LineHeight = 1.5,
   Font = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
  }

  local function ToHex(c)
   return string.format("#%02X%02X%02X", math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
  end

  local function HexToColor3(hex)
   local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
   return Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
  end

  local function SetupEditor()
   local TextService = game:GetService("TextService")
   local TweenService = game:GetService("TweenService")
   local UIS = game:GetService("UserInputService")
   local GuiService = game:GetService("GuiService")
   local RunService = game:GetService("RunService")

   local function Settle()
    RunService.Heartbeat:Wait()
    RunService.Heartbeat:Wait()
   end

   for _, d in ipairs(gethui():GetDescendants()) do
    local n = d.Name
    if n == "VoltView" or n == "VoltHL" or n == "VoltCursor" or n == "VoltProbe" or n == "VoltKbPad" then
     d:Destroy()
    end
   end

   local Highlighter
   do
    local ok, h = pcall(function()
     return loadstring(game:HttpGet(HIGHLIGHTER_URL))()
    end)
    if ok and type(h) == "table" and type(h.Tokenize) == "function" then
     Highlighter = h
    else
     warn("[Volt] Highlighter failed to load, syntax highlighting skipped")
    end
   end

   local ESC = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ['"'] = "&quot;", ["'"] = "&apos;" }
   local function Esc(s)
    return (s:gsub("[&<>\"']", ESC))
   end

   local plainHex = Palette.plain
   local plainColor = HexToColor3(plainHex)

   local function ToRichText(src)
    if not Highlighter then return Esc(src) end
    local okT, tokens = pcall(Highlighter.Tokenize, src)
    if not okT or type(tokens) ~= "table" then
     return Esc(src)
    end

    local out, n = {}, 0
    local pos = 1
    local runHex, runBuf = nil, {}

    local function Flush()
     if #runBuf == 0 then return end
     local text = table.concat(runBuf)
     n += 1
     if runHex == plainHex then
      out[n] = text
     else
      out[n] = '<font color="' .. runHex .. '">' .. text .. "</font>"
     end
     table.clear(runBuf)
    end

    local function Add(text, hex)
     if text == "" then return end
     if hex ~= runHex then
      Flush()
      runHex = hex
     end
     runBuf[#runBuf + 1] = Esc(text)
    end

    for _, tok in ipairs(tokens) do
     local value = tok.value
     if type(value) == "string" and value ~= "" then
      local s, e = string.find(src, value, pos, true)
      if s then
       if s > pos then
        Add(string.sub(src, pos, s - 1), plainHex)
       end
       Add(value, Palette[tok.type] or plainHex)
       pos = e + 1
      end
     end
    end
    if pos <= #src then
     Add(string.sub(src, pos), plainHex)
    end
    Flush()
    return table.concat(out)
   end

   local params = Instance.new("GetTextBoundsParams")
   params.Width = math.huge
   local pipeCache = {}
   local function Measure(str, font, size)
    params.Font = font
    params.Size = size
    local cacheKey = size .. "|" .. font.Family .. "|" .. tostring(font.Weight)
    local pipeW = pipeCache[cacheKey]
    if not pipeW then
     params.Text = "|"
     pipeW = TextService:GetTextBoundsAsync(params).X
     pipeCache[cacheKey] = pipeW
    end
    params.Text = str .. "|"
    local b = TextService:GetTextBoundsAsync(params)
    return math.max(0, b.X - pipeW), b.Y
   end

   local function GetPitch(probe, box, h)
    local pitch = h * box.LineHeight
    pcall(function()
     probe.FontFace = box.FontFace
     probe.TextSize = box.TextSize
     probe.LineHeight = box.LineHeight
     probe.Text = "A"
     local one = probe.TextBounds.Y
     probe.Text = "A\nA"
     local two = probe.TextBounds.Y
     if two - one > 1 then pitch = two - one end
    end)
    return pitch
   end

   local function KeyboardTop(scroller)
    if not UIS.OnScreenKeyboardVisible then return nil end
    local y = UIS.OnScreenKeyboardPosition.Y
    local root = scroller:FindFirstAncestorOfClass("ScreenGui")
    if root and not root.IgnoreGuiInset then
     y -= GuiService:GetGuiInset().Y
    end
    return y
   end

   local function UpdateKeyboardPad(view, scroller, box)
    local pad = view:FindFirstChild("VoltKbPad")
    if not pad then
     pad = Instance.new("UIPadding")
     pad.Name = "VoltKbPad"
     pad.Parent = view
    end
    local kbTop = KeyboardTop(scroller)
    local overlap = 0
    if kbTop then
     local winBottom = scroller.AbsolutePosition.Y + scroller.AbsoluteWindowSize.Y
     overlap = math.max(0, winBottom - kbTop)
     if overlap > 0 then
      overlap += CURSOR.ScrollMarginLines * box.TextSize * 1.2 * box.LineHeight
     end
    end
    pad.PaddingBottom = UDim.new(0, math.ceil(overlap))
   end

   local active = setmetatable({}, { __mode = "k" })
   local padFns = setmetatable({}, { __mode = "k" })
   local solidUntil = 0
   local token = {}
   env.__VoltCursorToken = token
   if CURSOR.Blink then
    task.spawn(function()
     while env.__VoltCursorToken == token do
      local now = os.clock()
      local on = now < solidUntil or (now % (CURSOR.BlinkRate * 2)) < CURSOR.BlinkRate
      for _, fr in pairs(active) do
       fr.BackgroundTransparency = on and 0 or 1
      end
      task.wait(0.05)
     end
    end)
   end

   local function OnKeyboardChanged()
    task.wait(0.15)
    for _, fn in pairs(padFns) do
     pcall(fn)
    end
   end
   table.insert(conns, UIS:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(OnKeyboardChanged))
   table.insert(conns, UIS:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(OnKeyboardChanged))

   local hooked = setmetatable({}, { __mode = "k" })

   local function HookBox(box)
    if hooked[box] then return end
    hooked[box] = true

    local scroller = box.Parent
    if LAYOUT.Font then pcall(function() box.FontFace = LAYOUT.Font end) end
    if LAYOUT.LineHeight then pcall(function() box.LineHeight = LAYOUT.LineHeight end) end

    local hiddenProps = {
     AutomaticSize = Enum.AutomaticSize.None,
     AnchorPoint = Vector2.new(0.5, 0.5),
     Position = UDim2.fromScale(0.5, 0.5),
     Size = UDim2.fromOffset(0, 0),
     BackgroundTransparency = 1,
     TextTransparency = 1,
     TextStrokeTransparency = 1,
     TextColor3 = Color3.new(0, 0, 0),
     ShowNativeInput = false,
     ClipsDescendants = true,
    }
    local order = { "AutomaticSize", "AnchorPoint", "Position", "Size", "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency", "TextColor3", "ShowNativeInput", "ClipsDescendants" }
    local function ApplyHidden()
     for _, p in ipairs(order) do
      local v = hiddenProps[p]
      if box[p] ~= v then box[p] = v end
     end
    end
    ApplyHidden()
    for _, p in ipairs(order) do
     table.insert(conns, box:GetPropertyChangedSignal(p):Connect(ApplyHidden))
    end

    local view = Instance.new("TextButton")
    view.Name = "VoltView"
    view.AutoButtonColor = false
    view.BackgroundTransparency = 1
    view.BorderSizePixel = 0
    view.RichText = true
    view.Text = ""
    view.TextColor3 = plainColor
    view.TextXAlignment = Enum.TextXAlignment.Left
    view.TextYAlignment = Enum.TextYAlignment.Top
    view.TextWrapped = false
    view.AutomaticSize = Enum.AutomaticSize.XY
    view.Position = UDim2.fromOffset(LAYOUT.PadX + LAYOUT.Gutter, LAYOUT.PadY)
    view.ZIndex = box.ZIndex
    view.Active = true
    view.Visible = box.Visible
    pcall(function() view.FontFace = box.FontFace end)
    view.TextSize = box.TextSize

    local probe = Instance.new("TextLabel")
    probe.Name = "VoltProbe"
    probe.BackgroundTransparency = 1
    probe.TextTransparency = 1
    probe.Size = UDim2.fromOffset(0, 0)
    probe.TextWrapped = false
    probe.TextXAlignment = Enum.TextXAlignment.Left
    probe.TextYAlignment = Enum.TextYAlignment.Top
    probe.Active = false
    probe.Text = "A"
    probe.Parent = view

    local fr = Instance.new("Frame")
    fr.Name = "VoltCursor"
    fr.BackgroundColor3 = CURSOR.Color
    fr.BorderSizePixel = 0
    fr.Size = UDim2.fromOffset(CURSOR.Width, 16)
    fr.Visible = false
    fr.Active = false
    fr.ZIndex = view.ZIndex + 2
    pcall(function() fr.Interactable = false end)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CURSOR.CornerRadius)
    corner.Parent = fr
    fr.Parent = view

    local line = Instance.new("Frame")
    line.Name = "VoltLine"
    line.BackgroundColor3 = LAYOUT.LineHighlight
    line.BackgroundTransparency = LAYOUT.LineHighlightTransparency
    line.BorderSizePixel = 0
    line.Visible = false
    line.Active = false
    line.ZIndex = view.ZIndex + 1
    pcall(function() line.Interactable = false end)
    line.Parent = view

    local function MakeGutter(name, color)
     local g = Instance.new("TextLabel")
     g.Name = name
     g.BackgroundTransparency = 1
     g.RichText = false
     g.Text = ""
     g.TextColor3 = color
     g.TextWrapped = false
     g.TextXAlignment = Enum.TextXAlignment.Right
     g.TextYAlignment = Enum.TextYAlignment.Top
     g.AutomaticSize = Enum.AutomaticSize.Y
     g.Position = UDim2.fromOffset(-LAYOUT.Gutter, 0)
     g.Size = UDim2.fromOffset(LAYOUT.Gutter - 16, 0)
     g.Active = false
     g.ZIndex = view.ZIndex + 2
     pcall(function() g.Interactable = false end)
     g.Parent = view
     return g
    end
    local gutter = MakeGutter("VoltGutter", LAYOUT.GutterColor)
    local gutterCur = MakeGutter("VoltGutterCur", LAYOUT.GutterActiveColor)
    gutterCur.Visible = false
    local lastLines = -1

    local function UpdateMin()
     local w = scroller.AbsoluteWindowSize
     view.Size = UDim2.fromOffset(math.max(0, w.X - LAYOUT.PadX - LAYOUT.Gutter), math.max(0, w.Y - LAYOUT.PadY))
    end
    UpdateMin()
    table.insert(conns, scroller:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(UpdateMin))

    view.Parent = scroller

    table.insert(conns, box:GetPropertyChangedSignal("Visible"):Connect(function()
     view.Visible = box.Visible
    end))
    table.insert(conns, box.AncestryChanged:Connect(function()
     if box.Parent == nil then
      active[box] = nil
      padFns[box] = nil
      view:Destroy()
     end
    end))

    padFns[box] = function() UpdateKeyboardPad(view, scroller, box) end

    local placeholder = box.PlaceholderText
    local function HideNativePlaceholder()
     if box.PlaceholderText ~= "" then
      placeholder = box.PlaceholderText
      box.PlaceholderText = ""
     end
    end
    HideNativePlaceholder()

    local pending = false
    local function Render()
     pending = false
     local text = box.Text
     pcall(function()
      view.FontFace = box.FontFace
      view.TextSize = box.TextSize
      view.LineHeight = box.LineHeight
      for _, g in ipairs({ gutter, gutterCur }) do
       g.FontFace = box.FontFace
       g.TextSize = box.TextSize
       g.LineHeight = box.LineHeight
      end
     end)
     local n = 1
     for _ in string.gmatch(text, "\n") do n += 1 end
     if n ~= lastLines then
      lastLines = n
      local t = table.create(n)
      for i = 1, n do t[i] = i end
      gutter.Text = table.concat(t, "\n")
     end
     if text == "" then
      view.RichText = true
      view.Text = '<font color="' .. ToHex(box.PlaceholderColor3) .. '">' .. Esc(placeholder) .. "</font>"
     elseif #text > MAX_CHARS then
      view.RichText = false
      view.Text = text
     else
      view.RichText = true
      view.Text = ToRichText(text)
     end
    end
    Render()

    local version = 0
    local function Update()
     version += 1
     local myVersion = version

     if not box:IsFocused() or box.CursorPosition < 1 then
      fr.Visible = false
      line.Visible = false
      gutterCur.Visible = false
      active[box] = nil
      return
     end

     local text = box.Text
     local cp = math.clamp(box.CursorPosition, 1, #text + 1)
     local before = string.sub(text, 1, cp - 1)
     local _, lineIdx = string.gsub(before, "\n", "")
     local lineStart = string.match(before, ".*\n()") or 1
     local lineStr = string.sub(before, lineStart)

     task.spawn(function()
      local okM, w, h = pcall(Measure, lineStr, box.FontFace, box.TextSize)
      if not okM or myVersion ~= version then return end

      local pitch = GetPitch(probe, box, h)
      local x = w
      local y = lineIdx * pitch + (pitch - h) * CURSOR.YBias
      local pos = UDim2.fromOffset(x, y)

      local ly = lineIdx * pitch
      line.Position = UDim2.fromOffset(-LAYOUT.Gutter, ly)
      line.Size = UDim2.new(1, LAYOUT.Gutter, 0, pitch)
      line.Visible = true
      gutterCur.Text = tostring(lineIdx + 1)
      gutterCur.Position = UDim2.fromOffset(-LAYOUT.Gutter, ly)
      gutterCur.Visible = true

      fr.Size = UDim2.fromOffset(CURSOR.Width, h)
      if CURSOR.Smooth and fr.Visible then
       TweenService:Create(fr, TweenInfo.new(CURSOR.SmoothTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = pos }):Play()
      else
       fr.Position = pos
      end
      fr.Visible = true
      active[box] = fr
      solidUntil = os.clock() + CURSOR.BlinkRate

      if CURSOR.FollowCursor then
       UpdateKeyboardPad(view, scroller, box)
       Settle()
       if myVersion ~= version then return end

       local winPos = scroller.AbsolutePosition
       local winSize = scroller.AbsoluteWindowSize
       local winBottom = winPos.Y + winSize.Y
       local kbTop = KeyboardTop(scroller)
       if kbTop then winBottom = math.min(winBottom, kbTop) end

       local curX = view.AbsolutePosition.X + x
       local curTop = view.AbsolutePosition.Y + y
       local curBottom = curTop + h
       local marginY = pitch * CURSOR.ScrollMarginLines
       local marginX = CURSOR.ScrollMarginX

       local canvas = scroller.CanvasPosition
       local dy, dx = 0, 0
       local fitsY = scroller.AbsoluteCanvasSize.Y <= winSize.Y + 1
       if fitsY then
        if canvas.Y ~= 0 then dy = -canvas.Y end
       elseif curBottom + marginY > winBottom then
        dy = (curBottom + marginY) - winBottom
       elseif curTop - marginY < winPos.Y then
        dy = (curTop - marginY) - winPos.Y
       end
       if curX + marginX > winPos.X + winSize.X then
        dx = (curX + marginX) - (winPos.X + winSize.X)
       elseif curX - marginX < winPos.X then
        dx = (curX - marginX) - winPos.X
       end
       if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
        scroller.CanvasPosition = Vector2.new(math.max(0, canvas.X + dx), math.max(0, canvas.Y + dy))
       end
      end
     end)
    end

    local scheduled, dirtyRender = false, false
    local function Schedule(renderToo)
     if renderToo then dirtyRender = true end
     if scheduled then return end
     scheduled = true
     task.defer(function()
      scheduled = false
      if dirtyRender then
       dirtyRender = false
       Render()
      end
      Update()
     end)
    end
    table.insert(conns, box:GetPropertyChangedSignal("Text"):Connect(function() Schedule(true) end))
    table.insert(conns, box:GetPropertyChangedSignal("TextSize"):Connect(function() Schedule(true) end))
    table.insert(conns, box:GetPropertyChangedSignal("FontFace"):Connect(function() Schedule(true) end))
    table.insert(conns, box:GetPropertyChangedSignal("PlaceholderText"):Connect(function()
     HideNativePlaceholder()
     Schedule(true)
    end))
    table.insert(conns, box:GetPropertyChangedSignal("CursorPosition"):Connect(function() Schedule(false) end))
    table.insert(conns, box.Focused:Connect(function() Schedule(false) end))
    table.insert(conns, box.FocusLost:Connect(function()
     version += 1
     fr.Visible = false
     line.Visible = false
     gutterCur.Visible = false
     active[box] = nil
    end))

    local function FocusAt(guiPos)
     box:CaptureFocus()
     if not CURSOR.TapPlacesCursor then return end
     task.spawn(function()
      local text = box.Text
      if text == "" then return end

      local okM, _, h = pcall(Measure, "A", box.FontFace, box.TextSize)
      if not okM then return end
      local pitch = GetPitch(probe, box, h)
      local relX = guiPos.X - view.AbsolutePosition.X
      local relY = guiPos.Y - view.AbsolutePosition.Y
      local lineNo = math.max(0, math.floor(relY / pitch))

      local startPos, curLine = 1, 0
      while curLine < lineNo do
       local nl = string.find(text, "\n", startPos, true)
       if not nl then break end
       startPos = nl + 1
       curLine += 1
      end
      local nl = string.find(text, "\n", startPos, true)
      local lineStr = string.sub(text, startPos, nl and (nl - 1) or #text)

      local function W(k)
       local okW, width = pcall(Measure, string.sub(lineStr, 1, k), box.FontFace, box.TextSize)
       return okW and width or math.huge
      end

      local lo, hi = 0, #lineStr
      while lo < hi do
       local mid = math.floor((lo + hi) / 2)
       if W(mid) >= relX then hi = mid else lo = mid + 1 end
      end
      local k = lo
      if k > 0 and (relX - W(k - 1)) < (W(k) - relX) then
       k -= 1
      end

      local target = startPos + k
      local tries = 0
      while not box:IsFocused() and tries < 15 do
       RunService.Heartbeat:Wait()
       tries += 1
      end
      Settle()
      if box:IsFocused() then
       box.CursorPosition = target
       RunService.Heartbeat:Wait()
       if box:IsFocused() and box.CursorPosition ~= target then
        box.CursorPosition = target
       end
      end
     end)
    end

    local downPos
    table.insert(conns, view.InputBegan:Connect(function(input)
     if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
      downPos = Vector2.new(input.Position.X, input.Position.Y)
     end
    end))
    table.insert(conns, view.InputEnded:Connect(function(input)
     if not downPos then return end
     if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
      local up = Vector2.new(input.Position.X, input.Position.Y)
      local moved = (up - downPos).Magnitude
      downPos = nil
      if moved <= CURSOR.TapSlop then
       FocusAt(up)
      end
     end
    end))

    local lastCursor, lastSelStart = 1, -1
    table.insert(conns, box:GetPropertyChangedSignal("CursorPosition"):Connect(function()
     if box.CursorPosition >= 1 then
      lastCursor = box.CursorPosition
      lastSelStart = box.SelectionStart
     end
    end))
    table.insert(conns, box:GetPropertyChangedSignal("SelectionStart"):Connect(function()
     if box.CursorPosition >= 1 then lastSelStart = box.SelectionStart end
    end))
    table.insert(conns, box.FocusLost:Connect(function(enterPressed)
     if not enterPressed then return end
     local text = box.Text
     local from = math.clamp(lastCursor, 1, #text + 1)
     local to = from
     if lastSelStart and lastSelStart >= 1 and lastSelStart ~= from then
      from, to = math.min(from, lastSelStart), math.max(from, lastSelStart)
     end
     local newText = string.sub(text, 1, from - 1) .. "\n" .. string.sub(text, to)
     local newCursor = from + 1
     task.defer(function()
      box.Text = newText
      box:CaptureFocus()
      task.wait()
      if box:IsFocused() then box.CursorPosition = newCursor end
      lastCursor = newCursor
      lastSelStart = -1
     end)
    end))
   end

   local function Consider(inst)
    if inst:IsA("TextBox") and inst.MultiLine then
     local p = inst.Parent
     if p and p.Name == "Code" and p:IsA("ScrollingFrame") then
      HookBox(inst)
     end
    end
   end

   for _, inst in ipairs(gethui():GetDescendants()) do
    Consider(inst)
   end
   table.insert(conns, gethui().DescendantAdded:Connect(function(inst)
    task.defer(Consider, inst)
   end))
  end

  SetupEditor()
end

local T = {
 bg = Color3.fromRGB(12, 12, 16),
 panel = Color3.fromRGB(15, 15, 20),
 surface = Color3.fromRGB(20, 20, 27),
 raised = Color3.fromRGB(30, 30, 41),
 border = Color3.fromRGB(34, 34, 46),
 text = Color3.fromRGB(215, 215, 230),
 dim = Color3.fromRGB(110, 110, 128),
 accent = Color3.fromRGB(150, 75, 255),
 accentHi = Color3.fromRGB(172, 112, 255),
 green = Color3.fromRGB(80, 220, 120),
 red = Color3.fromRGB(255, 95, 110),
 orange = Color3.fromRGB(255, 167, 96),
}
local FONT = Enum.Font.GothamMedium
local FONT_B = Enum.Font.GothamBold
local MONO = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local function ToHex(c)
 return string.format("#%02X%02X%02X", math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
end
local function HexToColor3(hex)
 local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
 return Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end
local ESC = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ['"'] = "&quot;", ["'"] = "&apos;" }
local function Esc(s) return (s:gsub("[&<>\"']", ESC)) end

local hasFS = type(writefile) == "function" and type(readfile) == "function" and type(listfiles) == "function"
local SETTINGS_PATH = "Volt/settings.json"
local Settings = {
 antiAfk = false,
 fps = "",
 console = true,
 highlight = true,
 autoSave = true,
 fontSize = "14",
}
pcall(function()
 if hasFS and isfile and isfile(SETTINGS_PATH) then
  local d = HttpService:JSONDecode(readfile(SETTINGS_PATH))
  for k, v in pairs(d) do if Settings[k] ~= nil then Settings[k] = v end end
 end
end)
local function SaveSettings()
 pcall(function()
  if not hasFS then return end
  if makefolder and isfolder and not isfolder("Volt") then makefolder("Volt") end
  writefile(SETTINGS_PATH, HttpService:JSONEncode(Settings))
 end)
end

local function New(class, props, parent)
 local o = Instance.new(class)
 for k, v in pairs(props or {}) do o[k] = v end
 if parent then o.Parent = parent end
 return o
end
local function Corner(o, r) return New("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function Stroke(o, c, t)
 return New("UIStroke", { Color = c or T.border, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end
local function Pad(o, l, t, r, b)
 return New("UIPadding", {
  PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or 0),
  PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0),
 }, o)
end
local function Label(parent, props)
 local d = {
  BackgroundTransparency = 1, BorderSizePixel = 0, Font = FONT, TextSize = 13,
  TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left, Text = "",
 }
 for k, v in pairs(props or {}) do d[k] = v end
 return New("TextLabel", d, parent)
end
local function Button(parent, props, onClick, noHover)
 local d = {
  AutoButtonColor = false, BackgroundColor3 = T.raised, BorderSizePixel = 0,
  Font = FONT, TextSize = 13, TextColor3 = T.text, Text = "",
 }
 for k, v in pairs(props or {}) do d[k] = v end
 local b = New("TextButton", d, parent)
 if not noHover then
  local baseC, baseT = b.BackgroundColor3, b.BackgroundTransparency
  b.MouseEnter:Connect(function()
   baseC, baseT = b.BackgroundColor3, b.BackgroundTransparency
   if baseC == T.accent then b.BackgroundColor3 = T.accentHi
   else b.BackgroundColor3 = T.raised; b.BackgroundTransparency = 0 end
  end)
  b.MouseLeave:Connect(function()
   b.BackgroundColor3, b.BackgroundTransparency = baseC, baseT
  end)
 end
 if onClick then b.Activated:Connect(onClick) end
 return b
end

local function VP()
 local s = Vector2.new(0, 0)
 pcall(function() s = workspace.CurrentCamera.ViewportSize end)
 return s
end

local function Drag(handle, onStart, onMove, onTap)
 local cur, origin, moved
 handle.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
   cur = input
   origin = Vector2.new(input.Position.X, input.Position.Y)
   moved = false
   onStart()
   local c
   c = input.Changed:Connect(function()
    if input.UserInputState == Enum.UserInputState.End then
     c:Disconnect()
     if cur == input then
      cur = nil
      if not moved and onTap then onTap() end
     end
    end
   end)
  end
 end)
 Bind(UIS.InputChanged, function(input)
  if cur and (input == cur or input.UserInputType == Enum.UserInputType.MouseMovement) then
   local d = Vector2.new(input.Position.X, input.Position.Y) - origin
   if d.Magnitude > 4 then moved = true end
   if moved then onMove(d) end
  end
 end)
end

local ICON_URLS = {
 plus = "https://files.catbox.moe/ivkcs9.png",
 x = "https://files.catbox.moe/9zn4ro.png",
 minus = "https://files.catbox.moe/vhpyv6.png",
 max = "https://files.catbox.moe/e4tfbi.png",
 chevup = "https://files.catbox.moe/cx5lhq.png",
 chevdown = "https://files.catbox.moe/rp2tc3.png",
 dots = "https://files.catbox.moe/b2g6uf.png",
 gear = "https://files.catbox.moe/bhwvfl.png",
 hub = "https://files.catbox.moe/cf7ixe.png",
 user = "https://files.catbox.moe/99h0mk.png",
 refresh = "https://files.catbox.moe/6fyf3q.png",
 trash = "https://files.catbox.moe/wwbcf8.png",
 play = "https://files.catbox.moe/sic8gs.png",
 sidebar = "https://files.catbox.moe/80lvvb.png",
 bolt = "https://files.catbox.moe/fmon9x.png",
 search = "https://files.catbox.moe/bhu5hk.png",
}
local iconCache = {}
local function GetIconAsset(kind)
 if iconCache[kind] then return iconCache[kind] end
 local url = ICON_URLS[kind]
 if not hasFS or not url or url == "" then return nil end
 pcall(function()
  if makefolder and isfolder and not isfolder("Volt") then makefolder("Volt") end
  if makefolder and isfolder and not isfolder("Volt/icons") then makefolder("Volt/icons") end
 end)
 local path = "Volt/icons/" .. kind .. ".png"
 if not (isfile and isfile(path)) then
  local ok, body = pcall(function() return game:HttpGet(url) end)
  if not ok or type(body) ~= "string" or #body == 0 then return nil end
  if not pcall(writefile, path, body) then return nil end
 end
 local ok, asset = pcall(getcustomasset, path)
 if ok and type(asset) == "string" and asset ~= "" then
  iconCache[kind] = asset
  return asset
 end
 return nil
end

local function Icon(parent, kind, color, size)
 size = size or 14
 local img = New("ImageLabel", {
  Name = "Icon", BackgroundTransparency = 1, BorderSizePixel = 0,
  AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
  Size = UDim2.fromOffset(size, size), Image = GetIconAsset(kind) or "",
  ImageColor3 = color or Color3.new(1, 1, 1), ScaleType = Enum.ScaleType.Fit,
 }, parent)
 local function SetColor(c) img.ImageColor3 = c end
 return img, SetColor
end

local function IconButton(parent, kind, props, onClick, size, color)
 local b = Button(parent, props, onClick)
 b.Text = ""
 local base = color or T.dim
 local ic, setColor = Icon(b, kind, base, size or 14)
 local locked = false
 b.MouseEnter:Connect(function() if not locked then setColor(color and T.accentHi == color and color or T.text) end end)
 b.MouseLeave:Connect(function() if not locked then setColor(base) end end)
 return b, function(c, lock) locked = lock or false setColor(c or base) end
end

local deltaGui, deltaWasEnabled
do
 for _, g in ipairs(root:GetChildren()) do
  if g:IsA("ScreenGui") and g.Name ~= "VoltUI" and g:FindFirstChild("SidebarHandler", true) then
   deltaGui = g
   break
  end
 end
 if deltaGui then
  deltaWasEnabled = deltaGui.Enabled
  deltaGui.Enabled = false
 end
end

local function Fire(btn)
 if not btn or not getconnections then return false end
 for _, sig in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
  local ok, list = pcall(getconnections, btn[sig])
  if ok and type(list) == "table" and #list > 0 then
   for _, c in ipairs(list) do pcall(function() c:Fire() end) end
   return true
  end
 end
 return false
end
local function DeltaHolder(frameName)
 local f = deltaGui and deltaGui:FindFirstChild(frameName)
 return f and f:FindFirstChild("Holder")
end

local gui = New("ScreenGui", {
 Name = "VoltUI", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 2000,
 ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
gui.Parent = root

local vp0 = VP()
local W0 = math.clamp(math.floor(vp0.X * 0.82), 460, 820)
local H0 = math.clamp(math.floor(vp0.Y * 0.86), 280, 560)

local win = New("Frame", {
 Name = "Window", BackgroundColor3 = T.bg, BorderSizePixel = 0, ClipsDescendants = true,
 Position = UDim2.fromOffset(math.floor((vp0.X - W0) / 2), math.floor((vp0.Y - H0) / 2)),
 Size = UDim2.fromOffset(W0, H0),
}, gui)
Corner(win, 10)
Stroke(win, T.border)

local titlebar = New("Frame", { Name = "TitleBar", BackgroundColor3 = T.bg, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 34) }, win)
New("Frame", { BackgroundColor3 = T.border, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1) }, titlebar)

local logo = New("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(18, 18) }, titlebar)
Icon(logo, "bolt", Color3.new(1, 1, 1), 18)
Label(titlebar, { Name = "Title", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(80, 20), Text = "Volt", Font = FONT_B, TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = T.dim })

local clientName = "client_" .. LP.Name
local chip = Label(titlebar, {
 AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -176, 0.5, 0), Size = UDim2.fromOffset(110, 22),
 Text = clientName, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = T.text,
})

local function WinBtn(kind, fromRight, cb)
 return IconButton(titlebar, kind, {
  AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -fromRight, 0.5, 0), Size = UDim2.fromOffset(28, 24),
  BackgroundTransparency = 1,
 }, cb, 12)
end

local body = New("Frame", { Name = "Body", BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34) }, win)
local sidebar = New("Frame", { Name = "Sidebar", BackgroundColor3 = T.panel, BorderSizePixel = 0, Size = UDim2.new(0, 170, 1, 0), ClipsDescendants = true }, body)
New("Frame", { BackgroundColor3 = T.border, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 1, 1, 0) }, sidebar)
local main = New("Frame", { Name = "Main", BackgroundColor3 = T.bg, BorderSizePixel = 0, Position = UDim2.fromOffset(170, 0), Size = UDim2.new(1, -170, 1, 0), ClipsDescendants = true }, body)

local tabbar = New("Frame", { Name = "TabBar", BackgroundColor3 = T.panel, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 36) }, main)
New("Frame", { BackgroundColor3 = T.border, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1) }, tabbar)
local tabsScroll = New("ScrollingFrame", {
 Name = "Tabs", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, -118, 1, 0),
 CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingDirection = Enum.ScrollingDirection.X,
 ScrollBarThickness = 0,
}, tabbar)
New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder }, tabsScroll)

local content = New("Frame", { Name = "Content", BackgroundColor3 = T.bg, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 36), Size = UDim2.new(1, 0, 1, -36), ClipsDescendants = true }, main)
local term = New("Frame", { Name = "Terminal", BackgroundColor3 = T.panel, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 160), ClipsDescendants = true }, main)
New("Frame", { BackgroundColor3 = T.border, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1) }, term)

local SB_HIDDEN, TERM_MAX = false, false
local showSB = IconButton(main, "sidebar", { Position = UDim2.fromOffset(6, 42), Size = UDim2.fromOffset(26, 26), BackgroundColor3 = T.surface, Visible = false, ZIndex = 4 }, nil, 14)
Corner(showSB, 8)
Stroke(showSB, T.border)
local ApplyLayout
function ApplyLayout()
 showSB.Visible = SB_HIDDEN
 local ws = win.AbsoluteSize
 local sbw = SB_HIDDEN and 0 or math.clamp(math.floor(ws.X * 0.24), 128, 190)
 sidebar.Visible = sbw > 0
 sidebar.Size = UDim2.new(0, sbw, 1, 0)
 main.Position = UDim2.fromOffset(sbw, 0)
 main.Size = UDim2.new(1, -sbw, 1, 0)
 local mh = ws.Y - 34
 local th = 0
 if Settings.console then
  th = TERM_MAX and math.floor(mh * 0.7) or math.clamp(math.floor(mh * 0.34), 96, 220)
 end
 term.Visible = th > 0
 term.Size = UDim2.new(1, 0, 0, th)
 content.Size = UDim2.new(1, 0, 1, -36 - th)
end
Bind(win:GetPropertyChangedSignal("AbsoluteSize"), ApplyLayout)

local bubble = Button(gui, {
 Name = "Bubble", BackgroundColor3 = Color3.fromRGB(30, 30, 30),
 Size = UDim2.fromOffset(44, 44), Position = UDim2.fromOffset(math.max(10, vp0.X - 70), 80), Visible = false, ZIndex = 5,
}, nil, true)
Corner(bubble, 12)
Stroke(bubble, T.accentHi)
Icon(bubble, "bolt", Color3.new(1, 1, 1), 24)

local menuBlocker
local function CloseMenu()
 if menuBlocker then menuBlocker:Destroy() menuBlocker = nil end
end
local function ShowMenu(anchor, items, width)
 CloseMenu()
 width = width or 190
 menuBlocker = New("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 50, AutoButtonColor = false }, gui)
 menuBlocker.Activated:Connect(CloseMenu)
 local pop = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, ZIndex = 51, Size = UDim2.fromOffset(width, #items * 30 + 8) }, menuBlocker)
 Corner(pop, 8)
 Stroke(pop, T.border)
 Pad(pop, 4, 4, 4, 4)
 New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, pop)
 for i, it in ipairs(items) do
  Button(pop, {
   Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = it[1], TextXAlignment = Enum.TextXAlignment.Left,
   TextSize = 12, TextColor3 = it.danger and T.red or T.text, ZIndex = 52, LayoutOrder = i,
  }, function() CloseMenu() task.defer(it[2]) end).Text = "  " .. it[1]
 end
 local ap, as = anchor.AbsolutePosition, anchor.AbsoluteSize
 local v = gui.AbsoluteSize
 local x = math.clamp(ap.X + as.X - width, 6, math.max(6, v.X - width - 6))
 local y = math.clamp(ap.Y + as.Y + 4, 6, math.max(6, v.Y - (#items * 30 + 14)))
 pop.Position = UDim2.fromOffset(x, y)
end

local termHead = New("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 1), Size = UDim2.new(1, 0, 0, 30) }, term)
Label(termHead, { Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(78, 30), Text = "TERMINALS", Font = FONT_B, TextSize = 11, TextColor3 = T.dim })

local termChip = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, Position = UDim2.fromOffset(92, 4), Size = UDim2.fromOffset(106, 22) }, termHead)
Corner(termChip, 6)
Stroke(termChip, T.border)
local dot = New("Frame", { BackgroundColor3 = T.green, BorderSizePixel = 0, Position = UDim2.new(1, -14, 0.5, -3), Size = UDim2.fromOffset(6, 6) }, termChip)
Corner(dot, 3)
Label(termChip, { Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -26, 1, 0), Text = clientName, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd })

local filterMode, filterNames = 1, { "All", "Out", "Warn", "Err" }
local termSearch = ""
local entries, entryCount = {}, 0
local termList = New("ScrollingFrame", {
 BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32),
 CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent,
}, term)
Pad(termList, 12, 2, 12, 6)
New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) }, termList)

local function EntryVisible(e)
 if filterMode == 2 and e.kind ~= "print" then return false end
 if filterMode == 3 and e.kind ~= "warn" then return false end
 if filterMode == 4 and e.kind ~= "error" then return false end
 if termSearch ~= "" and not e.low:find(termSearch, 1, true) then return false end
 return true
end
local function RefilterTerm()
 for _, e in ipairs(entries) do e.label.Visible = EntryVisible(e) end
end
local function ScrollTermDown()
 task.defer(function()
  RunService.Heartbeat:Wait()
  termList.CanvasPosition = Vector2.new(0, math.max(0, termList.AbsoluteCanvasSize.Y - termList.AbsoluteWindowSize.Y))
 end)
end

local KIND_COLOR = { volt = T.accentHi, print = T.text, warn = T.orange, error = T.red }
local function Log(kind, msg)
 msg = tostring(msg)
 if #msg > 3000 then msg = msg:sub(1, 3000) .. " ..." end
 entryCount += 1
 local lbl = New("TextLabel", {
  BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
  TextWrapped = true, RichText = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
  FontFace = MONO, TextSize = 12, LayoutOrder = entryCount,
  Text = string.format('<font color="%s">[%s]</font> <font color="%s">%s</font>', ToHex(T.dim), os.date("%H:%M:%S"), ToHex(KIND_COLOR[kind] or T.text), Esc(msg)),
 }, termList)
 local e = { label = lbl, kind = kind, low = msg:lower() }
 entries[#entries + 1] = e
 lbl.Visible = EntryVisible(e)
 if #entries > 400 then
  local old = table.remove(entries, 1)
  old.label:Destroy()
 end
 ScrollTermDown()
end

local function TermBtn(text, fromRight, w, cb)
 return Button(termHead, {
  AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -fromRight, 0.5, 0), Size = UDim2.fromOffset(w, 22),
  BackgroundTransparency = 1, Text = text, TextSize = 12, TextColor3 = T.dim,
 }, cb)
end
local function TermIcon(kind, fromRight, cb)
 return IconButton(termHead, kind, {
  AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -fromRight, 0.5, 0), Size = UDim2.fromOffset(24, 22),
  BackgroundTransparency = 1,
 }, cb, 12)
end

local refreshers = {}
local function SetConsole(on)
 Settings.console = on
 SaveSettings()
 ApplyLayout()
 for _, r in ipairs(refreshers) do r() end
end
TermIcon("x", 6, function() SetConsole(false) end)
TermIcon("chevup", 32, function()
 TERM_MAX = not TERM_MAX
 ApplyLayout()
end)
TermIcon("trash", 58, function()
 for _, e in ipairs(entries) do e.label:Destroy() end
 table.clear(entries)
end)
local filterBtn
filterBtn = TermBtn("All", 84, 40, function()
 filterMode = filterMode % 4 + 1
 filterBtn.Text = filterNames[filterMode]
 RefilterTerm()
end)
local searchHolder = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -130, 0.5, 0), Size = UDim2.fromOffset(96, 22) }, termHead)
Corner(searchHolder, 6)
Stroke(searchHolder, T.border)
local termBox = New("TextBox", {
 BackgroundTransparency = 1, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(8, 0), Font = FONT, TextSize = 11, TextColor3 = T.text,
 PlaceholderText = "Search...", PlaceholderColor3 = T.dim, Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
}, searchHolder)
termBox:GetPropertyChangedSignal("Text"):Connect(function()
 termSearch = termBox.Text:lower()
 RefilterTerm()
end)
local function TermResponsive()
 termChip.Visible = main.AbsoluteSize.X > 500
end
Bind(main:GetPropertyChangedSignal("AbsoluteSize"), TermResponsive)

Bind(LogService.MessageOut, function(msg, mt)
 local kind = "print"
 if mt == Enum.MessageType.MessageWarning then kind = "warn"
 elseif mt == Enum.MessageType.MessageError then kind = "error" end
 Log(kind, msg)
end)

local function ListDir(dir)
 local out = {}
 if not hasFS then return out end
 local ok, list = false, nil
 local cands = (dir == "") and { "", ".", "./" } or { dir }
 for _, d in ipairs(cands) do
  ok, list = pcall(listfiles, d)
  if ok and type(list) == "table" then break end
 end
 if not ok or type(list) ~= "table" then return out end
 for _, full in ipairs(list) do
  local name = tostring(full):match("[^/\\]+$")
  local low = name and name:lower() or ""
  if name and (low:match("%.lua$") or low:match("%.luau$") or low:match("%.txt$")) then
   local isF = true
   if isfile then
    local o, r = pcall(isfile, full)
    if o then isF = r end
   end
   if isF then
    out[#out + 1] = { name = name, path = (dir == "") and name or (dir .. "/" .. name) }
   end
  end
 end
 table.sort(out, function(a, b) return a.name:lower() < b.name:lower() end)
 return out
end

local pages = {}
local function MakePage(name)
 local p = New("Frame", { Name = name, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false }, content)
 pages[name] = p
 return p
end
local pageEditor, pageWelcome, pageHub, pageSettings = MakePage("editor"), MakePage("welcome"), MakePage("hub"), MakePage("settings")

local codeScroll = New("ScrollingFrame", {
 Name = "Code", BackgroundColor3 = T.bg, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1),
 CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.XY, ScrollingDirection = Enum.ScrollingDirection.XY,
 ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent, ClipsDescendants = true,
}, pageEditor)
local codeBox = New("TextBox", {
 Name = "Editor", MultiLine = true, ClearTextOnFocus = false, TextEditable = true, BackgroundTransparency = 1,
 Font = Enum.Font.Code, TextSize = tonumber(Settings.fontSize) or 14, TextColor3 = T.text,
 TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
 PlaceholderText = "-- Write your script here", PlaceholderColor3 = T.dim, Text = "", Size = UDim2.fromOffset(0, 0),
}, codeScroll)

if deltaGui then
 pcall(function()
  local code = deltaGui:FindFirstChild("Code", true)
  local src
  if code then
   for _, tb in ipairs(code:GetChildren()) do
    if tb:IsA("TextBox") then src = tb if tb.Visible then break end end
   end
  end
  if src then
   for _, prop in ipairs({ "MultiLine", "TextWrapped", "ClearTextOnFocus", "TextEditable", "RichText", "TextScaled", "TextTruncate", "Selectable", "Active", "Interactable", "AutoLocalize" }) do
    pcall(function() codeBox[prop] = src[prop] end)
   end
  end
 end)
end

local tabs, activeTab = {}, nil
local loadingText = false
local RenderTabs, ActivateTab, RefreshFiles

local function ShowPage(name)
 for n, p in pairs(pages) do p.Visible = (n == name) end
end

local function FindTab(pred)
 for _, t in ipairs(tabs) do if pred(t) then return t end end
end

local function OpenPage(kind)
 local t = FindTab(function(x) return x.kind == kind end)
 if not t then
  local names = { welcome = "Welcome", hub = "Script Hub", settings = "Settings" }
  t = { kind = kind, name = names[kind] }
  tabs[#tabs + 1] = t
 end
 ActivateTab(t)
end

local function NewFileTab(name, path, text)
 local t = { kind = "file", name = name, path = path, text = text or "", saveToken = 0 }
 tabs[#tabs + 1] = t
 ActivateTab(t)
 return t
end

local function CloseTab(t)
 local idx = table.find(tabs, t)
 if not idx then return end
 table.remove(tabs, idx)
 if activeTab == t then
  activeTab = nil
  local nxt = tabs[idx] or tabs[idx - 1]
  if nxt then ActivateTab(nxt) else OpenPage("welcome") end
 else
  RenderTabs()
 end
 if RefreshFiles then RefreshFiles() end
end

function ActivateTab(t)
 activeTab = t
 if t.kind == "file" then
  loadingText = true
  codeBox.Text = t.text
  loadingText = false
  codeScroll.CanvasPosition = Vector2.new(0, 0)
  ShowPage("editor")
 else
  ShowPage(t.kind)
 end
 RenderTabs()
 if RefreshFiles then RefreshFiles() end
end

function RenderTabs()
 for _, c in ipairs(tabsScroll:GetChildren()) do
  if c:IsA("GuiObject") then c:Destroy() end
 end
 for i, t in ipairs(tabs) do
  local active = (t == activeTab)
  local w = math.clamp(TextService:GetTextSize(t.name, 12, FONT, Vector2.new(1000, 30)).X + 56, 96, 230)
  local b = Button(tabsScroll, {
   Size = UDim2.new(0, w, 1, 0), BackgroundColor3 = T.bg, BackgroundTransparency = active and 0 or 1, LayoutOrder = i,
  }, function() ActivateTab(t) end, true)
  local ic = New("Frame", { BackgroundColor3 = (t.kind == "file") and T.dim or T.accent, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 13), Size = UDim2.fromOffset(10, 10) }, b)
  Corner(ic, t.kind == "file" and 2 or 5)
  Label(b, { Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -56, 1, 0), Text = t.name, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = active and T.text or T.dim })
  IconButton(b, "x", {
   AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), Size = UDim2.fromOffset(20, 20),
   BackgroundTransparency = 1,
  }, function() CloseTab(t) end, 9)
  if active then
   New("Frame", { BackgroundColor3 = T.accent, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 2) }, b)
  end
 end
end

local files, autoFiles = {}, {}
local fileSearch = ""

local function QueueSave(t)
 if t.kind ~= "file" or not t.path or t.noSave or not hasFS or not Settings.autoSave then return end
 t.saveToken = (t.saveToken or 0) + 1
 local my = t.saveToken
 task.delay(0.8, function()
  if t.saveToken == my then pcall(writefile, t.path, t.text) end
 end)
end

Bind(codeBox:GetPropertyChangedSignal("Text"), function()
 if loadingText or not activeTab or activeTab.kind ~= "file" then return end
 activeTab.text = codeBox.Text
 QueueSave(activeTab)
end)

local function OpenFile(path, name)
 local t = FindTab(function(x) return x.kind == "file" and x.path == path end)
 if t then ActivateTab(t) return end
 local ok, data = pcall(readfile, path)
 if not ok then
  Log("error", "Could not read " .. path)
  return
 end
 NewFileTab(name, path, data)
end

local function UniqueName(base)
 local stem, ext = base:match("^(.*)(%.[^.]+)$")
 if not stem then stem, ext = base, ".lua" end
 local taken = {}
 for _, f in ipairs(files) do taken[f.name:lower()] = true end
 for _, t in ipairs(tabs) do if t.kind == "file" then taken[t.name:lower()] = true end end
 local n, name = 0, stem .. ext
 while taken[name:lower()] do
  n += 1
  name = stem .. n .. ext
 end
 return name
end

local function CreateFile(base, text)
 local name = UniqueName(base)
 NewFileTab(name, nil, text or "")
 return name
end

local function SaveActive()
 local t = activeTab
 if not t or t.kind ~= "file" then return end
 if t.path then
  if pcall(writefile, t.path, t.text) then Log("volt", "Saved " .. t.name) end
 elseif hasFS then
  local name = UniqueName(t.name)
  if pcall(writefile, name, t.text) then
   t.name, t.path = name, name
   RenderTabs()
   RefreshFiles()
   Log("volt", "Saved " .. name)
  end
 else
  Log("warn", "This executor has no file system, cannot save.")
 end
end

local function SideBtn(kind, x, cb, round)
 local b = IconButton(sidebar, kind, { Position = UDim2.fromOffset(x, 8), Size = UDim2.fromOffset(28, 28), BackgroundColor3 = T.surface }, cb, 14)
 Corner(b, round or 8)
 return b
end
SideBtn("sidebar", 10, function() SB_HIDDEN = true ApplyLayout() end)
SideBtn("gear", 42, function() OpenPage("settings") end, 14)
SideBtn("hub", 74, function() OpenPage("hub") end)

Label(sidebar, { Position = UDim2.fromOffset(12, 46), Size = UDim2.fromOffset(70, 22), Text = "EXPLORER", Font = FONT_B, TextSize = 11, TextColor3 = T.text })
local function ExpBtn(kind, fromRight, cb)
 return IconButton(sidebar, kind, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -fromRight, 0, 46), Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1 }, cb, 13)
end

local searchFrame = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, Position = UDim2.fromOffset(8, 72), Size = UDim2.new(1, -16, 0, 28) }, sidebar)
Corner(searchFrame, 8)
Stroke(searchFrame, T.border)
local fileSearchBox = New("TextBox", {
 BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -16, 1, 0), Font = FONT, TextSize = 12, TextColor3 = T.text,
 PlaceholderText = "Search", PlaceholderColor3 = T.dim, Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
}, searchFrame)

local filesLabel = Label(sidebar, { Position = UDim2.fromOffset(12, 108), Size = UDim2.fromOffset(100, 16), Text = deltaGui and "SCRIPTS" or "FILES", Font = FONT_B, TextSize = 10, TextColor3 = T.dim })
local fileList = New("ScrollingFrame", {
 BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 126), Size = UDim2.new(1, -1, 1, -126 - 104),
 CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = T.accent,
}, sidebar)
New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, fileList)
Label(sidebar, { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -86), Size = UDim2.fromOffset(120, 16), Text = "AUTO EXECUTION", Font = FONT_B, TextSize = 10, TextColor3 = T.dim })
local autoList = New("ScrollingFrame", {
 BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, -1, 0, 82),
 CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = T.accent,
}, sidebar)
New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, autoList)

local function ListDeltaScripts()
 local out = {}
 local h = DeltaHolder("Home")
 if not h then return out end
 for _, row in ipairs(h:GetChildren()) do
  if row:IsA("GuiObject") and row.Name == "Script" then
   local t = row:FindFirstChild("Title")
   local name = (t and t:IsA("TextLabel") and t.Text ~= "") and t.Text or "script"
   local btns = {}
   for _, d in ipairs(row:GetDescendants()) do
    if d:IsA("TextLabel") then
     local u = d.Text:upper()
     local b = d:FindFirstAncestorWhichIsA("GuiButton")
     if b then
      if u:find("EXECUTE", 1, true) then btns.exec = b
      elseif u:find("DELETE", 1, true) then btns.del = b
      elseif u:find("EDIT", 1, true) or u:find("OPEN", 1, true) then btns.edit = b end
     end
    end
   end
   out[#out + 1] = { name = name, row = row, btns = btns, delta = true }
  end
 end
 table.sort(out, function(a, b) return a.name:lower() < b.name:lower() end)
 return out
end

local function ReadDeltaEditor(preferred)
 local code = deltaGui and deltaGui:FindFirstChild("Code", true)
 if not code then return nil end
 local best
 for _, tb in ipairs(code:GetChildren()) do
  if tb:IsA("TextBox") and tb.Visible then
   best = tb
   if tb.Name:lower() == (preferred or ""):lower() then break end
  end
 end
 if best then return best.Text, best.Name end
end

local function OpenDeltaScript(f)
 if not f.btns.edit then
  Log("warn", '"' .. f.name .. '" has no edit button in Delta, use the play button to run it.')
  return
 end
 Fire(f.btns.edit)
 task.spawn(function()
  local txt, tname
  for _ = 1, 20 do
   task.wait(0.1)
   txt, tname = ReadDeltaEditor(f.name)
   if txt and txt ~= "" and tname and tname:lower() == f.name:lower() then break end
  end
  if txt and txt ~= "" then
   local t = NewFileTab(f.name, nil, txt)
   t.noSave = true
  else
   Log("warn", "Could not read " .. f.name .. " from Delta's editor.")
  end
 end)
end

local armed
local function FileRow(parent, f, order, deletable)
 local isActive = f.path and activeTab and activeTab.kind == "file" and activeTab.path == f.path
 local row = Button(parent, {
  Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.surface, BackgroundTransparency = isActive and 0 or 1, LayoutOrder = order,
 }, function()
  if f.delta then OpenDeltaScript(f) else OpenFile(f.path, f.name) end
 end)
 local ic = New("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 7), Size = UDim2.fromOffset(11, 14) }, row)
 Corner(ic, 2)
 Stroke(ic, isActive and T.accentHi or T.dim, 1.5)
 local right = 0
 local function ArmDelete(btn, setColor, doDelete)
  if armed == btn then
   armed = nil
   doDelete()
  else
   armed = btn
   setColor(T.red, true)
   task.delay(2.5, function()
    if armed == btn then armed = nil end
    if btn.Parent then setColor(nil, false) end
   end)
  end
 end
 if f.delta then
  if f.btns.del then
   right += 26
   local del, setC
   del, setC = IconButton(row, "trash", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1 }, function()
    ArmDelete(del, setC, function()
     Fire(f.btns.del)
     task.delay(0.5, RefreshFiles)
    end)
   end, 11)
  end
  if f.btns.exec then
   right += 26
   IconButton(row, "play", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4 - (right - 26), 0.5, 0), Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1 }, function()
    Log("volt", "Executing " .. f.name)
    Fire(f.btns.exec)
   end, 11, T.accentHi)
  end
 elseif deletable and delfile then
  right += 26
  local del, setC
  del, setC = IconButton(row, "x", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1 }, function()
   ArmDelete(del, setC, function()
    pcall(delfile, f.path)
    local t = FindTab(function(x) return x.kind == "file" and x.path == f.path end)
    if t then CloseTab(t) else RefreshFiles() end
   end)
  end, 10)
 end
 Label(row, { Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -40 - right, 1, 0), Text = f.name, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = isActive and T.text or Color3.fromRGB(170, 170, 188) })
end

local homeHooked = false
function RefreshFiles()
 files = deltaGui and ListDeltaScripts() or ListDir("")
 autoFiles = ListDir("autoexec")
 for _, l in ipairs({ fileList, autoList }) do
  for _, c in ipairs(l:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 end
 local q = fileSearch:lower()
 local shown = 0
 for i, f in ipairs(files) do
  if q == "" or f.name:lower():find(q, 1, true) then
   shown += 1
   FileRow(fileList, f, i, true)
  end
 end
 if shown == 0 then
  Label(fileList, { Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(12, 0), Text = (deltaGui or hasFS) and "No files found" or "No file system", TextSize = 11, TextColor3 = T.dim })
 end
 for i, f in ipairs(autoFiles) do FileRow(autoList, f, i, false) end
 if #autoFiles == 0 then
  Label(autoList, { Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(12, 0), Text = "No files found", TextSize = 11, TextColor3 = T.dim })
 end
 if not homeHooked then
  local h = DeltaHolder("Home")
  if h then
   homeHooked = true
   local function Later() task.delay(0.3, RefreshFiles) end
   Bind(h.ChildAdded, Later)
   Bind(h.ChildRemoved, Later)
  end
 end
end
Bind(fileSearchBox:GetPropertyChangedSignal("Text"), function()
 fileSearch = fileSearchBox.Text
 RefreshFiles()
end)

local function Execute(src, label)
 if type(src) ~= "string" or src:match("^%s*$") then
  Log("warn", "Nothing to execute.")
  return
 end
 local fn, err = loadstring(src)
 if not fn then
  Log("error", tostring(err))
  return
 end
 task.spawn(function()
  local ok, e = pcall(fn)
  if not ok then Log("error", tostring(e)) end
 end)
end

local function RunActive()
 if activeTab and activeTab.kind == "file" then
  Execute(codeBox.Text, activeTab.name)
  return
 end
 for _, t in ipairs(tabs) do
  if t.kind == "file" then ActivateTab(t) Execute(t.text, t.name) return end
 end
 Log("warn", "Open a file to run it.")
end

local function Clipboard(set, text)
 if set then
  local f = setclipboard or toclipboard or set_clipboard
  if f then return pcall(f, text) end
  return false
 end
 local g = getclipboard or get_clipboard
 if g then
  local ok, r = pcall(g)
  if ok then return r end
 end
end

local function LabelOf(b)
 local t = b:FindFirstChildWhichIsA("TextLabel", true)
 return t and t.Text:upper() or ""
end
local function InHub(o)
 local p = o.Parent
 while p and p ~= deltaGui do
  if p.Name == "Home" or p.Name == "Hub" or p.Name == "Holder" then return true end
  p = p.Parent
 end
 return false
end

local function FindDeltaClipboardBtn()
 if not deltaGui then return nil end
 local executeBtn
 for _, d in ipairs(deltaGui:GetDescendants()) do
  if d:IsA("TextLabel") and not InHub(d) then
   local u = d.Text:upper()
   local b = d:FindFirstAncestorWhichIsA("GuiButton")
   if b then
    if u:find("EXECUTE", 1, true) and u:find("CLIPBOARD", 1, true) then return b end
    if u == "EXECUTE" and not executeBtn then executeBtn = b end
   end
  end
 end
 if executeBtn and executeBtn.Parent then
  local pick, count = nil, 0
  for _, sib in ipairs(executeBtn.Parent:GetChildren()) do
   if sib:IsA("GuiButton") and sib ~= executeBtn then
    local l = LabelOf(sib)
    if l:find("CLIP", 1, true) then return sib end
    if l ~= "CLEAR" then pick, count = sib, count + 1 end
   end
  end
  if count == 1 then return pick end
 end
 for _, d in ipairs(deltaGui:GetDescendants()) do
  if d:IsA("GuiButton") and not InHub(d) then
   local n = d.Name:lower()
   if n:find("exec", 1, true) and n:find("clip", 1, true) then return d end
  end
 end
end

local function ExecClipboard()
 local dBtn = FindDeltaClipboardBtn()
 if dBtn then
  local fired = Fire(dBtn)
  if not fired and firesignal then
   for _, sig in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
    if pcall(firesignal, dBtn[sig]) then fired = true break end
   end
  end
  if fired then
   Log("volt", "Executing clipboard")
   return
  end
  Log("warn", "Found Delta's button (" .. dBtn:GetFullName() .. ") but couldn't fire it, using Volt's runner.")
 else
  Log("warn", "Delta's Execute Clipboard button not found, using Volt's runner.")
 end
 local c = Clipboard(false)
 if type(c) == "string" and c ~= "" then Execute(c, "clipboard") else Log("warn", "Clipboard is empty or unavailable.") end
end

local runBtn = Button(tabbar, {
 AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -40, 0.5, 0), Size = UDim2.fromOffset(66, 26),
 BackgroundColor3 = T.accent,
}, RunActive)
Corner(runBtn, 8)
local runIc = Icon(runBtn, "play", Color3.new(1, 1, 1), 12)
runIc.Position = UDim2.fromOffset(16, 13)
Label(runBtn, { Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -30, 1, 0), Text = "Run", Font = FONT_B, TextSize = 13, TextColor3 = Color3.new(1, 1, 1) })

local Minimize, SwitchToUpdated

do
 local sc = New("ScrollingFrame", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = T.accent }, pageWelcome)
 Pad(sc, 24, 22, 24, 22)
 New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, sc)
 Label(sc, { LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 36), Text = "Volt", Font = FONT_B, TextSize = 30, TextColor3 = T.text })
 local exName, exVer = "unknown executor", ""
 pcall(function() if identifyexecutor then exName, exVer = identifyexecutor() end end)
 Label(sc, { LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 18), Text = "Running on " .. tostring(exName) .. (exVer and exVer ~= "" and (" " .. tostring(exVer)) or ""), TextSize = 12, TextColor3 = T.dim })
 local grid = New("Frame", { LayoutOrder = 3, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 150) }, sc)
 New("UIGridLayout", { CellSize = UDim2.new(0.5, -5, 0, 68), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
 local function Card(title, desc, order, cb)
  local c = Button(grid, { BackgroundColor3 = T.surface, LayoutOrder = order }, cb)
  Corner(c, 10)
  Stroke(c, T.border)
  Label(c, { Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -28, 0, 18), Text = title, Font = FONT_B, TextSize = 14 })
  Label(c, { Position = UDim2.fromOffset(14, 32), Size = UDim2.new(1, -28, 0, 28), Text = desc, TextSize = 11, TextColor3 = T.dim, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })
 end
 Card("Script Hub", "Search and run scripts from ScriptBlox", 1, function() OpenPage("hub") end)
 Card("Settings", "Delta's settings plus editor options", 2, function() OpenPage("settings") end)
 Card("Console", "Show or hide the terminal", 3, function() SetConsole(not Settings.console) end)
 Card("Delta Version", "Switch to the new Delta reskin", 4, function() SwitchToUpdated() end)
end

do
 local sc = New("ScrollingFrame", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = T.accent }, pageSettings)
 Pad(sc, 18, 16, 18, 16)
 New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }, sc)
 Label(sc, { LayoutOrder = 0, Size = UDim2.new(1, 0, 0, 26), Text = "Settings", Font = FONT_B, TextSize = 18 })

 local sf = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 1 }, sc)
 Corner(sf, 8)
 Stroke(sf, T.border)
 local sIc = Icon(sf, "search", T.dim, 13)
 sIc.Position = UDim2.fromOffset(18, 16)
 local sBox = New("TextBox", {
  BackgroundTransparency = 1, Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -44, 1, 0), Font = FONT, TextSize = 12, TextColor3 = T.text,
  PlaceholderText = "Search settings", PlaceholderColor3 = T.dim, Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
 }, sf)

 local order = 1
 local rows = {}
 local function Header(text)
  order += 1
  Label(sc, { LayoutOrder = order, Size = UDim2.new(1, 0, 0, 20), Text = text, Font = FONT_B, TextSize = 10, TextColor3 = T.dim })
 end
 local function Row(title, desc)
  order += 1
  local r = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 56), LayoutOrder = order }, sc)
  Corner(r, 8)
  Stroke(r, T.border)
  Label(r, { Position = UDim2.fromOffset(14, 9), Size = UDim2.new(1, -170, 0, 18), Text = title, Font = FONT_B, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd })
  Label(r, { Position = UDim2.fromOffset(14, 28), Size = UDim2.new(1, -170, 0, 18), Text = desc or "", TextSize = 11, TextColor3 = T.dim, TextTruncate = Enum.TextTruncate.AtEnd })
  rows[#rows + 1] = { frame = r, key = ((title or "") .. " " .. (desc or "")):lower() }
  return r
 end
 Bind(sBox:GetPropertyChangedSignal("Text"), function()
  local q = sBox.Text:lower()
  for _, r in ipairs(rows) do r.frame.Visible = (q == "") or (r.key:find(q, 1, true) ~= nil) end
 end)

 local function Pill(row, getState, onClick)
  local sw = Button(row, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(42, 22) }, nil, true)
  Corner(sw, 11)
  local knob = New("Frame", { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Size = UDim2.fromOffset(16, 16) }, sw)
  Corner(knob, 8)
  local function Refresh()
   local on = getState()
   sw.BackgroundColor3 = on and T.accent or T.border
   knob.Position = on and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
  end
  sw.Activated:Connect(onClick)
  Refresh()
  return Refresh
 end
 local function Toggle(row, key, onChange)
  local Refresh
  Refresh = Pill(row, function() return Settings[key] end, function()
   Settings[key] = not Settings[key]
   SaveSettings()
   Refresh()
   if onChange then onChange(Settings[key]) end
  end)
  refreshers[#refreshers + 1] = Refresh
 end
 local function Segmented(row, key, options, onChange)
  local holder = New("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(#options * 50 - 4, 26) }, row)
  New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, holder)
  local btns = {}
  local function Refresh()
   for opt, b in pairs(btns) do
    local on = tostring(Settings[key]) == opt
    b.BackgroundColor3 = on and T.accent or T.raised
    b.TextColor3 = on and Color3.new(1, 1, 1) or T.dim
   end
  end
  for _, opt in ipairs(options) do
   local b = Button(holder, { Size = UDim2.fromOffset(46, 26), Text = opt, TextSize = 12 }, function()
    Settings[key] = opt
    SaveSettings()
    Refresh()
    if onChange then onChange(opt) end
   end, true)
   Corner(b, 6)
   btns[opt] = b
  end
  Refresh()
 end
 local function ActionBtn(row, text, cb)
  local w = math.max(86, TextService:GetTextSize(text, 11, FONT_B, Vector2.new(400, 30)).X + 26)
  local b = Button(row, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(w, 28), BackgroundColor3 = T.accent, Text = text, Font = FONT_B, TextSize = 11, TextColor3 = Color3.new(1, 1, 1) }, cb)
  Corner(b, 7)
  return b
 end

 Header("VOLT")
 Toggle(Row("Console", "Show the terminal panel"), "console", function() ApplyLayout() end)
 Toggle(Row("Syntax Highlighting", "Colour the editor (large scripts skip it)"), "highlight", function() if env.__VoltRerender then env.__VoltRerender() end end)
 Toggle(Row("Auto Save", "Save workspace files while typing"), "autoSave")
 Segmented(Row("Editor Font Size", "Text size in the code editor"), "fontSize", { "12", "14", "16" }, function(v) codeBox.TextSize = tonumber(v) or 14 end)

 local holder = DeltaHolder("Settings")
 if holder then
  Header("DELTA")
  local list = {}
  for i, d in ipairs(holder:GetChildren()) do
   if d:IsA("Frame") and d:FindFirstChild("Title") and (d.Name:match("^SettingSwitch") or d.Name == "SettingDropdown" or d.Name == "Button") then
    list[#list + 1] = { d = d, i = i }
   end
  end
  table.sort(list, function(a, b)
   if a.d.LayoutOrder ~= b.d.LayoutOrder then return a.d.LayoutOrder < b.d.LayoutOrder end
   return a.i < b.i
  end)

  local function TextOf(o) return (o and o:IsA("TextLabel")) and o.Text or "" end
  for _, e in ipairs(list) do
   local d = e.d
   local row = Row(TextOf(d:FindFirstChild("Title")), TextOf(d:FindFirstChild("Desc")))

   if d.Name:match("^SettingSwitch") then
    local sw = d:FindFirstChild("Switch")
    local knob = sw and sw:FindFirstChildWhichIsA("ImageLabel")
    local ev = d:FindFirstChild("Enabled")
    local Refresh
    local function State()
     if knob then return knob.Position.X.Scale > 0.5 end
     return ev and ev:IsA("BoolValue") and ev.Value or false
    end
    Refresh = Pill(row, State, function()
     Fire(sw)
     task.delay(0.15, Refresh)
     task.delay(0.5, Refresh)
    end)
    if knob then Bind(knob:GetPropertyChangedSignal("Position"), function() task.defer(Refresh) end) end
    if ev and ev:IsA("BoolValue") then Bind(ev.Changed, function() task.defer(Refresh) end) end

   elseif d.Name == "SettingDropdown" then
    local btn = d:FindFirstChild("Button")
    local cur = btn and btn:FindFirstChild("Title")
    local dd = d:FindFirstChild("Dropdown")
    local opts = {}
    if dd then
     for _, o in ipairs(dd:GetChildren()) do
      if o.Name:match("^Option") then opts[#opts + 1] = o end
     end
     table.sort(opts, function(a, b) return a.Name < b.Name end)
    end
    local ctrl = Button(row, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(108, 28), BackgroundColor3 = T.raised, Text = "" })
    Corner(ctrl, 7)
    Stroke(ctrl, T.border)
    local lbl = Label(ctrl, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -30, 1, 0), Text = TextOf(cur), TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd })
    local cv = Icon(ctrl, "chevdown", T.dim, 11)
    cv.Position = UDim2.new(1, -13, 0.5, 0)
    if cur then Bind(cur:GetPropertyChangedSignal("Text"), function() lbl.Text = cur.Text end) end
    ctrl.Activated:Connect(function()
     local items = {}
     for _, o in ipairs(opts) do
      local name = TextOf(o:FindFirstChild("Title"))
      items[#items + 1] = { ((name == TextOf(cur)) and "> " or "   ") .. name, function()
       Fire(o)
       task.delay(0.25, function()
        if dd and dd.Visible then Fire(btn) end
        if cur then lbl.Text = cur.Text end
       end)
      end }
     end
     if #items > 0 then ShowMenu(ctrl, items, 170) end
    end)

   else
    local b = d:FindFirstChild("Button")
    local inner = b and b:FindFirstChild("Title")
    ActionBtn(row, (inner and inner.Text ~= "") and inner.Text or "RUN", function() Fire(b) end)
   end
  end
 else
  Header("GAME")
  local afkConn
  local function ApplyAfk()
   if afkConn then afkConn:Disconnect() afkConn = nil end
   if Settings.antiAfk then
    afkConn = LP.Idled:Connect(function()
     pcall(function()
      local VU = game:GetService("VirtualUser")
      VU:CaptureController()
      VU:ClickButton2(Vector2.new())
     end)
    end)
   end
  end
  env.__VoltAfkStop = function() if afkConn then afkConn:Disconnect() afkConn = nil end end
  Toggle(Row("Anti AFK", "Disable idle timeout kicks"), "antiAfk", ApplyAfk)
  Segmented(Row("FPS Cap", "Change the FPS cap"), "fps", { "60", "120", "Max" }, function(v)
   if setfpscap then pcall(setfpscap, (v == "Max") and 0 or tonumber(v)) end
  end)
  ActionBtn(Row("Rejoin", "Rejoins your current server"), "REJOIN", function()
   pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)
  end)
  if Settings.antiAfk then ApplyAfk() end
 end
end

do
 local hubSearchFrame = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -28, 0, 34) }, pageHub)
 Corner(hubSearchFrame, 8)
 Stroke(hubSearchFrame, T.border)
 local hubBox = New("TextBox", {
  BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 1, 0), Font = FONT, TextSize = 13, TextColor3 = T.text,
  PlaceholderText = "Search scripts (ScriptBlox)...", PlaceholderColor3 = T.dim, Text = "", ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
 }, hubSearchFrame)
 local status = Label(pageHub, { Position = UDim2.fromOffset(16, 52), Size = UDim2.new(1, -32, 0, 16), Text = "", TextSize = 11, TextColor3 = T.dim })
 local list = New("ScrollingFrame", {
  BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 72), Size = UDim2.new(1, 0, 1, -72),
  CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent,
 }, pageHub)
 Pad(list, 14, 0, 14, 12)
 New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }, list)

 local hub = { page = 1, total = 1, query = "", token = 0 }

 local function HttpGetSafe(url)
  local ok, res = pcall(function() return game:HttpGet(url) end)
  if ok and type(res) == "string" and #res > 0 then return res end
  local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request) or httprequest
  if req then
   local ok2, r = pcall(req, { Url = url, Method = "GET" })
   if ok2 and r and r.Body then return r.Body end
  end
  return nil, tostring(res)
 end
 local function GetJson(url)
  local body, err = HttpGetSafe(url)
  if not body then return nil, err end
  local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
  if ok then return data end
  return nil, "bad response"
 end
 local function GetSource(item)
  if type(item.script) == "string" and item.script ~= "" then return item.script end
  if item.slug then
   local d = GetJson("https://scriptblox.com/api/script/" .. HttpService:UrlEncode(item.slug))
   local s = d and d.script and d.script.script
   if type(s) == "string" then return s end
  end
 end
 local function Fmt(n)
  n = tonumber(n) or 0
  if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
  if n >= 1e3 then return string.format("%.1fk", n / 1e3) end
  return tostring(n)
 end

 local function AddCard(item, order)
  local card = New("Frame", { BackgroundColor3 = T.surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 88), LayoutOrder = order }, list)
  Corner(card, 10)
  Stroke(card, T.border)
  Label(card, { Position = UDim2.fromOffset(12, 8), Size = UDim2.new(1, -24, 0, 18), Text = tostring(item.title or "Untitled"), Font = FONT_B, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd })
  local gname = item.game and item.game.name or (item.isUniversal and "Universal") or "Unknown game"
  local meta = Esc(tostring(gname)) .. "  -  " .. Fmt(item.views) .. " views"
  if item.verified then meta = meta .. '  -  <font color="' .. ToHex(T.green) .. '">VERIFIED</font>' end
  if item.key then meta = meta .. '  -  <font color="' .. ToHex(T.orange) .. '">KEY</font>' end
  Label(card, { Position = UDim2.fromOffset(12, 28), Size = UDim2.new(1, -24, 0, 16), Text = meta, RichText = true, TextSize = 11, TextColor3 = T.dim, TextTruncate = Enum.TextTruncate.AtEnd })

  local function Act(text, x, w, primary, fn)
   local b = Button(card, { Position = UDim2.fromOffset(x, 54), Size = UDim2.fromOffset(w, 26), BackgroundColor3 = primary and T.accent or T.raised, Text = text, Font = FONT_B, TextSize = 11, TextColor3 = primary and Color3.new(1, 1, 1) or T.text }, function()
    task.spawn(function()
     local src = GetSource(item)
     if not src then Log("error", "Could not fetch script source for " .. tostring(item.title)) return end
     fn(src)
    end)
   end)
   Corner(b, 6)
  end
  Act("EXECUTE", 12, 82, true, function(src) Execute(src, tostring(item.title)) end)
  Act("EDIT", 100, 62, false, function(src)
   local safe = tostring(item.title or "script"):gsub("[^%w%-_ ]", ""):gsub("%s+", "_"):sub(1, 32)
   if safe == "" then safe = "script" end
   CreateFile(safe .. ".lua", src)
  end)
  Act("COPY", 168, 62, false, function(src)
   if Clipboard(true, src) then Log("volt", "Copied " .. tostring(item.title)) else Log("warn", "Clipboard is unavailable.") end
  end)
 end

 local moreBtn
 local function Fetch(reset)
  hub.token += 1
  local my = hub.token
  if reset then
   hub.page, hub.total = 1, 1
   for _, c in ipairs(list:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
  end
  if moreBtn then moreBtn:Destroy() moreBtn = nil end
  status.Text = (hub.query ~= "") and "Searching..." or "Loading latest scripts..."
  task.spawn(function()
   local url
   if hub.query ~= "" then
    url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(hub.query) .. "&mode=free&page=" .. hub.page
   else
    url = "https://scriptblox.com/api/script/fetch?page=" .. hub.page
   end
   local data, err = GetJson(url)
   if my ~= hub.token then return end
   local scripts = data and data.result and data.result.scripts
   if type(scripts) ~= "table" then
    status.Text = "Failed to load scripts" .. (err and (": " .. tostring(err):sub(1, 60)) or "")
    return
   end
   hub.total = tonumber(data.result.totalPages) or 1
   local base = (hub.page - 1) * 100
   for i, item in ipairs(scripts) do AddCard(item, base + i) end
   status.Text = (#scripts == 0 and hub.page == 1) and "No results" or ("Page " .. hub.page .. " of " .. hub.total)
   if hub.page < hub.total then
    moreBtn = Button(list, { Size = UDim2.new(1, 0, 0, 34), Text = "Load more", Font = FONT_B, TextSize = 12, LayoutOrder = 1e6 }, function()
     hub.page += 1
     Fetch(false)
    end)
    Corner(moreBtn, 8)
   end
  end)
 end

 local debounce = 0
 hubBox:GetPropertyChangedSignal("Text"):Connect(function()
  debounce += 1
  local my = debounce
  task.delay(0.6, function()
   if my ~= debounce then return end
   hub.query = hubBox.Text
   Fetch(true)
  end)
 end)

 local loaded = false
 local oldShow = pages.hub
 Bind(pages.hub:GetPropertyChangedSignal("Visible"), function()
  if pages.hub.Visible and not loaded then
   loaded = true
   Fetch(true)
  end
 end)
end

local HIGHLIGHTER_URL = "https://raw.githubusercontent.com/lqdxt/Scripts/main/Highlighter.lua"
local MAX_CHARS = 60000

local Palette = {
 keyword = "#FF6EC7", string = "#FFA760", value = "#5ED8F0", comment = "#6E6E7C", builtin = "#7FD0FF",
 property = "#5ED8F0", method = "#FFE6A8", identifier = "#D8E4FF", plain = "#6EA8FF",
}
local CURSOR = {
 Color = Color3.fromRGB(190, 140, 255), Width = 2, CornerRadius = 1, Smooth = true, SmoothTime = 0.07,
 Blink = true, BlinkRate = 0.53, YBias = 0, FollowCursor = true, ScrollMarginLines = 1.5, ScrollMarginX = 40,
 TapPlacesCursor = true, TapSlop = 12,
}
local LAYOUT = {
 PadX = 8, PadY = 4, Gutter = 46,
 GutterColor = Color3.fromRGB(88, 88, 102), GutterActiveColor = Color3.fromRGB(240, 240, 248),
 LineHighlight = Color3.fromRGB(255, 255, 255), LineHighlightTransparency = 0.86, LineHeight = 1.5, Font = MONO,
}

local function SetupEditor(box)
 local Highlighter
 do
  local ok, h = pcall(function() return loadstring(game:HttpGet(HIGHLIGHTER_URL))() end)
  if ok and type(h) == "table" and type(h.Tokenize) == "function" then
   Highlighter = h
  else
   Log("warn", "Highlighter failed to load, syntax highlighting skipped")
  end
 end

 local function Settle()
  RunService.Heartbeat:Wait()
  RunService.Heartbeat:Wait()
 end

 local plainHex = Palette.plain
 local plainColor = HexToColor3(plainHex)

 local function BuildRich(src)
  if not Highlighter or not Settings.highlight then return Esc(src) end
  local okT, tokens = pcall(Highlighter.Tokenize, src)
  if not okT or type(tokens) ~= "table" then return Esc(src) end

  local out, n = {}, 0
  local pos = 1
  local runHex, runBuf = nil, {}

  local function Flush()
   if #runBuf == 0 then return end
   local text = table.concat(runBuf)
   n += 1
   if runHex == plainHex then out[n] = text
   else out[n] = '<font color="' .. runHex .. '">' .. text .. "</font>" end
   table.clear(runBuf)
  end
  local function Add(text, hex)
   if text == "" then return end
   if hex ~= runHex then Flush() runHex = hex end
   runBuf[#runBuf + 1] = Esc(text)
  end

  for _, tok in ipairs(tokens) do
   local value = tok.value
   if type(value) == "string" and value ~= "" then
    local s, e = string.find(src, value, pos, true)
    if s then
     if s > pos then Add(string.sub(src, pos, s - 1), plainHex) end
     Add(value, Palette[tok.type] or plainHex)
     pos = e + 1
    end
   end
  end
  if pos <= #src then Add(string.sub(src, pos), plainHex) end
  Flush()
  return table.concat(out)
 end

 local function ToRichText(src)
  local ok, res = pcall(BuildRich, src)
  if not ok or type(res) ~= "string" then return Esc(src) end
  local plain = res:gsub("<[^>]->", ""):gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", '"'):gsub("&apos;", "'"):gsub("&amp;", "&")
  if plain ~= src then return Esc(src) end
  return res
 end

 local params = Instance.new("GetTextBoundsParams")
 params.Width = math.huge
 local pipeCache = {}
 local function Measure(str, font, size)
  params.Font = font
  params.Size = size
  local cacheKey = size .. "|" .. font.Family .. "|" .. tostring(font.Weight)
  local pipeW = pipeCache[cacheKey]
  if not pipeW then
   params.Text = "|"
   pipeW = TextService:GetTextBoundsAsync(params).X
   pipeCache[cacheKey] = pipeW
  end
  params.Text = str .. "|"
  local b = TextService:GetTextBoundsAsync(params)
  return math.max(0, b.X - pipeW), b.Y
 end

 local function GetPitch(probe, b, h)
  local pitch = h * b.LineHeight
  pcall(function()
   probe.FontFace = b.FontFace
   probe.TextSize = b.TextSize
   probe.LineHeight = b.LineHeight
   probe.Text = "A"
   local one = probe.TextBounds.Y
   probe.Text = "A\nA"
   local two = probe.TextBounds.Y
   if two - one > 1 then pitch = two - one end
  end)
  return pitch
 end

 local function KeyboardTop(scroller)
  if not UIS.OnScreenKeyboardVisible then return nil end
  local y = UIS.OnScreenKeyboardPosition.Y
  local rootGui = scroller:FindFirstAncestorOfClass("ScreenGui")
  if rootGui and not rootGui.IgnoreGuiInset then y -= GuiService:GetGuiInset().Y end
  return y
 end

 local function UpdateKeyboardPad(view, scroller, b)
  local pad = view:FindFirstChild("VoltKbPad")
  if not pad then
   pad = Instance.new("UIPadding")
   pad.Name = "VoltKbPad"
   pad.Parent = view
  end
  local kbTop = KeyboardTop(scroller)
  local overlap = 0
  if kbTop then
   local winBottom = scroller.AbsolutePosition.Y + scroller.AbsoluteWindowSize.Y
   overlap = math.max(0, winBottom - kbTop)
   if overlap > 0 then overlap += CURSOR.ScrollMarginLines * b.TextSize * 1.2 * b.LineHeight end
  end
  pad.PaddingBottom = UDim.new(0, math.ceil(overlap))
 end

 local active = setmetatable({}, { __mode = "k" })
 local padFns = setmetatable({}, { __mode = "k" })
 local solidUntil = 0
 local token = {}
 env.__VoltCursorToken = token
 if CURSOR.Blink then
  task.spawn(function()
   while env.__VoltCursorToken == token do
    local now = os.clock()
    local on = now < solidUntil or (now % (CURSOR.BlinkRate * 2)) < CURSOR.BlinkRate
    for _, fr in pairs(active) do fr.BackgroundTransparency = on and 0 or 1 end
    task.wait(0.05)
   end
  end)
 end

 local function OnKeyboardChanged()
  task.wait(0.15)
  for _, fn in pairs(padFns) do pcall(fn) end
 end
 Bind(UIS:GetPropertyChangedSignal("OnScreenKeyboardVisible"), OnKeyboardChanged)
 Bind(UIS:GetPropertyChangedSignal("OnScreenKeyboardSize"), OnKeyboardChanged)

 local scroller = box.Parent
 if LAYOUT.Font then pcall(function() box.FontFace = LAYOUT.Font end) end
 if LAYOUT.LineHeight then pcall(function() box.LineHeight = LAYOUT.LineHeight end) end

 local hiddenProps = {
  AutomaticSize = Enum.AutomaticSize.None, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
  Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1,
  TextColor3 = Color3.new(0, 0, 0), ShowNativeInput = false, ClipsDescendants = true,
 }
 local order = { "AutomaticSize", "AnchorPoint", "Position", "Size", "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency", "TextColor3", "ShowNativeInput", "ClipsDescendants" }
 local function ApplyHidden()
  for _, p in ipairs(order) do
   local v = hiddenProps[p]
   if box[p] ~= v then box[p] = v end
  end
 end
 ApplyHidden()
 for _, p in ipairs(order) do Bind(box:GetPropertyChangedSignal(p), ApplyHidden) end

 local view = Instance.new("TextButton")
 view.Name = "VoltView"
 view.AutoButtonColor = false
 view.BackgroundTransparency = 1
 view.BorderSizePixel = 0
 view.RichText = true
 view.Text = ""
 view.TextColor3 = plainColor
 view.TextXAlignment = Enum.TextXAlignment.Left
 view.TextYAlignment = Enum.TextYAlignment.Top
 view.TextWrapped = false
 view.AutomaticSize = Enum.AutomaticSize.XY
 view.Position = UDim2.fromOffset(LAYOUT.PadX + LAYOUT.Gutter, LAYOUT.PadY)
 view.ZIndex = box.ZIndex
 view.Active = true
 view.Visible = box.Visible
 pcall(function() view.FontFace = box.FontFace end)
 view.TextSize = box.TextSize

 local probe = Instance.new("TextLabel")
 probe.Name = "VoltProbe"
 probe.BackgroundTransparency = 1
 probe.TextTransparency = 1
 probe.Size = UDim2.fromOffset(0, 0)
 probe.TextWrapped = false
 probe.TextXAlignment = Enum.TextXAlignment.Left
 probe.TextYAlignment = Enum.TextYAlignment.Top
 probe.Active = false
 probe.Text = "A"
 probe.Parent = view

 local fr = Instance.new("Frame")
 fr.Name = "VoltCursor"
 fr.BackgroundColor3 = CURSOR.Color
 fr.BorderSizePixel = 0
 fr.Size = UDim2.fromOffset(CURSOR.Width, 16)
 fr.Visible = false
 fr.Active = false
 fr.ZIndex = view.ZIndex + 2
 pcall(function() fr.Interactable = false end)
 local corner = Instance.new("UICorner")
 corner.CornerRadius = UDim.new(0, CURSOR.CornerRadius)
 corner.Parent = fr
 fr.Parent = view

 local line = Instance.new("Frame")
 line.Name = "VoltLine"
 line.BackgroundColor3 = LAYOUT.LineHighlight
 line.BackgroundTransparency = LAYOUT.LineHighlightTransparency
 line.BorderSizePixel = 0
 line.Visible = false
 line.Active = false
 line.ZIndex = view.ZIndex + 1
 pcall(function() line.Interactable = false end)
 line.Parent = view

 local function MakeGutter(name, color)
  local g = Instance.new("TextLabel")
  g.Name = name
  g.BackgroundTransparency = 1
  g.RichText = false
  g.Text = ""
  g.TextColor3 = color
  g.TextWrapped = false
  g.TextXAlignment = Enum.TextXAlignment.Right
  g.TextYAlignment = Enum.TextYAlignment.Top
  g.AutomaticSize = Enum.AutomaticSize.Y
  g.Position = UDim2.fromOffset(-LAYOUT.Gutter, 0)
  g.Size = UDim2.fromOffset(LAYOUT.Gutter - 16, 0)
  g.Active = false
  g.ZIndex = view.ZIndex + 2
  pcall(function() g.Interactable = false end)
  g.Parent = view
  return g
 end
 local gutter = MakeGutter("VoltGutter", LAYOUT.GutterColor)
 local gutterCur = MakeGutter("VoltGutterCur", LAYOUT.GutterActiveColor)
 gutterCur.Visible = false
 local lastLines = -1

 local function UpdateMin()
  local w = scroller.AbsoluteWindowSize
  view.Size = UDim2.fromOffset(math.max(0, w.X - LAYOUT.PadX - LAYOUT.Gutter), math.max(0, w.Y - LAYOUT.PadY))
 end
 UpdateMin()
 Bind(scroller:GetPropertyChangedSignal("AbsoluteWindowSize"), UpdateMin)

 view.Parent = scroller

 Bind(box:GetPropertyChangedSignal("Visible"), function() view.Visible = box.Visible end)
 padFns[box] = function() UpdateKeyboardPad(view, scroller, box) end

 local placeholder = box.PlaceholderText
 local function HideNativePlaceholder()
  if box.PlaceholderText ~= "" then
   placeholder = box.PlaceholderText
   box.PlaceholderText = ""
  end
 end
 HideNativePlaceholder()

 local function Render()
  local text = box.Text
  pcall(function()
   view.FontFace = box.FontFace
   view.TextSize = box.TextSize
   view.LineHeight = box.LineHeight
   for _, g in ipairs({ gutter, gutterCur }) do
    g.FontFace = box.FontFace
    g.TextSize = box.TextSize
    g.LineHeight = box.LineHeight
   end
  end)
  local n = 1
  for _ in string.gmatch(text, "\n") do n += 1 end
  if n ~= lastLines then
   lastLines = n
   local t = table.create(n)
   for i = 1, n do t[i] = i end
   gutter.Text = table.concat(t, "\n")
  end
  if text == "" then
   view.RichText = true
   view.Text = '<font color="' .. ToHex(box.PlaceholderColor3) .. '">' .. Esc(placeholder) .. "</font>"
  elseif #text > MAX_CHARS then
   view.RichText = false
   view.Text = text
  else
   view.RichText = true
   view.Text = ToRichText(text)
  end
 end
 Render()
 env.__VoltRerender = Render

 local version = 0
 local function Update()
  version += 1
  local myVersion = version

  if not box:IsFocused() or box.CursorPosition < 1 then
   fr.Visible = false
   line.Visible = false
   gutterCur.Visible = false
   active[box] = nil
   return
  end

  local text = box.Text
  local cp = math.clamp(box.CursorPosition, 1, #text + 1)
  local before = string.sub(text, 1, cp - 1)
  local _, lineIdx = string.gsub(before, "\n", "")
  local lineStart = string.match(before, ".*\n()") or 1
  local lineStr = string.sub(before, lineStart)

  task.spawn(function()
   local okM, w, h = pcall(Measure, lineStr, box.FontFace, box.TextSize)
   if not okM or myVersion ~= version then return end

   local pitch = GetPitch(probe, box, h)
   local x = w
   local y = lineIdx * pitch + (pitch - h) * CURSOR.YBias
   local pos = UDim2.fromOffset(x, y)

   local ly = lineIdx * pitch
   line.Position = UDim2.fromOffset(-LAYOUT.Gutter, ly)
   line.Size = UDim2.new(1, LAYOUT.Gutter, 0, pitch)
   line.Visible = true
   gutterCur.Text = tostring(lineIdx + 1)
   gutterCur.Position = UDim2.fromOffset(-LAYOUT.Gutter, ly)
   gutterCur.Visible = true

   fr.Size = UDim2.fromOffset(CURSOR.Width, h)
   if CURSOR.Smooth and fr.Visible then
    TweenService:Create(fr, TweenInfo.new(CURSOR.SmoothTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = pos }):Play()
   else
    fr.Position = pos
   end
   fr.Visible = true
   active[box] = fr
   solidUntil = os.clock() + CURSOR.BlinkRate

   if CURSOR.FollowCursor then
    UpdateKeyboardPad(view, scroller, box)
    Settle()
    if myVersion ~= version then return end

    local winPos = scroller.AbsolutePosition
    local winSize = scroller.AbsoluteWindowSize
    local winBottom = winPos.Y + winSize.Y
    local kbTop = KeyboardTop(scroller)
    if kbTop then winBottom = math.min(winBottom, kbTop) end

    local curX = view.AbsolutePosition.X + x
    local curTop = view.AbsolutePosition.Y + y
    local curBottom = curTop + h
    local marginY = pitch * CURSOR.ScrollMarginLines
    local marginX = CURSOR.ScrollMarginX

    local canvas = scroller.CanvasPosition
    local dy, dx = 0, 0
    local fitsY = scroller.AbsoluteCanvasSize.Y <= winSize.Y + 1
    if fitsY then
     if canvas.Y ~= 0 then dy = -canvas.Y end
    elseif curBottom + marginY > winBottom then
     dy = (curBottom + marginY) - winBottom
    elseif curTop - marginY < winPos.Y then
     dy = (curTop - marginY) - winPos.Y
    end
    if curX + marginX > winPos.X + winSize.X then
     dx = (curX + marginX) - (winPos.X + winSize.X)
    elseif curX - marginX < winPos.X then
     dx = (curX - marginX) - winPos.X
    end
    if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
     scroller.CanvasPosition = Vector2.new(math.max(0, canvas.X + dx), math.max(0, canvas.Y + dy))
    end
   end
  end)
 end

 local scheduled, dirtyRender = false, false
 local function Schedule(renderToo)
  if renderToo then dirtyRender = true end
  if scheduled then return end
  scheduled = true
  task.defer(function()
   scheduled = false
   if dirtyRender then
    dirtyRender = false
    Render()
   end
   Update()
  end)
 end
 Bind(box:GetPropertyChangedSignal("Text"), function() Schedule(true) end)
 Bind(box:GetPropertyChangedSignal("TextSize"), function() Schedule(true) end)
 Bind(box:GetPropertyChangedSignal("FontFace"), function() Schedule(true) end)
 Bind(box:GetPropertyChangedSignal("PlaceholderText"), function()
  HideNativePlaceholder()
  Schedule(true)
 end)
 Bind(box:GetPropertyChangedSignal("CursorPosition"), function() Schedule(false) end)
 Bind(box.Focused, function() Schedule(false) end)
 Bind(box.FocusLost, function()
  version += 1
  fr.Visible = false
  line.Visible = false
  gutterCur.Visible = false
  active[box] = nil
 end)

 local function FocusAt(guiPos)
  box:CaptureFocus()
  if not CURSOR.TapPlacesCursor then return end
  task.spawn(function()
   local text = box.Text
   if text == "" then return end

   local okM, _, h = pcall(Measure, "A", box.FontFace, box.TextSize)
   if not okM then return end
   local pitch = GetPitch(probe, box, h)
   local relX = guiPos.X - view.AbsolutePosition.X
   local relY = guiPos.Y - view.AbsolutePosition.Y
   local lineNo = math.max(0, math.floor(relY / pitch))

   local startPos, curLine = 1, 0
   while curLine < lineNo do
    local nl = string.find(text, "\n", startPos, true)
    if not nl then break end
    startPos = nl + 1
    curLine += 1
   end
   local nl = string.find(text, "\n", startPos, true)
   local lineStr = string.sub(text, startPos, nl and (nl - 1) or #text)

   local function W(k)
    local okW, width = pcall(Measure, string.sub(lineStr, 1, k), box.FontFace, box.TextSize)
    return okW and width or math.huge
   end

   local lo, hi = 0, #lineStr
   while lo < hi do
    local mid = math.floor((lo + hi) / 2)
    if W(mid) >= relX then hi = mid else lo = mid + 1 end
   end
   local k = lo
   if k > 0 and (relX - W(k - 1)) < (W(k) - relX) then k -= 1 end

   local target = startPos + k
   local tries = 0
   while not box:IsFocused() and tries < 15 do
    RunService.Heartbeat:Wait()
    tries += 1
   end
   Settle()
   if box:IsFocused() then
    box.CursorPosition = target
    RunService.Heartbeat:Wait()
    if box:IsFocused() and box.CursorPosition ~= target then box.CursorPosition = target end
   end
  end)
 end

 local downPos
 view.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
   downPos = Vector2.new(input.Position.X, input.Position.Y)
  end
 end)
 view.InputEnded:Connect(function(input)
  if not downPos then return end
  if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
   local up = Vector2.new(input.Position.X, input.Position.Y)
   local moved = (up - downPos).Magnitude
   downPos = nil
   if moved <= CURSOR.TapSlop then FocusAt(up) end
  end
 end)

 local lastCursor, lastSelStart = 1, -1
 Bind(box:GetPropertyChangedSignal("CursorPosition"), function()
  if box.CursorPosition >= 1 then
   lastCursor = box.CursorPosition
   lastSelStart = box.SelectionStart
  end
 end)
 Bind(box:GetPropertyChangedSignal("SelectionStart"), function()
  if box.CursorPosition >= 1 then lastSelStart = box.SelectionStart end
 end)
 Bind(box.FocusLost, function(enterPressed)
  if not enterPressed then return end
  local text = box.Text
  local from = math.clamp(lastCursor, 1, #text + 1)
  local to = from
  if lastSelStart and lastSelStart >= 1 and lastSelStart ~= from then
   from, to = math.min(from, lastSelStart), math.max(from, lastSelStart)
  end
  local newText = string.sub(text, 1, from - 1) .. "\n" .. string.sub(text, to)
  local newCursor = from + 1
  task.defer(function()
   box.Text = newText
   box:CaptureFocus()
   task.wait()
   if box:IsFocused() then box.CursorPosition = newCursor end
   lastCursor = newCursor
   lastSelStart = -1
  end)
 end)
end

local maximized, restoreRect = false, nil

function Minimize()
 win.Visible = false
 bubble.Visible = true
end
local function Restore()
 bubble.Visible = false
 win.Visible = true
 if deltaGui then deltaGui.Enabled = false end
end
local function Unload()
 if env.__VoltUnload then env.__VoltUnload() end
end
local function ToggleMax()
 local v = VP()
 if maximized then
  maximized = false
  if restoreRect then
   win.Position, win.Size = restoreRect[1], restoreRect[2]
  end
 else
  maximized = true
  restoreRect = { win.Position, win.Size }
  win.Position = UDim2.fromOffset(6, 6)
  win.Size = UDim2.fromOffset(v.X - 12, v.Y - 12)
 end
end

function SwitchToUpdated()
 if not deltaGui then
  Log("warn", "Updated version reskins Delta's own UI, which wasn't found.")
  return
 end
 local dg = deltaGui
 Unload()
 pcall(function() dg.Enabled = true end)
 task.defer(function()
  local ok, err = pcall(env.__VoltLoadUpdated)
  if not ok then warn("[Volt] Updated version failed: " .. tostring(err)) end
 end)
end

WinBtn("x", 6, Unload)
WinBtn("max", 36, ToggleMax)
WinBtn("minus", 66, Minimize)


local startPos
Drag(titlebar, function() startPos = Vector2.new(win.Position.X.Offset, win.Position.Y.Offset) end, function(d)
 if maximized then return end
 local v, s = VP(), win.AbsoluteSize
 win.Position = UDim2.fromOffset(math.clamp(startPos.X + d.X, -s.X + 90, v.X - 90), math.clamp(startPos.Y + d.Y, 0, v.Y - 34))
end)

local bStart
Drag(bubble, function() bStart = Vector2.new(bubble.Position.X.Offset, bubble.Position.Y.Offset) end, function(d)
 local v = VP()
 bubble.Position = UDim2.fromOffset(math.clamp(bStart.X + d.X, 0, v.X - 44), math.clamp(bStart.Y + d.Y, 0, v.Y - 44))
end, Restore)

local grip = Button(win, {
 AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1,
 Text = "//", TextSize = 11, TextColor3 = T.dim, ZIndex = 10,
}, nil, true)
local rStart
Drag(grip, function() rStart = win.AbsoluteSize end, function(d)
 if maximized then return end
 local v = VP()
 win.Size = UDim2.fromOffset(math.clamp(rStart.X + d.X, 440, v.X), math.clamp(rStart.Y + d.Y, 280, v.Y))
end)

local function EditorMenu()
 ShowMenu(tabbar, {
  { "Execute Clipboard", ExecClipboard },
  { "Save", SaveActive },
  { "Copy Script", function()
   if activeTab and activeTab.kind == "file" then
    if Clipboard(true, codeBox.Text) then Log("volt", "Copied script") end
   end
  end },
  { "Clear Editor", function()
   if activeTab and activeTab.kind == "file" then codeBox.Text = "" end
  end },
  { "Script Hub", function() OpenPage("hub") end },
  { "Settings", function() OpenPage("settings") end },
  { "Welcome", function() OpenPage("welcome") end },
  { Settings.console and "Hide Console" or "Show Console", function() SetConsole(not Settings.console) end },
  { "Close All Tabs", function()
   table.clear(tabs)
   activeTab = nil
   OpenPage("welcome")
  end },
  { "Unload Volt", Unload, danger = true },
 }, 190)
end
Button(tabbar, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.fromOffset(28, 26), BackgroundTransparency = 1, Text = "...", Font = FONT_B, TextSize = 14, TextColor3 = T.dim }, EditorMenu)

local expMenu = ExpBtn("dots", 4, function()
 ShowMenu(sidebar, {
  { "Script Hub", function() OpenPage("hub") end },
  { "Settings", function() OpenPage("settings") end },
  { Settings.console and "Hide Console" or "Show Console", function() SetConsole(not Settings.console) end },
 }, 170)
end)
ExpBtn("refresh", 28, function() RefreshFiles() end)
ExpBtn("plus", 52, function() CreateFile("script.lua", "") end)

showSB.Activated:Connect(function()
 SB_HIDDEN = false
 ApplyLayout()
end)

env.__VoltUnload = function()
 env.__VoltCursorToken = nil
 env.__VoltRerender = nil
 for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
 table.clear(conns)
 pcall(function() if env.__VoltAfkStop then env.__VoltAfkStop() end end)
 if deltaGui then pcall(function() deltaGui.Enabled = deltaWasEnabled end) end
 pcall(function() gui:Destroy() end)
 env.__VoltUnload = nil
end

SetupEditor(codeBox)
RefreshFiles()
TermResponsive()
ApplyLayout()
OpenPage("welcome")
NewFileTab(UniqueName("script.lua"), nil, "")
Log("volt", "Volt successfully loaded")
do
 local n = "unknown"
 pcall(function() if identifyexecutor then n = (identifyexecutor()) end end)
 Log("volt", "Running on " .. tostring(n) .. (deltaGui and " (Delta UI hidden)" or ""))
end
