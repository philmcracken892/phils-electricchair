Config = {}

---------------
-- SETTINGS
---------------
Config.BanditsPerRaid 			= math.random(5, 10)
Config.EndRaidTime 				= 1800000 -- 30 minute finish raid for time
Config.WaitTimeBetweenPoints 	= 60000 -- 1 minute move point selected
Config.Radius 					= 5.0 -- Adjust this value to change the spread of the formation
Config.AggressionRange 			= 300.0 -- or whatever range you want, in game units
Config.BanditAccuracy 			= math.random(50, 100) 

Config.AutoRaidEnabled = true
Config.AutoRaidInterval = 31 -- in minutes  set to 2 mins for testing 

---------------
-- EXTRA 
---------------
Config.BossBandits 				= true
Config.BossPerRaid 				= math.random(1, 2)
Config.FollowBossDistance 		= 5.0 -- follow boss BossBandits

---------------
-- LOCATIONS
---------------
Config.RaidPaths = {
    {	id = 'valentine',
        spawnPoint = vector3(-31.26, 1103.94, 169.11),
        path = {
            vector3(-308.80, 787.52, 117.65),
            vector3(-309.57, 788.26, 117.64),
            vector3(-263.31, 806.52, 118.72),
            vector3(-245.22, 747.65, 116.24),
            vector3(-387.93, 776.61, 115.76),
            vector3(-331.15, 784.70, 116.15),
        }
    },
    {	id = 'valentine2',
        spawnPoint = vector3(-703.30, 681.14, 60.90),
        path = {
            vector3(-331.15, 784.70, 116.15),
            vector3(-308.80, 787.52, 117.65),
            vector3(-309.57, 788.26, 117.64),
            vector3(-263.31, 806.52, 118.72),
            vector3(-245.22, 747.65, 116.24),
            vector3(-387.93, 776.61, 115.76),
        }
    },
    {	id = 'heartland',
        spawnPoint = vector3(511.96, 894.55, 144.06),
        path = {
            vector3(489.06, 697.83, 116.02),
            vector3(474.59, 613.51, 110.67),
        }
    },
    {	id = 'heartland2',
        spawnPoint = vector3(544.48, 367.24, 107.01),
        path = {
            vector3(489.06, 697.83, 116.02),
            vector3(474.59, 613.51, 110.67),
        }
    },
    {	id = 'emerald',
        spawnPoint = vector3(1563.55, 488.24, 89.81),
        path = {
            vector3(1421.37, 257.33, 90.54),
            vector3(1426.49, 326.98, 88.39),
        }
    },
    {	id = 'emerald2',
        spawnPoint = vector3(1667.33, 71.42, 77.07),
        path = {
            vector3(1421.37, 257.33, 90.54),
            vector3(1426.49, 326.98, 88.39),
        }
    },
    {	id = 'rhodes',
        spawnPoint = vector3(1542.60, -1411.14, 62.71),
        path = {
            vector3(1300.80, -1293.41, 76.26),
            vector3(1332.90, -1307.91, 76.52),
        }
    },
    {	id = 'rhodes2',
        spawnPoint = vector3(1151.81, -1159.28, 71.07),
        path = {
            vector3(1300.80, -1293.41, 76.26),
            vector3(1332.90, -1307.91, 76.52),
        }
    },
    {	id = 'vanhorn',
        spawnPoint = vector3(2926.35, 414.15, 48.98),
        path = {
            vector3(2958.76, 525.67, 44.60),
        }
    },
    {	id = 'Annesburg',
        spawnPoint = vector3(2599.62, 1317.01, 112.57),
        path = {
            vector3(2806.30, 1351.06, 71.61),
            vector3(2933.32, 1323.93, 44.15),
            vector3(3018.54, 1442.82, 46.66),
        }
    },
    -- Add more raid paths as needed 
}

