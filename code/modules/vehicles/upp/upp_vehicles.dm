/obj/vehicle/multitile/tank/upptank
	vehicle_faction = FACTION_UPP
	req_one_access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_LEADERSHIP)
	name = "Cheetah 2A Light Tank"
	desc = "The Cheetah 2A is an assault tank designed to be rapidly deployed from light dropcraft in daring raids and first strike operations. The Cheetah 2A is relatively new in comparison to most UPP vehicles seen on the Frontier, but has already earned a fair reputation as a reliable workhorse, that is able to bring some cutting edge technology to the fight. While the project was based in Germany, the Cheetah 2A has a truly progressive development history, seeing influences from nearly all UPP member states."

	icon = 'icons/obj/vehicles/upptank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = /datum/map_template/interior/upptank

	passengers_slots = 4
	//this is done in case VCs die inside the tank, so that someone else can come in and take them out.
	revivable_dead_slots = 2
	xenos_slots = 4

	entrances = list(
		"back" = list(0, 2)
	)

	movement_sound = null
	honk_sound = 'sound/vehicles/honk_3_ambulence.ogg'

	required_skill = SKILL_VEHICLE_LARGE

	vehicle_flags = VEHICLE_CLASS_MEDIUM

	move_max_momentum = 2
	top_speed = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.6

	vehicle_light_range = 4

	// Rest (all the guns) is handled by the tank turret hardpoint
	hardpoints_allowed = list(
		/obj/item/hardpoint/engine/tank,
		/obj/item/hardpoint/fuel_tank/uscm,
		/obj/item/hardpoint/radiator/uscm,
		/obj/item/hardpoint/battery/uscm,
		/obj/item/hardpoint/hatch/armored/uscm,

		/obj/item/hardpoint/holder/tank_turret/uppturret,
		/obj/item/hardpoint/support/weapons_sensor/upp,
		/obj/item/hardpoint/support/overdrive_enhancer,
		/obj/item/hardpoint/support/artillery_module/upp,
		/obj/item/hardpoint/armor/reactive,
		/obj/item/hardpoint/locomotion/treads/upp,
		/obj/item/hardpoint/locomotion/treads/robust,
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 0.5,
		"slash" = 1.6,
		"bullet" = 0.4,
		"explosive" = 0.8,
		"blunt" = 0.8,
		"abstract" = 1
	)

	explosive_resistance = 500

/obj/vehicle/multitile/tank/upptank/setup_overwatch_camera()
	return

/obj/vehicle/multitile/apc/uppapc
	vehicle_faction = FACTION_UPP
	req_one_access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_LEADERSHIP)
	name = "ZSL-68 'Pilgrim'"
	desc = "The ZSL-68 'Pilgrim APC designed in a joint project Ukraine and China, as part of the 'New Arms Cooperative' initiative of 2165. Despite its' rough appearance and age, it is still respected by the many branches it serves. Entrances on the rear and sides"

	icon = 'icons/obj/vehicles/uppapc.dmi'
	icon_state = "uppapc_base"
	pixel_x = -65
	pixel_y = -65

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = /datum/map_template/interior/uppapc

	passengers_slots = 20
	revivable_dead_slots = 3
	xenos_slots = 8

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0),
		"rear center" = list(0, 2),

	)

	entrance_speed = 0.5 SECONDS

	required_skill = SKILL_VEHICLE_LARGE

	movement_sound = null

	vehicle_light_range = 7

	hardpoints_allowed = list(
		/obj/item/hardpoint/engine/apc,
		/obj/item/hardpoint/fuel_tank/uscm,
		/obj/item/hardpoint/radiator/uscm,
		/obj/item/hardpoint/battery/uscm,
		/obj/item/hardpoint/hatch/armored/uscm,

		/obj/item/hardpoint/holder/tank_turret/uppapc,
		/obj/item/hardpoint/locomotion/apc_wheels/zsl_wheels,
		/obj/item/hardpoint/support/flare_launcher/upp,
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	vehicle_flags = VEHICLE_CLASS_LIGHT

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.6,
		"slash" = 1.8,
		"bullet" = 0.6,
		"explosive" = 0.7,
		"blunt" = 0.7,
		"abstract" = 1
	)

	explosive_resistance = 150

	move_max_momentum = 2
	top_speed = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

