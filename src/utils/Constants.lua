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

-- All addons share the global namespace and global name conflicts are possible.
-- Bundling all constants in a single object to avoid possible conflicts.
PA_C = {}

PA_C.DIRECTION_MARGIN = 0.02
PA_C.MINIMUM_SECONDS = 4

PA_C.NAME = 'PingAnnouncer'

PA_C.UIOBJECT_TYPE = 'Frame'
PA_C.GAME_TOOLTIP = 'GameTooltipTextLeft1'
PA_C.PLAYER = 'player'
PA_C.PARTY_CHAT = 'PARTY'

PA_C.CVAR_ROTATE_MINIMAP = 'rotateMinimap'
PA_C.ATTR_ON_EVENT = 'OnEvent'
PA_C.EVENT_MINIMAP_PING = 'MINIMAP_PING'

return PA_C
