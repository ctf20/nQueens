-- Microbial Genetic Algorithm Module 
-- 2014 May Chrisantha Fernando 
-- Lua module for running a microbial genetic algorithm 
--require 'torch'   -- torch
require 'gfx.js'  -- to visualize the dataset
require "fitnessFunctions"
require "crossoverOperators"
require "mutationOperators"
require "utilities"

local microbialGA = {}

-- Default parameters 

-- local variables 
local numGen = 1000
local popSize = 100 
local probSize = 0
local population = {}
local fitnesses = {}
local fitHist = {}

local problemType = ""

local MUTATION_PROBABILITY  = 0.8 
local VERBOSE = 0 

local aug = {-1}
local augF = {-1}

local function evaluateFitness(individual) 

	-- ALL ONES PROBLEM 
	--fit = AllOnes(population[individual])

	local worstQueen = {-1,-1}
	-- N QUEENS PROBLEM
	if aug[1] == -1 then 	
		fit = nQueens(math.sqrt(probSize), population[individual])
	else
		fit = nQueensAugmented(math.sqrt(probSize), population[individual], aug, augF)

		--PLOT AUGMENTED FITNESS DETAILS 
		--print(" ")
		--plotQueens(math.sqrt(probSize), population[individual])
		worstQueen = plotnQueensFitnessFeatures(math.sqrt(probSize), population[individual], aug, augF, 0)
		--print(" ")
	
	end

	if VERBOSE == 1 then
		print('fitness of individual ' .. individual .. " = " .. fit)
	end
	--print("worst queen = " .. worstQueen[1])
	return {fit,worstQueen}

end

function microbialGA.initialize(popSizeI, numGenerations, genotypeDescription, problemSize, problemTypeI, verboseI, augI, augFI)
	population = {}
	fitnesses = {}
	fitHist = {}
	problemType = problemTypeI

	verboseI = verboseI or VERBOSE
	VERBOSE = verboseI

	augI = augI or aug
	aug = augI

	augFI = augFI or augF
	augF = augFI

	--print(aug[1].. " --> " .. augF[1])

	
	if VERBOSE == 1 then
		print("Making microbial GA")
	end
	popSizeI = popSizeI or popSize
	popSize = popSizeI
	if VERBOSE == 1 then
		print('pop size = ' .. popSize)
	end
	numGenerations = numGenerations or numGen
	numGen = numGenerations
	if VERBOSE == 1 then
		print('num generations = ' .. numGen)
	end
	problemSize = problemSize or probSize
	probSize = problemSize 
	if VERBOSE == 1 then
		print('problem size  = ' .. probSize)
	end
	if genotypeDescription == 'binary' then 
		-- initialize the popuation with binary numbers. 
		for i=1, popSize do 

			-- INITIALIZE WITH RANDOM BITSTRING 
			--table.insert(population, random_bitstring(problemSize))

			if problemType == "NQueens" then
				-- INITIALIZE WITH N QUEENS
				table.insert(population, random_nQueens(probSize))
			end

			if problemType == "2BQueens" then
				-- INITIALIZE WITH 2 QUEENS
				table.insert(population, random_2bQueens(2, probSize))
			end

			table.insert(fitnesses, 0)
		end
	end
end

function microbialGA.run(mutation)

	local data = {} 
	local dataFitness = {}

	if VERBOSE == 1 then
		print('Running GA for ' .. numGen .. ' generations')
	end
	for gen=1, numGen do
		
		units = chooseWithoutReplacement(2, popSize)
		
		res1 = evaluateFitness(units[1])
		res2 = evaluateFitness(units[2])
		
		fit1 = res1[1]
		fit2 = res2[1]
		worst1 = res1[2]
		worst2 = res2[2]
		--print("worst1 x = "..worst1[1].. " worst1 y = ".. worst1[2])
		--print("worst2 x = "..worst2[1].. " worst2 y = ".. worst2[2])

		table.insert(data, population[units[1]])
		table.insert(data, population[units[2]])
		table.insert(dataFitness, fit1)
		table.insert(dataFitness, fit2)

		--If max fitness is reached, return time taken and the solution 
		if fit1 == 1 then
			outcome = {gen, population[units[1]], data, dataFitness} 
			return outcome
		end
		if fit2 == 1 then
			outcome = {gen, population[units[2]], data, dataFitness} 
			return outcome
		end

		fitnesses[units[1]] = fit1
		fitnesses[units[2]] = fit2

		local worst
		if fit1 > fit2 then 
			winner = units[1]
			loser = units[2]
			worst = worst1 
		else
			winner = units[2]
			loser = units[1]
			worst = worst2
		end

		--plotQueens(math.sqrt(probSize), population[winner])

		-- Overwrite the loser with the winner uniformly with some per locus probability of overwrite.
		-- s = crossover_BiasedUniform(population[winner], population[loser], 0.8) -- copy the winner to the loser with a per locus probability (uniform)
		s = population[winner]
		--s = mutate_bitFlip(s)
		
		if mutation == 'randomMutation' or worst[1] == -1 then 
			if math.random() < MUTATION_PROBABILITY then 
				s = mutate_BinaryPermute(s) --The hard constraints are pre-programmed (i.e. you can only have 9 Queens)
			end
		end
		if mutation == 'mutateWorstLocus' and worst[1] ~= -1 then
			if math.random() < MUTATION_PROBABILITY then 
				s = mutate_BinaryPermuteWorst(s,worst) --The hard constraints are pre-programmed (i.e. you can only have 9 Queens)
			end
		end

		population[loser] = s

		-- Here we wish to discover regularities/structure in the succesful solutions that should constrain variation in future. 


		--Print best genotype so far. 
		--print("winner = " ..population[winner])
		-- Record fitness values 
		fitHist[gen] = {}
		for i,v in ipairs(fitnesses) do 
			fitHist[gen][i] = v
			--print(fitHist[gen][i])
		end
	end
	return {numGen, population[units[1]], data, dataFitness} 
end

function microbialGA.visualize()
	--
	d = {}
	 for i=1,numGen do
	 	for j=1,popSize do
		 	d[i] = {x = i, y = fitHist[i][j]}
		 	if i ==numGen-1 then 
		 		print(fitHist[i][j])
		 	end
		end
	end

	--d = { {x=0,y=0}, {x = 1, y = 2} }
	data = {key = 'Fitness', values = d}
	
	--data = {key = 'Legend', values = { {x=0,y=0}, {x = 1, y = 2} }}
	--table.insert(values, {x = 3, y = 4})
	--data = {key = 'Legend', values}
	--data = {key = 'Legend', values}

	gfx.chart(data, {
			chart = 'line', -- or: bar, stacked, multibar, scatter
			width = 600,
			height = 450,
		})
end

return microbialGA

