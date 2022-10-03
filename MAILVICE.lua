require "moonloader"
require "sampfuncs"
local ev = require "samp.events"

local key = false
function main()
	while not isSampLoaded() and not isSampfuncsLoaded() and not isSampAvailable() do wait(0xE4) end
	while true do
		wait(0x0)
		if not sampIsDialogActive() and not sampIsChatInputActive() and not isCharInAnyCar(PLAYER_PED) and isKeyDown(VK_SPACE) then
			key = not key
			_, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
			RakNet = allocateMemory(68)
			sampStorePlayerOnfootData(myId, RakNet)
			setStructElement(RakNet, 4, 2, key and 0 or 1024)
			sampSendOnfootData(RakNet)
			freeMemory(RakNet)
			wait(45)
		end
	end
end

function onReceiveRpc(id, bitstream)
	if id == 61 then
		ID = raknetBitStreamReadInt16(bitstream)
		--sampAddChatMessage(ID, -1)
		if ID == 25686 then 
			sampSendDialogResponse(ID, 1, 0, -1)
			return false
		end
	end
end
function ev.onServerMessage(color,text)
	if text:find('Вы начали работу почтальона!') then
		thisScript():unload()
	end
end