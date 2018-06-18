IncludeFile("Lib\\TOIR_SDK.lua")

    Teeto = class()
local version = 0.1
local developer="Pinggin_friend"
function OnLoad()
    if GetChampName(GetMyChamp()) == "Teemo" then
        __PrintTextGame("")
        __PrintTextGame("<b><font size=\"40\" color=\"#ffffff\">TEETO</font></b>".."<b><font size=\"20\" color=\"#ffffff\"> ON </font></b>".."<b><font size=\"40\" color=\"#ffffff\">DUTY</font></b>".."<font size=\"20\" color=\"#ff0000\">v0.1</font>")
        __PrintTextGame("<b><font color=\"#ffffff\">_______By: Pinggin_friend_________</font></b> ")
        __PrintTextGame("")
        __PrintTextGame("")

        Teeto:__init()

    else
        __PrintTextGame("<b><font color=\"#ff0000\">Your Champion is not Teemo </font></b> " )

    end
end


function Teeto:__init()



     self.english={'Drawings',"Combo","Harrass","Jungle Clear","Flee","Miscellaneous","Key Bindings","[Beta]Game Assistance"}
    self.portuguese={"Desenhos","Combo","Molestar","Jungle Clear","Fugir","Diversos","Combinações de teclas","[Beta] Assistência ao Jogo"}
    self.chinese={"图纸","二合一","骚扰","丛林清澈","逃跑","杂","关键绑定","[Beta]游戏援助"}
    self.vietnamese={"Bản vẽ","Combo","Quấy rối","Jungle Clear","tẩu thoát","Khác","Tổ hợp phím","[Beta] Hỗ trợ trò chơi"}
    self.turkish={"Çizimler","kombo","bezdirmek","Orman temizle","kaçış","Çeşitli","Anahtar Bağlamalar","[Beta] Oyun Yardımı"}
    self.polish={"Rysunki","Combo","Nękać","Jungle Clear","ucieczka","Różne","Wiązania kluczowe","[Beta] Pomoc w grze"}
    self.korean={"도면","콤보","괴롭히다","정글 클리어","탈출","여러 가지 잡다한","키 바인딩","[Beta] 게임 지원"}
    self.spanish={"Dibujos","Combo","Acosar","Jungle Clear","escapar","Diverso","Atajos de teclado","[Beta] Asistencia de juego"}
    self.taiwanese={"ภาพวาด","วงดนตรีผสม","ราวี","ล้างป่า","หนี","เบ็ดเตล็ด","การผูกคีย์","ความช่วยเหลือเกี่ยวกับเกมเบต้า"}
    self.greek={"Σχέδια ζωγραφικής","Combo","Παρενοχλούν","Jungle Clear","διαφυγή","Διάφορα","Συνδέσεις κλειδιών","[Beta] Βοήθεια παιχνιδιών"}


self.languagetab={self.english,self.portuguese,self.chinese,self.vietnamese,self.turkish,self.polish,self.korean,self.spanish,self.taiwanese,self.greek}


    SetLuaCombo(true)

    SetLuaHarass(true)
    SetLuaLaneClear(true)
    self.Q = Spell(_Q, 730)
    self.W = Spell(_W)
    self.E = Spell(_E)
    self.R = Spell(_R,400)

    self.NoVision = {}
    self.LastSeenTime = {}
    self.recalled={false,false,false,false,false}
    self.colours = {Lua_ARGB(255,255,255,255),Lua_ARGB(255,0,255,0),Lua_ARGB(255,255,76,59),Lua_ARGB(255,0,114,187),Lua_ARGB(255,255,208,52)}
    self.langauge=GetCurrentLanguage()
    self.lastpos = {}

    self.circleSize=0

    self.onetimetable={false,false,false,false,false}
    self.Q:SetTargetted(0.5, 1500)
    self.W:SetActive()
    self.R:SetSkillShot(0.5, 120, 1000,false)


    self.deltashroom=0
    self.nowhshroom=0
    self.delta={0,0,0,0,0}
    self.now ={GetTimeGame(),GetTimeGame(),GetTimeGame(),GetTimeGame(),GetTimeGame()}
    self.counter={0,0,0,0,0}

    self.your_enemies=self:GetEnemies()
    Callback.Add("Tick", function() self:OnTick() end)
    Callback.Add("CreateObject", function() self:OnCreateObject() end)
    Callback.Add("DeleteObject", function() self:OnDeleteObject() end)
    Callback.Add("Draw", function(...) self:OnDraw(...) end)
    Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
    Callback.Add("UpdateBuff", function(...) self:OnUpdateBuff(...) end)
    Callback.Add("RemoveBuff", function(...) self:OnRemoveBuff(...) end)
    Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
    Callback.Add("Vision", function(...) self:OnVision(...) end)



    self:SetDefault()

end











function Teeto:MenuBool(stringKey, bool)
    return ReadIniBoolean(self.menu, stringKey, bool)
end

