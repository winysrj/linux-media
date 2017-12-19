Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39345 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdLSNOT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 08:14:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC 1/4] drm: Add colorkey properties
Date: Tue, 19 Dec 2017 15:14:29 +0200
Message-ID: <6363445.9viBvkM8do@avalon>
In-Reply-To: <774a29ec-fd51-7bc5-bcbb-ce0d49a76aa8@baylibre.com>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com> <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com> <774a29ec-fd51-7bc5-bcbb-ce0d49a76aa8@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

On Tuesday, 19 December 2017 11:00:28 EET Neil Armstrong wrote:
> On 17/12/2017 01:17, Laurent Pinchart wrote:
> > Color keying is the action of replacing pixels matching a given color
> > (or range of colors) with transparent pixels in an overlay when
> > performing blitting. Depending on the hardware capabilities, the
> > matching pixel can either become fully transparent, or gain a
> > programmable alpha value.
> > 
> > Color keying is found in a large number of devices whose capabilities
> > often differ, but they still have enough common features in range to
> > standardize color key properties. This commit adds four properties
> > related to color keying named colorkey.min, colorkey.max, colorkey.alpha
> > and colorkey.mode. Additional properties can be defined by drivers to
> > expose device-specific features.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/gpu/drm/drm_atomic.c |  16 +++++++
> >  drivers/gpu/drm/drm_blend.c  | 108 ++++++++++++++++++++++++++++++++++++++
> >  include/drm/drm_blend.h      |   4 ++
> >  include/drm/drm_plane.h      |  28 ++++++++++-
> >  4 files changed, 155 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> > index 37445d50816a..4f57ec25e04d 100644
> > --- a/drivers/gpu/drm/drm_atomic.c
> > +++ b/drivers/gpu/drm/drm_atomic.c
> > @@ -756,6 +756,14 @@ static int drm_atomic_plane_set_property(struct

[snip]

> > +int drm_plane_create_colorkey_properties(struct drm_plane *plane,
> > +					 const struct drm_prop_enum_list *modes,
> > +					 unsigned int num_modes, bool replace)
> > +{
> > +#define CREATE_COLORKEY_PROP(plane, name, type, args...) ({		       \
> > +	prop = drm_property_create_##type(plane->dev, 0, "colorkey." #name,    
\
> > +					  args);			       \
> > +	if (prop) {							       \
> > +		drm_object_attach_property(&plane->base, prop, 0);	       \
> > +		plane->colorkey.name##_property = prop;			       \
> > +	}								       \
> > +	prop;								       \
> > +})
> > +
> > +	struct drm_property *prop;
> > +
> > +	/*
> > +	 * A minimum of two modes are required, with the first mode must named
> > +	 * "disabled".
> > +	 */
> > +	if (!modes || num_modes == 0 || strcmp(modes[0].name, "disabled"))
> > +		return -EINVAL;
> > +
> > +	prop = CREATE_COLORKEY_PROP(plane, mode, enum, modes, num_modes);
> > +	if (!prop)
> > +		return -ENOMEM;
> > +
> > +	prop = CREATE_COLORKEY_PROP(plane, min, range, 0, U64_MAX);
> > +	if (!prop)
> > +		return -ENOMEM;
> > +
> > +	prop = CREATE_COLORKEY_PROP(plane, max, range, 0, U64_MAX);
> > +	if (!prop)
> > +		return -ENOMEM;
> > +
> > +	if (replace) {
> > +		prop = CREATE_COLORKEY_PROP(plane, value, range, 0, U64_MAX);
> > +		if (!prop)
> > +			return -ENOMEM;
> > +	}
> 
> #undef CREATE_COLORKEY_PROP ?

That's a good idea, I'll fix it in the next version.

> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(drm_plane_create_colorkey_properties);

[snip]

> Apart from that,
> 
> Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>

-- 
Regards,

Laurent Pinchart
