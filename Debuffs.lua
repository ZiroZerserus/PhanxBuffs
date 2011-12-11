--[[--------------------------------------------------------------------
	PhanxBuffs
	Replacement player buff, debuff, and temporary enchant frames.
	Written by Phanx <addons@phanx.net>
	Copyright © 2010–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info16874-PhanxBuffs.html
	http://wow.curse.com/downloads/wow-addons/details/phanxbuffs.aspx
----------------------------------------------------------------------]]

local PhanxDebuffFrame = CreateFrame("Frame", "PhanxDebuffFrame", UIParent)

local db
local ignore

local debuffs = { }
local debuffUnit = "player"

local DebuffTypeColor = {
	["Magic"]	= { 0.2, 0.6, 1 },
	["Curse"]	= { 0.6, 0.0, 1 },
	["Disease"]	= { 0.6, 0.4, 0 },
	["Poison"]	= { 0.0, 0.6, 0 },
}

local GetDispelMacro
do
	local _, class = UnitClass("player")
	if class == "DRUID" then
		local macro = "/cast [@player] " .. (GetSpellInfo(2782)) -- Remove Corruption
		GetDispelMacro = function(kind)
			if kind == "CURSE" or kind == "POISON" or (kind == "MAGIC" and select(5, GetTalentInfo(3, 17)) > 0) then
				return macro
			end
		end
	elseif class == "MAGE" then
		local macro = "/cast [@player] " .. (GetSpellInfo(475)) -- Remove Curse
		GetDispelMacro = function(kind)
			if kind == "CURSE" then
				return macro
			end
		end
	elseif class == "PALADIN" then
		local macro = "/cast [@player] " .. (GetSpellInfo(4987)) -- Cleanse
		GetDispelMacro = function(kind)
			if kind == "DISEASE" or kind == "POISON" or (kind == "MAGIC" and select(5, GetTalentInfo(1, 14)) > 0) then
				return macro
			end
		end
	elseif class == "PRIEST" then
		local macro1 = "/cast [@player] " .. (GetSpellInfo(528)) -- Cure Disease
		local macro2 = "/cast [@player] " .. (GetSpellInfo(527)) -- Dispel Magic
		GetDispelMacro = function(kind)
			if kind == "DISEASE" then
				return macro1
			elseif kind == "MAGIC" then
				return macro2
			end
		end
	elseif class == "SHAMAN" then
		local macro = "/cast [@player] " .. (GetSpellInfo(51886)) -- Cleanse Spirit
		GetDispelMacro = function(kind)
			if kind == "CURSE" or (kind == "MAGIC" and select(5, GetTalentInfo(3, 12)) > 0) then
				return macro
			end
		end
	end
end

local _, ns = ...
local GetFontFile = ns.GetFontFile

------------------------------------------------------------------------

local function button_OnEnter(self)
	local debuff = debuffs[self:GetID()]
	if not debuff then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetUnitAura(debuffUnit, debuff.index, "HARMFUL")
end

local function button_OnLeave()
	GameTooltip:Hide()
end

local function button_OnClick(self)
	local debuff = debuffs[self:GetID()]
	if not debuff then return end

	if IsAltKeyDown() and IsShiftKeyDown() then
		ignore[debuff.name] = true
		print("|cffffcc00PhanxBuffs:|r", string.format(ns.L["Now ignoring debuff:"], debuff.name))
		self:GetParent():Update()
	elseif not InCombatLockdown() then
		local macro = GetDispelMacro and GetDispelMacro(debuff.kind)
		if macro then
			PhanxBuffsCancelButton:SetMacro(self, debuff.icon, macro)
		end
	end
end

local function button_SetBorderColor(self, ...)
	return self.border:SetVertexColor(...)
end

