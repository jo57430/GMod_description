include("autorun/desc_config.lua") 

ply = LocalPlayer()
lp = FindMetaTable("Player")

surface.CreateFont( "DescFont", {
	font = "Trebuchet24",
	size = ScrW()*0.012,
	weight = 500
} )

surface.CreateFont( "Desc3D", {
	font = "Trebuchet24",
	size = 30,
	weight = 500
} )

surface.CreateFont( "DescButton", {
	font = "Trebuchet24",
	size = ScrW()*0.018,
	weight = 500,
	shadow = false
} )

function DescriptionMenu()  
local TheDescStr = ""
	local MainMenu = vgui.Create( "DFrame" )
	MainMenu:SetPos( ScrW()*0,ScrH()*0 )
	MainMenu:SetSize( ScrW()*0.3, ScrH()*0.2 )
	MainMenu:SetTitle( "" )
	MainMenu:SetDraggable( false )
	MainMenu:ShowCloseButton( false )
	MainMenu:MakePopup() 
	MainMenu:Center() 
	MainMenu.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(100,100,100))
		draw.RoundedBox( 0, ScrW()*0.01, ScrH()*0.03, ScrW()*0.28, ScrH()*0.15, Color(150,150,150))
		draw.DrawText( servername, "TargetID", ScrW() * 0.01, ScrH() * 0.01, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		draw.DrawText( descmessage, "DescFont", ScrW() * 0.015, ScrH() * 0.035, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	end
 
	 local Desc_Line1 = vgui.Create( "DTextEntry", MainMenu )
		Desc_Line1:SetPos( ScrW()*0.014, ScrH()*0.06 )
		Desc_Line1:SetTall( 20 )
		Desc_Line1:SetWide( ScrW()*0.272 )  
		Desc_Line1:SetText( LocalPlayer():GetNWString("DescriptionLine1") or "")
		Desc_Line1:SetEnterAllowed( true ) 
	Desc_Line1.OnTextChanged = function(self)
		TheDescStr = self:GetValue()
	end 
	Desc_Line1.OnEnter = function(self)
		TheDescStr = self:GetValue()
	end

	local ValidB_Color = Color(60,60,60)
	local BackText_Color = Color(170,170,170)
	local ValidB = vgui.Create( "DButton", MainMenu )
		ValidB:SetPos( ScrW()*0.205, ScrH()*0.09 )
		ValidB:SetText( "" )
		ValidB:SetSize( ScrW()*0.08, ScrH()*0.05 )
	ValidB.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.1, ScrH()*0.04, ValidB_Color)
		draw.DrawText( validbutton, "DescButton", ScrW()*0.037, ScrH()*0.005, BackText_Color, TEXT_ALIGN_CENTER )	
	end
	ValidB.OnCursorEntered = function()
		surface.PlaySound("UI/buttonclick.wav")
		ValidB_Color = Color(80,180,80)
		BackText_Color = Color(0,0,0)
	end
	ValidB.OnCursorExited = function()
		ValidB_Color = Color(60,60,60)
		BackText_Color = Color(170,170,170)
	end
	ValidB.DoClick = function()
	
		net.Start( "ApplyDescription" )
			net.WriteEntity( LocalPlayer() )
			net.WriteString( TheDescStr )
		net.SendToServer()
		
		MainMenu:Remove()
			if Preview3D then
				Preview3D:Remove()
				Preview3D = nil
			end
	end

	local BackB_Color = Color(60,60,60)
	local BackText_Color = Color(170,170,170)
	local BackB = vgui.Create( "DButton", MainMenu )
		BackB:SetPos( ScrW()*0.205, ScrH()*0.135 )
		BackB:SetText( "" )
		BackB:SetSize( ScrW()*0.08, ScrH()*0.05 )
	BackB.Paint = function()
		draw.RoundedBox( 0, 0, 0, ScrW()*0.1, ScrH()*0.04, BackB_Color)
		draw.DrawText( backbutton, "DescButton", ScrW()*0.037, ScrH()*0.005, BackText_Color, TEXT_ALIGN_CENTER )	
	end
	BackB.OnCursorEntered = function()
		surface.PlaySound("UI/buttonclick.wav")
		BackB_Color = Color(180,80,80)
		BackText_Color = Color(0,0,0)
	end
	BackB.OnCursorExited = function()
		BackB_Color = Color(60,60,60)
		BackText_Color = Color(170,170,170)
	end
	BackB.DoClick = function()
		MainMenu:Remove()
		if Preview3D then
		Preview3D:Remove()
		Preview3D = nil
		end
	end

	
	local ExampleList = vgui.Create( "DComboBox",MainMenu )
		ExampleList:SetPos( ScrW()*0.014, ScrH()*0.09 )
		ExampleList:SetSize( ScrW()*0.06, 20 )
		ExampleList:SetValue( typeof )
	for k,v in pairs(ExampleDesc) do
		ExampleList:AddChoice(k, v.Text)
	end	
	ExampleList.OnSelect = function( panel, index, value, data )
		Desc_Line1:SetText( data )
		TheDescStr = data
	end
	
	local ResetB = vgui.Create( "DButton", MainMenu )
		ResetB:SetPos( ScrW()*0.08, ScrH()*0.09 )
		ResetB:SetText( resetstr )
		ResetB:SetSize( ScrW()*0.05, 20)
	ResetB.DoClick = function()
		Desc_Line1:SetText( defaultdesc )
		TheDescStr = defaultdesc
	end
	
	local RandomB = vgui.Create( "DButton", MainMenu )
		RandomB:SetPos( ScrW()*0.135, ScrH()*0.09 )
		RandomB:SetText( randomstr )
		RandomB:SetSize( ScrW()*0.05, 20)
	RandomB.DoClick = function()
		Desc_Line1:SetText( " "..math.random(49,70).. "kg | 1m"..math.random(30,90).." | -- Hair | -- Eyes | -- Face " )
	end
	
	local ModelB = vgui.Create( "DButton", MainMenu )
		ModelB:SetPos( ScrW()*0.08, ScrH()*0.12 )
		ModelB:SetText( previewstr )
		ModelB:SetSize( ScrW()*0.105, 20)
	ModelB.DoClick = function()
	
		if Preview3D == nil then
			Preview3D = vgui.Create( "DPanel" )
			Preview3D:SetPos( ScrW()*0.55, ScrH()*0.3 )
			Preview3D:SetSize( ScrW()*0.3, ScrH()*0.5 )
			Preview3D.Paint = function()
			draw.DrawText( modelstr, "DescFont", ScrW() * 0.15, ScrH() * 0.05, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end

			Model3D = vgui.Create( "DModelPanel", Preview3D )
			Model3D:SetSize( ScrW()*0.3, ScrH()*0.5 )
			Model3D:SetModel( LocalPlayer():GetModel()  )
			
		elseif Preview3D then
			Preview3D:Remove()
			Preview3D = nil
		end
	end
end
net.Receive("OpenSimpleDesc", DescriptionMenu)

hook.Add("HUDPaint", "DescThink", function()
local ent = LocalPlayer():GetEyeTrace().Entity
end)


hook.Remove("PostDrawOpaqueRenderables", "example")
hook.Add( "PostDrawOpaqueRenderables", "RenderNameDesc", function()
	local trace = LocalPlayer():GetEyeTrace()
	local angle = trace.HitNormal:Angle()
	local ent = LocalPlayer():GetEyeTrace().Entity 
	
	if ent:IsPlayer() && ent:IsValid() && ent:Alive() and EnableCustomHUD then
	local eyeAng = EyeAngles() 
	eyeAng.p = 0
	eyeAng.y = eyeAng.y -90
	eyeAng.r = 90
	
	if AddSlideEffect then
	ent.Offset = Vector(0, 0, 0+(math.cos(CurTime())*0.5))
	end
	
	cam.Start3D2D(ent:GetPos() + ent.Offset, eyeAng, 0.05)
		local y = -1448
		draw.DrawText( ent:Nick() or "??" ,"Desc3D", x , y - 30, Color(255,255,255,255), TEXT_ALIGN_CENTER )
		draw.DrawText( ent:GetNWString("DescriptionLine1") or "No description" ,"Desc3D", x , y+30, Color(255,255,255,255), TEXT_ALIGN_CENTER )
		draw.DrawText( team.GetName(ent:Team()) or "No description" ,"Desc3D", x , y, Color(255,255,255,255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
	end
	
end )