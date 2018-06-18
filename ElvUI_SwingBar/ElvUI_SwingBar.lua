local E, L, V, P, G = unpack(ElvUI)
local SB = E:NewModule("SwingBar")
local UF = E:GetModule("UnitFrames")
local EP = LibStub("LibElvUIPlugin-1.0")
local addonName = ...

local NONE, FONT_SIZE, COLOR = NONE, FONT_SIZE, COLOR

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
		fontOutline = "MONOCHROMEOUTLINE",
		color = {r = 1, g = 1, b = 1}
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
	BOTTOM = "BOTTOM"
}

local function getOptions()
	E.Options.args.unitframe.args.player.args.swing = {
		order = 2000,
		type = "group",
		name = L["Swing Bar"],
		get = function(info) return E.db.unitframe.units.player.swingbar[ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units.player.swingbar[ info[#info] ] = value UF:CreateAndUpdateUF("player") end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Swing Bar"]
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"]
			},
			spacer = {
				order = 3,
				type = "description",
				name = " "
			},
			width = {
				order = 4,
				type = "range",
				name = L["Width"],
				min = 50, max = 600, step = 1,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			height = {
				order = 5,
				type = "range",
				name = L["Height"],
				min = 5, max = 85, step = 1,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			color = {
				order = 6,
				type = "color",
				name = COLOR,
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
				order = 7,
				type = "group",
				name = L["Text"],
				guiInline = true,
				get = function(info) return E.db.unitframe.units.player.swingbar.text[ info[#info] ] end,
				set = function(info, value) E.db.unitframe.units.player.swingbar.text[ info[#info] ] = value UF:CreateAndUpdateUF("player") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
					},
					spacer = {
						order = 2,
						type = "description",
						name = " "
					},
					position = {
						order = 3,
						type = "select",
						name = L["Text Position"],
						values = positionValues,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					xOffset = {
						order = 4,
						type = "range",
						name = L["Text xOffset"],
						desc = L["Offset position for text."],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					yOffset = {
						order = 5,
						type = "range",
						name = L["Text yOffset"],
						desc = L["Offset position for text."],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					font = {
						order = 6,
						type = "select", dialogControl = "LSM30_Font",
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					fontSize = {
						order = 6,
						type = "range",
						name = FONT_SIZE,
						min = 6, max = 32, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					fontOutline = {
						order = 7,
						type = "select",
						name = L["Font Outline"],
						desc = L["Set the font outline."],
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE"
						},
						disabled = function() return not E.db.unitframe.units.player.swingbar.enable or not E.db.unitframe.units.player.swingbar.text.enable end
					},
					color = {
						order = 9,
						type = "color",
						name = L["Text Color"],
						get = function(info)
							local t = E.db.unitframe.units.player.swingbar.text[info[#info]]
							local d = P.unitframe.units.player.swingbar.text[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							local t = E.db.unitframe.units.player.swingbar.text[info[#info]]
							t.r, t.g, t.b = r, g, b
							UF:CreateAndUpdateUF("player")
						end,
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					}
				}
			}
		}
	}
end

function UF:Construct_Swingbar(frame)
	local swingbar = CreateFrame("StatusBar", nil, frame)
	UF["statusbars"][swingbar] = true

	swingbar:CreateBackdrop("Default", nil, nil, self.thinBorders, true)
	swingbar:SetClampedToScreen(true)

	swingbar.Text = swingbar:CreateFontString(nil, "OVERLAY")

	local holder = CreateFrame("Frame", nil, swingbar)
	swingbar.Holder = holder

	holder:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -36)
	swingbar:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -E.Border, E.Border)

	E:CreateMover(holder, frame:GetName() .. "SwingBarMover", L["Player SwingBar"], nil, -6, nil, "ALL,SOLO")

	return swingbar
end

function UF:Configure_Swingbar(frame)
	local db = frame.db
	local swingbar = frame.Swing

	if db.swingbar.enable then
		if not frame:IsElementEnabled("Swing") then
			frame:EnableElement("Swing")
		end
		swingbar:Width(db.swingbar.width - (E.Border * 2))
		swingbar:Height(db.swingbar.height)
		swingbar.Holder:Width(db.swingbar.width)
		swingbar.Holder:Height(db.swingbar.height + (E.PixelMode and 2 or (E.Border * 2)))
		if swingbar.Holder:GetScript("OnSizeChanged") then
			swingbar.Holder:GetScript("OnSizeChanged")(swingbar.Holder)
		end

		swingbar:SetStatusBarColor(db.swingbar.color.r, db.swingbar.color.g, db.swingbar.color.b)

		local color = E.db.unitframe.colors.borderColor
		swingbar.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)

		color = db.swingbar.text.color
		if swingbar.Text then
			if db.swingbar.text.enable then
				swingbar.Text:Show()
				swingbar.Text:FontTemplate(UF.LSM:Fetch("font", db.swingbar.text.font), db.swingbar.text.fontSize, db.swingbar.text.fontOutline)
				local x, y = self:GetPositionOffset(db.swingbar.text.position)
				swingbar.Text:ClearAllPoints()
				swingbar.Text:Point(db.swingbar.text.position, swingbar, db.swingbar.text.position, x + db.swingbar.text.xOffset, y + db.swingbar.text.yOffset)
				swingbar.Text:SetTextColor(color.r, color.g, color.b)
			else
				swingbar.Text:Hide()
			end
		end

		E:EnableMover(frame:GetName().."SwingBarMover")
	elseif frame:IsElementEnabled("Swing") then
		frame:DisableElement("Swing")

		swingbar:Hide()
		E:DisableMover(frame:GetName().."SwingBarMover")
	end
end

function SB:Initialize()
	EP:RegisterPlugin(addonName, getOptions)

	ElvUF_Player.Swing = UF:Construct_Swingbar(ElvUF_Player)
	hooksecurefunc(UF, "Update_PlayerFrame", function(self, frame, db)
		UF:Configure_Swingbar(frame)
	end)
end

local function InitializeCallback()
	SB:Initialize()
end

E:RegisterModule(SB:GetName(), InitializeCallback)