--[[
Samp Replay Mod v1.1
Автор: maynkraftpro2010
Тема на BlastHack: https://www.blast.hk/threads/138411/
Изменения версии 1.1:
- Автосохранение
- Ускорение повторов
- Возможность поставить воспроизведение на паузу
- Уведомление о новой версии скрипта
--]]
--------------------------------------------------------------
script_version("2") -- номер сборки
script_author("maynkraftpro2010")
--------------------------------------------------------------
local request = require("requests")
local imgui = require("imgui")
local inicfg = require("inicfg")
local encoding = require("encoding")
local font = renderCreateFont('Arial', 15, 4 + 8)
require("sampfuncs")
encoding.default = "CP1251"
u8 = encoding.UTF8
local windows_state = imgui.ImBool(false)
imgui.Process = false
--------------------------------------------------------------
local RecordingStates = {
	waiting = 0,
	record = 1,
	recorded = 2,
	replay = 3,
	loaded = 4
}
local NormalPackets = {
	PACKET_AIM_SYNC,
	PACKET_BULLET_SYNC,
	PACKET_UNOCCUPIED_SYNC,
	PACKET_TRAILER_SYNC,
	PACKET_PASSENGER_SYNC
}
local IgnoredRPCs = {
	RPC_SCRSETPLAYERHEALTH,
	RPC_SCRSETCAMERABEHINDPLAYER,
	RPC_SCRSETPLAYERCAMERALOOKAT,
	RPC_SCRSETPLAYERCAMERAPOS,
	RPC_SCRINTERPOLATECAMERA,
	RPC_SCRATTACHCAMERATOOBJECT,
	RPC_SPAWN,
	RPC_REQUESTSPAWN,
	RPC_SCRSETPLAYERWORLDBOUNDS,
	RPC_SCRTOGGLEPLAYERSPECTATING,
	RPC_SCRTOGGLEPLAYERCONTROLLABLE,
	RPC_SCRSETPLAYERPOS,
	RPC_SCRSETPLAYERFACINGANGLE,
	RPC_SCRPLAYERSPECTATEPLAYER,
	RPC_SCRPLAYERSPECTATEVEHICLE,
	RPC_CLICKTEXTDRAW,
	RPC_SCRSHOWTEXTDRAW,
	RPC_SCRSHOWDIALOG,
	RPC_SCRDISPLAYGAMETEXT,
	RPC_SCRGIVEPLAYERWEAPON,
	RPC_SCRREMOVEBUILDINGFORPLAYER
}
--------------------------------------------------------------
local _MenuPage = 1
local _Version = "1.1"
local _ReadMe = "ReplayMod v" .. _Version .. ". Активация: /rm. BlastHack: https://www.blast.hk/threads/138411.\nАвтор: maynkraftpro2010. 2021-2022. Не удаляйте этот файл во избежание крашей."
--------------------------------------------------------------
local _RecordingState = RecordingStates.waiting
local _LocalPlayerId = 1001
local _Pause = false
--------------------------------------------------------------
local _RpcRecorded = {}
local _RpcQueue = {}
local _RpcPlaying = {}
--------------------------------------------------------------
local _PacketRecorded = {}
local _PacketQueue = {}
local _PacketPlaying = {}
--------------------------------------------------------------
local _WaitingRpc = false
local _WaitingPacket = false
local _WaitingRpcIteration = 0
local _WaitingPacketIteration = 0
--------------------------------------------------------------
local _Multiplier = imgui.ImFloat(1)
--------------------------------------------------------------
local _InitGame = "8B000401C4680004621201000000E903808000000600B789019E000000000500000005000000050000000040000000200000020A6825A9AA040605C6640A6CAE4ECCAE400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
local _Players = {}
local _PlayersSerialized = {}
local _Vehicles = {}
local _VehiclesSerialized = {}
local _Objects = {}
local _ObjectsSerialized = {}
local _PlayersList = {}
local _PlayersListSerialized = {}
--------------------------------------------------------------

function Say(msg)
    sampAddChatMessage("{FF4D00}[ReplayMod]: {FFFFFF}" .. tostring(msg), -1)
end

function main()
    repeat wait(0) until isSampAvailable()

	if not doesDirectoryExist(getGameDirectory().."/moonloader/ReplayMod") then
        createDirectory(getGameDirectory().."/moonloader/ReplayMod")
    end

    if not doesFileExist(getGameDirectory().."/moonloader/ReplayMod/readme.txt") then
        io.open(getGameDirectory().."/moonloader/ReplayMod/readme.txt", "w"):write(_ReadMe):close()
    end

    Say("ReplayMod загружен!")
    Say("Активация: {FFFFFF}/replaymod")
    Say("Автор: {FFFFFF}minecraftpro2010")

    local result, response = pcall(request.get, "http://f0679564.xsph.ru/ReplayMod/latest.txt")
    if result then
        local resp = response.text
        if resp ~= _Version then
			Say("{FFFF00}Вы используете устаревшую версию скрипта: " .. _Version .. ". Новейшая версия: " .. resp .. ".")
		end
    end

    sampRegisterChatCommand("rm", function()
        windows_state.v = not windows_state.v
        imgui.Process = windows_state.v
    end)

    while true do wait(0)
        if windows_state.v == false then
            imgui.Process = false
        end

		if _RecordingState == RecordingStates.replay then
			if testCheat("OP") then
			 	local result, handle = sampGetCharHandleBySampPlayerId(_LocalPlayerId)
				if result then
					local x, y, z = getCharCoordinates(handle)
					setCharCoordinates(1, x, y, z)
				end
			end
		end
		
		scrx, scry = getScreenResolution()
		if _RecordingState == RecordingStates.record then
            renderFontDrawText(font, "REC", scrx - 47, 0, 0xFFFF0000)
        elseif _RecordingState == RecordingStates.replay then
            renderFontDrawText(font, "PLAY", scrx - 62, 0, 0xFFFF0000)
        end
    end
