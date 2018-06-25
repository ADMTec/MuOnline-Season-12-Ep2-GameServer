// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//
#pragma warning ( disable : 4786 )	// Disable Warning of Large Debuf Strings ( truncated to 255 len )
#pragma warning ( disable : 4244 )
#pragma warning ( disable : 4996 )
#pragma warning ( disable : 4995 )
#pragma warning ( disable : 4554 )
#pragma warning ( disable : 4258 )
#pragma warning ( disable : 4018 )
#pragma warning ( disable : 4482 )
#pragma warning ( disable : 4532 )
#pragma warning ( disable : 4627 )

#if !defined(AFX_STDAFX_H__A9DB83DB_A9FD_11D0_BFD1_444553540000__INCLUDED_)
#define AFX_STDAFX_H__A9DB83DB_A9FD_11D0_BFD1_444553540000__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers
#define _WIN32_WINNT 0x601

#define LOG_INMEDIATLY	0
#define REMOVE_CHECKSUM	1
#define DEBUG_IT 0
#define DEBUG_BUFF_EFFECT 0
#define DEBUG_SUMMONER_SKILL	0
#define DEBUG_EVENT_COUNTER	0
#define USE_M_DRIVE 0
#define TESTSERVER	0

#if (USE_M_DRIVE == 1)
#define FINAL_PATH "M:\\"
#define COMMONSERVER_PATH "M:\\commonserver.cfg"
#define SERVER_INFO_PATH "..\\data\\Serverinfo.dat"
#else
#define FINAL_PATH "..\\Data\\"
#define COMMONSERVER_PATH "..\\Data\\CommonServer.cfg"
#define SERVER_INFO_PATH "Data\\Serverinfo.dat"
#endif

#ifdef INTERNATIONAL_KOREAN	
#define PROTOCOL_MOVE 0xD3
#define PROTOCOL_POSITION 0xDF
#define PROTOCOL_ATTACK 0xD7
#define PROTOCOL_BEATTACK 0x10
#endif

#ifdef INTERNATIONAL_ENGLISH
#define PROTOCOL_MOVE 0xD4
#define PROTOCOL_POSITION 0x11
#define PROTOCOL_ATTACK 0x15
#define PROTOCOL_BEATTACK 0xDB
#endif

#ifdef INTERNATIONAL_JAPAN
#define PROTOCOL_MOVE 0x1D
#define PROTOCOL_POSITION 0xD6
#define PROTOCOL_ATTACK 0xDC
#define PROTOCOL_BEATTACK 0xD7
#endif

#ifdef INTERNATIONAL_CHINA
#define PROTOCOL_MOVE 0xD7
#define PROTOCOL_POSITION 0xDD
#define PROTOCOL_ATTACK 0xD9
#define PROTOCOL_BEATTACK 0x1D
#endif

#ifdef INTERNATIONAL_TAIWAN
#define PROTOCOL_MOVE 0xD6
#define PROTOCOL_POSITION 0xDF
#define PROTOCOL_ATTACK 0xDD
#define PROTOCOL_BEATTACK 0xD2
#endif

#ifdef INTERNATIONAL_VIETNAM
#define PROTOCOL_MOVE 0xD9
#define PROTOCOL_POSITION 0xDC
#define PROTOCOL_ATTACK 0x15
#define PROTOCOL_BEATTACK 0x1D
#endif

#ifdef INTERNATIONAL_PHILIPPINES
#define PROTOCOL_MOVE 0xDD
#define PROTOCOL_POSITION 0xDF
#define PROTOCOL_ATTACK 0xD6
#define PROTOCOL_BEATTACK 0x11
#endif

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxdisp.h>        // MFC Automation classes

// Windows Header Files:
#include <windows.h>
#include <winbase.h>
#include <winsock2.h>
#include "COMMCTRL.h"

// C RunTime Header Files
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <tchar.h>

#include <time.h>
#include <math.h>
#include <process.h>

#include <map>
#include <string>
#include <ios>

#include <iostream> //Webzen added on 77 ??

#include <algorithm>
#include <vector>
#include <set>

// Local Header Files
#include "..\\Common\\Msg.h"

// TODO: reference additional headers your program requires here

extern CMsg			lMsg;

#define MSGGET(x,y)	(x*256)+y
//#pragma comment( lib , "wsock32.lib" )
//#pragma comment( lib , "ws2_32.lib" )
//#pragma comment( lib , "COMCTL32.lib" )


//{{AFX_INSERT_LOCATION}}
#include <afx.h>
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__A9DB83DB_A9FD_11D0_BFD1_444553540000__INCLUDED_)
