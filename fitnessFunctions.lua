--fitnessFunctions.lua
local VERBOSE = 0 

-- All ones problem (binary genotypes)
function AllOnes(genotype)
	local fit = 0
	for i=1, genotype:len() do
		local c = genotype:sub(i,i)
		if(c == "1") then fit = fit + 1 end
	end
	return fit
end


--[[Returns fitness for the n-Queens Problem (binary genotypes) 
1. Note that this problem is in its bare form a needle in a haystack problem. 
2. How can 

--]]  

function plotQueens(n, genotype)
	N = n
	--Convert genotype to phenotype (board position)
	--num = 1
	board = {}
	for i = 1, N do
	    board[i] = {}
	    for j = 1, N do
		    local c = genotype:sub((i-1)*N + j,(i-1)*N + j) 
		    --print(c.."*")
		    if c == "1" then 
		    	board[i][j] = true
		    	--print(num)
		    	--num = num+1
		    else
				board[i][j] = false
		    end
		end
	end

	--Print board position 
	for i = 1, N do
		for j = 1, N do
		    if board[i][j] then 
				io.write( "|Q" )
	    	else 
				io.write( "| " )
	    	end
		end
	print( "|" )
	end


end

local function match(geno, epis)
	--Does hashed matching. 
	local matched = true
	for i=1, epis:len() do
		local c = epis:sub(i,i)
		if c == "1" then 
			if geno:sub(i,i) == "0" then
				return false
			end
		end
	end

	return true

end

function plotnQueensFitnessFeatures(n, genotype, aug, augF, verb)

local N = n
local worstQueen = {-1, -1}
local augFmin = 10000
	--Convert genotype to phenotype (board position)
	--num = 1
	local boardF = {}
	for i = 1, N do
	    boardF[i] = {}
	    for j = 1, N do
		    	boardF[i][j] = 0
		end
	end

	--Convert genotype to phenotype (board position)
	--num = 1
	local board = {}
	for i = 1, N do
	    board[i] = {}
	    for j = 1, N do
		    local c = genotype:sub((i-1)*N + j,(i-1)*N + j) 
		    --print(c.."*")
		    if c == "1" then 
		    	board[i][j] = true

		    	--print(num)
		    	--num = num+1
		    else
				board[i][j] = false
		    end
		end
	end


	--Then go through calculating matches of the genotype to the aug episodes
	for i,v in ipairs(aug) do 
		if match(genotype, aug[i]) then 
			--If matched, then add fitness to the matched squares
			for p = 1, N do
			    for q = 1, N do
				    local c = aug[i]:sub((p-1)*N + q,(p-1)*N + q) 
				    if c == "1" then 
				    	boardF[p][q] = boardF[p][q] + augF[i]
				    end
				end
			end
		end
	end

	--Find the lowest valued queen. 
	for i = 1, N do
	    for j = 1, N do
		    	if  boardF[i][j] < augFmin and boardF[i][j] ~= 0 then
				    augFmin = boardF[i][j] 
				    --print("reducing augFmin to "..boardF[i][j])
				end
		end
	end

	--Get list of positions of queens with this lowest argument 
	worstQueenList = {}
	for i = 1, N do
	    for j = 1, N do
	    		--print(augFmin)
	    		--print("board F  = " ..boardF[i][j])
		    	if boardF[i][j] == augFmin then
				    table.insert(worstQueenList, {i,j})
				end
		end
	end
	
	--print("WORST QUEEN LENGTH = " ..table.getn(worstQueenList))
	--Choose a random queen 
	r = math.random(table.getn(worstQueenList))
	--print(r)
	if table.getn(worstQueenList) > 0 then
		worstQueen = worstQueenList[r]
	else
		worstQueen = {-1, -1}
		--print(worstQueen[1] .. " " .. worstQueen[2])

	end
	--print("worstQueen 1 = " .. worstQueen[1])
	--print("worstQueen 2 = " .. worstQueen[2])

	--Now draw the board. 
	--Draw board augmented fitness values. 
	if verb == 1 then  
		for i = 1, N do
			for j = 1, N do
				io.write("|"..boardF[i][j])
			end
		print( "|" )
		end
	end

	return worstQueen

