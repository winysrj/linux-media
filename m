Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33557 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbeDWH2i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:28:38 -0400
Date: Mon, 23 Apr 2018 09:28:15 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Peter Rosin <peda@axentia.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, daniel@ffwll.ch,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drm: rcar-du: rcar-lvds: Add bridge format support
Message-ID: <20180423072815.GM4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-7-git-send-email-jacopo+renesas@jmondi.org>
 <11e82e23-4ab0-7441-1798-1eeb4fb96995@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hcut4fGOf7Kh6EdG"
Content-Disposition: inline
In-Reply-To: <11e82e23-4ab0-7441-1798-1eeb4fb96995@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Peter,
   thanks for looking into this

On Sun, Apr 22, 2018 at 10:08:21PM +0200, Peter Rosin wrote:
> On 2018-04-19 11:31, Jacopo Mondi wrote:
> > With the introduction of static input image format enumeration in DRM
> > bridges, add support to retrieve the format in rcar-lvds LVDS encoder
> > from both panel or bridge, to set the desired LVDS mode.
> >
> > Do not rely on 'DRM_BUS_FLAG_DATA_LSB_TO_MSB' flag to mirror the LVDS
> > format, as it is only defined for drm connectors, but use the newly
> > introduced _LE version of LVDS mbus image formats.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/gpu/drm/rcar-du/rcar_lvds.c | 64 +++++++++++++++++++++++++------------
> >  1 file changed, 44 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
> > index 3d2d3bb..2fa875f 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
> > @@ -280,41 +280,65 @@ static bool rcar_lvds_mode_fixup(struct drm_bridge *bridge,
> >  	return true;
> >  }
> >
> > -static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
> > +static int rcar_lvds_get_lvds_mode_from_connector(struct rcar_lvds *lvds,
> > +						  unsigned int *bus_fmt)
> >  {
> >  	struct drm_display_info *info = &lvds->connector.display_info;
> > -	enum rcar_lvds_mode mode;
> > -
> > -	/*
> > -	 * There is no API yet to retrieve LVDS mode from a bridge, only panels
> > -	 * are supported.
> > -	 */
> > -	if (!lvds->panel)
> > -		return;
> >
> >  	if (!info->num_bus_formats || !info->bus_formats) {
> >  		dev_err(lvds->dev, "no LVDS bus format reported\n");
> > -		return;
> > +		return -EINVAL;
> > +	}
> > +
> > +	*bus_fmt = info->bus_formats[0];
> > +
> > +	return 0;
> > +}
> > +
> > +static int rcar_lvds_get_lvds_mode_from_bridge(struct rcar_lvds *lvds,
> > +					       unsigned int *bus_fmt)
> > +{
> > +	if (!lvds->next_bridge->num_bus_formats ||
> > +	    !lvds->next_bridge->bus_formats) {
> > +		dev_err(lvds->dev, "no LVDS bus format reported\n");
> > +		return -EINVAL;
> >  	}
> >
> > -	switch (info->bus_formats[0]) {
> > +	*bus_fmt = lvds->next_bridge->bus_formats[0];
>
> What makes the first reported format the best choice?

It already was the selection 'policy' in place in this driver before
introducing bridge formats. As you can see from the switch I have here
removed, the first format was selected even when only the format
reported by the connector was inspected.

And, anyway, as DRM lacks a format negotiation API, there is no way to
tell a bridge/panel "use this format instead of this other one" (which
makes me wonders why more formats can be reported, but the
bus_formats[] helpers for connectors allow that, so I thought it made
sense to do the same for bridges).

>
> > +
> > +	return 0;
> > +}
> > +
> > +static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
> > +{
> > +	unsigned int bus_fmt;
> > +	int ret;
> > +
> > +	if (lvds->panel)
> > +		ret = rcar_lvds_get_lvds_mode_from_connector(lvds, &bus_fmt);
> > +	else
> > +		ret = rcar_lvds_get_lvds_mode_from_bridge(lvds, &bus_fmt);
>
> What if no bridge reports any format, shouldn't the connector be examined
> then?

There is no fallback selection policy at the moment as you can see, or
either, as it was before, the LVDS mode is not set for the rcar_lvds
component  if it's not reported by the next element in the pipeline (and I
should probably return 0, not an error here in that case).

The connector associated with a panel is only inspected if it's next in the
pipeline.

>
> > +	if (ret)
> > +		return;
> > +
> > +	switch (bus_fmt) {
> > +	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE:
> > +	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE:
> > +		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
> >  	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
> >  	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
> > -		mode = RCAR_LVDS_MODE_JEIDA;
> > +		lvds->mode = RCAR_LVDS_MODE_JEIDA;
>
> This is b0rken, first the mirror bit is ORed into some unknown preexisting
> value, then the code falls through (without any fall through comment, btw)
> and forcibly sets the mode, thus discarding the mirror bit which was
> carefully ORed in.

You are correct, the second assignment should have been an |= and not
a plain assignment. The variable is 0ed though, as 'struct rcar_lvds
*lvds' is kzalloc-ed in probe function.
>
> >  		break;
> > +
> > +	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE:
> > +		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
> >  	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
> > -		mode = RCAR_LVDS_MODE_VESA;
> > +		lvds->mode = RCAR_LVDS_MODE_VESA;
>
> Dito.
>
> Cheers,
> Peter
>
> >  		break;
> >  	default:
> >  		dev_err(lvds->dev, "unsupported LVDS bus format 0x%04x\n",
> > -			info->bus_formats[0]);
> > -		return;
> > +			bus_fmt);
> >  	}
> > -
> > -	if (info->bus_flags & DRM_BUS_FLAG_DATA_LSB_TO_MSB)
> > -		mode |= RCAR_LVDS_MODE_MIRROR;
> > -
> > -	lvds->mode = mode;
> >  }
> >
> >  static void rcar_lvds_mode_set(struct drm_bridge *bridge,
> >
>

--hcut4fGOf7Kh6EdG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3YsPAAoJEHI0Bo8WoVY8WKcP/0yHz9QK3VEHvfINxU3ZEBFV
qPt9IUsr2763p7P5DdV/c2Q9VBd0z7uoU8G8B2H2Zveb/yqFd9UbvTbTiAI6Ci2y
T1btH2HWWuXsCEJaxTy8M2vpgi02O6NS5uTgyqCkxkHEn+jgna4KFw+x6LpaaxwW
8H1P0sGagy61NWWLkO3goAw/1DtfuRLLMuH1CHYhHHyLowv8+1DQEAy1uJYHzoMW
RD0iOoFwq7vMFuL3bSgoa4BtkXSxIPPNILKeLcSGhTNvOGA8SFSVIOYyIgCENS9O
znq9ea9OuxG8m6Jd6OWKx2NeuHBAGp/+MA+H86UlfjFnq8uDT0OgrRw7S07AANGl
Q+TTDM4uaXL1kvfDht1EAL445eLAPk7gr0HIvQzd5RLB+ox2RKS1eMakwxEgyQZ0
T22Q+RRK00XHdVFX/0VcjVMDQkiWZQfgK7+Q7B3ek2qWOl3B1lNJ5ihuW8M9gd4i
Y3kP7/uKpG2LI75p6HaownN2qvZtRrgAO+hAtcu/ZOZrPSfugnEf3zxfmomTjaB0
NeVuf/BSCONR89rGhuD2PFUtlOx3oMfWSVjOYHZ0d2HziJD6EGoqJbOGwXvG9CRO
CmwYFJLe9JB28zXA6Ewh2FrkBti2YNET+L/12+GQjkmqNpl0b38Eju7Yeq8GySkF
lUS8JMqfil/eyFZdlgP8
=n57G
-----END PGP SIGNATURE-----

--hcut4fGOf7Kh6EdG--
