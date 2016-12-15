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

--Turns on debug messages
debug = true;

--force selectes all heroes to value of requireHero
requireHero = "npc_dota_hero_axe";
useRequiredHero = true;

--All currently supported bots
allBotHeroes = {
		'npc_dota_hero_axe',
		'npc_dota_hero_bane',
		'npc_dota_hero_bloodseeker',
		'npc_dota_hero_bounty_hunter',
		'npc_dota_hero_bristleback',
		'npc_dota_hero_chaos_knight',
		'npc_dota_hero_crystal_maiden',
		'npc_dota_hero_dazzle',
		'npc_dota_hero_death_prophet',
		'npc_dota_hero_dragon_knight',
		'npc_dota_hero_drow_ranger',
		'npc_dota_hero_earthshaker',
		'npc_dota_hero_jakiro',
		'npc_dota_hero_juggernaut',
		'npc_dota_hero_kunkka',
		'npc_dota_hero_lich',
		'npc_dota_hero_lina',
		'npc_dota_hero_lion',
		'npc_dota_hero_luna',
		'npc_dota_hero_necrolyte',
		'npc_dota_hero_nevermore',
		'npc_dota_hero_omniknight',
		'npc_dota_hero_oracle',
		'npc_dota_hero_phantom_assassin',
		'npc_dota_hero_pudge',
		'npc_dota_hero_razor',
		'npc_dota_hero_sand_king',
		'npc_dota_hero_skeleton_king',
		'npc_dota_hero_skywrath_mage',
		'npc_dota_hero_sniper',
		'npc_dota_hero_sven',
		'npc_dota_hero_tidehunter',
		'npc_dota_hero_tiny',
		'npc_dota_hero_vengefulspirit',
		'npc_dota_hero_viper',
		'npc_dota_hero_warlock',
		'npc_dota_hero_windrunner',
		'npc_dota_hero_witch_doctor',
		'npc_dota_hero_zuus'
};

--Array of all currently selected heroes
selectedHeroes = {};

function Think()
	print(requireHero)
	--Time delay when choosing heroes
	local delay = 70;

	if (DotaTime() + delay >= delay-1 and not useRequiredHero)
	then

		if ( GetTeam() == TEAM_RADIANT )
		then
			SelectHero(0, selectRandomHero());
			SelectHero(1, selectRandomHero());
			SelectHero(2, selectRandomHero());
			SelectHero(3, selectRandomHero());
			SelectHero(4, selectRandomHero());
		elseif ( GetTeam() == TEAM_DIRE )
		then
			SelectHero(5, selectRandomHero());
			SelectHero(6, selectRandomHero());
			SelectHero(7, selectRandomHero());
			SelectHero(8, selectRandomHero());
			SelectHero(9, selectRandomHero());
		end

	elseif (useRequiredHero)
		then

			if ( GetTeam() == TEAM_RADIANT )
			then
				SelectHero(0, requireHero);
				SelectHero(1, requireHero);
				SelectHero(2, requireHero);
				SelectHero(3, requireHero);
				SelectHero(4, requireHero);
			elseif ( GetTeam() == TEAM_DIRE )
			then
				SelectHero(5, requireHero);
				SelectHero(6, requireHero);
				SelectHero(7, requireHero);
				SelectHero(8, requireHero);
				SelectHero(9, requireHero);
			end
		end
end

----------------------------------------------------------------------------------------------------
--Global Functions--

function selectRandomHero(teamSlot)

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
