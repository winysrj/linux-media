Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33659 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbdGLKac (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 06:30:32 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2 2/3] drm: rcar-du: Fix planes to CRTC assignment when
 using the VSP
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20170711222942.27735-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170711222942.27735-3-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <23b0037c-defe-4e95-771b-ad99b86d5c26@ideasonboard.com>
Date: Wed, 12 Jul 2017 11:30:19 +0100
MIME-Version: 1.0
In-Reply-To: <20170711222942.27735-3-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch

Only a minor nit on one comment, but aside from that,

On 11/07/17 23:29, Laurent Pinchart wrote:
> The DU can compose the output of a VSP with other planes on Gen2
> hardware, and of two VSPs on Gen3 hardware. Neither of these features
> are supported by the driver, and the current implementation always
> assigns planes to CRTCs the same way.
> 
> Simplify the implementation by configuring plane assignment when setting
> up DU groups, instead of recomputing it for every atomic plane update.
> This allows skipping the wait for vertical blanking when stopping a
> CRTC, as there's no need to reconfigure plane assignment at that point.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c  | 31 ++++++++++++++++---------------
>  drivers/gpu/drm/rcar-du/rcar_du_group.c | 12 ++++++++++++
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c   | 28 +++++++++++++++++-----------
>  drivers/gpu/drm/rcar-du/rcar_du_plane.c | 10 +---------
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |  9 ---------
>  5 files changed, 46 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> index 17fd1cd5212c..413ab032afed 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -315,6 +315,10 @@ static void rcar_du_crtc_update_planes(struct rcar_du_crtc *rcrtc)
>  	unsigned int i;
>  	u32 dspr = 0;
>  
> +	/* Plane assignment is fixed when using the VSP. */
> +	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE))
> +		return;
> +
>  	for (i = 0; i < rcrtc->group->num_planes; ++i) {
>  		struct rcar_du_plane *plane = &rcrtc->group->planes[i];
>  		unsigned int j;
> @@ -351,17 +355,6 @@ static void rcar_du_crtc_update_planes(struct rcar_du_crtc *rcrtc)
>  		}
>  	}
>  
> -	/* If VSP+DU integration is enabled the plane assignment is fixed. */
> -	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> -		if (rcdu->info->gen < 3) {
> -			dspr = (rcrtc->index % 2) + 1;
> -			hwplanes = 1 << (rcrtc->index % 2);
> -		} else {
> -			dspr = (rcrtc->index % 2) ? 3 : 1;
> -			hwplanes = 1 << ((rcrtc->index % 2) ? 2 : 0);
> -		}
> -	}
> -
>  	/*
>  	 * Update the planes to display timing and dot clock generator
>  	 * associations.
> @@ -462,8 +455,13 @@ static void rcar_du_crtc_setup(struct rcar_du_crtc *rcrtc)
>  	rcar_du_crtc_set_display_timing(rcrtc);
>  	rcar_du_group_set_routing(rcrtc->group);
>  
> -	/* Start with all planes disabled. */
> -	rcar_du_group_write(rcrtc->group, rcrtc->index % 2 ? DS2PR : DS1PR, 0);
> +	/*
> +	 * Start with all planes disabled, except when using the VSP in which
> +	 * case the fixed plane assignment must not be modified.
> +	 */
> +	if (!rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE))
> +		rcar_du_group_write(rcrtc->group,
> +				    rcrtc->index % 2 ? DS2PR : DS1PR, 0);
>  
>  	/* Enable the VSP compositor. */
>  	if (rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE))
> @@ -505,8 +503,11 @@ static void rcar_du_crtc_stop(struct rcar_du_crtc *rcrtc)
>  	 * are stopped in one operation as we now wait for one vblank per CRTC.
>  	 * Whether this can be improved needs to be researched.
>  	 */
> -	rcar_du_group_write(rcrtc->group, rcrtc->index % 2 ? DS2PR : DS1PR, 0);
> -	drm_crtc_wait_one_vblank(crtc);
> +	if (!rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> +		rcar_du_group_write(rcrtc->group,
> +				    rcrtc->index % 2 ? DS2PR : DS1PR, 0);
> +		drm_crtc_wait_one_vblank(crtc);
> +	}
>  
>  	/*
>  	 * Disable vertical blanking interrupt reporting. We first need to wait
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.c b/drivers/gpu/drm/rcar-du/rcar_du_group.c
> index 00d5f470d377..d26b647207b8 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_group.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_group.c
> @@ -126,6 +126,18 @@ static void rcar_du_group_setup(struct rcar_du_group *rgrp)
>  	if (rcdu->info->gen >= 3)
>  		rcar_du_group_write(rgrp, DEFR10, DEFR10_CODE | DEFR10_DEFE10);
>  
> +	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> +		/*
> +		 * The CRTCs can compose the output of a VSP with other planes
> +		 * on Gen2 hardware, and of two VSPs on Gen3 hardware. Neither
> +		 * of these features are supported by the driver, so we hardcode
> +		 * plane assignment to CRTCs when setting the group up to avoid
> +		 * the need to restart then group when setting planes up.

Minor nits in comment:

  /restart then group/restart the group/

I would also possibly swap the final 'planes up' as 'up planes' if you update
here anyway:

* so we hardcode plane assignment to CRTCs when setting the group up to avoid
* the need to restart the group when setting up planes.

Up to you of course :)


> +		 */
> +		rcar_du_group_write(rgrp, DS1PR, 1);
> +		rcar_du_group_write(rgrp, DS2PR, rcdu->info->gen >= 3 ? 3 : 2);

