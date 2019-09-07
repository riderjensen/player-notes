PlayerList = {} 

function MOD_TextFrame_OnUpdate()
  if (MOD_TextFrameTime <	 GetTime() - 1) then
    local alpha = MOD_TextFrame:GetAlpha();
    if (alpha ~= 0) then MOD_TextFrame:SetAlpha(alpha - .05); end
    if (alpha == 0) then MOD_TextFrame:Hide(); end
  end
end


-- For setting a message on the screen --
function MOD_TextMessage(message)
  MOD_TextFrame.text:SetText(message);
  MOD_TextFrame:SetAlpha(1);
  MOD_TextFrame:Show();
  MOD_TextFrameTime = GetTime();
end


-- For creating a frame --
function Create_Text_Frame(message, postion)
	MyFrame = CreateFrame("Frame");
	MyFrame:ClearAllPoints();
	MyFrame:SetBackdrop(StaticPopup1:GetBackdrop());
	MyFrame:SetHeight(75);
	MyFrame:SetWidth(250);

	MyFrame.text = MyFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
	MyFrame.text:SetAllPoints();
	MyFrame.text:SetText(message);
	MyFrame:SetPoint(postion, 0, 0);
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
	-- add some type of try catch to make sure we are getting a guid
	if string.find(guid, "Player") then
		return true;
	  else
		return nil;
	  end
end

-- FRIEND BUTTON
local friend_button = CreateFrame("Button");
friend_button:SetPoint("TOP", 100, 0);
friend_button:SetWidth(100);
friend_button:SetHeight(50);
friend_button:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
friend_button:SetText("Friend");
friend_button:SetNormalFontObject("GameFontNormal");
friend_button:SetScript("OnClick", Add_Friend);

-- ENEMY BUTTON
local enemy_button = CreateFrame("Button");
enemy_button:SetPoint("TOP", -100, 0);
enemy_button:SetWidth(100);
enemy_button:SetHeight(50);
enemy_button:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
enemy_button:SetText("Enemy");
enemy_button:SetNormalFontObject("GameFontNormal");
enemy_button:SetScript("OnClick",  Add_Enemy);

-- OTHER BUTTON
local other_button = CreateFrame("Button");
other_button:SetPoint("TOP", 0, 0);
other_button:SetWidth(100);
other_button:SetHeight(50);
other_button:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
other_button:SetText("Other");
other_button:SetNormalFontObject("GameFontNormal");
other_button:SetScript("OnClick", Add_Comment);

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
	if Check_If_Player() then 
		Hide_Buttons();
		local checkVar = Check_FriendShip();
		if checkVar == 1 then
			print("Kill!");
		elseif checkVar == 0 then
			print("Friend!");
		else 	
			Show_Buttons();
		end
	end
end)

-- SHOW BUTTONS FUNCTION
function Show_Buttons()
	enemy_button:Show();
	friend_button:Show();
	other_button:Show();
end

-- HIDE BUTTONS FUNCTION
function Hide_Buttons()
	enemy_button:Hide();
	friend_button:Hide();
	other_button:Hide();
end

Hide_Buttons();
