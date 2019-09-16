local _, ns = ...
local oUF = oUF or ns.oUF or ElvUF
if not oUF then return end

local unpack = unpack
local find = string.find

local GetInventoryItemID = GetInventoryItemID
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitAttackSpeed = UnitAttackSpeed
local UnitCastingInfo = UnitCastingInfo
local UnitRangedDamage = UnitRangedDamage

local MainhandID = GetInventoryItemID("player", 16)
local OffhandID = GetInventoryItemID("player", 17)
local RangedID = GetInventoryItemID("player", 18)

local melee, range, lastHit

local function SwingStopped(element)
	local bar = element.__owner

	if bar.Twohand:IsShown() then return end
	if bar.Mainhand:IsShown() then return end
	if bar.Offhand:IsShown() then return end

	bar:Hide()
end

local OnDurationUpdate
do
	local checkElapsed, slamElapsed, slamTime, now = 0, 0, 0
	local slam = GetSpellInfo(1464)

	function OnDurationUpdate(self, elapsed)
		now = GetTime()

		if melee then
			if checkElapsed > 0.02 then
				if lastHit + self.speed + slamTime < now then
					self:Hide()
					self:SetScript("OnUpdate", nil)
					SwingStopped(self)
					melee = false
					range = false
				end

				checkElapsed = 0
			else
				checkElapsed = checkElapsed + elapsed
			end
		end

		local spell = UnitCastingInfo("player")

		if slam == spell then
			slamElapsed = slamElapsed + elapsed
			slamTime = slamTime + elapsed
		else
			if slamElapsed ~= 0 then
				self.min = self.min + slamElapsed
				self.max = self.max + slamElapsed
				self:SetMinMaxValues(self.min, self.max)
				slamElapsed = 0
			end

			if now > self.max then
				if melee then
					if lastHit then
						self.min = self.max
						self.max = self.max + self.speed
						self:SetMinMaxValues(self.min, self.max)
						slamTime = 0
					end
				else
					self:Hide()
					self:SetScript("OnUpdate", nil)
					melee = false
					range = false
				end
			else
				self:SetValue(now)
				if self.Text then
					self.Text:SetFormattedText("%.1f", self.max - now)
				end
			end
		end
	end
end

local function MeleeChange(self, _, unit)
	if unit ~= "player" then return end
	if not melee then return end

	local element = self.Swing

	local NewMainhandID = GetInventoryItemID("player", 16)
	local NewOffhandID = GetInventoryItemID("player", 17)

	local now = GetTime()
	local mainHandSpeed, offHandSpeed = UnitAttackSpeed("player")

	if MainhandID ~= NewMainhandID or OffhandID ~= NewOffhandID then
		if offHandSpeed then
			element.Twohand:Hide()
			element.Twohand:SetScript("OnUpdate", nil)

			element.Mainhand.min = GetTime()
			element.Mainhand.max = element.Mainhand.min + mainHandSpeed
			element.Mainhand.speed = mainHandSpeed

			element.Mainhand:Show()
			element.Mainhand:SetMinMaxValues(element.Mainhand.min, element.Mainhand.max)
			element.Mainhand:SetScript("OnUpdate", OnDurationUpdate)

			element.Offhand.min = GetTime()
			element.Offhand.max = element.Offhand.min + offHandSpeed
			element.Offhand.speed = offHandSpeed

			element.Offhand:Show()
			element.Offhand:SetMinMaxValues(element.Offhand.min, element.Mainhand.max)
			element.Offhand:SetScript("OnUpdate", OnDurationUpdate)
		else
			element.Twohand.min = GetTime()
			element.Twohand.max = element.Twohand.min + mainHandSpeed
			element.Twohand.speed = mainHandSpeed

			element.Twohand:Show()
			element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
			element.Twohand:SetScript("OnUpdate", OnDurationUpdate)

			element.Mainhand:Hide()
			element.Mainhand:SetScript("OnUpdate", nil)

			element.Offhand:Hide()
			element.Offhand:SetScript("OnUpdate", nil)
		end

		lastHit = now

		MainhandID = NewMainhandID
		OffhandID = NewOffhandID
	else
		if offHandSpeed then
			if element.Mainhand.speed ~= mainHandSpeed then
				local percentage = (element.Mainhand.max - now) / (element.Mainhand.speed)
				element.Mainhand.min = now - mainHandSpeed * (1 - percentage)
				element.Mainhand.max = now + mainHandSpeed * percentage
				element.Mainhand:SetMinMaxValues(element.Mainhand.min, element.Mainhand.max)
				element.Mainhand.speed = mainHandSpeed
			end
			if element.Offhand.speed ~= offHandSpeed then
				local percentage = (element.Offhand.max - now) / (element.Offhand.speed)
				element.Offhand.min = now - offHandSpeed * (1 - percentage)
				element.Offhand.max = now + offHandSpeed * percentage
				element.Offhand:SetMinMaxValues(element.Offhand.min, element.Offhand.max)
				element.Offhand.speed = offHandSpeed
			end
		else
			if element.Twohand.speed ~= mainHandSpeed then
				local percentage = (element.Twohand.max - now) / (element.Twohand.speed)
				element.Twohand.min = now - mainHandSpeed * (1 - percentage)
				element.Twohand.max = now + mainHandSpeed * percentage
				element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
				element.Twohand.speed = mainHandSpeed
			end
		end
	end
