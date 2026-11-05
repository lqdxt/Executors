-- will change a lot overtime, maybe even changing the entire structure

local colorMap = {}

local function Reg(r1, g1, b1, r2, g2, b2)
 colorMap[r1 .. "," .. g1 .. "," .. b1] = Color3.fromRGB(r2, g2, b2)
end

Reg(26, 28, 36, 13, 13, 20)
Reg(26, 27, 36, 13, 13, 20)
Reg(24, 25, 33, 16, 16, 24)
Reg(32, 35, 46, 16, 14, 28)
Reg(34, 41, 50, 18, 15, 30)
Reg(38, 41, 49, 18, 18, 28)
Reg(38, 41, 50, 18, 18, 28)
Reg(31, 37, 47, 15, 15, 23)
Reg(41, 44, 52, 22, 18, 35)
Reg(41, 45, 58, 22, 22, 32)
Reg(51, 56, 70, 24, 20, 38)
Reg(59, 63, 74, 26, 22, 40)
Reg(59, 64, 79, 28, 24, 44)
Reg(59, 71, 90, 26, 22, 44)
Reg(61, 66, 81, 28, 24, 44)
Reg(22, 22, 30, 10, 10, 16)

Reg(34, 160, 255, 138, 43, 226)
Reg(59, 139, 254, 138, 43, 226)
Reg(60, 137, 196, 100, 40, 180)
Reg(86, 173, 239, 120, 60, 210)
Reg(94, 136, 169, 70, 35, 130)
Reg(31, 51, 80, 50, 20, 85)
Reg(69, 97, 119, 50, 30, 90)

Reg(185, 211, 230, 170, 140, 220)
Reg(190, 206, 232, 175, 145, 225)

Reg(103, 109, 126, 85, 65, 120)
Reg(104, 120, 144, 85, 60, 130)
Reg(126, 139, 176, 100, 70, 160)
Reg(136, 140, 151, 105, 80, 145)
Reg(137, 144, 163, 110, 80, 155)
Reg(138, 146, 167, 110, 80, 155)
Reg(157, 162, 199, 130, 90, 185)
Reg(161, 167, 182, 135, 100, 170)

Reg(115, 127, 152, 100, 90, 130)
Reg(129, 143, 164, 120, 100, 160)
Reg(140, 206, 255, 180, 130, 255)
Reg(162, 191, 212, 160, 130, 200)

local function Key(c)
 return math.round(c.R * 255) .. "," .. math.round(c.G * 255) .. "," .. math.round(c.B * 255)
end

local function Remap(c)
 return colorMap[Key(c)]
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

local function PatchInstance(inst)
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
 keyword = "#C792FF",
 string = "#A8F0B0",
 value = "#FFB86C",
 comment = "#6B6591",
 builtin = "#8FD3FF",
 property = "#A58BFF",
 method = "#FFE6A8",
 identifier = "#F0EAFF",
 plain = "#D6D0EA",
}

local CURSOR = {
 Color = Color3.fromRGB(180, 130, 255),
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

  local hiddenProps = {
   AutomaticSize = Enum.AutomaticSize.None,
   AnchorPoint = Vector2.new(0.5, 0.5),
   Position = UDim2.fromScale(0.5, 0.5),
   Size = UDim2.fromOffset(0, 0),
   BackgroundTransparency = 1,
   TextTransparency = 1,
   ClipsDescendants = true,
  }
  local order = { "AutomaticSize", "AnchorPoint", "Position", "Size", "BackgroundTransparency", "TextTransparency", "ClipsDescendants" }
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
  view.Position = UDim2.fromOffset(LAYOUT.PadX, LAYOUT.PadY)
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

  local function UpdateMin()
   local w = scroller.AbsoluteWindowSize
   view.Size = UDim2.fromOffset(math.max(0, w.X - LAYOUT.PadX), math.max(0, w.Y - LAYOUT.PadY))
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
   end)
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
