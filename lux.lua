IncludeFile("Lib\\TOIR_SDK.lua")
    Lux = class()
local version = 0.1
local developer="Pinggin_friend"
function OnLoad()
    if GetChampName(GetMyChamp()) == "Lux" then
        __PrintTextGame("")
        __PrintTextGame("<b><font size=\"40\" color=\"#ffffff\">LUX</font></b>".."<b><font size=\"20\" color=\"#ffffff\">  </font></b>".."<b><font size=\"40\" color=\"#ffffff\">LIGHTNED</font></b>".."<font size=\"20\" color=\"#ff0000\">v0.1</font>")
        __PrintTextGame("<b><font color=\"#ffffff\">_______By: Pinggin_friend_________</font></b> ")
        __PrintTextGame("")
        __PrintTextGame("")

        Lux:__init()

    else
        __PrintTextGame("<b><font color=\"#ff0000\">Your Champion is not Lux </font></b> " )

    end
end


function Lux:__init()

    self.Q = Spell(_Q, 1175 )
    self.W = Spell(_W,1075 )
    self.E = Spell(_E,1000 )
    self.R = Spell(_R,3340 )


    self.Q:SetSkillShot(0.5, 120, 1000,false)
    self.W:SetSkillShot(0.5, 120, 1000,false)
    self.E:SetSkillShot(0.5, 120, 1000,false)
    self.R:SetSkillShot(0.5, 120, 1000,false)



    Callback.Add("Tick", function() self:OnTick() end)
    Callback.Add("Draw", function(...) self:OnDraw(...) end)
    Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
    Callback.Add("UpdateBuff", function(...) self:OnUpdateBuff(...) end)
    Callback.Add("RemoveBuff", function(...) self:OnRemoveBuff(...) end)
    Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)

    self:SetDefault()

end











function Lux:MenuBool(stringKey, bool)
    return ReadIniBoolean(self.menu, stringKey, bool)
end

