-- 도플갱어 Lua 스크립트


-- 도플갱어 맵의 정보 초기화 함수
-- FN_LuaSetDoppelgangerInit()
-- 사용자의 최고 레벨을 가져옴
-- LuaGetMaxUserLevel()
-- 사용자의 최저 레벨을 가져옴
-- LuaGetMinUserLevel()
-- 몬스터 HP 설정
-- LuaSetMonsterHp(monsterIndex, HP)
-- 몬스터 출현 시간 설정
-- LuaSetAddMonsterTime(Second)
-- 몬스터 공격확률
-- LuaSetMonsterAttackRate(Rate)
-- 이벤트 준비시간
-- LuaSetReadyTime(Minute)
-- 이벤트 진행시간
-- LuaSetPlayTime(Minute)
-- 보상 받는 시간
-- LuaSetEndTime(Minute)


local classDoppelgangerLua = CDoppelgangerLua()

--//////////////////////////////////////////////////////////////////////////////
-- 도플갱어 맵 정보 초기화
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaDopplegangerInit()
	-- 준비시간(분)
	classDoppelgangerLua:LuaSetReadyTime(1)
	-- 진행시간(분)
	classDoppelgangerLua:LuaSetPlayTime(10)
	-- 보상받는시간(분)
	classDoppelgangerLua:LuaSetEndTime(1)
end


--//////////////////////////////////////////////////////////////////////////////
-- Callback 주기적으로 호출
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaDoppelgangerCallback(nCurTime)
	-- 현재의 시간
	--local nCurTime 			= classDoppelgangerLua:LuaGetLocalTime()

	-- 이벤트 시작시간
	local nStateTime		= classDoppelgangerLua:LuaGetStateTime()
	-- 게임시작 후 지난시간 (밀리세컨드)
	local nPlayTime 		= (nCurTime - nStateTime) / 1000
	-- 몬스터 출현 시간
	local nAddHerdMonsterTime = nCurTime
	--local nAddBossMonsterTime = nCurTime
	-- 아이스워커출현여부
	local bIceWorkerRegen	= 0

	nAddHerdMonsterTime 	= classDoppelgangerLua:LuaGetAddHerdMonsterTime()
	--nAddBossMonsterTime 	= classDoppelgangerLua:LuaGetAddBossMonsterTime()
	local nBossRegenOrder	= classDoppelgangerLua:LuaGetBossRegenOrder()

	-- 맵번호
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	local nHerdIndex = -1

	-- 무리 몬스터를 생성
	if (nCurTime - nAddHerdMonsterTime) >= 3 * 1000 then

		-- 무리 몬스터 인덱스를 얻어옴
		nHerdIndex = classDoppelgangerLua:LuaGetMonsterHerdIndex()
		if nHerdIndex == -1 then
			return
		end

		-- 무리 몬스터 시작위치 설정
		classDoppelgangerLua:LuaSetHerdStartPosInfo(nHerdIndex, 0, 1)
		-- 무리 몬스터 종료위치 설정
		classDoppelgangerLua:LuaSetHerdEndPosInfo(nHerdIndex, 0)

		-- 무리 몬스터를 추가함
		FN_LuaAddHerdMonster(nCurTime, nStateTime, nHerdIndex)

		-- 죽지 않고 도착지점에 들어간 도살자는 다시 생성
		local nKillerBossState = classDoppelgangerLua:LuaGetBossMonsterState()
		if nKillerBossState == 3 then
			FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, 0)
		end

		-- 죽지 않고 도착지점에 들어간 분노한 도살자는 다시 생성
		local nAngerKillerBossState = classDoppelgangerLua:LuaGetLastBossMonsterState()
		if nAngerKillerBossState == 3 then
			FN_LuaAddLastBossMonster(nCurTime, nStateTime, nHerdIndex, 0)
		end

		-- 무리 몬스터 생성 시간 저장
		classDoppelgangerLua:LuaSetAddHerdMonsterTime(nCurTime)

	end

	-- 무리번호를 안받았으면 리턴
	if nHerdIndex == -1 then
		return
	end

	--DebugPrint('nBossRegenOrder', nBossRegenOrder)

	-- 보스급 몬스터 생성
	if nBossRegenOrder == 0 and nPlayTime >= 1 * 60 then
		-- 1분 후
		classDoppelgangerLua:LuaSetBossMonsterState(1)
		FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, 1)
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	elseif nBossRegenOrder == 1 and nPlayTime >= 4 * 60 then
		-- 4분 후
		classDoppelgangerLua:LuaSetBossMonsterState(1)
		FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, 1)
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	elseif nBossRegenOrder == 2 and nPlayTime >= 6 * 60 - 5 then
		-- 6분 후 아이스 워커를 출현시킨다
		bIceWorkerRegen	= 1
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	elseif nBossRegenOrder == 3 and nPlayTime >= 7 * 60 then
		-- 7분 후
		classDoppelgangerLua:LuaSetLastBossMonsterState(1)
		FN_LuaAddLastBossMonster(nCurTime, nStateTime, nHerdIndex, 1)
		classDoppelgangerLua:LuaSetBossRegenOrder(nBossRegenOrder+1)
	end


	-- 실제로 무리 몬스터를 움직임
	classDoppelgangerLua:LuaMonsterHerdStart(nHerdIndex)

	-- 아이스 워커 출현은 여기서
	if bIceWorkerRegen == 1 then
		-- 무리 몬스터 인덱스를 얻어옴
		local nHerdIndex = classDoppelgangerLua:LuaGetMonsterHerdIndex()
		if nHerdIndex == -1 then
			return
		end

		-- 위치를 설정
		local nPosInfo = classDoppelgangerLua:LuaGetRandomValue(16) + 3
		-- 무리 몬스터 시작위치 설정
		classDoppelgangerLua:LuaSetHerdStartPosInfo(nHerdIndex, nPosInfo, 0)
		-- 무리 몬스터 종료위치 설정
		classDoppelgangerLua:LuaSetHerdEndPosInfo(nHerdIndex, nPosInfo)

		-- 아이스워커가 출현한다고 알림
		classDoppelgangerLua:LuaIceworkerRegen(nPosInfo)

		-- 아이스워커 리젠
		FN_LuaAddIceWorkerMonster(nCurTime, nStateTime, nHerdIndex)

		-- 실제로 무리 몬스터를 움직임
		classDoppelgangerLua:LuaMonsterHerdStart(nHerdIndex)

		bIceWorkerRegen = 0
	end

