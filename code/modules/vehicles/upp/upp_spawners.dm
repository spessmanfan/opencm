// Ported from cmss13-pve PR #728 (9d18beb769), assembled with experimental components.
/obj/effect/vehicle_spawner/upp
	var/vehicle_type
	var/list/chassis_equipment = list()
	var/list/turret_equipment = list()
	var/destroyed = FALSE

/obj/effect/vehicle_spawner/upp/Initialize()
	. = ..()
	spawn_vehicle()
	return INITIALIZE_HINT_QDEL

/obj/effect/vehicle_spawner/upp/spawn_vehicle()
	if(!vehicle_type)
		return
	var/obj/vehicle/multitile/vehicle = new vehicle_type(loc)
	load_misc(vehicle)
	load_hardpoints(vehicle)
	handle_direction(vehicle)
	if(destroyed)
		load_damage(vehicle)
	vehicle.update_icon()
	return vehicle

/obj/effect/vehicle_spawner/upp/load_hardpoints(obj/vehicle/multitile/vehicle)
	for(var/equipment_type in chassis_equipment)
		vehicle.add_hardpoint(new equipment_type)
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(turret)
		for(var/equipment_type in turret_equipment)
			turret.add_hardpoint(new equipment_type)
		turret.recalculate_turn_rate()

/obj/effect/vehicle_spawner/upptank
	parent_type = /obj/effect/vehicle_spawner/upp
	name = "UPP Cheetah 2A spawner"
	vehicle_type = /obj/vehicle/multitile/tank/upptank
	icon = 'icons/obj/vehicles/upptank.dmi'
	icon_state = "tank_base"
	chassis_equipment = list(/obj/item/hardpoint/holder/tank_turret/uppturret)
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm)

/obj/effect/vehicle_spawner/upptank/plain
	chassis_equipment = list(/obj/item/hardpoint/engine/tank, /obj/item/hardpoint/fuel_tank/uscm, /obj/item/hardpoint/radiator/uscm, /obj/item/hardpoint/battery/uscm, /obj/item/hardpoint/hatch/armored/uscm, /obj/item/hardpoint/locomotion/treads/upp, /obj/item/hardpoint/holder/tank_turret/uppturret)

/obj/effect/vehicle_spawner/upptank/hull
	chassis_equipment = list()
	turret_equipment = list()

/obj/effect/vehicle_spawner/upptank/hull/broken
	destroyed = TRUE

/obj/effect/vehicle_spawner/upptank/fixed
	chassis_equipment = list(/obj/item/hardpoint/engine/tank, /obj/item/hardpoint/fuel_tank/uscm, /obj/item/hardpoint/radiator/uscm, /obj/item/hardpoint/battery/uscm, /obj/item/hardpoint/hatch/armored/uscm, /obj/item/hardpoint/locomotion/treads/upp, /obj/item/hardpoint/holder/tank_turret/uppturret, /obj/item/hardpoint/support/weapons_sensor/upp, /obj/item/hardpoint/armor/reactive)
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm, /obj/item/hardpoint/primary/upp_cannon, /obj/item/hardpoint/secondary/t60p3m, /obj/item/hardpoint/support/flare_launcher/upptank)

/obj/effect/vehicle_spawner/upptank/decrepit
	parent_type = /obj/effect/vehicle_spawner/upptank/fixed
	destroyed = TRUE

/obj/effect/vehicle_spawner/upptank/fixed/non_armor
	chassis_equipment = list(/obj/item/hardpoint/engine/tank, /obj/item/hardpoint/fuel_tank/uscm, /obj/item/hardpoint/radiator/uscm, /obj/item/hardpoint/battery/uscm, /obj/item/hardpoint/hatch/armored/uscm, /obj/item/hardpoint/locomotion/treads/upp, /obj/item/hardpoint/holder/tank_turret/uppturret, /obj/item/hardpoint/support/weapons_sensor/upp)

/obj/effect/vehicle_spawner/upptank/fixed/tow
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm, /obj/item/hardpoint/primary/upp_cannon, /obj/item/hardpoint/secondary/hj35launcher/upptank, /obj/item/hardpoint/support/flare_launcher/upptank)

/obj/effect/vehicle_spawner/upptank/fixed/railgun
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm, /obj/item/hardpoint/primary/upp_railgun, /obj/item/hardpoint/secondary/t60p3m, /obj/item/hardpoint/support/flare_launcher/upptank)

/obj/effect/vehicle_spawner/upptank/fixed/sniper_railgun
	parent_type = /obj/effect/vehicle_spawner/upptank/fixed/railgun
	chassis_equipment = list(/obj/item/hardpoint/engine/tank, /obj/item/hardpoint/fuel_tank/uscm, /obj/item/hardpoint/radiator/uscm, /obj/item/hardpoint/battery/uscm, /obj/item/hardpoint/hatch/armored/uscm, /obj/item/hardpoint/locomotion/treads/upp, /obj/item/hardpoint/holder/tank_turret/uppturret, /obj/item/hardpoint/support/artillery_module/upp, /obj/item/hardpoint/armor/reactive)

/obj/effect/vehicle_spawner/apc/uppapc
	parent_type = /obj/effect/vehicle_spawner/upp
	name = "UPP Pilgrim APC spawner"
	vehicle_type = /obj/vehicle/multitile/apc/uppapc
	icon = 'icons/obj/vehicles/uppapc.dmi'
	icon_state = "uppapc_base"

/obj/effect/vehicle_spawner/uppapc
	parent_type = /obj/effect/vehicle_spawner/apc/uppapc/minigun

