Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51288 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729547AbeHNMdr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 08:33:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] drm: Add generic colorkey properties for display planes
Date: Tue, 14 Aug 2018 12:48:08 +0300
Message-ID: <7041537.TPdt8DIvGD@avalon>
In-Reply-To: <20180807172202.1961-2-digetx@gmail.com>
References: <20180807172202.1961-1-digetx@gmail.com> <20180807172202.1961-2-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

Thank you for the patch.

On Tuesday, 7 August 2018 20:22:01 EEST Dmitry Osipenko wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Color keying is the action of replacing pixels matching a given color
> (or range of colors) with transparent pixels in an overlay when
> performing blitting. Depending on the hardware capabilities, the
> matching pixel can either become fully transparent or gain adjustment
> of the pixels component values.
> 
> Color keying is found in a large number of devices whose capabilities
> often differ, but they still have enough common features in range to
> standardize color key properties. This commit adds new generic DRM plane
> properties related to the color keying, providing initial color keying
> support.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  drivers/gpu/drm/drm_atomic.c |  20 +++++
>  drivers/gpu/drm/drm_blend.c  | 150 +++++++++++++++++++++++++++++++++++
>  include/drm/drm_blend.h      |   3 +
>  include/drm/drm_plane.h      |  91 +++++++++++++++++++++
>  4 files changed, 264 insertions(+)

[snip]

> diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
> index a16a74d7e15e..13c61dd0d9b7 100644
> --- a/drivers/gpu/drm/drm_blend.c
> +++ b/drivers/gpu/drm/drm_blend.c
> @@ -107,6 +107,11 @@
>   *	planes. Without this property the primary plane is always below the
> cursor *	plane, and ordering between all other planes is undefined.
>   *
> + * colorkey:
> + *	Color keying is set up with drm_plane_create_colorkey_properties().
> + *	It adds support for actions like replacing a range of colors with a
> + *	transparent color in the plane. Color keying is disabled by default.
> + *
>   * Note that all the property extensions described here apply either to the
> * plane or the CRTC (e.g. for the background color, which currently is not
> * exposed and assumed to be black).
> @@ -448,3 +453,148 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
>  	return 0;
>  }
>  EXPORT_SYMBOL(drm_atomic_normalize_zpos);
> +
> +static const char * const plane_colorkey_mode_name[] = {
> +	[DRM_PLANE_COLORKEY_MODE_DISABLED] = "disabled",
> +	[DRM_PLANE_COLORKEY_MODE_TRANSPARENT] = "transparent",
> +};
> +
> +/**
> + * drm_plane_create_colorkey_properties - create colorkey properties
> + * @plane: drm plane
> + * @supported_modes: bitmask of supported color keying modes
> + *
> + * This function creates the generic color keying properties and attaches
> them
> + * to the @plane to enable color keying control for blending operations.
> + *
> + * Glossary:
> + *
> + * Destination plane:
> + *	Plane to which color keying properties are applied, this planes takes
> + *	the effect of color keying operation. The effect is determined by a
> + *	given color keying mode.
> + *
> + * Source plane:
> + *	Pixels of this plane are the source for color key matching operation.
> + *
> + * Color keying is controlled by these properties:
> + *
> + * colorkey.plane_mask:
> + *	The mask property specifies which planes participate in color key
> + *	matching process, these planes are the color key sources.
> + *
> + *	Drivers return an error from their plane atomic check if plane can't be
> + *	handled.

This seems fragile to me. We don't document how userspace determines which 
planes need to be specified here, and we don't document what happens if a 
plane underneath the destination plane is not specified in the mask. More 
precise documentation is needed if we want to use such a property.

It also seems quite complex. Is an explicit plane mask really the best option 
? What's the reason why planes couldn't be handled ? How do drivers determine 
that ?

> + * colorkey.mode:
> + *	The mode is an enumerated property that controls how color keying
> + *	operates.

A link to the drm_plane_colorkey_mode enum documentation would be useful.

> + * colorkey.mask:
> + *	This property specifies the pixel components mask. Unmasked pixel
> + *	components are not participating in the matching. This mask value is
> + *	applied to colorkey.min / max values. The mask value is given in a
> + *	64-bit integer in ARGB16161616 format, where A is the alpha value and
> + *	R, G and B correspond to the color components. Drivers shall convert
> + *	ARGB16161616 value into appropriate format within planes atomic check.
> + *
> + *	Drivers return an error from their plane atomic check if mask can't be
> + *	handled.
> + *
> + * colorkey.min, colorkey.max:
> + *	These two properties specify the colors that are treated as the color
> + *	key. Pixel whose value is in the [min, max] range is the color key
> + *	matching pixel. The minimum and maximum values are expressed as a
> + *	64-bit integer in ARGB16161616 format, where A is the alpha value and
> + *	R, G and B correspond to the color components. Drivers shall convert
> + *	ARGB16161616 value into appropriate format within planes atomic check.
> + *	The converted value shall be *rounded up* to the nearest value.
> + *
> + *	When a single color key is desired instead of a range, userspace shall
> + *	set the min and max properties to the same value.
> + *
> + *	Drivers return an error from their plane atomic check if range can't be
> + *	handled.
> + *
> + * Returns:
> + * Zero on success, negative errno on failure.
> + */

