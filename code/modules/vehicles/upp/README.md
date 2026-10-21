# UPP vehicles

Port of cmss13-devs/cmss13-pve PR #728, by dimdimich1996, merged as
9d18beb76938e33b83bcaf4074ae9d42c00bc321. Adapted to experimental's vehicle overhaul.

The tank, APC and vans use the current gearbox, engine, fuel, radiator and battery
systems. Armed variants mount a current turret ring, visual sensors, air filter and
UPP-configured IFF module. Their turrets use mouse aiming, stabilization and safety.
The unarmed vans inherit the existing van controls and repair behavior.

The P-177-02 uses the Longstreet LTB's three-second tracking lock-on, accepting living
mobs and vehicles. Vehicle-locked cannon rounds use 1000 direct damage / 150 AP against
vehicles; TOW and HJ-35 rounds use 1200 / 200 AP on vehicle impact. These bonuses do
not increase infantry damage or explosions. Vehicle mitigation still applies. The
railgun retains free aim. Turrets fire smoke magazines; dedicated flare launchers use experimental's individually loaded starshells.
Shared icon sheets were preserved; imported sheets have UPP-specific paths.

Apart from the anti-vehicle bonuses above, original damage, magazine capacities and
UPP equipment health are retained. In particular, the railgun still has 2500 base damage and special vehicle-impact effects.
This is a compatibility port, not a PvP balance pass. No round-start vendor, requisition
or map placements are added. Use the spawners below for admin events or mapping.

## Ready-to-drive spawners

- `/obj/effect/vehicle_spawner/upptank/fixed`
- `/obj/effect/vehicle_spawner/upptank/fixed/tow`
- `/obj/effect/vehicle_spawner/upptank/fixed/railgun`
- `/obj/effect/vehicle_spawner/upptank/fixed/sniper_railgun`
- `/obj/effect/vehicle_spawner/apc/uppapc/minigun`
- `/obj/effect/vehicle_spawner/apc/uppapc/minigunhj35`
- `/obj/effect/vehicle_spawner/uppvan/fixed`
- `/obj/effect/vehicle_spawner/uppvant/fixed`
- `/obj/effect/vehicle_spawner/uppvan/medical/fixed`
- `/obj/effect/vehicle_spawner/uppvan/logistics/fixed`
- `/obj/effect/vehicle_spawner/uppvan/prisoner/fixed`

Bare and decrepit variants are also available. Engines start off, as with the current
vehicles. Start the engine and select a driving gear. IFF modules default to UPP but
must be switched on through the normal vehicle controls.

The APC's PvE dropship console is an inert disconnected screen because experimental
has no corresponding UPP dropship. Interiors use this branch's phone landmarks and
furniture. Test coverage lives in `code/modules/unit_tests/upp_vehicles.dm` and checks
13 usable presets, including interior loading, component slots and turret ring failure.

Visual rotation alignment and gameplay balance should also be checked in a player
client before deploying these vehicles to a live round.
