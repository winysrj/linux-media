Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40666 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031885AbeEZQQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 12:16:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
Date: Sat, 26 May 2018 19:16:54 +0300
Message-ID: <4468833.XY6THhPN9R@avalon>
In-Reply-To: <20180526155623.12610-2-digetx@gmail.com>
References: <20180526155623.12610-1-digetx@gmail.com> <20180526155623.12610-2-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dimitri,

Thank you for the patch.

I'll review this in details, but as this patch is based on the "[PATCH/RFC 
1/4] drm: Add colorkey properties" patch I've submitted, please retain the 
authorship, both in the Signed-off-by line, and in the patch author in git.

On Saturday, 26 May 2018 18:56:22 EEST Dmitry Osipenko wrote:
> Color keying is the action of replacing pixels matching a given color
> (or range of colors) with transparent pixels in an overlay when
> performing blitting. Depending on the hardware capabilities, the
> matching pixel can either become fully transparent or gain adjustment
> of the pixels component values.
> 
> Color keying is found in a large number of devices whose capabilities
> often differ, but they still have enough common features in range to
> standardize color key properties. This commit adds nine generic DRM plane
> properties related to the color keying to cover various HW capabilities.
> 
> This patch is based on the initial work done by Laurent Pinchart, most of
> credits for this patch goes to him.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  drivers/gpu/drm/drm_atomic.c |  36 ++++++
>  drivers/gpu/drm/drm_blend.c  | 229 +++++++++++++++++++++++++++++++++++
>  include/drm/drm_blend.h      |   3 +
>  include/drm/drm_plane.h      |  77 ++++++++++++
>  4 files changed, 345 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> index 895741e9cd7d..5b808cb68654 100644
> --- a/drivers/gpu/drm/drm_atomic.c
> +++ b/drivers/gpu/drm/drm_atomic.c
> @@ -799,6 +799,24 @@ static int drm_atomic_plane_set_property(struct
> drm_plane *plane, state->rotation = val;
>  	} else if (property == plane->zpos_property) {
>  		state->zpos = val;
> +	} else if (property == plane->colorkey.mode_property) {
> +		state->colorkey.mode = val;
> +	} else if (property == plane->colorkey.min_property) {
> +		state->colorkey.min = val;
> +	} else if (property == plane->colorkey.max_property) {
> +		state->colorkey.max = val;
> +	} else if (property == plane->colorkey.format_property) {
> +		state->colorkey.format = val;
> +	} else if (property == plane->colorkey.mask_property) {
> +		state->colorkey.mask = val;
> +	} else if (property == plane->colorkey.inverted_match_property) {
> +		state->colorkey.inverted_match = val;
> +	} else if (property == plane->colorkey.replacement_mask_property) {
> +		state->colorkey.replacement_mask = val;
> +	} else if (property == plane->colorkey.replacement_value_property) {
> +		state->colorkey.replacement_value = val;
> +	} else if (property == plane->colorkey.replacement_format_property) {
> +		state->colorkey.replacement_format = val;
>  	} else if (property == plane->color_encoding_property) {
>  		state->color_encoding = val;
>  	} else if (property == plane->color_range_property) {
> @@ -864,6 +882,24 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
>  		*val = state->rotation;
>  	} else if (property == plane->zpos_property) {
>  		*val = state->zpos;
> +	} else if (property == plane->colorkey.mode_property) {
> +		*val = state->colorkey.mode;
> +	} else if (property == plane->colorkey.min_property) {
> +		*val = state->colorkey.min;
> +	} else if (property == plane->colorkey.max_property) {
> +		*val = state->colorkey.max;
> +	} else if (property == plane->colorkey.format_property) {
> +		*val = state->colorkey.format;
> +	} else if (property == plane->colorkey.mask_property) {
> +		*val = state->colorkey.mask;
> +	} else if (property == plane->colorkey.inverted_match_property) {
> +		*val = state->colorkey.inverted_match;
> +	} else if (property == plane->colorkey.replacement_mask_property) {
> +		*val = state->colorkey.replacement_mask;
> +	} else if (property == plane->colorkey.replacement_value_property) {
> +		*val = state->colorkey.replacement_value;
> +	} else if (property == plane->colorkey.replacement_format_property) {
> +		*val = state->colorkey.replacement_format;
>  	} else if (property == plane->color_encoding_property) {
>  		*val = state->color_encoding;
>  	} else if (property == plane->color_range_property) {
> diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
> index a16a74d7e15e..05e5632ce375 100644
> --- a/drivers/gpu/drm/drm_blend.c
> +++ b/drivers/gpu/drm/drm_blend.c
> @@ -107,6 +107,11 @@
>   *	planes. Without this property the primary plane is always below the
> cursor *	plane, and ordering between all other planes is undefined.
>   *
> + * colorkey:
> + *	Color keying is set up with drm_plane_create_colorkey_properties().
> + *	It adds support for replacing a range of colors with a transparent
> + *	color in the plane.
> + *
>   * Note that all the property extensions described here apply either to the
> * plane or the CRTC (e.g. for the background color, which currently is not
> * exposed and assumed to be black).
> @@ -448,3 +453,227 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
>  	return 0;
>  }
>  EXPORT_SYMBOL(drm_atomic_normalize_zpos);
> +
> +static const char * const plane_colorkey_mode_name[] = {
> +	[DRM_PLANE_COLORKEY_MODE_DISABLED] = "disabled",
> +	[DRM_PLANE_COLORKEY_MODE_SRC] = "src-match-src-replace",
> +	[DRM_PLANE_COLORKEY_MODE_DST] = "dst-match-src-replace",
> +};
> +
> +/**
> + * drm_plane_create_colorkey_properties - create colorkey properties
> + * @plane: drm plane
> + * @supported_modes: bitmask of supported color keying modes
> + *
> + * This function creates the generic color keying properties and attach
> them to + * the plane to enable color keying control for blending
> operations. + *
> + * Color keying is controlled through nine properties:
> + *
> + * colorkey.mode:
> + *	The mode is an enumerated property that controls how color keying
> + *	operates. The "disabled" mode that disables color keying and is
> + *	very likely to exist if color keying is supported, it should be the
> + *	default mode.
> + *
> + * colorkey.min, colorkey.max:
> + *	These two properties specify the colors that are treated as the color
> + *	key. Pixel whose value is in the [min, max] range is the color key
> + *	matching pixel. The minimum and maximum values are expressed as a
> + *	64-bit integer in AXYZ16161616 format, where A is the alpha value and
> + *	X, Y and Z correspond to the color components of the colorkey.format.
> + *	In most cases XYZ will be either RGB or YUV.
> + *
> + *	When a single color key is desired instead of a range, userspace shall
> + *	set the min and max properties to the same value.
> + *
> + *	Drivers return an error from their plane atomic check if range can't be
> + *	handled.
> + *
> + * colorkey.format:
> + *	This property specifies the pixel format for the colorkey.min / max
> + *	properties. The format is given in a form of DRM fourcc code.
> + *
> + *	Drivers return an error from their plane atomic check if pixel format
> + *	is unsupported.
> + *
> + * colorkey.mask:
> + *	This property specifies the pixel components mask. Unmasked pixel
> + *	components are not participating in the matching. This mask value is
> + *	applied to colorkey.min / max values. The mask value is given in a
> + *	form of DRM fourcc code corresponding to the colorkey.format property.
> + *
> + *	For example: userspace shall set the colorkey.mask to 0x0000ff00
> + *	to match only the green component if colorkey.format is set to
> + *	DRM_FORMAT_XRGB8888.
> + *
> + *	Drivers return an error from their plane atomic check if mask value
> + *	can't be handled.
> + *
> + * colorkey.inverted-match:
> + *	This property specifies whether the matching min-max range should
> + *	be inverted, i.e. pixels outside of the given color range become
> + *	the color key match.
> + *
> + *	Drivers return an error from their plane atomic check if inversion
> + *	mode can't be handled.
> + *
> + * colorkey.replacement-value:
> + *	This property specifies the color value that replaces pixels matching
> + *	the color key. The value is expressed in AXYZ16161616 format, where A
> + *	is the alpha value and X, Y and Z correspond to the color components
> + *	of the colorkey.replacement-format.
> + *
> + *	Drivers return an error from their plane atomic check if replacement
> + *	value can't be handled.
> + *
> + * colorkey.replacement-format:
> + *	This property specifies the pixel format for the
> + *	colorkey.replacement-value property. The format is given in a form of
> + *	DRM fourcc code.
> + *
> + *	Drivers return an error from their plane atomic check if replacement
> + *	pixel format is unsupported.
> + *
> + * colorkey.replacement-mask:
> + *	This property specifies the pixel components mask that defines
> + *	what components of the colorkey.replacement-value will participate in
> + *	replacement of the pixels color. Unmasked pixel components are not
> + *	participating in the replacement. The mask value is given in a form of
> + *	DRM fourcc code corresponding to the colorkey.replacement-format
> + *	property.
> + *
> + *	For example: userspace shall set the colorkey.replacement-mask to
> + *	0x0000ff00 to replace only the green component if
> + *	colorkey.replacement-format is set to DRM_FORMAT_XRGB8888.
> + *
> + *	Userspace shall set colorkey.replacement-mask to 0 to disable the color
> + *	replacement. In this case matching pixels become transparent.
> + *
> + *	Drivers return an error from their plane atomic check if replacement
> + *	mask value can't be handled.
> + *
> + * Returns:
> + * Zero on success, negative errno on failure.
> + */
> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> +					 u32 supported_modes)
> +{
> +	struct drm_prop_enum_list modes_list[DRM_PLANE_COLORKEY_MODES_NUM];
> +	struct drm_property *replacement_format_prop;
> +	struct drm_property *replacement_value_prop;
> +	struct drm_property *replacement_mask_prop;
> +	struct drm_property *inverted_match_prop;
> +	struct drm_property *format_prop;
> +	struct drm_property *mask_prop;
> +	struct drm_property *mode_prop;
> +	struct drm_property *min_prop;
> +	struct drm_property *max_prop;
> +	unsigned int modes_num = 0;
> +	unsigned int i;
> +
> +	/* at least two modes should be supported */
> +	if (!supported_modes)
> +		return -EINVAL;
> +
> +	/* modes are driver-specific, build the list of supported modes */
> +	for (i = 0; i < DRM_PLANE_COLORKEY_MODES_NUM; i++) {
> +		if (!(supported_modes & BIT(i)))
> +			continue;
> +
> +		modes_list[modes_num].name = plane_colorkey_mode_name[i];
> +		modes_list[modes_num].type = i;
> +		modes_num++;
> +	}
> +
> +	mode_prop = drm_property_create_enum(plane->dev, 0, "colorkey.mode",
> +					     modes_list, modes_num);
> +	if (!mode_prop)
> +		return -ENOMEM;
> +
> +	mask_prop = drm_property_create_range(plane->dev, 0, "colorkey.mask",
> +					      0, U64_MAX);
> +	if (!mask_prop)
> +		goto err_destroy_mode_prop;
> +
> +	min_prop = drm_property_create_range(plane->dev, 0, "colorkey.min",
> +					     0, U64_MAX);
> +	if (!min_prop)
> +		goto err_destroy_mask_prop;
> +
> +	max_prop = drm_property_create_range(plane->dev, 0, "colorkey.max",
> +					     0, U64_MAX);
> +	if (!max_prop)
> +		goto err_destroy_min_prop;
> +
> +	format_prop = drm_property_create_range(plane->dev, 0,
> +					"colorkey.format",
> +					0, U32_MAX);
> +	if (!format_prop)
> +		goto err_destroy_max_prop;
> +
> +	inverted_match_prop = drm_property_create_bool(plane->dev, 0,
> +					"colorkey.inverted-match");
> +	if (!inverted_match_prop)
> +		goto err_destroy_format_prop;
> +
> +	replacement_mask_prop = drm_property_create_range(plane->dev, 0,
> +					"colorkey.replacement-mask",
> +					0, U64_MAX);
> +	if (!replacement_mask_prop)
> +		goto err_destroy_inverted_match_prop;
> +
> +	replacement_value_prop = drm_property_create_range(plane->dev, 0,
> +					"colorkey.replacement-value",
> +					0, U64_MAX);
> +	if (!replacement_value_prop)
> +		goto err_destroy_replacement_mask_prop;
> +
> +	replacement_format_prop = drm_property_create_range(plane->dev, 0,
> +					"colorkey.replacement-format",
> +					0, U64_MAX);
> +	if (!replacement_format_prop)
> +		goto err_destroy_replacement_value_prop;
> +
> +	drm_object_attach_property(&plane->base, min_prop, 0);
> +	drm_object_attach_property(&plane->base, max_prop, 0);
> +	drm_object_attach_property(&plane->base, mode_prop, 0);
> +	drm_object_attach_property(&plane->base, mask_prop, 0);
> +	drm_object_attach_property(&plane->base, format_prop, 0);
> +	drm_object_attach_property(&plane->base, inverted_match_prop, 0);
> +	drm_object_attach_property(&plane->base, replacement_mask_prop, 0);
> +	drm_object_attach_property(&plane->base, replacement_value_prop, 0);
> +	drm_object_attach_property(&plane->base, replacement_format_prop, 0);
> +
> +	plane->colorkey.min_property = min_prop;
> +	plane->colorkey.max_property = max_prop;
> +	plane->colorkey.mode_property = mode_prop;
> +	plane->colorkey.mask_property = mask_prop;
> +	plane->colorkey.format_property = format_prop;
> +	plane->colorkey.inverted_match_property = inverted_match_prop;
> +	plane->colorkey.replacement_mask_property = replacement_mask_prop;
> +	plane->colorkey.replacement_value_property = replacement_value_prop;
> +	plane->colorkey.replacement_format_property = replacement_format_prop;
> +
> +	return 0;
> +
> +err_destroy_replacement_value_prop:
> +	drm_property_destroy(plane->dev, replacement_value_prop);
> +err_destroy_replacement_mask_prop:
> +	drm_property_destroy(plane->dev, replacement_mask_prop);
> +err_destroy_inverted_match_prop:
> +	drm_property_destroy(plane->dev, inverted_match_prop);
> +err_destroy_format_prop:
> +	drm_property_destroy(plane->dev, format_prop);
> +err_destroy_max_prop:
> +	drm_property_destroy(plane->dev, max_prop);
> +err_destroy_min_prop:
> +	drm_property_destroy(plane->dev, min_prop);
> +err_destroy_mask_prop:
> +	drm_property_destroy(plane->dev, mask_prop);
> +err_destroy_mode_prop:
> +	drm_property_destroy(plane->dev, mode_prop);
> +
> +	return -ENOMEM;
> +}
> +EXPORT_SYMBOL(drm_plane_create_colorkey_properties);
> diff --git a/include/drm/drm_blend.h b/include/drm/drm_blend.h
> index 330c561c4c11..8e80d33b643e 100644
> --- a/include/drm/drm_blend.h
> +++ b/include/drm/drm_blend.h
> @@ -52,4 +52,7 @@ int drm_plane_create_zpos_immutable_property(struct
> drm_plane *plane, unsigned int zpos);
>  int drm_atomic_normalize_zpos(struct drm_device *dev,
>  			      struct drm_atomic_state *state);
> +
> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> +					 u32 supported_modes);
>  #endif
> diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
> index 26fa50c2a50e..ff7f5ebe2b79 100644
> --- a/include/drm/drm_plane.h
> +++ b/include/drm/drm_plane.h
> @@ -32,6 +32,42 @@ struct drm_crtc;
>  struct drm_printer;
>  struct drm_modeset_acquire_ctx;
> 
> +/**
> + * enum drm_plane_colorkey_mode - uapi plane colorkey mode enumeration
> + */
> +enum drm_plane_colorkey_mode {
> +	/**
> +	 * @DRM_PLANE_COLORKEY_MODE_DISABLED:
> +	 *
> +	 * No color matching performed in this mode. This is the default
> +	 * common mode.
> +	 */
> +	DRM_PLANE_COLORKEY_MODE_DISABLED,
> +
> +	/**
> +	 * @DRM_PLANE_COLORKEY_MODE_SRC:
> +	 *
> +	 * In this mode color matching is performed with the pixels of
> +	 * the given plane and the matched pixels are fully (or partially)
> +	 * replaced with the replacement color or become completely
> +	 * transparent.
> +	 */
> +	DRM_PLANE_COLORKEY_MODE_SRC,
> +
> +	/**
> +	 * @DRM_PLANE_COLORKEY_MODE_DST:
> +	 *
> +	 * In this mode color matching is performed with the pixels of the
> +	 * planes z-positioned under the given plane and the pixels of the
> +	 * hovering plane that are xy-positioned as the underlying
> +	 * color-matched pixels are fully (or partially) replaced with the
> +	 * replacement color or become completely transparent.
> +	 */
> +	DRM_PLANE_COLORKEY_MODE_DST,
> +
> +	DRM_PLANE_COLORKEY_MODES_NUM,
> +};
> +
>  /**
>   * struct drm_plane_state - mutable plane state
>   * @plane: backpointer to the plane
> @@ -54,6 +90,21 @@ struct drm_modeset_acquire_ctx;
>   *	where N is the number of active planes for given crtc. Note that
>   *	the driver must set drm_mode_config.normalize_zpos or call
>   *	drm_atomic_normalize_zpos() to update this before it can be trusted.
> + * @colorkey.mode: color key mode
> + * @colorkey.min: color key range minimum. The value is stored in
> AXYZ16161616 + *	format, where A is the alpha value and X, Y and Z
> correspond to the + *	color components of the plane's pixel format (usually
> RGB or YUV) + * @colorkey.max: color key range maximum (in AXYZ16161616
> format) + * @colorkey.mask: color key mask value (in AXYZ16161616 format)
> + * @colorkey.format: color key min/max/mask values pixel format (in
> + * 	DRM_FORMAT_AXYZ16161616 form)
> + * @colorkey.inverted_match: color key min-max matching range is inverted
> + * @colorkey.replacement_mask: color key replacement mask value (in
> + * 	AXYZ16161616 format)
> + * @colorkey.replacement_value: color key replacement value (in
> + * 	AXYZ16161616 format)
> + * @colorkey.replacement_format: color key replacement value / mask
> + *	pixel format (in DRM_FORMAT_AXYZ16161616 form)
>   * @src: clipped source coordinates of the plane (in 16.16)
>   * @dst: clipped destination coordinates of the plane
>   * @state: backpointer to global drm_atomic_state
> @@ -124,6 +175,19 @@ struct drm_plane_state {
>  	unsigned int zpos;
>  	unsigned int normalized_zpos;
> 
> +	/* Plane colorkey */
> +	struct {
> +		enum drm_plane_colorkey_mode mode;
> +		u64 min;
> +		u64 max;
> +		u64 mask;
> +		u32 format;
> +		bool inverted_match;
> +		u64 replacement_mask;
> +		u64 replacement_value;
> +		u32 replacement_format;
> +	} colorkey;
> +
>  	/**
>  	 * @color_encoding:
>  	 *
> @@ -510,6 +574,7 @@ enum drm_plane_type {
>   * @alpha_property: alpha property for this plane
>   * @zpos_property: zpos property for this plane
>   * @rotation_property: rotation property for this plane
> + * @colorkey: colorkey properties for this plane
>   * @helper_private: mid-layer private data
>   */
>  struct drm_plane {
> @@ -587,6 +652,18 @@ struct drm_plane {
>  	struct drm_property *zpos_property;
>  	struct drm_property *rotation_property;
> 
> +	struct {
> +		struct drm_property *min_property;
> +		struct drm_property *max_property;
> +		struct drm_property *mode_property;
> +		struct drm_property *mask_property;
> +		struct drm_property *format_property;
> +		struct drm_property *inverted_match_property;
> +		struct drm_property *replacement_mask_property;
> +		struct drm_property *replacement_value_property;
> +		struct drm_property *replacement_format_property;
> +	} colorkey;
> +
>  	/**
>  	 * @color_encoding_property:
>  	 *

-- 
Regards,

Laurent Pinchart
