

function LuaBind()
	local luaBindTest = LuaBindTest()		-- class LuaBindTest
	
	luaBindTest:LuaBindFunTest(20,'abcd')	-- LuaBindTest::LuabindFunTest()에 인자를 넘김
end

function LuaBindReturn()

	local luaBindTest = LuaBindTest()		-- class LuaBindTest
	
	local lua_return = luaBindTest:LuaBindFunReturnTest()	-- LuaBindtest::LuaBindfunReturnTest()의 리턴값 얻어옴
	
	lua_return = lua_return + 100
	
	return lua_return;					
	
end

LuaBind()
