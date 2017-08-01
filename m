Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45884 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdHANu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 09:50:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 14/14] drm: rcar-du: Configure DPAD0 routing through last group on Gen3
Date: Tue, 01 Aug 2017 16:51:08 +0300
Message-ID: <6559605.ajX4pK5sJf@avalon>
In-Reply-To: <ec0cd98e-f74c-fb75-ddaa-2a1a3a8193c8@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com> <20170626181226.29575-15-laurent.pinchart+renesas@ideasonboard.com> <ec0cd98e-f74c-fb75-ddaa-2a1a3a8193c8@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tuesday 01 Aug 2017 14:46:13 Kieran Bingham wrote:
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > On Gen3 SoCs DPAD0 routing is configured through the last CRTC group,
> > unlike on Gen2 where it is configured through the first CRTC group. Fix
> > the driver accordingly.
> > 
> > Fixes: 2427b3037710 ("drm: rcar-du: Add R8A7795 device support")
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/gpu/drm/rcar-du/rcar_du_group.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.c
> > b/drivers/gpu/drm/rcar-du/rcar_du_group.c index
> > 64738fca96d0..2abb2fdd143e 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_group.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_group.c
> > @@ -208,23 +208,30 @@ void rcar_du_group_restart(struct rcar_du_group
> > *rgrp)
> >  int rcar_du_set_dpad0_vsp1_routing(struct rcar_du_device *rcdu)
> >  {
> > +	struct rcar_du_group *rgrp;
> > +	struct rcar_du_crtc *crtc;
> >  	int ret;
> >  	
> >  	if (!rcar_du_has(rcdu, RCAR_DU_FEATURE_EXT_CTRL_REGS))
> >  		return 0;
> > 
> > -	/* RGB output routing to DPAD0 and VSP1D routing to DU0/1/2 are
> > -	 * configured in the DEFR8 register of the first group. As this
> > function
> > -	 * can be called with the DU0 and DU1 CRTCs disabled, we need to
> > enable
> > -	 * the first group clock before accessing the register.
> > +	/*
> > +	 * RGB output routing to DPAD0 and VSP1D routing to DU0/1/2 are
> > +	 * configured in the DEFR8 register of the first group on Gen2 and the
> > +	 * last group on Gen3. As this function can be called with the DU
> > +	 * channels of the corresponding CRTCs disabled, we need to enable the
> > +	 * group clock before accessing the register.
> >  	 */
> > 
> > -	ret = clk_prepare_enable(rcdu->crtcs[0].clock);
> > +	rgrp = &rcdu->groups[DIV_ROUND_UP(rcdu->num_crtcs, 2) - 1];
> > +	crtc = &rcdu->crtcs[rgrp->index * 2];
> 
> I'm not certain I understand how this makes a distinct difference between
> G2, and G3.

That's because, well, it doesn't :-)

> Is rcdu->num_crtcs the distinguishing factor between the SoC's?

I'm not sure what I was thinking when I wrote this. I'll send a v3.

> > +
> > +	ret = clk_prepare_enable(crtc->clock);
> >  	if (ret < 0)
> >  		return ret;
> > 
> > -	rcar_du_group_setup_defr8(&rcdu->groups[0]);
> > +	rcar_du_group_setup_defr8(rgrp);
> > 
> > -	clk_disable_unprepare(rcdu->crtcs[0].clock);
> > +	clk_disable_unprepare(crtc->clock);
> > 
> >  	return 0;
> >  }

-- 
Regards,

Laurent Pinchart
