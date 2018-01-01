//v0.1
//考虑背景过渡色问题
//未考虑 block 内花纹

//v1.0
//在遇到 CD block 的时候会有音乐符号上浮对扫描线造成干扰 - 判断body在屏幕左边还是右边，仅扫描另一半屏幕
//block 中间的圆点判断
//有时候背景色突然改变，作定点判断

//v1.1
//提高 block 边界的精确度


Delay 1000
Dim maxlen
Dim x1,y1, x2,y2

Dim screenX, screenY
screenX = GetScreenX()
screenY = GetScreenY()
maxlen = sqr( screenX^2 + screenX^2 )

Dim bgcolor, prev, curr
Dim head, bottom, centx, centy, dist

Dim body
Dim changed

While (1)
	bgcolor = GetPixelColor(100, 360)
	body = findbody()
	If body = 1 Then
		say "From: " & x1 & "," & y1
		
		If check_bgcolor_change(bgcolor) = 1 Then 
			bgcolor = GetPixelColor(100, 360)
		End If
		
		head = get_headline( x1 )
		say "heady = " & head
		If head < 0 
			Exit For
		End If
		
		centx = get_centx( head, x1 )
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
		Exit While
	End If
	
	Delay 2500
	
	TracePrint "Step: " & iter
	TracePrint ""
End While

Function get_headline( body_x )
	Dim execute
	Dim cmp
	Dim color, num
	Dim xleft, xright, halfx
	halfx = screenX / 2
	
	If body_x > halfx Then 
		xleft = 1
		xright = halfx
		TracePrint "test left side"
	Else 
		xleft = halfx + 1
		xright = screenX
		TracePrint "test right side"
	End If
	
	For y = 500 To 1000 Step 10
		color = GetPixelColor( xleft, y )
		//say "bgcolor: "& color
		
		num = GetColorNum(xleft, y, xright, y, color, 0.95)
		
		//如果相同颜色的数量比预像素计少20
		If num < (halfx - 20) Then
			get_headline = y
			
			//精确扫描
			For yy = (y - 10) To y Step 2
				num = GetColorNum(xleft, yy, xright, yy, color, 0.95)
				If num < (halfx - 20) Then 
					get_headline = yy
					Exit For
				End If
			Next
			Exit For
		End If
		
		//say "Y: " & y & ", Result: " & cmp
		//Touch 800, y, 100
		//Delay 100
	Next
	
	If cmp = 1 Then 
		get_headline = -1
	End If
End Function

Function get_centx(headline, body_x)
	Dim color, cmp
	color = GetPixelColor(5, headline)
	
	Dim xleft, xright, halfx
	halfx = screenX / 2
	
	If body_x > halfx Then 
		xleft = 1
		xright = halfx
		TracePrint "Centx, test left side"
	Else 
		xleft = halfx + 1
		xright = screenX
		TracePrint "Centx, test right side"
	End If
	
	get_centx = -1
	For x = xleft To xright Step 5
		cmp = CmpColor(x, head, color, 0.95)
		//不匹配时返回 -1
		If cmp = -1 Then
			get_centx = x
			say "Cent Color: " & GetPixelColor(x, headline)
			Exit For
		End If
	Next
	
End Function

Function get_bottomline( centx, head )
	Dim color, cmp, white
	color = GetPixelColor(centx, head)
	
	get_bottomline = -1
	
	For y = head to head+500 Step 10
		cmp = CmpColor(centx, y, color, 0.95)
		If cmp = -1 Then 
			white = CmpColor( centx, y, "FFFFFF", 0.9 )
			//如果不是白色
			If white = -1 Then
				get_bottomline = y
				
				//精确搜索
				For yy = (y - 10) To y Step 2
					cmp = CmpColor(centx, yy, color, 0.95)
					If cmp = -1 Then 
						get_bottomline = yy
						Exit For
					End If
				Next
				
				Exit For
			End If
		End If
		//say "Bottom: " & y & ", Result: " & cmp
	Next
	
End Function

Function check_bgcolor_change(bgcolor)
	check_bgcolor_change = 0
	While (CmpColor(100, 360, bgcolor, 0.98) = -1)
		say "Color changed"
		Delay 3000
		check_bgcolor_change = 1
		Exit While
	Wend
End Function

Function findbody()
    Dim times = 0
    Dim result = -1

    While ( result = -1 )
        FindPic 0,0,0,0,"Attachment:body.png","000000", 3, 0.95, x1, y1
        If x1 > -1 And y1 > -1 Then 
            x1 = x1 + 30
            y1 = y1 + 30
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

Sub press(delta)
    Dim hold
    hold = Int(delta / maxlen * 2000)
    say "Delta: " & int(delta) & ", Delay: " & hold
    Touch x1, centy, hold
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
