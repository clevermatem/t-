IncludeFile("Lib\SDK.lua")
class "Singed"
local version = 0.1
local developer="Pinggin_friend"
function OnLoad()

    if GetChampName(GetMyChamp()) == "Singed" then
        __PrintTextGame("")
        __PrintTextGame("<b><font size=\"40\" color=\"#ffffff\">Singed</font></b>".."<b><font size=\"20\" color=\"#ffffff\"> ON </font></b>".."<b><font size=\"40\" color=\"#ffffff\">DUTY</font></b>".."<font size=\"20\" color=\"#ff0000\">v0.1</font>")
        __PrintTextGame("<b><font color=\"#ffffff\">_______By: Pinggin_friend_________</font></b> ")
        __PrintTextGame("")
        __PrintTextGame("")

        Singed:__init()

    else
        __PrintTextGame("<b><font color=\"#ff0000\">Your Champion is not Teemo </font></b> " )

    end
end


function Singed:__init()



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
    self.Q = Spell({Slot = 0,SpellType =Enum.SpellType.Active,Range = 900})
    self.W = Spell({Slot = 1,SpellType = Enum.SpellType.SkillShot,range=1000,SkillShotType = Enum.SkillShotType.Circle})
    self.E = Spell({Slot = 2,SpellType = Enum.SpellType.Targetted})
    self.R = Spell({Slot = 3,SpellType =Enum.SpellType.Active})

    self.NoVision = {}
    self.LastSeenTime = {}
    self.recalled={false,false,false,false,false}
    self.colours = {Lua_ARGB(255,255,255,255),Lua_ARGB(255,0,255,0),Lua_ARGB(255,255,76,59),Lua_ARGB(255,0,114,187),Lua_ARGB(255,255,208,52)}
    self.langauge=GetCurrentLanguage()
    self.lastpos = {}
    self.casted=false
    self.circleSize=0

    self.onetimetable={false,false,false,false,false}
    self.Q:SetTargetted(0.5, 1500)
    self.W:SetActive()
    self.W:SetSkillShot(0.5, 0, 175,false)

    Callback.Add("Tick", function() self:OnTick() end)
    Callback.Add("Draw", function(...) self:OnDraw(...) end)
    Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
    Callback.Add("UpdateBuff", function(...) self:OnUpdateBuff(...) end)
    Callback.Add("RemoveBuff", function(...) self:OnRemoveBuff(...) end)
    Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)

    self.deltashroom=0
    self.nowhshroom=0
    self.delta={0,0,0,0,0}
    self.now ={GetTimeGame(),GetTimeGame(),GetTimeGame(),GetTimeGame(),GetTimeGame()}
    self.counter={0,0,0,0,0}

    self.your_enemies=self:GetEnemies()


    AddEvent(Enum.Event.OnTick, function(...) self:OnTick(...) end)

    AddEvent(Enum.Event.OnProcessSpell, function(...) self:OnProcessSpell(...) end)

    self:SetDefault()


end











function Singed:MenuBool(stringKey, bool)
    return ReadIniBoolean(self.menu, stringKey, bool)
end

