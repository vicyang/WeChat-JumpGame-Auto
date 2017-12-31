//v0.1
//未考虑背景过渡色问题
//未考虑 block 内花纹

Delay 1000
'Touch 500, 500, 1000

Dim maxlen
Dim x1,y1, x2,y2

Dim screenX, screenY
screenX = GetScreenX()
screenY = GetScreenY()
maxlen = sqr( screenX^2 + screenX^2 )

Dim bgcolor, head, bottom, centx, centy, dist
bgcolor = GetPixelColor(125, 360)
say "bgColor: " & bgcolor

Dim body

For iter = 1 To 50
	body = findbody()
	If body = 1 Then
		say "From: " & x1 & "," & y1
		Delay 500
		head = get_headline(bgcolor)
		say "heady = " & head
		If head < 0 
			Exit For
		End If
		
		centx = get_centx(head, bgcolor)
		say "centx = " & centx
		
		If centx < 0 Then 
			Exit For
		End If
		
		bottom = get_bottomline( centx, head )
		centy = (head+bottom)/2
		say "centy : " & centy
		
		dist = distance( x1, y1, centx, centy )
		say "dist: " & dist
		press (dist)
		//press (Abs(y2 - y1))
	Else 
		Exit For
	End If
	
	Delay 3000
	say "\n"
Next


Function get_headline(color)
	Dim execute
	Dim cmp
	
	For y = 600 to 900 Step 10	
		execute = ""
		For x = 1 To screenX Step 10
    		execute = execute & x & "|" & y & "|" & color & ","
		Next
		cmp = CmpColorEx(execute, 0.95)
		//出现不匹配情况时返回 0
		If cmp = 0 Then 
			get_headline = y
			Exit For
		End If
		
		//say "Y: " & y & ", Result: " & cmp
		//Touch 800, y, 100
		Delay 100
	Next
	
	If cmp = 1 Then 
		get_headline = -1
	End If
End Function

Function get_centx(head, color)
	Dim cmp
	
	get_centx = -1
	For x = 1 To screenX Step 10
		cmp = CmpColor(x, head, color, 0.95)
		//不匹配时返回 -1
		If cmp = -1 Then
			get_centx = x
			Exit For
		End If
	Next
	
End Function

Function get_bottomline( centx, head )
	Dim color, cmp
	color = GetPixelColor(centx, head)
	
	get_bottomline = -1
	
	For y = head to head+500 Step 10
		cmp = CmpColor(centx, y, color, 0.95)
		If cmp = -1 Then 
			get_bottomline = y
			Exit For
		End If
		//say "Bottom: " & y & ", Result: " & cmp
	Next
	
End Function

Sub compare(color)
    Dim cmp
    //For vt = 300 To 800 Step 10
    For vt = 600 To 800 Step 10
        For hz = 1 To screenX Step 50
            cmp = CmpColor(hz, vt, color, 0.95)
            If cmp = -1 Then 
                Exit For
            End If
        Next
	
        If cmp = -1 Then 
            Exit For
        End If
		
        say "y: " & vt & ", Result: " & cmp
        Touch 800, vt, 100
        Delay 500
    Next
End Sub

Function findbody()
    Dim times = 0
    Dim result = -1

    While ( result = -1 )
        FindPic 0,0,0,0,"Attachment:body.png","000000", 3, 0.95, x1, y1
        If x1 > -1 And y1 > -1 Then 
            x1 = x1 + 25
            y1 = y1 + 47
            result = 1
        End If
		
        If times >= 30 Then 
            result = 0
        End If
		
        times = times+1
        Delay 300
        say "find pic again, times: " & times
    Wend
    findbody = result
	
End Function


Function findblock()
    Dim times  = 0
    Dim result = -1
	
    While ( result = -1 )
        FindPic 0,0,0,0,"Attachment:block_green1.png","000000", 3, 0.8, x2, y2
        If x2 > -1 And y2 > -1 Then
            say x2 & ", " & y2
            result = 1
        End If
		
        If times >= 30 Then
            result = 0
        End If
	
        times = times + 1
        Delay 300
        say "find block again, times: " & times
    Wend
    findblock = result
	
End Function

Sub press(delta)
    Dim hold
    hold = Int(delta / maxlen * 2000)
    say "Delta: " & int(delta) & ", Delay: " & hold
    Touch x1+200, y1+100, hold
End Sub


Function distance(x1, y1, x2, y2)
	distance = sqr( (x1-x2)^2 + (y1-y2)^2 )
End Function

Function OnScriptExit()
    Delay 2000
End Function

Sub say(something)
    ShowMessage something
    TracePrint something
End Sub
