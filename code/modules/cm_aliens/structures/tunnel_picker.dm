/*
 * Tunnel picker UI
 *
 * Lets a xeno pick which tunnel to travel to from a list, with a live tacmap
 * preview centered on whichever tunnel is currently highlighted.
 */

#define TUNNEL_PICKER_PREVIEW_RADIUS 39
#define TUNNEL_PICKER_PREVIEW_ZOOM 3

/datum/tunnel_picker
	var/mob/living/carbon/xenomorph/xeno
	var/obj/structure/tunnel/source_tunnel
	var/list/obj/structure/tunnel/available_tunnels
	var/obj/structure/tunnel/selected_tunnel
	/// Cached preview asset urls by tunnel ref, so flipping back and forth doesn't regenerate the icon
	var/list/preview_cache = list()
	/// Prevents double-confirming while a move is already resolving
	var/moving = FALSE

/datum/tunnel_picker/New(mob/living/carbon/xenomorph/X, obj/structure/tunnel/source, list/tunnels)
	. = ..()
	xeno = X
	source_tunnel = source
	available_tunnels = tunnels
	if(length(available_tunnels))
		selected_tunnel = available_tunnels[1]
	RegisterSignal(xeno, COMSIG_PARENT_QDELETING, PROC_REF(on_gone))
	RegisterSignal(source_tunnel, COMSIG_PARENT_QDELETING, PROC_REF(on_gone))

/datum/tunnel_picker/Destroy()
	SStgui.close_uis(src)
	xeno = null
	source_tunnel = null
	available_tunnels = null
	selected_tunnel = null
	return ..()

/datum/tunnel_picker/proc/on_gone()
	SIGNAL_HANDLER
	qdel(src)

/datum/tunnel_picker/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TunnelPicker", "Tunnel")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tunnel_picker/ui_state(mob/user)
	return GLOB.conscious_state

/datum/tunnel_picker/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(. == UI_CLOSE)
		return .
	if(user != xeno || QDELETED(xeno) || QDELETED(source_tunnel) || !(xeno in source_tunnel.contents))
		return UI_CLOSE
	return .

/datum/tunnel_picker/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tunnel_picker/ui_data(mob/user)
	var/list/data = list()

	var/list/tunnel_data = list()
	for(var/obj/structure/tunnel/T as anything in available_tunnels)
		if(QDELETED(T))
			continue
		tunnel_data += list(list(
			"ref" = REF(T),
			"desc" = T.tunnel_desc,
			"dist" = round(get_dist(T, source_tunnel)),
		))
	data["tunnels"] = tunnel_data
	data["selected_ref"] = (selected_tunnel && !QDELETED(selected_tunnel)) ? REF(selected_tunnel) : null
	data["preview"] = get_preview(selected_tunnel)
	return data

/datum/tunnel_picker/proc/get_preview(obj/structure/tunnel/T)
	if(QDELETED(T) || QDELETED(xeno) || !xeno.hive || !xeno.client)
		return null

	var/turf/map_turf = get_turf(T)
	if(!map_turf)
		return null

	var/ref = REF(T)
	var/url = preview_cache[ref]
	if(!url)
		url = SSminimaps.get_map_slice_url(map_turf.z, xeno.hive.minimap_type, map_turf.x, map_turf.y, xeno.client, TUNNEL_PICKER_PREVIEW_RADIUS, TUNNEL_PICKER_PREVIEW_ZOOM, /obj/structure/tunnel)
		if(url)
			preview_cache[ref] = url

	var/area/map_area = get_area(T)
	return list(
		"url" = url,
		"area" = map_area ? map_area.name : "Unknown",
	)

/datum/tunnel_picker/proc/get_tunnel_by_ref(ref)
	if(!ref)
		return null
	for(var/obj/structure/tunnel/T as anything in available_tunnels)
		if(REF(T) == ref)
			return T
	return null

/datum/tunnel_picker/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("select")
			var/obj/structure/tunnel/T = get_tunnel_by_ref(params["ref"])
			if(!T || QDELETED(T))
				return
			selected_tunnel = T
			. = TRUE

		if("confirm")
			if(moving)
				return
			var/obj/structure/tunnel/T = get_tunnel_by_ref(params["ref"]) || selected_tunnel
			if(!T || QDELETED(T))
				return
			// Grab local refs before closing the UI, since that qdel()s src and nulls its vars
			var/mob/living/carbon/xenomorph/X = xeno
			var/obj/structure/tunnel/source = source_tunnel
			if(QDELETED(X) || !source || !(X in source.contents))
				return

			moving = TRUE
			SStgui.close_uis(src) // triggers ui_close() -> qdel(src)
			source.attempt_enter_tunnel(X, T)
			. = TRUE

		if("cancel")
			SStgui.close_uis(src) // triggers ui_close() -> qdel(src)
			. = TRUE
