--mutationOperators.lua

function mutate_bitFlip(a, mutRate)
	mutRate = mutRate or 1/(a:len()*1.0)
	local s = ""
	for i=1, a:len() do
		local c = a:sub(i,i)
		if math.random() < mutRate then		 
			if c == "0" 
			then s = s.."1"
			else s = s.."0" end
		else s = s..c end
	end
	return s
end

function mutate_BinaryPermute(a)

	--print("input string = " .. a)
	-- convert string to array 
	local x = {}
	for i=1, a:len() do
		local c = a:sub(i,i)
		x[i] = c
	end

	-- Randomly move one queen in x 
	local chosen = 0
	while chosen == 0 do 
		r = math.random(a:len())
		if x[r] == "1" then 
			x[r] = "0"
			chosen = 1
		end
		placed = 0
		while placed == 0 and chosen == 1 do 
			r = math.random(a:len())
			if x[r] == "0" then 
				x[r] = "1"
				placed = 1
			end
		end
	end

	--Re-write string genotype 
	local s = ""
	for i in pairs(x) do
		if x[i] == "0" then 
			s = s.."0"
		else
			s = s.."1"
		end
	end
	--print("mutated sing = " .. s)
	--print("\n")
	return s

end

function mutate_BinaryPermuteWorst(a, worst)

	--print("input string = " .. a)
	-- convert string to array 
	local x = {}
	for i=1, a:len() do
		local c = a:sub(i,i)
		x[i] = c
	end

	-- Randomly move one queen in x 
	local chosen = 0
	while chosen == 0 do 
		if worst[1] ~= -1 then
			r = (worst[1]-1)*math.sqrt(a:len()) + worst[2]
			--print("choosing worst " .. worst[1] .. " " .. worst[2])
		else
			print("choosing random move")
			r = math.random(a:len())
		end

		if x[r] == "1" then 
			x[r] = "0"
			chosen = 1
		end
		placed = 0
		while placed == 0 and chosen == 1 do 
			r = math.random(a:len())
			if x[r] == "0" then 
				x[r] = "1"
				placed = 1
			end
		end
	end

	--Re-write string genotype 
	local s = ""
	for i in pairs(x) do
		if x[i] == "0" then 
			s = s.."0"
		else
			s = s.."1"
		end
	end
	--print("mutated sing = " .. s)
	--print("\n")
	return s

end