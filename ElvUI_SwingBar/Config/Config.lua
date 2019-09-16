local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale or "enUS")
local SB = E:GetModule("SwingBar")
local UF = E:GetModule("UnitFrames")

local positionValues = {
	TOP = L["Top"],
	LEFT = L["Left"],
	RIGHT = L["Right"],
	CENTER = L["Center"],
	BOTTOM = L["Bottom"],
	TOPLEFT = L["Top Left"],
	TOPRIGHT = L["Top Right"],
	BOTTOMLEFT = L["Bottom Left"],
	BOTTOMRIGHT = L["Bottom Right"]
}

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function SB:InsertOptions()
	local ACD = E.Libs.AceConfigDialog

	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cff1784d1E|r|cffe5e3e3lvUI |r|cff1784d1P|r|cffe5e3e3lugins|r",
			args = {
				header = {
					order = 0,
					type = "header",
					name = "|cff1784d1E|r|cffe5e3e3lvUI |r|cff1784d1P|r|cffe5e3e3lugins|r"
				},
				swingBarShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["Swing Bar"]),
					func = function()
						if IsAddOnLoaded("ElvUI_OptionsUI") then
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "swing")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.swingBarShortcut then
		E.Options.args.elvuiPlugins.args.swingBarShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["Swing Bar"]),
			func = function()
				if IsAddOnLoaded("ElvUI_OptionsUI") then
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "swing")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.swing = {
		type = "group",
		name = ColorizeSettingName(L["Swing Bar"]),
		get = function(info) return E.db.unitframe.units.player.swingbar[info[#info]] end,
		set = function(info, value) E.db.unitframe.units.player.swingbar[info[#info]] = value UF:CreateAndUpdateUF("player") end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Swing Bar"]
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["ENABLE"]
			},
			restore = {
				order = 3,
				type = "execute",
				name = L["Restore Defaults"],
				buttonElvUI = true,
				func = function() E:CopyTable(E.db.unitframe.units.player.swingbar, P.unitframe.units.player.swingbar) E:ResetMovers(L["Player SwingBar"]) UF:CreateAndUpdateUF("player") end,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			spacer = {
				order = 4,
				type = "description",
				name = " "
			},
			width = {
				order = 5,
				type = "range",
				name = L["Width"],
				min = 50, max = 600, step = 1,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			height = {
				order = 6,
				type = "range",
				name = L["Height"],
				min = 5, max = 85, step = 1,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			spark = {
				order = 7,
				type = "toggle",
				name = L["Spark"],
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			spacer2 = {
				order = 8,
				type = "description",
				name = " "
			},
			color = {
				order = 9,
				type = "color",
				name = L["COLOR"],
				get = function(info)
					local t = E.db.unitframe.units.player.swingbar[info[#info]]
					local d = P.unitframe.units.player.swingbar[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					local t = E.db.unitframe.units.player.swingbar[info[#info]]
					t.r, t.g, t.b = r, g, b
					UF:CreateAndUpdateUF("player")
				end,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			backdropColor = {
				order = 10,
				type = "color",
				name = L["Backdrop Color"],
				get = function(info)
					local t = E.db.unitframe.units.player.swingbar[info[#info]]
					local d = P.unitframe.units.player.swingbar[info[#info]]
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					local t = E.db.unitframe.units.player.swingbar[info[#info]]
					t.r, t.g, t.b = r, g, b
					UF:CreateAndUpdateUF("player")
				end,
				disabled = function() return not E.db.unitframe.units.player.swingbar.enable end
			},
			textGroup = {
				order = 11,
				type = "group",
				name = L["Text"],
				guiInline = true,
				get = function(info) return E.db.unitframe.units.player.swingbar.text[info[#info]] end,
				set = function(info, value) E.db.unitframe.units.player.swingbar.text[info[#info]] = value UF:CreateAndUpdateUF("player") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["ENABLE"],
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
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					},
					xOffset = {
						order = 4,
						type = "range",
						name = L["X-Offset"],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					},
					yOffset = {
						order = 5,
						type = "range",
						name = L["Y-Offset"],
						min = -300, max = 300, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					},
					color = {
						order = 6,
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
					},
					font = {
						order = 7,
						type = "select", dialogControl = "LSM30_Font",
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					},
					fontSize = {
						order = 8,
						type = "range",
						name = L["FONT_SIZE"],
						min = 6, max = 32, step = 1,
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					},
					fontOutline = {
						order = 9,
						type = "select",
						name = L["Font Outline"],
						desc = L["Set the font outline."],
						values = {
							["NONE"] = L["NONE"],
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE"
						},
						disabled = function() return not E.db.unitframe.units.player.swingbar.text.enable or not E.db.unitframe.units.player.swingbar.enable end
					}
				}
			}
		}
	}
end