end

local Replay = {
	Start = function(arg)
		if arg == "User" then
			-- В следующем обновлении здесь будет код, который помещает в начало очереди разные RPC о создании всех объектов и игроков. Это нужно для начала записи в любой момент
		end
		Say("Запись началась!")
		_RecordingState = RecordingStates.record
		lua_thread.create(function()
			while _RecordingState == RecordingStates.record do -- автосохранение
				wait(60000)
				if _RecordingState == RecordingStates.record then
					RetardedSave()
				end
			end
		end)
		lua_thread.create(function()
			while _RecordingState == RecordingStates.record do
				wait(10)
				for i=1, 10 do
					if _RpcQueue[1] ~= nil then
						if _WaitingRpc then
							_WaitingRpc = false
							_RpcRecorded[#_RpcRecorded+1] = "! " .. _WaitingRpcIteration
							_WaitingRpcIteration = 0
						end
						_RpcRecorded[#_RpcRecorded+1] = _RpcQueue[1]
						table.remove(_RpcQueue, 1)
					else
						_WaitingRpc = true
						_WaitingRpcIteration = _WaitingRpcIteration + 1
					end
				end
			end
		end)
		lua_thread.create(function()
			while _RecordingState == RecordingStates.record do
				wait(10)
				for i=1, 100 do
					if _PacketQueue[1] ~= nil then
						if _WaitingPacket then
							_WaitingPacket = false
							_PacketRecorded[#_PacketRecorded+1] = "! " .. _WaitingPacketIteration
							_WaitingPacketIteration = 0
						end
						_PacketRecorded[#_PacketRecorded+1] = _PacketQueue[1]
						table.remove(_PacketQueue, 1)
					else
						_WaitingPacket = true
						_WaitingPacketIteration = _WaitingPacketIteration + 1
					end
				end
			end
		end)
	end,
	StopRecording = function()
		_RecordingState = RecordingStates.recorded
	end,
	Save = function(Mode)
		if Mode == "User" then -- мм, дублирующийся код. работает - не трогай
			_RecordingState = RecordingStates.waiting
			local FileName = DeGenerateName(Mode)
			local Presset = "[rpc]\nsize=0\n[packet]\nsize=0"
			io.open(getGameDirectory().. "/moonloader/ReplayMod/" .. FileName, "w"):write(Presset):close()

			local directIni = "moonloader/ReplayMod/" .. FileName
    		local mainIni = inicfg.load(nil, directIni)
			mainIni.rpc["size"] = #_RpcRecorded
        	for i=1, #_RpcRecorded do
        	    mainIni.rpc[i] = _RpcRecorded[i]
        	end

        	mainIni.packet["size"] = #_PacketRecorded
        	for i=1, #_PacketRecorded do
        	    mainIni.packet[i] = _PacketRecorded[i]
        	end

			if inicfg.save(mainIni, directIni) then
				Say("Сохранено как " .. FileName)
			end

			_RpcRecorded = {}
			_PacketRecorded = {}
		end
		if Mode == "Auto" then
			local FileName = DeGenerateName(Mode)
			local Presset = "[rpc]\nsize=0\n[packet]\nsize=0"
			io.open(getGameDirectory().. "/moonloader/ReplayMod/" .. FileName, "w"):write(Presset):close()

			local directIni = "moonloader/ReplayMod/" .. FileName
    		local mainIni = inicfg.load(nil, directIni)
			mainIni.rpc["size"] = #_RpcRecorded
        	for i=1, #_RpcRecorded do
        	    mainIni.rpc[i] = _RpcRecorded[i]
        	end

        	mainIni.packet["size"] = #_PacketRecorded
        	for i=1, #_PacketRecorded do
        	    mainIni.packet[i] = _PacketRecorded[i]
        	end

			if inicfg.save(mainIni, directIni) then
				Say("Сохранено как " .. FileName)
			end
		end
	end,
	Load = function(LoadPath)
		local directIni = "moonloader/ReplayMod/" .. LoadPath
        local mainIni = inicfg.load(nil, directIni)
        if mainIni == nil then return Say("При загрузке сохранения произошла ошибка!") end
		_RecordingState = RecordingStates.loaded
		Say(LoadPath .. " загружен.")
		_RpcRecorded = {}
		_PacketRecorded = {}
		_RpcPlaying = {}
		_PacketPlaying = {}
		for i=1, mainIni.rpc.size do
			if tostring(mainIni.rpc[i]):find("!") then
				local itter = string.match(mainIni.rpc[i], "! (%d+)")
				for i=1, itter do
					_RpcPlaying[#_RpcPlaying+1] = "nop"
				end
			else
				_RpcPlaying[#_RpcPlaying+1] = tostring(mainIni.rpc[i])
			end
		end
		for i=1, mainIni.packet.size do
			if tostring(mainIni.packet[i]):find("!") then
				local itter = string.match(mainIni.packet[i], "! (%d+)")
				for i=1, itter do
					_PacketPlaying[#_PacketPlaying+1] = "nop"
				end
			else
				_PacketPlaying[#_PacketPlaying+1] = tostring(mainIni.packet[i])
			end
		end
	end,
	Clear = function()
		_RpcRecorded = {}
		_PacketRecorded = {}
		_RpcPlaying = {}
		_PacketPlaying = {}
		_RecordingState = RecordingStates.waiting
	end,
	StopPlay = function()
		_RecordingState = RecordingStates.waiting
	end,
	Play = function()
		RemoveAllContent()
		Say("Воспроизведение началось!")
		_RecordingState = RecordingStates.replay
		lua_thread.create(function()
			local Iteration = 0
			while _RecordingState == RecordingStates.replay and Iteration < #_RpcPlaying do
				wait(10)
				for i=1, math.floor(10 * _Multiplier.v) do
					if not _Pause then
                    	Iteration = Iteration + 1

						local DoesIgnoreRPC = false
                    	if _RpcPlaying[Iteration] ~= "nop" and _RpcPlaying[Iteration] ~= "dlg" and not _RpcPlaying[Iteration]:find("CONNECT") and _RpcPlaying[Iteration] ~= nil then
							for i=1, #IgnoredRPCs do
								local HexID = _RpcPlaying[Iteration]:sub(1, 2)
								local RpcID = tonumber("0x" .. HexID)
								if RpcID == IgnoredRPCs[i] then
									DoesIgnoreRPC = true
								end
							end
							if not DoesIgnoreRPC then
								EmulateSerializedData(_RpcPlaying[Iteration], "RPC")
								if tonumber("0x" .. _RpcPlaying[Iteration]:sub(1, 2)) == RPC_SCRINITGAME then
									sampSpawnPlayer()
								end
							end
                    	end

                    	if _RpcPlaying[Iteration] == "dlg" then
                    	    local memory = require("memory")
                    	    memory.setint32(sampGetDialogInfoPtr() + 40, 0, true)
                    	    sampToggleCursor(false)
                    	end

						if _RpcPlaying[Iteration]:find("CONNECT") then
							local id, name = string.match(_RpcPlaying[Iteration], "CONNECT (.-) (.+)")
							_LocalPlayerId = id
							local bs = raknetNewBitStream()
							raknetBitStreamWriteInt16(bs, tonumber(id))
							raknetBitStreamWriteInt32(bs, 0)
							raknetBitStreamWriteInt8(bs, 0)
							raknetBitStreamWriteInt8(bs, #name)
							raknetBitStreamWriteString(bs, name)
							raknetEmulRpcReceiveBitStream(137, bs)
							raknetDeleteBitStream(bs)

							local bs = raknetNewBitStream()
							raknetBitStreamWriteInt16(bs, tonumber(id))
							raknetBitStreamWriteInt8(bs, 0)
							raknetBitStreamWriteInt32(bs, 0)
							raknetBitStreamWriteFloat(bs, 0.0)
							raknetBitStreamWriteFloat(bs, 0.0)
							raknetBitStreamWriteFloat(bs, 0.0)
							raknetBitStreamWriteFloat(bs, 0.0)
							raknetBitStreamWriteInt32(bs, 0)
							raknetBitStreamWriteInt8(bs, 0)
							raknetEmulRpcReceiveBitStream(32, bs)
							raknetDeleteBitStream(bs)
						end

                    	if Iteration == #_RpcPlaying then
                    	    _RecordingState = RecordingStates.loaded
                    	end

                    	if _RecordingState ~= RecordingStates.replay then
                    	    break
                    	end
					end
                end
			end
			Say("Эмуляция RPC завершена.")
		end)
		lua_thread.create(function()
			local Iteration = 0
			while _RecordingState == RecordingStates.replay and Iteration < #_PacketPlaying do
				wait(10)
				for i=1, math.floor(100 * _Multiplier.v) do
					if not _Pause then
                    	Iteration = Iteration + 1

						if _PacketPlaying[Iteration] ~= "nop" and _PacketPlaying[Iteration] ~= "dlg" and _PacketPlaying[Iteration] ~= nil then
							EmulateSerializedData(_PacketPlaying[Iteration], "Packet")
                    	end

                    	if _RecordingState ~= RecordingStates.replay then
                    	    break
                    	end
					end
                end
			end
			Say("Эмуляция пакетов завершена.")
		end)
	end,
	Pause = function()
		_Pause = not _Pause
		Say(_Pause and "Воспроизведение приостановлено" or "Воспроизведение возобновлено")
	end,
}

function imgui.OnDrawFrame()
    imgui.SetNextWindowSize(imgui.ImVec2(700, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(1280 / 4, 1024 / 2), imgui.Cond.FirstUseEver)
    imgui.Begin(u8"Samp Replay Mod by maynkraftpro2010 v" .. _Version, windows_state, imgui.WindowFlags.NoResize)

    imgui.BeginChild("Buttons", imgui.ImVec2(200, 258), true)
        if imgui.Button(u8"Воспроизведение", imgui.ImVec2(-0.1, 79)) then
            _MenuPage = 1
        end
        if imgui.Button(u8"Сохранения", imgui.ImVec2(-0.1, 79)) then
            _MenuPage = 2
        end
        if imgui.Button(u8"Информация", imgui.ImVec2(-0.1, 79)) then
            _MenuPage = 3
        end
    imgui.EndChild()

    imgui.SameLine()

    imgui.BeginChild("Settings", imgui.ImVec2(480, 258), true)
        if _MenuPage == 1 then
			if _RecordingState == RecordingStates.waiting then
				imgui.CenterText(u8"Для начала записи зайдите на сервер.")
				--if imgui.Button(u8"Начать запись", imgui.ImVec2(-0.1, -0.1)) then
				--	Replay.Start("User")
				--end
			elseif _RecordingState == RecordingStates.record then
				if imgui.Button(u8"Остановить запись", imgui.ImVec2(-0.1, -0.1)) then
					Replay.StopRecording()
				end
			elseif _RecordingState == RecordingStates.recorded then
				if imgui.Button(u8"Сохранить", imgui.ImVec2(-0.1, 120)) then
					Replay.Save("User")
				end
				if imgui.Button(u8"Удалить", imgui.ImVec2(-0.1, 120)) then
					Replay.Clear()
				end
			elseif _RecordingState == RecordingStates.replay then
				if imgui.Button(_Pause and u8"Продолжить воспроизведение" or u8"Поставить на паузу", imgui.ImVec2(-0.1, 120)) then
					Replay.Pause()
				end
				if imgui.Button(u8"Остановить воспроизведение", imgui.ImVec2(-0.1, -0.1)) then
					Replay.StopPlay()
				end
			elseif _RecordingState == RecordingStates.loaded then
				if imgui.Button(u8"Воспроизвести", imgui.ImVec2(-0.1, 120)) then
					Replay.Play()
				end
				if imgui.Button(u8"Очистить", imgui.ImVec2(-0.1, 120)) then
					Replay.Clear()
				end
			end
        elseif _MenuPage == 2 then
			local files, count = {}, 0
        	local handle, file = findFirstFile("moonloader/ReplayMod/*.*")
        	while file do
        	    files[#files + 1] = file
        	    count = count + 1
        	    file = findNextFile(handle)
        	end
        	findClose(handle)

        	for i=#files, 1, -1 do
        	    if files[i] ~= "readme.txt" and files[i] ~= "." and files[i] ~= ".." then
        	        if imgui.CollapsingHeader(u8(files[i])) then
        	            if imgui.Button(u8"Загрузить", imgui.ImVec2(230, 20)) then
							Replay.Load(files[i])
        	            end

        	            imgui.SameLine()

        	            if imgui.Button(u8"Удалить", imgui.ImVec2(230, 20)) then
        	                os.remove(getGameDirectory().."/moonloader/ReplayMod/"..files[i])
        	            end
        	        end
        	    end
        	end
        elseif _MenuPage == 3 then
			if imgui.CollapsingHeader("Debug Info") then
				imgui.CenterText("Debug Info:")
				imgui.Text(u8"Записанные пакеты: " .. #_PacketRecorded)
				imgui.Text(u8"Записанные RPC: " .. #_RpcRecorded)
				imgui.Text(u8"Пакеты в очереди на запись: " .. #_PacketQueue)
				imgui.Text(u8"RPC в очереди на запись:" .. #_RpcQueue)
				imgui.Text(u8"Длительность воспроизведения: " .. (#_PacketPlaying/100) / 60 / 60 .. u8" мин.")
			end
			if imgui.CollapsingHeader(u8"Настройки") then
				imgui.BeginChild("Settings", imgui.ImVec2(-0.1, -0.1), true)
					if imgui.Button(u8"Перейти в режим просмотра", imgui.ImVec2(-0.1, 30)) then
						RemoveAllContent()
					end
					imgui.CenterText(u8"Скорость воспроизведения:")
					imgui.PushItemWidth(-1)
					imgui.SliderFloat(u8"Скорость воспроизведения", _Multiplier, 0.5, 3)
				imgui.EndChild()
			end
			imgui.CenterText(u8"")
			imgui.CenterText(u8"Samp Replay Mod v" .. _Version)
			imgui.CenterText(u8"Активация: /rm")
			imgui.CenterText(u8"Автор: maynkraftpro2010. 2021-2022.")
        end
    imgui.EndChild()

    imgui.End()
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function onReceiveRpc(id, BitStream)
	if _RecordingState == RecordingStates.record then
		_RpcQueue[#_RpcQueue+1] = SerializeData(id, BitStream, "RPC")
		if id == RPC_SCRINITGAME then
			_InitGame = SerializeData(id, BitStream, "RPC")
			lua_thread.create(function()
				wait(5000)
				_RpcQueue[#_RpcQueue+1] = "CONNECT " .. sampGetLocalPlayerId() .. " " .. sampGetPlayerNickname(sampGetLocalPlayerId())
			end)
		end
	end
end

function onReceivePacket(id, BitStream)
	if id == PACKET_CONNECTION_REQUEST_ACCEPTED and _RecordingState == RecordingStates.waiting then
		Replay.Start()
	end

	if _RecordingState == RecordingStates.record then
		_PacketQueue[#_PacketQueue+1] = SerializeData(id, BitStream, "Packet")
	end
end

function onSendRpc(id, BitStream)
	if _RecordingState == RecordingStates.record then
		if id == RPC_ENTERVEHICLE then
			local VehicleID = raknetBitStreamReadInt16(BitStream)
			local IsPassenger = raknetBitStreamReadInt8(BitStream)
			_RpcQueue[#_RpcQueue+1] = DecToBinary(id, 8) .. BigEndianToLittleEndian(DecToBinary(sampGetLocalPlayerId(), 16)) .. BigEndianToLittleEndian(DecToBinary(VehicleID, 16)) .. DecToBinary(IsPassenger, 8)
		end
	end
end

function onSendPacket(id, BitStream)
	if _RecordingState == RecordingStates.record then
		if id == PACKET_PLAYER_SYNC or id == PACKET_VEHICLE_SYNC then
			_PacketQueue[#_PacketQueue+1] = ConvertOutputData(id, BitStream, true)
		end

		for i=1, #NormalPackets do
			if id == NormalPackets[i] then
				_PacketQueue[#_PacketQueue+1] = ConvertOutputData(id, BitStream, false)
			end
		end
	end
end

function ConvertOutputData(Mode, BitStream, IsCompressed) -- год разработки ушел на это
	raknetBitStreamSetReadOffset(BitStream, 8)
	local BitString = DecToBinary(Mode, 8) .. BigEndianToLittleEndian(DecToBinary(sampGetLocalPlayerId(), 16))
	if IsCompressed then
		if Mode == PACKET_PLAYER_SYNC then
			local LrKey = raknetBitStreamReadInt16(BitStream)
			if LrKey ~= 0 then
				BitString = BitString .. "1"
				BitString = BitString .. BigEndianToLittleEndian(DecToBinary(LrKey, 16))
			else
				BitString = BitString .. "0"
			end

			local UdKey = raknetBitStreamReadInt16(BitStream)
			if UdKey ~= 0 then
				BitString = BitString .. "1"
				BitString = BitString .. BigEndianToLittleEndian(DecToBinary(UdKey, 16))
			else
				BitString = BitString .. "0"
			end
			
			local Keys = raknetBitStreamReadInt16(BitStream)
			if Keys == 160 then Keys = 0 end -- ебучий пед удаляется если так не сделать
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(Keys, 16))
			
			local X, Y, Z = raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream)
			BitString = BitString .. HexStringToBitString(FloatToLittleEndianBitString(X)) .. HexStringToBitString(FloatToLittleEndianBitString(Y)) .. HexStringToBitString(FloatToLittleEndianBitString(Z))

			local QuatW, QuatX, QuatY, QuatZ = raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream)
			BitString = BitString .. BoolToNum(QuatW < 0) .. BoolToNum(QuatX < 0) .. BoolToNum(QuatY < 0) .. BoolToNum(QuatZ < 0)
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(math.floor(math.abs(QuatX) * 65535), 16))
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(math.floor(math.abs(QuatY) * 65535), 16))
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(math.floor(math.abs(QuatZ) * 65535), 16))

			local Health = raknetBitStreamReadInt8(BitStream)
			local Armor = raknetBitStreamReadInt8(BitStream)
			BitString = BitString .. DecToBinary(compress_health_and_armor(Health, Armor), 8)

			local Weapon = raknetBitStreamReadInt8(BitStream)
        	BitString = BitString .. DecToBinary(Weapon, 8)
        	local SpecialAction = raknetBitStreamReadInt8(BitStream)
        	BitString = BitString .. DecToBinary(SpecialAction, 8)

			local MovespeedX, MovespeedY, MovespeedZ = raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream)
			local Magnitude = math.sqrt(MovespeedX * MovespeedX + MovespeedY * MovespeedY + MovespeedZ * MovespeedZ)
			BitString = BitString .. HexStringToBitString(FloatToLittleEndianBitString(Magnitude))
			if Magnitude == 0 then Magnitude = 0.0001 end -- так надо.
			if Magnitude > 0 then
				BitString = BitString .. writeCf(MovespeedX / Magnitude)
				BitString = BitString .. writeCf(MovespeedY / Magnitude)
				BitString = BitString .. writeCf(MovespeedZ / Magnitude)
			end

			BitString = BitString .. "0"
			local SurfingVehicleID = raknetBitStreamReadInt16(BitStream) -- сделаю завтра
        	local SurfOffsetX = raknetBitStreamReadFloat(BitStream)
        	local SurfOffsetY = raknetBitStreamReadFloat(BitStream)
        	local SurfOffsetZ = raknetBitStreamReadFloat(BitStream)

			local AnimID = raknetBitStreamReadInt16(bs)
        	local AnimFlags = raknetBitStreamReadInt16(bs)
        	BitString = BitString .. "1"
        	BitString = BitString .. DecToBinary(AnimID, 16)
        	BitString = BitString .. DecToBinary(AnimFlags, 16)

			repeat BitString = BitString .. "0" until #BitString % 8 == 0 -- так надо.
			BitString = BitStringToHexString(BitString)
			return BitString
		end
		if Mode == PACKET_VEHICLE_SYNC then
			local CarID = raknetBitStreamReadInt16(BitStream)
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(CarID, 16))

			local LrKey = raknetBitStreamReadInt16(BitStream)
        	if LrKey ~= 0 then
        	    if LrKey == 65408 then -- 80FF -- я не помню, но почему-то по-другому не работает
        	        BitString = BitString .. "1000000011111111"
        	    elseif LrKey == 128 then -- 8000
        	        BitString = BitString .. "1000000000000000"
        	    end
        	else
        	    BitString = BitString .. "0000000000000000"
        	end

        	local UdKey = raknetBitStreamReadInt16(BitStream)
        	if UdKey ~= 0 then
        	    if UdKey == 65408 then -- 80FF
        	        BitString = BitString .. "1000000011111111"
        	    elseif UdKey == 128 then -- 8000
        	        BitString = BitString .. "1000000000000000"
        	    end
        	else
        	    BitString = BitString .. "0000000000000000"
        	end
			
			local Keys = raknetBitStreamReadInt16(BitStream)
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(Keys, 16))

			local QuatW, QuatX, QuatY, QuatZ = raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream)
			BitString = BitString .. BoolToNum(QuatW < 0) .. BoolToNum(QuatX < 0) .. BoolToNum(QuatY < 0) .. BoolToNum(QuatZ < 0)
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(math.floor(math.abs(QuatX) * 65535), 16))
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(math.floor(math.abs(QuatY) * 65535), 16))
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(math.floor(math.abs(QuatZ) * 65535), 16))
			
			local X, Y, Z = raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream)
			BitString = BitString .. HexStringToBitString(FloatToLittleEndianBitString(X)) .. HexStringToBitString(FloatToLittleEndianBitString(Y)) .. HexStringToBitString(FloatToLittleEndianBitString(Z))

			local MovespeedX, MovespeedY, MovespeedZ = raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream), raknetBitStreamReadFloat(BitStream)
			local Magnitude = math.sqrt(MovespeedX * MovespeedX + MovespeedY * MovespeedY + MovespeedZ * MovespeedZ)
			if Magnitude == 0 then Magnitude = 0.001 end -- так надо.
			BitString = BitString .. HexStringToBitString(FloatToLittleEndianBitString(Magnitude))
			if Magnitude > 0 then
				BitString = BitString .. writeCf(MovespeedX / Magnitude)
				BitString = BitString .. writeCf(MovespeedY / Magnitude)
				BitString = BitString .. writeCf(MovespeedZ / Magnitude)
			end

			local CarHealth = raknetBitStreamReadFloat(BitStream) -- всегда показывает 1000, чзх бессмертная машина?
			BitString = BitString .. BigEndianToLittleEndian(DecToBinary(CarHealth, 16)) 

			local Health = raknetBitStreamReadInt8(BitStream)
			local Armor = raknetBitStreamReadInt8(BitStream)
			BitString = BitString .. DecToBinary(compress_health_and_armor(Health, Armor), 8)

			local Weapon = raknetBitStreamReadInt8(BitStream)
        	BitString = BitString .. DecToBinary(Weapon, 8)

			local SirenState = raknetBitStreamReadBool(BitStream)
			BitString = BitString .. BoolToNum(SirenState)

			local GearState = raknetBitStreamReadBool(BitStream)
			BitString = BitString .. BoolToNum(GearState)

			local TrainSpeed = raknetBitStreamReadFloat(BitStream)
        	if TrainSpeed ~= 0 then
        	    BitString = BitString .. "1"
        	    BitString = BitString .. "00000000000000000000000000000000" -- мне лень делать отдельное преобразование для 32 бит соре
        	else
        	    BitString = BitString .. "0"
        	end
		
        	local TrailerID = raknetBitStreamReadInt16(BitStream)
        	if TrailerID ~= 0 then
        	    BitString = BitString .. "1"
        	    BitString = BitString .. BigEndianToLittleEndian(DecToBinary(TrailerID, 16)) 
        	else
        	    BitString = BitString .. "0"
        	end

			repeat BitString = BitString .. "0" until #BitString % 8 == 0 -- и не спрашивайте зачем
			BitString = BitStringToHexString(BitString)
			return BitString
		end
	else
		for i=1, raknetBitStreamGetNumberOfUnreadBits(BitStream) / 8 do
			BitString = BitString .. DecToBinary(raknetBitStreamReadInt8(BitStream), 8)
		end
		BitString = BitStringToHexString(BitString)
		return BitString
	end
end

function EmulateSerializedData(SerializedString, Mode)
	local DeserializedBytes = DeserializeString(SerializedString)
	local Id = DeserializedBytes[1]
	table.remove(DeserializedBytes, 1)
	local BitStream = raknetNewBitStream()
	for i=1, #DeserializedBytes do
		raknetBitStreamWriteInt8(BitStream, DeserializedBytes[i])
	end
	if Mode == "RPC" then
		raknetEmulRpcReceiveBitStream(Id, BitStream)
	elseif Mode == "Packet" then
		raknetEmulPacketReceiveBitStream(Id, BitStream)
	end
	raknetDeleteBitStream(BitStream)
end

function DeserializeString(SerializedString)
	local DeserializedBytes = {}
	local SerializedBytes = {}
	for i=1, #SerializedString, 2 do
		SerializedBytes[#SerializedBytes+1] = tostring(SerializedString):sub(i, i+1)
	end
	for i=1, #SerializedBytes do
		DeserializedBytes[i] = tonumber(SerializedBytes[i], 16)
	end
	return DeserializedBytes
end

function SerializeData(id, BitStream, Mode)
	local SerializedString = ToHex(id)
	if Mode == "Packet" then raknetBitStreamSetReadOffset(BitStream, 8) end
	local Bytes = {}
	for i=1, raknetBitStreamGetNumberOfUnreadBits(BitStream) / 8 do
		Bytes[i] = raknetBitStreamReadInt8(BitStream)
	end
	if id == RPC_SCRINITGAME and Mode == "RPC" then
		Bytes[14] = 233
		Bytes[15] = 3
		--[[
		специально для этого скрипта я попросил калкора в 2015 году увеличить лимит игроков до 1004
		чтобы можно было использовать дополнительные слоты. в данном скрипте локальному игроку выдается
		1001 ид чтобы не забирать его у других игроков при повторе. остальные 4 ида (1000, 1002, 1003, 1004)
		используются для входа на фулловый сервер арз вне очереди. если вы видели игрока с
		каким-то из этих ид, то знайте - это был калкор.
		--]]
	end
	for i=1, #Bytes do
		SerializedString = SerializedString .. ToHex(Bytes[i])
	end
	return CompressHexString(SerializedString)
end

--------------------------------------------------------------

function CompressHexString(string)
	return string
end

function DecompressHexString(string)
	return string
end

function compress_health_and_armor(hp, armor)
	local hpAp = 0
	if hp > 0 and hp < 100 then hpAp = bit.lshift(hp / 7, 4)
	elseif hp >= 100 then hpAp = 0xF0
	end
	if armor > 0 and armor < 100 then hpAp = bit.bor(hpAp, armor / 7)
	elseif armor >= 100 then hpAp = bit.bor(hpAp, 0x0F)
	end
	return hpAp
end

function writeCf(value)
    if value < -1 then
        value = -1
    elseif value > 1 then
        value = 1
    end
    local result = BigEndianToLittleEndian(DecToBinary((math.floor((value + 1) * 32767.5)), 16))
    return result
end

function FloatToBigEndianBitString(n) -- ахуеть
    if n == 0.0 then return 0.0 end

    local sign = 0
    if n < 0.0 then
        sign = 0x80
        n = -n
    end

    local mant, expo = math.frexp(n)
    local hext = {}

    if mant ~= mant then
        hext[#hext+1] = string.char(0xFF, 0x88, 0x00, 0x00)

    elseif mant == math.huge or expo > 0x80 then
        if sign == 0 then
            hext[#hext+1] = string.char(0x7F, 0x80, 0x00, 0x00)
        else
            hext[#hext+1] = string.char(0xFF, 0x80, 0x00, 0x00)
        end

    elseif (mant == 0.0 and expo == 0) or expo < -0x7E then
        hext[#hext+1] = string.char(sign, 0x00, 0x00, 0x00)

    else
        expo = expo + 0x7E
        mant = (mant * 2.0 - 1.0) * math.ldexp(0.5, 24)
        hext[#hext+1] = string.char(sign + math.floor(expo / 0x2),
                                    (expo % 0x2) * 0x80 + math.floor(mant / 0x10000),
                                    math.floor(mant / 0x100) % 0x100,
                                    mant % 0x100)
    end

    return string.gsub(table.concat(hext),"(.)",
                                function (c) return string.format("%02X%s",string.byte(c),"") end)
end

function FloatToLittleEndianBitString(FloatNumber)
	local BigEndianHexString = FloatToBigEndianBitString(FloatNumber)
	local LittleEndianBits = ""
	local bytes = {}
    local hexarr = StringToTable(BigEndianHexString)
    for i=1, #hexarr/2 do
        bytes[#bytes+1] = hexarr[1] .. hexarr[2]
        table.remove(hexarr, 1)
        table.remove(hexarr, 1)
    end
    bytes = Reverse(bytes)
    return table.concat(bytes)
end

function BitStringToHexString(s)
    local bin2hex = {
        ["0000"] = "0",
        ["0001"] = "1",
        ["0010"] = "2",
        ["0011"] = "3",
        ["0100"] = "4",
        ["0101"] = "5",
        ["0110"] = "6",
        ["0111"] = "7",
        ["1000"] = "8",
        ["1001"] = "9",
        ["1010"] = "A",
        ["1011"] = "B",
        ["1100"] = "C",
        ["1101"] = "D",
        ["1110"] = "E",
        ["1111"] = "F"
    }
    
    local l = 0
    local h = ""
    local b = ""
    local rem
    
    l = string.len(s)
    rem = l % 4
    l = l-1
    h = ""
    
    if (rem > 0) then
        s = string.rep("0", 4 - rem)..s
    end

    for i = 1, l, 4 do
        b = string.sub(s, i, i+3)
        h = h..bin2hex[b]
    end

    return h
end

function HexStringToBitString(hexstr)
    local hex2bin = {
        ["0"] = "0000",
        ["1"] = "0001",
        ["2"] = "0010",
        ["3"] = "0011",
        ["4"] = "0100",
        ["5"] = "0101",
        ["6"] = "0110",
        ["7"] = "0111",
        ["8"] = "1000",
        ["9"] = "1001",
        ["A"] = "1010",
        ["B"] = "1011",
        ["C"] = "1100",
        ["D"] = "1101",
        ["E"] = "1110",
        ["F"] = "1111"
    }

    local ret = ""
    for i = 1, #hexstr do
        ret = ret..hex2bin[hexstr:sub(i, i)]
    end
    
    return ret
end

function BigEndianToLittleEndian(BigEndianBits)
	local LittleEndianBits = ""
	if #BigEndianBits == 16 then
		LittleEndianBits = BigEndianBits:sub(9, 16) .. BigEndianBits:sub(1, 8)
	end
	return LittleEndianBits
end

function DecToBinary(num, bits)
    bits = bits or math.max(1, select(2, math.frexp(num)))
    local t = {} 
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    return table.concat(t)
end

function sampGetLocalPlayerId()
	return select(2, sampGetPlayerIdByCharHandle(1))
end

function ToHex(int)
    local string = string.format("%X", tostring(int))
    if #string == 1 then
        string = "0" .. string
    end
    return string
end

function RemoveAllContent()
	if _RecordingState == RecordingStates.record then
		_RecordingState = RecordingStates.waiting
	end
	lua_thread.create(function()
		sampDisconnectWithReason(bebra)
		wait(1000)
		sampSetGamestate(3)
		wait(1000)
		sampSpawnPlayerWithEmulation()
		wait(1000)
		deactivateSpectatorMode()
		wait(1000)
		sampSpawnPlayer()
		restoreCameraJumpcut()
		wait(5000)
		setCharCoordinates(1, 2490, -1670, 13.38)
	end)
end

function StringToTable(string)
    local table = {}
    for i=1, #tostring(string) do
        table[i] = tostring(string):sub(i, i)
    end
    return table
end

function Reverse(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function BoolToNum(bebra)
	return bebra and "1" or "0"
end

function DeGenerateName(Mode)
	if Mode == "User" then return tostring(os.date("%Y-%m-%d_%H-%M-%S")) .. ".save" end
	if Mode == "Auto" then return "Autosave-" .. sampGetPlayerNickname(sampGetLocalPlayerId()) .. ".bak" end
end

function RetardedSave()
	Replay.Save("Auto")
end

function ApplyCustomStyle()
	imgui.SwitchContext()
	local style  = imgui.GetStyle()
	local colors = style.Colors
	local clr    = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowRounding = 4.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 4.0
    style.FrameRounding = 4.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 4.0

	colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]         = ImVec4(0.73, 0.75, 0.74, 1.00)
	colors[clr.WindowBg]             = ImVec4(0.09, 0.09, 0.09, 0.94)
	colors[clr.ChildWindowBg]        = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PopupBg]              = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.Border]               = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.BorderShadow]         = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.FrameBg]              = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.FrameBgHovered]       = ImVec4(1.00, 0.36, 0.00, 1.00)
	colors[clr.FrameBgActive]        = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.TitleBg]              = ImVec4(1.00, 0.30, 0.00, 0.49)
	colors[clr.TitleBgActive]        = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.TitleBgCollapsed]     = ImVec4(1.00, 0.49, 0.00, 1.00)
	colors[clr.MenuBarBg]            = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.ScrollbarBg]          = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.ScrollbarGrab]        = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(1.00, 0.36, 0.00, 1.00)
	colors[clr.ScrollbarGrabActive]  = ImVec4(1.00, 0.69, 0.00, 1.00)
	colors[clr.ComboBg]              = ImVec4(1.00, 0.55, 0.18, 1.00)
	colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrab]           = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.SliderGrabActive]     = ImVec4(1.00, 0.55, 0.00, 1.00)
	colors[clr.Button]               = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.ButtonHovered]        = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.ButtonActive]         = ImVec4(1.00, 0.18, 0.00, 1.00)
	colors[clr.Header]               = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.HeaderHovered]        = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.HeaderActive]         = ImVec4(1.00, 0.18, 0.00, 1.00)
	colors[clr.Separator]            = ImVec4(1.00, 1.00, 0.00, 1.00)
	colors[clr.SeparatorHovered]     = ImVec4(1.00, 1.00, 0.31, 1.00)
	colors[clr.SeparatorActive]      = ImVec4(1.00, 1.00, 0.56, 1.00)
	colors[clr.ResizeGrip]           = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.ResizeGripHovered]    = ImVec4(1.00, 0.43, 0.00, 1.00)
	colors[clr.ResizeGripActive]     = ImVec4(1.00, 0.18, 0.00, 1.00)
	colors[clr.CloseButton]          = ImVec4(1.00, 0.30, 0.00, 1.00)
	colors[clr.CloseButtonHovered]   = ImVec4(1.00, 0.56, 0.00, 1.00)
	colors[clr.CloseButtonActive]    = ImVec4(1.00, 0.18, 0.00, 1.00)
	colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]     = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]       = ImVec4(1.00, 0.68, 0.00, 1.00)
	colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function sampSpawnPlayerWithEmulation()
	emul_rpc('onRequestSpawnResponse', {true})
	emul_rpc('onSetSpawnInfo', {0, 74, 0, {0, 0, 0}, 0, {0}, {0}})
	restoreCameraJumpcut()
end

function deactivateSpectatorMode()
	local bs = raknetNewBitStream()
    raknetBitStreamWriteInt32(bs, 0)
    raknetEmulRpcReceiveBitStream(124, bs)
    raknetDeleteBitStream(bs)
end

function emul_rpc(hook, parameters)
    local bs_io = require 'samp.events.bitstream_io'
    local handler = require 'samp.events.handlers'
    local extra_types = require 'samp.events.extra_types'
    local hooks = {
        ['onRequestSpawnResponse'] = { 'bool8', 129 },
        ['onSetSpawnInfo'] = { 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 68 }
    }
    local extra = {
        ['PlayerScorePingMap'] = true,
        ['Int32Array3'] = true
    }
    local hook_table = hooks[hook]
    if hook_table then
        local bs = raknetNewBitStream()
        local max = #hook_table-1
        if max > 0 then
            for i = 1, max do
                local p = hook_table[i]
                if extra[p] then extra_types[p]['write'](bs, parameters[i])
                else bs_io[p]['write'](bs, parameters[i]) end
            end
        end
        raknetEmulRpcReceiveBitStream(hook_table[#hook_table], bs)
        raknetDeleteBitStream(bs)
    end
end

ApplyCustomStyle()