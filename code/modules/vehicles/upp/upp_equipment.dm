/datum/ammo/grenade_container/smoke/upp
	name = "smoke grenade shell"
	nade_type = /obj/item/explosive/grenade/smokebomb
	icon_state = "smoke_shell"

// UPP ROCKETS/MISSILES
/datum/ammo/rocket/ap/hj35_launcher
	vehicle_damage_multiplier = 120 // 10 base damage -> 1200 against vehicles
	vehicle_penetration = 200
	icon = 'icons/obj/items/weapons/upp_vehicle_projectiles.dmi'
	icon_state = "hj35_missile"
	max_range = 8

// TANK CANNON
/datum/ammo/rocket/ltb/p17702
	icon = 'icons/obj/items/weapons/upp_vehicle_projectiles.dmi'
	name = "93mm round"
	icon_state = "p17702"
	flags_ammo_behavior = AMMO_ROCKET|AMMO_STRIKES_SURFACE

	accuracy = HIT_ACCURACY_TIER_3
	accurate_range = 32
	max_range = 32
	damage = 200
	shell_speed = AMMO_SPEED_TIER_3

// RAILGUN CANNON
/datum/ammo/rocket/ap/railgun
	icon = 'icons/obj/items/weapons/upp_vehicle_projectiles.dmi'
	name = "railgun round"
	icon_state = "railgun"
	flags_ammo_behavior = AMMO_ROCKET

	accuracy = HIT_ACCURACY_TIER_5
	accurate_range = 32
	max_range = 32
	damage = 2500
	damage_var_high = 120
	shell_speed = AMMO_SPEED_TIER_3
	var/vehicle_slowdown_time = 5 SECONDS
	penetration= ARMOR_PENETRATION_TIER_10

/datum/ammo/rocket/ap/railgun/do_at_max_range(obj/projectile/projectile)
	var/turf/turf = get_turf(projectile)
	var/hit_something = 0
	for(var/mob/mob in turf)
		mob.ex_act(450, projectile.dir, projectile.weapon_cause_data, 40)
		mob.apply_effect(3, WEAKEN)
		mob.apply_effect(3, PARALYZE)
		hit_something = 1
		break
	if(!hit_something)
		for(var/obj/object in turf)
			if(object.density)
				object.ex_act(250, projectile.dir, projectile.weapon_cause_data, 200)
				hit_something = 1
				break
	if(!hit_something)
		turf.ex_act(150, projectile.dir, projectile.weapon_cause_data)
	cell_explosion(turf, 550, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, projectile.weapon_cause_data)
	do_smoke(projectile, turf)