end

local function RangedChange(self, _, unit)
	if unit ~= "player" then return end
	if not range then return end

	local element = self.Swing
	local NewRangedID = GetInventoryItemID("player", 18)

	if RangedID ~= NewRangedID then
		element.Twohand.speed = UnitRangedDamage(unit)
		element.Twohand.min = GetTime()
		element.Twohand.max = element.Twohand.min + element.Twohand.speed

		element.Twohand:Show()
		element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
		element.Twohand:SetScript("OnUpdate", OnDurationupdate)
	else
		local speed = UnitRangedDamage("player")
		local now = GetTime()

		if element.Twohand.speed ~= speed then
			local percentage = (element.Twohand.max - GetTime()) / (element.Twohand.speed)
			element.Twohand.min = now - speed * (1 - percentage)
			element.Twohand.max = now + speed * percentage
			element.Twohand.speed = speed
		end
	end
end

local function Ranged(self, _, unit, spellName)
	if unit ~= "player" then return end
	if spellName ~= GetSpellInfo(75) and spellName ~= GetSpellInfo(5019) then return end

	local element = self.Swing

	melee = false
	range = true

	element:Show()

	element.Twohand.speed = UnitRangedDamage(unit)
	element.Twohand.min = GetTime()
	element.Twohand.max = element.Twohand.min + element.Twohand.speed

	element.Twohand:Show()
	element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
	element.Twohand:SetScript("OnUpdate", OnDurationUpdate)

	element.Mainhand:Hide()
	element.Mainhand:SetScript("OnUpdate", nil)

	element.Offhand:Hide()
	element.Offhand:SetScript("OnUpdate", nil)
end

local function Melee(self, _, _, event, GUID, _, _, _, _, _, _, spellName)
	if UnitGUID("player") ~= GUID then return end
	if not find(event, "SWING") and not find(event, "SPELL_CAST_SUCCESS") then return end
	if find(event, "SPELL_CAST_SUCCESS") then
		if spellName ~= GetSpellInfo(30324) and spellName ~= GetSpellInfo(25231) and spellName ~= GetSpellInfo(27014) and spellName ~= GetSpellInfo(26996) then return end
	end

	local element = self.Swing

	if not melee then
		element:Show()

		element.Twohand:Hide()
		element.Twohand:SetScript("OnUpdate", nil)

		element.Mainhand:Hide()
		element.Mainhand:SetScript("OnUpdate", nil)

		element.Offhand:Hide()
		element.Offhand:SetScript("OnUpdate", nil)

		local mainHandSpeed, offHandSpeed = UnitAttackSpeed("player")

		if offHandSpeed then
			element.Mainhand.min = GetTime()
			element.Mainhand.max = element.Mainhand.min + mainHandSpeed
			element.Mainhand.speed = mainHandSpeed

			element.Mainhand:Show()
			element.Mainhand:SetMinMaxValues(element.Mainhand.min, element.Mainhand.max)
			element.Mainhand:SetScript("OnUpdate", OnDurationUpdate)

			element.Offhand.min = GetTime()
			element.Offhand.max = element.Offhand.min + offHandSpeed
			element.Offhand.speed = offHandSpeed

			element.Offhand:Show()
			element.Offhand:SetMinMaxValues(element.Offhand.min, element.Offhand.max)
			element.Offhand:SetScript("OnUpdate", OnDurationUpdate)
		else
			element.Twohand.min = GetTime()
			element.Twohand.max = element.Twohand.min + mainHandSpeed
			element.Twohand.speed = mainHandSpeed

			element.Twohand:Show()
			element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
			element.Twohand:SetScript("OnUpdate", OnDurationUpdate)
		end

		melee = true
		range = false
	end

	lastHit = GetTime()
