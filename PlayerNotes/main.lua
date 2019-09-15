PlayerList = {} 

function StopPulse(frame)
	frame.pulsing = false
	UIFrameFadeIn(frame, 0.5, frame:GetAlpha(), 0)
end

function StartPulse(frame)
	frame.pulsing = "in"
	UIFrameFadeIn(frame, 0.5, frame:GetAlpha(), 1)
end

-- ADD FRIEND FUNCTION
function Add_Friend()
	PlayerList[UnitGUID("target")] = 0;
	Hide_Buttons();

end

-- ADD ENEMY FUNCTION
function Add_Enemy()
	PlayerList[UnitGUID("target")] = 1;
	Hide_Buttons();
end

function Check_FriendShip()
	return PlayerList[UnitGUID("target")]
end

function Check_If_Player()
	local guid = UnitGUID("target");
	if guid ~= nil then
		if string.find(guid, "Player") then
			return true;
		else
			return nil;
		end
	end
end


function Glow(path)
	Background_Glow = CreateFrame("frame", "FriendFrame");
	Background_Glow:SetAllPoints();
	Background_Glow:SetAlpha(0);
	Background_Glow.texture = Background_Glow:CreateTexture();
	Background_Glow.texture:SetAllPoints(Background_Glow);
	Background_Glow.texture:SetDrawLayer("BACKGROUND");
	Background_Glow.texture:SetBlendMode("ADD");
	Background_Glow.texture:SetTexture(path);
	return Background_Glow;
end


function Button(positionTop, positionLeft, text,  functionCall, buttonString)
	local button = CreateFrame("Button");
	button:SetPoint("TOPLEFT", positionLeft, positionTop);
	button:SetWidth(15);
	button:SetHeight(15);
	button:SetBackdrop({bgFile = buttonString, stretch = false, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
	button:SetNormalFontObject("GameFontNormal");
	button:SetScript("OnClick", functionCall);
	button:Hide();
	return button;
end

-- END FUNCTIONS --



-- Start Declarations --
Friend_Button = Button(-20, 150, "Friend", Add_Friend, "Interface/AddOns/PlayerNotes/Textures/Arrow-Up-Down.blp");
Enemy_Button = Button(-35, 152, "Enemy", Add_Enemy, "Interface/AddOns/PlayerNotes/Textures/Arrow-Down-Up.blp");
EnemyGlow = Glow("Interface\\FullScreenTextures\\LowHealth");
FriendGlow = Glow("Interface\\FullScreenTextures\\OutOfControl");


-- CREATING FRAME
MOD_TextFrame = CreateFrame("frame");
MOD_TextFrameTime = 0;

MOD_TextFrame:RegisterEvent("UNIT_TARGET")
MOD_TextFrame:SetScript("OnEvent", function(self,event,...) 
	-- Hide the glows
	StopPulse(EnemyGlow)
	StopPulse(FriendGlow)
	Hide_Buttons();

	-- Check to see if there is a player
	if Check_If_Player() then 
		local checkVar = Check_FriendShip();
		if checkVar == 1 then
			StartPulse(EnemyGlow)
		elseif checkVar == 0 then
			StartPulse(FriendGlow)
		else 	
			Show_Buttons();
		end
	end
end)

function Show_Buttons()
	Enemy_Button:Show();
	Friend_Button:Show();
end

function Hide_Buttons()
	Enemy_Button:Hide();
	Friend_Button:Hide();
end
