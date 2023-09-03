#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_magicbox;

init()
{
    level thread onPlayerConnect();
    level thread health();

    setdvar( "player_strafeSpeedScale", 1 );
    setdvar( "player_backSpeedScale", 1 );
}

health() {
    for(;;) {
        if(level.round_number > 158) {
            zombies = GetAIArray("axis");

            for(i = 0; i < zombies.size; i++) {
                if (zombies[i].targetname != "zombie") {
                }
                else if(zombies[i].targetname == "zombie") {
                    if(!isDefined(zombies[i].health_override)) {
                        zombies[i].health_override = true;
                        zombies[i].health = 1390371547; //cap at 158 so traps keep working
                        //iprintln("zombie[0] health: " + zombies[i].health); wait(.5);
                    }
                }
            }
        }
        wait(.1);
    }
}

onPlayerConnect()
{
	while(true)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread GivePermaPerks();
		player thread GiveBank();
        player thread GiveCharacter();
		player thread GiveFridge();
    }
}

onPlayerSpawned()
{
    level endon( "game_ended" );
	self endon( "disconnect" );

	self thread timer_hud();
	self.initialspawn = true;

	for( ; ; )
	{
    	self waittill( "spawned_player" );

    	if (self.initalspawn)
		{
			self.initialspawn = false;
			if( getdvar( "mapname" ) == "zm_highrise" || getdvar( "mapname" ) == "zm_buried" || getdvar( "mapname" ) == "zm_transit" )
			{
				self thread GiveCharacter();
			}
		}
	}
}

GivePermaPerks()  
{
	flag_wait("initial_blackscreen_passed");
	permaperks = strTok("pers_boarding, pers_revivenoperk, pers_multikill_headshots, pers_cash_back_bought, pers_cash_back_prone, pers_insta_kill, pers_jugg, pers_carpenter, pers_flopper_counter, pers_perk_lose_counter, pers_pistol_points_counter, pers_double_points_counter, pers_sniper_counter, pers_box_weapon_counter, pers_nube_counter", ",");
	for (i = 0; i < permaperks.size; i++)
	{
		self increment_client_stat(permaperks[i], 0);
		wait 0.25;
	}
}

GiveBank()
{
	flag_wait("initial_blackscreen_passed");
	self set_map_stat("depositBox", 250, level.banking_map);
	self.account_value = 250000;
}

GiveFridge()
{
	flag_wait("initial_blackscreen_passed");

	self clear_stored_weapondata();
	self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms" );
}

GiveCharacter()
{	
	if (level.force_team_characters != 1)
	{
		self setviewmodel( "c_zom_farmgirl_viewhands" );
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50 );
	    self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600 );
	}
}
