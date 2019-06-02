local M = {}

local a = 0x80000000
local b = 0x7fffffff
local c = 0x7fff

M.band = function(v1, v2)
	return bit.band(math.floor(v1 / a), math.floor(v2 / a)) * a + bit.band(bit.band(v1, b), bit.band(v2, b))
end

M.bor = function(v1, v2)
	return bit.bor(math.floor(v1 / a), math.floor(v2 / a)) * a + bit.bor(bit.band(v1, b), bit.band(v2, b))
end

M.bxor = function(v1, v2)
	return bit.bxor(math.floor(v1 / a), math.floor(v2 / a)) * a + bit.bxor(bit.band(v1, b), bit.band(v2, b))
end

M.lshift = function(num, bits)
	return num * math.pow(2, bits)
end

M.rshift = function(num, bits)
	return math.floor(num / math.pow(2, bits))
end

M.bnot = function(v1)
	return bit.band(bit.bnot(v1), b) + M.lshift(bit.band(bit.bnot(M.rshift(v1, 31)), c), 31)
end

M.to_num = function(ary)
	local t = 0
	for i,v in ipairs(ary) do
		t = t + M.lshift(v, #ary-i)
	end
	return t
end

M.to_ary = function(num, bits)
	bits = bits or math.max(1, select(2, math.frexp(num)))
	local t = {}
	for i = bits, 1, -1 do
		t[i] = math.fmod(num, 2)
		num = math.floor((num - t[i]) / 2)
	end
	return t
end

M.swap = function(num, bits)
	local ary = M.to_ary(num, bits)
	local t = {}
	for i=1,#ary do
		table.insert(t, ary[#ary-i+1])
	end
	return M.to_num(t)
end

M.swap_ary = function(ary)
	local t = {}
	for i=1,#ary do
		table.insert(t, ary[#ary-i+1])
	end
	return t
end

return M
