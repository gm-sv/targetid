require("gmsv")

local color_black = Color(0, 0, 0, 255)

gmsv.StartModule("TargetID")
do
	if CLIENT then
		function DrawTextWithShadow(self, Text)
			local x, y = surface.GetTextPos()
			local PrimaryColor = surface.GetTextColor()

			surface.SetTextColor(color_black)

			surface.SetTextPos(x + 1, y + 1)
			surface.DrawText(Text)

			surface.SetTextPos(x + 2, y + 2)
			surface.DrawText(Text)

			surface.SetTextColor(PrimaryColor)
			surface.SetTextPos(x, y)
			surface.DrawText(Text)
		end

		function HUDDrawTargetID()
			local Trace = LocalPlayer():GetEyeTrace()
			if not Trace.Hit or not Trace.HitNonWorld then return false end

			local Player = Trace.Entity
			if not Player:IsPlayer() then return false end

			local Name = Player:GetName()
			local HealthArmor = Format("%u%%   %u%%", Player:Health(), Player:Armor()) -- Hmmmm might be slow

			surface.SetFont("TargetID")
			surface.SetTextColor(team.GetColor(Player:Team()))

			local x = ScrW() * 0.5
			local y = ScrH() * 0.5

			-- Name
			local tw, th = surface.GetTextSize(Name)
			local tx = x - (tw * 0.5)
			local ty = y + 30

			surface.SetTextPos(tx, ty)
			self:DrawTextWithShadow(Name)

			-- Health and Armor
			ty = (ty + th) + 5
			tw, th = surface.GetTextSize(HealthArmor)
			tx = x - (tw * 0.5)

			surface.SetTextPos(tx, ty)
			self:DrawTextWithShadow(HealthArmor)

			-- God Mode
			if Player:HasGodMode() then
				local Status = "(Has God Mode)"

				ty = (ty + th) + 5
				tw, th = surface.GetTextSize(Status)
				tx = x - (tw * 0.5)

				surface.SetTextPos(tx, ty)
				self:DrawTextWithShadow(Status)
			end

			return false
		end

		function OnEnabled(self)
			hook.Add("HUDDrawTargetID", self:GetName(), self.HUDDrawTargetID)
		end

		function OnDisabled(self)
			hook.Remove("HUDDrawTargetID", self:GetName())
		end
	end
end
gmsv.EndModule()
