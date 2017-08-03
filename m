Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55402 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdHCM5I (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 08:57:08 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 3/4] drm: rcar-du: Fix race condition when disabling
 planes at CRTC stop
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170729210855.9187-4-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <1b742f51-2952-333b-f916-4b07d7522eb1@ideasonboard.com>
Date: Thu, 3 Aug 2017 13:57:04 +0100
MIME-Version: 1.0
In-Reply-To: <20170729210855.9187-4-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 29/07/17 22:08, Laurent Pinchart wrote:
> When stopping the CRTC the driver must disable all planes and wait for
> the change to take effect at the next vblank. Merely calling
> drm_crtc_wait_one_vblank() is not enough, as the function doesn't
> include any mechanism to handle the race with vblank interrupts.
> 
> Replace the drm_crtc_wait_one_vblank() call with a manual mechanism that
> handles the vblank interrupt race.

This looks like a nasty hidden race
 (though I understand I unintentionally helped make it more prominent  :D )

Fix looks good to me.

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 58 ++++++++++++++++++++++++++++++----
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  8 +++++
>  2 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> index 17fd1cd5212c..6e5bd0b92dfa 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -490,23 +490,51 @@ static void rcar_du_crtc_start(struct rcar_du_crtc *rcrtc)
>  	rcar_du_group_start_stop(rcrtc->group, true);
>  }
>  
> +static void rcar_du_crtc_disable_planes(struct rcar_du_crtc *rcrtc)
> +{
> +	struct rcar_du_device *rcdu = rcrtc->group->dev;
> +	struct drm_crtc *crtc = &rcrtc->crtc;
> +	u32 status;
> +
> +	/* Make sure vblank interrupts are enabled. */
> +	drm_crtc_vblank_get(crtc);
> +
> +	/*
> +	 * Disable planes and calculate how many vertical blanking interrupts we
> +	 * have to wait for. If a vertical blanking interrupt has been triggered
> +	 * but not processed yet, we don't know whether it occurred before or
> +	 * after the planes got disabled. We thus have to wait for two vblank
> +	 * interrupts in that case.
> +	 */
> +	spin_lock_irq(&rcrtc->vblank_lock);
> +	rcar_du_group_write(rcrtc->group, rcrtc->index % 2 ? DS2PR : DS1PR, 0);
> +	status = rcar_du_crtc_read(rcrtc, DSSR);
> +	rcrtc->vblank_count = status & DSSR_VBK ? 2 : 1;
> +	spin_unlock_irq(&rcrtc->vblank_lock);
> +
> +	if (!wait_event_timeout(rcrtc->vblank_wait, rcrtc->vblank_count == 0,
> +				msecs_to_jiffies(100)))
> +		dev_warn(rcdu->dev, "vertical blanking timeout\n");
> +
> +	drm_crtc_vblank_put(crtc);
> +}
> +
>  static void rcar_du_crtc_stop(struct rcar_du_crtc *rcrtc)
>  {
>  	struct drm_crtc *crtc = &rcrtc->crtc;
>  
>  	/*
>  	 * Disable all planes and wait for the change to take effect. This is
> -	 * required as the DSnPR registers are updated on vblank, and no vblank
> -	 * will occur once the CRTC is stopped. Disabling planes when starting
> -	 * the CRTC thus wouldn't be enough as it would start scanning out
> -	 * immediately from old frame buffers until the next vblank.
> +	 * required as the plane enable registers are updated on vblank, and no
> +	 * vblank will occur once the CRTC is stopped. Disabling planes when
> +	 * starting the CRTC thus wouldn't be enough as it would start scanning
> +	 * out immediately from old frame buffers until the next vblank.
>  	 *
>  	 * This increases the CRTC stop delay, especially when multiple CRTCs
>  	 * are stopped in one operation as we now wait for one vblank per CRTC.
>  	 * Whether this can be improved needs to be researched.
>  	 */
> -	rcar_du_group_write(rcrtc->group, rcrtc->index % 2 ? DS2PR : DS1PR, 0);
> -	drm_crtc_wait_one_vblank(crtc);
> +	rcar_du_crtc_disable_planes(rcrtc);
>  
>  	/*
>  	 * Disable vertical blanking interrupt reporting. We first need to wait
> @@ -695,10 +723,26 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
>  	irqreturn_t ret = IRQ_NONE;
>  	u32 status;
>  
> +	spin_lock(&rcrtc->vblank_lock);
> +
>  	status = rcar_du_crtc_read(rcrtc, DSSR);
>  	rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
>  
>  	if (status & DSSR_VBK) {
> +		/*
> +		 * Wake up the vblank wait if the counter reaches 0. This must
> +		 * be protected by the vblank_lock to avoid races in
> +		 * rcar_du_crtc_disable_planes().
> +		 */
> +		if (rcrtc->vblank_count) {
> +			if (--rcrtc->vblank_count == 0)
> +				wake_up(&rcrtc->vblank_wait);
> +		}
> +	}
> +
> +	spin_unlock(&rcrtc->vblank_lock);
> +
> +	if (status & DSSR_VBK) {
>  		drm_crtc_handle_vblank(&rcrtc->crtc);
>  
>  		if (rcdu->info->gen < 3)
> @@ -756,6 +800,8 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int index)
>  	}
>  
>  	init_waitqueue_head(&rcrtc->flip_wait);
> +	init_waitqueue_head(&rcrtc->vblank_wait);
> +	spin_lock_init(&rcrtc->vblank_lock);
>  
>  	rcrtc->group = rgrp;
>  	rcrtc->mmio_offset = mmio_offsets[index];
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> index 3cc376826592..065b91f5b1d9 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> @@ -15,6 +15,7 @@
>  #define __RCAR_DU_CRTC_H__
>  
>  #include <linux/mutex.h>
> +#include <linux/spinlock.h>
>  #include <linux/wait.h>
>  
>  #include <drm/drmP.h>
> @@ -33,6 +34,9 @@ struct rcar_du_vsp;
>   * @initialized: whether the CRTC has been initialized and clocks enabled
>   * @event: event to post when the pending page flip completes
>   * @flip_wait: wait queue used to signal page flip completion
> + * @vblank_lock: protects vblank_wait and vblank_count
> + * @vblank_wait: wait queue used to signal vertical blanking
> + * @vblank_count: number of vertical blanking interrupts to wait for
>   * @outputs: bitmask of the outputs (enum rcar_du_output) driven by this CRTC
>   * @group: CRTC group this CRTC belongs to
>   * @vsp: VSP feeding video to this CRTC
> @@ -50,6 +54,10 @@ struct rcar_du_crtc {
>  	struct drm_pending_vblank_event *event;
>  	wait_queue_head_t flip_wait;
>  
> +	spinlock_t vblank_lock;
> +	wait_queue_head_t vblank_wait;
> +	unsigned int vblank_count;
> +
>  	unsigned int outputs;
>  
>  	struct rcar_du_group *group;
> 