/obj/vehicle/multitile/uppvan
	vehicle_faction = FACTION_UPP
	req_one_access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_LEADERSHIP)
	parent_type = /obj/vehicle/multitile/van
	name = "Kheshig-1M"
	desc = "The Kheshig-1M is a result of a modernization program to try and make a common heavy utility vehicle for the Union. Lightly armored and relatively compact, most variants are unarmed."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/uppvan.dmi'
	icon_state = "uppvan_base"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = /datum/map_template/interior/uppvan

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0),
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)

	vehicle_flags = VEHICLE_CLASS_WEAK

	passengers_slots = 14
	xenos_slots = 2

	misc_multipliers = list(
		"move" = 0.5,
		"accuracy" = 1,
		"cooldown" = 1
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	vehicle_light_range = 6

	move_max_momentum = 3

	hardpoints_allowed = list(
		/obj/item/hardpoint/engine/van,
		/obj/item/hardpoint/fuel_tank/van,
		/obj/item/hardpoint/radiator/civilian,
		/obj/item/hardpoint/battery/civilian,

		/obj/item/hardpoint/locomotion/van_wheels/upp,
	)

	move_turn_momentum_loss_factor = 1

	req_access = list()

	door_locked = FALSE

	move_on_turn = TRUE

/obj/vehicle/multitile/uppvan/uppvant
	name = "Kheshig-1M-T"
	desc = "The Kheshig-1M is a result of a modernization program to try and make a common heavy utility vehicle for the Union. Lightly armored and relatively compact, most variants are unarmed, though the mounting dock for a machine gun turret is on almost every model."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/uppvan.dmi'
	icon_state = "uppvant_base"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = /datum/map_template/interior/uppvant

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0),
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)

	hardpoints_allowed = list(
		/obj/item/hardpoint/engine/van,
		/obj/item/hardpoint/fuel_tank/van,
		/obj/item/hardpoint/radiator/civilian,
		/obj/item/hardpoint/battery/civilian,

		/obj/item/hardpoint/locomotion/van_wheels/upp,
		/obj/item/hardpoint/holder/tank_turret/uppvanturret,
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

/obj/vehicle/multitile/uppvan/medical
	name = "Kheshig-1M-Medical"
	desc = "The Kheshig-1M is a result of a modernization program to try and make a common heavy utility vehicle for the Union. Lightly armored and relatively compact, most variants are unarmed, The cross on the top marks this vehicle as a medical evacuation vehicle."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/uppvan.dmi'
	icon_state = "uppvan_medical"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = /datum/map_template/interior/uppvan/medical

/obj/vehicle/multitile/uppvan/logistics
	name = "Kheshig-1M-logistics"
	desc = "The Kheshig-1M is a result of a modernization program to try and make a common heavy utility vehicle for the Union. Lightly armored and relatively compact, most variants are unarmed, The orange stripe across the side marks this vehicle as a logistics transport."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/uppvan_logistics.dmi'
	icon_state = "uppvan_base"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = /datum/map_template/interior/uppvan/logistics

/obj/vehicle/multitile/uppvan/prisoner
	name = "Kheshig-1M-Prisoner"
	desc = "The Kheshig-1M is a result of a modernization program to try and make a common heavy utility vehicle for the Union. Lightly armored and relatively compact, most variants are unarmed, The red stripe across the side marks this vehicle as a prisoner transport."
	layer = ABOVE_XENO_LAYER

	icon = 'icons/obj/vehicles/uppvan.dmi'
	icon_state = "uppvan_prisoner"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = /datum/map_template/interior/uppvan/prisoner

/obj/vehicle/multitile/uppvan/uppvant/supports_visual_sensors()
	return TRUE

/obj/vehicle/multitile/uppvan/uppvant/add_seated_verbs(mob/living/user, seat)
	. = ..()
	if(!user.client)
		return
	if(seat == VEHICLE_DRIVER)
		add_verb(user.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
		))
		return
	if(seat != VEHICLE_GUNNER)
		return
	add_verb(user.client, list(
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/cycle_hardpoint,
		/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
		/obj/vehicle/multitile/proc/toggle_iff_module,
		/obj/vehicle/multitile/proc/toggle_turret_safety,
		/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver,
	))
	give_action(user, /datum/action/human_action/vehicle_action/toggle_iff)
	give_action(user, /datum/action/human_action/vehicle_action/toggle_gyro)
	give_action(user, /datum/action/human_action/vehicle_action/slave_secondary)
	get_gyro_hardpoint()?.recalculate_gyro(TRUE)
	start_crew_hud(user, VEHICLE_GUNNER)
	ensure_active_hardpoint(seat)

/obj/vehicle/multitile/uppvan/uppvant/remove_seated_verbs(mob/living/user, seat)
	. = ..()
	if(!user.client)
		return
	if(seat == VEHICLE_DRIVER)
		remove_verb(user.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
		))
		return
	if(seat != VEHICLE_GUNNER)
		return
	remove_verb(user.client, list(
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/cycle_hardpoint,
		/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
		/obj/vehicle/multitile/proc/toggle_iff_module,
		/obj/vehicle/multitile/proc/toggle_turret_safety,
		/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver,
	))
	remove_action(user, /datum/action/human_action/vehicle_action/toggle_iff)
	remove_action(user, /datum/action/human_action/vehicle_action/toggle_gyro)
	remove_action(user, /datum/action/human_action/vehicle_action/slave_secondary)
	get_gyro_hardpoint()?.recalculate_gyro(FALSE)
	stop_crew_hud(user, VEHICLE_GUNNER)

/obj/vehicle/multitile/tank/upptank/initialize_cameras(change_tag = FALSE)
	..()
	camera.c_tag = "Cheetah 2A [nickname]"
	if(camera_int)
		camera_int.c_tag = "[camera.c_tag] interior"

/obj/vehicle/multitile/apc/uppapc/initialize_cameras(change_tag = FALSE)
	..()
	camera.c_tag = "ZSL-68 Pilgrim [nickname]"
	if(camera_int)
		camera_int.c_tag = "[camera.c_tag] interior"
