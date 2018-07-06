Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:48190 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932502AbeGFMXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jul 2018 08:23:35 -0400
Date: Fri, 6 Jul 2018 15:23:18 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/2] drm: Add generic colorkey properties for DRM
 planes
Message-ID: <20180706122318.GI5565@intel.com>
References: <20180603220059.17670-1-digetx@gmail.com>
 <20180603220059.17670-2-digetx@gmail.com>
 <8b80e766-be05-b5be-5a0f-102a5135d230@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b80e766-be05-b5be-5a0f-102a5135d230@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2018 at 02:11:44PM +0200, Maarten Lankhorst wrote:
> Hey,
> 
> Op 04-06-18 om 00:00 schreef Dmitry Osipenko:
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >
> > Color keying is the action of replacing pixels matching a given color
> > (or range of colors) with transparent pixels in an overlay when
> > performing blitting. Depending on the hardware capabilities, the
> > matching pixel can either become fully transparent or gain adjustment
> > of the pixels component values.
> >
> > Color keying is found in a large number of devices whose capabilities
> > often differ, but they still have enough common features in range to
> > standardize color key properties. This commit adds three generic DRM plane
> > properties related to the color keying, providing initial color keying
> > support.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> > ---
> >  drivers/gpu/drm/drm_atomic.c | 12 +++++
> >  drivers/gpu/drm/drm_blend.c  | 99 ++++++++++++++++++++++++++++++++++++
> >  include/drm/drm_blend.h      |  3 ++
> >  include/drm/drm_plane.h      | 53 +++++++++++++++++++
> >  4 files changed, 167 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> > index 895741e9cd7d..b322cbed319b 100644
> > --- a/drivers/gpu/drm/drm_atomic.c
> > +++ b/drivers/gpu/drm/drm_atomic.c
> > @@ -799,6 +799,12 @@ static int drm_atomic_plane_set_property(struct drm_plane *plane,
> >  		state->rotation = val;
> >  	} else if (property == plane->zpos_property) {
> >  		state->zpos = val;
> > +	} else if (property == plane->colorkey.mode_property) {
> > +		state->colorkey.mode = val;
> > +	} else if (property == plane->colorkey.min_property) {
> > +		state->colorkey.min = val;
> > +	} else if (property == plane->colorkey.max_property) {
> > +		state->colorkey.max = val;
> >  	} else if (property == plane->color_encoding_property) {
> >  		state->color_encoding = val;
> >  	} else if (property == plane->color_range_property) {
> > @@ -864,6 +870,12 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
> >  		*val = state->rotation;
> >  	} else if (property == plane->zpos_property) {
> >  		*val = state->zpos;
> > +	} else if (property == plane->colorkey.mode_property) {
> > +		*val = state->colorkey.mode;
> > +	} else if (property == plane->colorkey.min_property) {
> > +		*val = state->colorkey.min;
> > +	} else if (property == plane->colorkey.max_property) {
> > +		*val = state->colorkey.max;
> >  	} else if (property == plane->color_encoding_property) {
> >  		*val = state->color_encoding;
> >  	} else if (property == plane->color_range_property) {
> > diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
> > index a16a74d7e15e..12fed2ff65c8 100644
> > --- a/drivers/gpu/drm/drm_blend.c
> > +++ b/drivers/gpu/drm/drm_blend.c
> > @@ -107,6 +107,11 @@
> >   *	planes. Without this property the primary plane is always below the cursor
> >   *	plane, and ordering between all other planes is undefined.
> >   *
> > + * colorkey:
> > + *	Color keying is set up with drm_plane_create_colorkey_properties().
> > + *	It adds support for replacing a range of colors with a transparent
> > + *	color in the plane.
> > + *
> >   * Note that all the property extensions described here apply either to the
> >   * plane or the CRTC (e.g. for the background color, which currently is not
> >   * exposed and assumed to be black).
> > @@ -448,3 +453,97 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(drm_atomic_normalize_zpos);
> > +
> > +static const char * const plane_colorkey_mode_name[] = {
> > +	[DRM_PLANE_COLORKEY_MODE_DISABLED] = "disabled",
> > +	[DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP] = "foreground-clip",
> > +};
> > +
> > +/**
> > + * drm_plane_create_colorkey_properties - create colorkey properties
> > + * @plane: drm plane
> > + * @supported_modes: bitmask of supported color keying modes
> > + *
> > + * This function creates the generic color keying properties and attach them to
> > + * the plane to enable color keying control for blending operations.
> > + *
> > + * Color keying is controlled by these properties:
> > + *
> > + * colorkey.mode:
> > + *	The mode is an enumerated property that controls how color keying
> > + *	operates.
> > + *
> > + * colorkey.min, colorkey.max:
> > + *	These two properties specify the colors that are treated as the color
> > + *	key. Pixel whose value is in the [min, max] range is the color key
> > + *	matching pixel. The minimum and maximum values are expressed as a
> > + *	64-bit integer in ARGB16161616 format, where A is the alpha value and
> > + *	R, G and B correspond to the color components. Drivers shall convert
> > + *	ARGB16161616 value into appropriate format within planes atomic check.
> > + *
> > + *	When a single color key is desired instead of a range, userspace shall
> > + *	set the min and max properties to the same value.
> > + *
> > + *	Drivers return an error from their plane atomic check if range can't be
> > + *	handled.
> > + *
> > + * Returns:
> > + * Zero on success, negative errno on failure.
> > + */
> > +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> > +					 u32 supported_modes)
> > +{
> > +	struct drm_prop_enum_list modes_list[DRM_PLANE_COLORKEY_MODES_NUM];
> > +	struct drm_property *mode_prop;
> > +	struct drm_property *min_prop;
> > +	struct drm_property *max_prop;
> > +	unsigned int modes_num = 0;
> > +	unsigned int i;
> > +
> > +	/* modes are driver-specific, build the list of supported modes */
> > +	for (i = 0; i < DRM_PLANE_COLORKEY_MODES_NUM; i++) {
> > +		if (!(supported_modes & BIT(i)))
> > +			continue;
> > +
> > +		modes_list[modes_num].name = plane_colorkey_mode_name[i];
> > +		modes_list[modes_num].type = i;
> > +		modes_num++;
> > +	}
> > +
> > +	/* at least one mode should be supported */
> > +	if (!modes_num)
> > +		return -EINVAL;
> > +
> > +	mode_prop = drm_property_create_enum(plane->dev, 0, "colorkey.mode",
> > +					     modes_list, modes_num);
> > +	if (!mode_prop)
> > +		return -ENOMEM;
> > +
> > +	min_prop = drm_property_create_range(plane->dev, 0, "colorkey.min",
> > +					     0, U64_MAX);
> > +	if (!min_prop)
> > +		goto err_destroy_mode_prop;
> > +
> > +	max_prop = drm_property_create_range(plane->dev, 0, "colorkey.max",
> > +					     0, U64_MAX);
> > +	if (!max_prop)
> > +		goto err_destroy_min_prop;
> > +
> > +	drm_object_attach_property(&plane->base, mode_prop, 0);
> > +	drm_object_attach_property(&plane->base, min_prop, 0);
> > +	drm_object_attach_property(&plane->base, max_prop, 0);
> > +
> > +	plane->colorkey.mode_property = mode_prop;
> > +	plane->colorkey.min_property = min_prop;
> > +	plane->colorkey.max_property = max_prop;
> > +
> > +	return 0;
> > +
> > +err_destroy_min_prop:
> > +	drm_property_destroy(plane->dev, min_prop);
> > +err_destroy_mode_prop:
> > +	drm_property_destroy(plane->dev, mode_prop);
> > +
> > +	return -ENOMEM;
> > +}
> > +EXPORT_SYMBOL(drm_plane_create_colorkey_properties);
> > diff --git a/include/drm/drm_blend.h b/include/drm/drm_blend.h
> > index 330c561c4c11..8e80d33b643e 100644
> > --- a/include/drm/drm_blend.h
> > +++ b/include/drm/drm_blend.h
> > @@ -52,4 +52,7 @@ int drm_plane_create_zpos_immutable_property(struct drm_plane *plane,
> >  					     unsigned int zpos);
> >  int drm_atomic_normalize_zpos(struct drm_device *dev,
> >  			      struct drm_atomic_state *state);
> > +
> > +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> > +					 u32 supported_modes);
> >  #endif
> > diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
> > index 26fa50c2a50e..9a621e1ccc47 100644
> > --- a/include/drm/drm_plane.h
> > +++ b/include/drm/drm_plane.h
> > @@ -32,6 +32,48 @@ struct drm_crtc;
> >  struct drm_printer;
> >  struct drm_modeset_acquire_ctx;
> >  
> > +/**
> > + * enum drm_plane_colorkey_mode - uapi plane colorkey mode enumeration
> > + */
> > +enum drm_plane_colorkey_mode {
> > +	/**
> > +	 * @DRM_PLANE_COLORKEY_MODE_DISABLED:
> > +	 *
> > +	 * No color matching performed in this mode.
> > +	 */
> > +	DRM_PLANE_COLORKEY_MODE_DISABLED,
> > +
> > +	/**
> > +	 * @DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP:
> > +	 *
> > +	 * This mode is also known as a "green screen". Plane pixels are
> > +	 * transparent in areas where pixels match a given color key range
> > +	 * and there is a bottom (background) plane, in other cases plane
> > +	 * pixels are unaffected.
> > +	 *
> > +	 */
> > +	DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP,
> Could we add background clip as well?

Also could we just name them "src" and "dst" (or some variation of
those). I'm betting no one has any kind of idea what these proposed
names mean without looking up the docs, whereas pretty much everyone
knows immediately what src/dst colorkeying means.

> 
> Would be nice if we could map i915's legacy ioctl handler to the new color key mode.
> > +	/**
> > +	 * @DRM_PLANE_COLORKEY_MODES_NUM:
> > +	 *
> > +	 * Total number of color keying modes.
> > +	 */
> > +	DRM_PLANE_COLORKEY_MODES_NUM,
> > +};
> > +
> > +/**
> > + * struct drm_plane_colorkey_state - plane color keying state
> > + * @colorkey.mode: color keying mode
> > + * @colorkey.min: color key range minimum (in ARGB16161616 format)
> > + * @colorkey.max: color key range maximum (in ARGB16161616 format)
> > + */
> > +struct drm_plane_colorkey_state {
> > +	enum drm_plane_colorkey_mode mode;
> > +	u64 min;
> > +	u64 max;
> > +};
> Could we have some macros to extract the components for min/max?
> A, R, G, B.

And where did we lose the value+mask?

-- 
Ville Syrjälä
Intel
