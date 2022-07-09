script_name('AFK Tools (upd)')
script_author("skeez")
script_version('2.0.9 (ñ ïàáëèêîì)')
script_properties('work-in-pause')
local dlstatus = require("moonloader").download_status
local imgui = require('imgui')
local encoding = require("encoding")
local sampev = require("samp.events")
local memory = require("memory")
local effil = require("effil")
local inicfg = require("inicfg")
encoding.default = 'CP1251'
u8 = encoding.UTF8

if not doesDirectoryExist('moonloader/config') then
	createDirectory('moonloader/config')
end

local path = getWorkingDirectory() .. "\\config"

local mainIni = inicfg.load({
	autologin = {
		state = false
	},
	arec ={
		state = false,
		statebanned = false,
		wait = 50
	},
	roulette = {
		standart = false,
		donate = false,
		platina = false,
		wait = 1000
	},
	vknotf = {
		token = 'f4a2a0348f59ed335a1d94b434242834ca9a272b18b6364e93933d3138dc4dfe1710bdac6e1f08956cc07',
		user_id = '',
		group_id = '198189955',
		state = false,
		isinitgame = false,
		ishungry = false,
		iscloseconnect = false,
		isadm = false,
		iscode = false,
		isdemorgan = false,
		islowhp = false,
		ispayday = false,
		iscrashscript = false,
		issellitem = false,
		issmscall = false,
		record = false,
		ismeat = false
	},
	piar = {
		piar1 = '',
		piar2 = '',
		piar3 = '',
		piarwait = 50,
		piarwait2 = 50,
		piarwait3 = 50,
		auto_piar = false,
		auto_piar_kd = 300,
		last_time = os.time(),
	},
	eat = {
		checkmethod = 0,
		eat2met = 30,
		cycwait = 30,
		setmetod = 0,
        eatmetod = 0,
        healstate = false,
        hplvl = 30,
        hpmetod = 0,
        arztextdrawid = 648,
        arztextdrawidheal = 646,
        drugsquen = 1
	},
	config = {
		banscreen = false,
		antiafk = false,
		autoad = false,
		autoo = false,
		atext = '',
		lastvrmessage = '',
		returnmessageforvr = false,
		autoadbiz = false,
		fastconnect = false
	}
},'afktools.ini')

if not doesFileExist('moonloader/config/afktools.ini') then
	inicfg.save(mainIni,'afktools.ini')
end

changelog = [[
	v1.0
		Ðåëèç
	v1.1 
		Äîáàâèë àâòîîáíîâëåíèå
		Äîáàâèë íîâûå ñîáûòèÿ äëÿ óâåäîìëåíèé 
		Èçìåíèë àâòîëîãèí, òåïåðü ýòî àâòîçàïîëíåíèå
	v1.2
		Óïðàâëåíèå èãðîé ÷åðåç êîìàíäû: !getplstats, !getplinfo, !send(à òàê æå êíîïêè) 
		Íîâîå ñîáûòèå äëÿ îòïðàâêè óâåäîìëåíèÿ: ïðè âûõîäå èç äåìîðãàíà
		Äîáàâèë ôëóäåð íà 3 ñòðîêè(åñëè 2 èëè 3 ñòðîêà íå íóæíà îñòàâüòå å¸ ïóñòîé)
	v1.25 - Hotfix
		Èñïðàâèë êðàø ïðè îòïðàâêå óâåäîìëåíèÿ î òîì ÷òî ïåðñ ãîëîäåí
	v1.3
		Äîáàâèë îòêðûòèå äîíàò ñóíäóêà (âíèìàòåëüíî ÷èòàéòå êàê ñäåëàòü ÷òîá ðàáîòàëî)
		Äëÿ óêðàèíöåâ: äîáàâèë âîçìîæíîñòü âûðóáèòü VK Notifications è ñïîêîéíî èñïîëüçîâàòü ñêðèïò
	v1.4
		Ïîôèêñèë àâòîîòêðûòèå åñëè èãðà ñâåðíóòà
	v1.5
		Ïåðåïèñàë ôóíêöèþ ïðèíÿòèÿ óâåäîìëåíèé
		Òåïåðü àâòîõèëë íå ôëóäèò
	v1.6
		Ðåëèç íà BlastHack
		Ê êàæäîé ñòðîêå ôëóäåðà äîáàâëåíà ñâîÿ çàäåðæêà
		Òåïåðü, åñëè âàñ óáèë èãðîê è âêëþ÷åíî óâåäîìëåíèå î ñìåðòè, â óâåäîìëåíèè íàïèøåò êòî âàñ óáèë
		Ïðèáðàëñÿ â êîäå
	v1.6.1
		Ôèêñ VK Notifications
	v1.7
		Â VK Notifications äîáàâëåíà êíîïêà "Ãîëîä" è êîìàíäà !getplhun
		Äîáàâëåíà âîçìîæíîñòü âûêëþ÷èòü àâòîîáíîâëåíèå
		Èñïðàâëåíû ëîæíûå óâåäîìëåíèÿ íà ñîîáùåíèÿ îò àäìèíèñòðàòîðà
	v1.8 
		Îáíîâèë ñïîñîá àíòèàôê, âðîäå òåïåðü ó âñåõ ðàáîòàåò
		Ïîôèêñèë åñëè ïåðñ óìðåò
	v1.8-fix
		Ôèêñ êðàøà ïðè ðåêîííåêòå
	v1.9
		Íîâûé äèçàéí
		Äîáàâëåí ÀâòîÏèàð
		Äîáàâëåíà ïðîâåðêà íà /pm îò àäìèíîâ(äèàëîã + ÷àò, 2 âèäà)
		Ôèêñ AutoBanScreen - òåïåðü, ñêðèíèò ïðè ïîÿâëåíèè äèàëîãà î áàíå
	v1.9.1
		Ôèêñ õàâêè èç äîìà
	v1.9.1.1
		Ôèêñ ñîõðàíåíèÿ çàäåðæêè äëÿ àâòîîòêðûòèÿ
	v2.0.0
		Ïîôèêøåíû êðàøè(âðîäå âñå) ïðè ðåêîííåêòå, èñïîëüçîâàíèè áîòà VK
		Ñìåíåí äèçàéí íà áîëåå ïðèÿòíûé
		Â àâòîçàïîëíåíèå äîáàâëåíà êíîïêà "Äîáàâèòü àêêàóíò"
		Äîáàâëåíû êîìàíäû /afkrec(ðåêîí ñ ñåêóíäàìè), /afksrec(ñòîïàåò àâòîðåêîí è ðåêîí îáû÷íûé)
]]
changelog2 = [[	v2.0.1
		Ôèêñ àâòîîòêðûòèÿ
	v2.0.2
		Àâòîåäà - Äîáàâëåí âûáîð ïðîâåðêè êîãäà ìîæíî ïîõàâàòü(ïîëîñêà ãîëîäà ñ íàñòðîéêîé) 
		Ôèêñ êðàøåé èç-çà ïèàðà è äð.
		Äîáàâëåí Fastconnect
	v2.0.3
		Ôèêñû áàãîâ
	v2.0.4
		Îòêëþ÷åíèå àâòîîáíîâëåíèé
		Â VK Notifications äîáàâëåíà êíîïêà "SMS è Çâîíîê"
	v2.0.5
		Â VK Notifications äîáàâëåíà êíîïêà "ÊÄ ìåøêà/ðóëåòîê", à òàêæå "Êîä ñ ïî÷òû/ÂÊ"
		Äîáàâëåíû êîìàíäû !sendcode !sendvk äëÿ îòïðàâêè êîäîâ ïîäòâåðæäåíèé èç ÂÊ â èãðó.
	v2.0.6
		Äîáàâëåí Àâòîîòâåò÷èê, êîòîðûé ñàì âîçüìåò òðóáêó è ïîïðîñèò àáîíåíòà íàïèñàòü â ÂÊ.
		Äîáàâëåíà çàïèñü çâîíêîâ, òàêæå ìîæíî ðàçãîâàðèâàòü ïî òåëåôîíó èç ÂÊ.
		Â ÂÊ äîáàâëåíû êîìàíäû !p (ïðèíÿòü çâîíîê) è !h (ñáðîñèòü çâîíîê). Îáùàòüñÿ ìîæíî ÷åðåç !send [òåêñò].
	v2.0.7
		Åñëè â àâòîïèàðå èñïîëüçóåòå /ad, òî äëÿ ýòîãî äîáàâëåí Àâòîñêèï /ad (äëÿ îáû÷íûõ è ìàðêåòîëîãîâ).
		Ïîôèêñèë ôëóä â ÂÊ "The server didn't respond".
		Âîññòàíîâëåíèå íà ÁÕ.
	v2.0.8
		Äîáàâèë ïðîâåðêó ïðè èñïîëüçîâàíèè êîìàíäû !p, !h (ðàíüøå ñêðèïò îòïðàâëÿë ñîîáùåíèÿ äàæå íå âçàèìîäåéñòâóÿ)
		Òåïåðü ñêðèïò íå ðåñòàðòèò ïðè çàïðîñå êîäà ñ ïî÷òû/ÂÊ.
		Ïåðåïèñàí àâòîîòâåò÷èê, à òàêæå çàïèñü çâîíêîâ.
		Òåïåðü åñòü 2 âåðñèè ñêðèïòà:
			- Ñ óæå ïîäêëþ÷åííûì ïàáëèêîì (äëÿ òåõ êòî íå óìååò)
			- Áåç ïîäêëþ÷åííîãî ïàáëèêà, ïîäêëþ÷àòü ñàìîìó (äëÿ òåõ êòî õî÷åò áûòü êðóòûì)
		Äîáàâëåíà êîìàíäà !gauth äëÿ îòïðàâêè êîäà èç GAuthenticator
		Åñëè ïåðñîíàæ çàñïàíèòñÿ ïîñëå ëîãèíà, òî ïðèäåò óâåäîìëåíèå
	v2.0.9
		Òåïåðü íà àâòîîòâåò÷èê ìîæíî ïèñàòü ñâîé òåêñò.
		Â ÂÊ äîáàâëåíà êíîïêà "Ïîñëåäíèå 10 ñòðîê ñ ÷àòà"
		Äîáàâëåíà ôóíêöèÿ ïåðåîòïðàâêè ñîîáùåíèÿ â /vr èç-çà ÊÄ.


]]
scriptinfo = [[
	AFK Tools - ñêðèïò, äëÿ ïðîêà÷êè àêêàóíòà íà Arizona Role Play
	Â äàííîì ðàçäåëå âû ìîæåòå áîëåå ïîäðîáíî óçíàòü î ñêðèïòå

	Êîìàíäû ñêðèïòà:
		/afktools - îòêðûòü ìåíþ ñêðèïòà
		/afkreload - ïåðåçàãðóçèòü ñêðèïò 
		/afkunload - âûãðóçèòü ñêðèïò
		/afkrec - ðåêîííåêò ñ ñåêóíäàìè
		/afksrec - îñòàíîâèòü ðåêîííåêò(ñòàíäàðòíûé èëè àâòîðåêîí) 
]]


howsetVK = [[

Ãäå âçÿòü VK ID?
Ñàìûé ïðîñòîé ñïîñîá
1. Çàéäèòå â "Íàñòðîéêè" âàøåãî àêêàóíòà
2. Â ïîëå "Àäðåñ ñòðàíèöû" íàæìèòå "Èçìåíèòü"
3. Íàä êíîïêîé "Ñîõðàíèòü" áóäåò òåêñò - "Íîìåð ñòðàíèöû - (öèôðû)". Ýòè öèôðû è åñòü âàø VK ID
4. Ïåðåïèøèòå ýòè öèôðû â ïîëå "VK ID" 

Ñîõðàíèòå
Íàïèøèòå ÷òî-òî â ãðóïïó @arizona.notify
Òåïåðü, âû ìîæåòå ïðîâåðèòü óâåäîìëåíèÿ íàæàâ êíîïêó "Ïðîâåðèòü" 
]]
local _message = {}