function Teeto:MenuSliderInt(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Teeto:MenuKeyBinding(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end
function Teeto:MenuSliderFloat(stringKey, valueDefault)
    return ReadIniFloat(self.menu, stringKey, valueDefault)
end





function Teeto:OnDraw()






    --disable all draws
    if not self.draw_All then


        --Draw autoattack range
        if self.draw_AA then
            local aa_range = Vector(myHero)

            DrawCircleGame(aa_range.x , aa_range.y, aa_range.z, GetAttackRange(GetMyChamp())+135, Lua_ARGB(255,255,255,255))
        end
        --Draw Q range
        if self.Q:IsReady() and self.draw_Q then
            local posQ = Vector(myHero)
            DrawCircleGame(posQ.x , posQ.y, posQ.z, self.Q.range+52, Lua_ARGB(255,0,255,0))
        end

        --Draw R range
        if self.R:IsReady() and self.draw_R then
            local posR = Vector(myHero)
            if myHero.LevelSpell(_R)==1 then
                DrawCircleGame(posR.x , posR.y, posR.z, self.R.range+55, Lua_ARGB(255,0,0,255))

            end

                    if myHero.LevelSpell(_R)==2 then
                        self.R = Spell(_R,650)

                        DrawCircleGame(posR.x , posR.y, posR.z, self.R.range+85, Lua_ARGB(255,0,0,255))

            end

                    if myHero.LevelSpell(_R)==3 then
                        self.R = Spell(_R,900)

                        DrawCircleGame(posR.x , posR.y, posR.z, self.R.range+120, Lua_ARGB(255,0,0,255))

            end




        end


--draw important shroom places

        --  Top Lane Blue Side + Baron
        if self.Top_Lane_Blue_Side then
            DrawCircleGame(2790, 50.16358, 7278, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(3700.708, -11.22648, 9294.094, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(2314 , 53.165 , 9722 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(3090, -68.03732 , 10810 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(4722 , -71.2406 , 10010 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(5208 , -71.2406 , 9114 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(4400 , 52.53909 , 7240, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(4564 , 51.83786 , 6060, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(2760 , 52.96445 , 5178, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(4440 , 56.8484 , 11840, 149, Lua_ARGB(255, 0,250,154))

        end
        --Top Lane Tri Bush

        if self.Top_Lane_Tri_Bush then
            DrawCircleGame(2420, 52.8381, 13482, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(1630 , 52.8381 , 13008, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(1172 , 52.8381 , 12302 , 149, Lua_ARGB(255, 0,250,154))

            DrawCircleGame(3020, 52.8381, 12182 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(2472 , 52.8381 , 11702 , 149, Lua_ARGB(255, 0,250,154))


        end
        --Top Lane Red Side

        if self.Top_Lane_Red_Side then
            DrawCircleGame(5666 , 52.8381 , 12722 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(8004 , 56.4768 , 11782, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(9194 , 53.35013 , 11368 , 149, Lua_ARGB(255, 0,250,154))

            DrawCircleGame( 8280 , 50.06194 , 10254  , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(6728 , 53.82967 , 11450  , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(5980 , 53.82967 , 11150  , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(6242 , 54.09851 , 10270 , 149, Lua_ARGB(255, 0,250,154))


        end




       -- Mid Lane

        if self.Mid_Lane then
            DrawCircleGame(6484 , -71.2406 , 8380 , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(8380 , -71.2406 , 6502, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame( 9099.75 , 52.95337 , 7376.637 , 149, Lua_ARGB(255, 0,250,154))

            DrawCircleGame(  7376 , 52.8726 , 8802  , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(  5776 , 52.8726 , 7402  , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(7602 , 52.56985 , 5928  , 149, Lua_ARGB(255, 0,250,154))


        end




        --Dragon
        if self.Dragon then
            DrawCircleGame(9372 , -71.2406 , 5674  , 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(10148 , -71.2406 , 4801.525, 149, Lua_ARGB(255, 0,250,154))

        end




        --Bot Lane Red Side
        if self.Both_Lane_Red_Side then
            DrawCircleGame(9772 , 9.031885 , 6458, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(9938, 51.62378, 7900, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(11465, 51.72557, 7157.772, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(12481, 51.7294, 5232.559, 149, Lua_ARGB(255, 0,250,154))

            DrawCircleGame(11266, -7.897567, 5542, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(11290, 64.39886, 8694, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(12676, 51.6851, 7310.818, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(12022, 9154, 51.25105, 149, Lua_ARGB(255, 0,250,154))


        end




        -- Bot Lane Blue Side+bushes
        if self.Both_Lane_Blue_Side_bushes then
            DrawCircleGame(6544 , 48.257, 4732, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(5576, 51.42581, 3512, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(6888, 51.94016, 3082, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(8070, 51.5508, 3472, 149, Lua_ARGB(255, 0,250,154))

            DrawCircleGame(8594, 51.73177, 4668, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(10388, 49.81641, 3046, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(9160, 59.97022, 2122, 149, Lua_ARGB(255, 0,250,154))


        end



        -- Bot Lane tri bushes++
        if self.Both_Lane_tri_bushes then

            DrawCircleGame(12518 , 53.66707, 1504, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(13404, 51.3669, 2482, 149, Lua_ARGB(255, 0,250,154))
            DrawCircleGame(11854, -68.06037, 3922, 149, Lua_ARGB(255, 0,250,154))


        end


        enemies_t=self:GetEnemies()

        for i,j in pairs(enemies_t) do

            if self.draw_enemy_AA and GetAIHero(j).IsDead==false and GetAIHero(j).IsVisible==true then
                local enemy_aa_range = Vector(GetAIHero(j))

                DrawCircleGame(enemy_aa_range.x , enemy_aa_range.y, enemy_aa_range.z, GetAIHero(j).AARange , Lua_ARGB(255,255,255,255))
            end




        end





    end


if  self.MMDRAWS then
    self:circles()

end

end








function Teeto:SetDefault()
    self.menu = "TEETO_on_DUTY"

    --Combo
    self.Smart_Q = self:MenuBool("Use Q only on ADC", true)
    self.combo_Q = self:MenuBool("Use Q in Combo", true)
    self.combo_W = self:MenuBool("Use W in Combo", true)

    self.combo_R = self:MenuBool("Use R in Combo", true)

    self.ShroomStacks_combo = self:MenuSliderInt("Number of shrooms before casting", 1)

    --harras
    self.harras_Q = self:MenuBool("Use Q in Harras", true)
    self.Q_mana_Harras = self:MenuSliderInt("Q min mana", 100)

    self.harras_W = self:MenuBool("Use W in Harras", true)
    self.W_mana_Harras = self:MenuSliderInt("W min mana", 0)

    self.harras_R = self:MenuBool("Use R in Harras", true)
    self.R_mana_Harras = self:MenuSliderInt("R min mana", 0)
    self.ShroomStacks_harras = self:MenuSliderInt("Number of shrooms before casting", 1)


    --JgClear
    self.JgClear_Q = self:MenuBool("Use Q in JungleClear", true)
    self.Q_mana_JC = self:MenuSliderInt("Q min mana", 0)

    self.JgClear_R = self:MenuBool("Use R in JungleClear", true)
    self.R_mana_JC = self:MenuSliderInt("R min mana", 0)
    self.ShroomStacks_JC = self:MenuSliderInt("Number of shrooms before casting", 1)



    --flee
    self.Flee_W = self:MenuBool("Use W in Flee", true)
    self.W_mana_Flee = self:MenuSliderInt("min mana", 0)

    self.Flee_items = self:MenuBool("Use items in Flee", true)

    --KeyBindings
    self.Combo = self:MenuKeyBinding("Combo", 32)
    self.Harass = self:MenuKeyBinding("Harass", 31)
    self.Last_Hit = self:MenuKeyBinding("Last Hit", 30)
    self.LaneClear = self:MenuKeyBinding("Lane Clear", 33)
    self.JungleClear = self:MenuKeyBinding("Jungle Clear", 34)
    self.Flee = self:MenuKeyBinding("Flee", 165)

    --Miscellaneous
    self.Auto_R = self:MenuBool("Use automatic R on commomn places", false)
    self.R_mana_Auto = self:MenuSliderInt("Q min mana", 100)

    self.ShroomStacks_auto = self:MenuSliderInt("Number of shrooms before casting", 3)


    ---Draw
    self.draw_All = self:MenuBool("Disable all drawings", true)
    self.draw_AA = self:MenuBool("Draw AA Range", true)
    self.draw_enemy_AA = self:MenuBool("Draw  enemy_AA Range", true)
    self.aa_enemy_range = self:MenuBool("Draw AA enemy Range", true)
    self.draw_Q = self:MenuBool("Draw Q Range", true)
    self.draw_R = self:MenuBool("Draw R Range", true)
    self.Top_Lane_Blue_Side = self:MenuBool("Draw Top Lane Blue Side postitions", true)
    self.Top_Lane_Tri_Bush = self:MenuBool("Draw Top Lane Tri Bush postitions", true)
    self.Top_Lane_Red_Side = self:MenuBool("Draw Top Lane Red Side postitions", true)
    self.Mid_Lane = self:MenuBool("Draw Mid Lane positions", true)
    self.Dragon = self:MenuBool("Draw Dragon positions", true)
    self.Both_Lane_Red_Side = self:MenuBool("Draw Bot Lane Red Side postitions", true)
    self.Both_Lane_Blue_Side_bushes = self:MenuBool("Draw Bot Lane Blue Side bushes positions", true)
    self.Both_Lane_tri_bushes = self:MenuBool("Draw Bot Lane tri bushes postitions", true)

    --GameAssistance
    self.RT = self:MenuBool("Activate recall tracker?", true)
    self.MMDRAWS = self:MenuBool("Activate MiniMap drawings?", true)
    self.EARLYHINT = self:MenuBool("Activate early hints?", true)






end







--Draw Main section in menu and set defaults----------------------------------------------------------------------------
function Teeto:OnDrawMenu()
    if Menu_Begin(self.menu) then

        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][1]) then

            self.draw_All = Menu_Bool("Disable all drawings", self.draw_All, self.menu)

            Menu_Separator()
            if self.draw_All==false then
                self.draw_AA = Menu_Bool("Draw AA  Range", self.draw_AA, self.menu)
                self.draw_enemy_AA = Menu_Bool("Draw enemy_AA  Range", self.draw_enemy_AA, self.menu)
                self.aa_enemy_range = Menu_Bool("Draw AA enemy Range", self.aa_enemy_range, self.menu)
                self.draw_Q = Menu_Bool("Draw Q Range", self.draw_Q, self.menu)
                self.draw_R = Menu_Bool("Draw R Range", self.draw_R, self.menu)
                Menu_Separator()
                self.Top_Lane_Blue_Side = Menu_Bool("Draw Top Lane Blue Side postitions", self.Top_Lane_Blue_Side, self.menu)
                self.Top_Lane_Tri_Bush = Menu_Bool("Draw Top Lane Tri Bush postitions", self.Top_Lane_Tri_Bush, self.menu)
                self.Top_Lane_Red_Side = Menu_Bool("Draw Top Lane Red Side postitions", self.Top_Lane_Red_Side, self.menu)
                self.Mid_Lane = Menu_Bool("Draw Mid Lane positions", self.Mid_Lane, self.menu)
                self.Dragon = Menu_Bool("Draw Dragon positions", self.Dragon, self.menu)
                self.Both_Lane_Red_Side = Menu_Bool("Draw Bot Lane Red Side postitions", self.Both_Lane_Red_Side, self.menu)
                self.Both_Lane_Blue_Side_bushes = Menu_Bool("Draw Bot Lane Blue Side bushes positions", self.Both_Lane_Blue_Side_bushes, self.menu)
                self.Both_Lane_tri_bushes = Menu_Bool("Draw Bot Lane tri bushes postitions", self.Both_Lane_tri_bushes, self.menu)

            end

            Menu_End()
        end


        Menu_Separator()

        ---Combo

        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][2]) then
            self.combo_Q = Menu_Bool("Use Q in Combo", self.combo_Q, self.menu)
            if self.combo_Q then
                self.Smart_Q = Menu_Bool("Use Q only on ADC", self.Smart_Q, self.menu)
            end

            Menu_Separator()

            self.combo_W = Menu_Bool("Use W in Combo", self.combo_W, self.menu)

            Menu_Separator()

            self.combo_R = Menu_Bool("Use R in Combo", self.combo_R, self.menu)
            if self.combo_R  then


                self.ShroomStacks_combo = Menu_SliderInt("Number of shrooms before casting",self.ShroomStacks_combo, 1, 3, self.menu)

            end


            Menu_End()
        end
        Menu_Separator()

        --Harras
        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][3]) then
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

            self.harras_R = Menu_Bool("Use R in Harras", self.harras_R, self.menu)
            if  self.harras_R then
                self.R_mana_Harras = Menu_SliderInt("R min mana",self.R_mana_Harras, 0, myHero.MaxMP, self.menu)
                self.ShroomStacks_harras = Menu_SliderInt("Number of shrooms before casting",self.ShroomStacks_harras,1, 3, self.menu)

            end



            Menu_End()
        end
        Menu_Separator()




        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][4]) then
            self.JgClear_Q = Menu_Bool("Use Q in JungleClear", self.JgClear_Q, self.menu)
            if self.JgClear_Q then
                self.Q_mana_JC = Menu_SliderInt("Q min mana",self.Q_mana_JC , 1, myHero.MaxMP, self.menu)

            end
            Menu_Separator()

            self.JgClear_R = Menu_Bool("Use R in JungleClear", self.JgClear_R, self.menu)
            if self.JgClear_R then
                self.R_mana_JC = Menu_SliderInt("R min mana",   self.R_mana_JC, 1, myHero.MaxMP, self.menu)

                self.ShroomStacks_JC = Menu_SliderInt("Number of shrooms before casting",self.ShroomStacks_JC,1, 3, self.menu)

            end



            Menu_End()
        end
        Menu_Separator()




        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][5]) then
            self.Flee_W = Menu_Bool("Use W in Flee", self.Flee_W, self.menu)
            if self.Flee_W then
                self.W_mana_Flee = Menu_SliderInt("W min mana",self.W_mana_Flee, 1, myHero.MaxMP, self.menu)

            end
            Menu_Separator()

            self.Flee_items = Menu_Bool("Use items in Flee", self.Flee_items, self.menu)
            if  self.Flee_items then
                self.Item1 = Menu_Bool("Use protobelt", self.Item1, self.menu)


            end



            Menu_End()
        end
        Menu_Separator()






        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][6]) then


            self.Auto_R = Menu_Bool("Use automatic R on commomn places", self.Auto_R, self.menu)
            if  self.Auto_R then
                self.R_mana_Auto = Menu_SliderInt("min mana",self.R_mana_Auto, 1, myHero.MaxMP, self.menu)
                self.ShroomStacks_auto = Menu_SliderInt("Number of shrooms before casting",self.ShroomStacks_auto,1, 3, self.menu)

            end



            Menu_End()
        end

        Menu_Separator()






        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][7]) then
            self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
            self.Harass = Menu_KeyBinding("Harass", self.Harass, self.menu)
            self.Last_Hit = Menu_KeyBinding("Last Hit", self.Last_Hit, self.menu)
            self.LaneClear = Menu_KeyBinding("Lane Clear", self.LaneClear, self.menu)
            self.JungleClear = Menu_KeyBinding("Jungle Clear", self.JungleClear, self.menu)
            self.Flee = Menu_KeyBinding("Flee", self.Flee, self.menu)
            Menu_End()
        end
        Menu_Separator()



        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][8]) then
            self.RT = Menu_Bool("Activate recall tracker?", self.RT, self.menu)
            self.MMDRAWS = Menu_Bool("Activate MiniMap drawings?", self.MMDRAWS, self.menu)
            self.EARLYHINT = Menu_Bool("Activate early hints?", self.EARLYHINT, self.menu)





            Menu_End()
        end







        Menu_End()
    end
end






function Teeto:OnTick()
    if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
--autoshrooms


    local Target = GetTargetSelector(800, 0)

    if GetKeyPress(self.Combo) > 0   then
        self:makeCombo(Target)
        if myHero.Level<=3 and self.EARLYHINT then
            local Targetadvice = GetTargetSelector(1500, 0)

            self:advice(Targetadvice)
        end


    end
    if GetKeyPress(self.Harass) > 0   then
       self:makeHarras(Target)
        if myHero.Level<=3 and self.EARLYHINT  then
            local Targetadvice = GetTargetSelector(1500, 0)

            self:advice(Targetadvice)
        end
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

    --todo fix autohshroom
    if self.Auto_R and myHero.MP>=self.R_mana_Auto and self.ShroomStacks_auto<= myHero.StackSpell(_R) then





        if myHero.x<=2790+self.R.range and myHero.x>=2790-self.R.range and  myHero.z<=7278+self.R.range and myHero.z>=7278-self.R.range then
            CastSpellToPos(2790, 7278,_R)

        end



        if myHero.x<=3700.708+self.R.range and myHero.x>=3700.708-self.R.range and  myHero.z<= 9294.094+self.R.range and myHero.z>= 9294.094-self.R.range then
            CastSpellToPos(3700.708,  9294.094,_R)

        end



        if myHero.x<=2314+self.R.range and myHero.x>=2314-self.R.range and  myHero.z<=9722+self.R.range and myHero.z>=9722-self.R.range then
            CastSpellToPos(2314,9722,_R)

        end



        if myHero.x<=3090+self.R.range and myHero.x>=3090-self.R.range and  myHero.z<=10810+self.R.range and myHero.z>=10810-self.R.range then
            CastSpellToPos(3090, 10810,_R)

        end



        if myHero.x<=4722+self.R.range and myHero.x>=4722-self.R.range and  myHero.z<=10010+self.R.range and myHero.z>=10010-self.R.range then
            CastSpellToPos(4722, 4801.525,_R)

        end



        if myHero.x<=5208+self.R.range and myHero.x>=5208-self.R.range and  myHero.z<=9114+self.R.range and myHero.z>=9114-self.R.range then
            CastSpellToPos(5208, 9114,_R)

        end



        if myHero.x<=4400+self.R.range and myHero.x>=4400-self.R.range and  myHero.z<=7240+self.R.range and myHero.z>=7240-self.R.range then
            CastSpellToPos(4400, 7240,_R)

        end



        if myHero.x<=4564+self.R.range and myHero.x>=4564-self.R.range and  myHero.z<=6060+self.R.range and myHero.z>=6060-self.R.range then
            CastSpellToPos(4564, 6060,_R)

        end



        if myHero.x<=2760+self.R.range and myHero.x>=2760-self.R.range and  myHero.z<=5178+self.R.range and myHero.z>=5178-self.R.range then
            CastSpellToPos(2760, 5178,_R)

        end



        if myHero.x<=4440+self.R.range and myHero.x>=4440-self.R.range and  myHero.z<=11840+self.R.range and myHero.z>=11840-self.R.range then
            CastSpellToPos(4440,11840,_R)

        end


        -----------------------


        if myHero.x<=2420+self.R.range and myHero.x>=2420-self.R.range and  myHero.z<=13482+self.R.range and myHero.z>=13482-self.R.range then
            CastSpellToPos(2420, 13482,_R)

        end



        if myHero.x<=1630+self.R.range and myHero.x>=1630-self.R.range and  myHero.z<=13008+self.R.range and myHero.z>=13008-self.R.range then
            CastSpellToPos(1630, 13008,_R)

        end



        if myHero.x<=1172+self.R.range and myHero.x>=1172-self.R.range and  myHero.z<=12182+self.R.range and myHero.z>=12182-self.R.range then
            CastSpellToPos(1172, 12182,_R)

        end



        if myHero.x<=3020+self.R.range and myHero.x>=3020-self.R.range and  myHero.z<=12182+self.R.range and myHero.z>=12182-self.R.range then
            CastSpellToPos(3020, 12182,_R)

        end



        if myHero.x<=2472+self.R.range and myHero.x>=2472-self.R.range and  myHero.z<=11702+self.R.range and myHero.z>=11702-self.R.range then
            CastSpellToPos(2472, 11702,_R)

        end


        if myHero.x<=5666+self.R.range and myHero.x>=5666-self.R.range and  myHero.z<=12722+self.R.range and myHero.z>=12722-self.R.range then
            CastSpellToPos(5666, 12722,_R)

        end



        if myHero.x<=8004+self.R.range and myHero.x>=8004-self.R.range and  myHero.z<=11782+self.R.range and myHero.z>=11782-self.R.range then
            CastSpellToPos(8004,11782,_R)

        end



        if myHero.x<=9194+self.R.range and myHero.x>=9194-self.R.range and  myHero.z<=11368+self.R.range and myHero.z>=11368-self.R.range then
            CastSpellToPos(9194,11368,_R)

        end



        if myHero.x<=8280+self.R.range and myHero.x>=8280-self.R.range and  myHero.z<=10254+self.R.range and myHero.z>=10254-self.R.range then
            CastSpellToPos(8280, 10254,_R)

        end



        if myHero.x<=6728+self.R.range and myHero.x>=6728-self.R.range and  myHero.z<=11450+self.R.range and myHero.z>=11450-self.R.range then
            CastSpellToPos(6728, 11450,_R)

        end



        if myHero.x<=5980+self.R.range and myHero.x>=5980-self.R.range and  myHero.z<=11150+self.R.range and myHero.z>=11150-self.R.range then
            CastSpellToPos(5980, 11150,_R)

        end



        if myHero.x<=6242+self.R.range and myHero.x>=6242-self.R.range and  myHero.z<=10270+self.R.range and myHero.z>=10270-self.R.range then
            CastSpellToPos(6242, 10270,_R)

        end



        if myHero.x<=6484+self.R.range and myHero.x>=6484-self.R.range and  myHero.z<=8380+self.R.range and myHero.z>=8380-self.R.range then
            CastSpellToPos(6484, 8380,_R)

        end



        if myHero.x<=8380+self.R.range and myHero.x>=8380-self.R.range and  myHero.z<=6502+self.R.range and myHero.z>=6502-self.R.range then
            CastSpellToPos(8380, 6502,_R)

        end



        if myHero.x<=9099.75+self.R.range and myHero.x>=9099.75-self.R.range and  myHero.z<= 7376.637+self.R.range and myHero.z>= 7376.637-self.R.range then
            CastSpellToPos(9099.75,  7376.637,_R)

        end



        if myHero.x<=7376+self.R.range and myHero.x>=7376-self.R.range and  myHero.z<=8802+self.R.range and myHero.z>=8802-self.R.range then
            CastSpellToPos(7376, 8802,_R)

        end



        if myHero.x<=5776+self.R.range and myHero.x>=5776-self.R.range and  myHero.z<=7402+self.R.range and myHero.z>=7402-self.R.range then
            CastSpellToPos(5776, 7402,_R)

        end



        if myHero.x<=7602+self.R.range and myHero.x>=7602-self.R.range and  myHero.z<=5928+self.R.range and myHero.z>=5928-self.R.range then
            CastSpellToPos(7602, 5928,_R)

        end



        if myHero.x<=9372+self.R.range and myHero.x>=9372-self.R.range and  myHero.z<=5674+self.R.range and myHero.z>=5674-self.R.range then
            CastSpellToPos(9372, 5674,_R)

        end



        if myHero.x<=10148+self.R.range and myHero.x>=10148-self.R.range and  myHero.z<=4801.52+self.R.range and myHero.z>=4801.52-self.R.range then
            CastSpellToPos(10148, 4801.525,_R)

        end



        if myHero.x<=9772+self.R.range and myHero.x>=9772-self.R.range and  myHero.z<=6458+self.R.range and myHero.z>=6458-self.R.range then
            CastSpellToPos(9772, 6458,_R)

        end



        if myHero.x<=9938+self.R.range and myHero.x>=9938-self.R.range and  myHero.z<=7900+self.R.range and myHero.z>=7900-self.R.range then
            CastSpellToPos(9938, 7900,_R)

        end



        if myHero.x<=11465+self.R.range and myHero.x>=11465-self.R.range and  myHero.z<=7157.772+self.R.range and myHero.z>=7157.772-self.R.range then
            CastSpellToPos(11465, 7157.772,_R)

        end



        if myHero.x<=12481+self.R.range and myHero.x>=12481-self.R.range and  myHero.z<=5232.559+self.R.range and myHero.z>=5232.559-self.R.range then
            CastSpellToPos(12481, 5232.559,_R)

        end



        if myHero.x<=11266+self.R.range and myHero.x>=11266-self.R.range and  myHero.z<=5542+self.R.range and myHero.z>=5542-self.R.range then
            CastSpellToPos(11266,5542,_R)

        end



        if myHero.x<=11290+self.R.range and myHero.x>=11290-self.R.range and  myHero.z<=8694+self.R.range and myHero.z>=8694-self.R.range then
            CastSpellToPos(11290, 8694,_R)

        end



        if myHero.x<=12676+self.R.range and myHero.x>=12676-self.R.range and  myHero.z<=7310.818+self.R.range and myHero.z>=7310.818-self.R.range then
            CastSpellToPos(12676, 7310.818,_R)

        end



        if myHero.x<=12022+self.R.range and myHero.x>=12022-self.R.range and  myHero.z<=4801.52+self.R.range and myHero.z>=4801.52-self.R.range then
            CastSpellToPos(12022, 4801.525,_R)

        end




        -------------------------



        if myHero.x<=6544+self.R.range and myHero.x>=6544-self.R.range and  myHero.z<=4732+self.R.range and myHero.z>=4732-self.R.range then
            CastSpellToPos(6544, 4732,_R)

        end



        if myHero.x<=5576+self.R.range and myHero.x>=5576-self.R.range and  myHero.z<=3512+self.R.range and myHero.z>=3512-self.R.range then
            CastSpellToPos(5576, 3512,_R)

        end



        if myHero.x<=6888+self.R.range and myHero.x>=6888-self.R.range and  myHero.z<=3082+self.R.range and myHero.z>=3082-self.R.range then
            CastSpellToPos(6888, 3082,_R)

        end



        if myHero.x<=8070+self.R.range and myHero.x>=8070-self.R.range and  myHero.z<=3472+self.R.range and myHero.z>=3472-self.R.range then
            CastSpellToPos(8070, 3472,_R)

        end



        if myHero.x<=8594+self.R.range and myHero.x>=8594-self.R.range and  myHero.z<=4668+self.R.range and myHero.z>=4668-self.R.range then
            CastSpellToPos(8594,4668,_R)

        end



        if myHero.x<=10388+self.R.range and myHero.x>=10388-self.R.range and  myHero.z<=3046+self.R.range and myHero.z>=3046-self.R.range then
            CastSpellToPos(10388, 3046,_R)

        end



        if myHero.x<=9160+self.R.range and myHero.x>=9160-self.R.range and  myHero.z<=2122+self.R.range and myHero.z>=2122-self.R.range then
            CastSpellToPos(9160,2122,_R)

        end

        ----------------------------


        if myHero.x<=12518+self.R.range and myHero.x>=12518-self.R.range and  myHero.z<=1504+self.R.range and myHero.z>=1504-self.R.range then
            CastSpellToPos(12518,1504,_R)

        end



        if myHero.x<=13404+self.R.range and myHero.x>=13404-self.R.range and  myHero.z<=2482+self.R.range and myHero.z>=2482-self.R.range then
            CastSpellToPos(13404,2482,_R)

        end



        if myHero.x<=11854+self.R.range and myHero.x>=11854-self.R.range and  myHero.z<=3922+self.R.range and myHero.z>=3922-self.R.range then
            CastSpellToPos(11854, 3922,_R)

        end



    end
    if self.RT then
        self:RecallTracker(self.your_enemies)

    end

end


function Teeto:makeCombo(Target)
--todo: add checking ADC

    if  self.Smart_Q and self:GetADC(Target)  and self.combo_Q then
        CastSpellTarget(Target,_Q)

    end

    if  self.combo_Q and  self.Smart_Q==false then
        CastSpellTarget(Target,_Q)

    end




    if GetType(Target)==0 and self.combo_W then
        CastSpellTarget(myHero.Addr,_W)
    end



    if self.combo_R and (self.ShroomStacks_combo<= myHero.StackSpell(_R)) then

        later=GetTimeGame()
        self.deltashroom=later-self.nowhshroom

        if self.deltashroom >=2.0 then


            CastSpellToPredictionPos(Target, _R, self.R.range)

            --end
            self.deltashroom=0
            self.nowhshroom=later
        end
    end






end


function Teeto:makeHarras(Target)

    if self.harras_Q and myHero.MP>=self.Q_mana_Harras then

        CastSpellTarget(Target,_Q)

    end



    if GetType(Target)==0 and self.harras_W and myHero.MP>=self.W_mana_Harras then
        CastSpellTarget(myHero.Addr,_W)

    end



    if self.harras_R and myHero.MP>=self.R_mana_Harras and myHero.StackSpell(_R)>= self.ShroomStacks_harras then

        later=GetTimeGame()
        self.deltashroom=later-self.nowhshroom

        if self.deltashroom >=2.0 then
        CastSpellToPredictionPos(Target, _R, self.R.range)
            --end
            self.deltashroom=0
            self.nowhshroom=later
        end
    end









end

function Teeto:makeLaneClear()

    if
    (GetType(GetTargetOrb()) == 1)
            --and (GetTargetOrb().HP<=GetDamage("Q", GetTargetOrb()))
    then


  --      CastSpellTarget(GetUnit(GetTargetOrb()).Addr,_Q)
  --          CastSpellToPredictionPos(GetUnit(GetTargetOrb()).Addr, _R, self.R.range)

    end
        end



function Teeto:makeJungleClear()

    if
    (GetType(GetTargetOrb()) == 3)
    then

        if self.JgClear_Q and myHero.MP>= self.Q_mana_JC then
            CastSpellTarget(GetUnit(GetTargetOrb()).Addr,_Q)

            end




        if self.JgClear_R and myHero.MP>= self.R_mana_JC and myHero.StackSpell(_R) >= self.ShroomStacks_JC then

        later=GetTimeGame()
        self.deltashroom=later-self.nowhshroom

        if self.deltashroom >=2.0 then

            CastSpellToPredictionPos(GetUnit(GetTargetOrb()).Addr, _R, self.R.range)
            --
            self.deltashroom=0
            self.nowhshroom=later
        end
        end



    end

end



function   Teeto:MakeFlee()
    MoveToPos(GetMousePosX(),GetMousePosZ())

    if self.Flee_W and myHero.MP >= self.W_mana_Flee then
    CastSpellTarget(myHero.Addr,_W)

    end
if self.Flee_items and self.Item1 then
    CastSpellTargetByName(myHero.Addr,"ItemSoFBoltSpellBase")
    CastSpellToPos(GetMousePosX(), GetMousePosZ(),GetSpellIndexByName("ItemSoFBoltSpellBase"))
end

    --TODO: item usage
end


function Teeto:GetEnemies()
    enemy_champs = {}

    for i,j in pairs(self:GetHeroes()) do
        if IsEnemy(j) and IsChampion(j) then
            table.insert(enemy_champs, j)

        end
    end

    return enemy_champs
end

--------------------------------------
function Teeto:AllADC()
ADCtable={ "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Jhin","Jinx","Kai'Sa", "Kalista",
           "KogMaw", "Lucian", "MissFortune", "Mordekaiser","Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Urgot", "Varus",
           "Vayne","Xayah"}
    return ADCtable
end

--------------------------------------

function Teeto:GetADC(target)

found=false
        for k2,v2 in pairs(self:AllADC()) do

            if (GetAIHero(target).CharName)==v2 then
                found=true
            end

        end



return found

    end



function Teeto:GetHeroes()
    SearchAllChamp()
    local t = pObjChamp
    return t
end


function Teeto:OnCreateObject(obj)


        if string.find(obj.Name, "TeemoRCast") then
            __PrintTextGame('found')


        end

end

function Teeto:OnDeleteObject(obj)


end





function Teeto:OnVision(unit, state)
    local hero = GetAIHero(unit)

    if state == true and self.NoVision[hero.NetworkId] ~= nil then
        self.NoVision[hero.NetworkId] = nil
    end
    if state == false and self.NoVision[hero.NetworkId] == nil then
        self.NoVision[hero.NetworkId] = hero
        self.LastSeenTime[hero.NetworkId] = math.floor(GetTimeGame())
        self.lastpos[hero.NetworkId] = Vector(hero.x,hero.y,hero.z)

    end
end



function Teeto:circles()



        for i,v in pairs(self:GetEnemies()) do

            local un = GetAIHero(v)
            if self.NoVision[un.NetworkId] ~= nil and not un.IsDead  then

                local ntime = math.floor(GetTimeGame())
                local ltime = self.LastSeenTime[un.NetworkId]
                local totaltime = ntime - ltime
                local moveSpeed = un.MoveSpeed
                local circleSize = moveSpeed * totaltime





                if self.recalled[i] then

                    self.recalled[i]=false
                    if un.TeamId == 100 then
                        self.lastpos[un.NetworkId] = Vector(410,182,422)
                        totaltime=0
                        self.LastSeenTime[un.NetworkId] = GetTimeGame()
                    elseif un.TeamId == 200 then
                        self.lastpos[un.NetworkId] = Vector(14298,171,14378)

                        totaltime=0

                        self.LastSeenTime[un.NetworkId] = GetTimeGame()
                    end







                end
                if un.IsDead then
                    if un.TeamId == 100 then
                        self.lastpos[un.NetworkId] = Vector(410,182,422)
                        totaltime=0
                        self.LastSeenTime[un.NetworkId] = GetTimeGame()
                    elseif un.TeamId == 200 then
                        self.lastpos[un.NetworkId] = Vector(14298,171,14378)

                        totaltime=0

                        self.LastSeenTime[un.NetworkId] = GetTimeGame()
                    end


                end
                local lastp = self.lastpos[un.NetworkId]
                local a,b = WorldToMiniMap(lastp.x,lastp.y,lastp.z)
                DrawTextD3DX(a - 10 ,b - 4,un.CharName,self.colours[i],2)
                DrawTextD3DX(a - 10 ,b - 2,"___",self.colours[i],2)

                local herov = Vector(lastp.x,lastp.y,lastp.z)
                if totaltime <= 40  then
                    DrawCircleMiniMap(herov.x,herov.y,herov.z,circleSize)

                end






            end

        end







end





function Teeto:RecallTracker(enemies)


    for i,j in pairs(enemies) do

        if GetAIHero(j).IsRecall then
            if self.onetimetable[i]==false then
                __PrintTextGame("<b><font color=\"#ffffff\">HINT: ".."["..string.format("%02.2f",GetTimeGame()/60)..'] '..GetAIHero(j).CharName..' is recalling  ' .."</font></b> ")
                self.onetimetable[i]=true
            end
            later=GetTimeGame()
            self.delta[i]=later-self.now[i]

            if  self.delta[i] >=1.0 then
                self.counter[i]=self.counter[i]+1

                self.delta[i]=0
                self.now[i]=later
            end
        end



        if GetAIHero(j).IsRecall==false then

            if self.counter[i]<=7 and  self.counter[i] > 1 then
                __PrintTextGame("<b><font color=\"#ff0000\">HINT: ".."["..string.format("%02.2f",GetTimeGame()/60)..'] '..GetAIHero(j).CharName..' recalling aborted'.."</font></b> " )

                self.counter[i]=0
                self.onetimetable[i]=false


                end
            if  self.counter[i]>=8 then
                __PrintTextGame("<b><font color=\"#00ff00\">HINT: ".."["..string.format("%02.2f",GetTimeGame()/60)..'] '..GetAIHero(j).CharName..' recalling finished'.."</font></b> " )

                self.counter[i]=0
                self.onetimetable[i]=false

                self.recalled[i]=true
            end
            if  self.counter[i]==0 then
                self.onetimetable[i]=false

            end



        end



    end
end



function Teeto:advice(target)


    later=GetTimeGame()
    self.deltashroom=later-self.nowhshroom

    if self.deltashroom >=10.0 then






    if GetAIHero(target).CharName=="Aatrox" then
        __PrintTextGame("<b><font color=\"#32B92D\">HINT:Blind is OP against an AA only Champion.</font></b> ")

    end

      if GetAIHero(target).CharName=="Darius" then
        __PrintTextGame("<b><font color=\"#32B92D\">HINT:Kite him and you are fine.Don't get too close , If he takes phase rush and ghost you can hug your turret.</font></b> ")

    end

      if GetAIHero(target).CharName=="Dr. Mundo" then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:Punish him early, in late he is just a never dying Champ.</font></b> ")

    end

      if GetAIHero(target).CharName=="Ekko" then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:Blind his E AA and you can avoid 50% od his damage</font></b> ")

    end

      if GetAIHero(target).CharName=="Gangplank" then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:He is weak early. Destroy his Barrles and just kill him.</font></b> ")

    end

      if GetAIHero(target).CharName=="Kayle" then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:Blind is OP against an AA only Champion.</font></b> ")

    end

      if GetAIHero(target).CharName== "Kennen" then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:Blind is OP against an AA only Champion.But if he bilds AP you have to dodge his Q or you have a problem.</font></b> ")

    end

      if GetAIHero(target).CharName=='Kled' then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:Blind his W  and you are good to go.</font></b> ")

    end

      if GetAIHero(target).CharName== 'Nasus'then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:Punish him early, if he reaches late its too late.</font></b> ")

    end

      if GetAIHero(target).CharName=="Swain" then
        __PrintTextGame("<b><font color=\"#32B92D \">HINT:You cant kill Swain, just farm.</font></b> ")

    end

      if GetAIHero(target).CharName=="Akali" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:She has a lot of Burst.</font></b> ")

    end

      if GetAIHero(target).CharName=="Cho'Gath" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:Punish him early, in late he is just a never dying Champ.</font></b> ")

    end

      if GetAIHero(target).CharName=="Garen" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:You can Bling his Q but he will still kill you after level 6.</font></b> ")

    end

      if GetAIHero(target).CharName=="Gnar" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:Keep an eye on his Passive </font></b> ")

    end

      if GetAIHero(target).CharName=="Illaoi" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:Too much to dodge: Q-E-R</font></b> ")

    end

      if GetAIHero(target).CharName=="Irelia" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:She has a lot of Burst</font></b> ")

    end

      if GetAIHero(target).CharName=="Jax" then
        __PrintTextGame("<b><font color=\"#FFDE00\">".."HINT:You are stronger in early, abuse it before it's too late".." .</font></b> ")

    end

      if GetAIHero(target).CharName=="Malphite" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:Punish him early, in late he is just a never dying Champ.</font></b> ")

    end

      if GetAIHero(target).CharName=="Maokai" then
        __PrintTextGame("<b><font color=\"#FFDE00\">HINT:Punish him early, in late he is just a never dying Champ.</font></b> ")

    end

      if GetAIHero(target).CharName=="Fiora" then
        __PrintTextGame("<b><font color=\"#FF0000 \">HINT:If she knows how to play this Matchup you are rekt. Ban Fiora in champselect.</font></b> ")

    end

      if GetAIHero(target).CharName=='Heimerdinger' then
        __PrintTextGame("<b><font color=\"#FF0000 \">HINT:He bullies you out of lane, just try to farm.</font></b> ")

    end
    if GetAIHero(target).CharName=='Jayce' then
        __PrintTextGame("<b><font color=\"#FF0000 \">HINT:Try to farm, he bullies you out of lane.</font></b> ")

    end
    if GetAIHero(target).CharName=='Sion' then
        __PrintTextGame("<b><font color=\"#FF0000 \">HINT:Dodge his Q.</font></b> ")

    end
    if GetAIHero(target).CharName=='Talon' then
        __PrintTextGame("<b><font color=\"#FF0000 \">HINT:If you are losing ,Rush armor.</font></b> ")

    end
    if GetAIHero(target).CharName=='Pantheon' then
        __PrintTextGame("<b><font color=\"#FF0000 \">HINT:If you are losing ,Rush armor.</font></b> ")

    end



        self.deltashroom=0
        self.nowhshroom=later
    end

end