function Singed:MenuSliderInt(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Singed:MenuSliderFloat(stringKey, valueDefault)
    return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Singed:MenuComboBox(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Singed:MenuKeyBinding(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end





function Singed:OnDraw()






    --disable all draws
    if not self.draw_All then


        --Draw autoattack range
        if self.draw_AA then
            local aa_range = Vector(myHero)

            DrawCircleGame(aa_range.x , aa_range.y, aa_range.z, GetAttackRange(GetMyChamp())+135, Lua_ARGB(255,255,255,255))
        end
        --Draw W range
        if self.W:IsReady() and self.draw_W then
            local posW = Vector(myHero)
            DrawCircleGame(posW.x , posW.y, posW.z, self.W.range+140, Lua_ARGB(255,0,255,0))


        end




--draw important shroom places



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








function Singed:SetDefault()
    self.menu = "Singed_on_DUTY"

    --Combo

    --harras


    --JgClear

    --flee

    --KeyBindings
    self.Combo = self:MenuKeyBinding("Combo", 32)
    self.Harass = self:MenuKeyBinding("Harass", 31)
    self.Last_Hit = self:MenuKeyBinding("Last Hit", 30)
    self.LaneClear = self:MenuKeyBinding("Lane Clear", 33)
    self.JungleClear = self:MenuKeyBinding("Jungle Clear", 34)
    self.Flee = self:MenuKeyBinding("Flee", 165)

    --Miscellaneous

    ---Draw
    self.draw_All = self:MenuBool("Disable all drawings", true)
    self.draw_AA = self:MenuBool("Draw AA Range", true)
    self.draw_enemy_AA = self:MenuBool("Draw  enemy_AA Range", true)
    self.draw_W = self:MenuBool("Draw W Range", true)

    --GameAssistance
    self.RT = self:MenuBool("Activate recall tracker?", true)
    self.MMDRAWS = self:MenuBool("Activate MiniMap drawings?", true)
    self.EARLYHINT = self:MenuBool("Activate early hints?", true)






end







--Draw Main section in menu and set defaults----------------------------------------------------------------------------
function Singed:OnDrawMenu()
    if Menu_Begin(self.menu) then

        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][1]) then

            self.draw_All = Menu_Bool("Disable all drawings", self.draw_All, self.menu)

            Menu_Separator()
            if self.draw_All==false then
                self.draw_AA = Menu_Bool("Draw AA  Range", self.draw_AA, self.menu)
                self.draw_enemy_AA = Menu_Bool("Draw enemy_AA  Range", self.draw_enemy_AA, self.menu)
                self.draw_W = Menu_Bool("Draw W Range", self.draw_W, self.menu)

            end

            Menu_End()
        end


        Menu_Separator()

        ---Combo

        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][2]) then

            Menu_End()
        end
        Menu_Separator()

        --Harras
        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][3]) then



            Menu_End()
        end
        Menu_Separator()






        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][5]) then



            Menu_End()
        end
        Menu_Separator()






        if Menu_Begin(self.languagetab[GetCurrentLanguage()+1][6]) then


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






function Singed:OnTick()
    if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
--autoshrooms


    local Targetfar = GetTargetSelector(1500, 0)
    local Targetneaer = GetTargetSelector(300, 0)

    if GetKeyPress(self.Combo) > 0   then
        self:makeCombo(Targetfar,Targetneaer)



    end
    if GetKeyPress(self.Harass) > 0   then
       self:makeHarras(Target)

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

    if self.RT then
        self:RecallTracker(self.your_enemies)

    end

end


function Singed:makeCombo(targetfar,Targetnear)
    sf=GetAIHero(targetfar)
    sn=GetAIHero(Targetnear)




    if   GetEnemyChampNearest(1000) ~=0 and self.casted==false then
        CastSpellTarget(myHero.Addr,_Q)
        self.casted=true
    end

    if   GetEnemyChampNearest(1000) ==0 and self.casted==true then
        CastSpellTarget(myHero.Addr,_Q)
        self.casted=false
    end




    if myHero.CanCast(_W) then
        CastSpellToPredictionPos(sf.Addr,_W,1000)


    end


    if  myHero.CanCast(_E) then
        CastSpellTarget(sn.Addr,_E)


    end







end


function Singed:makeHarras(Target)










end

function Singed:makeLaneClear()

    if
    (GetType(GetTargetOrb()) == 1)
            --and (GetTargetOrb().HP<=GetDamage("Q", GetTargetOrb()))
    then


  --      CastSpellTarget(GetUnit(GetTargetOrb()).Addr,_Q)
  --          CastSpellToPredictionPos(GetUnit(GetTargetOrb()).Addr, _R, self.R.range)

    end
        end



function Singed:makeJungleClear()

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



function   Singed:MakeFlee()
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


function Singed:GetEnemies()
    enemy_champs = {}

    for i,j in pairs(self:GetHeroes()) do
        if IsEnemy(j) and IsChampion(j) then
            table.insert(enemy_champs, j)

        end
    end

    return enemy_champs
end

--------------------------------------
-------------------------------


function Singed:GetHeroes()
    SearchAllChamp()
    local t = pObjChamp
    return t
end


function Singed:OnCreateObject(obj)




end

function Singed:OnDeleteObject(obj)


end





function Singed:OnVision(unit, state)
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



function Singed:circles()



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





function Singed:RecallTracker(enemies)


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