/datum/ammo/rocket/ap/railgun/on_hit_obj(obj/object, obj/projectile/projectile)
	if(istype(object, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/mob = object
		mob.next_move = world.time + vehicle_slowdown_time
		playsound(mob, 'sound/effects/meteorimpact.ogg', 35)
		mob.at_munition_interior_explosion_effect(cause_data = create_cause_data("railgun round"))
		mob.interior_crash_effect()
		var/turf/turf = get_turf(mob.loc)
		mob.ex_act(50, projectile.dir, projectile.weapon_cause_data, 50)
		cell_explosion(get_turf(mob), 100, 40, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, projectile.weapon_cause_data)
		do_smoke(projectile, turf)

		return
	return ..()

/datum/map_template/interior/upptank
	name = "UPP Tank"
	interior_id = "upptank"

/datum/map_template/interior/uppvan
	name = "UPP Van"
	interior_id = "uppvan"

/datum/map_template/interior/uppvan/medical
	name = "UPP Van Medical"
	interior_id = "uppvan_medical"

/datum/map_template/interior/uppvan/logistics
	name = "UPP Van Supply"
	interior_id = "uppvan_logistics"

/datum/map_template/interior/uppvan/prisoner
	name = "UPP Van Prisoner"
	interior_id = "uppvan_prisoner"

/datum/map_template/interior/uppvant
	name = "UPP Van Turret"
	interior_id = "uppvant"

/datum/map_template/interior/uppapc
	name = "ZSL-68"
	interior_id = "uppapc"

/turf/open/void/vehicle/unopacity
	density = TRUE
	opacity = FALSE

/obj/structure/machinery/computer/overwatch/upp/toc
	name = "TOC Overwatch Console"
	desc = "The Tactical Operations Center overwatch console. Many different screens make up the display."
	icon = 'icons/obj/structures/machinery/toc_upp.dmi'
	icon_state = "toc"
	bound_width = 64
	bound_height = 32
	layer = ABOVE_TABLE_LAYER
	density = TRUE

/obj/item/hardpoint/armor/reactive
	name = "\improper Reactive Armor"
	desc = "A set of explosive reactive armor panels for the tank hull that increases its resistance to shaped charges and kinetic penetrators."

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "reactive_armor"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "reactive_armor"

	health = 2000

	type_multipliers = list(
		"explosive" = 0.70,
		"bullet" = 0.70,
		"slash" = 0.70,
		"blunt" = 0.50,
		"all" = 0.9
	)

/obj/item/ammo_magazine/hardpoint/Gshk_minigun
	name = "Gshk Minigun Magazine"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/vehicles.dmi'
	desc = "A primary armament minigun magazine."
	caliber = "7.62x51mm" //Correlates to miniguns
	icon_state = "gshk"
	w_class = SIZE_LARGE //Primary weapon ammo should probably all be the same w_class
	default_ammo = /datum/ammo/bullet/tank/minigun
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/gshk_minigun

/obj/item/ammo_magazine/hardpoint/p17702
	name = "P-177-02 93mm Cannon Magazine"
	desc = "A primary armament cannon magazine"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/vehicles.dmi'
	caliber = "93mm" //Making this unique on purpose
	icon_state = "p17702_8"
	w_class = SIZE_LARGE //Heavy
	default_ammo = /datum/ammo/rocket/ltb/p17702
	max_rounds = 8
	gun_type = /obj/item/hardpoint/primary/upp_cannon

/obj/item/ammo_magazine/hardpoint/p17702/update_icon()
	icon_state = "p17702_[current_rounds]"

/obj/item/ammo_magazine/hardpoint/railgun
	name = "Railgun Cannon Magazine"
	desc = "A primary armament cannon magazine"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/vehicles.dmi'
	caliber = "93mm" //Making this unique on purpose
	icon_state = "railgun_4"
	w_class = SIZE_LARGE //Heavy
	default_ammo = /datum/ammo/rocket/ap/railgun
	max_rounds = 4
	gun_type = /obj/item/hardpoint/primary/upp_railgun

/obj/item/ammo_magazine/hardpoint/railgun/update_icon()
	icon_state = "railgun_[current_rounds]"

/obj/item/ammo_magazine/hardpoint/upp_smoke
	caliber = "grenade"
	w_class = SIZE_LARGE
	max_rounds = 10
	name = "UPP Turret Smoke Screen Magazine"
	desc = "A smoke grenades magazine used by upp apc turret."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/vehicles.dmi'
	icon_state = "upp_slauncher_1"
	default_ammo = /datum/ammo/grenade_container/smoke/upp
	gun_type = /obj/item/hardpoint/holder/tank_turret/uppapc

/obj/item/ammo_magazine/hardpoint/t60p3m
	name = "T6OP-3M Magazine (10x27mm)"
	desc = "A secondary armament MG magazine"
	caliber = "10x27mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/vehicles.dmi'
	icon_state = "t60p3m"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/rifle/upp_vehicle_tracer
	max_rounds = 500
	gun_type = /obj/item/hardpoint/secondary/t60p3m

// HJ-35 FOR UPP APC

/obj/item/ammo_magazine/hardpoint/hj35launcher
	name = "HJ-35 Launcher Magazine"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/vehicles.dmi'
	desc = "A secondary armament rocket magazine"
	caliber = "rocket" //correlates to any rocket mags
	icon_state = "hj35"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/rocket/ap/hj35_launcher
	max_rounds = 3
	gun_type = /obj/item/hardpoint/secondary/hj35launcher

/obj/item/hardpoint/primary/gshk_minigun
	muzzle_flash_anchors = list(
		"1" = list(0.5, 40.5),
		"2" = list(0.5, -36.5),
		"4" = list(40.5, 0.5),
		"8" = list(-39.5, 0.5),
	)
	name = "\improper Gshk-5000.K minigun"
	desc = "Electric rotor Gatling gun. Originating from a man-portable design, the Gshk-5000.K is an anti-personnel system that provides effective fire support and suppression. Unlike the American GAU-8, the Gshk-5000.K uses an electrical pulse action in place of hypergolic liquid fuels."
	icon = 'icons/obj/vehicles/hardpoints/uppapc.dmi'

	icon_state = "apc_minigun"
	disp_icon = 'icons/obj/vehicles/uppapc.dmi'
	disp_icon_state = "apc_minigun"

	health = 1000
	traverse_arc = 90

	ammo = new /obj/item/ammo_magazine/hardpoint/Gshk_minigun
	max_clips = 2

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(16.5, 45),
		"2" = list(16.3, -43),
		"4" = list(63, 0.5),
		"8" = list(-30, 1)
	)

	scatter = 3
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.2 SECONDS //base fire rate, modified by stage_delay_mult

	activation_sounds = list('sound/weapons/gun_minigun.ogg')
	/// Active firing time to reach max spin_stage.
	var/spinup_time = 8 SECONDS
	/// Grace period before losing spin_stage.
	var/spindown_grace_time = 2 SECONDS
	COOLDOWN_DECLARE(spindown_grace_cooldown)
	/// Cooldown time to reach min spin_stage.
	var/spindown_time = 3 SECONDS
	/// Index of stage_rate.
	var/spin_stage = 1
	/// Shots fired per fire_delay at a particular spin_stage.
	var/list/stage_rate = list(1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5)
	/// Fire delay multiplier for current spin_stage.
	var/stage_delay_mult = 1
	/// When it was last fired, related to world.time.
	var/last_fired = 0

/obj/item/hardpoint/primary/gshk_minigun/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/gshk_minigun/set_fire_delay(value)
	fire_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay * stage_delay_mult)

