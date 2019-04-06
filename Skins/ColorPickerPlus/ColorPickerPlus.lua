debug = true
colors = {}

function Initialize()

    dofile(SKIN:MakePathAbsolute('Extra\\HSBLib.lua'))
    colors.scrubber_cursor_hue,colors.scrubber_cursor_sat = RGBtoHSB(SKIN:GetVariable('colorBorder'))

end

function Update()

    -- Selected
    colors.selected_rgb = SKIN:ReplaceVariables(SKIN:GetVariable('selectedColor'))
    colors.selected_hue, colors.selected_sat, colors.selected_bri = RGBtoHSB(colors.selected_rgb)
    colors.selected_hex = RGBtoHEX(string.match(colors.selected_rgb, '(%d+),(%d+),(%d+)'))
    -- Scrubbers
    colors.scrubber_hue_0 = string.format('%s,%s,%s', HSBtoRGB((0/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_hue_60 = string.format('%s,%s,%s', HSBtoRGB((1/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_hue_120 = string.format('%s,%s,%s', HSBtoRGB((2/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_hue_180 = string.format('%s,%s,%s', HSBtoRGB((3/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_hue_240 = string.format('%s,%s,%s', HSBtoRGB((4/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_hue_300 = string.format('%s,%s,%s', HSBtoRGB((5/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_hue_360 = string.format('%s,%s,%s', HSBtoRGB((6/6), colors.selected_sat, colors.selected_bri))
    colors.scrubber_sat_left = string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, 0, colors.selected_bri))
    colors.scrubber_sat_right = string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, 1, colors.selected_bri))
    colors.scrubber_bri_left = string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, colors.selected_sat, 0))
    colors.scrubber_bri_right = string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, colors.selected_sat, 1))
    colors.scrubber_cursor = string.format('%s,%s,%s', HSBtoRGB(colors.scrubber_cursor_hue, colors.scrubber_cursor_sat, (1 - Clamp(ColorLumens(string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, colors.selected_sat, colors.selected_bri))),35,65) / 100)))
    -- Display
	colors.display_hue = string.format('%.0f', Round((colors.selected_hue * 100), 5))
	colors.display_sat = string.format('%.0f', Round((colors.selected_sat * 100), 5))
    colors.display_bri = string.format('%.0f', Round((colors.selected_bri * 100), 5))

    SKIN:Bang('!UpdateMeterGroup', 'ColorMeters')
    SKIN:Bang('!Redraw')

end

function GetColor(key) return colors[key] or 0 end

function SetHSL(key, value)

    colors['selected_' .. key] = SKIN:ParseFormula(value)
    SKIN:Bang('!SetVariable', 'selectedColor', string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, colors.selected_sat, colors.selected_bri)))
    SKIN:Bang('!UpdateMeasure', SELF:GetName())

end

function ChangeHSL(key, delta)

    colors['selected_' .. key] = Clamp(colors['selected_' .. key] + SKIN:ParseFormula(delta),0,1)
    SKIN:Bang('!SetVariable', 'selectedColor', string.format('%s,%s,%s', HSBtoRGB(colors.selected_hue, colors.selected_sat, colors.selected_bri)))
    SKIN:Bang('!UpdateMeasure', SELF:GetName())

end