end

function nQueensAugmented(n, genotype, aug, augF)

	local f = 0 
	-- First run the minimal Nqueens fitness function 
	fOld = nQueens(n, genotype)
	if fOld == 1 then
		return 1
	else
		--Augment it 
		--Go through the current genotype matching it with any episodes in aug. 
		--Where it matches add the corresponding fitness component. 
		augFitness = 0 
		for i,v in ipairs(aug) do 
			if match(genotype, aug[i]) then 
				--print("genotype = " ..genotype)
				--print("episode  = " ..aug[i])
				--print("adding fitness component".. augF[i] .. " to " .. augFitness)
				augFitness = augFitness + 0.01*augF[i]
			end
		end
	end
	f = fOld + augFitness
	return f

end

function nQueens(n, genotype)

	N = n
	--Convert genotype to phenotype (board position)
	--num = 1
	board = {}
	for i = 1, N do
	    board[i] = {}
	    for j = 1, N do
		    local c = genotype:sub((i-1)*N + j,(i-1)*N + j) 
		    --print(c.."*")
		    if c == "1" then 
		    	board[i][j] = true
		    	--print(num)
		    	--num = num+1
		    else
				board[i][j] = false
		    end
		end
	end

	if VERBOSE == 1 then

		--Print board position 
		for i = 1, N do
			for j = 1, N do
			    if board[i][j] then 
					io.write( "|Q" )
		    	else 
					io.write( "| " )
		    	end
			end
		print( "|" )
		end
	end

	-- calculate top-level objective fitness of this position 
	-- 0 fitness if two queens in same row and return
	--Go through each row
	for i = 1, N do --rows
		--For each row, go through columns, if there is more than one queen then return 0
		local numQ = 0
		for j = 1, N do --columns
			if board[i][j] == true then 
				numQ = numQ + 1
				if numQ > 1 then 
					return 0 
				end
			end
		end
	end


	-- 0 fitness if two queens in same column and return 
	--Go through each column
	for i = 1, N do --columns
		--For each column, go through rows, if there is more than one queen then return 0
		local numQ = 0
		for j = 1, N do --rows
			if board[j][i] == true then 
				numQ = numQ + 1
				if numQ > 1 then 
					return 0 
				end
			end
		end
	end

	-- 0 fitness if two queens in same diagonal and return 
	local startj = 1
	for starti = 1, N do
		local numQ = 0
		for i = 0, N do 
				if starti + i <=N and startj + i <=N then 
					if board[starti + i][startj + i] == true then
						numQ = numQ + 1
						if numQ > 1 then
							return 0
						end
					end
				end
			
		end
	end


	local starti = 1
	for startj = 1, N do
		local numQ = 0
		for i = 0, N do 
				if starti + i <= N and startj + i <= N then 
					if board[starti + i][startj + i] == true then
						numQ = numQ + 1
						if numQ > 1 then
							return 0
						end
					end
				end
		end
	end

	local startj = N
	for starti = 1, N do
		local numQ = 0
		for i = 0,N  do 
				if starti + i <=N and startj - i >= 1 then 
					if board[starti + i][startj - i] == true then
						numQ = numQ + 1
						if numQ > 1 then
							return 0
						end
					end
				end
			
		end
	end

	local starti = 1
	for startj = 1, N do
		local numQ = 0
		for i = 0,N do 
				if starti + i <= N and startj - i >= 1 then 
					if board[starti + i][startj - i] == true then
						numQ = numQ + 1
						if numQ > 1 then
							return 0
						end
					end
				end
		end
	end


	-- else return 1 

	return 1

end


