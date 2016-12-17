--[[

	In the Think() function the remaining slots will be filled with a random hero from
	the list of currently supported heroes based on the current teams composition.

	--Todo--
	-Find any players and dont fill those slots with people. - Unknown if possible with current API
	-Fill bot slots with random bots - DONE
	-Make sure bots dont select a hero that is already choosen. - DONE
	-Fill bots with the needed role - DONE
	-Add debug support for specific heroes - DONE
	-Sort all heroes into subclasses and update calculateTeamComp()
	-Add debug support for calculateTeamComp() -DONE
	-Clean Debug messages - DONE

]]
----------------------------------------------------------------------------------------------------

--load in the heroes
require( GetScriptDirectory().."/heroes" )

--Turns on debug messages
debug = true;

--force selectes all heroes to value of requireHero
requireHero = "npc_dota_hero_lina";
useRequiredHero = false;

--Array of all currently selected heroes
selectedHeroes = {};

radiantTeam = {};
direTeam = {};

function Think()
	--Time delay when choosing heroes
	local delay = 70;

	if (DotaTime() + delay >= delay-1 and not useRequiredHero)
	then
		--For each slot select a random hero
		for i=0,9 do
			SelectHero(i, selectRandomHero(i));
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

function selectRandomHero(slot)
--[[
	This function returns a random hero in the slot provided
]]

	--updates selected heroes list
	for i=0,9 do
		selectedHeroes[i] = GetSelectedHeroName(i);

		if (slot <= 4)
		then

			--Assigns the current heroes on radiant team
			for t=0,4 do
				radiantTeam[t] = GetSelectedHeroName(t)
			end

		elseif (slot >= 5)
		then

			--Assigns the current heroes on dire team
			for t=0,4 do
				direTeam[t] = GetSelectedHeroName(t+5)
			end

		end

		if (debug and selectedHeroes[i] ~= "") then print("Slot " .. i .. ": " .. selectedHeroes[i]) end; -- Debug Text
	end

	--Sets the randomseed to current time
	math.randomseed(RealTime());

		local hero; -- I'm you're average everyday local hero

		--Randomly generates a hero from bot list
		hero = generateHero(calculateTeamComp(slot));

		--Checks to see if a the random hero is repeated
		for i=0,table.getn(allBotHeroes) do --This for loop helps ensure no heroes are repeated
			for _,v in pairs(selectedHeroes) do
				if v == hero then
					hero = generateHero(calculateTeamComp(slot));

					if (debug) then print("Repeat hero repicking...") end -- Debug Text
				end
			end
		end


	--returns the random hero
	return hero;

end



function calculateTeamComp(slot)
	--[[
	This function will return a number based on what the team composition needs
	Currently the team set up is grouped into 3 sections: Carry, Support, Other
	1 - carry 2 - support 3 - other
	]]

	local carry,support,other = 0,0,0;

	--Calculate for radiant
	if (slot <= 4) then

			--Count all carrys on the team
		for _,h in pairs(botCarry) do
			for _,v in pairs(radiantTeam) do
				if v == h then
					carry = carry + 1;
				end
			end
		end

		--Count all supports on the team
		for _,h in pairs(botSupport) do
			for _,v in pairs(radiantTeam) do
				if v == h then
					support = support + 1;
				end
			end
		end

		--Count all others on the team
		for _,h in pairs(botOther) do
			for _,v in pairs(radiantTeam) do
				if v == h then
					other = other + 1;
				end
			end
		end

	--Calculate for Dire
elseif (slot >= 5) then

		--Count all carrys on the team
		for _,h in pairs(botCarry) do
			for _,v in pairs(direTeam) do
				if v == h then
					carry = carry + 1;
				end
			end
		end

		--Count all supports on the team
		for _,h in pairs(botSupport) do
			for _,v in pairs(direTeam) do
				if v == h then
					support = support + 1;
				end
			end
		end

		--Count all others on the team
		for _,h in pairs(botOther) do
			for _,v in pairs(direTeam) do
				if v == h then
					other = other + 1;
				end
			end
		end

	end

	if(debug) then print("Carry: " .. carry .. " Support: " .. support .. " Other: " .. other) end;

--Returns the needed role
	if(carry<2) then
			return 1;
	elseif(other<1) then
			return 2;
	elseif(support<2) then
			return 3;
	end

end

function generateHero(type)
	--[[
	This function generates a random hero based on the type provided in calculateTeamComp()
	]]

	if(type == 1) then return botCarry[math.random(table.getn(botCarry))] end
	if(type == 2) then return botOther[math.random(table.getn(botOther))] end
	if(type == 3) then return botSupport[math.random(table.getn(botSupport))] end
end

----------------------------------------------------------------------------------------------------
