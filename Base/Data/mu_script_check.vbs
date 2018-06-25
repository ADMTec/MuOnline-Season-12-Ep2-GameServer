On Error Resume Next

	Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
	Set cmdShell = CreateObject("Wscript.Shell")

	Set OSVersion = objWMIService.ExecQuery("Select Caption from Win32_OperatingSystem")

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set cn = CreateObject("ADODB.Connection")
	Set rs = CreateObject("ADODB.Recordset")

	Set Hostname = objWMIService.ExecQuery("Select CSName From Win32_OperatingSystem")

	For Each objItem in OSVersion 
		OSName = objItem.Caption
	next

	For Each objItem in Hostname 
		ServerName = objItem.CSName
	next

	cn.Open "Provider=SQLOLEDB.1;Password=!dnsdudtlf)0;Persist Security Info=True;User ID=con_sms;Initial Catalog=master;Data Source=192.168.100.202,6279"

	if cn.State = adStateOpen Then
		WScript.quit
	end if


	sql = "select upload from SMS_APP.SUN_SMS.dbo.T_server where name = '"+ServerName+"' "

	rs.CursorLocation = 3
	rs.CursorType = 3
	rs.LockType = 3

	rs.Open sql, cn

	DownLoad = rs(0)

	rs.close


	select case DownLoad
	case "1"	
		cmd = "C:\mu_script.vbs"

		cmdShell.Run cmd

		Set cmdShell = nothing

	case "0"

		Set MyFile = fso.OpenTextFile("C:\mu_script.vbs", 2, True)

		sql = "select * from SMS_APP.SUN_SMS.dbo.mu_script order by count"


		rs.CursorLocation = 3
		rs.CursorType = 3
		rs.LockType = 3

		rs.Open sql, cn


		rs.MoveFirst

		For i = 1 To rs.RecordCount 

			MyFile.WriteLine replace(rs(1),"@","'")

			rs.MoveNext
		Next

		rs.close

		sql = " update SMS_APP.SUN_SMS.dbo.T_server set upload = '1' where name = '"+ServerName+"' "

		rs.CursorLocation = 3
		rs.CursorType = 3
		rs.LockType = 3

		rs.Open sql, cn

		MyFile.Close


		cmd = "C:\mu_script.vbs"

		cmdShell.Run cmd

		Set cmdShell = nothing		

	case else

		WScript.Quit

	end select

Set rs = nothing
Set cn = nothing

WScript.Quit