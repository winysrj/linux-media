Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35588 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdCCCZL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 21:25:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 3/3] drm: rcar-du: Register a completion callback with VSP1
Date: Fri, 03 Mar 2017 04:17:39 +0200
Message-ID: <1896383.LZRWDRHL8Z@avalon>
In-Reply-To: <b2e74113040a80c99151c392b1d42ea604b8ca1f.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com> <b2e74113040a80c99151c392b1d42ea604b8ca1f.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Wednesday 01 Mar 2017 13:12:56 Kieran Bingham wrote:
> Updating the state in a running VSP1 requires two interrupts from the
> VSP. Initially, the updated state will be committed - but only after the
> VSP1 has completed processing it's current frame will the new state be
> taken into account. As such, the committed state will only be 'completed'
> after an extra frame completion interrupt.
> 
> Track this delay, by passing the frame flip event through the VSP
> module; It will be returned only when the frame has completed and can be
> returned to the caller.

I'll check the interrupt sequence logic tomorrow, it's a bit too late now. 
Please see below for additional comments.

> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  8 +++++-
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  1 +-
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 34 ++++++++++++++++++++++++++-
>  3 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index 7391dd95c733..0a824633a012
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -328,7 +328,7 @@ static bool rcar_du_crtc_page_flip_pending(struct
> rcar_du_crtc *rcrtc) bool pending;
> 
>  	spin_lock_irqsave(&dev->event_lock, flags);
> -	pending = rcrtc->event != NULL;
> +	pending = (rcrtc->event != NULL) || (rcrtc->pending != NULL);
>  	spin_unlock_irqrestore(&dev->event_lock, flags);
> 
>  	return pending;
> @@ -578,6 +578,12 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
> rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
> 
>  	if (status & DSSR_FRM) {
> +
> +		if (rcrtc->pending) {
> +			trace_printk("VBlank loss due to VSP Overrun\n");
> +			return IRQ_HANDLED;
> +		}
> +
>  		drm_crtc_handle_vblank(&rcrtc->crtc);
>  		rcar_du_crtc_finish_page_flip(rcrtc);
>  		ret = IRQ_HANDLED;
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h index a7194812997e..8374a858446a
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> @@ -46,6 +46,7 @@ struct rcar_du_crtc {
>  	bool started;
> 
>  	struct drm_pending_vblank_event *event;
> +	struct drm_pending_vblank_event *pending;
>  	wait_queue_head_t flip_wait;
> 
>  	unsigned int outputs;
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c index 71e70e1e0881..408375aff1a0
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -28,6 +28,26 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
> 
> +static void rcar_du_vsp_complete(void *private, void *data)
> +{
> +	struct rcar_du_crtc *crtc = (struct rcar_du_crtc *)private;
> +	struct drm_device *dev = crtc->crtc.dev;
> +	struct drm_pending_vblank_event *event;
> +	bool match;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->event_lock, flags);
> +	event = crtc->event;
> +	crtc->event = data;
> +	match = (crtc->event == crtc->pending);
> +	crtc->pending = NULL;
> +	spin_unlock_irqrestore(&dev->event_lock, flags);
> +
> +	/* Safety checks */
> +	WARN(event, "Event lost by VSP completion callback\n");
> +	WARN(!match, "Stored pending event, does not match completion\n");

I understand you want to be safe, and I assume these have never been triggered 
in your tests. I'd rather replace them by a mechanism that doesn't require 
passing the event to the VSP driver, and that wouldn't require adding a 
pending field to the rcar_du_crtc structure. Wouldn't adding a WARN_ON(rcrtc-
>event) in rcar_du_crtc_atomic_begin() in the if (crtc->state->event) block do 
the job ?

Would this get in the way of your trace_printk() debugging in 
rcar_du_crtc_irq() ? Could you implement the debugging in a separate patch 
without requiring to pass the event to the VSP driver ?

> +}
> +
>  void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  {
>  	const struct drm_display_mode *mode = &crtc->crtc.state-
>adjusted_mode;
> @@ -66,6 +86,8 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  	 */
>  	crtc->group->need_restart = true;
> 
> +	vsp1_du_register_callback(crtc->vsp->vsp, rcar_du_vsp_complete, crtc);
> +
>  	vsp1_du_setup_lif(crtc->vsp->vsp, mode->hdisplay, mode->vdisplay);
>  }
> 
> @@ -81,7 +103,17 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
> 
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_flush(crtc->vsp->vsp, NULL);
> +	struct drm_device *dev = crtc->crtc.dev;
> +	struct drm_pending_vblank_event *event;
> +	unsigned long flags;
> +
> +	/* Move the event to the VSP, track it locally as 'pending' */
> +	spin_lock_irqsave(&dev->event_lock, flags);
> +	event = crtc->pending = crtc->event;
> +	crtc->event = NULL;
> +	spin_unlock_irqrestore(&dev->event_lock, flags);
> +
> +	vsp1_du_atomic_flush(crtc->vsp->vsp, event);
>  }
> 
>  /* Keep the two tables in sync. */

-- 
Regards,

Laurent Pinchart