function Lux:MenuSliderInt(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Lux:MenuKeyBinding(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end
function Lux:MenuSliderFloat(stringKey, valueDefault)
    return ReadIniFloat(self.menu, stringKey, valueDefault)
end


function Lux:MenuComboBox(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end


function Lux:OnDraw()


    --disable all draws
    if not self.draw_All then


        --Draw autoattack range
        if self.draw_AA then
            local aa_range = Vector(myHero)

            DrawCircleGame(aa_range.x , aa_range.y, aa_range.z, GetAttackRange(GetMyChamp())+150, Lua_ARGB(255,255,255,255))
        end
        --Draw Q range
        if self.Q:IsReady() and self.draw_Q then
            local posQ = Vector(myHero)
            DrawCircleGame(posQ.x , posQ.y, posQ.z, self.Q.range+70, Lua_ARGB(255,0,255,0))
        end
        if self.E:IsReady() and self.draw_E then
            local posE = Vector(myHero)
            DrawCircleGame(posE.x , posE.y, posE.z, self.E.range+240, Lua_ARGB(255,255,0,0))
        end

        --Draw R range
        if self.R:IsReady() and self.draw_R then
            local posR = Vector(myHero)
            DrawCircleGame(posR.x , posR.y, posR.z, self.R.range+450, Lua_ARGB(255,0,0,255))

        end






        enemies_t=self:GetEnemies()

        for i,j in pairs(enemies_t) do

            if self.draw_enemy_AA and GetAIHero(j).IsDead==false and GetAIHero(j).IsVisible==true then
                local enemy_aa_range = Vector(GetAIHero(j))

                DrawCircleGame(enemy_aa_range.x , enemy_aa_range.y, enemy_aa_range.z, GetAIHero(j).AARange , Lua_ARGB(255,255,255,255))
            end




        end




    end


end











--Draw Main section in menu and set defaults----------------------------------------------------------------------------
function Lux:OnDrawMenu()
    if Menu_Begin(self.menu) then


        if Menu_Begin("Drawings") then
            self.draw_All = Menu_Bool("Disable all drawings", self.draw_All, self.menu)
            Menu_Separator()
            if self.draw_All==false then
                self.draw_AA = Menu_Bool("Draw AA  Range", self.draw_AA, self.menu)
                self.draw_enemy_AA = Menu_Bool("Draw enemy_AA  Range", self.draw_enemy_AA, self.menu)

                self.draw_Q = Menu_Bool("Draw Q Range", self.draw_Q, self.menu)
                self.draw_E = Menu_Bool("Draw E Range", self.draw_E, self.menu)
                self.draw_R = Menu_Bool("Draw R Range", self.draw_R, self.menu)
            end

            Menu_End()
        end


        Menu_Separator()
        ---Combo

        if Menu_Begin("Combo") then
            self.combo_Q = Menu_Bool("Use Q in Combo", self.combo_Q, self.menu)
            self.combo_W = Menu_Bool("Use W in Combo", self.combo_W, self.menu)
            self.combo_E = Menu_Bool("Use E in Combo", self.combo_E, self.menu)
            self.combo_R = Menu_Bool("Use R in Combo", self.combo_R, self.menu)
            if self.combo_R  then

                self.RTYPE = Menu_ComboBox("When to cast R", self.RTYPE, "IF STUNNED\0IF KILLABLE\0\0", self.menu)


            end


            Menu_End()
        end
        Menu_Separator()

        --Harras
        if Menu_Begin("Harras") then

            self.harras_Q = Menu_Bool("Use Q in Harras", self.harras_Q, self.menu)
            if self.harras_Q then
                self.Q_mana_Harras = Menu_SliderInt("Q min mana", self.Q_mana_Harras, 1, myHero.MaxMP, self.menu)

            end
            Menu_Separator()

            self.harras_W = Menu_Bool("Use W in Harras", self.harras_W, self.menu)
            if  self.harras_W then
                self.W_mana_Harras = Menu_SliderInt("W min mana",self.W_mana_Harras, 1, myHero.MaxMP, self.menu)
            end
Menu_Separator()

            self.harras_E = Menu_Bool("Use E in Harras", self.harras_E, self.menu)
            if  self.harras_E then
                self.E_mana_Harras = Menu_SliderInt("E min mana",self.E_mana_Harras, 1, myHero.MaxMP, self.menu)
            end

            Menu_Separator()

            self.harras_R = Menu_Bool("Use R in Harras", self.harras_R, self.menu)

            if  self.harras_R then
                self.R_mana_Harras = Menu_SliderInt("R min mana",self.R_mana_Harras, 0, myHero.MaxMP, self.menu)

            end


                Menu_End()
        end
        Menu_Separator()

        --LaneClear
        if Menu_Begin("LaneClear") then



            Menu_End()
        end
        Menu_Separator()


        if Menu_Begin("JungleClear") then



            Menu_End()
        end
        Menu_Separator()


        if Menu_Begin("KillSteal") then




            Menu_End()
        end
        Menu_Separator()


        if Menu_Begin("Flee") then

            Menu_End()
        end
        Menu_Separator()






        if Menu_Begin("Miscellaneous") then


            Menu_End()
        end

        Menu_Separator()






        if Menu_Begin("Key bindings") then
                self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
            self.Harass = Menu_KeyBinding("Harass", self.Harass, self.menu)
            self.Last_Hit = Menu_KeyBinding("Last Hit", self.Last_Hit, self.menu)
            self.LaneClear = Menu_KeyBinding("Lane Clear", self.LaneClear, self.menu)
            self.JungleClear = Menu_KeyBinding("Jungle Clear", self.JungleClear, self.menu)
            self.Flee = Menu_KeyBinding("Flee", self.Flee, self.menu)
            Menu_End()
        end











        Menu_End()
    end
end





function Lux:SetDefault()
    self.menu = "LUX_LIGHTENED"

    --Draw
    self.draw_All = self:MenuBool("Disable all drawings", true)
    self.draw_AA = self:MenuBool("Draw AA Range", true)
    self.draw_enemy_AA = self:MenuBool("Draw  enemy_AA Range", true)

    self.draw_Q = self:MenuBool("Draw Q Range", true)
    self.draw_E = self:MenuBool("Draw E Range", true)
    self.draw_R = self:MenuBool("Draw R Range", true)
    self.RTYPE = self:MenuComboBox("When to cast R", 1)

    --combo
    self.combo_Q = self:MenuBool("Use Q in Combo", true)
    self.combo_W = self:MenuBool("Use W in Combo", true)
    self.combo_E = self:MenuBool("Use E in Combo", true)
    self.combo_R = self:MenuBool("Use R in Combo", true)

    --harass
    self.harras_Q = self:MenuBool("Use Q in Harras", true)
    self.Q_mana_Harras = self:MenuSliderInt("Q min mana", 100)

    self.harras_W = self:MenuBool("Use W in Harras", true)
    self.W_mana_Harras = self:MenuSliderInt("W min mana", 0)

 self.harras_E = self:MenuBool("Use E in Harras", true)
    self.E_mana_Harras = self:MenuSliderInt("E min mana", 0)

    self.harras_R = self:MenuBool("Use R in Harras", true)
    self.R_mana_Harras = self:MenuSliderInt("R min mana", 0)

    --laneclear


    --jgclear

    --flee

    --miscellaneous

    --game assistance


    --Keybindindings
    self.Combo = self:MenuKeyBinding("Combo", 32)
    self.Harass = self:MenuKeyBinding("Harass", 31)
    self.Last_Hit = self:MenuKeyBinding("Last Hit", 30)
    self.LaneClear = self:MenuKeyBinding("Lane Clear", 33)
    self.JungleClear = self:MenuKeyBinding("Jungle Clear", 34)
    self.Flee = self:MenuKeyBinding("Flee", 165)
end





function Lux:OnTick()
    if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
    local Target = GetTargetSelector(1500, 0)
    local Target2 = GetTargetSelector(3300, 0)

    if GetKeyPress(self.Combo) > 0   then
       self:makeCombo(Target2)
    end
    if GetKeyPress(self.Harass) > 0   then
      -- self:makeHarras(Target2)
    end


     if GetKeyPress(self.LaneClear) > 0   then
        self:makeLaneClear()
    end

     if GetKeyPress(self.JungleClear) > 0   then

        self:makeJungleClear()
    end



     if GetKeyPress(self.Flee) > 0   then

        self:MakeFlee()
    end



end


function Lux:makeCombo(Target)
s=GetAIHero(Target)



    local castPosXr, castPosZr  , unitPosXr, unitPosZr, hitChancer, _aoeTargetsHitCountr = GetPredictionCore(s.Addr, 0,  1.012, 20, 3300, 0, myHero.x, myHero.z, true, false)
    if hitChancer >= 5 then


        if   s.IsMove==false then

            CastSpellToPos(castPosXr,castPosZr,_R)

        end

    end

    local castPosXe, castPosZe , unitPosXe, unitPosZe, hitChancee, _aoeTargetsHitCounte = GetPredictionCore(s.Addr, 0, 0.25, 20, 1200, 1200, myHero.x, myHero.z, true, false)

    if hitChancee >= 5 then



            CastSpellToPos(castPosXe,castPosZe,_E)


    end




  local castPosXq, castPosZq, unitPosXq, unitPosZq, hitChanceq, _aoeTargetsHitCountq = GetPredictionCore(s.Addr, 0, 0.25, 20, 1200, 1050, myHero.x, myHero.z, true, true,2,0,1,2)

    if hitChanceq >= 5 then



        --    CastSpellToPos(castPosXq,castPosZq,_Q)


    end












    --todo: prevenet W from casting without enemies around


end



function Lux:makeHarras(Target)





end

function Lux:makeLaneClear()

    if
    (GetType(GetTargetOrb()) == 1)
            --and (GetTargetOrb().HP<=GetDamage("Q", GetTargetOrb()))
    then


  --      CastSpellTarget(GetUnit(GetTargetOrb()).Addr,_Q)
  --          CastSpellToPredictionPos(GetUnit(GetTargetOrb()).Addr, _R, self.R.range)

    end
        end



function Lux:makeJungleClear()

    if
    (GetType(GetTargetOrb()) == 3)
    then



        later=GetTimeGame()
        self.delta=later-self.now

        if self.delta >=2.0 then

           CastSpellTarget(GetUnit(GetTargetOrb()).Addr,_Q)
            CastSpellToPredictionPos(GetUnit(GetTargetOrb()).Addr, _R, self.R.range)
            --end
            self.delta=0
            self.now=later
        end




    end

end



function   Lux:MakeFlee()

    MoveToPos(GetMousePosX(),GetMousePosZ())
    CastSpellTarget(myHero.Addr,_W)
    CastSpellTargetByName(myHero.Addr,"ItemSoFBoltSpellBase")
    CastSpellToPos(GetMousePosX(), GetMousePosZ(),GetSpellIndexByName("ItemSoFBoltSpellBase"))


    --TODO: item usage
end



function Lux:GetEnemies()
    enemy_champs = {}

    for i,j in pairs(self:GetHeroes()) do
        if IsEnemy(j) and IsChampion(j) then
            table.insert(enemy_champs, j)

        end
    end

    return enemy_champs
end

function Lux:GetHeroes()
    SearchAllChamp()
    local t = pObjChamp
    return t
end
