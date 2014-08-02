-- ***Evolutionary Computation Benchmarks***
-- May 2014: Chrisantha Fernando 

-- General parameters 
local problemSize = 9*9
local generations = 500000
local popSize = 100

local mGA = require "microbialGA"
local stat = require "stats"
require "fitnessFunctions"

-- Load microbial genetic algorithm module 

math.randomseed(os.time())

--[ Run microbial genetic algorithm and plot results. 

-- mGA.initialize(popSize,
-- 			   generations, 
-- 			   'binary', 
-- 			   problemSize)

-- outP = mGA.run()
-- --mGA.visualize()
-- print(outP[1])

--Batch trials to produce Table 1, 2.  
local fitTable = {}
local uniqueSolutions = {}

local dataForTraining = {} -- Stores sequences explored so that they can be used for fitness shaping. 
local dataFitness = {} -- Stores fitness of sequences explored for fitness shaping later. 

local count = 0
local found = 0 


-- 1. First collect data on the 2BQueens problem to use for fitness shaping. 

for trial = 1, 10000 do 
	mGA.initialize(popSize,
				   generations, 
				   'binary', 
				   problemSize, 
				   '2BQueens', --problemtype
				   0)--verbose

	outP = mGA.run('randomMutation')
	
	if outP[1] < generations then 
		found = found + 1 
		table.insert(fitTable, outP[1])
		--mGA.visualize()
		--plotQueens(5, outP[2])
		--gather unique solutions
		if uniqueSolutions[""..outP[2]] == nil then
			uniqueSolutions[""..outP[2]] = true
			count = count + 1
			plotQueens(math.sqrt(problemSize), outP[2])
		end
	end

	table.insert(dataForTraining, outP[3])
	table.insert(dataFitness, outP[4])

	print("time taken in trial " .. trial .. " = " .. outP[1] .. " Unique solutions = " .. count .. " times found = " .. found)
end
print("Mean = " ..stat.mean(fitTable))

-- Get sequences and fitnesses into two neat arrays for use to augment the fitness function 
local d = {}
local df = {}
local dMap = {}
local count2 = 0

for i in pairs(dataForTraining) do 
	for j in pairs(dataForTraining[i]) do 
		print(dataForTraining[i][j].. "-->" .. dataFitness[i][j])
		if dMap[dataForTraining[i][j]] ~= true then 
			dMap[dataForTraining[i][j]] = true
			table.insert(d, dataForTraining[i][j])
			table.insert(df, dataFitness[i][j])
			count2 = count2 + 1
		end
	end
end

print("number of unique episodes = " ..count2)





-- Now run the full NQueens problem, with the microbialGA provided with d, and df, so that the fitness function 
-- can be augmented. 
 -- 	mGA.initialize(popSize,
	-- 			   generations, 
	-- 			   'binary', 
	-- 			   problemSize, 
	-- 			   'NQueens', --problemtype
	-- 			   1,--verbose
	-- 			   d, 
	-- 			   df) 

	-- outP = mGA.run()

	-- print("time taken in trial " .. " = " .. outP[1])

	-- mGA.visualize()


local found = 0
local count = 0
local fitTable = {}
local uniqueSolutions2 = {}

for trial = 1, 100 do 
	mGA.initialize(popSize,
			   generations, 
			   'binary', 
			   problemSize, 
			   'NQueens', --problemtype
			   0,--verbose
			   d, 
			   df) 


	outP = mGA.run('mutateWorstLocus')
	
	if outP[1] < generations then 
		found = found + 1 
		table.insert(fitTable, outP[1])
		--mGA.visualize()
		--plotQueens(5, outP[2])
		--gather unique solutions
		if uniqueSolutions2[""..outP[2]] == nil then
			uniqueSolutions2[""..outP[2]] = true
			count = count + 1
			plotQueens(math.sqrt(problemSize), outP[2])
			plotnQueensFitnessFeatures(math.sqrt(problemSize), outP[2], d, df, 1)

		end
	end

	print("time taken in trial " .. trial .. " = " .. outP[1] .. " Unique solutions(2) = " .. count .. " times found = " .. found)
end
print("Mean = " ..stat.mean(fitTable))



--print("Standard Deviation  = " ..stat.standardDeviation(fitTable))


