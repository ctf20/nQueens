--utilities.lua

local VERBOSE = 0

function random_bitstring(length)
	local s = ""
	while s:len() < length do
		if math.random() < 0.5
		then s = s.."0"
		else s = s.."1" end
	end 
	return s
end

--Initialize n queens on an n x n grid at random positions. 
function random_nQueens(length)
	
	--Construct n Queens. 
	local numQueens = 1
	local x = {}

	while numQueens <= math.sqrt(length) do
		r = math.random(length)
		if x[r] ~= true then
			x[r] = true
			numQueens = numQueens + 1
			if VERBOSE == 1 then 
				print("making new queen")
			end
		else
			if VERBOSE == 1 then 
				print("no new queen1")
			end
		end
	end
		
	local s = ""
	local i = 1
	while s:len() < length do
		if x[i] == true then 
			s = s.."1"
		else
			s = s.."0"
		end
		i = i + 1
	end
	if VERBOSE == 1 then
		print("INITIAL GENOTYPE = " ..s)
	end
	return s

end

--Initialize 2 queens on an b x b grid at random positions. 
function random_2bQueens(num_queens, length)
	
	--Construct n Queens. 
	local numQueens = 1
	local x = {}

	while numQueens <= num_queens do
		r = math.random(length)
		if x[r] ~= true then
			x[r] = true
			numQueens = numQueens + 1
			if VERBOSE == 1 then
				print("making new queen")
			end
		else
			if VERBOSE == 1 then
				print("no new queen1")
			end
		end
	end
		
	local s = ""
	local i = 1
	while s:len() < length do
		if x[i] == true then 
			s = s.."1"
		else
			s = s.."0"
		end
		i = i + 1
	end
	if VERBOSE == 1 then
		print("INITIAL GENOTYPE = " ..s)
	end
	return s

end

function chooseWithoutReplacement(numToPick, popSize)
	picked = {}
	numPicked = 0
	while numPicked < numToPick do
		u = math.random(1,popSize)
		if picked[u] ~= true then
			picked[u] = true
			numPicked = numPicked + 1
		end
	end
	--This picked2 is probably unnecessary 
	--print("\n")
	picked2 = {}
	for key in pairs(picked) do table.insert(picked2, key) end	
	--for i,v in ipairs(picked2) do
		--print(v)
	--end
	return picked2

end