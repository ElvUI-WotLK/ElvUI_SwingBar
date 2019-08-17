local E, L, V, P, G = unpack(ElvUI)
local SB = E:NewModule("SwingBar")
local UF = E:GetModule("UnitFrames")
local EP = E.Libs.EP

local addonName = ...

function UF:Construct_Swingbar(frame)
	local swingbar = CreateFrame("Frame", frame:GetName().."SwingBar", frame)
	swingbar:SetFrameLevel(frame.RaisedElementParent:GetFrameLevel() + 30)
	swingbar:SetClampedToScreen(true)

	swingbar.Twohand = CreateFrame("StatusBar", frame:GetName().."SwingBar_Twohand", swingbar)
	UF.statusbars[swingbar.Twohand] = true
	swingbar.Twohand:CreateBackdrop("Default", nil, nil, self.thinBorders, true)
	swingbar.Twohand:Point("TOPLEFT", swingbar, "TOPLEFT", 0, 0)
	swingbar.Twohand:Point("BOTTOMRIGHT", swingbar, "BOTTOMRIGHT", 0, 0)
	swingbar.Twohand:Hide()

	swingbar.Mainhand = CreateFrame("StatusBar", frame:GetName().."SwingBar_Mainhand", swingbar)
	self.statusbars[swingbar.Mainhand] = true
	swingbar.Mainhand:CreateBackdrop("Default", nil, nil, self.thinBorders, true)
	swingbar.Mainhand:Point("TOPLEFT", swingbar, "TOPLEFT", 0, 0)
	swingbar.Mainhand:Point("BOTTOMRIGHT", swingbar, "RIGHT", 0, E.Border)
	swingbar.Mainhand:Hide()

	swingbar.Offhand = CreateFrame("StatusBar", frame:GetName().."SwingBar_Offhand", swingbar)
	self.statusbars[swingbar.Offhand] = true
	swingbar.Offhand:CreateBackdrop("Default", nil, nil, self.thinBorders, true)
	swingbar.Offhand:Point("TOPLEFT", swingbar, "LEFT", 0, 0)
	swingbar.Offhand:Point("BOTTOMRIGHT", swingbar, "BOTTOMRIGHT", 0, 0)
	swingbar.Offhand:Hide()

	swingbar.Text = swingbar:CreateFontString(nil, "OVERLAY")
	swingbar.TextMH = swingbar:CreateFontString(nil, "OVERLAY")
	swingbar.TextOH = swingbar:CreateFontString(nil, "OVERLAY")

	local holder = CreateFrame("Frame", nil, swingbar)
	swingbar.Holder = holder
	swingbar.Holder:Point("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -36)
	swingbar:Point("BOTTOMRIGHT", swingbar.Holder, "BOTTOMRIGHT", -E.Border, E.Border)

	E:CreateMover(holder, frame:GetName().."SwingBarMover", L["Player SwingBar"], nil, -6, nil, "ALL,SOLO", nil, "elvuiPlugins,swing")

	return swingbar
end

function UF:Configure_Swingbar(frame)
	local swingbar = frame.Swing
	local db = frame.db.swingbar

	if db.enable then
		if not frame:IsElementEnabled("Swing") then
			frame:EnableElement("Swing")
		end

		swingbar:Show()
		swingbar:Size(db.width - (E.Border * 2), db.height)

		swingbar.Holder:Size(db.width, db.height + (E.PixelMode and 2 or (E.Border * 2)))

		if swingbar.Holder:GetScript("OnSizeChanged") then
			swingbar.Holder:GetScript("OnSizeChanged")(swingbar.Holder)
		end

		local color = db.color
		swingbar.Twohand:SetStatusBarColor(color.r, color.g, color.b)
		swingbar.Mainhand:SetStatusBarColor(color.r, color.g, color.b)
		swingbar.Offhand:SetStatusBarColor(color.r, color.g, color.b)

		color = E.db.unitframe.colors.borderColor
		swingbar.Twohand.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		swingbar.Mainhand.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		swingbar.Offhand.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)

		local x, y = self:GetPositionOffset(db.text.position)
		local pos, xOff, yOff = db.text.position, x + db.text.xOffset, y + db.text.yOffset
		local font = UF.LSM:Fetch("font", db.text.font), db.text.fontSize, db.text.fontOutline
		color = db.text.color

		swingbar.Text:ClearAllPoints()
		swingbar.Text:Point(pos, swingbar.Twohand, pos, xOff, yOff)
		swingbar.Text:FontTemplate(font)
		swingbar.Text:SetTextColor(color.r, color.g, color.b)

		swingbar.TextMH:ClearAllPoints()
		swingbar.TextMH:Point(pos, swingbar.Mainhand, pos, xOff, yOff)
		swingbar.TextMH:FontTemplate(font)
		swingbar.TextMH:SetTextColor(color.r, color.g, color.b)

		swingbar.TextOH:ClearAllPoints()
		swingbar.TextOH:Point(pos, swingbar.Offhand, pos, xOff, yOff)
		swingbar.TextOH:FontTemplate(font)
		swingbar.TextOH:SetTextColor(color.r, color.g, color.b)

		if db.text.enable then
			swingbar.Text:Show()
			swingbar.TextMH:Show()
			swingbar.TextOH:Show()
		else
			swingbar.Text:Hide()
			swingbar.TextOH:Hide()
			swingbar.TextMH:Hide()
		end

		E:EnableMover(frame:GetName().."SwingBarMover")
	elseif frame:IsElementEnabled("Swing") then
		frame:DisableElement("Swing")

		swingbar:Hide()
		E:DisableMover(frame:GetName().."SwingBarMover")
	end
end

function SB:Initialize()
	EP:RegisterPlugin(addonName, self.InsertOptions)

	ElvUF_Player.Swing = UF:Construct_Swingbar(ElvUF_Player)
	hooksecurefunc(UF, "Update_PlayerFrame", function(_, frame)
		UF:Configure_Swingbar(frame)
	end)
end

local function InitializeCallback()
	SB:Initialize()
end

E:RegisterModule(SB:GetName(), InitializeCallback)