function AFKMessage(text,del)
	del = del or 5
	_message[#_message+1] = {active = false, time = 0, showtime = del, text = text}
end
--ale op, load
local fastconnect = imgui.ImBool(mainIni.config.fastconnect)
local antiafk = imgui.ImBool(mainIni.config.antiafk)
local banscreen = imgui.ImBool(mainIni.config.banscreen)
local autoad = imgui.ImBool(mainIni.config.autoad)
local autoo = imgui.ImBool(mainIni.config.autoo)
local returnmessageforvr = imgui.ImBool(mainIni.config.returnmessageforvr)
local atext = imgui.ImBuffer(''..mainIni.config.atext,300)
local autoadbiz = imgui.ImBool(mainIni.config.autoadbiz)
local autologin = {
	state = imgui.ImBool(mainIni.autologin.state)
}
local arec = {
	state = imgui.ImBool(mainIni.arec.state),
	statebanned = imgui.ImBool(mainIni.arec.statebanned),
	wait = imgui.ImInt(mainIni.arec.wait)
}
local roulette = {
	standart = imgui.ImBool(mainIni.roulette.standart),
	donate = imgui.ImBool(mainIni.roulette.donate),
	platina = imgui.ImBool(mainIni.roulette.platina),
	wait = imgui.ImInt(mainIni.roulette.wait)
}
local vknotf = {
	token = imgui.ImBuffer(''..mainIni.vknotf.token,300),
	user_id = imgui.ImBuffer(''..mainIni.vknotf.user_id,300),
	group_id = imgui.ImBuffer(''..mainIni.vknotf.group_id,300),
	state = imgui.ImBool(mainIni.vknotf.state),
	isinitgame = imgui.ImBool(mainIni.vknotf.isinitgame),
	ishungry = imgui.ImBool(mainIni.vknotf.ishungry),
	issmscall = imgui.ImBool(mainIni.vknotf.issmscall),
	record = imgui.ImBool(mainIni.vknotf.record),
	ismeat = imgui.ImBool(mainIni.vknotf.ismeat),
	iscloseconnect = imgui.ImBool(mainIni.vknotf.iscloseconnect),
	isadm = imgui.ImBool(mainIni.vknotf.isadm),
	iscode = imgui.ImBool(mainIni.vknotf.iscode),
	isdemorgan = imgui.ImBool(mainIni.vknotf.isdemorgan),
	islowhp = imgui.ImBool(mainIni.vknotf.islowhp),
	issendlowhp = false,
	ispayday = imgui.ImBool(mainIni.vknotf.ispayday),
	iscrashscript = imgui.ImBool(mainIni.vknotf.iscrashscript),
	ispaydaystate = false,
	ispaydayvalue = 0,
	ispaydaytext = '',
	issellitem = imgui.ImBool(mainIni.vknotf.issellitem)
}
local piar = {
	piar1 = imgui.ImBuffer(''..mainIni.piar.piar1, 500),
	piar2 = imgui.ImBuffer(''..mainIni.piar.piar2, 500),
	piar3 = imgui.ImBuffer(''..mainIni.piar.piar3, 500),
	piarwait = imgui.ImInt(mainIni.piar.piarwait),
	piarwait2 = imgui.ImInt(mainIni.piar.piarwait2),
	piarwait3 = imgui.ImInt(mainIni.piar.piarwait3),
	auto_piar = imgui.ImBool(mainIni.piar.auto_piar),
	auto_piar_kd = imgui.ImInt(mainIni.piar.auto_piar_kd),
	last_time = mainIni.piar.last_time
}
local eat = {
	checkmethod = imgui.ImInt(mainIni.eat.checkmethod),
	eat2met = imgui.ImInt(mainIni.eat.eat2met),
	cycwait = imgui.ImInt(mainIni.eat.cycwait),
	setmetod = imgui.ImInt(mainIni.eat.setmetod),
	eatmetod = imgui.ImInt(mainIni.eat.eatmetod),
	healstate = imgui.ImBool(mainIni.eat.healstate),
	hplvl = imgui.ImInt(mainIni.eat.hplvl),
	hpmetod = imgui.ImInt(mainIni.eat.hpmetod),
	arztextdrawid = imgui.ImInt(mainIni.eat.arztextdrawid),
	arztextdrawidheal = imgui.ImInt(mainIni.eat.arztextdrawidheal),
	drugsquen = imgui.ImInt(mainIni.eat.drugsquen)
}
-- one launch
local afksets = imgui.ImBool(false)
local showpass = false
local showtoken = false
local aopen = false
local opentimerid = {
	standart = -1,
	donate = -1,
	platina = -1
}
local checkopen = {
	standart = false,
	donate = false
}
local onPlayerHungry = lua_thread.create_suspended(function()
	if eat.eatmetod.v == 1 then
		AFKMessage('Ðåàãèðóþ, êóøàþ')
		gotoeatinhouse = true
		sampSendChat('/home')
	elseif eat.eatmetod.v == 3 then
		AFKMessage('Ðåàãèðóþ, êóøàþ')
		setVirtualKeyDown(0x12, false)
		while not sampIsDialogActive() do wait(0) end
		sampSendDialogResponse(1825, 1, 6, false)
		while not sampIsDialogActive() do wait(0) end
		setVirtualKeyDown(0x12, false)
		while not sampIsDialogActive() do wait(0) end
		sampSendDialogResponse(1825, 1, 6, false)
		while not sampIsDialogActive() do wait(0) end
		wait(500)
		sampCloseCurrentDialogWithButton(0)
	elseif eat.eatmetod.v == 2 then 
		AFKMessage('Ðåàãèðóþ, êóøàþ')
		if eat.setmetod.v == 0 then
			for i = 1,30 do
				sampSendChat('/cheeps')
				wait(4000)
			end    
		elseif eat.setmetod.v == 1 then
			for k = 1,10 do
				sampSendChat('/jfish')
				wait(3000)
			end    
		elseif eat.setmetod.v == 2 then
			sampSendChat('/jmeat')  
		elseif eat.setmetod.v == 3 then
			sampSendClickTextdraw(eat.arztextdrawid.v)
			sampSendClickTextdraw(eat.arztextdrawid.v)
		elseif eat.setmetod.v == 4 then
			sampSendChat('/meatbag') 
		end
	end
end)
local createscreen = lua_thread.create_suspended(function()
	wait(2000)
	takeScreen()
end)
local checkrulopen = lua_thread.create_suspended(function()
	while true do
		wait(0)
		if aopen then
			AFKMessage('Íà÷èíàåì äåëàòü ïðîâåðêó')
			checkopen.standart = true
			checkopen.donate = roulette.donate.v and true or false
			checkopen.platina = roulette.platina.v and true or false
			sampSendChat('/invent')
			wait(roulette.wait.v*1000)
			AFKMessage('Ïåðåçàïóñê')
		end
	end
end)

--autofill
local file_accs = path .. "\\accs.json"

local dialogChecker = {
	check = false,
	id = -1,
	title = ""
}

local editpass = {
	numedit = -1,
	input = imgui.ImBuffer('',100)
}

local addnew = {
	name = imgui.ImBuffer('',100),
	pass = imgui.ImBuffer('',100),
	dialogid = imgui.ImInt(0),
	serverip = imgui.ImBuffer('',100)
}

function addnew:save()
	if #addnew.name.v > 0 and #addnew.pass.v > 0 and #(tostring(addnew.dialogid.v)) > 0 and #addnew.serverip.v > 0 then
		saveacc(addnew.name.v,addnew.pass.v,addnew.dialogid.v,addnew.serverip.v)
		return true
	end
end

local temppass = {}
local savepass = {}

if doesFileExist(file_accs) then
	local f = io.open(file_accs, "r")
	if f then
		savepass = decodeJson(f:read("a*"))
		f:close()
	end
end


local checklist = {
	u8('You are hungry!'),
	u8('Ïîëîñêà ãîëîäà')
}
local metod = {
	u8('×èïñû'),
	u8('Ðûáà'),
	u8('Îëåíèíà'),
	u8('TextDraw'),
	u8('Ìåøîê')
}
local healmetod = {
	u8('Àïòå÷êà'),
	u8('Íàðêîòèêè'),
	u8('Àíäðåíàëèí'),
	u8('Ïèâî'),
	u8('TextDraw')
}
 
font2 = renderCreateFont('Arial', 8, 5)
local list = {}
function list:new()
	return {
		pos = {
			x = select(1,getScreenResolution()) - 222,
			y = select(2,getScreenResolution()) - 60
		},
		size = {
			x = 200,
			y = 0
		}
	}
end
notfList = list:new()

function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x101 then
		if (wparam == 0x1B and afksets.v) and not isPauseMenuActive() then
			consumeWindowMessage(true, false)
			if msg == 0x101 then
				afksets.v = false
			end
		end
	end
end

menunum = 0 
menufill = 0 
localvalue = 0
local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- îáðàáîòêà effil ïîòîêà áåç áëîêèðîâîê
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end
function requestRunner() -- ñîçäàíèå effil ïîòîêà ñ ôóíêöèåé https çàïðîñà
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end
function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(threadHandle,runner, url, args, resolve, reject)
end
local vkerr, vkerrsend -- ñîîáùåíèå ñ òåêñòîì îøèáêè, nil åñëè âñå îê
function tblfromstr(str)
	local a = {}
	for b in str:gmatch('%S+') do
		a[#a+1] = b
	end
	return a
end
function longpollResolve(result)
	if result then
		if not result:sub(1,1) == '{' then
			vkerr = 'Îøèáêà!\nÏðè÷èíà: Íåò ñîåäèíåíèÿ ñ VK!'
			return
		end
		local t = decodeJson(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				key = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
		if vknotf.state.v and t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' and tonumber(v.object.from_id) == tonumber(vknotf.user_id.v) and v.object.text then
					if v.object.payload then
						local pl = decodeJson(v.object.payload)
						if pl.button then
							if pl.button == 'getstats' then
								getPlayerArzStats(sendvknotf)
							elseif pl.button == 'getinfo' then
								getPlayerInfo(sendvknotf)
							elseif pl.button == 'gethun' then
								getPlayerArzHun(sendvknotf)
							elseif pl.button == 'lastchat10' then
								lastchatmessage(10,sendvknotf)
							elseif pl.button == 'support' then
								sendvknotf('Êîìàíäû:\n!send - Îòïðàâèòü ñîîáùåíèå èç VK â Èãðó\n!getplstats - ïîëó÷èòü ñòàòèñòèêó ïåðñîíàæà\n!getplhun - ïîëó÷èòü ãîëîä ïåðñîíàæà\n!getplinfo - ïîëó÷èòü èíôîðìàöèþ î ïåðñîíàæå\n!sendcode - îòïðàâèòü êîä ñ ïî÷òû\n!sendvk - îòïðàâèòü êîä èç ÂÊ\n!gauth - îòïðàâèòü êîä èç GAuth\n!p/!h - ñáðîñèòü/ïðèíÿòü âûçîâ\nÏîääåðæêà: @sk33z')
							elseif pl.button == 'openchest' then
								openchestrulletVK(sendvknotf)
							elseif pl.button == 'keyW' then
								setKeyFromVK('go',sendvknotf)
							elseif pl.button == 'keyA' then
								setKeyFromVK('left',sendvknotf)
							elseif pl.button == 'keyS' then
								setKeyFromVK('back',sendvknotf)
							elseif pl.button == 'keyD' then
								setKeyFromVK('right',sendvknotf)
							end
						end
						return
					end
					local objsend = tblfromstr(v.object.text)
					if objsend[1] == '!getplstats' then
						getPlayerArzStats()
					elseif objsend[1] == '!getplinfo' then
						getPlayerInfo()
					elseif objsend[1] == '!getplhun' then
						getPlayerArzHun()
					elseif objsend[1] == '!p' then
						PickUpPhone()
					elseif objsend[1] == '!h' then
						PickDownPhone()
					elseif objsend[1] == '!send' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampProcessChatInput(args)
							sendvknotf('Ñîîáùåíèå "' .. args .. '" áûëî óñïåøíî îòïðàâëåíî â èãðó')
						else
							sendvknotf('Íåïðàâèëüíûé àðãóìåíò! Ïðèìåð: !send [ñòðîêà]')
						end
						elseif objsend[1] == '!sendcode' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampSendDialogResponse(8928, 1, false, (args))
							sendvknotf('Êîä "' .. args .. '" áûë óñïåøíî îòïðàâëåí â äèàëîã')
						else
							sendvknotf('Íåïðàâèëüíûé àðãóìåíò! Ïðèìåð: !sendcode [êîä]')
						end
						elseif objsend[1] == '!sendvk' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampSendDialogResponse(7782, 1, false, (args))
							sendvknotf('Êîä "' .. args .. '" áûë óñïåøíî îòïðàâëåí â äèàëîã')
						else
							sendvknotf('Íåïðàâèëüíûé àðãóìåíò! Ïðèìåð: !sendvk [êîä]')
						end
						elseif objsend[1] == '!gauth' then
						print('this')
						local args = table.concat(objsend, " ", 2, #objsend) 
						if #args > 0 then
							args = u8:decode(args)
							sampSendDialogResponse(8929, 1, false, (args))
							sendvknotf('Êîä "' .. args .. '" áûë óñïåøíî îòïðàâëåí â äèàëîã')
						else
							sendvknotf('Íåïðàâèëüíûé àðãóìåíò! Ïðèìåð: !gauth [êîä]')
						end
					elseif cmd == '!lastchat' then
						local lines = tonumber(args)
						if lines and lines < 52 and lines > 0 then
							lastchatmessage(text,sendvknotf)
						else
							sendvknotf('Íåâåðíîå çíà÷åíèå! Àðãóìåíò äîëæåí áûòü áîëüøå 0 è ìåíüøå 52')
						end
						return
					end
				end
			end
		end
	end
end
function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. vknotf.group_id.v .. '&access_token=' .. vknotf.token.v .. '&v=5.81', '', function (result)
		if result then
			if not result:sub(1,1) == '{' then
				vkerr = 'Îøèáêà!\nÏðè÷èíà: Íåò ñîåäèíåíèÿ ñ VK!'
				return
			end
			local t = decodeJson(result)
			if t then
				if t.error then
					vkerr = 'Îøèáêà!\nÊîä: ' .. t.error.error_code .. ' Ïðè÷èíà: ' .. t.error.error_msg
					return
				end
				server = t.response.server
				ts = t.response.ts
				key = t.response.key
				vkerr = nil
			end
		end
	end)
end
function sendvknotf(msg, host)
	host = host or sampGetCurrentServerName()
	local acc = sampGetPlayerNickname(select(2,sampGetPlayerIdByCharHandle(playerPed))) .. '['..select(2,sampGetPlayerIdByCharHandle(playerPed))..']'
	msg = msg:gsub('{......}', '')
	msg = '[AFK Tools | Notifications | '..acc..' | '..host..']\n'..msg
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if vknotf.state.v and #vknotf.user_id.v > 0 then
		async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. vknotf.user_id.v .. '&message=' .. msg .. '&access_token=' .. vknotf.token.v .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				return
			end
			if t.error then
				vkerrsend = 'Îøèáêà!\nÊîä: ' .. t.error.error_code .. ' Ïðè÷èíà: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end
function vkKeyboard() --ñîçäàåò êîíêðåòíóþ êëàâèàòóðó äëÿ áîòà VK, êàê ñäåëàòü äëÿ áîëåå îáùèõ ñëó÷àåâ ïîêà íå çàäóìûâàëñÿ
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	keyboard.buttons[2] = {}
	keyboard.buttons[3] = {}
	keyboard.buttons[4] = {}
	keyboard.buttons[5] = {}
	local row = keyboard.buttons[1]
	local row2 = keyboard.buttons[2]
	local row3 = keyboard.buttons[3]
	local row4 = keyboard.buttons[4]
	local row5 = keyboard.buttons[5]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "getinfo"}'
	row[1].action.label = 'Èíôîðìàöèÿ'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "getstats"}'
	row[2].action.label = 'Ñòàòèñòèêà'
	row[3] = {}
	row[3].action = {}
	row[3].color = 'positive'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "gethun"}'
	row[3].action.label = 'Ãîëîä'
	row2[2] = {}
	row2[2].action = {}
	row2[2].color = 'positive'
	row2[2].action.type = 'text'
	row2[2].action.payload = '{"button": "lastchat10"}'
	row2[2].action.label = 'Ïîñëåäíèå 10 ñòðîê ñ ÷àòà'
	row2[1] = {}
	row2[1].action = {}
	row2[1].color = 'positive'
	row2[1].action.type = 'text'
	row2[1].action.payload = '{"button": "openchest"}'
	row2[1].action.label = aopen and 'Âûêëþ÷èòü àâòîîòêðûòèå' or 'Âêëþ÷èòü àâòîîòêðûòèå'
	row3[1] = {}
	row3[1].action = {}
	row3[1].color = 'positive'
	row3[1].action.type = 'text'
	row3[1].action.payload = '{"button": "support"}'
	row3[1].action.label = 'Ïîääåðæêà'
	row4[1] = {}
	row4[1].action = {}
	row4[1].color = 'positive'
	row4[1].action.type = 'text'
	row4[1].action.payload = '{"button": "keyW"}'
	row4[1].action.label = 'W'
	row5[1] = {}
	row5[1].action = {}
	row5[1].color = 'positive'
	row5[1].action.type = 'text'
	row5[1].action.payload = '{"button": "keyA"}'
	row5[1].action.label = 'A'
	row5[2] = {}
	row5[2].action = {}
	row5[2].color = 'positive'
	row5[2].action.type = 'text'
	row5[2].action.payload = '{"button": "keyS"}'
	row5[2].action.label = 'S'
	row5[3] = {}
	row5[3].action = {}
	row5[3].color = 'positive'
	row5[3].action.type = 'text'
	row5[3].action.payload = '{"button": "keyD"}'
	row5[3].action.label = 'D'
	return encodeJson(keyboard)
