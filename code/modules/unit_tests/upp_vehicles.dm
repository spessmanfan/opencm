// Integration coverage for the UPP port: real presets, interiors and rotating components.
/datum/unit_test/upp_vehicles/Run()
	var/list/presets = list(
		/obj/effect/vehicle_spawner/upptank/plain,
		/obj/effect/vehicle_spawner/upptank/fixed,
		/obj/effect/vehicle_spawner/upptank/fixed/non_armor,
		/obj/effect/vehicle_spawner/upptank/fixed/tow,
		/obj/effect/vehicle_spawner/upptank/fixed/railgun,
		/obj/effect/vehicle_spawner/upptank/fixed/sniper_railgun,
		/obj/effect/vehicle_spawner/apc/uppapc/minigun,
		/obj/effect/vehicle_spawner/apc/uppapc/minigunhj35,
		/obj/effect/vehicle_spawner/uppvan/fixed,
		/obj/effect/vehicle_spawner/uppvant/fixed,
		/obj/effect/vehicle_spawner/uppvan/medical/fixed,
		/obj/effect/vehicle_spawner/uppvan/logistics/fixed,
		/obj/effect/vehicle_spawner/uppvan/prisoner/fixed,
	)
	for(var/preset in presets)
		check_preset(preset)
	check_vehicle_combat()

