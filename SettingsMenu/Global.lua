function onLoad()
    --[[ print('onLoad!') --]]
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()
    --[[ print('onUpdate loop!') --]]
end

function GetSetting(var, default)
	if not (var and type(var)=="string") then return default end -- No var, return default
	
	if (not SettingsObject) or (SettingsObject==nil) then
		for _,obj in pairs(getAllObjects()) do
			if obj.getLock() and obj.getName()=="Settings" and obj.getVar("getSetting") and not (obj==nil) then
				SettingsObject = obj
				break
			end
		end
		
		if (not SettingsObject) or (SettingsObject==nil) then
			return default -- No settings object, return default
		end
	end
	
	local value = SettingsObject.Call("getSetting", {index=var})
	if value==nil then return default end -- Unset, return default
	
	return value -- Return value
end