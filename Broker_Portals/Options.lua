local Portals = LibStub("AceAddon-3.0"):GetAddon("BrokerPortals")
local L = LibStub("AceLocale-3.0"):GetLocale("BrokerPortals")
local WHITE = "|cffFFFFFF"

function Portals:OptionsToggle()
    if InterfaceOptionsFrame:IsVisible() then
		InterfaceOptionsFrame:Hide()
	else
		InterfaceOptionsFrame_OpenToCategory("BrokerPortals")
	end
end

function BrokerPortals_OpenOptions()
	if InterfaceOptionsFrame:GetWidth() < 850 then InterfaceOptionsFrame:SetWidth(850) end
	BrokerPortals_DropDownInitialize()
end

--Creates the options frame and all its assets

function Portals:CreateOptionsUI()
	local Options = {
		AddonName = "BrokerPortals",
		TitleText = "Broker Portals Settings",
		{
		Name = "Broker Poratls",
		Left = {
			{
				Type = "CheckButton",
				Name = "hideMenu",
				Lable = "Hide Standalone Button",
				OnClick = 	function()
					if self.db.hideMenu then
						self.standaloneButton:Show()
						self.db.hideMenu = false
					else
						self.standaloneButton:Hide()
						self.db.hideMenu = true
					end
				end
			},
			{
				Type = "CheckButton",
				Name = "enableAutoHide",
				Lable = "Only Show Standalone Button on Hover",
				OnClick = function()
					self.db.enableAutoHide = not self.db.enableAutoHide
					self:ToggleMainButton(self.db.enableAutoHide)
				end
			},
			{
				Type = "CheckButton",
				Name = "autoMenu",
				Lable = "Open menu on mouse over",
				OnClick = function() self.db.autoMenu = not self.db.autoMenu end
			},
			{
				Type = "CheckButton",
				Name = "showItems",
				Lable = L['SHOW_ITEMS'],
				OnClick = function() self.db.showItems = not self.db.showItems end
			},
			{
				Type = "CheckButton",
				Name = "showItemCooldowns",
				Lable = L['SHOW_ITEM_COOLDOWNS'],
				OnClick = function() self.db.showItemCooldowns = not self.db.showItemCooldowns end
			},
			{
				Type = "CheckButton",
				Name = "announce",
				Lable = L['ANNOUNCE'],
				OnClick = function() self.db.announce = not self.db.announce end
			},
			{
				Type = "Menu",
				Name = "announce",
				Lable = "Show Announce in",
				Menu = {{"Say", "SAY"}, {"Yell", "YELL"}, {"|cff00ffffParty|r/|cffff7f00Raid", "PARTYRAID"}}
			},
			{
				Type = "CheckButton",
				Name = "showPortals",
				Lable = "Show portals only in Party/Raid",
				OnClick = function() self.db.showPortals = not self.db.showPortals end
			},
			{
				Type = "CheckButton",
				Name = "swapPortals",
				Lable = "Swap teleport to portal spells in Party/Raid",
				OnClick = function() self.db.swapPortals = not self.db.swapPortals end
			},
			{
				Type = "CheckButton",
				Name = "stonesSubMenu",
				Lable = "Show Stones Of Retreats As Menus",
				OnClick = function() self.db.stonesSubMenu = not self.db.stonesSubMenu end
			},
			{
				Type = "CheckButton",
				Name = "showEnemy",
				Lable = "Show enemy faction Stones of Retreats",
				OnClick = function() self.db.showEnemy = not self.db.showEnemy end
			},
			{
				Type = "CheckButton",
				Name = "selfCast",
				Lable = "Cast placeable items/spells on self",
				OnClick = function() self.db.selfCast = not self.db.selfCast end
			},
			{
				Type = "CheckButton",
				Name = "showStonesZone",
				Lable = "Show stone of retreat zones",
				OnClick = function() self.db.showStonesZone = not self.db.showStonesZone end
			},
		},
		Right = {
			{
				Type = "CheckButton",
				Name = "deleteItem",
				Lable = "Delete vanity items after summoning",
				OnClick = function() self.db.deleteItem = not self.db.deleteItem end
			},
			{
				Type = "CheckButton",
				Name = "minimap",
				Lable = "Hide minimap icon",
				OnClick = function()
					self:ToggleMinimap()
				end
			},
			{
				Type = "Menu",
				Name = "txtSize",
				Lable = "Menu text size"
			},
			{
				Type = "Menu",
				Name = "ProfileSelect",
				Lable = "Profile selection",
			},
			{
				Type = "Button",
				Name = "ProfileAdd",
				Lable = "Add Profile",
				Size = {100,25},
				OnClick = function() StaticPopup_Show("BROKER_PORTALS_ADD_PROFILE") end
			},
			{
				Type = "Button",
				Position = "Right",
				Name = "ProfileDelete",
				Lable = "Delete Profile",
				Size = {100,25},
				OnClick = function()
					StaticPopupDialogs.BROKER_PORTALS_DELETE_PROFILE.profile = self.activeProfile
					StaticPopup_Show("BROKER_PORTALS_DELETE_PROFILE")
				end
			},
			{
				Type = "Slider",
				Name = "buttonScale",
				Lable = "Standalone Button Scale",
				MinMax = {0.25, 1.5},
				Step = 0.01,
				Size = {240,16},
				OnShow = function() self.options.buttonScale:SetValue(self.db.buttonScale or 1) end,
				OnValueChanged = function()
					self.db.buttonScale = self.options.buttonScale:GetValue()
					if self.standaloneButton then
						self.standaloneButton:SetScale(self.db.buttonScale)
					end
				end
			}
		}
		}
	}
	self.options = self:CreateOptionsPages(Options, PortalsDB)
	self.options.discordLink = CreateFrame("Button", "BrokerPortalsOptionsDiscordLink", BrokerPortalsOptionsFrame)
	self.options.discordLink:SetPoint("BOTTOMLEFT", 15, 15)
	self.options.discordLink.Lable = self.options.discordLink:CreateFontString(nil , "BORDER", "GameFontNormal")
	self.options.discordLink.Lable:SetJustifyH("LEFT")
	self.options.discordLink.Lable:SetPoint("LEFT", self.options.discordLink, 0, 0)
	self.options.discordLink.Lable:SetText("For Help or suggestions come join us on Discord\nhttps://discord.gg/j7eebTK5Q3"..WHITE.." (Click to copy link)")
	self.options.discordLink:SetScript("OnClick", function()
		Internal_CopyToClipboard("https://discord.gg/bgsqskycPd")
		DEFAULT_CHAT_FRAME:AddMessage("Discord link copyed to clipboard")
	end)
	self.options.discordLink:SetSize(self.options.discordLink.Lable:GetStringWidth(), self.options.discordLink.Lable:GetStringHeight())

