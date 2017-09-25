local addonName = ...
local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local SB = E:NewModule("SwingBar")
local UF = E:GetModule("UnitFrames")

P.unitframe.units.player.swingbar = {
	enable = true,
	width = 270,
	height = 18,
	color = {r = .31, g = .31, b = .31},

	text = {
		enable = true,
		position = "CENTER",
		xOffset = 0,
		yOffset = 0,
		font = "Homespun",
		fontSize = 10,
		fontOutline = "MONOCHROMEOUTLINE"
	}
}

local positionValues = {
	TOPLEFT = "TOPLEFT",
	LEFT = "LEFT",
	BOTTOMLEFT = "BOTTOMLEFT",
	RIGHT = "RIGHT",
	TOPRIGHT = "TOPRIGHT",
	BOTTOMRIGHT = "BOTTOMRIGHT",
	CENTER = "CENTER",
	TOP = "TOP",
	BOTTOM = "BOTTOM",
}

local function getOptions()
	E.Options.args.unitframe.args.player.args.swing = {
		order = 2000,
		type = "group",
		name = L["SwingBar"],
		get = function(info) return E.db.unitframe.units.player.swingbar[ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units.player.swingbar[ info[#info] ] = value UF:CreateAndUpdateUF("player") end,
		args = {
			enable = {
				type = "toggle",
				order = 1,
				name = L["Enable"],
			},
			width = {
				order = 2,
				name = L["Width"],
				type = "range",
				min = 50, max = 600, step = 1,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			height = {
				order = 3,
				name = L["Height"],
				type = "range",
				min = 10, max = 85, step = 1,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			color = {
				order = 4,
				name = L["Color"],
				type = "color",
				get = function(info)
					local t = E.db.unitframe.units.player.swingbar[ info[#info] ]
					local d = P.unitframe.units.player.swingbar[ info[#info] ]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					local t = E.db.unitframe.units.player.swingbar[ info[#info] ]
					t.r, t.g, t.b = r, g, b
					UF:CreateAndUpdateUF("player")
				end,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			textGroup = {
				order = 300,
				type = "group",
				name = L["Text"],
				guiInline = true,
				get = function(info) return E.db.unitframe.units.player.swingbar.text[ info[#info] ] end,
				set = function(info, value) E.db.unitframe.units.player.swingbar.text[ info[#info] ] = value UF:CreateAndUpdateUF("player") end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
					},
					position = {
						type = "select",
						order = 2,
						name = L["Text Position"],
						values = positionValues,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					xOffset = {
						order = 3,
						type = "range",
						name = L["Text xOffset"],
						desc = L["Offset position for text."],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					yOffset = {
						order = 4,
						type = "range",
						name = L["Text yOffset"],
						desc = L["Offset position for text."],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					font = {
						type = "select", dialogControl = "LSM30_Font",
						order = 5,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					fontSize = {
						order = 6,
						name = L["Font Size"],
						type = "range",
						min = 6, max = 32, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					fontOutline = {
						order = 7,
						name = L["Font Outline"],
						desc = L["Set the font outline."],
						type = "select",
						values = {
							["NONE"] = L["None"],
							["OUTLINE"] = "OUTLINE",
							["MONOCHROME"] = (not E.isMacClient) and "MONOCHROME" or nil,
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE"
						},
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					}
				}
			}
		}
	}
end

function UF:Construct_Swingbar(frame)
	local swingbar = CreateFrame("StatusBar", nil, frame)
	UF["statusbars"][swingbar] = true

	swingbar:SetClampedToScreen(true)
	swingbar:CreateBackdrop("Default")

	swingbar.Text = swingbar:CreateFontString(nil, "OVERLAY")

	local holder = CreateFrame("Frame", nil, swingbar)
	swingbar.Holder = holder

	holder:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -36)
	swingbar:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -E.Border, E.Border)

	E:CreateMover(holder, frame:GetName() .. "SwingBarMover", "Player SwingBar", nil, -6, nil, "ALL,SOLO")

	return swingbar
end

function UF:Configure_Swingbar(frame)
	local db = frame.db
	local swingbar = frame.Swing

	swingbar:Width(db.swingbar.width - (E.Border * 2))
	swingbar:Height(db.swingbar.height)
	swingbar.Holder:Width(db.swingbar.width)
	swingbar.Holder:Height(db.swingbar.height + (E.PixelMode and 2 or (E.Border * 2)))
	if(swingbar.Holder:GetScript("OnSizeChanged")) then
		swingbar.Holder:GetScript("OnSizeChanged")(swingbar.Holder)
	end

	swingbar:SetStatusBarColor(db.swingbar.color.r, db.swingbar.color.g, db.swingbar.color.b)

	if(swingbar.Text) then
		if(db.swingbar.text.enable) then
			swingbar.Text:Show()
			swingbar.Text:FontTemplate(UF.LSM:Fetch("font", db.swingbar.text.font), db.swingbar.text.fontSize, db.swingbar.text.fontOutline)
			local x, y = self:GetPositionOffset(db.swingbar.text.position)
			swingbar.Text:ClearAllPoints()
			swingbar.Text:Point(db.swingbar.text.position, swingbar, db.swingbar.text.position, x + db.swingbar.text.xOffset, y + db.swingbar.text.yOffset)
		else
			swingbar.Text:Hide()
		end
	end

	if(db.swingbar.enable) then
		frame:EnableElement("Swing")
		E:EnableMover(frame:GetName() .. "SwingBarMover")
	elseif(not db.swingbar.enable) then
		frame:DisableElement("Swing")
		E:DisableMover(frame:GetName() .. "SwingBarMover")
		swingbar:Hide()
	end
end

function SB:Initialize()
	EP:RegisterPlugin(addonName, getOptions)

	ElvUF_Player.Swing = UF:Construct_Swingbar(ElvUF_Player)
	hooksecurefunc(UF, "Update_PlayerFrame", function(self, frame, db)
		UF:Configure_Swingbar(frame)
	end)
end

E:RegisterModule(SB:GetName())