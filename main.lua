local vips = require("vips")

local characters = {
    "Ñ",
    "@",
    "#",
    "W",
    "$",
    "9",
    "8",
    "7",
    "6",
    "5",
    "4",
    "3",
    "2",
    "1",
    "0",
    "?",
    "!",
    "a",
    "b",
    "c",
    ";",
    ":",
    "+",
    "=",
    "-",
    ",",
    ".",
    " ",
}

local function input()
    print("give me path\n")
    local p = io.read("l")
    print("give me color type (0 if white: main subject will be draw, else black: everything except the main subject will draw)\n")
    local c = io.read("n")
    print("give me width\n")
    local w = io.read("n")
    return p, c, w
end

local function resizeImage(image, widthPara)
    local ratio = image:width() / widthPara
    return image:resize(1 / ratio)
end

local function generateArt(type, image)
    local delta = (255 * 3) / #characters
    local imageWidth = image:width() - 1
    local imageHeight = image:height() - 1
    local string = ""
    local loading = "["
    local progress = 0
    if type == 0 then
        for i = 0, imageHeight, 1 do
            for j = 0, imageWidth, 1 do
                loading = "["
                local r, g, b = image(j, i)
                local result = math.floor((r + g + b) / delta + 0.5)
                if result < 1 then
                    result = 1
                elseif result > #characters then
                    result = #characters
                end
                progress = math.floor((i * imageWidth + j) / (imageWidth * imageHeight) * 100) 
                for l = 1, progress, 1 do
                    loading = loading .. "#"
                end
                print(result)
                loading = loading .. "] " .. progress .. "%"
                string = string .. characters[result] .. " "
                print(loading)
                os.execute("clear")
            end
            string = string .. "\n"
        end
    else
        for i = 0, imageHeight, 1 do
            for j = 0, imageWidth, 1 do
                loading = "["
                local r, g, b = image(j, i)
                local result = math.floor((r + g + b) / delta + 0.5)
                if result < 1 then
                    result = 1
                elseif result >= #characters then
                    result = #characters - 1
                end
                progress = math.floor((i * imageWidth + j) / (imageWidth * imageHeight) * 100)
                for l = 1, progress, 1 do
                    loading = loading .. "#"
                end
                loading = loading .. "] " .. progress .. "%"
                string = string .. characters[#characters - result] .. " "
                print(loading)
                os.execute("clear")
            end
            string = string .. "\n"
        end
    end
    return string
end

local function main()
    -- Input
    local path, colorType, desiredWidth = input()

    -- -- debug
    -- local path = "./sampleImage2.jpeg"
    -- local desiredWidth = 90
    -- local colorType = 0

    ImageFile = resizeImage(vips.Image.new_from_file(path), desiredWidth)

    local art = generateArt(colorType, ImageFile);
    print(art)
end

main()