---------------
-- DEFAULT MODELS
---------------
Config.Weapons = {
    0x772C8DD6,
	0x169F59F7,
	0xDB21AC8C,
	0x6DFA071B,
    0xF5175BA1,
	0xD2718D48,
	0x797FBF5,
	0x772C8DD6,
    0x7BBD1FF6,
	0x63F46DE6,
	0xA84762EC,
	0xDDF7BC1E,
    0x20D13FF,
	0x1765A8F8,
	0x657065D6,
	0x8580C63E,
    0x95B24592,
	0x31B7B9FE,
	0x88A855C,
	0x1C02870C,
    0x28950C71,
	0x6DFA071B
}

Config.HorseModels = {
	"A_C_HORSE_GANG_KIERAN",
	"A_C_HORSE_MORGAN_BAY",
	"A_C_HORSE_MORGAN_BAYROAN",
	"A_C_HORSE_MORGAN_FLAXENCHESTNUT",
	"A_C_HORSE_MORGAN_PALOMINO",
	"A_C_HORSE_KENTUCKYSADDLE_BLACK",
	"A_C_HORSE_KENTUCKYSADDLE_CHESTNUTPINTO",
	"A_C_HORSE_KENTUCKYSADDLE_GREY",
	"A_C_HORSE_KENTUCKYSADDLE_SILVERBAY",
	"A_C_HORSE_TENNESSEEWALKER_BLACKRABICANO",
	"A_C_HORSE_TENNESSEEWALKER_CHESTNUT",
	"A_C_HORSE_TENNESSEEWALKER_DAPPLEBAY",
	"A_C_HORSE_TENNESSEEWALKER_REDROAN",
	"A_C_HORSE_AMERICANPAINT_GREYOVERO",
	"A_C_HORSE_AMERICANSTANDARDBRED_PALOMINODAPPLE",
	"A_C_HORSE_AMERICANSTANDARDBRED_SILVERTAILBUCKSKIN",
	"A_C_HORSE_ANDALUSIAN_DARKBAY",
	"A_C_HORSE_ANDALUSIAN_ROSEGRAY",
	"A_C_HORSE_APPALOOSA_BROWNLEOPARD",
	"A_C_HORSE_APPALOOSA_LEOPARD",
	"A_C_HORSE_ARABIAN_BLACK",
	"A_C_HORSE_ARABIAN_ROSEGREYBAY",
	"A_C_HORSE_ARDENNES_BAYROAN",
	"A_C_HORSE_ARDENNES_STRAWBERRYROAN",
	"A_C_HORSE_BELGIAN_BLONDCHESTNUT",
	"A_C_HORSE_BELGIAN_MEALYCHESTNUT",
	"A_C_HORSE_DUTCHWARMBLOOD_CHOCOLATEROAN",
	"A_C_HORSE_DUTCHWARMBLOOD_SEALBROWN",
	"A_C_HORSE_DUTCHWARMBLOOD_SOOTYBUCKSKIN",
	"A_C_HORSE_HUNGARIANHALFBRED_DARKDAPPLEGREY",
	"A_C_HORSE_HUNGARIANHALFBRED_PIEBALDTOBIANO",
	"A_C_HORSE_MISSOURIFOXTROTTER_AMBERCHAMPAGNE",
	"A_C_HORSE_MISSOURIFOXTROTTER_SILVERDAPPLEPINTO",
	"A_C_HORSE_NOKOTA_REVERSEDAPPLEROAN",
	"A_C_HORSE_SHIRE_DARKBAY",
	"A_C_HORSE_SHIRE_LIGHTGREY",
	"A_C_HORSE_SUFFOLKPUNCH_SORREL",
	"A_C_HORSE_SUFFOLKPUNCH_REDCHESTNUT",
	"A_C_HORSE_TENNESSEEWALKER_FLAXENROAN",
	"A_C_HORSE_THOROUGHBRED_BRINDLE",
	"A_C_HORSE_TURKOMAN_DARKBAY",
	"A_C_HORSE_TURKOMAN_GOLD",
	"A_C_HORSE_TURKOMAN_SILVER",
	"A_C_HORSE_GANG_BILL",
	"A_C_HORSE_GANG_CHARLES",
	"A_C_HORSE_GANG_DUTCH",
	"A_C_HORSE_GANG_HOSEA",
	"A_C_HORSE_GANG_JAVIER",
	"A_C_HORSE_GANG_JOHN",
	"A_C_HORSE_GANG_KAREN",
	"A_C_HORSE_GANG_LENNY",
	"A_C_HORSE_GANG_MICAH",
	"A_C_HORSE_GANG_SADIE",
	"A_C_HORSE_GANG_SEAN",
	"A_C_HORSE_GANG_TRELAWNEY",
	"A_C_HORSE_GANG_UNCLE",
	"A_C_HORSE_GANG_SADIE_ENDLESSSUMMER",
	"A_C_HORSE_GANG_CHARLES_ENDLESSSUMMER",
	"A_C_HORSE_GANG_UNCLE_ENDLESSSUMMER",
	"A_C_HORSE_AMERICANPAINT_OVERO",
	"A_C_HORSE_AMERICANPAINT_TOBIANO",
	"A_C_HORSE_AMERICANPAINT_SPLASHEDWHITE",
	"A_C_HORSE_AMERICANSTANDARDBRED_BLACK",
	"A_C_HORSE_AMERICANSTANDARDBRED_BUCKSKIN",
	"A_C_HORSE_APPALOOSA_BLANKET",
	"A_C_HORSE_APPALOOSA_LEOPARDBLANKET",
	"A_C_HORSE_ARABIAN_WHITE",
	"A_C_HORSE_HUNGARIANHALFBRED_FLAXENCHESTNUT",
	"A_C_HORSE_MUSTANG_GRULLODUN",
	"A_C_HORSE_MUSTANG_WILDBAY",
	"A_C_HORSE_MUSTANG_TIGERSTRIPEDBAY",
	"A_C_HORSE_NOKOTA_BLUEROAN",
	"A_C_HORSE_NOKOTA_WHITEROAN",
	"A_C_HORSE_THOROUGHBRED_BLOODBAY",
	"A_C_HORSE_THOROUGHBRED_DAPPLEGREY",
	"A_C_Donkey_01",
}