end

local function ParryHaste(self, _, _, event, _, _, _, _, tarGUID, _, missType)
	if UnitGUID("player") ~= tarGUID then return end
	if not melee then return end
	if not find(event, "MISSED") then return end
	if missType ~= "PARRY" then return end

	local element = self.Swing
	local _, dualWield = UnitAttackSpeed("player")
	local now = GetTime()

	if dualWield then
		local percentage = (element.Mainhand.max - now) / element.Mainhand.speed

		if percentage > 0.6 then
			element.Mainhand.max = now + element.Mainhand.speed * 0.6
			element.Mainhand.min = now - (element.Mainhand.max - now) * percentage / (1 - percentage)
			element.Mainhand:SetMinMaxValues(element.Mainhand.min, element.Mainhand.max)
		elseif percentage > 0.2 then
			element.Mainhand.max = now + element.Mainhand.speed * 0.2
			element.Mainhand.min = now - (element.Mainhand.max - now) * percentage / (1 - percentage)
			element.Mainhand:SetMinMaxValues(element.Mainhand.min, element.Mainhand.max)
		end

		percentage = (element.Offhand.max - now) / element.Offhand.speed

		if percentage > 0.6 then
			element.Offhand.max = now + element.Offhand.speed * 0.6
			element.Offhand.min = now - (element.Offhand.max - now) * percentage / (1 - percentage)
			element.Offhand:SetMinMaxValues(element.Offhand.min, element.Offhand.max)
		elseif percentage > 0.2 then
			element.Offhand.max = now + element.Offhand.speed * 0.2
			element.Offhand.min = now - (element.Offhand.max - now) * percentage / (1 - percentage)
			element.Offhand:SetMinMaxValues(element.Offhand.min, element.Offhand.max)
		end
	else
		local percentage = (element.Twohand.max - now) / element.Twohand.speed

		if percentage > 0.6 then
			element.Twohand.max = now + element.Twohand.speed * 0.6
			element.Twohand.min = now - (element.Twohand.max - now) * percentage / (1 - percentage)
			element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
		elseif percentage > 0.2 then
			element.Twohand.max = now + element.Twohand.speed * 0.2
			element.Twohand.min = now - (element.Twohand.max - now) * percentage / (1 - percentage)
			element.Twohand:SetMinMaxValues(element.Twohand.min, element.Twohand.max)
		end
	end
end

local function Ooc(self)
	local element = self.Swing

	melee = false
	range = false

	element:Hide()
	element.Twohand:Hide()
	element.Mainhand:Hide()
	element.Offhand:Hide()
end

local function Enable(self, unit)
	local element = self.Swing

	if element and unit == "player" then
		for _, Bar in pairs({element.Twohand, element.Mainhand, element.Offhand}) do
			Bar.__owner = element

			if Bar:IsObjectType("StatusBar") and not Bar:GetStatusBarTexture() then
				Bar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end

			if Bar.Spark and Bar.Spark:IsObjectType("Texture") and not Bar.Spark:GetTexture() then
				Bar.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
			end

			if Bar.Text then
				Bar.Text:SetParent(Bar)
			end
		end

		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", Ranged)
--		self:RegisterEvent("UNIT_RANGEDDAMAGE", RangedChange)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Melee)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", ParryHaste)
		self:RegisterEvent("UNIT_ATTACK_SPEED", MeleeChange)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", Ooc)

		return true
	end
end

local function Disable(self)
	local element = self.Swing

	if element then
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED", Ranged)
--		self:UnregisterEvent("UNIT_RANGEDDAMAGE", RangedChange)
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Melee)
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", ParryHaste)
		self:UnregisterEvent("UNIT_ATTACK_SPEED", MeleeChange)
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", Ooc)

		element:Hide()
	end
end

oUF:AddElement("Swing", nil, Enable, Disable)