/datum/unit_test/upp_vehicles/proc/check_preset(preset)
	var/list/before = GLOB.all_multi_vehicles.Copy()
	allocate(preset)
	var/list/spawned = GLOB.all_multi_vehicles - before
	TEST_ASSERT_EQUAL(length(spawned), 1, "[preset] must spawn exactly one vehicle")
	var/obj/vehicle/multitile/vehicle = spawned[1]
	allocated += vehicle
	TEST_ASSERT(vehicle.uses_gear_transmission, "[preset] must use the current gearbox")
	TEST_ASSERT_EQUAL(vehicle.vehicle_faction, FACTION_UPP, "[preset] must start with UPP IFF")
	var/load_deadline = world.time + 30 SECONDS
	while(!QDELETED(vehicle) && !vehicle.interior?.ready && world.time < load_deadline)
		sleep(1)
	TEST_ASSERT(!QDELETED(vehicle), "[preset] must survive interior loading")
	TEST_ASSERT_NOTNULL(vehicle.interior, "[preset] must load an interior")
	TEST_ASSERT(vehicle.interior.ready, "[preset] interior must finish loading")
	var/list/interior_bounds = vehicle.interior.get_bound_turfs()
	var/seat_count = 0
	for(var/turf/interior_turf in block(interior_bounds[1], interior_bounds[2]))
		for(var/obj/structure/bed/chair/comfy/vehicle/seat in interior_turf)
			seat_count++
			TEST_ASSERT(!interior_turf.density, "[preset] seat must have a walkable floor")
			for(var/obj/blocker in interior_turf)
				TEST_ASSERT(!blocker.density, "[preset] seat is blocked by [blocker.type]")
	TEST_ASSERT(seat_count >= length(vehicle.seats), "[preset] must have all crew seats in its interior")
	for(var/slot in list(HDPT_ENGINE, HDPT_FUEL_TANK, HDPT_RADIATOR, HDPT_BATTERY))
		TEST_ASSERT_NOTNULL(vehicle.get_hardpoint_by_slot(slot), "[preset] missing [slot]")
	var/list/slots = list()
	for(var/obj/item/hardpoint/equipment in vehicle.hardpoints)
		TEST_ASSERT(equipment.type in vehicle.hardpoints_allowed, "[preset] has unsupported [equipment.type]")
		TEST_ASSERT(!(equipment.slot in slots), "[preset] duplicates chassis slot [equipment.slot]")
		slots += equipment.slot
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in vehicle.hardpoints
	if(turret)
		var/list/turret_slots = list()
		for(var/obj/item/hardpoint/equipment in turret.hardpoints)
			TEST_ASSERT(equipment.type in turret.accepted_hardpoints, "[preset] turret rejects [equipment.type]")
			TEST_ASSERT(!(equipment.slot in turret_slots), "[preset] duplicates turret slot [equipment.slot]")
			turret_slots += equipment.slot
			if(equipment.ammo)
				TEST_ASSERT(equipment.ammo_type || equipment.uses_starshell_ammo, "[equipment.type] must accept its magazine or use starshells")
		TEST_ASSERT_NOTNULL(vehicle.get_hardpoint_by_slot(HDPT_TURRET_RING), "[preset] needs a turret ring")
		var/obj/item/hardpoint/turret_ring/ring = vehicle.get_hardpoint_by_slot(HDPT_TURRET_RING)
		turret.recalculate_turn_rate()
		TEST_ASSERT(turret.max_angular_velocity > 0, "[preset] must be able to turn")
		TEST_ASSERT(turret.ammo_type, "[preset] must accept smoke reloads")
		for(var/angle in list(0, 45, 90, 135, 180, 225, 270, 315))
			turret.current_angle = angle
			turret.apply_current_angle()
			TEST_ASSERT(length(turret.get_hardpoint_image()), "[preset] must render at [angle] degrees")
			for(var/obj/item/hardpoint/weapon in turret.hardpoints)
				if(!weapon.use_muzzle_flash || !weapon.muzzle_flash_anchors)
					continue
				var/image/flash = weapon.get_mounted_muzzle_flash()
				TEST_ASSERT_NOTNULL(flash, "[weapon.type] needs a flash at [angle] degrees")
				var/matrix/flash_transform = flash.transform
				// The flash's north-pointing axis must follow the rendered barrel.
				TEST_ASSERT(abs(flash_transform.b - sin(angle)) < 0.001, "[weapon.type] flash must face its barrel at [angle] degrees")
				TEST_ASSERT(abs(flash_transform.e - cos(angle)) < 0.001, "[weapon.type] flash must face its barrel at [angle] degrees")

		var/healthy_turn_rate = turret.max_angular_velocity
		ring.health = 0
		turret.recalculate_turn_rate()
		TEST_ASSERT_EQUAL(turret.max_angular_velocity, 0, "[preset] must stop turning with a destroyed ring")
		ring.health = initial(ring.health)
		turret.recalculate_turn_rate()
		TEST_ASSERT_EQUAL(turret.max_angular_velocity, healthy_turn_rate, "[preset] must recover turning after ring repair")
		var/obj/item/hardpoint/iff_module/iff = vehicle.get_hardpoint_by_slot(HDPT_IFF_MODULE)
		TEST_ASSERT_EQUAL(iff.set_faction, FACTION_UPP, "[preset] IFF must recognize UPP")
	qdel(vehicle)

#ifdef UPP_VEHICLE_TESTS
TEST_FOCUS(/datum/unit_test/upp_vehicles)
#endif

// Observe the shared vehicle impact pipeline without armor randomness or hull destruction.
/obj/vehicle/multitile/upp_test_target
	bound_width = 64
	bound_height = 64
	var/last_bullet_damage = 0

/obj/vehicle/multitile/upp_test_target/take_damage_type(damage, type, atom/attacker, unmitigated = FALSE)
	if(type == "bullet")
		last_bullet_damage = damage