end

--//////////////////////////////////////////////////////////////////////////////
-- 일반 몬스터를 추가한다
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddHerdMonster(nCurTime, nStateTime, nHerdIndex)
	-- 최고 레벨을 가지고 온다
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- 레벨을 이용 몬스터의 Hp를 계산
	--local nMonsterHp = nMaxUserLevel --* 10
	-- 게임시작 후 지난시간 (밀리세컨드)
	local nPlayTime = nCurTime - nStateTime
	-- 맵번호
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	-- 몬스터 공격력 (최소공력력 = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- 몬스터 방어력
	--local nMonsterDef 	= nMaxUserLevel + 100

	-- 몬스터 수를 설정
	local nMonsterCount = 1

	if nPlayTime < 3 * 60 * 1000 then
		nMonsterCount = 1
	elseif nPlayTime < 6 * 60 * 1000  then
		nMonsterCount = 2
	else
		nMonsterCount = 3
	end

	nMonsterCount = nMonsterCount + classDoppelgangerLua:LuaGetUserCount() - 1

	-- nMonsterCount 만큼 몬스터 추가
	for cnt = 0, nMonsterCount-1 do
		local nMonsterIndex = 533 + classDoppelgangerLua:LuaGetRandomValue(6)
		--local nMonsterIndex = 531 + classDoppelgangerLua:LuaGetRandomValue(9)
		--local nMonsterIndex = 530
		local nAttackFirst	= 0

		if classDoppelgangerLua:LuaGetRandomValue(1000) < 700 then
		--if classDoppelgangerLua:LuaGetRandomValue(10000) < 1000 then
			nAttackFirst = 1
		end

		-- 도플갱어 일경우는 무조건 선재공격(자폭)
		if nMonsterIndex == 533 then
			nAttackFirst = 1
		end

		-- 다크로드일 경우 마검사로 바꿈
		if nMonsterIndex == 538 then
			nMonsterIndex = 539
		end

		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- 중간보스 몬스터를 추가한다
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddMiddleBossMonster(nCurTime, nStateTime, nHerdIndex, nFlag)
	-- 최고 레벨을 가지고 온다
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- 레벨을 이용 몬스터의 Hp를 계산
	--local nMonsterHp = nMaxUserLevel --* 10
	-- 게임시작 후 지난시간 (밀리세컨드)
	local nPlayTime = nCurTime - nStateTime
	-- 맵번호
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	-- 몬스터 공격력 (최소공력력 = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- 몬스터 방어력
	--local nMonsterDef 	= nMaxUserLevel + 100

	local nMonsterIndex = 530	-- 도살자
	local nAttackFirst	= 0
	classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)

	if nFlag == 1 then
		nMonsterIndex 	= 538	-- 다크로드
		nAttackFirst	= 1
		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- 최종보스 몬스터를 추가한다
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddLastBossMonster(nCurTime, nStateTime, nHerdIndex, nFlag)
	-- 최고 레벨을 가지고 온다
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- 레벨을 이용 몬스터의 Hp를 계산
	--local nMonsterHp = nMaxUserLevel --* 10
	-- 게임시작 후 지난시간 (밀리세컨드)
	local nPlayTime = nCurTime - nStateTime
	-- 맵번호
	local nMapNumber = classDoppelgangerLua:LuaGetMapNumber()

	-- 몬스터 공격력 (최소공력력 = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- 몬스터 방어력
	--local nMonsterDef 	= nMaxUserLevel + 100

	local nMonsterIndex = 529	-- 도살자
	local nAttackFirst	= 0
	classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)

	if nFlag == 1 then
		nMonsterIndex 	= 538	-- 다크로드
		nAttackFirst	= 1
		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- 아이스워커를를 추가한다
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaAddIceWorkerMonster(ncurTime, nStateTime, nHerdIndex)
	-- 최고 레벨을 가지고 온다
	--local nMaxUserLevel	= classDoppelgangerLua:LuaGetMaxUserLevel()
	-- 레벨을 이용 몬스터의 Hp를 계산
	--local nMonsterHp = nMaxUserLevel * 10

	-- 몬스터 공격력 (최소공력력 = nMonsterAtt * 0.8)
	--local nMonsterAtt 	= nMaxUserLevel + 100
	-- 몬스터 방어력
	--local nMonsterDef 	= nMaxUserLevel + 100

	local nMonsterIndex = 531	-- 아이스워커
	local nAttackFirst	= 1

	local nMonsterCount = classDoppelgangerLua:LuaGetUserCount()
	for cnt = 0, nMonsterCount-1 do
		classDoppelgangerLua:LuaAddMonsterHerd(nHerdIndex, nMonsterIndex, nAttackFirst)
	end
end

--//////////////////////////////////////////////////////////////////////////////
-- 몬스터의 시작위치를 가져온다 ( 반환값이 두개)
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaGetStartPosition(nMapNumber)
	local StartPosX = nill
	local StartPosY = nill

	if nMapNumber == 65 then
		StartPosX = 225
		StartPosY = 101
	elseif nMapNumber == 66 then
		StartPosX = 114
		StartPosY = 181
	elseif nMapNumber ==67 then
		StartPosX = 110
		StartPosY = 151
	elseif nMapNumber == 68 then
		StartPosX = 43
		StartPosY = 109
	end

	return StartPosX, StartPosY
end

--//////////////////////////////////////////////////////////////////////////////
-- 몬스터의 종료위치를 가져온다 ( 반환값이 두개)
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaGetEndPosition(nMapNumber)
	local EndPosX = nill
	local EndPosY = nill

	if nMapNumber == 65 then
		EndPosX = 210
		EndPosY = 64
	elseif nMapNumber == 66 then
		EndPosX = 125
		EndPosY = 124
	elseif nMapNumber == 67 then
		EndPosX = 108
		EndPosY = 104
	elseif nMapNumber == 68 then
		EndPosX = 74
		EndPosY = 53
	end

	return EndPosX, EndPosY
end

--//////////////////////////////////////////////////////////////////////////////
-- 아이스워커의 시작위치를 가져온다 ( 반환값이 두개)
--//////////////////////////////////////////////////////////////////////////////
function FN_LuaGetIceWorkerStartPos(nMapNumber)
	local StartPosX = nill
	local StartPosY = nill

	if nMapNumber == 65 then
		StartPosX = 210
		StartPosY = 64
	elseif nMapNumber == 66 then
		StartPosX = 125
		StartPosY = 124
	elseif nMapNumber ==67 then
		StartPosX = 108
		StartPosY = 104
	elseif nMapNumber == 68 then
		StartPosX = 74
		StartPosY = 53
	end

	return StartPosX, StartPosY
end

