end
function char_to_hex(str)
	return string.format("%%%02X", string.byte(str))
  end
  
function url_encode(str)
    local str = string.gsub(str, "\\", "\\")
    local str = string.gsub(str, "([^%w])", char_to_hex)
    return str
end
function getPlayerInfo()
	if isSampLoaded() and isSampAvailable() and sampGetGamestate() == 3 then
		local response = ''
		response = response .. 'HP: ' .. getCharHealth(PLAYER_PED) .. '\n'
		response = response .. 'Armor: ' .. getCharArmour(PLAYER_PED) .. '\n'
		response = response .. 'Money: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n'
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. 'Coords: X: ' .. math.floor(x) .. ' | Y: ' .. math.floor(y) .. ' | Z: ' .. math.floor(z)
		sendvknotf(response)
	else
		sendvknotf('Âû íå ïîäêëþ÷åíû ê ñåðâåðó!')
	end
end
sendstatsstate = false
function getPlayerArzStats()
	if sampIsLocalPlayerSpawned() then
		sendstatsstate = true
		sampSendChat('/stats')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if sendstatsstate ~= true then
				timesendrequest = 0
			end 
		end
		sendvknotf(sendstatsstate == true and 'Îøèáêà! Â òå÷åíèè 10 ñåêóíä ñêðèïò íå ïîëó÷èë èíôîðìàöèþ!' or tostring(sendstatsstate))
		sendstatsstate = false
	else
		sendvknotf('(error) Ïåðñîíàæ íå çàñïàâíåí')
	end
end
function lastchatmessage(intchat, tochat)
	if sampIsLocalPlayerSpawned() then
		print('use: lastchat')
		local allchat = '\n'
		for i = 100-intchat, 99 do
			local getstr = select(1,sampGetChatString(i))
			allchat = allchat .. getstr .. '\n'
		end
		sendvknotf(allchat)
	else
		sendvknotf('(error) Ïåðñîíàæ íå çàñïàâíåí')
	end
end
function getPlayerArzHun()
	if sampIsLocalPlayerSpawned() then
		gethunstate = true
		sampSendChat('/satiety')
		local timesendrequest = os.clock()
		while os.clock() - timesendrequest <= 10 do
			wait(0)
			if gethunstate ~= true then
				timesendrequest = 0
			end 
		end
		sendvknotf(gethunstate == true and 'Îøèáêà! Â òå÷åíèè 10 ñåêóíä ñêðèïò íå ïîëó÷èë èíôîðìàöèþ!' or tostring(gethunstate))
		gethunstate = false
	else
		sendvknotf('(error) Ïåðñîíàæ íå çàñïàâíåí')
	end
end
function PickUpPhone()
	if sampIsLocalPlayerSpawned() then
		setVirtualKeyDown(89, true)
		setVirtualKeyDown(89, false)
		sampSendClickTextdraw(2108)
	end
end
function PickDownPhone()
	if sampIsLocalPlayerSpawned() then
		setVirtualKeyDown(89, true)
		setVirtualKeyDown(89, false)
		sampSendClickTextdraw(2104)
	end
end
function setKeyFromVK(getkey)
	if isSampLoaded() and isSampAvailable() and sampIsLocalPlayerSpawned() then
		sendvknotf('Îòïðàâëåíî íàæàòèå íà êëàâèøó '..getkey)
		local timepress = os.time()
		if getkey == 'go' then
			print('key set go')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(1,-1024) end
			setGameKeyState(1,0)
		elseif getkey == 'back' then
			print('key set back')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(1,1024) end
			setGameKeyState(1,0)
		elseif getkey == 'left' then
			print('key set left')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(0,-1024) end
			setGameKeyState(0,0)
		elseif getkey == 'right' then
			print('key set right')
			while os.time() - timepress < 2 do wait(0) setGameKeyState(0,1024) end
			setGameKeyState(0,0)
		end
	else
		sendvknotf('Âàø ïåðñîíàæ íå çàñïàâíåí!')
	end
end
function openchestrulletVK()
	if isSampLoaded() and isSampAvailable() and sampIsLocalPlayerSpawned() then
		if roulette.standart.v or roulette.donate.v or roulette.platina.v then
			aopen = not aopen
			if aopen then 
				checkrulopen:run()
				afksets.v = false
			else 
				lua_thread.terminate(checkrulopen) 
			end
			sendvknotf('Àâòîîòêðûòèå '..(aopen and 'âêëþ÷åíî!' or 'âûêëþ÷åíî!'))
		else
			sendvknotf("Âêëþ÷èòå ñóíäóê ñ ðóëåòêàìè!")
		end
	else
		sendvknotf('Âàø ïåðñîíàæ íå çàñïàâíåí!')
	end
end
function openchestrullet()
	if sampIsLocalPlayerSpawned() then
		if roulette.standart.v or roulette.donate.v or roulette.platina.v then
			aopen = not aopen
			AFKMessage('Àâòîîòêðûòèå '..(aopen and 'âêëþ÷åíî!' or 'âûêëþ÷åíî!'))
			if aopen then 
				checkrulopen:run()
				afksets.v = false
			else 
				lua_thread.terminate(checkrulopen) 
			end
		else
			AFKMessage("Âêëþ÷èòå ñóíäóê ñ ðóëåòêàìè!")
		end
	else
		AFKMessage("Âàø ïåðñîíàæ íå çàñïàâíåí!")
	end
end
bizpiaron = false
idsshow = false
function vkget()
	longpollGetKey()
	local reject, args = function() end, ''
	while not key do 
		wait(1)
	end
	local runner = requestRunner()
	while true do
		while not key do wait(0) end
		url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --ìåíÿåì url êàæäûé íîâûé çàïðîñ ïîòîêa, òàê êàê server/key/ts ìîãóò èçìåíÿòüñÿ
		threadHandle(runner, url, args, longpollResolve, reject)
		wait(100)
	end
end
function bizpiar()
	while true do wait(0)
		if bizpiaron then
			sampSendChat(u8:decode(piar.piar1.v))
			wait(piar.piarwait.v * 1000)
		end
	end
end
function bizpiar2()
	while true do wait(0)
		if bizpiaron then
			if piar.piar2.v:len() > 0 then
				sampSendChat(u8:decode(piar.piar2.v))
				wait(piar.piarwait2.v * 1000)
			end
		end
	end
end
function bizpiar3()
	while true do wait(0)
		if bizpiaron then
			if piar.piar3.v:len() > 0 then
				sampSendChat(u8:decode(piar.piar3.v))
				wait(piar.piarwait3.v * 1000)
			end
		end
	end
end
bizpiarhandle = lua_thread.create_suspended(bizpiar) 
bizpiarhandle2 = lua_thread.create_suspended(bizpiar2) 
bizpiarhandle3 = lua_thread.create_suspended(bizpiar3) 
function activatePiar(bbiza)
	if bbiza then 
		bizpiarhandle:run()
		bizpiarhandle2:run()
		bizpiarhandle3:run()
	else 
		bizpiarhandle:terminate()
		bizpiarhandle2:terminate()
		bizpiarhandle3:terminate()
	end
end

function main()
    while not isSampAvailable() do
        wait(0)
	end
	if piar.auto_piar.v and (os.time() - piar.last_time) <= piar.auto_piar_kd.v then
		lua_thread.create(function()
			while not sampIsLocalPlayerSpawned() do wait(0) end
			bizpiaron = true
			activatePiar(bizpiaron)
			AFKMessage('[ÀâòîÏèàð] Ïèàð âêëþ÷åí ò.ê ïðîøëî ìåíüøå ÷åì '..piar.auto_piar_kd.v..' ñåêóíä ïîñëå ïîñëåäíåé âûãðóçêè')
		end)
	end
	local _a = [[Ñêðèïò óñïåøíî çàïóùåí!
Âåðñèÿ: %s
Îòêðûòü ìåíþ: /afktools
Àâòîð: @sk33z]]
	AFKMessage(_a:format(thisScript().version))
	sampRegisterChatCommand('eattest',function() gotoeatinhouse = true; sampSendChat('/home') end)
	sampRegisterChatCommand('afktools',function() afksets.v = not afksets.v end)
	sampRegisterChatCommand('afkreload',function() thisScript():reload() end)
	sampRegisterChatCommand('afkunload',function() thisScript():unload() end)
	sampRegisterChatCommand('afksrec', function() 
		if handle_aurc then
			handle_aurc:terminate()
			handle_aurc = nil
			AFKMessage('Àâòîðåêîííåêò îñòàíîâëåí!')
		else
			AFKMessage('Âû ñåé÷àñ íå îæèäàåòå àâòîðåêîííåêòà!')
		end
		if handle_rc then
			handle_rc:terminate()
			handle_rc = nil
			AFKMessage('Ðåêîííåêò îñòàíîâëåí!')
		else
			AFKMessage('Âû ñåé÷àñ íå îæèäàåòå ðåêîííåêòà!')
		end
	end)
	sampRegisterChatCommand('afkrec',function(a)
		a = a and (tonumber(a) and tonumber(a) or 1) or 1
		reconstandart(a)
	end)
	if fastconnect.v then
		sampFastConnect(fastconnect.v)
	end
	workpaus(antiafk.v)
	lua_thread.create(vkget)
    while true do 
		wait(0)
        imgui.Process = afksets.v or #_message>0
		imgui.ShowCursor = afksets.v
		if idsshow then
            local alltextdraws = sampGetAllTextDraws()
            for _, v in pairs(alltextdraws) do
                local fX,fY = sampTextdrawGetPos(v)
                local fX,fY = convertGameScreenCoordsToWindowScreenCoords(fX,fY)	
                renderFontDrawText(font2,tostring(v),tonumber(fX),tonumber(fY),0xD7FFFFFF)
            end
		end
    end
end
function convertHexToImVec4(hex,alp)
	alp = alp or 255 
	local r,g,b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
	return imgui.ImVec4(r/255,g/255,b/255,alp/255)
end
function convertImVec4ToU32(imvec)
	return imgui.ImColor(imvec):GetU32()
