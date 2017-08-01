Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46445 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbdHATBl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 15:01:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 12/14] drm: rcar-du: Support multiple sources from the same VSP
Date: Tue, 01 Aug 2017 22:01:53 +0300
Message-ID: <1792412.y3GJ2ps3ge@avalon>
In-Reply-To: <2ff1d13c-cdf9-3e65-d24d-72b9deb3d3cb@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com> <20170626181226.29575-13-laurent.pinchart+renesas@ideasonboard.com> <2ff1d13c-cdf9-3e65-d24d-72b9deb3d3cb@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tuesday 01 Aug 2017 19:10:20 Kieran Bingham wrote:
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > On R-Car H3 ES2.0, DU channels 0 and 3 are served by two separate
> > pipelines from the same VSP. Support this in the DU driver.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> This looks good to me.
> 
> Minor nit / comment can be safely ignored. Mostly just me thinking outload.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  2 +-
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  3 ++
> >  drivers/gpu/drm/rcar-du/rcar_du_kms.c  | 91 +++++++++++++++++++++++++----
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 37 +++++++-------
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.h  | 10 +++-
> >  5 files changed, 110 insertions(+), 33 deletions(-)

[snip]

> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> > b/drivers/gpu/drm/rcar-du/rcar_du_kms.c index f4125c8ca902..82b978a5dae6
> > 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> > @@ -432,6 +432,83 @@ static int rcar_du_properties_init(struct
> > rcar_du_device *rcdu)
> >  	return 0;
> >  }
> > 
> > +static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
> > +{
> > +	const struct device_node *np = rcdu->dev->of_node;
> > +	struct of_phandle_args args;
> > +	struct {
> > +		struct device_node *np;
> > +		unsigned int crtcs_mask;
> > +	} vsps[RCAR_DU_MAX_VSPS] = { { 0, }, };
> > +	unsigned int vsps_count = 0;
> > +	unsigned int cells;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	/*
> > +	 * First parse the DT vsps property to populate the list of VSPs. Each
> > +	 * entry contains a pointer to the VSP DT node and a bitmask of the
> > +	 * connected DU CRTCs.
> > +	 */
> > +	cells = of_property_count_u32_elems(np, "vsps") / rcdu->num_crtcs - 1;
> > +	if (cells > 1)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < rcdu->num_crtcs; ++i) {
> > +		unsigned int j;
> > +
> > +		ret = of_parse_phandle_with_fixed_args(np, "vsps", cells, i,
> > +						       &args);
> > +		if (ret < 0)
> > +			goto error;
> > +
> > +		/*
> > +		 * Add the VSP to the list or update the corresponding
> > existing
> > +		 * entry if the VSP has already been added.
> > +		 */
> > +		for (j = 0; j < vsps_count; ++j) {
> > +			if (vsps[j].np == args.np)
> > +				break;
> > +		}
> > +
> > +		if (j < vsps_count)
> > +			of_node_put(args.np);
> > +		else
> > +			vsps[vsps_count++].np = args.np;
> > +
> > +		vsps[j].crtcs_mask |= 1 << i;
> 
> I do love the BIT(x) macro personally - but it's not important :)

I wonder why I don't like the BIT macro. There's probably no good reason.

> > +
> > +		/* Store the VSP pointer and pipe index in the CRTC. */
> > +		rcdu->crtcs[i].vsp = &rcdu->vsps[j];
> > +		rcdu->crtcs[i].vsp_pipe = cells >= 1 ? args.args[0] : 0;
> > +	}
> > +
> > +	/*
> > +	 * Then initialize all the VSPs from the node pointers and CRTCs
> > bitmask
> > +	 * computed previously.
> > +	 */
> > +	for (i = 0; i < vsps_count; ++i) {
> > +		struct rcar_du_vsp *vsp = &rcdu->vsps[i];
> > +
> > +		vsp->index = i;
> > +		vsp->dev = rcdu;
> > +
> > +		ret = rcar_du_vsp_init(vsp, vsps[i].np, vsps[i].crtcs_mask);
> > +		if (ret < 0)
> > +			goto error;
> > +	}
> > +
> > +	return 0;
> > +
> > +error:
> > +	for (i = 0; i < ARRAY_SIZE(vsps); ++i) {
> > +		if (vsps[i].np)
> 
> Minor nit: of_node_put already has NULL protection so we don't need this
> 'if' but it probably does make it clearer that we are only putting back
> nodes that we collected.

It's a good point, I'll remove the check.

> > +			of_node_put(vsps[i].np);
> > +	}
> > +
> > +	return ret;
> > +}

[snip]

-- 
Regards,

Laurent Pinchart