Config.BanditsModel = {
	"G_M_M_UniBanditos_01",
	"A_M_M_GRIFANCYDRIVERS_01",
	"A_M_M_NEAROUGHTRAVELLERS_01",
	"A_M_M_RANCHERTRAVELERS_COOL_01",
	"A_M_M_RANCHERTRAVELERS_WARM_01",
	"mp_g_f_m_owlhootfamily_01",
	"a_m_m_skpprisoner_01",
	"g_m_m_uniduster_02",
	"g_m_y_uniexconfeds_02",
}

Config.BossModel = {
	"mp_u_m_m_bountytarget_050",
	"mp_u_m_m_bountytarget_052",
	"mp_u_m_m_bountytarget_054",
	"mp_u_m_m_protect_mercer_contact_01",
	"re_deadbodies_males_01",
	"u_m_m_unidusterhenchman_02",
	"mp_fm_stakeout_corpses_males_01",
	"mp_u_f_m_laperlevipmasked_03",
	"mp_u_f_m_laperlevipmasked_02",
	"cs_mp_alfredo_montez",
	"cs_mp_cripps",
	"mes_finale3_males_01",
	"u_f_m_story_nightfolk_01",
	"mp_u_f_m_gunslinger3_rifleman_02",
	"mp_u_f_m_bountytarget_011",
	"mp_u_f_m_bountytarget_006",
	"mp_u_f_m_bountytarget_008",
	"cs_mp_bountyhunter",
	"cs_famousgunslinger_05",
}