/obj/item/hardpoint/primary/gshk_minigun/set_fire_cooldown()
	calculate_stage_delay_mult() //needs to check grace_cooldown before refreshed
	last_fired = world.time
	COOLDOWN_START(src, spindown_grace_cooldown, spindown_grace_time)
	COOLDOWN_START(src, fire_cooldown, fire_delay * stage_delay_mult)

/obj/item/hardpoint/primary/gshk_minigun/proc/calculate_stage_delay_mult()
	var/stage_rate_len = stage_rate.len
	var/delta_time = world.time - last_fired

	var/old_spin_stage = spin_stage
	if(auto_firing || burst_firing) //spinup if continuing fire
		var/delta_stage = delta_time * (stage_rate_len - 1)
		spin_stage += delta_stage / spinup_time
	else if(COOLDOWN_FINISHED(src, spindown_grace_cooldown)) //spindown if initiating fire after grace
		var/delta_stage = (delta_time - spindown_grace_time) * (stage_rate_len - 1)
		spin_stage -= delta_stage / spindown_time
	else
		return
	spin_stage = clamp(spin_stage, 1, stage_rate_len)

	var/old_stage_rate = stage_rate[floor(old_spin_stage)]
	var/new_stage_rate = stage_rate[floor(spin_stage)]

	if(old_stage_rate != new_stage_rate)
		stage_delay_mult = 1 / new_stage_rate
		SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay * stage_delay_mult)