end
--ðåíäåð óâåäîâ
function onRenderNotification()
	local count = 0
	for k, v in ipairs(_message) do
		local push = false
		if v.active and v.time < os.clock() then
			v.active = false
			table.remove(_message, k)
		end
		if count < 10 then
			if not v.active then
				if v.showtime > 0 then
					v.active = true
					v.time = os.clock() + v.showtime
					v.showtime = 0
				end
			end
			if v.active then
				count = count + 1
				if v.time + 3.000 >= os.clock() then
					imgui.PushStyleVar(imgui.StyleVar.Alpha, (v.time - os.clock()) / 0.3)
					push = true
				end
				local nText = u8(tostring(v.text))
				notfList.size = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize, 200.0, 196.0, nText)
				notfList.pos = imgui.ImVec2(notfList.pos.x, (notfList.pos.y - (count == 1 and notfList.size.y or (notfList.size.y + 40))))
				imgui.SetNextWindowPos(notfList.pos, _, imgui.ImVec2(0.0, 0.0))
				imgui.SetNextWindowSize(imgui.ImVec2(200, notfList.size.y + imgui.GetStyle().ItemSpacing.y + imgui.GetStyle().WindowPadding.y+25))
				imgui.Begin(u8'##msg' .. k, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
				imgui.CenterText('AFK Tools')
				imgui.Separator()
				imgui.TextWrapped(nText)
				imgui.End()
				if push then
					imgui.PopStyleVar()
				end
			end
		end
	end
	notfList = list:new()
end
--imgui: ýëåìåíòû àêêîâ
function autofillelementsaccs()
	if imgui.Button(u8('Âðåìåííûå äàííûå')) then menufill = 1 end
	imgui.SameLine()
	if imgui.Button(u8('Äîáàâèòü àêêàóíò')) then
		imgui.OpenPopup('##addacc')
	end
	if imgui.BeginPopupModal('##addacc',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
		imgui.CenterText(u8('Äîáàâèòü íîâûé àêêàóíò'))
		imgui.Separator()
		imgui.CenterText(u8('Íèê'))
		imgui.Separator()
		imgui.InputText('##nameadd',addnew.name)
		imgui.Separator()
		imgui.CenterText(u8('Ïàðîëü'))
		imgui.Separator()
		imgui.InputText('##addpas',addnew.pass)
		imgui.Separator()
		imgui.CenterText(u8('ID Äèàëîãà'))
		imgui.SameLine()
		imgui.TextQuestion(u8('ID Äèàëîãà â êîòîðûé íàäî ââåñòè ïàðîëü\nÍåñêîëüêî ID äëÿ Arizona RP\n	2 - Äèàëîã ââîäà ïàðîëÿ\n	991 - Äèàëîã PIN-Êîäà áàíêà'))
		imgui.Separator()
		imgui.InputInt('##dialogudadd',addnew.dialogid)
		imgui.Separator()
		imgui.CenterText(u8('IP ñåðâåðà'))
		imgui.SameLine()
		imgui.TextQuestion(u8('IP Ñåðâåðà, íà êîòîðîì áóäåò ââåäåí ïàðîëü\nÏðèìåð: 185.169.134.171:7777'))
		imgui.Separator()
		imgui.InputText('##ipport',addnew.serverip)
		imgui.Separator()
		if imgui.Button(u8("Äîáàâèòü"), imgui.ImVec2(-1, 20)) then
			if addnew:save() then
				imgui.CloseCurrentPopup()
			end
		end
		if imgui.Button(u8("Çàêðûòü"), imgui.ImVec2(-1, 20)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
	imgui.SameLine()
	imgui.Checkbox(u8('Âêëþ÷èòü'),autologin.state); imgui.SameLine(); imgui.TextQuestion(u8('Âêëþ÷àåò àâòîçàïîëíåíèå â äèàëîãè'))
	imgui.SameLine()
	imgui.CenterText(u8'Àâòîçàïîëíåíèå'); imgui.SameLine()
	imgui.SameLine(838)
	if imgui.Button(u8('Îáíîâèòü')) then
		local f = io.open(file_accs, "r")
		if f then
			savepass = decodeJson(f:read("a*"))
			f:close()
		end
		AFKMessage('Ïîäãðóæåííû íîâûå äàííûå')
	end
	imgui.Columns(3, _, true)
	imgui.Separator()
	imgui.SetColumnWidth(-1, 150); imgui.Text(u8"   Íèêíåéì"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 150); imgui.Text(u8"Ñåðâåð"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 450); imgui.Text(u8"Ïàðîëè"); imgui.NextColumn()
	for k, v in pairs(savepass) do
		imgui.Separator()
		if imgui.Selectable(u8('   '..v[1]..'##'..k), false, imgui.SelectableFlags.SpanAllColumns) then imgui.OpenPopup('##acc'..k) end
		if imgui.BeginPopupModal('##acc'..k,true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
			btnWidth2 = (imgui.GetWindowWidth() - 22)/2
			imgui.CreatePaddingY(8)
			imgui.CenterText(u8('Àêêàóíò '..v[1]))
			imgui.Separator()
			for f,t in pairs(v[3]) do
				imgui.Text(u8('Äèàëîã[ID]: '..v[3][f].id..' Ââåä¸ííûå äàííûå: '..v[3][f].text))
				if editpass.numedit == f then
					imgui.PushItemWidth(-1)
					imgui.InputText(u8'##pass'..f,editpass.input)
					imgui.PopItemWidth()
					if imgui.Button(u8("Ïîäòâåðäèòü##"..f), imgui.ImVec2(-1, 20)) then
						v[3][f].text = editpass.input.v
						editpass.input.v = ''
						editpass.numedit = -1
						saveaccounts()
					end
				elseif editpass.numedit == -1 then
					if imgui.Button(u8("Ñìåíèòü ïàðîëü##2"..f), imgui.ImVec2(-1, 20)) then
						editpass.input.v = v[3][f].text
						editpass.numedit = f
					end
				end
				if imgui.Button(u8("Ñêîïèðîâàòü##"..f), imgui.ImVec2(btnWidth2, 0)) then
					setClipboardText(v[3][f].text)
					imgui.CloseCurrentPopup()
				end
				imgui.SameLine()
				if imgui.Button(u8("Óäàëèòü##"..f), imgui.ImVec2(btnWidth2, 0)) then
					v[3][f] = nil
					if #v[3] == 0 then
						savepass[k] = nil
					end
					saveaccounts()
				end
				imgui.Separator()
			end
			if imgui.Button(u8("Ïîäêëþ÷èòüñÿ"), imgui.ImVec2(-1, 20)) then
				local ip2, port2 = string.match(v[2], "(.+)%:(%d+)")
				reconname(v[1],ip2, tonumber(port2))
			end
			if imgui.Button(u8("Óäàëèòü âñå äàííûå"), imgui.ImVec2(-1, 20)) then
				savepass[k] = nil
				imgui.CloseCurrentPopup()
				saveaccounts()
			end
			if imgui.Button(u8("Çàêðûòü##sdosodosdosd"), imgui.ImVec2(-1, 20)) then
				imgui.CloseCurrentPopup()
			end
			imgui.CreatePaddingY(8)
			imgui.EndPopup()
		end
		imgui.NextColumn()
		imgui.Text(tostring(v[2]))
		imgui.NextColumn()
		imgui.Text(u8('Êîë-âî ïàðîëåé: '..#v[3]..'. Íàæìèòå ËÊÌ äëÿ óïðàâëåíèÿ ïàðîëÿìè'))
		imgui.NextColumn()
	end
	imgui.Columns(1)
	imgui.Separator()
end
--imgui: ýëåìåíòû ñåéâà
function autofillelementssave()
	if imgui.Button(u8'< Àêêàóíòû') then menufill = 0 end
	imgui.SameLine()
	imgui.CenterText(u8'Àâòîçàïîëíåíèå')
	imgui.SameLine(838) 
	if imgui.Button(u8('Î÷èñòêà')) then temppass = {}; AFKMessage('Áóôåð âðåìåííûõ ïàðîëåé î÷èùåí!') end
	imgui.Columns(5, _, true)
	imgui.Separator()--710
	imgui.SetColumnWidth(-1, 130); imgui.Text(u8"Äèàëîã[ID]"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 150); imgui.Text(u8"Íèêíåéì"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 140); imgui.Text(u8"Ñåðâåð"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 170); imgui.Text(u8"Ââåäåííûå äàííûå"); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 140); imgui.Text(u8"Âðåìÿ"); imgui.NextColumn()
	for k, v in pairs(temppass) do
		if imgui.Selectable('   '..tostring(u8(string.gsub(v.title, "%{.*%}", "") .. "[" .. v.id .. "]")) .. "##" .. k, false, imgui.SelectableFlags.SpanAllColumns) then
			saveacc(k)
			saveaccounts()
			AFKMessage('Ïàðîëü '..v.text..' äëÿ àêêàóíòà '..v.nick..' íà ñåðâåðå '..v.ip..' ñîõðàí¸í!')
		end
		imgui.NextColumn()
		imgui.Text(tostring(v.nick))
		imgui.NextColumn()
		imgui.Text(tostring(v.ip))
		imgui.NextColumn()
		imgui.Text(tostring(u8(v.text)))
		imgui.NextColumn()
		imgui.Text(tostring(v.time))
		imgui.NextColumn()
	end
	imgui.Columns(1)
	imgui.Separator()
end
function imgui.OnDrawFrame()
	if afksets.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(920,470))
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2,sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
		-- imgui.PushStyleVar(imgui.StyleVar.WindowPadding,imgui.ImVec2(0,0))
		imgui.Begin('##afktools',afksets,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		if menunum > 0 then
			imgui.SetCursorPos(imgui.ImVec2(12,8))
			if imgui.Button('<',imgui.ImVec2(20,34)) then
				menunum = 0
			end
		end
		imgui.SetCursorPos(imgui.ImVec2(40,8))
		imgui.RenderLogo()
		imgui.SetCursorPos(imgui.ImVec2(516,8))
		imgui.BeginGroup()
		imgui.EndGroup()
		imgui.SetCursorPos(imgui.ImVec2(880,25))
		imgui.CloseButton(5.5)
		imgui.SetCursorPos(imgui.ImVec2(0,50))
		imgui.Separator()
		if menunum == 0 then
			local buttons = {
				{u8('Îñíîâíûå'),1,u8('Íàñòðîéêà îñíîâíûõ ôóíêöèé')},
				{u8('Àâòîçàïîëíåíèå'),2,u8('Àâòîââîä òåêñòà â äèàëîãè')},
				{u8('VK Notifications'),3,u8('Óâåäîìëåíèÿ â VK')},
				{u8('Àâòîåäà'),4,u8('Àâòîåäà êîãäà âû ãîëîäíû')},
				{u8('Èíôîðìàöèÿ'),5,u8('Ïîëåçíàÿ èíôîðìàöèÿ î ñêðèïòå')},
				{u8('Èñòîðèÿ îáíîâëåíèé'),6,u8('Ñïèñîê èçìåíåíèé êîòîðûå\n	 ïðîèçîøëè â ñêðèïòå')}
			}
			local function renderbutton(i)
				local name,set,desc,func = buttons[i][1],buttons[i][2],buttons[i][3],buttons[i][4]
				local getpos2 = imgui.GetCursorPos()
				imgui.SetCursorPos(getpos2)
				if imgui.Button('##'..name..'//'..desc,imgui.ImVec2(240,80)) then
					if func then
						pcall(func)
					else
						menunum = set
					end
				end 
				imgui.SetCursorPos(getpos2)
				imgui.BeginGroup()
				imgui.CreatePadding(240/2-imgui.CalcTextSize(name).x/2,15)
				imgui.Text(name)
				imgui.CreatePadding(240/2-imgui.CalcTextSize(desc).x/2,(80/2-imgui.CalcTextSize(desc).y/2)-25)
				imgui.Text(desc)
				imgui.EndGroup()
				imgui.SetCursorPos(imgui.ImVec2(getpos2.x,getpos2.y+90))
			end
			imgui.CreatePaddingY(20)
			local cc = 1
			local startY = 140 
			for i = 1, #buttons do
				local poss = {
					80,
					330,
					580
				}
				imgui.SetCursorPos(imgui.ImVec2(poss[cc],startY))
				renderbutton(i)
				if cc == #poss then
					cc = 0
					startY = startY + 90
				end
				cc = cc + 1
			end
			imgui.SetCursorPos(imgui.ImVec2(920/2 - 300/2,400))
			imgui.BeginGroup()
			if imgui.Button(u8('Ñîõðàíèòü íàñòðîéêè'),imgui.ImVec2(150,30)) then saveini() end
			imgui.SameLine()
			if imgui.Button(u8('Ïåðåçàãðóçèòü ñêðèïò'),imgui.ImVec2(150,30)) then thisScript():reload() end
			imgui.EndGroup()
			
		elseif menunum == 1 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Àâòîðåêîííåêò'))
			imgui.Separator()
			imgui.Checkbox(u8('Âêëþ÷èòü àâòîðåêîííåêò'), arec.state)
			if arec.state.v then
				imgui.Checkbox(u8('Âêëþ÷èòü àâòîðåêîííåêò ïðè You are banned from this server'), arec.statebanned)
			    imgui.SameLine()
			    imgui.PushItemWidth(80)
			    imgui.InputInt(u8('Çàäåðæêà(ñåê)###arec'),arec.wait)
			    imgui.PopItemWidth()
			end
			imgui.Separator()
			imgui.CenterText(u8('Àâòîîòêðûòèå ðóëåòîê'))
			imgui.Separator()
			imgui.BeginGroup()
			imgui.Text(u8('Âíèìàíèå! Àâòîîòêðûòèå ðóëåòîê íîðìàëüíî ðàáîòàåò òîëüêî íà àíãë. ÿçûêå èíâåíòàðÿ'))
			imgui.Checkbox(u8('Îòêðûâàòü ñòàíäàðò ñóíäóê'),roulette.standart); imgui.SameLine() imgui.TextQuestion(u8('Äëÿ îïòèìèçàöèè îòêðûâàíèÿ ñóíäóêîâ ñòàíäàðòíûé ñóíäóê äîëæåí áûòü â 1 ñëîòå íà 1 ñòðàíèöå')) 
			imgui.Checkbox(u8('Îòêðûâàòü äîíàò ñóíäóê'),roulette.donate); imgui.SameLine() imgui.TextQuestion(u8('[Îáÿçàòåëüíî!] Äîíàòíûé ñóíäóê äîëæåí áûòü â 2 ñëîòå íà 1 ñòðàíèöå'))
			imgui.Checkbox(u8('Îòêðûâàòü ïëàòèíà ñóíäóê'),roulette.platina); imgui.SameLine() imgui.TextQuestion(u8('[Îáÿçàòåëüíî!] Ïëàòèíîâûé ñóíäóê äîëæåí áûòü â 3 ñëîòå íà 1 ñòðàíèöå'))
			imgui.PushItemWidth(100)
			imgui.InputInt(u8('Çàäåðæêà (â ñåê.)##wait'),roulette.wait)
			imgui.SameLine()
			imgui.TextQuestion(u8('Çàäåðæêà ïåðåä ÷åêîì ñîñòîÿíèÿ ðóëåòîê(ìîæíî îòêðûòü èëè íåò)'))
			imgui.PopItemWidth()
			if imgui.Button(u8('Âêëþ÷èòü/âûêëþ÷èòü àâòîîòêðûòèå ñóíäóêîâ')) then 
			    openchestrullet()
			end
			imgui.EndGroup()
			imgui.Separator()
			imgui.CenterText(u8('Ôëóäåð'))
			imgui.Separator()
			imgui.BeginGroup()
			imgui.PushItemWidth(400)
			imgui.InputText(u8('1 Ñòðîêà'),piar.piar1)
			imgui.SameLine()
			imgui.TextQuestion(u8('Îáÿçàòåëüíàÿ ñòðîêà'))
			imgui.InputText(u8('2 Ñòðîêà'),piar.piar2)
			imgui.SameLine()
			imgui.TextQuestion(u8('Îñòàâüòå ñòðîêó ïóñòóþ åñëè íå õîòèòå å¸ èñïîëüçîâàòü'))
			imgui.InputText(u8('3 Ñòðîêà'),piar.piar3)
			imgui.SameLine()
			imgui.TextQuestion(u8('Îñòàâüòå ñòðîêó ïóñòóþ åñëè íå õîòèòå å¸ èñïîëüçîâàòü'))
			imgui.PopItemWidth()
			imgui.EndGroup()
		
			imgui.SameLine()
		
			imgui.BeginGroup()
			imgui.PushItemWidth(80)
			imgui.InputInt(u8('Çàäåðæêà(ñåê.)##piar1'),piar.piarwait); 
			imgui.InputInt(u8('Çàäåðæêà(ñåê.)##piar2'),piar.piarwait2); 
			imgui.InputInt(u8('Çàäåðæêà(ñåê.)##piar3'),piar.piarwait3); 
			imgui.PopItemWidth()
			imgui.EndGroup()
			if imgui.Button(u8('Àêòèâèðîâàòü ôëóäåð')) then 
			    bizpiaron = not bizpiaron
			    activatePiar(bizpiaron)
			    AFKMessage(bizpiaron and 'Ïèàð âêëþ÷¸í!' or 'Ïèàð âûêëþ÷åí!',5)
			end
			imgui.SameLine()
			imgui.Checkbox(u8('ÀâòîÏèàð'),piar.auto_piar) 
			imgui.SameLine()
			imgui.TextQuestion(u8('Åñëè ïîñëå ïîñëåäíåãî âûãðóæåíèÿ ñêðèïòà ïðîéäåò ìåíüøå óêàçàííîãî(â íàñòðîéêàõ) âðåìåíè, âêëþ÷èòüñÿ àâòîïèàð'))
			if piar.auto_piar.v then
			    imgui.SameLine()
			    imgui.PushItemWidth(120)
			    if imgui.InputInt(u8('Ìàêñèìàëüíîå âðåìÿ äëÿ âêëþ÷åíèÿ ïèàðà(â ñåê.)##autpiar'),piar.auto_piar_kd) then
			        if piar.auto_piar_kd.v < 0 then piar.auto_piar_kd = 0 end
			    end
			    imgui.PopItemWidth()
			end
			imgui.CenterText(u8('Îñòàëüíûå íàñòðîéêè'))
			imgui.Separator()
			imgui.BeginGroup()
			if imgui.Checkbox(u8('Fastconnect'),fastconnect) then
				sampFastConnect(fastconnect.v)
			end
			imgui.SameLine()
			imgui.TextQuestion(u8('Áûñòðûé âõîä íà ñåðâåð'))
			if imgui.Checkbox(u8('AntiAFK'),antiafk) then workpaus(antiafk.v) end
			imgui.SameLine()
			imgui.TextQuestion(u8('Âû íå áóäåòå ñòîÿòü â AFK åñëè ñâåðíåòå èãðó\nÂíèìàíèå! Åñëè AntiAFK âêëþ÷åí è âû ñîõðàíèëè íàñòðîéêè òî ïðè ñëåäóåùåì çàõîäå îí àâòîìàòè÷åñêè âêëþ÷èòñÿ! Ó÷òèòå ýòî!'))
			imgui.Checkbox(u8('AutoScreenBan'),banscreen)
			imgui.SameLine()
			imgui.TextQuestion(u8('Åñëè âàñ çàáàíèò àäìèí òî ñêðèí ñäåëàåòñÿ àâòîìàòè÷åñêè'))
			imgui.Checkbox(u8('Ñêèï äèàëîãà /ad'),autoad)
			imgui.SameLine()
			imgui.TextQuestion(u8('Ïðè èñïîëüçîâàíèè /ad [òåêñò], áóäåò çàïðàøèâàòüñÿ âûáîð òèïà îáüÿâëåíèÿ'))
			imgui.Checkbox(u8('Ñêèï äèàëîãà /ad äëÿ ìàðêåòîëîãîâ'),autoadbiz)
			imgui.SameLine()
			imgui.TextQuestion(u8('Ïðè èñïîëüçîâàíèè /ad [òåêñò], áóäåò âûáèðàòüñÿ òèï äëÿ ìàðêåòîëîãîâ'))
			imgui.Checkbox(u8('Àâòîîòâåò÷èê'),autoo)
			imgui.SameLine()
			imgui.TextQuestion(u8('Àâòîìàòè÷åñêè âîçüìåò òðóáêó, è ïîïðîñèò âõîäÿùåãî íàïèñàòü â ÂÊ.\nÏåðåä èñïîëüçîâàíèåì íàïèøèòå ñâîé èä âê â VK Notifications'))
			imgui.InputText(u8('Òåêñò àâòîîòâåò÷èêà'),atext)
			imgui.SameLine()
			imgui.TextQuestion(u8('Ââåäèòå òåêñò'))
			imgui.Checkbox(u8('Ïåðåîòïðàâèòü ñîîáùåíèå â /vr'),returnmessageforvr)
			imgui.SameLine()
			imgui.TextQuestion(u8('Åñëè âû èëè ñêðèïò îòïðàâèò ñåðâåðó êàêîå-òî ñîîáùåíèå â /vr è â ÷àòå áóäåò íàéäåíî ñîîáùåíèå "Ïîñëå ïîñëåäíåãî ñîîáùåíèÿ â ýòîì ÷àòå íóæíî ïîäîæäàòü 3 ñåêóíäû" îò ñåðâåðà(íå îò èãðîêà) òî ñêðèïò ïåðåîòïðàâèò òî ñîîáùåíèå ÷òî âû/ñêðèïò îòïðàâèë'))
			imgui.EndGroup()
			imgui.EndChild()
		elseif menunum == 2 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			if menufill == 0 then
				autofillelementsaccs()
			elseif menufill == 1 then
				autofillelementssave()
			end
			imgui.EndChild()
		elseif menunum == 3 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText('VK Notification')
			imgui.Separator()
			if imgui.Checkbox(u8('Âêëþ÷èòü óâåäîìëåíèÿ'), vknotf.state) then
				if vknotf.state.v then
					longpollGetKey()
				end
			end
			if vknotf.state.v then
				imgui.BeginGroup()
				if vkerr then
					imgui.Text(u8'Ñîñòîÿíèå ïðè¸ìà: ' .. u8(vkerr))
					imgui.Text(u8'Äëÿ ïåðåïîäêëþ÷åíèÿ ê ñåðâåðàì íàæìèòå êíîïêó "Ïåðåïîäêëþ÷èòüñÿ ê ñåðâåðàì"')
				else
					imgui.Text(u8'Ñîñòîÿíèå ïðè¸ìà: Àêòèâíî!')
				end
				if vkerrsend then
					imgui.Text(u8'Ñîñòîÿíèå îòïðàâêè: ' .. u8(vkerrsend))
				else
					imgui.Text(u8'Ñîñòîÿíèå îòïðàâêè: Àêòèâíî!')
				end
				imgui.InputText(u8('VK ID'), vknotf.user_id)
				imgui.SameLine()
				imgui.TextQuestion(u8('Â öèôðàõ!'))
				imgui.SetNextWindowSize(imgui.ImVec2(900,530))
				if imgui.BeginPopupModal('##howsetVK',true,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
					imgui.Text(u8(howsetVK))
					imgui.SetCursorPosY(490)
					local wid = imgui.GetWindowWidth()
					imgui.SetCursorPosX(wid / 2 - 30)
					if imgui.Button(u8'Çàêðûòü', imgui.ImVec2(60,20)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
				if imgui.Button(u8('Êàê íàñòðîèòü')) then imgui.OpenPopup('##howsetVK') end
				imgui.SameLine()
				if imgui.Button(u8('Ïðîâåðèòü óâåäîìëåíèÿ')) then sendvknotf('Òåñòîâîå ñîîáùåíèå ëîë êåê ìèëîòà') end
				imgui.SameLine()
				if imgui.Button(u8('Ïåðåïîäêëþ÷èòüñÿ ê ñåðâåðàì')) then longpollGetKey() end
				imgui.EndGroup()
				imgui.Separator()
				imgui.CenterText(u8('Ñîáûòèÿ, ïðè êîòîðûõ îòïðàâèòüñÿ óâåäîìëåíèå'))
				imgui.Separator()
				imgui.BeginGroup()
				imgui.Checkbox(u8('Ïîäêëþ÷åíèå'),vknotf.isinitgame); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ ïîäêëþ÷èòñÿ ê ñåðâåðó'))
				imgui.Checkbox(u8('Àäìèíèñòðàöèÿ'),vknotf.isadm); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè â ñòðîêå áóäåò ñëîâî "Àäìèíèñòðàòîð" + âàø íèê + êðàñíàÿ ñòðîêà(èñêë.: îêíî /pm, ÷àò /pm, ban òîæå áóäóò ó÷èòûâàòüñÿ)'))
				imgui.Checkbox(u8('Ãîëîä'),vknotf.ishungry); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ ïðîãîëîäàåòñÿ'))
				imgui.Checkbox(u8('Êèê'),vknotf.iscloseconnect); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ îòêëþ÷èòñÿ îò ñåðâåðà'))
				imgui.Checkbox(u8('Äåìîðãàí'),vknotf.isdemorgan); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ âûéäåò èç äåìîðãàíà'))
				imgui.Checkbox(u8('SMS è Çâîíîê'),vknotf.issmscall); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæó ïðèäåò ñìñ èëè ïîçâîíÿò'))
				imgui.Checkbox(u8('Çàïèñü çâîíêîâ'),vknotf.record); imgui.SameLine(); imgui.TextQuestion(u8('Çàïèñü çâîíêà, îòïðàâëÿåòñÿ â ÂÊ. Ðàáîòàåò ñ àâòîîòâåò÷èêîì'))
				imgui.EndGroup()
				imgui.SameLine(350)
				imgui.BeginGroup()
				imgui.Checkbox(u8('PayDay'),vknotf.ispayday); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ ïîëó÷èò PayDay'))
				imgui.Checkbox(u8('Ñìåðòü'),vknotf.islowhp); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ óìðåò(åñëè âàñ êòî-òî óáúåò, íàïèøåò åãî íèê)'))
				imgui.Checkbox(u8('Êðàø ñêðèïòà'),vknotf.iscrashscript); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ñêðèïò âûãðóçèòñÿ/êðàøíåòñÿ(äàæå åñëè ïåðåçàãðóçèòå ÷åðåç CTRL + R)'))
				imgui.Checkbox(u8('Ïðîäàæè'),vknotf.issellitem); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ïåðñîíàæ ïðîäàñò ÷òî-òî íà ÖÐ èëè ÀÁ'))
				imgui.Checkbox(u8('ÊÄ ìåøêà/ðóëåòîê'),vknotf.ismeat); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè ÊÄ íà ìåøîê/ñóíäóê íå ïðîøëî, èëè åñëè âûïàäåò ðóëåòêà òî ïðèäåò óâåäîìëåíèå'))
				imgui.Checkbox(u8('Êîä ñ ïî÷òû/ÂÊ'),vknotf.iscode); imgui.SameLine(); imgui.TextQuestion(u8('Åñëè áóäåò òðåáîâàòüñÿ êîä ñ ïî÷òû/ÂÊ, òî ïðèäåò óâåäîìëåíèå'))
				imgui.EndGroup()
			end
			imgui.EndChild()
		elseif menunum == 4 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Àâòîåäà'))
			imgui.Separator()
			imgui.BeginGroup()
        	imgui.RadioButton(u8'Îôôíóòü',eat.eatmetod,0)
			if eat.eatmetod.v > 0 then
				imgui.SameLine()
				imgui.PushItemWidth(140)
				imgui.Combo(u8('Ñïîñîá ïðîâåðêè ãîëîäà'), eat.checkmethod, checklist, -1)
				if eat.checkmethod.v == 1 then
					imgui.PushItemWidth(80)
					imgui.SameLine()
					imgui.InputInt(u8('Ïðè ñêîëüêè ïðîöåíòàõ ãîëîäà íàäî êóøàòü'),eat.eat2met,0)
				end
				imgui.PopItemWidth()
			end
			imgui.RadioButton(u8'Êóøàòü Äîìà',eat.eatmetod,1)
        	imgui.SameLine()
        	imgui.TextQuestion(u8'Âàø ïåðñîíàæ áóäåò êóøàòü äîìà èç õîëîäèëüíèêà')
        	imgui.BeginGroup()
        	imgui.RadioButton(u8'Êóøàòü âíå Äîìà',eat.eatmetod,2)
        	imgui.SameLine()
        	imgui.TextQuestion(u8'Âàø ïåðñîíàæ áóäåò êóøàòü âíå äîìà ñïîñîáîì èç ñïèñêà')
        	if eat.eatmetod.v == 2 then
        	    imgui.Text(u8'Âûáîð ìåòîäà åäû:')
        	    imgui.PushItemWidth(100)
        	    imgui.Combo('##123123131231232', eat.setmetod, metod, -1)
        	    if eat.setmetod.v == 3 then
        	        imgui.Text(u8("ID TextDraw'a Åäû"))
        	        imgui.InputInt(u8"##eat", eat.arztextdrawid,0)      
        	    end    
        	    imgui.PopItemWidth()
        	end
        	imgui.EndGroup()
        	imgui.RadioButton(u8'Êóøàòü â Ôàì ÊÂ',eat.eatmetod,3)
        	imgui.SameLine()
        	imgui.TextQuestion(u8'Âàø ïåðñîíàæ áóäåò êóøàòü èç õîëîäèëüíèêà â ñåìåéíîé êâàðòèðå. Äëÿ èñïîëüçîâàíèÿ âñòàíüòå íà ìåñòî, ãäå ïðè íàæàòèè ALT ïîÿâèòñÿ äèàëîã ñ âûáîðîì åäû')
        	imgui.EndGroup()
        	imgui.BeginGroup()
        	imgui.Checkbox(u8'ÀâòîÕèë', eat.healstate)
        	-- imgui.SameLine()
        	if eat.healstate.v then
        	    imgui.PushItemWidth(40)
        	    imgui.InputInt(u8'Óðîâåíü HP äëÿ Õèëà', eat.hplvl,0)
        	    imgui.PopItemWidth()
        	    imgui.Text(u8 'Âûáîð ìåòîäà õèëà:')
        	    imgui.PushItemWidth(100)
				imgui.Combo('##ban',eat.hpmetod,healmetod,-1)
				if eat.hpmetod.v == 1 then
        	        imgui.PushItemWidth(30)
        	        imgui.InputInt(u8"Êîë-âî íàðêî",eat.drugsquen,0)
        	        imgui.PopItemWidth()
        	    end
        	    if eat.hpmetod.v == 4 then
        	        imgui.Text(u8("ID TextDraw'a Õèëà"))
        	        imgui.InputInt(u8"##heal",eat.arztextdrawidheal,0)
        	    end
        	    imgui.PopItemWidth()
        	end
        	imgui.EndGroup()
        	imgui.SameLine(130)
        	if imgui.Checkbox(u8('Âêëþ÷èòü îòîáðàæåíèå ID òåêñòäðàâîâ'), imgui.ImBool(idsshow)) then
        	    idsshow = not idsshow
        	end
			imgui.EndChild()
		elseif menunum == 5 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Èíôîðìàöèÿ'))
			imgui.Separator()
			imgui.Text(u8(scriptinfo))
			imgui.EndChild()
		elseif menunum == 6 then
			imgui.BeginChild('##ana',imgui.ImVec2(-1,-1),false)
			imgui.CenterText(u8('Èñòîðèÿ îáíîâëåíèé'))
			imgui.Separator()
			imgui.Text(u8(changelog))
			imgui.Text(u8(changelog2))
			imgui.EndChild()
		end
		imgui.End()
	end
	onRenderNotification()
end
function imgui.ButtonDisabled(...)

    local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
    imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])

        local result = imgui.Button(...)

    imgui.PopStyleColor()
    imgui.PopStyleColor()
    imgui.PopStyleColor()
    imgui.PopStyleColor()

    return result
end
function imgui.CloseButton(rad)
	local pos = imgui.GetCursorScreenPos()
	local poss = imgui.GetCursorPos()
	local a,b,c,d = pos.x - rad, pos.x + rad, pos.y - rad, pos.y + rad
	local e,f = poss.x - rad, poss.y - rad
	local list = imgui.GetWindowDrawList()
	list:AddLine(imgui.ImVec2(a,d),imgui.ImVec2(b,c),convertImVec4ToU32(convertHexToImVec4('FFFFFF')))
	list:AddLine(imgui.ImVec2(b,d),imgui.ImVec2(a,c),convertImVec4ToU32(convertHexToImVec4('FFFFFF')))
	imgui.SetCursorPos(imgui.ImVec2(e,f))
	if imgui.InvisibleButton('##closebutolo',imgui.ImVec2(rad*2,rad*2)) then
		afksets.v = false
	end
end
function imgui.RenderLogo()
	imgui.Image(logos,imgui.ImVec2(40,40))
end
function imgui.CenterText(text) 
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.TextQuestion(text)
  imgui.TextDisabled('(?)')
  imgui._atq(text)
end
function imgui._atq(text)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end
function imgui.CreatePaddingX(x)
	x = x or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosX(cc.x+x)
end
function imgui.CreatePaddingY(y)
	y = y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPosY(cc.y+y)
end
function imgui.CreatePadding(x,y)
	x,y = x or 8, y or 8
	local cc = imgui.GetCursorPos()
	imgui.SetCursorPos(imgui.ImVec2(cc.x+x,cc.y+y))
end


function onScriptTerminate(scr,qgame)
	if scr == thisScript() then
		mainIni.piar.last_time = os.time()
		local saved = inicfg.save(mainIni,'afktools.ini')
		if vknotf.iscrashscript.v then
			sendvknotf('Ñêðèïò óìåð :(')
		end	
	end
end
--ïîëó÷èòü âñå òåêñòäðàâû
function sampGetAllTextDraws()
	local tds = {}
	pTd = sampGetTextdrawPoolPtr() + 9216
	for i = 0,2303 do
		if readMemory(pTd + i*4,4) ~= 0 then
			table.insert(tds,i)
		end
	end
	return tds
end

--ñäåëàòü ñêðèí
function takeScreen()
	if isSampLoaded() then
		memory.setuint8(sampGetBase() + 0x119CBC, 1)
	end
end
--antiafk
function workpaus(bool)	
	if bool then
		memory.setuint8(7634870, 1, false)
		memory.setuint8(7635034, 1, false)
		memory.fill(7623723, 144, 8, false)
		memory.fill(5499528, 144, 6, false)
	else
		memory.setuint8(7634870, 0, false)
		memory.setuint8(7635034, 0, false)
		memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
		memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
	end
	-- AFKMessage('AntiAFK '..(bool and 'ðàáîòàåò' or 'íå ðàáîòàåò'))
end
function sampFastConnect(bool)
	if bool then 
		writeMemory(sampGetBase() + 0x2D3C45, 2, 0, true)
	else
		writeMemory(sampGetBase() + 0x2D3C45, 2, 8228, true)
	end
end
-- àâòîçàïîëíåíèå
function findDialog(id, dialog)
	for k, v in pairs(savepass[id][3]) do
		if v.id == dialog then
			return k
		end
	end
	return -1
end
function findAcc(nick, ip)
	for k, v in pairs(savepass) do
		if nick == v[1] and ip == v[2] then
			return k
		end
	end
	return -1
end
function getAcc()
	local nick = tostring(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
	local ip, port = sampGetCurrentServerAddress()
	local ip = ip .. ":" .. port
	local acc = findAcc(nick, ip)
	return acc
end

--õóêèèèèèèèèèèèèèèèèèèè
function onReceivePacket(id, bitStream)
	if (id == PACKET_DISCONNECTION_NOTIFICATION or id == PACKET_INVALID_PASSWORD) then
		goaurc()
	end
	if (id == PACKET_CONNECTION_BANNED) then	
		ip,port = sampGetCurrentServerAddress()
		if arec.state.v and arec.statebanned.v then
			lua_thread.create(function()
				wait(1000)
				sampConnectToServer(ip,port)
			end)
		end
	end
end
function onReceiveRpc(id,bitStream)
	if (id == RPC_CONNECTIONREJECTED) then
		goaurc()
	end
end

tblclosetest = {['50.83'] = 50.84, ['49.9'] = 50, ['49.05'] = 49.15, ['48.2'] = 48.4, ['47.4'] = 47.6, ['46.5'] = 46.7, ['45.81'] = '45.84',
['44.99'] = '45.01', ['44.09'] = '44.17', ['43.2'] = '43.4', ['42.49'] = '42.51', ['41.59'] = '41.7', ['40.7'] = '40.9', ['39.99'] = 40.01,
['39.09'] = 39.2, ['38.3'] = 38.4, ['37.49'] = '37.51', ['36.5'] = '36.7', ['35.7'] = '35.9', ['34.99'] = '35.01', ['34.1'] = '34.2';}
tblclose = {}

sendcloseinventory = function()
	sampSendClickTextdraw(tblclose[1])
end
function sampev.onSendCommand(mess)
	if mess:find('^/vr') then
		lastvrmessage = mess
	end
end
function sampev.onShowTextDraw(id,data)
	-- for k,v in pairs(data) do
	-- 	if id == 2110 then
	-- 		__idclosebutton = id
	-- 		print(k,v)
	-- 		if type(v) == 'table' then
	-- 			for kb,bv in pairs(v) do
	-- 				print('	',kb,bv)
	-- 			end
	-- 		end
	-- 	end
	-- end

	--find close button / thx dmitriyewich
	for w, q in pairs(tblclosetest) do
		if data.lineWidth >= tonumber(w) and data.lineWidth <= tonumber(q) and data.text:find('^LD_SPAC:white$') then
			for i=0, 2 do rawset(tblclose, #tblclose + 1, id) end
		end
	end

	if eat.checkmethod.v == 1 then
		if data.boxColor == -1436898180 then 
			if data.position.x == 549.5 and data.position.y == 60 then
				print('get hun > its hungry')
				if math.floor(((data.lineWidth - 549.5) / 54.5) * 100) <= eat.eat2met.v then
					onPlayerHungry:run()
				end
			end
		end
	end
	if aopen then -- state
		if roulette.standart.v then --standard
			if data.modelId == 19918 then --standart model
				opentimerid.standart = id + 1
			end
			if checkopen.standart then
				if id == opentimerid.standart then
					AFKMessage('[standart] ïûòàþñü îòêðûòü ñóíäóê')
					sampSendClickTextdraw(id - 1) 
					sampSendClickTextdraw(2301)
					if not checkopen.donate and not checkopen.platina then
						sendcloseinventory()
					end
					checkopen.standart = false
				end
			end
		end
		if roulette.donate.v then
			if data.modelId == 19613 then --standart model
				opentimerid.donate = id + 1
			end
			if checkopen.donate then
				if id == opentimerid.donate then
					AFKMessage('[donate] ïûòàþñü îòêðûòü ñóíäóê')
					sampSendClickTextdraw(id - 1) 
					sampSendClickTextdraw(2302)
					if not checkopen.standard and not checkopen.platina then
						sendcloseinventory()
					end
					checkopen.donate = false
				end
			end
		end
		if roulette.platina.v then
			if data.modelId == 1353 then --standart model
				opentimerid.platina = id + 1
			end
			if checkopen.platina then
				if id == opentimerid.platina then
					AFKMessage('[platina] ïðîáóþ îòêðûòü ñóíäóê')
					sampSendClickTextdraw(id - 1) 
					sampSendClickTextdraw(2302)
					if not checkopen.standard and not checkopen.donate then
						sendcloseinventory()
					end
					checkopen.platina = false
				end
			end
		end
	end
	-- print('ID = %s, ModelID = %s',id,data.modelId)
end
function sampev.onSetPlayerHealth(healthfloat)
	if eat.healstate.v and sampIsLocalPlayerSpawned() then
		if healthfloat <= eat.hplvl.v then
			if eat.hpmetod.v == 0 then
				sampSendChat('/usemed')
			elseif eat.hpmetod.v == 1 then
				sampSendChat('/usedrugs '..eat.drugsquen.v)
			elseif eat.hpmetod.v == 2 then
				sampSendChat('/adrenaline')
			elseif eat.hpmetod.v == 3 then
				sampSendChat('/beer')
			elseif eat.hpmetod.v == 4 then
				sampSendClickTextdraw(eat.arztextdrawidheal.v)
			end 
		end   
	end
end
function sampev.onSendTakeDamage(playerId, damage, weapon, bodypart)
	local killer = ''
	if vknotf.islowhp.v then
		if sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(playerPed))) - damage <= 0 and sampIsLocalPlayerSpawned() then
			if playerId > -1 and playerId < 1001 then
				killer = '\nÓáèéöà: '..sampGetPlayerNickname(playerId)..'['..playerId..']'
			end
			sendvknotf('Âàø ïåðñîíàæ óìåð'..killer)
		end
	end
end
function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if dialogText:find('Âû ïîëó÷èëè áàí àêêàóíòà') then
		if banscreen.v then
			createscreen:run()
		end
		if vknotf.isadm.v then
			local svk = dialogText:gsub('\n','') 
			svk = svk:gsub('\t','') 
			sendvknotf('(warning | dialog) '..svk)
		end
	end
	if dialogText:find('Âûáåðèòå òèï îáúÿâëåíèÿ:') then
		if autoad.v then
			sampSendDialogResponse(15346, 1, 0, -1)
		end
	end
	if dialogText:find('Ïðîâåðüòå óêàçàííûå âàìè äàííûå') then
		if autoad.v then
			sampSendDialogResponse(15347, 1, 0, -1)
		end
	end
	if dialogText:find('Âàøå îáúÿâëåíèå åùå íå ðàññìîòðåíî') then
		if autoad.v then
			sampSendDialogResponse(15379, 0, 0, -1)
		end
	end
	if dialogText:find('Âûáåðèòå òèï îáúÿâëåíèÿ:') then
		if autoadbiz.v then
			sampSendDialogResponse(15346, 1, 2, -1)
		end
	end
	if dialogText:find('Ïðîâåðüòå óêàçàííûå âàìè äàííûå') then
		if autoadbiz.v then
			sampSendDialogResponse(15347, 1, 0, -1)
		end
	end
	if dialogText:find('Âàøå îáúÿâëåíèå åùå íå ðàññìîòðåíî') then
		if autoadbiz.v then
			sampSendDialogResponse(15379, 0, 0, -1)
		end
	end
	if vknotf.isadm.v then
		if dialogText:find('Àäìèíèñòðàòîð (.+) îòâåòèë âàì') then
			local svk = dialogText:gsub('\n','') 
			svk = svk:gsub('\t','') 
			sendvknotf('(warning | dialog) '..svk)
		end
	end
	if vknotf.iscode.v then
		if dialogText:find('áûëî îòïðàâëåíî') then
			sendvknotf('Òðåáóåòñÿ êîä ñ ïî÷òû.\nÂâåñòè êîä: !sendcode êîä')
		end
	end
	if vknotf.iscode.v then
		if dialogText:find('×åðåç ëè÷íîå ñîîáùåíèå Âàì íà ñòðàíèöó') then
			sendvknotf('Òðåáóåòñÿ êîä ñ ÂÊ.\nÂâåñòè êîä: !sendvk êîä')
		end
	end
	if vknotf.iscode.v then
		if dialogText:find('Ê ýòîìó àêêàóíòó ïîäêëþ÷åíî ïðèëîæåíèå') then
			sendvknotf('Òðåáóåòñÿ êîä èç GAuthenticator.\nÂâåñòè êîä: !gauth êîä')
		end
	end
	if vknotf.iscode.v then
		if dialogText:find('×åðåç ëè÷íîå ñîîáùåíèå Âàì íà ñòðàíèöó') then
			sendvknotf('Òðåáóåòñÿ êîä ñ ÂÊ.\nÂâåñòè êîä: !sendvk êîä')
		end
	end
	if gotoeatinhouse then
		local linelist = 0
		for n in dialogText:gmatch('[^\r\n]+') do
			if dialogId == 174 and n:find('Ìåíþ äîìà') then
				print('debug: 174 dialog')
				sampSendDialogResponse(174, 1, linelist, false)
			elseif dialogId == 2431 and n:find('Õîëîäèëüíèê') then
				print('debug: 2431 dialog')
				sampSendDialogResponse(2431, 1, linelist, false)
			elseif dialogId == 185 and n:find('Êîìïëåêñíûé Îáåä') then
				print('debug: 185 dialog')
				sampSendDialogResponse(185, 1, linelist-1, false)
				gotoeatinhouse = false
			end
			linelist = linelist + 1
		end
		return false
	end
	if gethunstate and dialogId == 0 and dialogText:find('Âàøà ñûòîñòü') then
		sampSendDialogResponse(id,0,0,'')
		gethunstate = dialogText
		return false
	end
	if sendstatsstate and dialogId == 235 then
		sampSendDialogResponse(id,0,0,'')
		sendstatsstate = dialogText
		return false
	end
	if dialogStyle == 1 or dialogStyle == 3 then
		local acc = getAcc()
		local bool = true
		if acc > -1 then
			if autologin.state.v then
				local dialog = findDialog(acc, dialogId)
				if dialog > -1 then
				
					sampSendDialogResponse(dialogId, 1, 0, tostring(savepass[acc][3][dialog].text))
					return false
				else
					bool = true
				end
			end
		else
			bool = true
		end
		if bool then
			dialogChecker.check = true
			dialogChecker.id = dialogId
			dialogChecker.title = dialogTitle
		end
	else
		dialogChecker.check = false
		dialogChecker.id = -1
		dialogChecker.title = ""
	end
end
function sampev.onServerMessage(color,text)
	-- print(text .. ' \\ ' .. color)
	if gotoeatinhouse then
		if text:find('ýëåêòðîýíåðãèþ') then
			AFKMessage('Íåâîçìîæíî ïîêóøàòü! Îïëàòèòå êîìóíàëêó!')
			gotoeatinhouse = false
		end
	end
	if vknotf.issellitem.v then 
		if color == -1347440641 and text:find('îò ïðîäàæè') and text:find('êîìèññèÿ') then
			sendvknotf(text)
		end
		if color == 1941201407 and text:find('Ïîçäðàâëÿåì ñ ïðîäàæåé òðàíñïîðòíîãî ñðåäñòâà') then
			sendvknotf('Ïîçäðàâëÿåì ñ ïðîäàæåé òðàíñïîðòíîãî ñðåäñòâà')
		end
	end
	if color == -10270721 and text:find('Âû ìîæåòå âûéòè èç ïñèõèàòðè÷åñêîé áîëüíèöû') then
		if vknotf.isdemorgan.v then
			sendvknotf(text)
		end
	end
	if text:find('^Àäìèíèñòðàòîð (.+) îòâåòèë âàì') then
		if vknotf.isadm.v then
			sendvknotf('(warning | chat) '..text)
		end
	end
	if color == -10270721 and text:find('Àäìèíèñòðàòîð') then
		local res, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if res then 
			local mname = sampGetPlayerNickname(mid)
			if text:find(mname) then
				if vknotf.isadm.v then
					sendvknotf(text)
				end
			end
		end
	end
	if vknotf.issmscall.v then
		if text:find('Âàì ïðèøëî íîâîå ñîîáùåíèå!') then
			sendvknotf('Âàì íàïèñàëè ÑÌÑ!')
		end
	end
	if vknotf.issmscall.v then 
		if text:find('äëÿ òîãî, ÷òîáû ïîêàçàòü êóðñîð óïðàâëåíèÿ èëè') then
			sendvknotf('Âàì çâîíÿò!')
		end
	end 
	if autoo.v then 
		if text:find('äëÿ òîãî, ÷òîáû ïîêàçàòü êóðñîð óïðàâëåíèÿ èëè') then
			setVirtualKeyDown(89, true)
			setVirtualKeyDown(89, false)
			sampSendClickTextdraw(2108)
		end
	end
	if autoo.v then
		if text:find('Âû ïîäíÿëè òðóáêó') then
			sampSendChat(u8:decode(atext.v))
		end
	end
	if vknotf.iscode.v then
		if text:find('Íà ñåðâåðå åñòü èíâåíòàðü, èñïîëüçóéòå êëàâèøó Y äëÿ ðàáîòû ñ íèì.') then
			sendvknotf('Ïåðñîíàæ çàñïàâíåí')
		end
	end		
	if vknotf.ismeat.v then
		if text:find('Èñïîëüçîâàòü ìåøîê ñ ìÿñîì ìîæíî ðàç â 30 ìèíóò!') then
			sendvknotf(text)
		end
	end
	if vknotf.record.v then
		if text:find('%[Òåë%]%:') then
			sendvknotf(text)
		end
	end
	if vknotf.record.v then
		if text:find('Âû ïîäíÿëè òðóáêó') then
			sendvknotf(text)
		end
	end
	if vknotf.record.v then
		if text:find('Âû îòìåíèëè çâîíîê') then
			sendvknotf(text)
		end
	end
	if vknotf.record.v then
		if text:find('Çâîíîê îêîí÷åí! Âðåìÿ ðàçãîâîðà') then
			sendvknotf(text)
		end
	end
	if vknotf.ismeat.v then
		if text:find('Âðåìÿ ïîñëå ïðîøëîãî èñïîëüçîâàíèÿ åù¸ íå ïðîøëî!') then
			sendvknotf(text)
		end
	end
	if vknotf.ismeat.v then
		if text:find('ñóíäóê ñ ðóëåòêàìè è ïîëó÷èëè') then
			sendvknotf(text)
		end
	end
	if vknotf.ispayday.v then
		if text:find('Áàíêîâñêèé ÷åê') and color == 1941201407 then
			vknotf.ispaydaystate = true
			vknotf.ispaydaytext = ''
		end
		if vknotf.ispaydaystate then
			if text:find('Äåïîçèò â áàíêå') then 
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
			elseif text:find('Ñóììà ê âûïëàòå') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text 
			elseif text:find('Òåêóùàÿ ñóììà â áàíêå') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
			elseif text:find('Òåêóùàÿ ñóììà íà äåïîçèòå') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
			elseif text:find('Â äàííûé ìîìåíò ó âàñ') then
				vknotf.ispaydaytext = vknotf.ispaydaytext..'\n'..text
				sendvknotf(vknotf.ispaydaytext)
				vknotf.ispaydaystate = false
				vknotf.ispaydaytext = ''
			end
		end
	end
	if returnmessageforvr.v then
		if text:find('Ïîñëå ïîñëåäíåãî ñîîáùåíèÿ â ýòîì ÷àòå íóæíî ïîäîæäàòü 3 ñåêóíäû') or text:find('Äëÿ âîçìîæíîñòè ïîâòîðíîé îòïðàâêè ñîîáùåíèÿ â ýòîò ÷àò îñòàëîñü') then
			sampAddChatMessage("[ReSend /vr]{ffffff} Ïåðåîòïðàâëÿþ...",-10270721)
			lua_thread.create(function() 
				wait(1000)
				sampSendChat(lastvrmessage)
			end)
		end
	end
end
function sampev.onInitGame(playerId, hostName, settings, vehicleModels, unknown)
	if vknotf.isinitgame.v then
		sendvknotf('Âû ïîäêëþ÷èëèñü ê ñåðâåðó!', hostName)
	end
end
function sampev.onDisplayGameText(style, time, text)
	-- print('[GameText | '..os.date('%H:%M:%S')..'] '..'style == '..style..', time == '..time..', text == '..text)
	if eat.checkmethod.v == 0 then
		if text == ('You are hungry!') or text == ('~r~You are very hungry!') then
			if vknotf.ishungry.v then
				sendvknotf('Âû ïðîãîëîäàëèñü!')
			end
			onPlayerHungry:run()
		end
	end 
end
function sampev.onSendDialogResponse(dialogid, button, list, text)
	if dialogChecker.check and dialogChecker.id == dialogid and button == 1 then
		local ip, port = sampGetCurrentServerAddress()
		table.insert(temppass, {
			id = dialogid,
			title = dialogChecker.title,
			text = text,
			time = os.date("%H:%M:%S"),
			ip = ip .. ":" .. port,
			nick = tostring(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
		})
		dialogChecker.check = false
		dialogChecker.id = -1
		dialogChecker.title = ""
	end
end	
-- ðåêîíû 
-- ðåêîí ñòàíäàðò 
function reconstandart(timewait,bool_close)
	if handle_aurc then
		handle_aurc:terminate()
		handle_aurc = nil
		AFKMessage('Àâòîðåêîííåêò îñòàíîâëåí ò.ê âû èñïîëüçîâàëè îáû÷íûé ðåêîííåêò')
	end
	if handle_rc then
		handle_rc:terminate()
		handle_rc = nil
		AFKMessage('Ïðåäûäóùèé ðåêîííåêò áûë îñòàíîâëåí')
	end
	handle_rc = lua_thread.create(function(timewait2, bclose)
		bclose = bclose or true
		if bclose then
			closeConnect()
		end
		timewait2 = tonumber(timewait2)
		if timewait2 then	
			if timewait2 >= 0 then
				recwaitim = timewait2*1000
				AFKMessage('Ðåêîííåêò ÷åðåç '..timewait2..' ñåêóíä')
				wait(recwaitim)
				sampConnectToServer(sampGetCurrentServerAddress())
			end
		else
			AFKMessage('Ðåêîííåêò...')
			sampConnectToServer(sampGetCurrentServerAddress())
		end  
		handle_rc = nil
	end,timewait, bool_close)
end
--ðåêîí ñ íèêîì 
function reconname(playername,ips,ports)
	if handle_aurc then
		handle_aurc:terminate()
		handle_aurc = nil
		AFKMessage('Àâòîðåêîííåêò îñòàíîâëåí ò.ê âû èñïîëüçîâàëè ðåêîííåêò ñ íèêîì')
	end
	if handle_rc then
		handle_rc:terminate()
		handle_rc = nil
		AFKMessage('Ïðåäûäóùèé ðåêîííåêò áûë îñòàíîâëåí')
	end
	handle_rc = lua_thread.create(function()
		if #playername == 0 then
			AFKMessage('Ââåäèòå íèê äëÿ ðåêîííåêòà')
		else
			closeConnect()
			sampSetLocalPlayerName(playername)
			AFKMessage('Ðåêîííåêò ñ íîâûì íèêîì\n'..playername)
			local ip, port = sampGetCurrentServerAddress()
			ips,ports = ips or ip, ports or port
			sampConnectToServer(ips,ports)
		end 
	end)
end
-- ñîçäàòü autorecon
function goaurc()
	if vknotf.iscloseconnect.v then
		sendvknotf('Ïîòåðÿíî ñîåäèíåíèå ñ ñåðâåðîì')
	end
	if arec.state.v then
		if handle_aurc then
			handle_aurc:terminate()
			handle_aurc = nil
			AFKMessage('Ïðåäûäóùèé àâòîðåêîííåêò áûë îñòàíîâëåí')
		end
		if handle_rc then
			handle_rc:terminate()
			handle_rc = nil
			AFKMessage('Îáû÷íûé àâòîðåêîííåêò áûë îñòàíîâëåí ò.ê ñðàáîòàë àâòîðåêîííåêò')
		end
		handle_aurc = lua_thread.create(function()
			local ip, port = sampGetCurrentServerAddress()
			AFKMessage('Ñîåäèíåíèå ïîòåðÿíî. Ðåêîííåêò ÷åðåç '..arec.wait.v..' ñåêóíä')
			wait(arec.wait.v * 1000)
			sampConnectToServer(ip,port)
			handle_aurc = nil
		end)
	end
end
--çàêðûòü ñîåäèíåíèå
function closeConnect()
	raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
	raknetDeleteBitStream(raknetNewBitStream())
end

--//saves
function saveini()
	--login
	mainIni.autologin.state = autologin.state.v
	--autoreconnect
	mainIni.arec.state = arec.state.v
	mainIni.arec.statebanned = arec.statebanned.v
	mainIni.arec.wait = arec.wait.v
	--roulette
	mainIni.roulette.standart = roulette.standart.v
	mainIni.roulette.donate = roulette.donate.v
	mainIni.roulette.wait = roulette.wait.v
	--vk.notf
	mainIni.vknotf.state = vknotf.state.v
	mainIni.vknotf.token = vknotf.token.v
	mainIni.vknotf.user_id = vknotf.user_id.v
	mainIni.vknotf.group_id = vknotf.group_id.v
	mainIni.vknotf.isadm = vknotf.isadm.v
	mainIni.vknotf.iscode = vknotf.iscode.v
	mainIni.vknotf.issmscall = vknotf.issmscall.v
	mainIni.vknotf.record = vknotf.record.v
	mainIni.vknotf.ismeat = vknotf.ismeat.v
	mainIni.vknotf.isinitgame = vknotf.isinitgame.v	
	mainIni.vknotf.iscloseconnect = vknotf.iscloseconnect.v
	mainIni.vknotf.ishungry = vknotf.ishungry.v
	mainIni.vknotf.isdemorgan = vknotf.isdemorgan.v
	mainIni.vknotf.islowhp = vknotf.islowhp.v
	mainIni.vknotf.ispayday = vknotf.ispayday.v
	mainIni.vknotf.iscrashscript = vknotf.iscrashscript.v
	mainIni.vknotf.issellitem = vknotf.issellitem.v
	--piar
	mainIni.piar.piar1 = piar.piar1.v
	mainIni.piar.piar2 = piar.piar2.v
	mainIni.piar.piar3 = piar.piar3.v
	mainIni.piar.piarwait = piar.piarwait.v
	mainIni.piar.piarwait2 = piar.piarwait2.v
	mainIni.piar.piarwait3 = piar.piarwait3.v
	mainIni.piar.auto_piar = piar.auto_piar.v
	mainIni.piar.auto_piar_kd = piar.auto_piar_kd.v
	--main config
	mainIni.config.antiafk = antiafk.v
	mainIni.config.banscreen = banscreen.v
	mainIni.config.fastconnect = fastconnect.v
	mainIni.config.autoad = autoad.v
	mainIni.config.autoadbiz = autoadbiz.v
	mainIni.config.autoo = autoo.v
	mainIni.config.atext = atext.v
	mainIni.config.returnmessageforvr = returnmessageforvr.v
	--eat
	mainIni.eat.checkmethod = eat.checkmethod.v
	mainIni.eat.cycwait = eat.cycwait.v
	mainIni.eat.eatmetod = eat.eatmetod.v
	mainIni.eat.eat2met = eat.eat2met.v
    mainIni.eat.arztextdrawid = eat.arztextdrawid.v
    mainIni.eat.arztextdrawidheal = eat.arztextdrawidheal.v
    mainIni.eat.setmetod = eat.setmetod.v
    mainIni.eat.hpmetod = eat.hpmetod.v
    mainIni.eat.hplvl = eat.hplvl.v
    mainIni.eat.healstate = eat.healstate.v
	mainIni.eat.drugsquen = eat.drugsquen.v
	mainIni.eat.hpmetod = eat.hpmetod.v
	local saved = inicfg.save(mainIni,'afktools.ini')
	AFKMessage('Íàñòðîéêè INI ñîõðàíåíû '..(saved and 'óñïåøíî!' or 'ñ îøèáêîé!'))
end
function saveacc(...)
	local a = {...}

	local data
	if #a == 1 then
		data = temppass[a[1]]
	else
		data = {
			nick = a[1],
			ip = a[4],
			id = a[3],
			text = a[2]
		}
	end
	local id = findAcc(data.nick, data.ip)
	if id > -1 then
		local dId = findDialog(id, data.id)
		if dId == -1 then
			table.insert(savepass[id][3], {
				id = data.id,
				text = data.text
			})
		end
	else
		table.insert(savepass, {
			data.nick,
			data.ip,
			{
				{
					id = data.id,
					text = data.text
				}
			}
		})
	end
end
function saveaccounts()
	if doesFileExist(file_accs) then
		os.remove(file_accs)
	end
	if table.maxn(savepass) > 0 then
		local f = io.open(file_accs, "w")
		if f then
			f:write(encodeJson(savepass))
			f:close()
		end
	end
	print('[Accounts] Saved!')
end
-- // ñèñòåìà àâòîîáíîâëåíèÿ
updates = {}
updates.data = {
	result = false,
	status = '',
	relevant_version = '',
	url_update = '',
	url_json = 'http://f0494401.xsph.ru/api/updates/afktools' 
}

function updates:download()
	if self.data.result and #self.data.relevant_version > 0  then
		if self.data.relevant_version ~= thisScript().version then
			self.data.status = 'Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..self.data.relevant_version
			AFKMessage(self.data.status)
			int_scr_download = downloadUrlToFile(self.data.url_update, thisScript().path, function(id3, status1, p13, p23)
				if status1 == dlstatus.STATUS_ENDDOWNLOADDATA and int_scr_download == id3 then
					AFKMessage('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')
					AFKMessage('Îáíîâëåíèå çàâåðøåíî!')
					goupdatestatus = true          
					lua_thread.create(function() wait(500) thisScript():reload() end)
				end
				if status1 == dlstatus.STATUSEX_ENDDOWNLOAD and int_scr_download == id3 then
					if goupdatestatus == nil then
						self.data.status = 'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóùåíà ñòàðàÿ âåðñèÿ.'
						AFKMessage(self.data.status)
					end
				end
			end)
		else
			self.data.status = 'Îáíîâëåíèå íå òðåáóåòñÿ.'
			AFKMessage(self.data.status)
		end
	end
end
--// ñòèëü, òåìà è ëîãî
function esstyle()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	
	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 4
	style.ChildWindowRounding = 5
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 3.0
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

end
esstyle()

function theme1()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00);
	colors[clr.ChildWindowBg]          = colors[clr.WindowBg];
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00);
    colors[clr.Border]                 = ImVec4(0.60, 0.60, 0.60, 0.40);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.00);
    colors[clr.FrameBg]                = ImVec4(0.36, 0.36, 0.36, 0.30);
    colors[clr.FrameBgHovered]         = ImVec4(0.53, 0.53, 0.53, 0.30);
    colors[clr.FrameBgActive]          = ImVec4(0.62, 0.62, 0.62, 0.30);
    colors[clr.TitleBg]                = ImVec4(0.12, 0.12, 0.12, 0.92);
    colors[clr.TitleBgActive]          = ImVec4(0.11, 0.11, 0.11, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.11, 0.11, 0.11, 0.85);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.13, 0.13, 0.13, 0.00);
    colors[clr.ScrollbarGrab]          = ImVec4(0.26, 0.26, 0.26, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.19, 0.19, 0.19, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.40, 0.40, 0.40, 1.00);
    colors[clr.ComboBg]                = ImVec4(0.23, 0.23, 0.23, 1.00);
    colors[clr.CheckMark]              = ImVec4(0.90, 0.90, 0.90, 1.00);
    colors[clr.SliderGrab]             = ImVec4(0.27, 0.27, 0.27, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(0.24, 0.23, 0.23, 1.00);
    colors[clr.Button]                 = ImVec4(0.36, 0.36, 0.36, 0.40);
    colors[clr.ButtonHovered]          = ImVec4(0.47, 0.46, 0.46, 0.40);
    colors[clr.ButtonActive]           = ImVec4(0.64, 0.64, 0.64, 0.53);
    colors[clr.Header]                 = ImVec4(0.36, 0.36, 0.36, 0.30);
    colors[clr.HeaderHovered]          = ImVec4(0.49, 0.49, 0.49, 0.30);
    colors[clr.HeaderActive]           = ImVec4(0.42, 0.42, 0.42, 0.30);
    colors[clr.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40);
    colors[clr.SeparatorHovered]       = ImVec4(0.36, 0.36, 0.36, 0.40);
    colors[clr.SeparatorActive]        = ImVec4(0.23, 0.23, 0.23, 0.40);
    colors[clr.ResizeGrip]             = ImVec4(0.36, 0.36, 0.36, 0.30);
    colors[clr.ResizeGripHovered]      = ImVec4(0.49, 0.49, 0.49, 0.30);
    colors[clr.ResizeGripActive]       = ImVec4(0.25, 0.25, 0.25, 0.30);
    colors[clr.CloseButton]            = ImVec4(0.36, 0.36, 0.36, 0.30);
    colors[clr.CloseButtonHovered]     = ImVec4(0.51, 0.51, 0.51, 0.30);
    colors[clr.CloseButtonActive]      = ImVec4(0.22, 0.22, 0.22, 0.30);
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(0.25, 0.25, 0.25, 0.60);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.21, 0.21, 0.21, 0.51);
end

theme1()
local _logos ="\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x28\x00\x00\x00\x28\x08\x06\x00\x00\x00\x8C\xFE\xB8\x6D\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x00\x20\x63\x48\x52\x4D\x00\x00\x7A\x25\x00\x00\x80\x83\x00\x00\xF9\xFF\x00\x00\x80\xE9\x00\x00\x75\x30\x00\x00\xEA\x60\x00\x00\x3A\x98\x00\x00\x17\x6F\x92\x5F\xC5\x46\x00\x00\x19\x38\x49\x44\x41\x54\x78\x01\x00\x28\x19\xD7\xE6\x01\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x11\x00\x00\x00\x00\x00\x00\x00\x89\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x99\x00\x00\x00\x00\x00\x00\x00\x9A\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xBC\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xCC\x00\x00\x00\x33\x00\x00\x00\xEF\x00\x00\x00\x12\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x22\x00\x00\x00\x33\x00\x00\x00\x00\x00\x00\x00\x9A\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xAB\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xDD\x00\x00\x00\x22\x00\x00\x00\xDE\x00\x00\x00\x23\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x33\x00\x00\x00\x22\x00\x00\x00\x00\x00\x00\x00\x9A\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x33\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xAB\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xEE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xCC\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xDD\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x11\xFF\xFF\xFF\x77\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x55\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x66\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xAA\xFF\xFF\xFF\x22\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x55\xFF\xFF\xFF\xDD\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xCC\xFF\xFF\xFF\x22\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x99\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x11\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xEE\xFF\xFF\xFF\x77\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xEE\xFF\xFF\xFF\x66\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x11\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xAA\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x44\xFF\xFF\xFF\xDD\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xDD\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x77\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x88\xFF\xFF\xFF\x11\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x66\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x66\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x77\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x99\xFF\xFF\xFF\x11\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xDD\xFF\xFF\xFF\x66\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xAA\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xEE\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x44\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xDD\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x55\xFF\xFF\xFF\xEE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBB\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x99\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\x99\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xEE\xFF\xFF\xFF\x77\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x11\xFF\xFF\xFF\x88\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x33\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x77\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x55\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xEE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBB\xFF\xFF\xFF\x22\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x33\xFF\xFF\xFF\xBB\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xCC\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xDD\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xDD\xFF\xFF\xFF\x55\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x66\xFF\xFF\xFF\xEE\xFF\xFF\xFF\x44\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x88\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x77\xFF\xFF\xFF\x11\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x11\xFF\xFF\xFF\x11\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x88\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x33\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x22\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\xFF\xFF\xFF\x00\x01\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xDD\x00\x00\x00\x22\x00\x00\x00\xDE\x00\x00\x00\x23\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x33\x00\x00\x00\x22\x00\x00\x00\x00\x00\x00\x00\x9A\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xAB\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xEE\x00\x00\x00\x11\x00\x00\x00\xBC\x00\x00\x00\x45\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x55\x00\x00\x00\x11\x00\x00\x00\x00\x00\x00\x00\xAB\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x55\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xAB\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\xBC\x00\x00\x00\xCD\x00\x00\x00\xEF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\xFF\xFF\x04\xE2\xBC\xA7\x45\x71\x94\xC3\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"
logos = imgui.CreateTextureFromMemory(memory.strptr(_logos),#_logos)