/datum/unit_test/upp_vehicles/proc/check_vehicle_combat()
	var/turf/firing_turf = locate(run_loc_floor_bottom_left.x + 1, run_loc_floor_bottom_left.y + 1, run_loc_floor_bottom_left.z)
	var/turf/target_turf = locate(firing_turf.x + 2, firing_turf.y, firing_turf.z)
	var/obj/vehicle/multitile/upp_test_target/target = allocate(/obj/vehicle/multitile/upp_test_target, target_turf)
	var/mob/living/carbon/human/person = allocate(/mob/living/carbon/human, target_turf)
	for(var/cannon_type in list(/obj/item/hardpoint/primary/cannon, /obj/item/hardpoint/primary/upp_cannon))
		var/obj/item/hardpoint/primary/cannon/cannon = allocate(cannon_type, firing_turf)
		TEST_ASSERT(cannon.is_valid_lock_target(target), "[cannon_type] must accept vehicles")
		TEST_ASSERT(cannon.is_valid_lock_target(person), "[cannon_type] must still accept living targets")
		target.health = 0
		TEST_ASSERT(!cannon.is_valid_lock_target(target), "[cannon_type] must reject wrecks")
		target.health = initial(target.health)
		cannon.owner = target
		TEST_ASSERT(!cannon.is_valid_lock_target(target), "[cannon_type] cannot lock its own vehicle")
		cannon.owner = null
		TEST_ASSERT(!cannon.check_shot_is_blocked(target), "An unobstructed vehicle must be lockable")
		var/obj/structure/blocker = allocate(/obj/structure, locate(firing_turf.x + 1, firing_turf.y, firing_turf.z))
		blocker.density = TRUE
		blocker.opacity = TRUE
		TEST_ASSERT(cannon.check_shot_is_blocked(target), "Lock-on must still respect cover")
		qdel(blocker)
		cannon.current_angle = 90
		cannon.trigger_held = TRUE
		TEST_ASSERT(cannon.track_and_charge(target, null, 1), "Vehicle lock tracking and visuals must complete")
		TEST_ASSERT(!cannon.lockon_icon && !cannon.laser_beam, "Lock visuals must clean up")
		cannon.homing_target = target
		var/obj/projectile/shell = cannon.generate_bullet(null, firing_turf)
		allocated += shell
		shell.damage = shell.ammo.damage // Remove random projectile variance from balance assertions.
		TEST_ASSERT_NOTNULL(shell.GetComponent(/datum/component/homing_projectile), "Vehicle-locked shells must home")
		target.bullet_act(shell)
		TEST_ASSERT(abs(target.last_bullet_damage - 1830) < 0.01, "Vehicle-locked shells must apply 1000 damage with 150 AP before armor")
		TEST_ASSERT_EQUAL(shell.damage, initial(shell.ammo.damage), "Vehicle lock must not increase damage to infantry")
		cannon.homing_target = person
		var/obj/projectile/normal_shell = cannon.generate_bullet(null, firing_turf)
		allocated += normal_shell
		TEST_ASSERT_EQUAL(normal_shell.ammo.vehicle_damage_multiplier, 1, "A later infantry lock must not retain the vehicle bonus")
		qdel(shell)
		qdel(normal_shell)
	for(var/ammo_type in list(/datum/ammo/rocket/ap/tank_towlauncher, /datum/ammo/rocket/ap/hj35_launcher))
		var/obj/projectile/missile = allocate(/obj/projectile, firing_turf, create_cause_data("vehicle combat test"))
		missile.generate_bullet(new ammo_type)
		missile.damage = missile.ammo.damage
		target.bullet_act(missile)
		TEST_ASSERT(abs(target.last_bullet_damage - 2796) < 0.01, "[ammo_type] must apply 1200 damage with 200 AP before armor")
		TEST_ASSERT_EQUAL(missile.damage, 10, "[ammo_type] must retain normal infantry impact damage")
		// Hit a footprint tile that does not contain the chassis atom, including turf-targeted rockets.
		var/turf/edge = locate(target.x + 1, target.y, target.z)
		TEST_ASSERT(edge in target.locs, "Test must use a vehicle footprint tile")
		target.last_bullet_damage = 0
		missile.speed = 1
		missile.target_turf = edge
		TEST_ASSERT(missile.scan_a_turf(edge, EAST), "Anti-vehicle missile must impact the chassis edge")
		TEST_ASSERT(abs(target.last_bullet_damage - 2796) < 0.01, "Footprint impact must apply boosted direct damage")
		qdel(missile)
