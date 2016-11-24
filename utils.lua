local util = {}
function util.dump_non_data(data) 
	for k, v in pairs(data) do
		if type(k) ~= 'number' then
			print(k .. ' ' .. v)
		end
	end
end

function min(x, y)
	if x > y then
		return y
	else
		return x
	end
end

function max(x, y)
	if x > y then
		return x
	else
		return y
	end
end

function math.round(num)
    if num >= 0 then return math.floor(num+.5) 
    else return math.ceil(num-.5) end
end