// UPP Cannon for upp tank
/obj/item/hardpoint/primary/upp_cannon
	parent_type = /obj/item/hardpoint/primary/cannon
	muzzle_flash_anchors = list(
		"1" = list(0.5, 56.5),
		"2" = list(-0.5, -29.5),
		"4" = list(60.5, -3),
		"8" = list(-59.5, -3),
	)
	name = "\improper P-177-02 93mm Cannon"
	desc = " Developed in Vietnam as part of a multinational project including China, Cambodia and Laos. This 93mm smoothbore cannon is seen in use with several light UPP vehicles and defensive fortifications. Though it's most notable as the standard gun for the Cheetah 2A. A rugged gun capable of operating in the most inhospitable environments, be it deep-sea trenches, airless moons, alien bogs or impossible jungles."

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "p17702"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "p17702"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 2000
	traverse_arc = 60

	ammo = new /obj/item/ammo_magazine/hardpoint/p17702
	max_clips = 4

	px_offsets = list(
		"1" = list(-1, 18),
		"2" = list(0, -38),
		"4" = list(17, 12),
		"8" = list(-18, 12)
	)

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(0, 67),
		"2" = list(-1, -88),
		"4" = list(86, -6),
		"8" = list(-86, -6)
	)

	scatter = 0
	fire_delay = 10.0 SECONDS

// UPP Cannon for upp tank
/obj/item/hardpoint/primary/upp_railgun
	muzzle_flash_anchors = list(
		"1" = list(0.5, 60.5),
		"2" = list(-0.5, -32.5),
		"4" = list(61.5, -2.5),
		"8" = list(-60.5, -2.5),
	)
	name = "\improper Railgun Cannon"
	desc = "An experimental chemical-railgun developed in a secreted orbital facility outside of Sol for hard targets, such as bunkers or dedicated armour. Using a high-efficiency hypergolic propellant as the first stage, which is then accelerated to blistering velocities by the magentic rails. Thanks to excessive energy requirements, the turret internals were significantly remodelled to account for the capacitors and dedicated generator. Suffers from wear-through issues on barrels, and heat-masking."

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "railgun"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "railgun"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 2300
	traverse_arc = 60

	ammo = new /obj/item/ammo_magazine/hardpoint/railgun
	max_clips = 2

	px_offsets = list(
		"1" = list(-1, 18),
		"2" = list(0, -38),
		"4" = list(17, 12),
		"8" = list(-18, 12)
	)

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(0, 67),
		"2" = list(-1, -88),
		"4" = list(86, -6),
		"8" = list(-86, -6)
	)

	scatter = 0
	fire_delay = 15.0 SECONDS

/obj/item/hardpoint/secondary/hj35launcher
	muzzle_flash_anchors = list(
		"1" = list(-15.5, 18.5),
		"2" = list(16.5, -12.5),
		"4" = list(15.5, 17.5),
		"8" = list(-13.5, -11.5),
	)
	name = "\improper HJ-35 Launcher"
	desc = "A secondary weapon for upp apc that shoots rockets"
	icon = 'icons/obj/vehicles/hardpoints/uppapc.dmi'

	icon_state = "hj35launcher"
	disp_icon = 'icons/obj/vehicles/uppapc.dmi'
	disp_icon_state = "apc_hj35"

	health = 2000
	traverse_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/hj35launcher
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(1, 20),
		"2" = list(33, -25),
		"4" = list(39, 16),
		"8" = list(-5, -10)
	)

	scatter = 2
	fire_delay = 7.0 SECONDS

/obj/item/hardpoint/secondary/hj35launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

// for upp tank
/obj/item/hardpoint/secondary/hj35launcher/upptank
	name = "\improper HJ-35-T Launcher"
	desc = "A secondary weapon for upp tank that shoots rockets"
	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'

	icon_state = "hj35tlauncher"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "hj35t"

	health = 2000
	traverse_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/hj35launcher
	max_clips = 1

	use_muzzle_flash = FALSE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(33, 20),
		"2" = list(-33, -25),
		"4" = list(39, 0),
		"8" = list(-5, 10)
	)