end

function BrokerPortals_Options_Profile_Select_Initialize()
	local i, info, selected = 1
	for name, _ in pairs(Portals.db.favorites) do
		if name == Portals.db.setProfile[GetRealmName()][UnitName("player")] then
			selected = i
		end
		i = i + 1
		info = {
			text = name;
			func = function()
				local thisID = this:GetID();
				UIDropDownMenu_SetSelectedID(BrokerPortalsOptionsProfileSelectMenu, thisID)
				Portals.activeProfile = name
				Portals.favoritesdb = Portals.db.favorites[Portals.activeProfile]
				Portals.db.setProfile[GetRealmName()][UnitName("player")] = Portals.activeProfile
			end;
		}
			UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetWidth(BrokerPortalsOptionsProfileSelectMenu, 150)
	UIDropDownMenu_SetSelectedID(BrokerPortalsOptionsProfileSelectMenu, selected)
end

function BrokerPortals_Options_Menu_Initialize()
	local info
	for i = 10, 25 do
		info = {
			text = i;
			func = function() 
				Portals.db.txtSize = i
				local thisID = this:GetID();
				UIDropDownMenu_SetSelectedID(BrokerPortalsOptionstxtSizeMenu, thisID)
			end;
		}
			UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetWidth(BrokerPortalsOptionstxtSizeMenu, 150)
	UIDropDownMenu_SetSelectedID(BrokerPortalsOptionstxtSizeMenu, Portals.db.txtSize - 9)
end

function BrokerPortals_Options_Announce_Initialize()
	local info, selected
	for i, announceType in ipairs(BrokerPortalsOptionsannounceMenu.Menu) do
		if (Portals.db.announceType == announceType[2]) then
			selected =  i
		end
		info = {
			text = announceType[1];
			func = function()
				local thisID = this:GetID();
				selected = thisID
				UIDropDownMenu_SetSelectedID(BrokerPortalsOptionsannounceMenu, thisID)
				Portals.db.announceType = announceType[2]
			end;
		}
			UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetWidth(BrokerPortalsOptionsannounceMenu, 150)
	UIDropDownMenu_SetSelectedID(BrokerPortalsOptionsannounceMenu, selected)
end

function BrokerPortals_DropDownInitialize()
	--Setup for Dropdown menus in the settings
	UIDropDownMenu_Initialize(BrokerPortalsOptionstxtSizeMenu, BrokerPortals_Options_Menu_Initialize)
	UIDropDownMenu_Initialize(BrokerPortalsOptionsProfileSelectMenu, BrokerPortals_Options_Profile_Select_Initialize)
	UIDropDownMenu_Initialize(BrokerPortalsOptionsannounceMenu, BrokerPortals_Options_Announce_Initialize)
end

--Hook interface frame show to update options data
InterfaceOptionsFrame:HookScript("OnShow", function()
	if InterfaceOptionsFrame and BrokerPortalsOptionsFrame:IsVisible() then
		BrokerPortals_OpenOptions()
	end
end)

StaticPopupDialogs["BROKER_PORTALS_ADD_PROFILE"] = {
	text = "Add New Profile",
	button1 = "Confirm",
	button2 = "Cancel",
	hasEditBox = true,
	OnShow = function(self)
	self:SetFrameStrata("TOOLTIP");
  end,
	OnAccept = function (self)
		local text = self.editBox:GetText()
		if text ~= "" then
		  Portals.db.favorites[text] = {}
		  self.activeProfile = text
		  Portals.favoritesdb = Portals.db.favorites[self.activeProfile]
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	enterClicksFirstButton = true,
  }
  
  StaticPopupDialogs["BROKER_PORTALS_DELETE_PROFILE"] = {
	text = "Delete Profile?",
	button1 = "Confirm",
	button2 = "Cancel",
	OnShow = function(self)
	self:SetFrameStrata("TOOLTIP");
	end,
	OnAccept = function (self)
	  local profile = StaticPopupDialogs.BROKER_PORTALS_DELETE_PROFILE.profile
	  if self.activeProfile == profile then
		self.activeProfile = "Default"
		Portals.favoritesdb = Portals.db.favorites[self.activeProfile]
	  end
	  Portals.db.favorites[profile] = nil
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	enterClicksFirstButton = true,
  }