While you're defining the concept of source and destination planes, it's not 
clear from the documentation how all this maps to the usual source and 
destination color keying concepts. I think that should be documented as well 
or users will be confused. Examples could help in this area.

[snip]

> diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
> index 8a152dc16ea5..ab6a91e6b54e 100644
> --- a/include/drm/drm_plane.h
> +++ b/include/drm/drm_plane.h

[snip]

> @@ -32,6 +33,52 @@ struct drm_crtc;
>  struct drm_printer;
>  struct drm_modeset_acquire_ctx;
> 
> +/**
> + * enum drm_plane_colorkey_mode - uapi plane colorkey mode enumeration
> + */

If it's uAPI, should it be moved to include/uapi/drm/ ?

> +enum drm_plane_colorkey_mode {
> +	/**
> +	 * @DRM_PLANE_COLORKEY_MODE_DISABLED:
> +	 *
> +	 * No color matching performed in this mode.

Do you mean "No color keying" ?

> +	 */
> +	DRM_PLANE_COLORKEY_MODE_DISABLED,
> +
> +	/**
> +	 * @DRM_PLANE_COLORKEY_MODE_TRANSPARENT:
> +	 *
> +	 * Destination plane pixels are completely transparent in areas
> +	 * where pixels of a source plane are matching a given color key
> +	 * range, in other cases pixels of a destination plane are unaffected.

How do we handle hardware that performs configurable color replacement instead 
of a fixed fully transparency ? That was included in my original proposal and 
available in R-Car hardware.

> +	 * In areas where two or more source planes overlap, the topmost
> +	 * plane takes precedence.
> +	 */
> +	DRM_PLANE_COLORKEY_MODE_TRANSPARENT,
> +
> +	/**
> +	 * @DRM_PLANE_COLORKEY_MODES_NUM:
> +	 *
> +	 * Total number of color keying modes.
> +	 */
> +	DRM_PLANE_COLORKEY_MODES_NUM,

This one, however, shouldn't be part of the uAPI as it will change when we 
will add new modes.

> +};

[snip]

> @@ -779,5 +846,29 @@ static inline struct drm_plane *drm_plane_find(struct
> drm_device *dev, #define drm_for_each_plane(plane, dev) \
>  	list_for_each_entry(plane, &(dev)->mode_config.plane_list, head)
> 
> +/**
> + * drm_colorkey_extract_component - get color key component value
> + * @ckey64: 64bit color key value
> + * @comp_name: name of 16bit color component to extract
> + * @nbits: size in bits of extracted component value
> + *
> + * Extract 16bit color component of @ckey64 given by @comp_name (alpha,
> red,
> + * green or blue) and convert it to an unsigned integer that has bit-width
> + * of @nbits (result is rounded-up).
> + */
> +#define drm_colorkey_extract_component(ckey64, comp_name, nbits) \
> +	__DRM_CKEY_CLAMP(__DRM_CKEY_CONV(ckey64, comp_name, nbits), nbits)
> +
> +#define __drm_ckey_alpha_shift	48
> +#define __drm_ckey_red_shift	32
> +#define __drm_ckey_green_shift	16
> +#define __drm_ckey_blue_shift	0
> +
> +#define __DRM_CKEY_CONV(ckey64, comp_name, nbits) \
> +	DIV_ROUND_UP((u16)((ckey64) >> __drm_ckey_ ## comp_name ## _shift), \
> +		     1 << (16 - (nbits)))

As the divisor is a power of two, could we use masking instead of a division ? 
Or do you expect the compiler to optimize it properly ?

> +#define __DRM_CKEY_CLAMP(value, nbits) \
> +	min_t(u16, (value), (1 << (nbits)) - 1)

Would the following be simpler to read and a bit more efficient as it avoids 
the division ?

static inline u16 __drm_colorkey_extract_component(u64 ckey64, 
                                                   unsigned int shift, 
                                                   unsigned int nbits)
{       
        u16 mask = (1 << (16 - nbits)) - 1;
        
        return ((u16)(ckey >> shift) + mask) >> (16 - nbits);
}

#define drm_colorkey_extract_component(ckey64, comp_name, nbits) \
        __drm_colorkey_extract_component(ckey64, __drm_ckey_ ## comp_name ## 
_shift, nbits)

>  #endif

-- 
Regards,

Laurent Pinchart
