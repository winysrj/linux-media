Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53716 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754905AbeDWM7p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:59:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Peter Rosin <peda@axentia.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drm: rcar-du: rcar-lvds: Add bridge format support
Date: Mon, 23 Apr 2018 15:59:56 +0300
Message-ID: <5001798.Des3fEuz24@avalon>
In-Reply-To: <20180423084728.GD17088@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <9378eadb-1dbf-ecfe-9bd1-40bec21c4648@axentia.se> <20180423084728.GD17088@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, 23 April 2018 11:47:28 EEST jacopo mondi wrote:
> On Mon, Apr 23, 2018 at 09:59:22AM +0200, Peter Rosin wrote:
> > On 2018-04-23 09:28, jacopo mondi wrote:
> >> On Sun, Apr 22, 2018 at 10:08:21PM +0200, Peter Rosin wrote:
> >>> On 2018-04-19 11:31, Jacopo Mondi wrote:
> >>>> With the introduction of static input image format enumeration in DRM
> >>>> bridges, add support to retrieve the format in rcar-lvds LVDS encoder
> >>>> from both panel or bridge, to set the desired LVDS mode.
> >>>> 
> >>>> Do not rely on 'DRM_BUS_FLAG_DATA_LSB_TO_MSB' flag to mirror the LVDS
> >>>> format, as it is only defined for drm connectors, but use the newly
> >>>> introduced _LE version of LVDS mbus image formats.
> >>>> 
> >>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>>> ---
> >>>> 
> >>>>  drivers/gpu/drm/rcar-du/rcar_lvds.c | 64 +++++++++++++++++++---------
> >>>>  1 file changed, 44 insertions(+), 20 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c
> >>>> b/drivers/gpu/drm/rcar-du/rcar_lvds.c index 3d2d3bb..2fa875f 100644
> >>>> --- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
> >>>> +++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
> >>>> @@ -280,41 +280,65 @@ static bool rcar_lvds_mode_fixup(struct
> >>>> drm_bridge *bridge,
> >>>>  	return true;
> >>>>  }
> >>>> 
> >>>> -static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
> >>>> +static int rcar_lvds_get_lvds_mode_from_connector(struct rcar_lvds
> >>>> *lvds,
> >>>> +						  unsigned int *bus_fmt)
> >>>>  {
> >>>>  	struct drm_display_info *info = &lvds->connector.display_info;
> >>>> -	enum rcar_lvds_mode mode;
> >>>> -
> >>>> -	/*
> >>>> -	 * There is no API yet to retrieve LVDS mode from a bridge, only
> >>>> panels
> >>>> -	 * are supported.
> >>>> -	 */
> >>>> -	if (!lvds->panel)
> >>>> -		return;
> >>>> 
> >>>>  	if (!info->num_bus_formats || !info->bus_formats) {
> >>>>  		dev_err(lvds->dev, "no LVDS bus format reported\n");
> >>>> -		return;
> >>>> +		return -EINVAL;
> >>>> +	}
> >>>> +
> >>>> +	*bus_fmt = info->bus_formats[0];
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int rcar_lvds_get_lvds_mode_from_bridge(struct rcar_lvds
> >>>> *lvds,
> >>>> +					       unsigned int *bus_fmt)
> >>>> +{
> >>>> +	if (!lvds->next_bridge->num_bus_formats ||
> >>>> +	    !lvds->next_bridge->bus_formats) {
> >>>> +		dev_err(lvds->dev, "no LVDS bus format reported\n");
> >>>> +		return -EINVAL;
> >>>>  	}
> >>>> 
> >>>> -	switch (info->bus_formats[0]) {
> >>>> +	*bus_fmt = lvds->next_bridge->bus_formats[0];
> >>> 
> >>> What makes the first reported format the best choice?
> >> 
> >> It already was the selection 'policy' in place in this driver before
> >> introducing bridge formats. As you can see from the switch I have here
> >> removed, the first format was selected even when only the format
> >> reported by the connector was inspected.
> > 
> > Well, *if* some bridge/panel do support more than one format, and your
> > driver depends on it being the first reported format, then I can easily
> > see that some other driver also requires its expected format to be first.
> > Then we might end up in a war over what format should be reported as the
> > first so that this multi-input bridge/panel could be used by both drivers.

In that case we would have to implement a format negotiation procedure for 
bridges. It won't work transparently anyway, if a bridge supports multiple 
formats, one will need to be selected, and the bridge hardware will need to be 
configured accordingly.

I don't think this is a problem for now. The bridge we're using reports a 
single format, as it supports a single format at the hardware level. If an 
LVDS decoder accepting multiple formats later needs to be supported I'd be 
happy to participate in the design of a bridge format negotiation procedure 
and API.

> >> And, anyway, as DRM lacks a format negotiation API, there is no way to
> >> tell a bridge/panel "use this format instead of this other one" (which
> >> makes me wonders why more formats can be reported, but the
> >> bus_formats[] helpers for connectors allow that, so I thought it made
> >> sense to do the same for bridges).
> > 
> > Since there is no way to negotiate, I would assume that the other end
> > really does support all reported formats (in some automagical way).

In practice it does, because it supports a single format. Selection is thus 
pretty easy :-)

> > To me, the only sensible approach is to loop over the formats and see if
> > *any* of them fits, and assume that something else<tm> deals with the
> > details.
> 
> I see. I agree looping may be a better way of handling this actually...

I don't think so, for the reasons explained above. If the bridge supports 
multiple incompatible formats we will need to select one of them and configure 
the bridge hardware appropriately. There is no magic autoselection, so looping 
won't help, we will need more than that. Using the first first is thus good 
enough here. Let's not forget that this patch is against the internal LVDS 
encoder driver, so we're guaranteed that the next bridge in the chain accepts 
LVDS. This limits the cases that need to be supported for now.

> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
> >>>> +{
> >>>> +	unsigned int bus_fmt;
> >>>> +	int ret;
> >>>> +
> >>>> +	if (lvds->panel)
> >>>> +		ret = rcar_lvds_get_lvds_mode_from_connector(lvds, &bus_fmt);
> >>>> +	else
> >>>> +		ret = rcar_lvds_get_lvds_mode_from_bridge(lvds, &bus_fmt);
> >>> 
> >>> What if no bridge reports any format, shouldn't the connector be
> >>> examined then?
> >> 
> >> There is no fallback selection policy at the moment as you can see, or
> >> either, as it was before, the LVDS mode is not set for the rcar_lvds
> >> component  if it's not reported by the next element in the pipeline (and
> >> I should probably return 0, not an error here in that case).
> >> 
> >> The connector associated with a panel is only inspected if it's next in
> >> the pipeline.
> > 
> > But by not going to the connector for the case where no bridge in the
> > pipeline has any info on the format, you effectively demand that at
> > least some bridge in the pipeline should report supported input
> > format(s). That excludes a lot of existing bridge combinations from
> > being used. Or do you see it as a requirement that bridges must
> > report their supported input formats? Perhaps only when used with
> > this driver?

We demand that the next component in the chain, bridge or panel, reports the 
LVDS mode it requires through the bus format API. I don't think that's an 
issue, if we later need to use a different bridge that doesn't comply with 
this requirement (is there even other LVDS decoder bridge drivers in mainline 
?) then we'll implement bus format support in that bridge driver. It will not 
break any existing platform.

Looking at the connector won't help as the connector will likely not report an 
LVDS bus format if there's an LVDS decoder bridge in the chain.

However, given that the Lager board currently uses a DT hack and connects the 
DU LVDS output to an HDMI encoder without modeling the on-board LVDS decoder 
in DT, we need to ensure that backward compatibility is preserved by not 
returning a fatal error if the next bridge doesn't report bus formats.

> That's a point that should be discussed imho.
> 
> Daniel in his reply to your original series suggested format should be
> reported by bridges when they get registered [1]. I have not enforced that
> though, as it requires all mainline bridge drivers (which are not that
> many -yet-) to register a format before bridge_add(). If there is
> consensus on this, all other drivers should be updated (I'm not even
> sure it is possible for all of them honestly).

I wouldn't make it mandatory yet, because I'm also not sure if all bridges 
accept a single input format.

> Anyway, the only thing I'm sure is that I don't want to make this
> driver 'special', I would prefer that in case format is not there,
> we'll ignore the LVDS mode configuration as it was before this series.

Yes, that seems the best option to me. You can print a warning message to 
ensure that DT and/or bridge drivers gets updated, but we should default to 
the same LVDS mode as before.

> [1] https://lkml.org/lkml/2018/4/4/50
> 
> >>>> +	if (ret)
> >>>> +		return;
> >>>> +
> >>>> +	switch (bus_fmt) {
> >>>> +	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE:
> >>>> +	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE:
> >>>> +		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
> >>>> 
> >>>>  	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
> >>>> 
> >>>>  	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
> >>>> -		mode = RCAR_LVDS_MODE_JEIDA;
> >>>> +		lvds->mode = RCAR_LVDS_MODE_JEIDA;
> >>> 
> >>> This is b0rken, first the mirror bit is ORed into some unknown
> >>> preexisting value, then the code falls through (without any fall
> >>> through comment, btw) and forcibly sets the mode, thus discarding the
> >>> mirror bit which was carefully ORed in.
> >> 
> >> You are correct, the second assignment should have been an |= and not
> >> a plain assignment. The variable is 0ed though, as 'struct rcar_lvds
> >> *lvds' is kzalloc-ed in probe function.
> > 
> > The code would be clearer if you explicitly zeroed the mode in this
> > function. Or do you rely on this function to not clobber other bits?
> > In that case apply some bit-mask.
> >
> >>>>  		break;
> >>>> +
> >>>> +	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE:
> >>>> +		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
> >>>> 
> >>>>  	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
> >>>> -		mode = RCAR_LVDS_MODE_VESA;
> >>>> +		lvds->mode = RCAR_LVDS_MODE_VESA;
> >>> 
> >>> Dito.
> >>> 
> >>>>  		break;
> >>>>  	
> >>>>  	default:
> >>>>  		dev_err(lvds->dev, "unsupported LVDS bus format 0x%04x\n",
> >>>> -			info->bus_formats[0]);
> >>>> -		return;
> >>>> +			bus_fmt);
> >>>>  	}
> >>>> -
> >>>> -	if (info->bus_flags & DRM_BUS_FLAG_DATA_LSB_TO_MSB)
> >>>> -		mode |= RCAR_LVDS_MODE_MIRROR;
> >>>> -
> >>>> -	lvds->mode = mode;
> >>>>  }
> >>>>  
> >>>>  static void rcar_lvds_mode_set(struct drm_bridge *bridge,

-- 
Regards,

Laurent Pinchart
