Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48561 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdIORGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 13:06:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v1 3/3] drm: rcar-du: Remove unused CRTC suspend/resume functions
Date: Fri, 15 Sep 2017 20:06:26 +0300
Message-ID: <8655239.xm8VQVi7RW@avalon>
In-Reply-To: <588e2797c3b8c0b966afb549e658e3cd0652a734.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com> <588e2797c3b8c0b966afb549e658e3cd0652a734.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 15 September 2017 19:42:07 EEST Kieran Bingham wrote:
> An early implementation of suspend-resume helpers are available in the
> CRTC module, however they are unused and no longer needed.
> 
> With suspend and resume handled by the core DRM atomic helpers, we can
> remove the unused functions.
> 
> CC: dri-devel@lists.freedesktop.org
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll take this in my tree with patch 2/3.

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 35 +---------------------------
>  1 file changed, 35 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index 301ea1a8018e..b492063a6e1f
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -557,41 +557,6 @@ static void rcar_du_crtc_stop(struct rcar_du_crtc
> *rcrtc) rcar_du_group_start_stop(rcrtc->group, false);
>  }
> 
> -void rcar_du_crtc_suspend(struct rcar_du_crtc *rcrtc)
> -{
> -	if (rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE))
> -		rcar_du_vsp_disable(rcrtc);
> -
> -	rcar_du_crtc_stop(rcrtc);
> -	rcar_du_crtc_put(rcrtc);
> -}
> -
> -void rcar_du_crtc_resume(struct rcar_du_crtc *rcrtc)
> -{
> -	unsigned int i;
> -
> -	if (!rcrtc->crtc.state->active)
> -		return;
> -
> -	rcar_du_crtc_get(rcrtc);
> -	rcar_du_crtc_setup(rcrtc);
> -
> -	/* Commit the planes state. */
> -	if (!rcar_du_has(rcrtc->group->dev, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> -		for (i = 0; i < rcrtc->group->num_planes; ++i) {
> -			struct rcar_du_plane *plane = &rcrtc->group->planes[i];
> -
> -			if (plane->plane.state->crtc != &rcrtc->crtc)
> -				continue;
> -
> -			rcar_du_plane_setup(plane);
> -		}
> -	}
> -
> -	rcar_du_crtc_update_planes(rcrtc);
> -	rcar_du_crtc_start(rcrtc);
> -}
> -
>  /* ------------------------------------------------------------------------
>   * CRTC Functions
>   */


-- 
Regards,

Laurent Pinchart
