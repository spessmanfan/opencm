//UPP TURRET
/obj/item/hardpoint/holder/tank_turret/uppturret
	parent_type = /obj/item/hardpoint/holder/tank_turret/upp
	name = "\improper VT/CZ 'Condor' Turret"
	desc = "VT/CZ 'Condor' Turret complex, developed in the Czech Republic with assistance from Austria and Slovakia. Produced as part of the 'A' upgrade package for the Cheetah 2, the VT/CZ follows the familiar philosophy of most UPP equipment: Modularity. Its' ability to mount a wide array of weapon systems both quickly and easily has allowed the vehicle to see wide application from its' intended air-assault role, to indirect fire, anti-air missions and tank hunting."

	icon = 'icons/obj/vehicles/upptank.dmi'
	icon_state = "tank_turret_0"
	disp_icon = 'icons/obj/vehicles/upptank.dmi'
	disp_icon_state = "tank_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -48
	pixel_y = -48

	ammo = new /obj/item/ammo_magazine/hardpoint/upp_smoke
	max_clips = 5
	use_muzzle_flash = FALSE

	// big beefy chonk of metal
	health = 1500
	damage_multiplier = 0.05

	uses_starshell_ammo = FALSE
	accepted_hardpoints = list(
		/obj/item/hardpoint/iff_module/upp,
		/obj/item/hardpoint/visual_sensors/uscm,
		/obj/item/hardpoint/turret_ring/uscm,
		/obj/item/hardpoint/air_filter/uscm,
		// primaries
		/obj/item/hardpoint/primary/upp_cannon,
		/obj/item/hardpoint/primary/upp_railgun,
		// secondaries
		/obj/item/hardpoint/secondary/t60p3m,
		/obj/item/hardpoint/secondary/hj35launcher/upptank,
		// support
		/obj/item/hardpoint/support/flare_launcher/upptank,
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, 3),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

/obj/item/hardpoint/holder/tank_turret/uppapc
	parent_type = /obj/item/hardpoint/holder/tank_turret/upp
	name = "\improper ZSL-68 Turret"
	desc = "'This is the BM-7/U.E.M Turret for the ZSL-68. The U.E.M, or 'Universal-Equipment-Module' was developed by Ukraine and China, though most of its' practical development took place in Ukraine. It is a remotely controlled and highly modular system capable of servicing a wide range of weapon packages."
	icon = 'icons/obj/vehicles/uppapc.dmi'
	icon_state = "apc_turret_0"
	disp_icon = 'icons/obj/vehicles/uppapc.dmi'
	disp_icon_state = "apc_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -65
	pixel_y = -65

	density = TRUE //come on, it's huge

	activatable = TRUE

	ammo = new /obj/item/ammo_magazine/hardpoint/upp_smoke
	max_clips = 5
	use_muzzle_flash = FALSE

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	allowed_seat = VEHICLE_DRIVER

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 1500
	damage_multiplier = 0.05

	uses_starshell_ammo = FALSE
	accepted_hardpoints = list(
		/obj/item/hardpoint/iff_module/upp,
		/obj/item/hardpoint/visual_sensors/uscm,
		/obj/item/hardpoint/turret_ring/uscm,
		/obj/item/hardpoint/air_filter/uscm,
		// primaries
		/obj/item/hardpoint/primary/gshk_minigun,
		// secondaries
		/obj/item/hardpoint/secondary/hj35launcher,
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, 10),
		"2" = list(0, 10),
		"4" = list(-0, 27),
		"8" = list(-0, 27)
	)

//UPP VAN TURRET
/obj/item/hardpoint/holder/tank_turret/uppvanturret
	parent_type = /obj/item/hardpoint/holder/tank_turret/upp
	name = "\improper Van Turret"
	desc = null
	icon = 'icons/obj/vehicles/uppvan.dmi'
	icon_state = "van_turret_0"
	disp_icon = 'icons/obj/vehicles/uppvan.dmi'
	disp_icon_state = "van_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -65
	pixel_y = -65

	ammo = new /obj/item/ammo_magazine/hardpoint/upp_smoke
	max_clips = 5
	use_muzzle_flash = FALSE

	allowed_seat = VEHICLE_DRIVER

	health = 3000
	damage_multiplier = 0.05

	uses_starshell_ammo = FALSE
	accepted_hardpoints = list(
		/obj/item/hardpoint/iff_module/upp,
		/obj/item/hardpoint/visual_sensors/uscm,
		/obj/item/hardpoint/turret_ring/uscm,
		/obj/item/hardpoint/air_filter/uscm,
		// secondaries
		/obj/item/hardpoint/secondary/t60p3m/van,
	)
	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, 8),
		"2" = list(0, 10),
		"4" = list(-5, 19),
		"8" = list(5, 19)
	)

// All UPP turrets retain the current aiming/repair implementation, but use smoke magazines.
/obj/item/hardpoint/holder/tank_turret/upp
	uses_starshell_ammo = FALSE
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(GUN_FIREMODE_BURSTFIRE)
	burst_amount = 2
	burst_delay = 1 SECONDS
	extra_delay = 5 SECONDS

/obj/item/hardpoint/holder/tank_turret/upp/Initialize()
	. = ..()
	ammo_type = ammo?.type

// Fixed smoke dischargers face forward with the hull, independently of the main gun.
/obj/item/hardpoint/holder/tank_turret/upp/try_fire(atom/target, mob/living/user, params)
	if(!owner || turret_safety_on)
		return NONE
	var/offset_angle = shots_fired ? 25 : -25
	target = get_angle_target_turf(owner, dir2angle(owner.dir) + offset_angle, 5)
	return ..(target, user, params)

/obj/item/hardpoint/holder/tank_turret/upp/in_firing_arc(atom/target)
	return TRUE

// Keep each mounted weapon's rotation center on the same turret spindle after its pixel offset.
/obj/item/hardpoint/holder/tank_turret/upp/add_hardpoint(obj/item/hardpoint/equipment)
	. = ..()
	if(!istype(equipment, /obj/item/hardpoint/primary) && !istype(equipment, /obj/item/hardpoint/secondary) && !istype(equipment, /obj/item/hardpoint/support))
		return
	equipment.rotation_pivot = list()
	for(var/direction in GLOB.cardinals)
		var/list/pivot = rotation_pivot?["[direction]"]
		var/list/offset = equipment.px_offsets?["[direction]"]
		equipment.rotation_pivot["[direction]"] = list((pivot ? pivot[1] : 0) - (offset ? offset[1] : 0), (pivot ? pivot[2] : 0) - (offset ? offset[2] : 0))
