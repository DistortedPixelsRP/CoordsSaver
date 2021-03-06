local CurrentVersion = '1.0.0'

PerformHttpRequest("https://raw.githubusercontent.com/Flatracer/CoordsSaver_Resources/master/VERSION", function(Error, NewestVersion, Header)
	print("\n")
	print("####################################################################")
	print("########################### Coords Saver ###########################")
	print("####################################################################")
	print("#####                  Current Version: " .. CurrentVersion .. "                  #####")
	print("#####                   Newest Version: " .. NewestVersion .. "                  #####")
	print("####################################################################")
	if CurrentVersion ~= NewestVersion then
		print("#### Outdated, please contact Flatracer for the newest Version! ####")
	else
		print("#####                        Up to date!                       #####")
	end
	print("####################################################################")
	print("\n")
end)

print('Write /savepos <Your_Comment> ingame to save the Coords, Heading and Comment in a ".txt" in the ' .. GetCurrentResourceName() .. ' - resource folder')

RegisterServerEvent('CoordSaver:SaveCoords')
AddEventHandler('CoordSaver:SaveCoords', function(PlayerName, X, Y, Z, H, C)
	local Output
	local OldCoords = LoadResourceFile(GetCurrentResourceName(), 'Saved' .. GetOSSep() .. PlayerName .. ' - Coords.txt')
	if OldCoords == nil or OldCoords == '' then
		Output = '{X: ' .. X .. ', Y: ' .. Y .. ', Z: ' .. Z .. '} {H: ' .. H .. '} {Comment: ' .. C .. '},'
	else
		Output = OldCoords .. '\n{X: ' .. X .. ', Y: ' .. Y .. ', Z: ' .. Z .. '} {H: ' .. H .. '} {Comment: ' .. C .. '},'
	end
	local UnusedBool = SaveResourceFile(GetCurrentResourceName(), 'Saved' .. GetOSSep() .. PlayerName .. ' - Coords.txt', Output, -1)
end)

AddEventHandler('chatMessage', function(Source, Color, Message)
    if Message:sub(1, 1) == '/' then
        local fullcmd = stringsplit(Message, ' ')
        local cmd = fullcmd[1]
		local Comment

		if #fullcmd > 1 then
			Comment = fullcmd[2]
			if #fullcmd > 2 then
				for i=3, #fullcmd do
					Comment = Comment .. ' ' .. fullcmd[i]
				end
			end
		end
		
        if cmd:lower() == '/savepos' then
        	TriggerClientEvent('CoordSaver:GetCoords', Source, Comment)
        	CancelEvent()
        end
    end
end)

function stringsplit(Input, Seperator)
	if Seperator == nil then
		Seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(Input, '([^'..Seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function GetOSSep()
	if os.getenv('HOME') then
		return '/'
	else
		return '\\'
	end
end

