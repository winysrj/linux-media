Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40896
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752823AbdERNyj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:54:39 -0400
Date: Thu, 18 May 2017 10:54:32 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, mchehab@kernel.org,
        kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH v4 4/4] drm: rcar-du: Register a completion callback
 with VSP1
Message-ID: <20170518105432.710fa911@vento.lan>
In-Reply-To: <934d69fcc0717a688bc3994e1fdc3e27c3827be6.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
        <934d69fcc0717a688bc3994e1fdc3e27c3827be6.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  5 May 2017 16:21:10 +0100
Kieran Bingham <kieran.bingham+renesas@ideasonboard.com> escreveu:

> Currently we process page flip events on every display interrupt,
> however this does not take into consideration the processing time needed
> by the VSP1 utilised in the pipeline.
> 
> Register a callback with the VSP driver to obtain completion events, and
> track them so that we only perform page flips when the full display
> pipeline has completed for the frame.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

For all parts of this series that touch drivers/media:

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  8 ++++++--
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  1 +
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  9 +++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> index 5f0664bcd12d..345eff72f581 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -378,7 +378,7 @@ static void rcar_du_crtc_update_planes(struct rcar_du_crtc *rcrtc)
>   * Page Flip
>   */
>  
> -static void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc)
> +void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc)
>  {
>  	struct drm_pending_vblank_event *event;
>  	struct drm_device *dev = rcrtc->crtc.dev;
> @@ -650,6 +650,7 @@ static const struct drm_crtc_funcs crtc_funcs = {
>  static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
>  {
>  	struct rcar_du_crtc *rcrtc = arg;
> +	struct rcar_du_device *rcdu = rcrtc->group->dev;
>  	irqreturn_t ret = IRQ_NONE;
>  	u32 status;
>  
> @@ -658,7 +659,10 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
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
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> index 15871fae7445..b199ed5adf36 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> @@ -73,5 +73,6 @@ void rcar_du_crtc_resume(struct rcar_du_crtc *rcrtc);
>  
>  void rcar_du_crtc_route_output(struct drm_crtc *crtc,
>  			       enum rcar_du_output output);
> +void rcar_du_crtc_finish_page_flip(struct rcar_du_crtc *rcrtc);
>  
>  #endif /* __RCAR_DU_CRTC_H__ */
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index b0ff304ce3dc..c7bb96fbfab1 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -28,6 +28,13 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
>  
> +static void rcar_du_vsp_complete(void *private)
> +{
> +	struct rcar_du_crtc *crtc = private;
> +
> +	rcar_du_crtc_finish_page_flip(crtc);
> +}
> +
>  void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  {
>  	const struct drm_display_mode *mode = &crtc->crtc.state->adjusted_mode;
> @@ -35,6 +42,8 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  	struct vsp1_du_lif_config cfg = {
>  		.width = mode->hdisplay,
>  		.height = mode->vdisplay,
> +		.callback = rcar_du_vsp_complete,
> +		.callback_data = crtc,
>  	};
>  	struct rcar_du_plane_state state = {
>  		.state = {



Thanks,
Mauro
