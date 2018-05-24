Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45152 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967338AbeEXLu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 07:50:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 11/11] drm: rcar-du: Support interlaced video output through vsp1
Date: Thu, 24 May 2018 14:50:23 +0300
Message-ID: <10463435.CoRpyeppX3@avalon>
In-Reply-To: <0c7e8033195d0a80af9a353b01c116778c568e04.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com> <0c7e8033195d0a80af9a353b01c116778c568e04.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 3 May 2018 16:36:22 EEST Kieran Bingham wrote:
> Use the newly exposed VSP1 interface to enable interlaced frame support
> through the VSP1 lif pipelines.

s/lif/LIF/

> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 1 +
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index d71d709fe3d9..206532959ec9
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -289,6 +289,7 @@ static void rcar_du_crtc_set_display_timing(struct
> rcar_du_crtc *rcrtc) /* Signal polarities */
>  	value = ((mode->flags & DRM_MODE_FLAG_PVSYNC) ? DSMR_VSL : 0)
>  	      | ((mode->flags & DRM_MODE_FLAG_PHSYNC) ? DSMR_HSL : 0)
> +	      | ((mode->flags & DRM_MODE_FLAG_INTERLACE) ? DSMR_ODEV : 0)

How will this affect Gen2 ? Could you document what this change does in the 
commit message ?

>  	      | DSMR_DIPM_DISP | DSMR_CSPM;
> 
>  	rcar_du_crtc_write(rcrtc, DSMR, value);
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c index af7822a66dee..c7b37232ee91
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -186,6 +186,9 @@ static void rcar_du_vsp_plane_setup(struct
> rcar_du_vsp_plane *plane) };
>  	unsigned int i;
> 
> +	cfg.interlaced = !!(plane->plane.state->crtc->mode.flags
> +			    & DRM_MODE_FLAG_INTERLACE);
> +
>  	cfg.src.left = state->state.src.x1 >> 16;
>  	cfg.src.top = state->state.src.y1 >> 16;
>  	cfg.src.width = drm_rect_width(&state->state.src) >> 16;

-- 
Regards,

Laurent Pinchart