/obj/item/hardpoint/secondary/t60p3m
	muzzle_flash_anchors = list("1" = list(13.5, 33.5), "2" = list(-14.5, -13.5), "4" = list(26.5, 3.5), "8" = list(-26.5, 25.5))
	name = "\improper T6OP-3M 'Buzzard' RWS"
	desc = "An older, albeit modernized remote machinegun seen in use by the Cheetah 2A. This Russo-Polish developed machinegun features robust autonomous fire capability, and was commonly used to intercept low-threat projectiles, though thanks to the superior active and passive systems in most vehicles, tankists now prefer to simply fire it at infantry and soft targets instead. Known for an annoying tendency for drifting off target in certain high temperature environments."

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "t60p3m"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "t60p3m"
	activation_sounds = list('sound/weapons/heavy_weapon_firing_sounds/gun_smartgun1.ogg', 'sound/weapons/heavy_weapon_firing_sounds/gun_smartgun2.ogg', 'sound/weapons/heavy_weapon_firing_sounds/gun_smartgun3.ogg', 'sound/weapons/heavy_weapon_firing_sounds/gun_smartgun4.ogg')

	health = 2000
	traverse_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/t60p3m
	max_clips = 1

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(8, -7),
		"2" = list(-7, -21),
		"4" = list(12, -10),
		"8" = list(-11, 7)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.1 SECONDS

/obj/item/hardpoint/secondary/t60p3m/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

// UPP APC
/obj/item/hardpoint/support/flare_launcher/upp
	name = "\improper ZSL-Flare Launcher"
	desc = "A support module for APCs that shoots flares."
	icon = 'icons/obj/vehicles/hardpoints/uppapc.dmi'

	icon_state = "upp_flare_launcher"
	disp_icon = 'icons/obj/vehicles/uppapc.dmi'
	disp_icon_state = "upp_flare_launcher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	damage_multiplier = 0.15

	activatable = TRUE

	health = 1500
	traverse_arc = 120

	allowed_seat = VEHICLE_DRIVER

	max_clips = 0

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_laser"

	muzzle_flash_pos = list(
		"1" = list(38, 50),
		"2" = list(-5, -38),
		"4" = list(63, 5),
		"8" = list(-30, 42)
	)

	scatter = 6
	fire_delay = 3.0 SECONDS

// UPP TANK
/obj/item/hardpoint/support/flare_launcher/upptank
	name = "\improper VT/CZ-Flare Launcher"
	desc = "A support module for Tanks that shoots flares."
	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'

	icon_state = "turret_slauncher"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "turret_slauncher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	damage_multiplier = 0.15

	activatable = TRUE

	health = 1500
	traverse_arc = 120

	allowed_seat = VEHICLE_GUNNER

	use_muzzle_flash = FALSE

// UPP APC
/obj/item/hardpoint/locomotion/apc_wheels/zsl_wheels
	name = "\improper ZSL wheels"
	desc = "Integral to the movement of the ZSL"
	icon = 'icons/obj/vehicles/hardpoints/uppapc.dmi'

	damage_multiplier = 0.20

	icon_state = "upp_tires"
	disp_icon = 'icons/obj/vehicles/uppapc.dmi'
	disp_icon_state = "wheels"

	health = 1650

	move_delay = VEHICLE_SPEED_SUPERFAST
	move_max_momentum = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.5

/obj/item/hardpoint/locomotion/van_wheels/upp
	name = "UPP Van wheels"
	desc = "Integral to the movement of the upp van"
	icon = 'icons/obj/vehicles/hardpoints/uppvan.dmi'

	icon_state = "upp_tires"
	disp_icon = 'icons/obj/vehicles/uppvan.dmi'
	disp_icon_state = "wheels"

	slot = HDPT_WHEELS

	health = 1200

	move_delay = VEHICLE_SPEED_VERYFAST

/area/interior/vehicle/uppapc
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP ZSL-68 interior"
	icon_state = "upp_apc"

/area/interior/vehicle/upptank
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP tank interior"
	icon_state = "upp_tank"

