include("autorun/desc_config.lua")
util.AddNetworkString("ApplyDescription")
util.AddNetworkString("OpenSimpleDesc")
 

net.Receive("ApplyDescription", function(len, ply)
	local ent = net.ReadEntity()
	local str = net.ReadString()
		ply:SetNWString("DescriptionLine1",str)
		if log_desc then
			MsgC( Color( 255, 222, 102 ), ent:Nick().." have update his description to (".. str ..")\n" )
		end
	file.CreateDir( "descriptiondata" )
	file.Write( "descriptiondata/"..ply:SteamID64().."_desc.txt", str )
end)

hook.Add( "PlayerSpawn", "SpawnSetDesc", function( ply)
	if file.Exists( "descriptiondata/"..ply:SteamID64().."_desc.txt", "DATA" ) then
	local str = file.Read( "descriptiondata/"..ply:SteamID64().."_desc.txt", "DATA" )
		ply:SetNWString("DescriptionLine1",str)
	else
		ply:SetNWString("DescriptionLine1"," ")
	end
end)

hook.Add( "PlayerSay", "FindTextDesc", function( ply, text, team )
	if text == command then 
	net.Start("OpenSimpleDesc")
	net.WriteEntity(ply)
	net.Send(ply)
	return ""
	end
end )