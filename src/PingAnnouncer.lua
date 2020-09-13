--[[
PingAnnouncer is a World of Warcraft addon that lets your party members know you've pinged an object of interest.

Copyright (C) 2020  Melik Noyan Baykal

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

-- This is used to prevent sending more than 1 message per second
local LAST_PING_TIME

local function determineDirection(x, y)
  local x2 = x
  local y2 = y

  -- Rotate the coordinates if the minimap is rotated
  if GetCVar(PA_C.CVAR_ROTATE_MINIMAP) == '1' then
    local rot = -1 * MinimapCompassTexture:GetRotation()

    x2 = x * math.cos(rot) - y * math.sin(rot)
    y2 = y * math.cos(rot) + x * math.sin(rot)
  end

  local directionX = ''
  local directionY = ''

  if x2 < -1 * PA_C.DIRECTION_MARGIN then
    directionX = PA_L.WEST
  elseif x2 > PA_C.DIRECTION_MARGIN then
    directionX = PA_L.EAST
  end

  if y2 < -1 * PA_C.DIRECTION_MARGIN then
    directionY = PA_L.SOUTH
  elseif y2 > PA_C.DIRECTION_MARGIN then
    directionY = PA_L.NORTH
  end

  return directionX, directionY
end

local function getPingMessage(objectName, directionX, directionY)
  local direction

  if directionX == '' and directionY == '' then
    direction = PA_L.NEARBY
  elseif directionX ~= '' and directionY ~= '' then
    direction = PA_L.DIRECTION..' '..directionY..' '..directionX
  else
    direction = PA_L.DIRECTION..' '..directionY..directionX
  end

  return PA_L.PINGED..': '..objectName..' '..direction
end

local function handlePing(unitId, x, y)
  -- Only consider pings coming from the player while there is a tooltip visible, when in a party
  local isPartyPing = unitId ~= PA_C.PLAYER
  local tooltipText = _G[PA_C.GAME_TOOLTIP]:GetText()
  local inParty = IsInGroup() and not IsInRaid()
  
  if isPartyPing or tooltipText == nil or not inParty then
    return
  end

  -- Throttle if needed
  local currentTime = time()
  if(LAST_PING_TIME == currentTime) then
    return
  else
    LAST_PING_TIME = currentTime
  end

  -- Determine the direction of the pinged coordinate
  local directionX, directionY = determineDirection(x, y)

  -- Let the party members know
  local messageText = getPingMessage(tooltipText, directionX, directionY)
  SendChatMessage(messageText, PA_C.PARTY_CHAT);
end

-- The addon entry is right here
local isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
if not isClassic then
  DEFAULT_CHAT_FRAME:AddMessage(PPF_L.TXT_NOT_CLASSIC)
  return
end

local PingAnnouncer = CreateFrame(PA_C.UIOBJECT_TYPE, PA_C.GA_NAME, UIParent)

PingAnnouncer:RegisterEvent(PA_C.EVENT_MINIMAP_PING)

PingAnnouncer:SetScript(PA_C.ATTR_ON_EVENT, function(self, event, ...)
  if (event == PA_C.EVENT_MINIMAP_PING) then
    handlePing(...)
  end
end)

PingAnnouncer:Hide()
