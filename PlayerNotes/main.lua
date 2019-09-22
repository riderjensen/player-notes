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
	local friendInfo = Create_Table(UnitName("target"), "0", PlayerList[UnitGUID("target")]["comment"])
	PlayerList[UnitGUID("target")] = friendInfo;
	Hide_Buttons();

end

-- ADD ENEMY FUNCTION
function Add_Enemy()
	local enemyInfo = Create_Table(UnitName("target"), "1", PlayerList[UnitGUID("target")]["comment"])
	PlayerList[UnitGUID("target")] = enemyInfo;
	Hide_Buttons();
end

function Create_Table(name, enemyBool, comment)
	comment = comment or ""
	enemyBool = enemyBool or ""
	local myTable = {};
	myTable["name"] = name;
	myTable["enemyBool"] = enemyBool;
	myTable["comment"] = comment;
	return myTable;
end

function Return_Info(unitGUID)
	return PlayerList[unitGUID];
end

function Add_Comment()
	edit_box = CreateFrame("Frame", "TchinFrame", UIParent, "BasicFrameTemplateWithInset");
	edit_box:ClearAllPoints();
	edit_box:SetHeight(100);
	edit_box:SetWidth(400);
	edit_box:SetMovable(true);

	edit_box.title = edit_box:CreateFontString(nil, "OVERLAY");
	edit_box.title:SetFontObject("GameFontHighlight");
	edit_box.title:SetPoint("LEFT", edit_box.TitleBg, 5, 0);
	edit_box.title:SetText(UnitName("target"));

	edit_box.Text = edit_box:CreateFontString(nil, "BACKGROUND", "GameFontNormal");
	edit_box.Text:SetAllPoints();
	edit_box:SetPoint("TOP", 0, -100);
	edit_box.Text = CreateFrame("EditBox", nil, edit_box)
	edit_box.Text:SetScript("OnEscapePressed", function(self)
		edit_box:Hide()
	end)
	edit_box.Text:SetScript("OnEnterPressed", function(self)
		PlayerList[UnitGUID("target")]["comment"] = edit_box.Text:GetText()
		edit_box.Text:ClearFocus()
		edit_box:Hide()
	end)
	edit_box.Text:SetPoint("TOPRIGHT", -15, -30)
	edit_box.Text:SetPoint("BOTTOMLEFT", 15, 40)
	edit_box.Text:SetMultiLine(false)
	edit_box.Text:SetMaxLetters(150)
	edit_box.Text:SetFontObject(GameFontNormal)
	edit_box.Text:SetFocus(true)


	-- Note button
	edit_box.noteBtn = CreateFrame("Button", nil, edit_box, "GameMenuButtonTemplate")
	edit_box.noteBtn:SetPoint("CENTER", edit_box, "BOTTOM", 0, 30);
	edit_box.noteBtn:SetSize(120, 30);
	edit_box.noteBtn:SetText("Add Note");
	edit_box.noteBtn:SetNormalFontObject("GameFontNormal");
	edit_box.noteBtn:SetHighlightFontObject("GameFontHighlight");
	edit_box.noteBtn:SetScript("OnClick", function(self)
		PlayerList[UnitGUID("target")]["comment"] = edit_box.Text:GetText()
		edit_box.Text:ClearFocus()
		edit_box:Hide()
	end)
end

function Comment_TextFrame_OnUpdate()
	if (Comment_TextFrameTime < GetTime() - 3) then
		local alpha = Comment_TextFrame:GetAlpha();
		if (alpha ~= 0) then Comment_TextFrame:SetAlpha(alpha - .05); end
		if (alpha == 0) then Comment_TextFrame:Hide(); end
	end
end

function MOD_TextMessage(message)
	Comment_TextFrame.text:SetText(message);
	Comment_TextFrame:SetAlpha(1);
	Comment_TextFrame:Show();
	Comment_TextFrameTime = GetTime();
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


function Button(positionTop, positionLeft,  functionCall, buttonString)
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


Comment_TextFrame = CreateFrame("Frame");
Comment_TextFrame:ClearAllPoints();
Comment_TextFrame:SetHeight(300);
Comment_TextFrame:SetWidth(300);
Comment_TextFrame:SetScript("OnUpdate", Comment_TextFrame_OnUpdate);
Comment_TextFrame:Hide();
Comment_TextFrame.text = Comment_TextFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont");
Comment_TextFrame.text:SetAllPoints();
Comment_TextFrame:SetPoint("CENTER", 0, 200);
Comment_TextFrameTime = 0;


-- Start Declarations --
Comment_Button = Button(-10, 2, Add_Comment, "Interface/AddOns/PlayerNotes/Textures/UI-GuildButton-PublicNote-Up.blp");
Friend_Button = Button(-25, 2, Add_Friend, "Interface/AddOns/PlayerNotes/Textures/Arrow-Up-Up.blp");
Enemy_Button = Button(-40, 2, Add_Enemy, "Interface/AddOns/PlayerNotes/Textures/Arrow-Down-Up.blp");
EnemyGlow = Glow("Interface\\FullScreenTextures\\LowHealth");
FriendGlow = Glow("Interface\\FullScreenTextures\\OutOfControl");


-- CREATING FRAME
MOD_TextFrame = CreateFrame("frame");
MOD_TextFrameTime = 0;

MOD_TextFrame:RegisterEvent("UNIT_TARGET")
MOD_TextFrame:SetScript("OnEvent", function(self,event,...) 

	local TARGET_GUID = UnitGUID("target");

	-- Hide the glows
	StopPulse(EnemyGlow);
	StopPulse(FriendGlow);
	Hide_Buttons();
	Comment_Button:Hide();

	-- Check to see if there is a player
	if Check_If_Player() then
		Comment_Button:Show();


		local checkVar = Return_Info(TARGET_GUID);
		if checkVar then 
			-- check if its a friend or foe
			if checkVar["enemyBool"] == "1" then
				StartPulse(EnemyGlow)
			elseif checkVar["enemyBool"] == "0" then
				StartPulse(FriendGlow)
			else 
				Show_Buttons()
			end

		-- check for an associated value on notes section
			if checkVar["comment"] ~= nil then
				MOD_TextMessage(checkVar["comment"])
			end
		else
			-- init a player obj
			Init_Player(TARGET_GUID);
			Show_Buttons()
		end
	end
end)

function Init_Player(GUID)
	PlayerList[GUID] = {};
	PlayerList[GUID]["enemyBool"] = nil;
	PlayerList[GUID]["name"] = nil;
	PlayerList[GUID]["comment"] = nil;
end

function Show_Buttons()
	Enemy_Button:Show();
	Friend_Button:Show();
end

function Hide_Buttons()
	Enemy_Button:Hide();
	Friend_Button:Hide();
end
