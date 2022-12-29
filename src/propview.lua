local imgui = require "cimgui"
local ffi = require "ffi"

item_selected = ""

return function(tbl)
    local function recurse(tbl)
        for k,v in pairs(tbl) do
            local sel = false
            if item_selected == k then
                sel = true
            end
            imgui.TableNextRow()
            imgui.TableNextColumn()
            if sel then
                imgui.PushStyleColor_Vec4(imgui.ImGuiCol_TableRowBg, 
                imgui.ImVec4_Float(0.26, 0.59, 0.98, 0.4))
            end
            if type(v) ~= "table" then
                if imgui.Selectable_Bool(tostring(k), sel) then
                    item_selected = k
                end
                imgui.TableNextColumn()
                imgui.Selectable_Bool(tostring(v))
            else
                if (imgui.TreeNodeEx_Str(k, imgui.ImGuiTreeNodeFlags_SpanFullWidth)) then
                   recurse(v)
                   imgui.TreePop()
                end
                imgui.TableNextColumn()
            end
            if sel then
                imgui.PopStyleColor()
            end
        end
    end

    if imgui.BeginTable("##tableview", 2, imgui.ImGuiTableFlags_RowBg) then
        imgui.TableSetupColumn("Key", ImGuiTableColumnFlags_NoHide)
        imgui.TableSetupColumn("Value", ImGuiTableColumnFlags_NoHide)
        imgui.TableHeadersRow()

        recurse(tbl)

        imgui.EndTable()
    end
end