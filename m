Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37073 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966867AbdLSJAc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:00:32 -0500
Received: by mail-wm0-f50.google.com with SMTP id f140so2054056wmd.2
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 01:00:31 -0800 (PST)
Subject: Re: [PATCH/RFC 1/4] drm: Add colorkey properties
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        linux-media@vger.kernel.org
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <774a29ec-fd51-7bc5-bcbb-ce0d49a76aa8@baylibre.com>
Date: Tue, 19 Dec 2017 10:00:28 +0100
MIME-Version: 1.0
In-Reply-To: <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 17/12/2017 01:17, Laurent Pinchart wrote:
> Color keying is the action of replacing pixels matching a given color
> (or range of colors) with transparent pixels in an overlay when
> performing blitting. Depending on the hardware capabilities, the
> matching pixel can either become fully transparent, or gain a
> programmable alpha value.
> 
> Color keying is found in a large number of devices whose capabilities
> often differ, but they still have enough common features in range to
> standardize color key properties. This commit adds four properties
> related to color keying named colorkey.min, colorkey.max, colorkey.alpha
> and colorkey.mode. Additional properties can be defined by drivers to
> expose device-specific features.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/drm_atomic.c |  16 +++++++
>  drivers/gpu/drm/drm_blend.c  | 108 +++++++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_blend.h      |   4 ++
>  include/drm/drm_plane.h      |  28 ++++++++++-
>  4 files changed, 155 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> index 37445d50816a..4f57ec25e04d 100644
> --- a/drivers/gpu/drm/drm_atomic.c
> +++ b/drivers/gpu/drm/drm_atomic.c
> @@ -756,6 +756,14 @@ static int drm_atomic_plane_set_property(struct drm_plane *plane,
>  		state->rotation = val;
>  	} else if (property == plane->zpos_property) {
>  		state->zpos = val;
> +	} else if (property == plane->colorkey.mode_property) {
> +		state->colorkey.mode = val;
> +	} else if (property == plane->colorkey.min_property) {
> +		state->colorkey.min = val;
> +	} else if (property == plane->colorkey.max_property) {
> +		state->colorkey.max = val;
> +	} else if (property == plane->colorkey.value_property) {
> +		state->colorkey.value = val;
>  	} else if (plane->funcs->atomic_set_property) {
>  		return plane->funcs->atomic_set_property(plane, state,
>  				property, val);
> @@ -815,6 +823,14 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
>  		*val = state->rotation;
>  	} else if (property == plane->zpos_property) {
>  		*val = state->zpos;
> +	} else if (property == plane->colorkey.mode_property) {
> +		*val = state->colorkey.mode;
> +	} else if (property == plane->colorkey.min_property) {
> +		*val = state->colorkey.min;
> +	} else if (property == plane->colorkey.max_property) {
> +		*val = state->colorkey.max;
> +	} else if (property == plane->colorkey.value_property) {
> +		*val = state->colorkey.value;
>  	} else if (plane->funcs->atomic_get_property) {
>  		return plane->funcs->atomic_get_property(plane, state, property, val);
>  	} else {
> diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
> index 2e5e089dd912..79da7d8a22e2 100644
> --- a/drivers/gpu/drm/drm_blend.c
> +++ b/drivers/gpu/drm/drm_blend.c
> @@ -98,6 +98,10 @@
>   *   planes. Without this property the primary plane is always below the cursor
>   *   plane, and ordering between all other planes is undefined.
>   *
> + * - Color keying is set up with drm_plane_create_colorkey_properties(). It adds
> + *   support for replacing a range of colors with a transparent color in the
> + *   plane.
> + *
>   * Note that all the property extensions described here apply either to the
>   * plane or the CRTC (e.g. for the background color, which currently is not
>   * exposed and assumed to be black).
> @@ -405,3 +409,107 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
>  	return 0;
>  }
>  EXPORT_SYMBOL(drm_atomic_normalize_zpos);
> +
> +/**
> + * drm_plane_create_colorkey_properties - create colorkey properties
> + * @plane: drm plane
> + * @modes: array of supported color keying modes
> + * @num_modes: number of modes in the modes array
> + * @replace: if true create the colorkey.replacement property
> + *
> + * This function creates the generic color keying properties and attach them to
> + * the plane to enable color keying control for blending operations.
> + *
> + * Color keying is controlled through four properties:
> + *
> + * colorkey.mode:
> + *	The mode is an enumerated property that controls how color keying
> + *	operates. Modes are driver-specific, except for a "disabled" mode that
> + *	disables color keying and is guaranteed to exist if color keying is
> + *	supported.
> + *
> + * colorkey.min, colorkey.max:
> + *	Those two properties specify the colors that are replaced by transparent
> + *	pixels. Pixel whose values are in the [min, max] range are replaced, all
> + *	other pixels are left untouched. The minimum and maximum values are
> + *	expressed as a 64-bit integer in AXYZ16161616 format, where A is the
> + *	alpha value and X, Y and Z correspond to the color components of the
> + *	plane's pixel format. In most cases XYZ will be either RGB or YUV.
> + *
> + *	When a single color key is supported instead of a range, userspace shall
> + *	set the min and max properties to the same value, and drivers return an
> + *	error from their plane atomic check when the min and max values differ.
> + *
> + *	Note that depending on the selected mode, not all components might be
> + *	used for comparison. For instance a device could support color keying in
> + *	YUV format using luma (Y) matching only, ignoring the chroma components.
> + *	This behaviour is driver-specific.
> + *
> + * colorkey.value:
> + *	This property specifies the color value that replaces pixels matching
> + *	the [min, max] range. The value is expressed in AXYZ16161616 format as
> + *	the min and max properties.
> + *
> + *	This property is optional and only present when the device supports
> + *	configurable color replacement for matching pixels in the plane. If
> + *	color keying capabilities of the device are limited to making the
> + *	matching pixels fully transparent the colorkey.value property won't be
> + *	created.
> + *
> + *	Note that depending on the device, or the selected mode, not all
> + *	components might be used for value replacement. For instance a device
> + *	could support replacing the alpha value of the matching pixels but not
> + *	its color components. This behaviour is driver-specific.
> + *
> + * The @modes parameter points to an array of all color keying modes supported
> + * by the plane. The first mode has to be named "disabled" and have value 0. All
> + * other modes are driver-specific, and at least one mode has to be provided in
> + * addition to the "disabled" mode.
> + *
> + * Returns:
> + * Zero on success, negative errno on failure.
> + */
> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> +					 const struct drm_prop_enum_list *modes,
> +					 unsigned int num_modes, bool replace)
> +{
> +#define CREATE_COLORKEY_PROP(plane, name, type, args...) ({		       \
> +	prop = drm_property_create_##type(plane->dev, 0, "colorkey." #name,    \
> +					  args);			       \
> +	if (prop) {							       \
> +		drm_object_attach_property(&plane->base, prop, 0);	       \
> +		plane->colorkey.name##_property = prop;			       \
> +	}								       \
> +	prop;								       \
> +})
> +
> +	struct drm_property *prop;
> +
> +	/*
> +	 * A minimum of two modes are required, with the first mode must named
> +	 * "disabled".
> +	 */
> +	if (!modes || num_modes == 0 || strcmp(modes[0].name, "disabled"))
> +		return -EINVAL;
> +
> +	prop = CREATE_COLORKEY_PROP(plane, mode, enum, modes, num_modes);
> +	if (!prop)
> +		return -ENOMEM;
> +
> +	prop = CREATE_COLORKEY_PROP(plane, min, range, 0, U64_MAX);
> +	if (!prop)
> +		return -ENOMEM;
> +
> +	prop = CREATE_COLORKEY_PROP(plane, max, range, 0, U64_MAX);
> +	if (!prop)
> +		return -ENOMEM;
> +
> +	if (replace) {
> +		prop = CREATE_COLORKEY_PROP(plane, value, range, 0, U64_MAX);
> +		if (!prop)
> +			return -ENOMEM;
> +	}


