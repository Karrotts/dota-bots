--[[
	Lists of Heroes used by bots:
	Axe, Bane, Bounty Hunter, Blood seeker, Bristleback, Chaos Knight,
	Crystal Maiden, Dazzle, Death Prophet, Dragon Knight, Drow Ranger,
	Earthshaker, Jakiro, Juggernaut, Kunkka, Lich, Lina, Lion, Luna,
	Necrophos, Omniknight, Oracle, Phantom Assassin, Pudge, Razor, Sand King,
	Shadow Fiend, Skywrath Mage, Sniper, Sven, Tidehunter, Tiny, Vengeful Spirit,
	Viper, Wind Ranger, Witch Doctor, Wraith King, Zeus

	In the Think() function the remaining slots will be filled with a random hero from
	the list of currently supported heroes.

	--Todo--
	-Find any players and dont fill those slots with people. - Unknown if possible with current API
	-Fill bot slots with random bots - DONE
	-Make sure bots dont select a hero that is already choosen. - DONE
	-Fill bots with the needed role
	-Add debug support for specific heroes - DONE

]]
----------------------------------------------------------------------------------------------------

--load in the heroes
require( GetScriptDirectory().."/heroes" )

--Turns on debug messages
debug = true;

--force selectes all heroes to value of requireHero
requireHero = "";
useRequiredHero = false;

--Array of all currently selected heroes
selectedHeroes = {};

function Think()
	--Time delay when choosing heroes
	local delay = 70;

	if (DotaTime() + delay >= delay-1 and not useRequiredHero)
	then
		--For each slot select a random hero
		for i=0,9 do
			SelectHero(i, selectRandomHero());
		end

	elseif (useRequiredHero)
	then
		--For each slot select the requiredHero
		for i=0,9 do
			SelectHero(i, requireHero);
		end

	end

end

----------------------------------------------------------------------------------------------------
--Global Functions--

function selectRandomHero()

	--updates selected heroes list
	for i=0,9 do
		selectedHeroes[i] = GetSelectedHeroName(i);
		if (debug and selectedHeroes[i] ~= "") then print(selectedHeroes[i]) end; -- Debug Text
	end

	--Sets the randomseed to current time
	math.randomseed(RealTime());

	--Randomly generates a hero from bot list
	local hero = allBotHeroes[math.random(table.getn(allBotHeroes))];
		if (debug) then print(hero) end -- Debug Text

	--Checks to see if a the random hero is repeated
	for i=0,table.getn(allBotHeroes) do --This for loop helps ensure no heroes are repeated
		for _,v in pairs(selectedHeroes) do
	  	if v == hero then
			hero = allBotHeroes[math.random(table.getn(allBotHeroes))]
			if (debug) then print("Repeat hero repicking...") end -- Debug Text
			end
		end
	end

	--returns hero
	return hero;

end

----------------------------------------------------------------------------------------------------
