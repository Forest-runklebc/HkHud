	CreateFrame("Frame", "hkHUD_CORE")
	-- INIT some vars
	local _G = getfenv(0)
	local events = {}
	local hkFrame
	local hkCount = 0
	local statsText, hkText,statsFrame
	hkHUD_CORE:RegisterEvent("PLAYER_ENTERING_WORLD")
	
--[[
	Slash Command Handler
--]]
SLASH_hkhudCCCOMMAND1 = "/hkhud";
SlashCmdList["hkhudCCCOMMAND"] = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
	if(not msg or msg == "" or msg == "help" or msg == "?") then
		--print help messages
		DEFAULT_CHAT_FRAME:AddMessage("hkhud Commands:");
		DEFAULT_CHAT_FRAME:AddMessage("/hkhud toggle");
		DEFAULT_CHAT_FRAME:AddMessage("/hkhud lock");
	else
		DEFAULT_CHAT_FRAME:AddMessage("msg else block");
		
		--/omnicc size <size>
		if(msg == "toggle") then
			DEFAULT_CHAT_FRAME:AddMessage("attempting to toggle hks");
			toggle_hks()
		elseif(msg == "lock") then
			DEFAULT_CHAT_FRAME:AddMessage("attempting to lock");
			hkFrame:SetMovable(false)
			hkFrame:EnableMouse(false)
		elseif(msg == "unlock") then
			DEFAULT_CHAT_FRAME:AddMessage("attempting to lock");
			hkFrame:SetMovable(true)
			hkFrame:EnableMouse(true)
		end
	end
end

function toggle_hks()
	if hkFrame:IsVisible() then
		hkFrame:Hide()
	else
		hkFrame:Show()
	end
end	

	-- EVENT HANDLER --
hkHUD_CORE:SetScript('OnEvent', function() 
	if event == "PLAYER_ENTERING_WORLD" then
		MakeHKFrame()
		hkHUD_Ragebar_VarUpdate()
	elseif "CHAT_MSG_COMBAT_HONOR_GAIN" then
		hkCount_Update()
	end
end)

function hkHUD_RegisterEvent(event)
	local registered = false
	if table.getn(events) == 0 then
		hkHUD_CORE:RegisterEvent(event)
		events[table.getn(events)+1] = event
	else
		for i=1,table.getn(events) do
			if events[i] == event then registered = true end
			if i == table.getn(events) and not registered then
				hkHUD_CORE:RegisterEvent(event)
				events[table.getn(events)+1] = event
			end
		end
	end
end

function MakeHKFrame()
	--Movement code based off of http://www.wow-one.com/forum/topic/73974-help-movable-frame/
	--Create base frame
	hkFrame = CreateFrame("Frame", "hkFrame", UIParent)
	hkFrame:SetHeight(50)
	hkFrame:SetWidth(50)		
	hkFrame:SetFrameStrata("HIGH")
	hkFrame:SetScale(1)
	hkFrame:SetAlpha(1)
	hkFrame:SetPoint("CENTER", UIParent, 0 ,-1)
	hkFrame:Show()

	
	--Give hkFrame the ability to move
	--Movement code based off of http://www.wow-one.com/forum/topic/73974-help-movable-frame/
	hkFrame:SetClampedToScreen(true)
	hkFrame:SetMovable(true)
	hkFrame:EnableMouse(true)
	hkFrame.isMoving = false
	hkFrame:SetScript("OnMouseDown", function()
			if not hkFrame.isMoving then
				hkFrame:StartMoving();
				hkFrame.isMoving = true;
			end
	end)
	hkFrame:SetScript("OnMouseUp", function()
			if hkFrame.isMoving then
				hkFrame:StopMovingOrSizing();
				hkFrame.isMoving = false;
			end
	end)
	hkFrame:SetScript("OnHide", function()
			if (hkFrame.isMoving) then
					hkFrame.StopMovingOrSizing();
					hkFrame.isMoving = false;
			end
	end)

	
	-- Both of these text displays are bound to the base frame "hkFrame"
	-- Create text display of hkCount
	hkCount_TEXT = hkFrame:CreateFontString(nil, "OVERLAY")
		hkCount_TEXT:SetParent(hkFrame)
		hkCount_TEXT:SetFont("Fonts\\FRIZQT__.TTF", 1000,"OUTLINE")
		hkCount_TEXT:SetPoint("CENTER",hkFrame,0,-10)
		hkCount_TEXT:SetText("0")
		hkCount_TEXT:SetJustifyH("CENTER")
		hkCount_TEXT:SetTextColor(1,0,0)
		
	-- Create text display on frame of "HORDE KILL COUNT"	
	staticWording_TEXT = hkFrame:CreateFontString(nil, "OVERLAY")
		staticWording_TEXT:SetParent(hkFrame)
		staticWording_TEXT:SetFont("Fonts\\FRIZQT__.TTF", 20,"OUTLINE")
		staticWording_TEXT:SetPoint("CENTER",hkFrame,0,30)
		staticWording_TEXT:SetText("HORDE KILL COUNTER")
		staticWording_TEXT:SetJustifyH("CENTER")
		staticWording_TEXT:SetTextColor(1,0,0)
end

function hkHUD_Ragebar_VarUpdate()	
		hkHUD_RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
		hkFrame:SetPoint("CENTER", UIParent, 0 ,-100)
end

function hkCount_Update()
	hkCount = hkCount+1	
	hkCount_TEXT:SetText(hkCount)
end

------------
DEFAULT_CHAT_FRAME:AddMessage("BOTTOM OF HKHUD", 1.0, 0.0, 1.0)
