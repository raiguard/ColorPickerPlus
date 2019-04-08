debug = true
colors = {}

function Initialize()

    dofile(SKIN:MakePathAbsolute('Extra\\Scripts\\HSBLib.lua'))
    colors.scrubber_cursor_hue,colors.scrubber_cursor_sat = RGBtoHSB(SKIN:GetVariable('colorBorder'))
    SetRGB(SKIN:GetVariable('baseColor'))

end

function Update() end

function GetColor(key) return colors[key] or 0 end

function SetScrubbers()

    -- HSB
    colors.scrubber_hue_0 = string.format('%s,%s,%s', HSBtoRGB((0/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_hue_60 = string.format('%s,%s,%s', HSBtoRGB((1/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_hue_120 = string.format('%s,%s,%s', HSBtoRGB((2/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_hue_180 = string.format('%s,%s,%s', HSBtoRGB((3/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_hue_240 = string.format('%s,%s,%s', HSBtoRGB((4/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_hue_300 = string.format('%s,%s,%s', HSBtoRGB((5/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_hue_360 = string.format('%s,%s,%s', HSBtoRGB((6/6), colors.cur_sat, colors.cur_bri))
    colors.scrubber_sat_left = string.format('%s,%s,%s', HSBtoRGB(colors.cur_hue, 0, colors.cur_bri))
    colors.scrubber_sat_right = string.format('%s,%s,%s', HSBtoRGB(colors.cur_hue, 1, colors.cur_bri))
    colors.scrubber_bri_left = string.format('%s,%s,%s', HSBtoRGB(colors.cur_hue, colors.cur_sat, 0))
    colors.scrubber_bri_right = string.format('%s,%s,%s', HSBtoRGB(colors.cur_hue, colors.cur_sat, 1))
    colors.scrubber_cursor = string.format('%s,%s,%s', HSBtoRGB(colors.scrubber_cursor_hue, colors.scrubber_cursor_sat, (1 - Clamp(ColorLumens(string.format('%s,%s,%s', HSBtoRGB(colors.cur_hue, colors.cur_sat, colors.cur_bri))),45,50) / 100)))
    -- RGB
    colors.scrubber_r_left = string.format('%s,%s,%s', 0, colors.cur_g, colors.cur_b)
    colors.scrubber_r_right = string.format('%s,%s,%s', 255, colors.cur_g, colors.cur_b)
    colors.scrubber_g_left = string.format('%s,%s,%s', colors.cur_r, 0, colors.cur_b)
    colors.scrubber_g_right = string.format('%s,%s,%s', colors.cur_r, 255, colors.cur_b)
    colors.scrubber_b_left = string.format('%s,%s,%s', colors.cur_r, colors.cur_g, 0)
    colors.scrubber_b_right = string.format('%s,%s,%s', colors.cur_r, colors.cur_g, 255)
    -- Display
	colors.disp_hue = string.format('%.0f', Round((colors.cur_hue * 360), 0))
	colors.disp_sat = string.format('%.0f', Round((colors.cur_sat * 100), 0))
    colors.disp_bri = string.format('%.0f', Round((colors.cur_bri * 100), 0))
    colors.disp_hsb = string.format('%s,%s,%s', colors.disp_hue, colors.disp_sat, colors.disp_bri)

    -- PrintTable(colors)

end

function SetRGB(...)

    if arg.n == 1 then
        colors.cur_rgb = arg[1]
        colors.cur_r, colors.cur_g, colors.cur_b = string.match(colors.cur_rgb, '(%d+),(%d+),(%d+)')
    else
        colors['cur_' .. arg[1]] = arg[3] and arg[2] or Round(Clamp((SKIN:ParseFormula(arg[2]) * 255),0,255),0)
        colors.cur_rgb = string.format('%s,%s,%s', colors.cur_r, colors.cur_g, colors.cur_b)
    end

    colors.cur_hue, colors.cur_sat, colors.cur_bri = RGBtoHSB(colors.cur_rgb)
    colors.cur_hsb = string.format('%s,%s,%s', colors.cur_hue, colors.cur_sat, colors.cur_bri)
    colors.cur_hex = RGBtoHEX(colors.cur_r, colors.cur_g, colors.cur_b)

    SetScrubbers()
    SKIN:Bang('!UpdateMeterGroup', 'ColorMeters')
    SKIN:Bang('!Redraw')

end

function SetHSB(...)

    if arg.n == 1 then
        colors.cur_hsb = arg[1]
        
    else
        colors['cur_' .. arg[1]] = Clamp(SKIN:ParseFormula(arg[2]),0,1)
        colors.cur_hsb = string.format('%s,%s,%s', colors.cur_hue, colors.cur_sat, colors.cur_bri)
    end

    colors.cur_rgb = string.format('%s,%s,%s', HSBtoRGB(colors.cur_hue, colors.cur_sat, colors.cur_bri))
    colors.cur_hex = RGBtoHEX(colors.cur_r, colors.cur_g, colors.cur_b)

    SetScrubbers()
    SKIN:Bang('!UpdateMeterGroup', 'ColorMeters')
    SKIN:Bang('!Redraw')

end

function SetHEX(value)

    RmLog('SetHEX')

    SetRGB(string.format('%s,%s,%s', HEXtoRGB(value)))

end

function ChangeRGB(key, delta)

    SetRGB(key, Clamp(colors['cur_' .. key] + delta, 0, 255), true)

end

function ChangeHSB(key, delta)

    SetHSB(key, Clamp(colors['cur_' .. key] + delta, 0, 1))

end

-- function to make logging messages less cluttered
function RmLog(message, type)

    if type == nil then type = 'Debug' end
      
    if debug == true then
        SKIN:Bang("!Log", message, type)
    elseif type ~= 'Debug' then
        SKIN:Bang("!Log", message, type)
    end
      
end

printIndent = '     '

-- prints the entire contents of a table to the Rainmeter log
function PrintTable(table)
    for k,v in pairs(table) do
        if type(v) == 'table' then
            local pI = printIndent
            RmLog(printIndent .. tostring(k) .. ':')
            printIndent = printIndent .. '  '
            PrintTable(v)
            printIndent = pI
        else
            RmLog(printIndent .. tostring(k) .. ': ' .. tostring(v))
        end
    end
end