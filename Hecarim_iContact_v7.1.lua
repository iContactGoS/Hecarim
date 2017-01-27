
if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

if GetObjectName(GetMyHero()) ~= "Hecarim" then return end

require("DamageLib")


function AutoUpdate(data)
    if tonumber(data) > tonumber(7.2) then
        PrintChat('New version found!')
        PrintChat('Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/iContactGoS/Hecarim/master/Hecarim_iContact_v7.1.lua', SCRIPT_PATH .. 'Hecarim_iContact_v7.1.lua', function() PrintChat('Update Complete, please 2x F6!') return end)
    else
        PrintChat('No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/iContactGoS/Hecarim/master/Hecarim.update", AutoUpdate)

local HecarimMenu = Menu("Hecarim - iContact", "Hecarim - iContact")

HecarimMenu:SubMenu("Combo", "Combo")

HecarimMenu.Combo:Boolean("Q", "Use Q in combo", true)
HecarimMenu.Combo:Boolean("W", "Use W in combo", true)
HecarimMenu.Combo:Boolean("E", "Use E in combo", true)
HecarimMenu.Combo:Boolean("R", "Use R in combo", true)
HecarimMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)


HecarimMenu:SubMenu("LaneClear", "LaneClear")
HecarimMenu.LaneClear:Boolean("Q", "Use Q", true)
HecarimMenu.LaneClear:Boolean("W", "Use W", true)
HecarimMenu.LaneClear:Boolean("E", "Use E", false)


HecarimMenu:SubMenu("Harass", "Harass")
HecarimMenu.Harass:Boolean("Q", "Use Q", true)
HecarimMenu.Harass:Boolean("W", "Use W", true)

HecarimMenu:SubMenu("KillSteal", "KillSteal")
HecarimMenu.KillSteal:Boolean("Q", "KS w Q", true)
HecarimMenu.KillSteal:Boolean("E", "KS w E", true)
HecarimMenu.KillSteal:Boolean("R", "KS w R", true)

HecarimMenu:SubMenu("Drawings", "Drawings")
HecarimMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
HecarimMenu.Drawings:Boolean("DW", "Draw W Range", true)
HecarimMenu.Drawings:Boolean("DR", "Draw R Range", true)


OnTick(function (myHero)

	if Mix:Mode() == "Harass" then
        if HecarimMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 350) then
			if target ~= nil then
				CastSpell(target, _Q)
            end
        end
        if HecarimMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 525) then
			CastSpell(_W)
        end
    end


	if Mix:Mode() == "Combo" then
		if HecarimMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 350) then
		CastSpell(target, _Q)
		end

		if HecarimMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 525) then
			CastSpell(_W)
		end
		if HecarimMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1500) then
		CastSpell(_E)
		end
		if HecarimMenu.Combo.R:Value() and Ready(_R) and EnemiesAround(myHeroPos(), 1000) >= 1 and (EnemiesAround(myHeroPos(), 1000) >= HecarimMenu.Combo.RX:Value()) then
			CastSkillShot(target, _R)
		end
	end

    for _, enemy in pairs(GetEnemyHeroes()) do
        if IsReady(_Q) and ValidTarget(enemy, 350) and HecarimMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
			if target ~= nil then
                CastSpell(target, _Q)
		    end
        end

		if IsReady(_E) and ValidTarget(enemy, 187) and HecarimMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
            CastSpell(_E)
        end
    end

    if Mix:Mode() == "LaneClear" then
		for _,closeminion in pairs(minionManager.objects) do
	        if HecarimMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 350) then
				CastSpell(_Q)
			end
            if HecarimMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 525) then
				CastSpell(_W)
            end
            if HecarimMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 325) then
	        	CastSpell(_E)
	        end
		end
	end

end)

OnDraw(function (myHero)
    if HecarimMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 350, 0, 200, GoS.Yellow)
    end
    if HecarimMenu.Drawings.DW:Value() then
		DrawCircle(GetOrigin(myHero), 525, 0, 200, GoS.Yellow)
	end
	if HecarimMenu.Drawings.DR:Value() then
		DrawCircle(GetOrigin(myHero), 1000, 0, 200, GoS.Yellow)
	end
end)


print('Hecarim - iContact Version 7.1! - Have Fun!')
