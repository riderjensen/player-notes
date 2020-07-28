-- /script print(CanSendAuctionQuery())
-- /script print(QueryAuctionItems("", nil, nil, 0, 0, 0, 0, 0, 0, 1, true))


local waitTable = {};
local waitFrame = nil;

function __wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end



function GetTotalPages()
	for j = 1,2,1
	do
		local currentTime = GetTime()
		__wait((j*0.1), CheckItem, j)
	end
end

function CheckItem(index)
	local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, owner, saleStatus, itemId, hasAllInfo, extra = GetAuctionItemInfo("list", index)
	
	if (minBid < 4 and highBidder == false) then 

		-- SetSelectedAuctionItem("list", index)
		-- BrowseBidButton:Click()
		-- StaticPopup1Button1:Click()

		local bid = minBid + minIncrement
		PlaceAuctionBid("list", index, bid);
		print("Placed a bid of " .. minBid+minIncrement .. " on " .. name)
		-- end
	end
end


function Big_Query()
	QueryAuctionItems("", nil, nil, 0, 0, 0, 0, 0, 0, 1, true)
end

function SortItems()
	SortAuctionItems("list", "bid");
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
Comment_Button = Button(-10, 2, Big_Query, "Interface/AddOns/PlayerNotes/Textures/UI-GuildButton-PublicNote-Up.blp");
Friend_Button = Button(-25, 2, SortItems, "Interface/AddOns/PlayerNotes/Textures/Arrow-Up-Up.blp");
Enemy_Button = Button(-40, 2, GetTotalPages, "Interface/AddOns/PlayerNotes/Textures/Arrow-Down-Up.blp");


-- CREATING FRAME
MOD_TextFrame = CreateFrame("frame");
MOD_TextFrameTime = 0;

MOD_TextFrame:RegisterEvent("UNIT_TARGET")
MOD_TextFrame:SetScript("OnEvent", function(self,event,...) 

	Comment_Button:Show();
	Enemy_Button:Show();
	Friend_Button:Show();

end)

