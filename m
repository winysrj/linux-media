Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51071 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932360AbeE1Xs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 19:48:26 -0400
Subject: Re: [RFC PATCH v2 1/2] drm: Add generic colorkey properties
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
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
References: <20180526155623.12610-1-digetx@gmail.com>
 <20180526155623.12610-2-digetx@gmail.com> <20180528131501.GK23723@intel.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <efba1801-5b00-1fa1-45df-a5d3a2e3d63a@gmail.com>
Date: Tue, 29 May 2018 02:48:22 +0300
MIME-Version: 1.0
In-Reply-To: <20180528131501.GK23723@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.05.2018 16:15, Ville Syrjälä wrote:
> On Sat, May 26, 2018 at 06:56:22PM +0300, Dmitry Osipenko wrote:
>> Color keying is the action of replacing pixels matching a given color
>> (or range of colors) with transparent pixels in an overlay when
>> performing blitting. Depending on the hardware capabilities, the
>> matching pixel can either become fully transparent or gain adjustment
>> of the pixels component values.
>>
>> Color keying is found in a large number of devices whose capabilities
>> often differ, but they still have enough common features in range to
>> standardize color key properties. This commit adds nine generic DRM plane
>> properties related to the color keying to cover various HW capabilities.
>>
>> This patch is based on the initial work done by Laurent Pinchart, most of
>> credits for this patch goes to him.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>  drivers/gpu/drm/drm_atomic.c |  36 ++++++
>>  drivers/gpu/drm/drm_blend.c  | 229 +++++++++++++++++++++++++++++++++++
>>  include/drm/drm_blend.h      |   3 +
>>  include/drm/drm_plane.h      |  77 ++++++++++++
>>  4 files changed, 345 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
>> index 895741e9cd7d..5b808cb68654 100644
>> --- a/drivers/gpu/drm/drm_atomic.c
>> +++ b/drivers/gpu/drm/drm_atomic.c
>> @@ -799,6 +799,24 @@ static int drm_atomic_plane_set_property(struct drm_plane *plane,
>>  		state->rotation = val;
>>  	} else if (property == plane->zpos_property) {
>>  		state->zpos = val;
>> +	} else if (property == plane->colorkey.mode_property) {
>> +		state->colorkey.mode = val;
>> +	} else if (property == plane->colorkey.min_property) {
>> +		state->colorkey.min = val;
>> +	} else if (property == plane->colorkey.max_property) {
>> +		state->colorkey.max = val;
>> +	} else if (property == plane->colorkey.format_property) {
>> +		state->colorkey.format = val;
>> +	} else if (property == plane->colorkey.mask_property) {
>> +		state->colorkey.mask = val;
>> +	} else if (property == plane->colorkey.inverted_match_property) {
>> +		state->colorkey.inverted_match = val;
>> +	} else if (property == plane->colorkey.replacement_mask_property) {
>> +		state->colorkey.replacement_mask = val;
>> +	} else if (property == plane->colorkey.replacement_value_property) {
>> +		state->colorkey.replacement_value = val;
>> +	} else if (property == plane->colorkey.replacement_format_property) {
>> +		state->colorkey.replacement_format = val;
>>  	} else if (property == plane->color_encoding_property) {
>>  		state->color_encoding = val;
>>  	} else if (property == plane->color_range_property) {
>> @@ -864,6 +882,24 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
>>  		*val = state->rotation;
>>  	} else if (property == plane->zpos_property) {
>>  		*val = state->zpos;
>> +	} else if (property == plane->colorkey.mode_property) {
>> +		*val = state->colorkey.mode;
>> +	} else if (property == plane->colorkey.min_property) {
>> +		*val = state->colorkey.min;
>> +	} else if (property == plane->colorkey.max_property) {
>> +		*val = state->colorkey.max;
>> +	} else if (property == plane->colorkey.format_property) {
>> +		*val = state->colorkey.format;
>> +	} else if (property == plane->colorkey.mask_property) {
>> +		*val = state->colorkey.mask;
>> +	} else if (property == plane->colorkey.inverted_match_property) {
>> +		*val = state->colorkey.inverted_match;
>> +	} else if (property == plane->colorkey.replacement_mask_property) {
>> +		*val = state->colorkey.replacement_mask;
>> +	} else if (property == plane->colorkey.replacement_value_property) {
>> +		*val = state->colorkey.replacement_value;
>> +	} else if (property == plane->colorkey.replacement_format_property) {
>> +		*val = state->colorkey.replacement_format;
>>  	} else if (property == plane->color_encoding_property) {
>>  		*val = state->color_encoding;
>>  	} else if (property == plane->color_range_property) {
>> diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
>> index a16a74d7e15e..05e5632ce375 100644
>> --- a/drivers/gpu/drm/drm_blend.c
>> +++ b/drivers/gpu/drm/drm_blend.c
>> @@ -107,6 +107,11 @@
>>   *	planes. Without this property the primary plane is always below the cursor
>>   *	plane, and ordering between all other planes is undefined.
>>   *
>> + * colorkey:
>> + *	Color keying is set up with drm_plane_create_colorkey_properties().
>> + *	It adds support for replacing a range of colors with a transparent
>> + *	color in the plane.
>> + *
>>   * Note that all the property extensions described here apply either to the
>>   * plane or the CRTC (e.g. for the background color, which currently is not
>>   * exposed and assumed to be black).
>> @@ -448,3 +453,227 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(drm_atomic_normalize_zpos);
>> +
>> +static const char * const plane_colorkey_mode_name[] = {
>> +	[DRM_PLANE_COLORKEY_MODE_DISABLED] = "disabled",
>> +	[DRM_PLANE_COLORKEY_MODE_SRC] = "src-match-src-replace",
>> +	[DRM_PLANE_COLORKEY_MODE_DST] = "dst-match-src-replace",
> 
> This list seems way more limited than I was expecting, at least when
> compared to all the different props you're proposing to add.
> 

What else are you expecting to see in the list?

>> +};
>> +
>> +/**
>> + * drm_plane_create_colorkey_properties - create colorkey properties
>> + * @plane: drm plane
>> + * @supported_modes: bitmask of supported color keying modes
>> + *
>> + * This function creates the generic color keying properties and attach them to
>> + * the plane to enable color keying control for blending operations.
>> + *
>> + * Color keying is controlled through nine properties:
>> + *
>> + * colorkey.mode:
>> + *	The mode is an enumerated property that controls how color keying
>> + *	operates. The "disabled" mode that disables color keying and is
>> + *	very likely to exist if color keying is supported, it should be the
>> + *	default mode.
>> + *
>> + * colorkey.min, colorkey.max:
>> + *	These two properties specify the colors that are treated as the color
>> + *	key. Pixel whose value is in the [min, max] range is the color key
>> + *	matching pixel. The minimum and maximum values are expressed as a
>> + *	64-bit integer in AXYZ16161616 format, where A is the alpha value and
>> + *	X, Y and Z correspond to the color components of the colorkey.format.
>> + *	In most cases XYZ will be either RGB or YUV.
>> + *
>> + *	When a single color key is desired instead of a range, userspace shall
>> + *	set the min and max properties to the same value.
>> + *
>> + *	Drivers return an error from their plane atomic check if range can't be
>> + *	handled.
>> + *
>> + * colorkey.format:
>> + *	This property specifies the pixel format for the colorkey.min / max
>> + *	properties. The format is given in a form of DRM fourcc code.
> 
> Umm. Why we do even need this? This seems incompatible with your earlier
> "min/max are specified in 16bpc format" statement.
> 

AXYZ16161616 is just an abstraction of a pixel format, at least that's how I'm
interpreting the AXYZ16161616.

Previously Laurent specified that min/max values should be given in the format
of the planes framebuffer. This doesn't work for a case of setting property for
a disabled plane because disabled plane doesn't have a framebuffer. This also
doesn't work for Tegra that can take only XRGB8888 format for a color key, AFAIK
HW internally converts all pixel formats to ARGB8888 and RGB part participates
in the color matching (later Tegra's support alpha channel matching as well).
Hence I added the format property that explicitly tells in what format the color
key integer value is given.

I'm now thinking that format property should be exposed to userspace in a form
of a ENUM-list, because otherwise userspace doesn't know what color key formats
are supported by the DRM driver.

And probably somehow userspace should be informed about that colorkey format
should match the framebuffers format if that's what driver expects. Maybe a
read-only property?

>> + *
>> + *	Drivers return an error from their plane atomic check if pixel format
>> + *	is unsupported.
>> + *
>> + * colorkey.mask:
>> + *	This property specifies the pixel components mask. Unmasked pixel
>> + *	components are not participating in the matching. This mask value is
>> + *	applied to colorkey.min / max values. The mask value is given in a
>> + *	form of DRM fourcc code corresponding to the colorkey.format property.
>> + *
>> + *	For example: userspace shall set the colorkey.mask to 0x0000ff00
>> + *	to match only the green component if colorkey.format is set to
>> + *	DRM_FORMAT_XRGB8888.
>> + *
>> + *	Drivers return an error from their plane atomic check if mask value
>> + *	can't be handled.
>> + *
>> + * colorkey.inverted-match:
>> + *	This property specifies whether the matching min-max range should
>> + *	be inverted, i.e. pixels outside of the given color range become
>> + *	the color key match.
>> + *
>> + *	Drivers return an error from their plane atomic check if inversion
>> + *	mode can't be handled.
> 
> Hmm. I'm trying to figure out what this means for the src vs. dst
> colorkey modes. Those pretty much already have an inverted meaning when
> compared to each other. So I can't figure out from these docs whether 
> you're supposed to use this when you want a normal dst ckey or normal
> src key semantics.
> 

I also couldn't understand what initial semantic to src/dst was given by Laurent.

In a case of this patch:

The src/dst-match specifies the "source" plane for which the color matching is
performed. Src means the plane to which the colorkey properties are applied. Dst
means planes other than plane X to which the colorkey properties are applied, in
particular the planes that are Z-positioned under the plane X. Hope that's more
clear now.

The src-replace part specifies that pixels of the plane to which the colorkey
properties are applied will be replaced.

I'll try to re-work the doc if the above sounds good.

The inverted-match property controls whether given color-match range shall be
inverted, like for example: if given color key is a red color, then all colors
expect the red will be matched as a color key.

Actually maybe inversion could be expressed using the mask solely. Like we could
add a helper that converts "value+mask" into "value=(value & ~mask),
inversion=true" if mask has form of 0x11000111, though this could be not
applicable to all possible pixel formats.. not sure.

>> + *
>> + * colorkey.replacement-value:
>> + *	This property specifies the color value that replaces pixels matching
>> + *	the color key. The value is expressed in AXYZ16161616 format, where A
>> + *	is the alpha value and X, Y and Z correspond to the color components
>> + *	of the colorkey.replacement-format.
>> + *
>> + *	Drivers return an error from their plane atomic check if replacement
>> + *	value can't be handled.
>> + *
>> + * colorkey.replacement-format:
>> + *	This property specifies the pixel format for the
>> + *	colorkey.replacement-value property. The format is given in a form of
>> + *	DRM fourcc code.
> 
> Again this seems at odds with the 16bpc replacement-value.
> 
>> + *
>> + *	Drivers return an error from their plane atomic check if replacement
>> + *	pixel format is unsupported.
>> + *
>> + * colorkey.replacement-mask:
>> + *	This property specifies the pixel components mask that defines
>> + *	what components of the colorkey.replacement-value will participate in
>> + *	replacement of the pixels color. Unmasked pixel components are not
>> + *	participating in the replacement.
> 
> Does that mean that the data for the unmasked bits will be coming
> from the source?
> 

Yeah, I see that "source" is vaguely defined.

Yes, the unmasked bits are coming from the source. The "source" is defined by
the mode.

src-match- -->SRC<-- -replace
dst-match- -->SRC<-- -replace

Src means the plane to which the colorkey properties are applied, as I stated above.

>> The mask value is given in a form of
>> + *	DRM fourcc code corresponding to the colorkey.replacement-format
>> + *	property.
>> + *
>> + *	For example: userspace shall set the colorkey.replacement-mask to
>> + *	0x0000ff00 to replace only the green component if
>> + *	colorkey.replacement-format is set to DRM_FORMAT_XRGB8888.
>> + *
>> + *	Userspace shall set colorkey.replacement-mask to 0 to disable the color
>> + *	replacement. In this case matching pixels become transparent.
>> + *
>> + *	Drivers return an error from their plane atomic check if replacement
>> + *	mask value can't be handled.
>> + *
>> + * Returns:
>> + * Zero on success, negative errno on failure.
>> + */
>> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
>> +					 u32 supported_modes)
>> +{
>> +	struct drm_prop_enum_list modes_list[DRM_PLANE_COLORKEY_MODES_NUM];
>> +	struct drm_property *replacement_format_prop;
>> +	struct drm_property *replacement_value_prop;
>> +	struct drm_property *replacement_mask_prop;
>> +	struct drm_property *inverted_match_prop;
>> +	struct drm_property *format_prop;
>> +	struct drm_property *mask_prop;
>> +	struct drm_property *mode_prop;
>> +	struct drm_property *min_prop;
>> +	struct drm_property *max_prop;
>> +	unsigned int modes_num = 0;
>> +	unsigned int i;
>> +
>> +	/* at least two modes should be supported */
>> +	if (!supported_modes)
>> +		return -EINVAL;
>> +
>> +	/* modes are driver-specific, build the list of supported modes */
>> +	for (i = 0; i < DRM_PLANE_COLORKEY_MODES_NUM; i++) {
>> +		if (!(supported_modes & BIT(i)))
>> +			continue;
>> +
>> +		modes_list[modes_num].name = plane_colorkey_mode_name[i];
>> +		modes_list[modes_num].type = i;
>> +		modes_num++;
>> +	}
>> +
>> +	mode_prop = drm_property_create_enum(plane->dev, 0, "colorkey.mode",
>> +					     modes_list, modes_num);
>> +	if (!mode_prop)
>> +		return -ENOMEM;
>> +
>> +	mask_prop = drm_property_create_range(plane->dev, 0, "colorkey.mask",
>> +					      0, U64_MAX);
>> +	if (!mask_prop)
>> +		goto err_destroy_mode_prop;
>> +
>> +	min_prop = drm_property_create_range(plane->dev, 0, "colorkey.min",
>> +					     0, U64_MAX);
>> +	if (!min_prop)
>> +		goto err_destroy_mask_prop;
>> +
>> +	max_prop = drm_property_create_range(plane->dev, 0, "colorkey.max",
>> +					     0, U64_MAX);
>> +	if (!max_prop)
>> +		goto err_destroy_min_prop;
>> +
>> +	format_prop = drm_property_create_range(plane->dev, 0,
>> +					"colorkey.format",
>> +					0, U32_MAX);
>> +	if (!format_prop)
>> +		goto err_destroy_max_prop;
>> +
>> +	inverted_match_prop = drm_property_create_bool(plane->dev, 0,
>> +					"colorkey.inverted-match");
>> +	if (!inverted_match_prop)
>> +		goto err_destroy_format_prop;
>> +
>> +	replacement_mask_prop = drm_property_create_range(plane->dev, 0,
>> +					"colorkey.replacement-mask",
>> +					0, U64_MAX);
>> +	if (!replacement_mask_prop)
>> +		goto err_destroy_inverted_match_prop;
>> +
>> +	replacement_value_prop = drm_property_create_range(plane->dev, 0,
>> +					"colorkey.replacement-value",
>> +					0, U64_MAX);
>> +	if (!replacement_value_prop)
>> +		goto err_destroy_replacement_mask_prop;
>> +
>> +	replacement_format_prop = drm_property_create_range(plane->dev, 0,
>> +					"colorkey.replacement-format",
>> +					0, U64_MAX);
>> +	if (!replacement_format_prop)
>> +		goto err_destroy_replacement_value_prop;
> 
> I don't think we want to add all these props for every driver/hardware.
> IMO the set of props we expose should depend on the supported set of
> colorkeying modes.
> 

Probably, I don't mind. This should be documented then, I can address that in
the next iteration.

/I think/ all of the currently-defined properties are relevant to the defined
color keying modes. Later, if the list of modes will be extended with new modes,
the creation of properties could be conditionalized.

Though maybe "color components replacement" and "replacement with a complete
transparency" could be factored out into a specific color keying modes.

I'm open for suggestions.

[snip]