whew ... that DS2PR indexing change from g2 to g3 looks annoying ... I had to
write out the logic tables on paper to verify the change here from the previous
code.

> +	}
> +
>  	/*
>  	 * Use DS1PR and DS2PR to configure planes priorities and connects the
>  	 * superposition 0 to DU0 pins. DU1 pins will be configured dynamically.
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> index 0e4e839afc97..13186a5684f1 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> @@ -562,17 +562,23 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
>  		rgrp->index = i;
>  		rgrp->num_crtcs = min(rcdu->num_crtcs - 2 * i, 2U);
>  
> -		/*
> -		 * If we have more than one CRTCs in this group pre-associate
> -		 * the low-order planes with CRTC 0 and the high-order planes
> -		 * with CRTC 1 to minimize flicker occurring when the
> -		 * association is changed.
> -		 */
> -		rgrp->dptsr_planes = rgrp->num_crtcs > 1
> -				   ? (rcdu->info->gen >= 3 ? 0x04 : 0xf0)
> -				   : 0;
> -
> -		if (!rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> +		if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> +			/*
> +			 * When using the VSP plane assignment to CRTCs is
> +			 * fixed. The first VSP is connected to plane 1, and the
> +			 * second VSP to plane 2 on Gen2 hardware and to plane 3
> +			 * on Gen3 hardware.
> +			 */
> +			rgrp->dptsr_planes = rgrp->num_crtcs > 1
> +					   ? (rcdu->info->gen >= 3 ? 4 : 2)
> +					   : 0;
> +		} else {
> +			/*
> +			 * Pre-associate the planes with the CRTCs if we have
> +			 * more than one CRTC in this group to minimize flicker
> +			 * when plane association is changed.
> +			 */
> +			rgrp->dptsr_planes = rgrp->num_crtcs > 1 ? 0xf0 : 0x00;
>  			ret = rcar_du_planes_init(rgrp);
>  			if (ret < 0)
>  				return ret;
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
> index b0040478a3db..787f036b18fb 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
> @@ -548,17 +548,9 @@ void __rcar_du_plane_setup(struct rcar_du_group *rgrp,
>  		rcar_du_plane_setup_format(rgrp, (state->hwindex + 1) % 8,
>  					   state);
>  
> +	/* On Gen3 planes have no scanout data. */
>  	if (rcdu->info->gen < 3)
>  		rcar_du_plane_setup_scanout(rgrp, state);
> -
> -	if (state->source == RCAR_DU_PLANE_VSPD1) {
> -		unsigned int vspd1_sink = rgrp->index ? 2 : 0;
> -
> -		if (rcdu->vspd1_sink != vspd1_sink) {
> -			rcdu->vspd1_sink = vspd1_sink;
> -			rcar_du_set_dpad0_vsp1_routing(rcdu);
> -		}
> -	}
>  }
>  
>  static int rcar_du_plane_atomic_check(struct drm_plane *plane,
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index e43b065e141a..dba150a20f3d 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -74,15 +74,6 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  
>  	__rcar_du_plane_setup(crtc->group, &state);
>  
> -	/*
> -	 * Ensure that the plane source configuration takes effect by requesting
> -	 * a restart of the group. See rcar_du_plane_atomic_update() for a more
> -	 * detailed explanation.
> -	 *
> -	 * TODO: Check whether this is still needed on Gen3.
> -	 */
> -	crtc->group->need_restart = true;
> -
>  	vsp1_du_setup_lif(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
>  }
>  
> 
