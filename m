Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59225 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbdCEWAi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 17:00:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 3/3] drm: rcar-du: Register a completion callback with VSP1
Date: Mon, 06 Mar 2017 00:01:13 +0200
Message-ID: <2336275.pnkIsF6lvT@avalon>
In-Reply-To: <591c0ba30211d53613a456d51f2bb523e6ef5e06.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com> <591c0ba30211d53613a456d51f2bb523e6ef5e06.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Sunday 05 Mar 2017 16:00:04 Kieran Bingham wrote:
> Currently we process page flip events on every display interrupt,
> however this does not take into consideration the processing time needed
> by the VSP1 utilised in the pipeline.
> 
> Register a callback with the VSP driver to obtain completion events, and
> track them so that we only perform page flips when the full display
> pipeline has completed for the frame.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  8 ++++++--
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  1 +
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  9 +++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index 2aceb84fc15d..caaaa1812e20
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -299,7 +299,7 @@ static void rcar_du_crtc_update_planes(struct
> rcar_du_crtc *rcrtc) * Page Flip
>   */
> 
> -static void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc)
> +void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc)
>  {
>  	struct drm_pending_vblank_event *event;
>  	struct drm_device *dev = rcrtc->crtc.dev;
> @@ -571,6 +571,7 @@ static const struct drm_crtc_funcs crtc_funcs = {
>  static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
>  {
>  	struct rcar_du_crtc *rcrtc = arg;
> +	struct rcar_du_device *rcdu = rcrtc->group->dev;
>  	irqreturn_t ret = IRQ_NONE;
>  	u32 status;
> 
> @@ -579,7 +580,10 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
> 
>  	if (status & DSSR_FRM) {
>  		drm_crtc_handle_vblank(&rcrtc->crtc);
> -		rcar_du_crtc_finish_page_flip(rcrtc);
> +
> +		if (rcdu->info->gen < 3)
> +			rcar_du_crtc_finish_page_flip(rcrtc);
> +
>  		ret = IRQ_HANDLED;
>  	}
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h index a7194812997e..ebdbff9d8e59
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> @@ -71,5 +71,6 @@ void rcar_du_crtc_resume(struct rcar_du_crtc *rcrtc);
> 
>  void rcar_du_crtc_route_output(struct drm_crtc *crtc,
>  			       enum rcar_du_output output);
> +void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc);
> 
>  #endif /* __RCAR_DU_CRTC_H__ */
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c index b0ff304ce3dc..cbb6f54c99ef
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -28,6 +28,13 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
> 
> +static void rcar_du_vsp_complete(void *private)
> +{
> +	struct rcar_du_crtc *crtc = (struct rcar_du_crtc *)private;

I'll remove the cast when applying, as pointed out by Sergei.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +
> +	rcar_du_crtc_finish_page_flip(crtc);
> +}
> +
>  void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  {
>  	const struct drm_display_mode *mode = &crtc->crtc.state-
>adjusted_mode;
> @@ -35,6 +42,8 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  	struct vsp1_du_lif_config cfg = {
>  		.width = mode->hdisplay,
>  		.height = mode->vdisplay,
> +		.callback = rcar_du_vsp_complete,
> +		.callback_data = crtc,
>  	};
>  	struct rcar_du_plane_state state = {
>  		.state = {

-- 
Regards,

Laurent Pinchart
