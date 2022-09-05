script_name("Develop Helper")
script_author("drags (blast.hk)")
script_version("Poxuy na Versiyu")
local imgui = require 'imgui'
local key = require 'vkeys'
local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"
local sp = require 'lib.samp.events'
local elcount = 0
local sizesFont = {"15", "16"}
local sFont = {}
local main_window_state = imgui.ImBool(false)
local carinfo = imgui.ImBool(false)
local targetinfo = imgui.ImBool(false)
local selfinfo = imgui.ImBool(false)
local TargetM = imgui.ImBool(false)
local glyph_ranges = nil
local blip = nil
local utls = {}
utls["did"] = imgui.ImBool(false)
utls["rpic"] = imgui.ImBool(false)
utls["robj"] = imgui.ImBool(false)
utls["rtext"] = imgui.ImBool(false)
utls["objd"] = imgui.ImInt(350)
utls["picd"] = imgui.ImInt(350)
local ptrn = {}
function sp.onShowDialog(id, style, title, button1, button2, text)
  if utls["did"].v then
    title = title.."[ "..id.."]"
  end
  return {id, style, title, button1, button2, text}
end
function cht(table, item)
  for k, v in pairs(table) do
    if v == item then return true end
  end
  return false
end
function sendSync(x, y, z, bool, key, pic)
  local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local data = allocateMemory(68)
  sampStorePlayerOnfootData(myId, data)
  if key == nil then key = 0 end
  if bool then
    setStructElement(data, 4, 2, key, false) -- send sKeys // mouse
  else
    setStructElement(data, 36, 1, key, false) -- send byteCurrentWeapon // Y, N, H
  end
  if z ~= nil then
    setStructFloatElement(data, 6, x, false)
    setStructFloatElement(data, 10, y, false)
    setStructFloatElement(data, 14, z, false)
  end

  sampSendOnfootData(data)
  if pic ~= nil then
    sampSendPickedUpPickup(tonumber(pic))
  end
  sampForceOnfootSync()
  freeMemory(data)
end

function chekcptrn(p, p2)
  if p == 1 then
    ptrn.k = "car"
    ptrn.v = getVehiclePointerHandle(p2)
  else
    ptrn.k = "char"
    ptrn.v = getCharPointerHandle(p2)
  end
end
function rendpickup()
  while true do
    wait(0)
    if utls["rpic"].v then
      for i = 1, 4096 do
        local pickup = sampGetPickupHandleBySampId(i)
        local pool = sampGetPickupPoolPtr()
        local mdid = (i * 20) + 61444 + pool
        pickupmodel = readMemory(mdid, 4, false)

        local x, y, z = getPickupCoordinates(pickup)
        local px, py, pz = getCharCoordinates(playerPed)
        local rad = getDistanceBetweenCoords3d(px, py, pz, x, y, z)
        if isPointOnScreen(x, y, z, 0) and rad <= utls["picd"].v then
          local cx, zy = convert3DCoordsToScreen(x, y, z)
          renderFontDrawText(font, string.format("Pickup: {31F5FC} %d {FFBEBEBE} Model:{31F5FC} %d", i, pickupmodel), cx, zy, 0xFFBEBEBE)
        end
      end
    end
  end
end
function rendobject()
  while true do
    wait(0)
    if utls["robj"].v then
      for i = 1, 1000 do
        local obj = sampGetObjectHandleBySampId(i)
        if doesObjectExist(obj) then
          local res, x, y, z = getObjectCoordinates(obj)
          local objmodel = getObjectModel(obj)
          local px, py, pz = getCharCoordinates(playerPed)
          local rad = getDistanceBetweenCoords3d(px, py, pz, x, y, z)
          if isPointOnScreen(x, y, z, 0) and rad <= utls["objd"].v then
            local cx, zy = convert3DCoordsToScreen(x, y, z)
            renderFontDrawText(font, string.format("Object:{31F5FC} %d {FFBEBEBE} Model: {31F5FC} %d", i, objmodel), cx, zy, 0xFFBEBEBE )
          end
        end
      end
    end
  end
end
function rendtextdraw()
  while true do
    wait(0)
    if utls["rtext"].v then
      for i = 1, 2304 do
        local obj = sampGetObjectHandleBySampId(i)
        if sampTextdrawIsExists(i) then
          local x, y = convertGameScreenCoordsToWindowScreenCoords(sampTextdrawGetPos(i))
          renderFontDrawText(font2, string.format("ID: {FF8D35}%d", i), x - 50, y, 0xFFBEBEBE)
        end
      end
    end
  end
