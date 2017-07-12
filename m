Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33940 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbdGLMNJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 08:13:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] drm: rcar-du: Fix planes to CRTC assignment when using the VSP
Date: Wed, 12 Jul 2017 15:13:09 +0300
Message-ID: <9618964.U0u9UE4uZN@avalon>
In-Reply-To: <23b0037c-defe-4e95-771b-ad99b86d5c26@ideasonboard.com>
References: <20170711222942.27735-1-laurent.pinchart+renesas@ideasonboard.com> <20170711222942.27735-3-laurent.pinchart+renesas@ideasonboard.com> <23b0037c-defe-4e95-771b-ad99b86d5c26@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday 12 Jul 2017 11:30:19 Kieran Bingham wrote:
> On 11/07/17 23:29, Laurent Pinchart wrote:
> > The DU can compose the output of a VSP with other planes on Gen2
> > hardware, and of two VSPs on Gen3 hardware. Neither of these features
> > are supported by the driver, and the current implementation always
> > assigns planes to CRTCs the same way.
> > 
> > Simplify the implementation by configuring plane assignment when setting
> > up DU groups, instead of recomputing it for every atomic plane update.
> > This allows skipping the wait for vertical blanking when stopping a
> > CRTC, as there's no need to reconfigure plane assignment at that point.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.c  | 31 ++++++++++++++-------------
> >  drivers/gpu/drm/rcar-du/rcar_du_group.c | 12 ++++++++++++
> >  drivers/gpu/drm/rcar-du/rcar_du_kms.c   | 28 +++++++++++++++++-----------
> >  drivers/gpu/drm/rcar-du/rcar_du_plane.c | 10 +---------
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |  9 ---------
> >  5 files changed, 46 insertions(+), 44 deletions(-)

[snip]

> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.c
> > b/drivers/gpu/drm/rcar-du/rcar_du_group.c index
> > 00d5f470d377..d26b647207b8 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_group.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_group.c
> > @@ -126,6 +126,18 @@ static void rcar_du_group_setup(struct rcar_du_group
> > *rgrp)> 
> >  	if (rcdu->info->gen >= 3)
> >  		rcar_du_group_write(rgrp, DEFR10, DEFR10_CODE | 
DEFR10_DEFE10);
> > 
> > +	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> > +		/*
> > +		 * The CRTCs can compose the output of a VSP with other planes
> > +		 * on Gen2 hardware, and of two VSPs on Gen3 hardware. Neither
> > +		 * of these features are supported by the driver, so we 
hardcode
> > +		 * plane assignment to CRTCs when setting the group up to 
avoid
> > +		 * the need to restart then group when setting planes up.
> 
> Minor nits in comment:
> 
>   /restart then group/restart the group/
> 
> I would also possibly swap the final 'planes up' as 'up planes' if you
> update here anyway:
> 
> * so we hardcode plane assignment to CRTCs when setting the group up to
> avoid
> * the need to restart the group when setting up planes.
> 
> Up to you of course :)

Thanks, I've fixed both, and also replaced "setting the group up" with 
"setting up the group".

> > +		 */
> > +		rcar_du_group_write(rgrp, DS1PR, 1);
> > +		rcar_du_group_write(rgrp, DS2PR, rcdu->info->gen >= 3 ? 3 : 
2);
> 
> whew ... that DS2PR indexing change from g2 to g3 looks annoying ... I had
> to write out the logic tables on paper to verify the change here from the
> previous code.

That's also how I wrote the code :-)

> > +	}
> > +
> > 
> >  	/*
> >  	
> >  	 * Use DS1PR and DS2PR to configure planes priorities and connects the
> >  	 * superposition 0 to DU0 pins. DU1 pins will be configured 
dynamically.

-- 
Regards,

Laurent Pinchart
