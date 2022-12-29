local imgui = require "cimgui"
local ffi = require "ffi"

local io = imgui.GetIO()

local propview = require "propview"

local show = ffi.new("bool[1]", true)

local files = {}
local curfile = 0

function tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end  

return function()
    -- fullscreen window of tabs for property files
    
    imgui.SetNextWindowSize(imgui.ImVec2_Float(io.DisplaySize.x, io.DisplaySize.y))
    imgui.SetNextWindowPos(imgui.ImVec2_Float(0, 0))
    if (imgui.Begin("propedit", show, 
    imgui.WindowFlags("MenuBar", "NoResize", "NoMove", "NoTitleBar", "NoSavedSettings"))) then
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("File") then
                if imgui.MenuItem_Bool("New") then
                    table.insert(files, #files+1, {name = "New File"..#files+1, data = {}})
                end
                imgui.Separator()
                if imgui.MenuItem_Bool("Open") then
                end
                imgui.Separator()
                if imgui.MenuItem_Bool("Save") then
                end
                if imgui.MenuItem_Bool("Save As") then
                end
                imgui.Separator()
                if imgui.MenuItem_Bool("Close") then
                    table.remove(files, curfile)
                end
                if imgui.MenuItem_Bool("Close All") then
                    files = {}
                end
                imgui.Separator()
                imgui.Text("Recent Items")
                imgui.Separator()
                if imgui.MenuItem_Bool("Quit") then love.event.quit() end
                imgui.EndMenu()
            end
            if imgui.BeginMenu("View") then
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
        end

        if (imgui.BeginTabBar("##proptabs")) then
            for k,v in ipairs(files) do
                if (imgui.BeginTabItem(v.name)) then
                    curfile = k

                    if imgui.Button("New") then
                        local key = "new"..tableLength(v.data)
                        v.data[key] = "value"
                    end
                    imgui.SameLine()
                    if imgui.Button("Delete") then
                        v.data[item_selected] = nil
                        item_selected = ""
                    end
                    propview(v.data)
                    imgui.EndTabItem()
                end
            end

            imgui.EndTabBar()
        end

    end
    imgui.End()
end