end
function imgui.BeforeDrawFrame()
  if not fontChanged then
    fontChanged = true
    glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    imgui.GetIO().Fonts:Clear()
    imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\arialbd.ttf', 14, nil, glyph_ranges)
    for _, v in ipairs(sizesFont) do
      sFont[tonumber(v)] = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\arialbd.ttf', v, nil, glyph_ranges)
    end
    imgui.RebuildFonts()
  end
end
function gtx()
  elcount = elcount + 20
  return elcount
end
function imgui.OnDrawFrame()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  style.WindowRounding = 2.0
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
  style.ChildWindowRounding = 2.0
  style.FrameRounding = 2.0
  style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.GrabMinSize = 8.0
  style.GrabRounding = 1.0
  colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
  colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
  colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
  colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
  colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
  colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
  colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
  imgui.ShowCursor = false
  if selfinfo.v then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.5, sh / 8), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('dbg', selfinfo, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoFocusOnAppearing + imgui.WindowFlags.AlwaysAutoResize)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.RenderInMenu = false
    imgui.ShowCursor = false
    local width = imgui.GetWindowWidth()
    local hight = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize('Self Information')
    elcount = calc.y
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.PushFont(sFont[tonumber(sizesFont[7])])
    local res, id = sampGetPlayerIdByCharHandle(playerPed)
    local animid = sampGetPlayerAnimationId(id)
    local animname, animfile = sampGetAnimationNameAndFile(animid)
    imgui.Text('Self Information')
    imgui.Separator()
    imgui.SetCursorPosY(gtx())
    imgui.Text("HP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(getCharHealth(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("AP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(getCharArmour(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Model:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(string.format("ID: %d", getCharModel(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getCharSpeed(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Interior:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getActiveInterior()))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Weapon ID:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getCurrentCharWeapon(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Animation:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%s(%d)", animfile, animid))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Position:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCharCoordinates(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Velocity:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.3f Y: %.3f Z: %.3f", getCharVelocity(PLAYER_PED)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Quaternion:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f W: %.2f", getCharQuaternion(PLAYER_PED)))
    imgui.PopFont()
    imgui.End()
  end
  local result, target = getCharPlayerIsTargeting(PLAYER_HANDLE)
  if targetinfo.v and result then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 8, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('dbg##22', selfinfo, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.AlwaysAutoResize)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.RenderInMenu = false
    imgui.ShowCursor = false
    local width = imgui.GetWindowWidth()
    local hight = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize('Self Information')
    elcount = 20
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.PushFont(sFont[tonumber(sizesFont[7])])
    local res, id = sampGetPlayerIdByCharHandle(target)
    imgui.Text('Target Information')
    imgui.Separator()
    imgui.SetCursorPosY(gtx())
    imgui.Text("Nick:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%s[%d]", sampGetPlayerNickname(id), id))
    imgui.SetCursorPosY(gtx())
    imgui.Text("HP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(sampGetPlayerHealth(id)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("AP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(sampGetPlayerArmor(id)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Model:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(string.format("ID: %d", getCharModel(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getCharSpeed(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Interior:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getActiveInterior()))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Weapon ID:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getCurrentCharWeapon(target)))

    imgui.SetCursorPosY(gtx())
    imgui.Text("Position:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCharCoordinates(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Velocity:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.3f Y: %.3f Z: %.3f", getCharVelocity(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Quaternion:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f W: %.2f", getCharQuaternion(target)))
    imgui.PopFont()
    imgui.End()
  end
  if carinfo.v and isCharInAnyCar(PLAYER_PED) then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 3, sh / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('dbg##232', carinfo, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.AlwaysAutoResize)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.RenderInMenu = false
    imgui.ShowCursor = false
    local width = imgui.GetWindowWidth()
    local hight = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize('Car Information')
    local car = storeCarCharIsInNoSave(PLAYER_PED)
    elcount = 20
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.PushFont(sFont[tonumber(sizesFont[7])])
    imgui.Text('Car Information')
    imgui.Separator()
    imgui.SetCursorPosY(gtx())
    imgui.Text("HP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(getCarHealth(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%.3f", getCarSpeed(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Model:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(getCarModel(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Car ID:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    local res, carid = sampGetVehicleIdByCarHandle(car)
    imgui.Text(tostring(carid))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Color:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%d and %d", getCarColours(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Position:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCarCoordinates(car)))
    imgui.Text("Vector Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCarSpeedVector(car)))
    imgui.PopFont()
    imgui.End()
  end

  if main_window_state.v then
    imgui.ShowCursor = true
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.5, sh / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('##2232', targetinfo, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.AlwaysAutoResize)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.RenderInMenu = false
    local width = imgui.GetWindowWidth()
    local hight = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize('Developer Helper')
    elcount = 20
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.PushFont(sFont[tonumber(sizesFont[6])])
    imgui.Text('Developer Helper')
    imgui.Separator()
    if imgui.Checkbox("Self info##1", selfinfo) then
    end
    imgui.SameLine()
    if imgui.Checkbox("Target info##1", targetinfo) then
    end
    imgui.SameLine()
    if imgui.Checkbox("Car Info##1", carinfo) then
    end
    imgui.SameLine()
    if imgui.Checkbox("Target Info(MBUTTON)##1", TargetM) then
    end
    imgui.Separator()
    local calc = imgui.CalcTextSize('Utils')
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text('Utils')
    imgui.Separator()
    if imgui.Checkbox("Dialog ID##1", utls["did"]) then
    end
    imgui.SameLine()
    if imgui.Checkbox("Pickup ID|Model##1", utls["rpic"]) then
    end
    imgui.SameLine()
    if imgui.Checkbox("Object ID|Model##1", utls["robj"]) then
    end
    imgui.SameLine()
    if imgui.Checkbox("TextDraw ID##1", utls["rtext"]) then
    end
    imgui.Separator()
    local calc = imgui.CalcTextSize('Distance settings')
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text('Distance settings')
    imgui.Separator()

    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.SliderInt("Object View Distance", utls["objd"], 150, 1000, 1)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.SliderInt("Pickup View Distance", utls["picd"], 150, 1000, 1)
    imgui.Separator()
    if imgui.Button("CMD Helper##1", btn_size) then
      text = [[
{FFFF00}/dv <-  {00FF00} Open menu
{FFFF00}/ppic {0008ff} ID {FFFF00} <-  {00FF00} Send pickup RPC
{FFFF00}/fppic {0008ff} ID {FFFF00} <-  {00FF00} Send pickup RPC with fake position
{FFFF00}/pospic {0008ff} ID {FFFF00} <-  {00FF00} Get pickup position
{FFFF00}/plpos  <-  {00FF00} Get player position
{FFFF00}/objpos {0008ff} ID {FFFF00} <-  {00FF00} Get Object position
{FFFF00}/fsync {0008ff} x y z bool key {FFFF00} <-  {00FF00} Send Fake sync packet bool(1-KeyData  1- weapons )
{FFFF00}Example 1:{00FF00}
/fsync 230 1000 23 1 1024 <- send fake sync with pressed ALT
{FFFF00}Example 2:{00FF00}
/fsync 230 1000 23 0 64 <- send fake sync with pressed Y

{00FF00}Developer: {fcff33}Drags
]]
      sampShowDialog(6405, "Information", text, "ÎÊ", "", 0)

      main_window_state.v = not main_window_state.v
    end

    if imgui.Button("Close##1", btn_size) then
      main_window_state.v = not main_window_state.v
    end

    imgui.PopFont()
    imgui.End()
  end







  if TargetM.v and ptrn.k == "char" and doesCharExist(ptrn.v) then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 8, sh / 8), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

    imgui.Begin('dbg##2323', TargetM, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.AlwaysAutoResize)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.RenderInMenu = false
    imgui.ShowCursor = false
    local width = imgui.GetWindowWidth()
    local hight = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize('Target Information')
    elcount = 20
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.PushFont(sFont[tonumber(sizesFont[7])])
    local target = ptrn.v
    local res, id = sampGetPlayerIdByCharHandle(target)
    imgui.Text('Target Information')
    imgui.Separator()
    imgui.SetCursorPosY(gtx())
    imgui.Text("Nick:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%s[%d]", sampGetPlayerNickname(id), id))
    imgui.SetCursorPosY(gtx())
    imgui.Text("HP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(sampGetPlayerHealth(id)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("AP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(sampGetPlayerArmor(id)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Model:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(string.format("ID: %d", getCharModel(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getCharSpeed(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Weapon ID:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(tostring(getCurrentCharWeapon(target)))

    imgui.SetCursorPosY(gtx())
    imgui.Text("Position:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCharCoordinates(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Velocity:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.3f Y: %.3f Z: %.3f", getCharVelocity(target)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Quaternion:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2)
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f W: %.2f", getCharQuaternion(target)))
    imgui.PopFont()
    imgui.End()
  end

  if TargetM.v and ptrn.k == "car" and doesVehicleExist(ptrn.v) then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 8, sh / 8), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

    imgui.Begin('dbg##2323', TargetM, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.AlwaysAutoResize)
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.RenderInMenu = false
    imgui.ShowCursor = false

    local width = imgui.GetWindowWidth()
    local hight = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize('Car Information')
    elcount = 20
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.PushFont(sFont[tonumber(sizesFont[7])])

    local car = ptrn.v
    imgui.Text('Car Information')
    imgui.Separator()
    imgui.SetCursorPosY(gtx())
    imgui.Text("HP:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(getCarHealth(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%.3f", getCarSpeed(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Model:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(tostring(getCarModel(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Car ID:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    local res, carid = sampGetVehicleIdByCarHandle(car)
    imgui.Text(tostring(carid))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Color:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("%d and %d", getCarColours(car)))
    imgui.SetCursorPosY(gtx())
    imgui.Text("Position:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCarCoordinates(car)))
    imgui.Text("Vector Speed:")
    imgui.SameLine()
    imgui.SetCursorPosX(width / 2 )
    imgui.Text(string.format("X: %.2f Y: %.2f Z: %.2f", getCarSpeedVector(car)))
    imgui.PopFont()
    imgui.End()
  end
end

local cursorEnabled = false
function fakepic(id)
  id = tonumber(id)
  local pickup = sampGetPickupHandleBySampId(id)
  local x, y, z = getPickupCoordinates(pickup)
  if x ~= 0 and y ~= 0 and z ~= -100 then
    sendSync( x, y, z, true, 0, id)
    sampAddChatMessage("{EB4E20}[Dev-Help]{FFFFFF} Send Pickup with fake position "..tonumber(id), 0x84FF09)
  else
    sampAddChatMessage("{EB4E20}[Dev-Help]{FFFFFF} Pickup Not Found", 0x84FF09)
  end
end
function getpos(id)
  id = tonumber(id)
  local pickup = sampGetPickupHandleBySampId(id)
  local x, y, z = getPickupCoordinates(pickup)
  if x ~= 0 and y ~= 0 and z ~= -100 then
    x = string.gsub(x, ",", ".")
    y = string.gsub(y, ",", ".")
    z = string.gsub(z, ",", ".")
    sampAddChatMessage(string.format("{EB4E20}[Dev-Help]{FFFFFF} Pickup %d X: %s Y:%s Z:%s (Coped to clipboard)", id, x, y, z, key), 0x84FF09)
    setClipboardText(string.format("%s , %s , %s", x, y, z))
  else
    sampAddChatMessage("{EB4E20}[Dev-Help]{FFFFFF} Pickup Not Found", 0x84FF09)
  end
end
function getoos(id)
  id = tonumber(id)
  local obj = sampGetObjectHandleBySampId(id)
  if doesObjectExist(obj) then
    local res, x, y, z = getObjectCoordinates(obj)
    print(x, y, z)
    x = string.gsub(x, ",", ".")
    y = string.gsub(y, ",", ".")
    z = string.gsub(z, ",", ".")
    sampAddChatMessage(string.format("{EB4E20}[Dev-Help]{FFFFFF} Object %d X: %s Y:%s Z:%s (Coped to clipboard)", id, x, y, z, key), 0x84FF09)
    setClipboardText(string.format("%s , %s , %s", x, y, z))
  else
    sampAddChatMessage("{EB4E20}[Dev-Help]{FFFFFF} Object Not Found", 0x84FF09)
  end
end
--thanks fyp <3
function split(str, delim, plain)
  local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
  repeat
    local npos, epos = string.find(str, delim, pos, plain)
    table.insert(tokens, string.sub(str, pos, npos and npos - 1))
    pos = epos and epos + 1
  until not pos
  return tokens
end
function fakesync(x)
  x = string.gsub(x, ",", ".")
  local zp = split(x, " ")
  local x, y, z, bool, key = tonumber(zp[1]), tonumber(zp[2]), tonumber(zp[3]), tonumber(zp[4]), tonumber(zp[5])
  if x == nil then x = 0 end if y == nil then y = 0 end if z == nil then z = 0 end if key == nil then key = 0 end if bool == nil then bool = 1 end
  if bool == 1 then
    sampAddChatMessage(string.format("{EB4E20}[Dev-Help]{FFFFFF} You send fake sync (X: %f Y:%f Z:%f Key: %d ) ", x, y, z, key), 0x84FF09)
  else
    sampAddChatMessage(string.format("{EB4E20}[Dev-Help]{FFFFFF} You send fake sync (X: %f Y:%f Z:%f Weapon: %d ) ", x, y, z, key), 0x84FF09)
  end
  sendSync( x, y, z, bool, key)
end
function getplpos()
  x, y, z = getCharCoordinates(playerPed)
  x = string.gsub(x, ",", ".")
  y = string.gsub(y, ",", ".")
  z = string.gsub(z, ",", ".")
  sampAddChatMessage(string.format("{EB4E20}[Dev-Help]{FFFFFF} You position X: %s Y:%s Z:%s (Coped to clipboard)", x, y, z, key), 0x84FF09)
  setClipboardText(string.format("%s , %s , %s", x, y, z))
end
function main()
  if not isSampfuncsLoaded() then return end
  repeat wait(0) until isSampAvailable()
    sampRegisterChatCommand('ppic', function(picid)
      sampAddChatMessage("{EB4E20}[Dev-Help]{FFFFFF} Send Pickup "..tonumber(picid), 0x84FF09)
      sampSendPickedUpPickup(tonumber(picid))
    end)
    sampRegisterChatCommand('fppic', fakepic)
    sampRegisterChatCommand('pospic', getpos)
    sampRegisterChatCommand("plpos", getplpos)
    sampRegisterChatCommand('fsync', fakesync)
    sampRegisterChatCommand("dv", function()
      main_window_state.v = not main_window_state.v
    end)
    sampRegisterChatCommand("objpos", getoos)
    font = renderCreateFont("arial black", 8)
    font2 = renderCreateFont("arial black", 10)
    lua_thread.create(rendpickup)
    lua_thread.create(rendobject)
    lua_thread.create(rendtextdraw)
    while true do
      imgui.Process = main_window_state.v or selfinfo.v or targetinfo.v or carinfo.v or TargetM.v
      if main_window_state.v then
        showCursor(true)
      end
      if TargetM.v then
        while isPauseMenuActive() do
          if cursorEnabled then
            showCursor(false)
          end
          wait(100)
        end
        if isKeyDown(key.VK_MBUTTON) then
          cursorEnabled = not cursorEnabled
          showCursor(cursorEnabled)
          while isKeyDown(key.VK_MBUTTON) do wait(80) end
        end
        if cursorEnabled then
          local mode = sampGetCursorMode()
          if mode == 0 then
            showCursor(true)
          end
          local sx, sy = getCursorPos()
          local sw, sh = getScreenResolution()
          if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
            local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
            local camX, camY, camZ = getActiveCameraCoordinates()
            local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, true, true, false, false, false)
            if result and colpoint.entity ~= 0 then
              local normal = colpoint.normal
              local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
              local text = "Press LBUTTON on PED/CAR to get info\nPress RBUTTON to reset"
              renderFontDrawText(font, text, sx, sy - renderGetFontDrawHeight(font) * 3, 0xFFFFFFFF)
              if colpoint.entityType == 2 then
                createblip(pos.x, pos.y, pos.z)
                if isKeyDown(key.VK_LBUTTON) then
                  chekcptrn(1, colpoint.entity)
                  cursorEnabled = false
                  showCursor(false)
                end
              end
              if colpoint.entityType == 3 then
                createblip(pos.x, pos.y, pos.z)
                if isKeyDown(key.VK_LBUTTON) then
                  chekcptrn(0, colpoint.entity)
                  cursorEnabled = false
                  showCursor(false)
                end
              end
              if isKeyDown(key.VK_LBUTTON) then
                cursorEnabled = false
                showCursor(false)
              end
              if isKeyDown(key.VK_RBUTTON) then
                ptrn = {}
                cursorEnabled = false
                showCursor(false)
              end
            end
          end
        end
      end
      wait(0)
      removeblip()
    end
  end

  function createblip(x, y, z)
    blip = createUser3dMarker(x, y, z + 1, 2)
  end

  function removeblip()
    if blip then
      removeUser3dMarker(blip)
      blip = nil
    end
  end
