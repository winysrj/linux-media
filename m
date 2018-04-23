Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53073 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753005AbeDWIrf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 04:47:35 -0400
Date: Mon, 23 Apr 2018 10:47:28 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Peter Rosin <peda@axentia.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, daniel@ffwll.ch,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drm: rcar-du: rcar-lvds: Add bridge format support
Message-ID: <20180423084728.GD17088@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-7-git-send-email-jacopo+renesas@jmondi.org>
 <11e82e23-4ab0-7441-1798-1eeb4fb96995@axentia.se>
 <20180423072815.GM4235@w540>
 <9378eadb-1dbf-ecfe-9bd1-40bec21c4648@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Content-Disposition: inline
In-Reply-To: <9378eadb-1dbf-ecfe-9bd1-40bec21c4648@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Peter,

On Mon, Apr 23, 2018 at 09:59:22AM +0200, Peter Rosin wrote:
> On 2018-04-23 09:28, jacopo mondi wrote:
> > Hi Peter,
> >    thanks for looking into this
> >
> > On Sun, Apr 22, 2018 at 10:08:21PM +0200, Peter Rosin wrote:
> >> On 2018-04-19 11:31, Jacopo Mondi wrote:
> >>> With the introduction of static input image format enumeration in DRM
> >>> bridges, add support to retrieve the format in rcar-lvds LVDS encoder
> >>> from both panel or bridge, to set the desired LVDS mode.
> >>>
> >>> Do not rely on 'DRM_BUS_FLAG_DATA_LSB_TO_MSB' flag to mirror the LVDS
> >>> format, as it is only defined for drm connectors, but use the newly
> >>> introduced _LE version of LVDS mbus image formats.
> >>>
> >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>> ---
> >>>  drivers/gpu/drm/rcar-du/rcar_lvds.c | 64 +++++++++++++++++++++++++------------
> >>>  1 file changed, 44 insertions(+), 20 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
> >>> index 3d2d3bb..2fa875f 100644
> >>> --- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
> >>> +++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
> >>> @@ -280,41 +280,65 @@ static bool rcar_lvds_mode_fixup(struct drm_bridge *bridge,
> >>>  	return true;
> >>>  }
> >>>
> >>> -static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
> >>> +static int rcar_lvds_get_lvds_mode_from_connector(struct rcar_lvds *lvds,
> >>> +						  unsigned int *bus_fmt)
> >>>  {
> >>>  	struct drm_display_info *info = &lvds->connector.display_info;
> >>> -	enum rcar_lvds_mode mode;
> >>> -
> >>> -	/*
> >>> -	 * There is no API yet to retrieve LVDS mode from a bridge, only panels
> >>> -	 * are supported.
> >>> -	 */
> >>> -	if (!lvds->panel)
> >>> -		return;
> >>>
> >>>  	if (!info->num_bus_formats || !info->bus_formats) {
> >>>  		dev_err(lvds->dev, "no LVDS bus format reported\n");
> >>> -		return;
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	*bus_fmt = info->bus_formats[0];
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int rcar_lvds_get_lvds_mode_from_bridge(struct rcar_lvds *lvds,
> >>> +					       unsigned int *bus_fmt)
> >>> +{
> >>> +	if (!lvds->next_bridge->num_bus_formats ||
> >>> +	    !lvds->next_bridge->bus_formats) {
> >>> +		dev_err(lvds->dev, "no LVDS bus format reported\n");
> >>> +		return -EINVAL;
> >>>  	}
> >>>
> >>> -	switch (info->bus_formats[0]) {
> >>> +	*bus_fmt = lvds->next_bridge->bus_formats[0];
> >>
> >> What makes the first reported format the best choice?
> >
> > It already was the selection 'policy' in place in this driver before
> > introducing bridge formats. As you can see from the switch I have here
> > removed, the first format was selected even when only the format
> > reported by the connector was inspected.
>
> Well, *if* some bridge/panel do support more than one format, and your
> driver depends on it being the first reported format, then I can easily
> see that some other driver also requires its expected format to be first.
> Then we might end up in a war over what format should be reported as the
> first so that this multi-input bridge/panel could be used by both drivers.
>
> > And, anyway, as DRM lacks a format negotiation API, there is no way to
> > tell a bridge/panel "use this format instead of this other one" (which
> > makes me wonders why more formats can be reported, but the
> > bus_formats[] helpers for connectors allow that, so I thought it made
> > sense to do the same for bridges).
>
> Since there is no way to negotiate, I would assume that the other end
> really does support all reported formats (in some automagical way). To
> me, the only sensible approach is to loop over the formats and see if
> *any* of them fits, and assume that something else<tm> deals with the
> details.
>

I see. I agree looping may be a better way of handling this
actually...

> >>
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
> >>> +{
> >>> +	unsigned int bus_fmt;
> >>> +	int ret;
> >>> +
> >>> +	if (lvds->panel)
> >>> +		ret = rcar_lvds_get_lvds_mode_from_connector(lvds, &bus_fmt);
> >>> +	else
> >>> +		ret = rcar_lvds_get_lvds_mode_from_bridge(lvds, &bus_fmt);
> >>
> >> What if no bridge reports any format, shouldn't the connector be examined
> >> then?
> >
> > There is no fallback selection policy at the moment as you can see, or
> > either, as it was before, the LVDS mode is not set for the rcar_lvds
> > component  if it's not reported by the next element in the pipeline (and I
> > should probably return 0, not an error here in that case).
> >
> > The connector associated with a panel is only inspected if it's next in the
> > pipeline.
>
> But by not going to the connector for the case where no bridge in the
> pipeline has any info on the format, you effectively demand that at
> least some bridge in the pipeline should report supported input
> format(s). That excludes a lot of existing bridge combinations from
> being used. Or do you see it as a requirement that bridges must
> report their supported input formats? Perhaps only when used with
> this driver?

That's a point that should be discussed imho.

Daniel in his reply to your original series suggested format should be
reported by bridges when they get registered [1]. I have not enforced that
though, as it requires all mainline bridge drivers (which are not that
many -yet-) to register a format before bridge_add(). If there is
consensus on this, all other drivers should be updated (I'm not even
sure it is possible for all of them honestly).

Anyway, the only thing I'm sure is that I don't want to make this
driver 'special', I would prefer that in case format is not there,
we'll ignore the LVDS mode configuration as it was before this series.

Thanks
  j


[1] https://lkml.org/lkml/2018/4/4/50
>
> >>
> >>> +	if (ret)
> >>> +		return;
> >>> +
> >>> +	switch (bus_fmt) {
> >>> +	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE:
> >>> +	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE:
> >>> +		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
> >>>  	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
> >>>  	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
> >>> -		mode = RCAR_LVDS_MODE_JEIDA;
> >>> +		lvds->mode = RCAR_LVDS_MODE_JEIDA;
> >>
> >> This is b0rken, first the mirror bit is ORed into some unknown preexisting
> >> value, then the code falls through (without any fall through comment, btw)
> >> and forcibly sets the mode, thus discarding the mirror bit which was
> >> carefully ORed in.
> >
> > You are correct, the second assignment should have been an |= and not
> > a plain assignment. The variable is 0ed though, as 'struct rcar_lvds
> > *lvds' is kzalloc-ed in probe function.
>
> The code would be clearer if you explicitly zeroed the mode in this
> function. Or do you rely on this function to not clobber other bits?
> In that case apply some bit-mask.
>
> Cheers,
> Peter
>
> >>
> >>>  		break;
> >>> +
> >>> +	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE:
> >>> +		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
> >>>  	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
> >>> -		mode = RCAR_LVDS_MODE_VESA;
> >>> +		lvds->mode = RCAR_LVDS_MODE_VESA;
> >>
> >> Dito.
> >>
> >> Cheers,
> >> Peter
> >>
> >>>  		break;
> >>>  	default:
> >>>  		dev_err(lvds->dev, "unsupported LVDS bus format 0x%04x\n",
> >>> -			info->bus_formats[0]);
> >>> -		return;
> >>> +			bus_fmt);
> >>>  	}
> >>> -
> >>> -	if (info->bus_flags & DRM_BUS_FLAG_DATA_LSB_TO_MSB)
> >>> -		mode |= RCAR_LVDS_MODE_MIRROR;
> >>> -
> >>> -	lvds->mode = mode;
> >>>  }
> >>>
> >>>  static void rcar_lvds_mode_set(struct drm_bridge *bridge,
> >>>
> >>
>

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3Z2gAAoJEHI0Bo8WoVY8MuYP+gMezpvf1adDHCGnFQaQd2Dk
laYgxs47ugWDTLErx3Cn3w6L4YnloQbpqlwkVTvP1dTCaTINJVy2P4zbkbC2IbGp
Vs0drtXzcYk9dumuIAhx3eIXVG8G3PX+5HQWcqGTD37E4AkgqVigi2SYHwM+ZO7m
LsRx5wii3c1ukp5766EoAZEwGwAvt1GK5mraimn8mzgd1ndKQRm/kYGQQL2GnYzU
Sn6I6EVKGnWxIvWFgTAsT0yLIJt4ubfNR8t01DE1d2A9J6dQtwfFUk7hBeEkvn4c
Bnoc1L6cIYaLAX4+gG7t+FyCpF5s4e5/1rbEvYVqHJ/IpyHOPP7HL+LWB2ra0GQk
gj3bzwLoGmVDvHOaC4DEY8xVcaAvY8f7hrBjJkGC6o4ZccztsE0zrwNjgUbvjxHD
87VvhYhzAVtiLfJHf4VAwv0jUIqJszRYK0nKwsrMboZkd5BSgC5tdlTBsMB9yj4r
vc7XU3fRVDBB9iMi/zLq5Cb7FKVC5GQmB6/kBs0CcMC/jTZpJPd7CeHgi33i8H+w
t7v+GP6n38cViFJDLlCxlU/uuB7/s2q69L1g0693HUvl5fWJdr4cwQ0IvAbDq8F0
LDlY1mw4/7qHRdxPu9aqXs1wLQ9KBIZEfJOqLDyWnf2A9vXK8tBw72zOtvmwZ9Ml
9bYyqyS6WaQIQPMsZrdm
=fSTS
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