/obj/effect/vehicle_spawner/apc/uppapc/plain
	chassis_equipment = list(/obj/item/hardpoint/engine/apc, /obj/item/hardpoint/fuel_tank/uscm, /obj/item/hardpoint/radiator/uscm, /obj/item/hardpoint/battery/uscm, /obj/item/hardpoint/hatch/armored/uscm, /obj/item/hardpoint/locomotion/apc_wheels/zsl_wheels)

/obj/effect/vehicle_spawner/apc/uppapc/minigun
	chassis_equipment = list(/obj/item/hardpoint/engine/apc, /obj/item/hardpoint/fuel_tank/uscm, /obj/item/hardpoint/radiator/uscm, /obj/item/hardpoint/battery/uscm, /obj/item/hardpoint/hatch/armored/uscm, /obj/item/hardpoint/locomotion/apc_wheels/zsl_wheels, /obj/item/hardpoint/holder/tank_turret/uppapc, /obj/item/hardpoint/support/flare_launcher/upp)
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm, /obj/item/hardpoint/primary/gshk_minigun)

/obj/effect/vehicle_spawner/apc/uppapc/minigunhj35
	parent_type = /obj/effect/vehicle_spawner/apc/uppapc/minigun
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm, /obj/item/hardpoint/primary/gshk_minigun, /obj/item/hardpoint/secondary/hj35launcher)

/obj/effect/vehicle_spawner/apc/uppapc/decrepit
	parent_type = /obj/effect/vehicle_spawner/apc/uppapc/minigun
	destroyed = TRUE

/obj/effect/vehicle_spawner/uppvan
	vehicle_type = /obj/vehicle/multitile/uppvan
	name = "UPP Kheshig van spawner"
	parent_type = /obj/effect/vehicle_spawner/upp
	icon = 'icons/obj/vehicles/uppvan.dmi'
	icon_state = "uppvan_base"

/obj/effect/vehicle_spawner/uppvan/fixed
	chassis_equipment = list(/obj/item/hardpoint/engine/van, /obj/item/hardpoint/fuel_tank/van, /obj/item/hardpoint/radiator/civilian, /obj/item/hardpoint/battery/civilian, /obj/item/hardpoint/locomotion/van_wheels/upp)

/obj/effect/vehicle_spawner/uppvan/decrepit
	parent_type = /obj/effect/vehicle_spawner/uppvan/fixed
	destroyed = TRUE

/obj/effect/vehicle_spawner/uppvan/medical
	vehicle_type = /obj/vehicle/multitile/uppvan/medical
	name = "UPP Kheshig van spawner"

/obj/effect/vehicle_spawner/uppvan/medical/fixed
	chassis_equipment = list(/obj/item/hardpoint/engine/van, /obj/item/hardpoint/fuel_tank/van, /obj/item/hardpoint/radiator/civilian, /obj/item/hardpoint/battery/civilian, /obj/item/hardpoint/locomotion/van_wheels/upp)

/obj/effect/vehicle_spawner/uppvan/medical/decrepit
	parent_type = /obj/effect/vehicle_spawner/uppvan/medical/fixed
	destroyed = TRUE

/obj/effect/vehicle_spawner/uppvan/logistics
	vehicle_type = /obj/vehicle/multitile/uppvan/logistics
	name = "UPP Kheshig van spawner"

/obj/effect/vehicle_spawner/uppvan/logistics/fixed
	chassis_equipment = list(/obj/item/hardpoint/engine/van, /obj/item/hardpoint/fuel_tank/van, /obj/item/hardpoint/radiator/civilian, /obj/item/hardpoint/battery/civilian, /obj/item/hardpoint/locomotion/van_wheels/upp)

/obj/effect/vehicle_spawner/uppvan/logistics/decrepit
	parent_type = /obj/effect/vehicle_spawner/uppvan/logistics/fixed
	destroyed = TRUE

/obj/effect/vehicle_spawner/uppvan/prisoner
	vehicle_type = /obj/vehicle/multitile/uppvan/prisoner
	name = "UPP Kheshig van spawner"

/obj/effect/vehicle_spawner/uppvan/prisoner/fixed
	chassis_equipment = list(/obj/item/hardpoint/engine/van, /obj/item/hardpoint/fuel_tank/van, /obj/item/hardpoint/radiator/civilian, /obj/item/hardpoint/battery/civilian, /obj/item/hardpoint/locomotion/van_wheels/upp)

/obj/effect/vehicle_spawner/uppvan/prisoner/decrepit
	parent_type = /obj/effect/vehicle_spawner/uppvan/prisoner/fixed
	destroyed = TRUE

/obj/effect/vehicle_spawner/uppvant
	parent_type = /obj/effect/vehicle_spawner/uppvan
	vehicle_type = /obj/vehicle/multitile/uppvan/uppvant
	icon_state = "uppvant_base"

/obj/effect/vehicle_spawner/uppvant/fixed
	chassis_equipment = list(/obj/item/hardpoint/engine/van, /obj/item/hardpoint/fuel_tank/van, /obj/item/hardpoint/radiator/civilian, /obj/item/hardpoint/battery/civilian, /obj/item/hardpoint/locomotion/van_wheels/upp, /obj/item/hardpoint/holder/tank_turret/uppvanturret)
	turret_equipment = list(/obj/item/hardpoint/iff_module/upp, /obj/item/hardpoint/visual_sensors/uscm, /obj/item/hardpoint/turret_ring/uscm, /obj/item/hardpoint/air_filter/uscm, /obj/item/hardpoint/secondary/t60p3m/van)

/obj/effect/vehicle_spawner/uppvant/decrepit
	parent_type = /obj/effect/vehicle_spawner/uppvant/fixed
	destroyed = TRUE
