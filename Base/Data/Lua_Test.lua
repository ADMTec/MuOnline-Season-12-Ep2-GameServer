

function LuaBind()
	local luaBindTest = LuaBindTest()		-- class LuaBindTest
	
	luaBindTest:LuaBindFunTest(20,'abcd')	-- LuaBindTest::LuabindFunTest()�� ���ڸ� �ѱ�
end

function LuaBindReturn()

	local luaBindTest = LuaBindTest()		-- class LuaBindTest
	
	local lua_return = luaBindTest:LuaBindFunReturnTest()	-- LuaBindtest::LuaBindfunReturnTest()�� ���ϰ� ����
	
	lua_return = lua_return + 100
	
	return lua_return;					
	
end

LuaBind()
