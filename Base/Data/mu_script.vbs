On Error Resume Next

Set objWMIService  = GetObject("winmgmts:\\.\root\cimv2")   
Set DISK  = objWMIService.ExecQuery("Select Name,Size,FreeSpace from Win32_LogicalDisk where DriveType = '3'")   
Set NETWORK   = objWMIService.ExecQuery("Select Name from Win32_NetworkConnection where ConnectionState = 'Connected'")   
Set SHARE  = objWMIService.ExecQuery("Select Path from Win32_Share where Name<>'IPC$'")   
Set ETC   = objWMIService.ExecQuery("Select CSName, LocalDateTime from Win32_OperatingSystem")   

eventday = left(Date,4) + mid(Date,6,2) + right(Date,2)
eventday = eventday + "000000.000000+540"
   
Set EVENTLOG  = objWMIService.ExecQuery("Select Logfile,EventCode,TimeWritten from Win32_NTLogEvent where Type ='¿À·ù' and Logfile <> 'Kaspersky Event Log' and TimeGenerated > '"& eventday &"' ",,48)   
   
Set Wshell = WScript.CreateObject("WScript.Shell")   
Set fso = CreateObject("Scripting.FileSystemObject")   
   
For Each objItem in ETC   
 CSName   = objItem.CSName  
 LocalDateTime   = objItem.LocalDateTime  
next   
   
save_time = mid(LocalDateTime,9,2)+":"+mid(LocalDateTime,11,2)   
save_date = left(Date,4)+mid(Date,6,2)+right(Date,2)   
   
   
Sub MakeFile   
   
 Set MyFile = fso.OpenTextFile("c:\DISK.txt", 2, True)  
   
 For Each objItem in Disk  
  MyFile.WriteLine (CSName) & ("|") & (save_date) & ("|") & (save_time) & ("|") & (left(objItem.Name,1)) & ("|") & (objItem.Size) & ("|") & (objItem.FreeSpace) 
 next  
 MyFile.Close  
   
   
' Set MyFile = fso.OpenTextFile("c:\SHARE.txt", 2, True)  
'   
' For Each objItem in SHARE  
'  MyFile.WriteLine (CSName) & ("|") & (save_date) & ("|") & (save_time) & ("|") & (objItem.Path) 
' Next  
' MyFile.Close  
   
   
' Set MyFile = fso.OpenTextFile("c:\NETWORK.txt", 2, True)  
'   
' For Each objItem in NETWORK  
'  MyFile.WriteLine (CSName) & ("|") & (save_date) & ("|") & (save_time) & ("|") & (objItem.Name) 
' Next  
' MyFile.Close  
   
   
 Set MyFile = fso.OpenTextFile("c:\EVENT.txt", 2, True)  
   
 For Each objItem In EVENTLOG  
  MyFile.WriteLine (CSName) & ("|") & (save_date) & ("|") & (save_time) & ("|") & (objItem.Logfile) & ("/") & (objItem.EventCode) & ("/") & (objItem.TimeWritten) 
 next  
 MyFile.Close  
   
End Sub   
   
   
Sub DBinsert   
   
 Set cn = CreateObject("ADODB.Connection")  
 cn.Open "Provider=SQLOLEDB.1;Password=!dnsdudtlf)0;Persist Security Info=True;User ID=con_sms;Initial Catalog=master;Data Source=192.168.100.202,6279"  
   
 if cn.State = adStateOpen Then  
  WScript.quit 
 end if  
   
 Set fso = CreateObject("Scripting.FileSystemObject")  
   
 filename = "C:\DISK.txt"  
 Set objTextStream = fso.OpenTextFile(filename, 1)  
   
 While Not objTextStream.AtEndOfStream  
  spl = split(objTextStream.readLine,"|")  
  Set rs = cn.execute("insert SMS_APP.SUN_SMS.dbo.T_disk values('"+spl(0)+"','"+spl(1)+"','"+spl(2)+"','"+spl(3)+"','"+spl(4)+"','"+spl(5)+"' )") 
 Wend  
   
 objTextStream.Close  
 Set objTextStream = Nothing  
   
'filename = "C:\SHARE.txt"  
'Set objTextStream = fso.OpenTextFile(filename, 1)  
'  
'While Not objTextStream.AtEndOfStream  
' spl = split(objTextStream.readLine,"|")  
' Set rs = cn.execute("insert SMS_APP.SUN_SMS.dbo.T_share values('"+spl(0)+"','"+spl(1)+"','"+spl(2)+"','"+spl(3)+"' )") 
'Wend  
'  
'objTextStream.Close  
'Set objTextStream = Nothing  
  
