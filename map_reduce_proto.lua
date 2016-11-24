require 'pl'
utils = require 'utils'

local OUR_N = 5
local iris = data.read('iris.csv')

-- Sepal_Length,Sepal_Width,Petal_Length,Petal_Width,Class
local ranges = {}
local fields = {}
function normalize (self, datum) 
	return (datum - self.min) / (self.max - self.min)
end
for i, v in ipairs (iris.fieldnames) do
	-- Get normalization
	if v ~= 'Class' then
		fields[v] = i
		ranges[v] = {
			min = tablex.reduce(min, iris:column_by_name(v)),
			max = tablex.reduce(max, iris:column_by_name(v)) + 0.000001,
			normalize = normalize
		}
	end
end

for k, row in ipairs(iris) do
	for name, idx in pairs(fields) do
		row[idx] = ranges[name]:normalize(row[idx])
	end
end


local test = {
	fieldnames = iris.fieldnames,
	out_file = 'iris_test.csv'
}

local train = {
	fieldnames = iris.fieldnames,
	out_file = 'iris_train.csv'
}

for k, v in ipairs(iris) do
	if k % 3 == 0 then
		table.insert(test, v)
	else
		table.insert(train, v)
	end
end

partitions = {}

local partition_degree = tonumber(arg[1])
local partition_divisor = 1 / partition_degree
for k, row in ipairs(train) do
	local part_width = math.floor(row[fields.Petal_Width] / partition_divisor) 
	local part_length = math.floor(row[fields.Petal_Length] / partition_divisor)
	local part = partitions[part_width] or {}
	partitions[part_width] = part
	part[part_length] = part[part_length] or {}
	table.insert(part[part_length], row)
end


local total = 0

for i=0, partition_degree - 1, 1 do
	local v = partitions[i] or {}
	for ii=0, partition_degree - 1, 1 do
		local vv = v[ii] or {}
		-- foldr for count
		io.write(tostring(#vv) .. "\t")
		total = total + (#vv)
	end
	print ("")
	--print (tostring(#v))
end

print ("Total records in partitions: " .. total)
