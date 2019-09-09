PlayerList = {} 

function MOD_TextFrame_OnUpdate()
	if (MOD_TextFrameTime <	 GetTime() - 1) then
		local alpha = MOD_TextFrame:GetAlpha();
		if (alpha ~= 0) then MOD_TextFrame:SetAlpha(alpha - .05); end
		if (alpha == 0) then MOD_TextFrame:Hide(); end
	end
end

function Background_Glow_OnUpdate()
	print(self:GetAlpha())
end

-- For setting a message on the screen --
function MOD_TextMessage(message)
	MOD_TextFrame.text:SetText(message);
	MOD_TextFrame:SetAlpha(1);
	MOD_TextFrame:Show();
	MOD_TextFrameTime = GetTime();
end


-- ADD FRIEND FUNCTION
function Add_Friend()
	MOD_TextMessage("Friend Added");
	PlayerList[UnitName("target")] = 0;
	Hide_Buttons();

end

-- ADD ENEMY FUNCTION
function Add_Enemy()
	MOD_TextMessage("Enemy Added");
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
	Background_Glow:SetAlpha(1);
	Background_Glow:SetScript("OnUpdate", Background_Glow_OnUpdate);
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
EnemyGlow = Glow("Interface\\FullScreenTextures\\LowHealth");
FriendGlow = Glow("Interface\\FullScreenTextures\\OutOfControl");
Friend_Button = Button(100, "Friend", Add_Friend);
Enemy_Button = Button(-100, "Enemy", Add_Enemy);
Other_Button = Button(0, "Comment", Add_Comment);


-- CREATING FRAME
MOD_TextFrame = CreateFrame("frame");
MOD_TextFrame:ClearAllPoints();
MOD_TextFrame:SetHeight(300);
MOD_TextFrame:SetWidth(300);
MOD_TextFrame:SetScript("OnUpdate", MOD_TextFrame_OnUpdate);
MOD_TextFrame:Hide();
MOD_TextFrame.text = MOD_TextFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont");
MOD_TextFrame.text:SetAllPoints();
MOD_TextFrame:SetPoint("CENTER", 0, 200);
MOD_TextFrameTime = 0;

MOD_TextFrame:RegisterEvent("UNIT_TARGET")
MOD_TextFrame:SetScript("OnEvent", function(self,event,...) 
	-- Hide the glows
	EnemyGlow:Hide();
	FriendGlow:Hide();
	Hide_Buttons();

	-- Check to see if there is a player
	if Check_If_Player() then 
		local checkVar = Check_FriendShip();
		if checkVar == 1 then
			EnemyGlow:Show();
		elseif checkVar == 0 then
			FriendGlow:Show();
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
