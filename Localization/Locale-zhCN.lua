--[[--------------------------------------------------------------------
	PhanxBuffs
	Replacement player buff, debuff, and temporary enchant frames.
	Copyright (c) 2010-2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info16874-PhanxBuffs.html
	http://www.curse.com/addons/wow/phanxbuffs
------------------------------------------------------------------------
	Simplified Chinese Localization (简体中文)
	Last updated 2011-10-20 by wowuicn
----------------------------------------------------------------------]]

if GetLocale() ~= "zhCN" then return end
local _, ns = ...
ns.L = {

-- Fake buff tooltip text

--	[105361] = "Melee attacks cause Holy damage.", -- Seal of Command
--	[20165] = "Improves casting speed by 10%.\nImproves healing by 5%.\nMelee attacks have a chance to heal.", -- Seal of Insight
--	[20154] = "Melee attacks cause Holy damage against all targets within 8 yards.", -- Seal of Righteousness
--	[31801] = "Melee attacks cause Holy damage over 15 sec.", -- Seal of Truth

-- Broker tooltip

--	["Click to lock or unlock the frames."] = "",
--	["Right-click for options."] = "",

-- Configuration panel

--	["Use this panel to adjust some basic settings for buff, debuff, and weapon buff icons."] = "",

	["Buff Size"] = "Buff 大小",
--	["Adjust the size of each buff icon."] = "",
--	["Buff Spacing"] = "",
--	["Adjust the space between buff icons."] = "",
	["Buff Columns"] = "Buff 栏",
--	["Adjust the number of buff icons to show on each row."] = "",
	["Buff Anchor"] = "Buff 增长锚点",
--	["Choose whether the buff icons grow from left to right, or right to left."] = "",
--	["Choose whether the buff icons grow from top to bottom, or bottom to top."] = "",

	["Debuff Size"] = "Debuff 大小",
--	["Adjust the size of each debuff icon."] = "",
--	["Debuff Spacing"] = "",
--	["Adjust the space between debuff icons."] = "",
	["Debuff Columns"] = "Debuff 栏",
--	["Adjust the number of debuff icons to show on each row."] = "",
	["Debuff Anchor"] = "Debuff 增长锚点",
--	["Choose whether the debuff icons grow from left to right, or right to left."] = "",
--	["Choose whether the debuff icons grow from top to bottom, or bottom to top."] = "",

--	["Top"] = "",
--	["Bottom"] = "",
	["Left"] = "左侧",
--	["Right"] = "",

--	["Typeface"] = "",
--	["Set the typeface for the stack count and timer text."] = "",
--	["Text Outline"] = "",
--	["Set the outline weight for the stack count and timer text."] = "",
--	["None"] = "",
--	["Thin"] = "",
--	["Thick"] = "",
--	["Text Size"] = "",
--	["Adjust the size of the stack count and timer text."] = ""

--	["Max Timer Duration"] = "",
--	["Adjust the maximum remaining duration, in seconds, to show the timer text for a buff or debuff."] = "",

--	["Show Stance Icons"] = "",
--	["Show fake buff icons for monk and warrior stances and paladin seals."] = "",
	["Buff Sources"] = "Buff 来源",
--	["Show the name of the party or raid member who cast a buff on you in its tooltip."] = "",
--	["Weapon Buff Sources"] = "",
--	["Show weapon buffs as the spell or item that buffed the weapon, instead of the weapon itself."] = "",
	["Lock Frames"] = "锁定框体",
--	["Lock the buff and debuff frames in place, hiding the backdrop and preventing them from being moved."] = "",

	["Cast by %s"] = "来自 %s",

-- Slash commands

--	["lock"] = "",
--	["unlock"] = "",
--	["buff"] = "buff",
--	["debuff"] = "debuff",
--	["Now ignoring buff: %s"] = "",
--	["Now ignoring debuff: %s"] = "",
--	["No longer ignoring buff: %s"] = "",
--	["No longer ignoring debuff: %s"] = "",
--	["No buffs are being ignored."] = "",
--	["No debuffs are being ignored."] = "",
--	["%d |4buff:buffs; |4is:are; being ignored:"] = "",
--	["%d |4debuff:debuffs; |4is:are; being ignored:"] = "",

}