local buttons = setmetatable({ }, { __index = function(t, i)
	local button = CreateFrame("Button", nil, PhanxDebuffFrame)
	button:SetID(i)
	button:SetWidth(db.debuffSize)
	button:SetHeight(db.debuffSize)
	button:Show()

	button:EnableMouse(true)
	button:SetScript("OnEnter", button_OnEnter)
	button:SetScript("OnLeave", button_OnLeave)

	button:RegisterForClicks("RightButtonUp")
	button:SetScript("OnClick", button_OnClick)

	button.icon = button:CreateTexture(nil, "BACKGROUND")
	button.icon:SetAllPoints(button)

	button.count = button:CreateFontString(nil, "OVERLAY")
    button.count:SetPoint("CENTER", button, "TOP")
    button.count:SetShadowOffset(1, -1)

	button.timer = button:CreateFontString(nil, "OVERLAY")
	button.timer:SetPoint("TOP", button, "BOTTOM")
    button.timer:SetShadowOffset(1, -1)

	button.symbol = button:CreateFontString(nil, "OVERLAY")
	button.symbol:SetPoint("BOTTOMLEFT", button, 1, 0)
    button.symbol:SetShadowOffset(1, -1)

	if PhanxBorder then
		PhanxBorder.AddBorder(button)
		button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	else
		button.border = button:CreateTexture(nil, "BORDER")
		button.border:SetPoint("TOPLEFT", button, -3, 2)
		button.border:SetPoint("BOTTOMRIGHT", button, 2, -2)
		button.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		button.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		button.SetBorderColor = button_SetBorderColor
	end

	t[i] = button

	PhanxDebuffFrame:UpdateLayout()

	return button
end })

PhanxDebuffFrame.buttons = buttons

------------------------------------------------------------------------

function PhanxDebuffFrame:UpdateLayout()
	local anchor = db.growthAnchor
	local size = db.debuffSize
	local spacing = db.iconSpacing
	local cols = db.debuffColumns

	local fontFace = GetFontFile(db.fontFace)
	local fontScale = db.fontScale
	local fontOutline = db.fontOutline

	for i, button in ipairs(buttons) do
		local col = (i - 1) % cols
		local row = math.ceil(i / cols) - 1

		local x = col * (spacing + size) * (anchor == "LEFT" and 1 or -1)
		local y = row * (spacing + (size * 1.5))

		button:ClearAllPoints()
		button:SetWidth(size)
		button:SetHeight(size)
		button:SetPoint("TOP" .. anchor, self, "TOP" .. anchor, x, -y)
		
		button.count:SetFont(fontFace, 18 * fontScale, fontOutline)
		button.timer:SetFont(fontFace, 14 * fontScale, fontOutline)
		button.symbol:SetFont(fontFace, 16 * fontScale, fontOutline)
	end

	self:ClearAllPoints()
	if db.debuffPoint and db.debuffX and db.debuffY then
		self:SetPoint(db.debuffPoint, UIParent, db.debuffX, db.debuffY)
	else
		self:SetPoint("BOTTOMRIGHT", UIParent, -70 - Minimap:GetWidth(), UIParent:GetHeight() - Minimap:GetHeight() - 62)
	end
	self:SetWidth((size * cols) + (spacing * (cols - 1)))
	self:SetHeight(size)
end

------------------------------------------------------------------------

local function DebuffSort(a, b)
	if a.duration == 0 then
		if b.duration == 0 then
			-- both timeless, sort by name REVERSE
			return a.name < b.name
		else
			-- a timeless, b not
			return true
		end
	else
		if b.duration == 0 then
			-- b timeless, a not
			return false
		else
			-- neither timeless, sort by expiry time
			return a.expires > b.expires
		end
	end
end

------------------------------------------------------------------------

local tablePool = { }

local function newTable()
	local t = next(tablePool) or { }
	tablePool[t] = nil
	return t
end

local function remTable(t)
	if type(t) == "table" then
		for k, v in pairs(t) do
			t[k] = nil
		end
		t[true] = true
		t[true] = nil
		tablePool[t] = true
	end
	return nil
end

------------------------------------------------------------------------

