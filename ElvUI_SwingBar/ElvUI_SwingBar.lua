local addonName = ...;
local E, L, V, P, G, _ = unpack(ElvUI);
local EP = LibStub("LibElvUIPlugin-1.0");
local SB = E:NewModule("SwingBar", "AceHook-3.0");
local UF = E:GetModule("UnitFrames");

P.unitframe.units.player.swingbar = {
	enable = false,
	width = 270,
	height = 18,
	color = { r = .31, g = .31, b = .31 }
};

local function getOptions()
	E.Options.args.unitframe.args.player.args.swing = {
		order = 2000,
		type = "group",
		name = L["SwingBar"],
		get = function(info) return E.db.unitframe.units.player.swingbar[ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units.player.swingbar[ info[#info] ] = value; UF:CreateAndUpdateUF("player"); end,
		args = {
			enable = {
				type = "toggle",
				order = 1,
				name = L["Enable"],
			},
			width = {
				order = 5,
				name = L["Width"],
				type = "range",
				min = 50, max = 600, step = 1,
			},
			height = {
				order = 6,
				name = L["Height"],
				type = "range",
				min = 10, max = 85, step = 1
			},
			color = {
				order = 1,
				name = L["Color"],
				type = "color",
				get = function(info)
					local t = E.db.unitframe.units.player.swingbar[ info[#info] ];
					local d = P.unitframe.units.player.swingbar[ info[#info] ];
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b;
				end,
				set = function(info, r, g, b)
					local t = E.db.unitframe.units.player.swingbar[ info[#info] ]
					t.r, t.g, t.b = r, g, b
					UF:CreateAndUpdateUF("player");
				end,	
			}
		}
	}
end

function UF:Construct_Swingbar(frame)
	local swingbar = CreateFrame("StatusBar", nil, frame);
	UF["statusbars"][swingbar] = true;
	
	swingbar:SetClampedToScreen(true);
	swingbar:CreateBackdrop("Default");
	
	local holder = CreateFrame("Frame", nil, swingbar);
	swingbar.Holder = holder;
	
	holder:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -36);
	swingbar:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -E.Border, E.Border);
	
	E:CreateMover(holder, self:GetName().."CastbarMover", "Player SwingBar", nil, -6, nil, "ALL,SOLO");
	
	return swingbar;
end

function SB:Initialize()
	EP:RegisterPlugin(addonName, getOptions);
	
	if(ElvUF_Player) then
		ElvUF_Player.Swing = UF:Construct_Swingbar(ElvUF_Player);
		
		self:SecureHook(UF, "Update_PlayerFrame", function(self, frame, db)
			local swingbar = frame.Swing;
			
			swingbar:Width(db.swingbar.width - (E.Border * 2));
			swingbar:Height(db.swingbar.height);
			swingbar.Holder:Width(db.swingbar.width);
			swingbar.Holder:Height(db.swingbar.height + (E.PixelMode and 2 or (E.Border * 2)));
			swingbar.Holder:GetScript("OnSizeChanged")(swingbar.Holder);
			
			swingbar:SetStatusBarColor(db.swingbar.color.r, db.swingbar.color.g, db.swingbar.color.b);
			
			if(db.swingbar.enable and not frame:IsElementEnabled("Swing")) then
				frame:EnableElement("Swing");
			elseif(not db.swingbar.enable and frame:IsElementEnabled("Swing")) then
				frame:DisableElement("Swing");
			end
		end);
	end
end

E:RegisterModule(SB:GetName());