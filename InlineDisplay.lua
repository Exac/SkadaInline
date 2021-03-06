--
-- Created by IntelliJ IDEA.
-- User: Thomas
-- Date: 4/16/16
-- Time: 20:44
-- To change this template use File | Settings | File Templates.
--

--print("InlineDisplay.lua")

local L = LibStub("AceLocale-3.0"):GetLocale("Skada", false) --localization
local Skada = Skada
local mod = Skada:NewModule("InlineBarDisplay")

mybars = {}
mybars[1] = {}
mybars[1].uuid = 1
mybars[1].bg = CreateFrame("Frame", "bg"..mybars[1].uuid, UIParent)
mybars[1].label = mybars[1].bg:CreateFontString("label"..mybars[1].uuid)
mybars[1].value = 0

si = mod
mod.wew = "lad"
--local libwindow = LibStub("LibWindow-1.1")
local media = LibStub("LibSharedMedia-3.0")

local window = {frame = {fstitle={SetText = function() end}}}

mod.name = "Inline Bar Display"
Skada.displays["inline"] = mod

if Skada == nil then
    return
end

function mod:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SkadaInlineDB") --matches SkadaInline.toc SavedVariables
end

function mod:Create(window)
    if not window.frame then
        window.frame = window.bargroup
        window.frame = CreateFrame("Frame", window.db.name.."InlineFrame", UIParent)
        window.frame.win = window
        window.frame:SetMovable(false)
        window.frame:SetFrameLevel(5)
        if window.db.barheight==15 then window.db.barheight = 23 end--TODO: Fix dirty hack
        window.frame:SetHeight(window.db.barheight)
        window.frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -1, -1)
        window.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 1, -1)
        if window.db.background.color.a==51/255 then window.db.background.color = {r=255, b=250/255, g=250/255, a=1 } end

    end

    local barleft = 60--left title-margin
    window.frame.fstitle = window.frame:CreateFontString("frameTitle", 6)
    window.frame.fstitle:SetTextColor(window.db.title.color.r,window.db.title.color.g,window.db.title.color.b,window.db.title.color.a)
    --window.frame.fstitle:SetTextColor(255,255,255,1)
    window.frame.fstitle:SetFont([[Interface\AddOns\SkadaInline\media\fonts\PT_Sans_Narrow.ttf]], 10, nil)
    window.frame.fstitle:SetText(window.metadata.title or "Skada")
    window.frame.fstitle:SetText(temptitle)
    window.frame.fstitle:SetWordWrap(false)
    window.frame.fstitle:SetJustifyH("LEFT")
    window.frame.fstitle:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", barleft, -1)
    window.frame.fstitle:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", 280, -1)
    window.frame.fstitle:SetHeight(window.db.barheight or 23)

    window.frame.barstartx = barleft + window.frame.fstitle:GetWidth()


    window.frame.win = window

    db = self.db
    win = window
end

function mod:Destroy(win)
    win.frame:Hide()
    win.frame = nil
end

function mod:Wipe(win) end

function mod:SetTitle(win, title)
    win.frame.fstitle:SetText(title)
end

barlibrary = {} --TODO: make local
barlibrary.bars = {}
--barlibrary.bars[1] = {}
--barlibrary.bars[1].uuid = 1
--barlibrary.bars[1].inuse = false
--barlibrary.bars[1].barid = ""
--barlibrary.bars[1].bg = CreateFrame("Frame", "bg"..barlibrary.bars.uuid, window.frame)
--barlibrary.bars[1].label = barlibrary.bars[1].bg:CreateFontString("label"..barlibrary.bars[1].uuid)

--[[    {
        uuid = 1,
        inuse = false,
        barid = "",
        bg = CreateFrame("Frame", "bg1", UIParent),
        --label = self.bg:CreateFontString("label2",6),
    },
    {
        uuid = 2,
        inuse = false,
        barid = "",
        bg = CreateFrame("Frame", "bg2", UIParent),
        --label = self.bg:CreateFontString("label1",6),
    }
}]]