function PhanxDebuffFrame:Update()
	for i, t in ipairs(debuffs) do
		debuffs[i] = remTable(t)
	end

	local i = 1
	while true do
		local name, _, icon, count, kind, duration, expires, caster, _, _, spellID = UnitAura(debuffUnit, i, "HARMFUL")
		if not icon or icon == "" then break end

		if not ignore[name] then
			local t = newTable()

			t.name = name
			t.icon = icon
			t.count = count
			t.kind = kind
			t.duration = duration or 0
			t.expires = expires
			t.caster = caster
			t.spellID = spellID
			t.index = i

			debuffs[#debuffs + 1] = t
		end

		i = i + 1
	end

	table.sort(debuffs, DebuffSort)

	for i, debuff in ipairs(debuffs) do
		local f = buttons[i]
		f.icon:SetTexture(debuff.icon)

		if debuff.count > 1 then
			f.count:SetText(debuff.count)
		else
			f.count:SetText()
		end

		local debuffTypeColor = DebuffTypeColor[debuff.kind]
		if debuffTypeColor then
			local r, g, b = unpack(debuffTypeColor)
			f:SetBorderColor(r, g, b, 1)
			if ENABLE_COLORBLIND_MODE == "1" then
				f.symbol:Show()
				f.symbol:SetText(DebuffTypeSymbol[debuff.kind])
			else
				f.symbol:Hide()
			end
		else
			f:SetBorderColor(1, 0, 0, 1)
			f.symbol:Hide()
		end

		f:Show()
	end

	if #buttons > #debuffs then
		for i = #debuffs + 1, #buttons do
			local f = buttons[i]
			f.icon:SetTexture()
			f.count:SetText()
			f:Hide()
		end
	end
end

------------------------------------------------------------------------

local dirty
local timerGroup = PhanxDebuffFrame:CreateAnimationGroup()
local timer = timerGroup:CreateAnimation()
timer:SetOrder(1)
timer:SetDuration(0.1) -- how often you want it to finish
-- timer:SetMaxFramerate(25) -- use this to throttle
timerGroup:SetScript("OnFinished", function(self, requested)
	if dirty then
		PhanxDebuffFrame:Update()
		dirty = false
	end
	local max = db.maxTimer
	for i, button in ipairs(buttons) do
		if not button:IsShown() then break end
		local debuff = debuffs[button:GetID()]
		if debuff then
			if debuff.expires > 0 then
				local remaining = debuff.expires - GetTime()
				if remaining < 0 then
					-- bugged out, kill it
					remTable( table.remove(debuffs, button:GetID()) )
					dirty = true
				elseif remaining <= max then
					if remaining > 3600 then
						button.timer:SetFormattedText( HOUR_ONELETTER_ABBR, floor( ( remaining / 60 ) + 0.5 ) )
					elseif remaining > 60 then
						button.timer:SetFormattedText( MINUTE_ONELETTER_ABBR, floor( ( remaining / 60 ) + 0.5 ) )
					else
						button.timer:SetText( floor( remaining + 0.5 ) )
					end
				else
					button.timer:SetText()
				end
			else
				button.timer:SetText()
			end
		end
	end
	self:Play() -- start it over again
end)

PhanxDebuffFrame:SetScript("OnEvent", function( self, event, unit )
	if event == "UNIT_AURA" then
		if unit == debuffUnit then
			dirty = true
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if ( UnitInVehicle( "player" ) and SecureCmdOptionParse( "[bonusbar:5]" ) ) then
			debuffUnit = "vehicle"
		else
			debuffUnit = "player"
		end
		dirty = true
	elseif event == "UNIT_ENTERED_VEHICLE" then
		if unit == "player" and SecureCmdOptionParse( "[bonusbar:5]" ) then
			debuffUnit = "vehicle"
			dirty = true
		end
	elseif event == "UNIT_EXITED_VEHICLE" then
		if unit == "player" then
			debuffUnit = "player"
			dirty = true
		end
	end
end)

------------------------------------------------------------------------

function PhanxDebuffFrame:Load()
	if db then return end

	db = PhanxBuffsDB
	ignore = PhanxBuffsIgnoreDB.debuffs

	dirty = true
	timerGroup:Play()

	self:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	self:RegisterEvent( "UNIT_ENTERING_VEHICLE" )
	self:RegisterEvent( "UNIT_EXITING_VEHICLE" )
	self:RegisterEvent( "UNIT_AURA" )
end