/area/interior/vehicle/uppvan
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP van interior"
	icon_state = "upp_van"

/area/interior/vehicle/uppvant
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP van turret interior"
	icon_state = "upp_vant"

/area/interior/vehicle/uppvan/medical
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP van medical interior"
	icon_state = "upp_van_medical"

/area/interior/vehicle/uppvan/logistics
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP van logistics interior"
	icon_state = "upp_van_logistics"

/area/interior/vehicle/uppvan/prisoner
	icon = 'icons/turf/areas_upp_interiors.dmi'
	name = "\improper UPP van prisoner interior"
	icon_state = "upp_van_prisoner"

// GUNNER VAN Seat
/obj/structure/bed/chair/comfy/vehicle/van_gunner
	name = "gunner's seat"
	desc = "Comfortable seat for a gunner."
	seat = VEHICLE_GUNNER
	required_skill = SKILL_VEHICLE_DEFAULT

/obj/structure/vehicle_locker/tank/upp
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "locker"

/obj/structure/vehicle_locker/tank/upp1
	name = "storage ammunition"
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "storage_ammo"

/obj/structure/vehicle_locker/tank/upp2
	name = "Locker"
	desc = "Small storage unit allowing vehicle crewmen to store their personal possessions. Only vehicle crewmen can access these."
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "small_locker"

/obj/structure/vehicle_locker/tank/upp3
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "small_locker1"

/obj/structure/vehicle_locker/uppvan
	name = "storage ammunition"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "small_storage"

// UPP VAN Gunner without skill
/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/armor/van
	name = "armor gunner's seat spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "armor_chair"
	color = "yellow"

/obj/effect/landmark/interior/spawn/vehicle_gunner_seat/armor/van/on_load(datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/van_gunner/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/item/ammo_magazine/hardpoint/upp_smoke/update_icon()
	icon_state = "upp_slauncher_[current_rounds > 0]"

/obj/item/hardpoint/iff_module/upp
	name = "UPP vehicle IFF module"
	set_faction = FACTION_UPP

// Preserve the Buzzard's original heavy tracer without importing PvE's rifle hierarchy.
/datum/ammo/bullet/rifle/upp_vehicle_tracer
	name = "10x27mm tracer"
	damage = 55
	penetration = ARMOR_PENETRATION_TIER_3
	accuracy = HIT_ACCURACY_TIER_3
	shell_speed = AMMO_SPEED_TIER_6
	effective_range_max = 10
	damage_falloff = DAMAGE_FALLOFF_TIER_9
	icon_state = "bullet_red"

// There is no UPP dropship on this branch. Keep the interior screen as an inert prop.
/obj/structure/prop/upp_vehicle_flight_screen
	name = "disconnected dropship control screen"
	desc = "A remote flight-control screen. No compatible UPP dropship is linked."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "toc_shuttle"
	anchored = TRUE

// The armed van has its own 96px weapon overlay; the tank uses a 128px sheet.
/obj/item/hardpoint/secondary/t60p3m/van
	muzzle_flash_anchors = list("1" = list(-0.5, 19.5), "2" = list(-0.5, -19.5), "4" = list(19.5, 1.5), "8" = list(-20.5, 1.5))
	disp_icon = 'icons/obj/vehicles/uppvan.dmi'

/obj/item/hardpoint/locomotion/treads/upp
	disp_icon = 'icons/obj/vehicles/upptank.dmi'

/obj/item/hardpoint/support/weapons_sensor/upp
	disp_icon = 'icons/obj/vehicles/upptank.dmi'

/obj/item/hardpoint/support/artillery_module/upp
	disp_icon = 'icons/obj/vehicles/upptank.dmi'

// These consoles sit against the wall on the gunner's floor tile.
/obj/structure/weapons_loader/wall_mounted
	density = FALSE

/obj/effect/landmark/interior/spawn/weapons_loader/wall_mounted
	loader_type = /obj/structure/weapons_loader/wall_mounted