'filename = "C:\NETWORK.txt"  
'Set objTextStream = fso.OpenTextFile(filename, 1)  
'   
' While Not objTextStream.AtEndOfStream  
'  spl = split(objTextStream.readLine,"|")  
'  Set rs = cn.execute("insert SMS_APP.SUN_SMS.dbo.T_network values('"+spl(0)+"','"+spl(1)+"','"+spl(2)+"','"+spl(3)+"' )") 
' Wend  
'   
' objTextStream.Close  
' Set objTextStream = Nothing  
'   
 filename = "C:\EVENT.txt"  
 Set objTextStream = fso.OpenTextFile(filename, 1)  
   
 While Not objTextStream.AtEndOfStream  
  spl = split(objTextStream.readLine,"|")  
  Set rs = cn.execute("insert SMS_APP.SUN_SMS.dbo.T_event values('"+spl(0)+"','"+spl(1)+"','"+spl(2)+"','"+spl(3)+"' )") 
 Wend  
   
 objTextStream.Close  
 Set objTextStream = Nothing   
   
 Set rs = cn.execute("insert SMS_APP.SUN_SMS.dbo.T_SendTimeCheck values('"+spl(0)+"','"+spl(1)+"','"+spl(2)+"')")  
   
 fso.DeleteFile("C:\DISK.txt")  
' fso.DeleteFile("C:\SHARE.txt")  
' fso.DeleteFile("C:\NETWORK.txt")  
 fso.DeleteFile("C:\EVENT.txt")  
   
 Set fso = nothing  
 Set rs = nothing  
 Set cn = nothing  
End Sub   
   
Sub ServerInfo   
 Set cmdShell = CreateObject("Wscript.Shell")  
 '''''OS, ServicePack, Name  
 Set BasicInfo = objWMIService.ExecQuery("Select Caption, CSDVersion, CSName from Win32_OperatingSystem")  
 i = 0  
 msg = ""  
 for each Info in BasicInfo  
  hostname = Info.CSName 
  msg =  msg & Info.CSName & "|" & Info.Caption & "|" & Info.CSDVersion & "|" 
  i = i + 1 
 next  
   
 total_msg = total_msg & "OS|" & i & "|" & msg & vbCRLF  
   
   
 '''''Disk  
 Set DiskInfo = objWMIService.ExecQuery("Select Model, InterfaceType, Size from Win32_DiskDrive where Status = 'OK' ")  
 i = 0  
 msg = ""  
 for each Info in DiskInfo  
  msg = msg & Info.Model & "|" & Info.InterfaceType & "|" & Info.Size & "|" 
  i = i + 1 
 next  
   
 total_msg = total_msg & "Disk|" & i & "|" & msg & vbCRLF  
   
   
 '''''Cpu  
 Set CpuInfo = objWMIService.ExecQuery("Select Name, SocketDesignation from Win32_Processor ")  
 i = 0  
 msg = ""  
 for each Info in CpuInfo  
  msg = msg & trim(Info.Name) & "|" & Info.SocketDesignation & "|"  
  i = i + 1 
 next  
   
 total_msg = total_msg & "Cpu|" & i & "|" & msg & vbCRLF  
   
   
 '''''Memory  
 Set MemoryInfo = objWMIService.ExecQuery("Select Capacity from Win32_PhysicalMemory ")  
 i = 0  
 msg = ""  
 for each Info in MemoryInfo  
  msg = msg & Info.Capacity & "|"  
  i = i + 1 
 next  
   
 total_msg = total_msg & "Memory|" & i & "|" & msg & vbCRLF  
   
   
 '''''Sql  
 Set SqlInfo = objWMIService.ExecQuery("select Caption from Win32_Process where Caption = 'sqlservr.exe' ")  
 i = 0  
 msg = ""  
 for each Info in SqlInfo  
  msg = Info.Caption 
  i = i + 1 
 next  
   
 if  i > 0 then  
  Set SqlInfo = objWMIService.ExecQuery("select Caption from Win32_Service where Caption = 'MSSQLSERVER' ") 
  i = 0 
  msg = "" 
  for each Info in SqlInfo 
   i = i + 1
  next 
   
  if i > 0  then 
   total_msg = total_msg & "Sql|SQL2000" & vbCRLF
  else 
   total_msg = total_msg & "Sql|SQL2005" & vbCRLF
  end if 
 end if  
   
 Set MyFile = fso.OpenTextFile("" & hostname & "_ServerInfo.txt", 2, True)  
 MyFile.WriteLine total_msg  
 MyFile.Close   
   
   
 '''''IP, GateWay, DNS, Subnet  
 cmdShell.Run "cmd /c ipconfig > " & hostname & "_ip.txt"  
   
 wscript.sleep(1000)  
   
   
 '''''Routing Table  
 cmdShell.Run "cmd /c route print >" & hostname & "_routing.txt"  
   
 Set cmdShell = nothing  
 Set MyFile = Nothing   
   
End Sub   
   
   
call MakeFile   
'call ServerInfo   
call DBinsert   
   
WScript.Quit   