#undef CREATE_COLORKEY_PROP ?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(drm_plane_create_colorkey_properties);
> diff --git a/include/drm/drm_blend.h b/include/drm/drm_blend.h
> index 17606026590b..1d4c965dd5e2 100644
> --- a/include/drm/drm_blend.h
> +++ b/include/drm/drm_blend.h
> @@ -49,4 +49,8 @@ int drm_plane_create_zpos_immutable_property(struct drm_plane *plane,
>  					     unsigned int zpos);
>  int drm_atomic_normalize_zpos(struct drm_device *dev,
>  			      struct drm_atomic_state *state);
> +
> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> +					 const struct drm_prop_enum_list *modes,
> +					 unsigned int num_modes, bool replace);
>  #endif
> diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
> index 8185e3468a23..a5804a4ea5c3 100644
> --- a/include/drm/drm_plane.h
> +++ b/include/drm/drm_plane.h
> @@ -52,6 +52,13 @@ struct drm_modeset_acquire_ctx;
>   *	where N is the number of active planes for given crtc. Note that
>   *	the driver must call drm_atomic_normalize_zpos() to update this before
>   *	it can be trusted.
> + * @colorkey.mode: color key mode. 0 disabled color keying, other values are
> + *	driver-specific.
> + * @colorkey.min: color key range minimum. The value is stored in AXYZ16161616
> + *	format, where A is the alpha value and X, Y and Z correspond to the
> + *	color components of the plane's pixel format (usually RGB or YUV).
> + * @colorkey.max: color key range maximum (in AXYZ16161616 format)
> + * @colorkey.value: color key replacement value (in in AXYZ16161616 format)
>   * @src: clipped source coordinates of the plane (in 16.16)
>   * @dst: clipped destination coordinates of the plane
>   * @state: backpointer to global drm_atomic_state
> @@ -112,6 +119,14 @@ struct drm_plane_state {
>  	unsigned int zpos;
>  	unsigned int normalized_zpos;
>  
> +	/* Plane colorkey */
> +	struct {
> +		unsigned int mode;
> +		u64 min;
> +		u64 max;
> +		u64 value;
> +	} colorkey;
> +
>  	/* Clipped coordinates */
>  	struct drm_rect src, dst;
>  
> @@ -481,9 +496,13 @@ enum drm_plane_type {
>   * @funcs: helper functions
>   * @properties: property tracking for this plane
>   * @type: type of plane (overlay, primary, cursor)
> + * @helper_private: mid-layer private data
>   * @zpos_property: zpos property for this plane
>   * @rotation_property: rotation property for this plane
> - * @helper_private: mid-layer private data
> + * @colorkey.mode_property: color key mode property
> + * @colorkey.min_property: color key range minimum property
> + * @colorkey.max_property: color key range maximum property
> + * @colorkey.value_property: color key replacement value property
>   */
>  struct drm_plane {
>  	struct drm_device *dev;
> @@ -558,6 +577,13 @@ struct drm_plane {
>  
>  	struct drm_property *zpos_property;
>  	struct drm_property *rotation_property;
> +
> +	struct {
> +		struct drm_property *mode_property;
> +		struct drm_property *min_property;
> +		struct drm_property *max_property;
> +		struct drm_property *value_property;
> +	} colorkey;
>  };
>  
>  #define obj_to_plane(x) container_of(x, struct drm_plane, base)
> 

Apart from that,

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