function barlibrary:Deposit (_bar)
    --strip the bar of variables
    _bar.inuse = false
    _bar.bg:Hide()
    _bar.value = 0
    _bar.label:Hide()
    _bar.label:SetFont([[Interface\AddOns\SkadaInline\media\fonts\PT_Sans_Narrow.ttf]], 10, nil)
    _bar.label:SetText("")
    --place it at the front of the queue
    table.insert(barlibrary.bars, 1, _bar)
    --print("Depositing bar.uuid", _bar.uuid)
end

function barlibrary:Withdraw ()--TODO: also pass parent and assign parent

    if #barlibrary.bars < 2 then
        --if barlibrary is empty, create a new bar to replace this bar
        local replacement = {}
        if #barlibrary.bars < 2 then
            replacement.uuid = barlibrary.bars[#barlibrary.bars].uuid + 1
        else
            replacement.uuid = 1
            print("THIS SHOULD NEVER HAPPEN")
        end
        replacement.bg = CreateFrame("Frame", "bg"..replacement.uuid, UIParent)
        replacement.label = replacement.bg:CreateFontString("label"..replacement.uuid)
        replacement.label:SetJustifyH("LEFT")
        replacement.value = 0
        --add the replacement bar to the end of the bar library
        table.insert(barlibrary.bars, replacement)
    end
    --mark the bar you will give away as in use & give it a barid
    barlibrary.bars[1].inuse = false
    barlibrary.bars[1].value = 0
    barlibrary.bars[1].label:SetJustifyH("LEFT")
    barlibrary.bars[1].label:SetFont([[Interface\AddOns\SkadaInline\media\fonts\PT_Sans_Narrow.ttf]], 10, nil)
    barlibrary.bars[1].label:SetText("")
    --remove the first bar from the table and return it
    --[[print("Withdrawing bar.uuid", barlibrary.bars[1].uuid, "from the following table:", serial(barlibrary.bars))]]
    return table.remove(barlibrary.bars, 1)
end

function mod:RecycleBar(_bar)
    --Example usage: for k,v in pairs(mybars) do mod:RecycleBar(table.remove(mybars, k)) end
    _bar.label:SetFont([[Interface\AddOns\SkadaInline\media\fonts\PT_Sans_Narrow.ttf]], 10, nil)
    _bar.label:SetText("")
    _bar.value = 0
    --hide stuff
    _bar.label:Hide()
    _bar.bg:Hide()
    barlibrary:Deposit(_bar)
end

function mod:GetBar()
    return barlibrary:Withdraw()
end

function mod:UpdateBar(bar, bardata, db)
    --[[
    --bar.uuid: number
    --bar.bg: userdata(FRAME)
    --bar.label: userdata(FONTSTRING)
    --bar.value: number
    --bardata.label: string ex:"Exac"
    --bardata.valuetext: string ex:"89.4K (8.1K)"
    --bardata.value: number ex:89410
    --bardata.class: string ex:"PALADIN"
    ]]
    --[[print("")
    print("type(bar):", type(bar), "type(bardata):", type(bardata), "bar[]:", serial(bar), "bardata:", serial(bardata))
    bar.value = 1
    return bar]]
    local label = bardata.label
    if bardata.valuetext then
        label = label.." - "
        label = label..bardata.valuetext
    end
    bar.label:SetFont(db.barfont, db.barfontsize, db.barfontflags)
    bar.label:SetText(label)
    --bar.label:SetTextColor(db.title.color.r,db.title.color.g,db.title.color.b,db.title.color.a)
    bar.value = bardata.value

    return bar
end

function mod:Update(win)
    wd = win.dataset

    --TODO: Only if the number of bars changes
    --delete any current bars
    --TODO:Fix this. If the loop isn't run many times mybars isn't emptied. Fix the key, k
    for k,v in pairs(mybars) do
        --print(serial(mybars),#mybars, k, v)
        mod:RecycleBar(table.remove(mybars, k))
    end
    for k,v in pairs(mybars) do
        --print(serial(mybars),#mybars, k, v)
        mod:RecycleBar(table.remove(mybars, k))
    end
    for k,v in pairs(mybars) do
        --print(serial(mybars),#mybars, k, v)
        mod:RecycleBar(table.remove(mybars, k))
    end
    for k,v in pairs(mybars) do
        --print(serial(mybars),#mybars, k, v)
        mod:RecycleBar(table.remove(mybars, k))
    end
    for k,v in pairs(mybars) do
        --print(serial(mybars),#mybars, k, v)
        mod:RecycleBar(table.remove(mybars, k))
    end
    --print("#barlibrary.bars:", #barlibrary.bars, "#mybars:", #mybars)
    --print(#mybars)
    --add new bars and update bar info
    for k,bardata in pairs(win.dataset) do
        --Update a fresh bar
        local _bar = mod:GetBar()
        table.insert(mybars, mod:UpdateBar(_bar, bardata, win.db))
    end

    --sort bars
    table.sort(mybars, function (bar1, bar2)
            if not bar1 or bar1.value==nil then
                return false
            elseif not bar2 or bar2.value==nil then
                return true
            else
                return bar1.value > bar2.value
            end
    end)

    local left = win.frame.barstartx + 15
    for key, bar in pairs(mybars) do
        --set bar positions
        --TODO
        --bar.texture:SetTexture(255, 0, 0, 1.00)
        bar.bg:SetFrameLevel(9)
        bar.bg:SetHeight(23)
        bar.bg:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, -1)
        bar.label:SetHeight(23)
        bar.label:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, -1)
        --increment left value
        left = left + bar.label:GetStringWidth()
        left = left + 15
        --show bar
        bar.bg:Show()
        bar.label:Show()
    end




    --[[
    local nr = 1
    for i, data in pairs(win.dataset) do
        if data.id then
            local barid = data.id
            local barlabel = data.label

            local bar = mod:GetBar(barid)
            table.insert(mybars, bar)
        end
    end
    for key, data in pairs(mybars) do
        barlibrary:Deposit(table.remove(mybars, key))
    end]]


    -- If we are using "wipestale", remove all unchecked bars.
    --...

    --[[ Sort by the order in the data table if we are using "ordersort".
    if win.metadata.ordersort then
        win.bargroup:SetSortFunction(bar_order_sort)
        win.bargroup:SortBars()
    else
        win.bargroup:SetSortFunction(nil)
        win.bargroup:SortBars()
    end]]
    si = mod
end

function mod:AnchorMoved(cbk, group, x, y) end

function mod:WindowResized(cbk, group) end

function mod:Show(win) end

function mod:Hide(win) end

function mod:IsShown(win) end

function mod:OnMouseWheel(win, frame, direction) end

function mod:CreateBar(win, name, label, maxValue, icon, o)
    print("mod:CreateBar():TODO")
    local bar = {}
    bar.win = win

    return bar
end

function mod:ApplySettings(win)
    local f = win.frame
    local p = win.db

    --
    --bars
    --
    f:SetHeight(p.barheight)
    f.fstitle:SetTextColor(p.title.color.r,p.title.color.g,p.title.color.b,p.title.color.a)
    f.fstitle:SetFont(p.title.fontpath or media:Fetch('font', p.barfont), p.barfontsize, p.barfontflags)
    for k,bar in pairs(mybars) do
        bar.label:SetFont(p.barfont,p.barfontsize,p.barfontflags )
        bar.label:SetTextColor(p.title.color.r,p.title.color.g,p.title.color.b,p.title.color.a)
    end

    --print("SetFont", p.barfont, p.barfontsize, p.barfontflags)

    --
    --background
    --
    local fbackdrop = {}
    fbackdrop.bgFile = media:Fetch("background", p.background.texture)
    if p.background.edgesize == nil then p.background.edgesize = 0 end
    if p.background.edgesize > 0 and p.background.bordertexture ~= "None" then
        fbackdrop.edgeFile = media:Fetch("border", p.background.bordertexture)
    else
        fbackdrop.edgeFile = nil
    end
    fbackdrop.tile = p.background.tile
    fbackdrop.tileSize = p.background.tilesize
    fbackdrop.edgeSize = p.background.edgesize
    fbackdrop.insets = { left = p.background.margin, right = p.background.margin, top = p.background.margin, bottom = p.background.margin }
    f:SetBackdrop(fbackdrop)
    f:SetBackdropColor(p.background.color.r,p.background.color.g,p.background.color.b,p.background.color.a)
    if p.background.strata then f:SetFrameLevel(5) end
    if p.background.strata then f:SetFrameStrata(p.background.strata) end

    --
    --ElvUI
    --
    if p.isusingelvuiskin and ElvUI then
        --bars
        f:SetHeight(p.barheight)
        f.fstitle:SetTextColor(255,255,255,1)        --local _r, _g, _b = unpack(ElvUI[1]["media"].rgbvaluecolor)
        f.fstitle:SetFont(ElvUI[1]["media"].normFont, p.barfontsize, nil)
        for k,bar in pairs(mybars) do
            bar.label:SetFont(ElvUI[1]["media"].normFont, p.barfontsize, nil)
            bar.label:SetTextColor(255,255,255,1)
        end

        --background
        fbackdrop = {}
        local borderR,borderG,borderB = unpack(ElvUI[1]["media"].bordercolor)
        local backdropR, backdropG, backdropB = unpack(ElvUI[1]["media"].backdropcolor)
        local backdropA = 0
        if p.issolidbackdrop then backdropA = 1.0 else backdropA = 0.8 end
        local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/(max(0.64, min(1.15, 768/GetScreenHeight() or UIParent:GetScale())))

        fbackdrop.bgFile = ElvUI[1]["media"].blankTex
        fbackdrop.edgeFile = ElvUI[1]["media"].blankTex
        fbackdrop.tile = false
        fbackdrop.tileSize = 0
        fbackdrop.edgeSize = mult
        fbackdrop.insets = { left = 0, right = 0, top = 0, bottom = 0 }
        f:SetBackdrop(fbackdrop)
        f:SetBackdropColor(backdropR, backdropG, backdropB, backdropA)
        f:SetBackdropBorderColor(borderR, borderG, borderB, 1.0)

    end

    --f:SortBars()
end

function mod:AddDisplayOptions(win, options)
    local db = win.db
    options.baroptions = {
        type = "group",
        name = "Data Display Options",
        order = 3,
        args = {
            height = {
                type = 'range',
                name = "Height",
                desc = "Height of the frame.\nDefault: 23",
                min=10,
                max=math.floor(GetScreenHeight()),
                step=1.0,
                get = function()
                    return db.barheight
                end,
                set = function(win,key)
                    db.barheight = key
                    Skada:ApplySettings()
                end,
                order=0.1,
            },
            color = {
                type="color",
                name="Font Color",
                desc="Font Color. \nClick 'class color' to begin.",
                hasAlpha=true,
                get=function()
                    local c = db.title.color
                    return c.r, c.g, c.b, c.a
                end,
                set=function(win, r, g, b, a)
                    db.title.color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or 1.0 }
                    if db.title.color.a==0.8 then db.title.color.a=100 end
                    Skada:ApplySettings()
                end,
                order=3.1,
            },
            barfont = {
                type = 'select',
                dialogControl = 'LSM30_Font',
                name = L["Bar font"],
                desc = L["The font used by all bars."],
                values = AceGUIWidgetLSMlists.font,
                get = function() return db.barfont end,
                set = function(win,key)
                    db.barfont = key
                    Skada:ApplySettings()
                end,
                order=1,
            },

            barfontsize = {
                type="range",
                name=L["Bar font size"],
                desc=L["The font size of all bars."],
                min=7,
                max=40,
                step=1,
                get=function() return db.barfontsize end,
                set=function(win, size)
                    db.barfontsize = size
                    Skada:ApplySettings()
                end,
                order=2,
            },

            barfontflags = {
                type = 'select',
                name = L["Font flags"],
                desc = L["Sets the font flags."],
                values = {[""] = L["None"], ["OUTLINE"] = L["Outline"], ["THICKOUTLINE"] = L["Thick outline"], ["MONOCHROME"] = L["Monochrome"], ["OUTLINEMONOCHROME"] = L["Outlined monochrome"]},
                get = function() return db.barfontflags end,
                set = function(win,key)
                    db.barfontflags = key
                    Skada:ApplySettings()
                end,
                order=3,
            },
        }
    }

    options.elvuioptions = {
        type = "group",
        name = "ElvUI",
        order = 4,
        args = {
            isusingelvuiskin = {
                type = 'toggle',
                name = "Use ElvUI skin if avaliable.",
                desc = "Check this to use ElvUI skin instead. \nDefault: checked",
                get = function() return db.isusingelvuiskin end,
                set = function(win,key)
                    db.isusingelvuiskin = key
                    Skada:ApplySettings()
                end,
                order=0.1,
            },
            issolidbackdrop = {
                type = 'toggle',
                name = "Use solid background.",
                desc = "Un-check this for an opaque background.",
                get = function() return db.issolidbackdrop end,
                set = function(win,key)
                    db.issolidbackdrop = key
                    Skada:ApplySettings()
                end,
                order=1.0,
            },
        },
    }

    options.frameoptions = { --window bg frame
        type = "group",
        name = "Background",--TODO: localize
        order = 2,
        args = {
            tile = {
                type = 'toggle',
                name = "Tile",
                desc = "Tile the background texture. \nDefault: un-checked",
                get = function() return db.background.tile end,
                set = function(win,key)
                    db.background.tile = key
                    Skada:ApplySettings()
                end,
                order=1.2,
            },

            tilesize = {
                type="range",
                name="Tile size",
                desc="The size of the texture pattern. \nDefault: 0",
                min=0,
                max=math.floor(GetScreenWidth()),
                step=1.0,
                get=function() return db.background.tilesize end,
                set=function(win, val)
                    db.background.tilesize = val
                    Skada:ApplySettings()
                end,
                order=1.1,
            },

            texture = {
                type = 'select',
                dialogControl = 'LSM30_Background',
                name = L["Background texture"],
                desc = "The texture used as the background. \nDefault: Solid",
                values = AceGUIWidgetLSMlists.background,
                get = function() return db.background.texture end,
                set = function(win,key)
                    db.background.texture = key
                    Skada:ApplySettings()
                end,
                order=1,
            },

            bordersize = {
                type="range",
                name="Border size",
                desc="The thickness of the borders. \nDefault: 0",
                min=0,
                max=100,
                step=0.05,
                get=function() return db.background.edgesize end,
                set=function(win, val)
                    db.background.edgesize = val
                    Skada:ApplySettings()
                end,
                order=3.1,
            },

            bordertexture = {
                type = 'select',
                dialogControl = 'LSM30_Border',
                name = "Border texture",
                desc = "The texture for the border. \nDefault: None",
                values = AceGUIWidgetLSMlists.border,
                get = function() return db.background.bordertexture end,
                set = function(win,key)
                    db.background.bordertexture = key
                    Skada:ApplySettings()
                end,
                order=3,
            },

            margin = {
                type="range",
                name=L["Margin"],
                desc="The margin between the outer edge and the background texture. \nDefault: 0",
                min=0,
                max=math.floor(23/2-1),
                step=0.5,
                get=function() return db.background.margin end,
                set=function(win, val)
                    db.background.margin = val
                    Skada:ApplySettings()
                end,
                order=1.3,
            },

            color = {
                type="color",
                name="Color",
                desc="Background Color. \nClick 'class color' to begin.",
                hasAlpha=true,
                get=function()
                    local c = db.background.color
                    return c.r, c.g, c.b, c.a
                end,
                set=function(win, r, g, b, a)
                    db.background.color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or 1.0 }
                    if db.background.color.a==0.2 then db.background.color.a=100 end
                    Skada:ApplySettings()
                end,
                order=0,
            },

            strata = {
                type="select",
                name="Strata",
                desc="This determines what other frames will be in front of the frame. \nDefault: LOW",
                values = {["BACKGROUND"]="BACKGROUND", ["LOW"]="LOW", ["MEDIUM"]="MEDIUM", ["HIGH"]="HIGH", ["DIALOG"]="DIALOG", ["FULLSCREEN"]="FULLSCREEN", ["FULLSCREEN_DIALOG"]="FULLSCREEN_DIALOG"},
                get=function() return db.background.strata end,
                set=function(win, val)
                    db.background.strata = val
                    Skada:ApplySettings()
                end,
                order=5,
            },


        }
    }
end

inline = mod