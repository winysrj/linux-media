Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35144 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932612AbeGFO6z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 10:58:55 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
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
Subject: Re: [RFC PATCH v3 1/2] drm: Add generic colorkey properties for DRM planes
Date: Fri, 06 Jul 2018 17:58:50 +0300
Message-ID: <2295190.xHWjP7Ltc3@dimapc>
In-Reply-To: <20180706141010.GJ5565@intel.com>
References: <20180603220059.17670-1-digetx@gmail.com> <a2e6e02b-bc6c-a411-0797-99e1bdb6674a@gmail.com> <20180706141010.GJ5565@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, 6 July 2018 17:10:10 MSK Ville Syrj=E4l=E4 wrote:
> On Fri, Jul 06, 2018 at 04:05:21PM +0300, Dmitry Osipenko wrote:
> > On 06.07.2018 15:23, Ville Syrj=E4l=E4 wrote:
> > > On Fri, Jul 06, 2018 at 02:11:44PM +0200, Maarten Lankhorst wrote:
> > >> Hey,
> > >>=20
> > >> Op 04-06-18 om 00:00 schreef Dmitry Osipenko:
> > >>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > >>>=20
> > >>> Color keying is the action of replacing pixels matching a given col=
or
> > >>> (or range of colors) with transparent pixels in an overlay when
> > >>> performing blitting. Depending on the hardware capabilities, the
> > >>> matching pixel can either become fully transparent or gain adjustme=
nt
> > >>> of the pixels component values.
> > >>>=20
> > >>> Color keying is found in a large number of devices whose capabiliti=
es
> > >>> often differ, but they still have enough common features in range to
> > >>> standardize color key properties. This commit adds three generic DRM
> > >>> plane
> > >>> properties related to the color keying, providing initial color key=
ing
> > >>> support.
> > >>>=20
> > >>> Signed-off-by: Laurent Pinchart
> > >>> <laurent.pinchart+renesas@ideasonboard.com>
> > >>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> > >>> ---
> > >>>=20
> > >>>  drivers/gpu/drm/drm_atomic.c | 12 +++++
> > >>>  drivers/gpu/drm/drm_blend.c  | 99
> > >>>  ++++++++++++++++++++++++++++++++++++
> > >>>  include/drm/drm_blend.h      |  3 ++
> > >>>  include/drm/drm_plane.h      | 53 +++++++++++++++++++
> > >>>  4 files changed, 167 insertions(+)
> > >>>=20
> > >>> diff --git a/drivers/gpu/drm/drm_atomic.c
> > >>> b/drivers/gpu/drm/drm_atomic.c
> > >>> index 895741e9cd7d..b322cbed319b 100644
> > >>> --- a/drivers/gpu/drm/drm_atomic.c
> > >>> +++ b/drivers/gpu/drm/drm_atomic.c
> > >>> @@ -799,6 +799,12 @@ static int drm_atomic_plane_set_property(struct
> > >>> drm_plane *plane,> >>>=20
> > >>>  		state->rotation =3D val;
> > >>>  =09
> > >>>  	} else if (property =3D=3D plane->zpos_property) {
> > >>>  =09
> > >>>  		state->zpos =3D val;
> > >>>=20
> > >>> +	} else if (property =3D=3D plane->colorkey.mode_property) {
> > >>> +		state->colorkey.mode =3D val;
> > >>> +	} else if (property =3D=3D plane->colorkey.min_property) {
> > >>> +		state->colorkey.min =3D val;
> > >>> +	} else if (property =3D=3D plane->colorkey.max_property) {
> > >>> +		state->colorkey.max =3D val;
> > >>>=20
> > >>>  	} else if (property =3D=3D plane->color_encoding_property) {
> > >>>  =09
> > >>>  		state->color_encoding =3D val;
> > >>>  =09
> > >>>  	} else if (property =3D=3D plane->color_range_property) {
> > >>>=20
> > >>> @@ -864,6 +870,12 @@ drm_atomic_plane_get_property(struct drm_plane
> > >>> *plane,
> > >>>=20
> > >>>  		*val =3D state->rotation;
> > >>>  =09
> > >>>  	} else if (property =3D=3D plane->zpos_property) {
> > >>>  =09
> > >>>  		*val =3D state->zpos;
> > >>>=20
> > >>> +	} else if (property =3D=3D plane->colorkey.mode_property) {
> > >>> +		*val =3D state->colorkey.mode;
> > >>> +	} else if (property =3D=3D plane->colorkey.min_property) {
> > >>> +		*val =3D state->colorkey.min;
> > >>> +	} else if (property =3D=3D plane->colorkey.max_property) {
> > >>> +		*val =3D state->colorkey.max;
> > >>>=20
> > >>>  	} else if (property =3D=3D plane->color_encoding_property) {
> > >>>  =09
> > >>>  		*val =3D state->color_encoding;
> > >>>  =09
> > >>>  	} else if (property =3D=3D plane->color_range_property) {
> > >>>=20
> > >>> diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blen=
d.c
> > >>> index a16a74d7e15e..12fed2ff65c8 100644
> > >>> --- a/drivers/gpu/drm/drm_blend.c
> > >>> +++ b/drivers/gpu/drm/drm_blend.c
> > >>> @@ -107,6 +107,11 @@
> > >>>=20
> > >>>   *	planes. Without this property the primary plane is always below
> > >>>   the cursor *	plane, and ordering between all other planes is
> > >>>   undefined.
> > >>>   *
> > >>>=20
> > >>> + * colorkey:
> > >>> + *	Color keying is set up with
> > >>> drm_plane_create_colorkey_properties().
> > >>> + *	It adds support for replacing a range of colors with a=20
transparent
> > >>> + *	color in the plane.
> > >>> + *
> > >>>=20
> > >>>   * Note that all the property extensions described here apply eith=
er
> > >>>   to the
> > >>>   * plane or the CRTC (e.g. for the background color, which current=
ly
> > >>>   is not
> > >>>   * exposed and assumed to be black).
> > >>>=20
> > >>> @@ -448,3 +453,97 @@ int drm_atomic_normalize_zpos(struct drm_device
> > >>> *dev,
> > >>>=20
> > >>>  	return 0;
> > >>> =20
> > >>>  }
> > >>>  EXPORT_SYMBOL(drm_atomic_normalize_zpos);
> > >>>=20
> > >>> +
> > >>> +static const char * const plane_colorkey_mode_name[] =3D {
> > >>> +	[DRM_PLANE_COLORKEY_MODE_DISABLED] =3D "disabled",
> > >>> +	[DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP] =3D "foreground-clip",
> > >>> +};
> > >>> +
> > >>> +/**
> > >>> + * drm_plane_create_colorkey_properties - create colorkey properti=
es
> > >>> + * @plane: drm plane
> > >>> + * @supported_modes: bitmask of supported color keying modes
> > >>> + *
> > >>> + * This function creates the generic color keying properties and
> > >>> attach them to + * the plane to enable color keying control for
> > >>> blending operations. + *
> > >>> + * Color keying is controlled by these properties:
> > >>> + *
> > >>> + * colorkey.mode:
> > >>> + *	The mode is an enumerated property that controls how color keyi=
ng
> > >>> + *	operates.
> > >>> + *
> > >>> + * colorkey.min, colorkey.max:
> > >>> + *	These two properties specify the colors that are treated as the
> > >>> color
> > >>> + *	key. Pixel whose value is in the [min, max] range is the color=
=20
key
> > >>> + *	matching pixel. The minimum and maximum values are expressed as=
 a
> > >>> + *	64-bit integer in ARGB16161616 format, where A is the alpha val=
ue
> > >>> and
> > >>> + *	R, G and B correspond to the color components. Drivers shall
> > >>> convert
> > >>> + *	ARGB16161616 value into appropriate format within planes atomic
> > >>> check.
> > >>> + *
> > >>> + *	When a single color key is desired instead of a range, userspace
> > >>> shall
> > >>> + *	set the min and max properties to the same value.
> > >>> + *
> > >>> + *	Drivers return an error from their plane atomic check if range
> > >>> can't be
> > >>> + *	handled.
> > >>> + *
> > >>> + * Returns:
> > >>> + * Zero on success, negative errno on failure.
> > >>> + */
> > >>> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> > >>> +					 u32 supported_modes)
> > >>> +{
> > >>> +	struct drm_prop_enum_list=20
modes_list[DRM_PLANE_COLORKEY_MODES_NUM];
> > >>> +	struct drm_property *mode_prop;
> > >>> +	struct drm_property *min_prop;
> > >>> +	struct drm_property *max_prop;
> > >>> +	unsigned int modes_num =3D 0;
> > >>> +	unsigned int i;
> > >>> +
> > >>> +	/* modes are driver-specific, build the list of supported modes=20
*/
> > >>> +	for (i =3D 0; i < DRM_PLANE_COLORKEY_MODES_NUM; i++) {
> > >>> +		if (!(supported_modes & BIT(i)))
> > >>> +			continue;
> > >>> +
> > >>> +		modes_list[modes_num].name =3D plane_colorkey_mode_name[i];
> > >>> +		modes_list[modes_num].type =3D i;
> > >>> +		modes_num++;
> > >>> +	}
> > >>> +
> > >>> +	/* at least one mode should be supported */
> > >>> +	if (!modes_num)
> > >>> +		return -EINVAL;
> > >>> +
> > >>> +	mode_prop =3D drm_property_create_enum(plane->dev, 0,=20
"colorkey.mode",
> > >>> +					     modes_list, modes_num);
> > >>> +	if (!mode_prop)
> > >>> +		return -ENOMEM;
> > >>> +
> > >>> +	min_prop =3D drm_property_create_range(plane->dev, 0,=20
"colorkey.min",
> > >>> +					     0, U64_MAX);
> > >>> +	if (!min_prop)
> > >>> +		goto err_destroy_mode_prop;
> > >>> +
> > >>> +	max_prop =3D drm_property_create_range(plane->dev, 0,=20
"colorkey.max",
> > >>> +					     0, U64_MAX);
> > >>> +	if (!max_prop)
> > >>> +		goto err_destroy_min_prop;
> > >>> +
> > >>> +	drm_object_attach_property(&plane->base, mode_prop, 0);
> > >>> +	drm_object_attach_property(&plane->base, min_prop, 0);
> > >>> +	drm_object_attach_property(&plane->base, max_prop, 0);
> > >>> +
> > >>> +	plane->colorkey.mode_property =3D mode_prop;
> > >>> +	plane->colorkey.min_property =3D min_prop;
> > >>> +	plane->colorkey.max_property =3D max_prop;
> > >>> +
> > >>> +	return 0;
> > >>> +
> > >>> +err_destroy_min_prop:
> > >>> +	drm_property_destroy(plane->dev, min_prop);
> > >>> +err_destroy_mode_prop:
> > >>> +	drm_property_destroy(plane->dev, mode_prop);
> > >>> +
> > >>> +	return -ENOMEM;
> > >>> +}
> > >>> +EXPORT_SYMBOL(drm_plane_create_colorkey_properties);
> > >>> diff --git a/include/drm/drm_blend.h b/include/drm/drm_blend.h
> > >>> index 330c561c4c11..8e80d33b643e 100644
> > >>> --- a/include/drm/drm_blend.h
> > >>> +++ b/include/drm/drm_blend.h
> > >>> @@ -52,4 +52,7 @@ int drm_plane_create_zpos_immutable_property(stru=
ct
> > >>> drm_plane *plane,> >>>=20
> > >>>  					     unsigned int zpos);
> > >>> =20
> > >>>  int drm_atomic_normalize_zpos(struct drm_device *dev,
> > >>> =20
> > >>>  			      struct drm_atomic_state *state);
> > >>>=20
> > >>> +
> > >>> +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> > >>> +					 u32 supported_modes);
> > >>>=20
> > >>>  #endif
> > >>>=20
> > >>> diff --git a/include/drm/drm_plane.h b/include/drm/drm_plane.h
> > >>> index 26fa50c2a50e..9a621e1ccc47 100644
> > >>> --- a/include/drm/drm_plane.h
> > >>> +++ b/include/drm/drm_plane.h
> > >>> @@ -32,6 +32,48 @@ struct drm_crtc;
> > >>>=20
> > >>>  struct drm_printer;
> > >>>  struct drm_modeset_acquire_ctx;
> > >>>=20
> > >>> +/**
> > >>> + * enum drm_plane_colorkey_mode - uapi plane colorkey mode
> > >>> enumeration
> > >>> + */
> > >>> +enum drm_plane_colorkey_mode {
> > >>> +	/**
> > >>> +	 * @DRM_PLANE_COLORKEY_MODE_DISABLED:
> > >>> +	 *
> > >>> +	 * No color matching performed in this mode.
> > >>> +	 */
> > >>> +	DRM_PLANE_COLORKEY_MODE_DISABLED,
> > >>> +
> > >>> +	/**
> > >>> +	 * @DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP:
> > >>> +	 *
> > >>> +	 * This mode is also known as a "green screen". Plane pixels are
> > >>> +	 * transparent in areas where pixels match a given color key=20
range
> > >>> +	 * and there is a bottom (background) plane, in other cases plane
> > >>> +	 * pixels are unaffected.
> > >>> +	 *
> > >>> +	 */
> > >>> +	DRM_PLANE_COLORKEY_MODE_FOREGROUND_CLIP,
> > >>=20
> > >> Could we add background clip as well?
> >=20
> > Sure, but I think adding a new mode should be a distinct change made on
> > top of the initial series.
> >=20
> > > Also could we just name them "src" and "dst" (or some variation of
> > > those). I'm betting no one has any kind of idea what these proposed
> > > names mean without looking up the docs, whereas pretty much everyone
> > > knows immediately what src/dst colorkeying means.
> >=20
> > Okay, I'll rename the mode to DRM_PLANE_COLORKEY_MODE_SRC in the next
> > revision.>=20
> > >> Would be nice if we could map i915's legacy ioctl handler to the new
> > >> color key mode.> >>=20
> > >>> +	/**
> > >>> +	 * @DRM_PLANE_COLORKEY_MODES_NUM:
> > >>> +	 *
> > >>> +	 * Total number of color keying modes.
> > >>> +	 */
> > >>> +	DRM_PLANE_COLORKEY_MODES_NUM,
> > >>> +};
> > >>> +
> > >>> +/**
> > >>> + * struct drm_plane_colorkey_state - plane color keying state
> > >>> + * @colorkey.mode: color keying mode
> > >>> + * @colorkey.min: color key range minimum (in ARGB16161616 format)
> > >>> + * @colorkey.max: color key range maximum (in ARGB16161616 format)
> > >>> + */
> > >>> +struct drm_plane_colorkey_state {
> > >>> +	enum drm_plane_colorkey_mode mode;
> > >>> +	u64 min;
> > >>> +	u64 max;
> > >>> +};
> > >>=20
> > >> Could we have some macros to extract the components for min/max?
> > >> A, R, G, B.
> >=20
> > I'll add the macros in the next revision.
> >=20
> > > And where did we lose the value+mask?
> >=20
> > There is no use for the mask on Tegra. I'd prefer to keep initial patch=
es
> > simple and minimal, other modes and additional properties could be added
> > in the further patches on by as-needed basis. Mask could be added later
> > with the default value of 0xffffffffffffffff. Does it sound good for yo=
u?
>=20
> IIRC my earlier idea was to have different colorkey modes for the
> min+max and value+mask modes. That way userspace might actually have
> some chance of figuring out which bits of state actually do something.
> Although for Intel hw I think the general rule is that min+max for YUV,
> value+mask for RGB, so it's still not 100% clear what to pick if the
> plane supports both.
>=20
> I guess one alternative would be to have min+max only, and the driver
> would reject 'min !=3D max' if it only uses a single value?
>=20

You should pick both and reject unsupported property values based on the=20
planes framebuffer format. So it will be possible to set unsupported values=
=20
while plane is disabled because it doesn't have an associated framebuffer a=
nd=20
then atomic check will fail to enable plane if property values are invalid =
for=20
the given format.

> And maybe we should have the mask always? IIRC Intel hw generally has a
> one bit enable/disable "mask" per channel in the min+max mode (I think
> there's one exception where it has only a 1 bit mask in the value+mask
> mode as well). So we could accept 0 and 0xffff mask values in this case
> and reject everything else.

Sounds good to me. Actually there is a place for the mask on Tegra, older=20
generation doesn't support matching of the alpha channel and the alpha chan=
nel=20
matching is simply ignored, so colorkeying could be support for the=20
framebuffer formats that have an alpha channel if the alpha channel matchin=
g=20
is disabled by the mask value.

> The alternative might be to enable the
> keying for the channel if 'min <=3D max' and disable it if 'min > max'.
> But not sure if that's slightly too magicy.

The mask property should suit well your case, I don't think there is any ne=
ed=20
for the magic.
