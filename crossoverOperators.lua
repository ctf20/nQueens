--crossoverOperators.lua

function crossover_BiasedUniform(a, b, PropA)
	--Uniform biased crossover, taken proportion A of a, and (1-A) of b into an offspring.
	PropA = PropA or 0.5  
	local s = ""
	for i = 1, #a do
	    local w = a:sub(i,i)
	    local l = b:sub(i,i)
		if math.random() < PropA then
			s = s..w
		else
			s = s..l
		end
	end
	return s

end
