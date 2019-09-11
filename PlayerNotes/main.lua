PlayerList = {} 

function LowHPPulser_StartPulsing(frame)
	if (frame.pulsing == "in") then
		if (frame:GetAlpha() == 1) then
			LowHPPulser_PulseOut(frame)
		end
	elseif (frame.pulsing == "out") then
		if (frame:GetAlpha() == 0) then
			LowHPPulser_PulseIn(frame)
		end
	else
		frame:SetAlpha(0)
		LowHPPulser_PulseIn(frame)
	end
end

function LowHPPulser_StopPulsing(frame)
	frame.pulsing = false
	UIFrameFadeIn(frame, 1, frame:GetAlpha(), 0)
end

function LowHPPulser_PulseIn(frame)
	frame.pulsing = "in"
	UIFrameFadeIn(frame, 1, frame:GetAlpha(), 1)
end

function LowHPPulser_PulseOut(frame)
	frame.pulsing = "out"
	UIFrameFadeIn(frame, 1, frame:GetAlpha(), 0)
end


-- ADD FRIEND FUNCTION
function Add_Friend()
	PlayerList[UnitName("target")] = 0;
	Hide_Buttons();

end

-- ADD ENEMY FUNCTION
function Add_Enemy()
	PlayerList[UnitName("target")] = 1;
	Hide_Buttons();
end


function Add_Comment()
	-- call up a text box
	edit_box = CreateFrame("Frame");
	edit_box:ClearAllPoints();
	edit_box:SetBackdrop(StaticPopup1:GetBackdrop());
	edit_box:SetHeight(75);
	edit_box:SetWidth(250);

	edit_box.Text = edit_box:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
	edit_box.Text:SetAllPoints();
	edit_box:SetPoint("BOTTOMRIGHT", 0, 0);
	edit_box.Text = CreateFrame("EditBox", nil, edit_box)
	edit_box.Text:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		print(self:GetText())
	end)
	edit_box.Text:SetPoint("TOPRIGHT", -15, -15)
	edit_box.Text:SetPoint("BOTTOMLEFT", 15, 15)
	edit_box.Text:SetMultiLine(true)
	edit_box.Text:SetMaxLetters(1000)
	edit_box.Text:SetFontObject(GameFontNormal)
	edit_box.Text:SetAutoFocus(false)
	edit_box.Text:SetFocus(true)

	Hide_Buttons();
end

function Check_FriendShip()
	return PlayerList[UnitName("target")]
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
	Background_Glow:SetScript("OnUpdate", LowHPPulser_StartPulsing)
	Background_Glow:SetAlpha(0);
	Background_Glow.texture = Background_Glow:CreateTexture();
	Background_Glow.texture:SetAllPoints(Background_Glow);
	Background_Glow.texture:SetDrawLayer("BACKGROUND");
	Background_Glow.texture:SetBlendMode("ADD");
	Background_Glow.texture:SetTexture(path);
	return Background_Glow;
end


function Button(position, text, functionCall)
	local button = CreateFrame("Button");
	button:SetPoint("TOP", position, 0);
	button:SetWidth(100);
	button:SetHeight(50);
	button:SetBackdrop({bgFile = "Interface/AddOns/PlayerNotes/Textures/mage.tga", stretch = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
	button:SetText(text);
	button:SetNormalFontObject("GameFontNormal");
	button:SetScript("OnClick", functionCall);
	button:Hide();
	return button;
end

-- END FUNCTIONS --



-- Start Declarations --
Friend_Button = Button(100, "Friend", Add_Friend);
Enemy_Button = Button(-100, "Enemy", Add_Enemy);
Other_Button = Button(0, "Comment", Add_Comment);
EnemyGlow = Glow("Interface\\FullScreenTextures\\LowHealth");
FriendGlow = Glow("Interface\\FullScreenTextures\\OutOfControl");


-- CREATING FRAME
MOD_TextFrame = CreateFrame("frame");
MOD_TextFrameTime = 0;

MOD_TextFrame:RegisterEvent("UNIT_TARGET")
MOD_TextFrame:SetScript("OnEvent", function(self,event,...) 
	-- Hide the glows


	LowHPPulser_StopPulsing(EnemyGlow)
	LowHPPulser_StopPulsing(FriendGlow)

	Hide_Buttons();

	-- Check to see if there is a player
	if Check_If_Player() then 
		local checkVar = Check_FriendShip();
		if checkVar == 1 then
			LowHPPulser_StartPulsing(EnemyGlow)
		elseif checkVar == 0 then
			LowHPPulser_StartPulsing(FriendGlow)
		else 	
			Show_Buttons();
		end
	end
end)

function Show_Buttons()
	Enemy_Button:Show();
	Friend_Button:Show();
	Other_Button:Show();
end

function Hide_Buttons()
	Enemy_Button:Hide();
	Friend_Button:Hide();
	Other_Button:Hide();
end
