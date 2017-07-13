Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38455 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdGMRCZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 13:02:25 -0400
Subject: Re: [PATCH v2 02/14] v4l: vsp1: Don't recycle active list at display
 start
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-3-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <b020fe7c-78fe-0f40-88bd-58165b22c496@ideasonboard.com>
Date: Thu, 13 Jul 2017 18:02:20 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-3-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/06/17 19:12, Laurent Pinchart wrote:
> When the display start interrupt occurs, we know that the hardware has
> finished loading the active display list. The driver then proceeds to
> recycle the list, assuming it won't be needed anymore.
> 
> This assumption holds true for headerless display lists, as the VSP
> doesn't reload the list for the next frame if it hasn't changed.
> However, this isn't true anymore for header display lists, as they are
> loaded at every frame start regardless of whether they have been
> updated.
> 
> To prepare for header display lists usage in display pipelines, we need
> to postpone recycling the list until it gets replaced by a new one
> through a page flip. The driver already does so in the frame end
> interrupt handler, so all we need is to skip list recycling in the
> display start interrupt handler.
> 
> While the active list can be recycled at display start for headerless
> display lists, there's no real harm in postponing that to the frame end
> interrupt handler in all cases. This simplifies interrupt handling as we
> don't need to process the display start interrupt anymore.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Ok, I had skipped this one as I was concerned about its effects in relation to
11/14 but I see how that's working now.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c  | 16 ----------------
>  drivers/media/platform/vsp1/vsp1_dl.h  |  1 -
>  drivers/media/platform/vsp1/vsp1_drm.c | 12 ++++--------
>  drivers/media/platform/vsp1/vsp1_drm.h |  2 --
>  drivers/media/platform/vsp1/vsp1_drv.c |  8 --------
>  5 files changed, 4 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index dc47e236c780..bb92be4fe0f0 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -547,22 +547,6 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
>   * Display List Manager
>   */
>  
> -/* Interrupt Handling */
> -void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
> -{
> -	spin_lock(&dlm->lock);
> -
> -	/*
> -	 * The display start interrupt signals the end of the display list
> -	 * processing by the device. The active display list, if any, won't be
> -	 * accessed anymore and can be reused.
> -	 */
> -	__vsp1_dl_list_put(dlm->active);
> -	dlm->active = NULL;
> -
> -	spin_unlock(&dlm->lock);
> -}
> -
>  /**
>   * vsp1_dlm_irq_frame_end - Display list handler for the frame end interrupt
>   * @dlm: the display list manager
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
> index 6ec1380a10af..ee3508172f0a 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -27,7 +27,6 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
>  					unsigned int prealloc);
>  void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
>  void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
> -void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
>  bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
>  
>  struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 9377aafa8996..bc3fd9bc7126 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -32,11 +32,6 @@
>   * Interrupt Handling
>   */
>  
> -void vsp1_drm_display_start(struct vsp1_device *vsp1)
> -{
> -	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
> -}
> -
>  static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
>  {
>  	struct vsp1_drm *drm = to_vsp1_drm(pipe);
> @@ -224,6 +219,10 @@ int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
>  		return ret;
>  	}
>  
> +	/* Disable the display interrupts. */
> +	vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
> +	vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
> +
>  	dev_dbg(vsp1->dev, "%s: pipeline enabled\n", __func__);
>  
>  	return 0;
> @@ -529,13 +528,10 @@ void vsp1_du_atomic_flush(struct device *dev)
>  
>  	/* Start or stop the pipeline if needed. */
>  	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
> -		vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
> -		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, VI6_DISP_IRQ_ENB_DSTE);
>  		spin_lock_irqsave(&pipe->irqlock, flags);
>  		vsp1_pipeline_run(pipe);
>  		spin_unlock_irqrestore(&pipe->irqlock, flags);
>  	} else if (vsp1->drm->num_inputs && !pipe->num_inputs) {
> -		vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
>  		vsp1_pipeline_stop(pipe);
>  	}
>  }
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index e9f80727ff92..cbdbb8a39883 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -50,6 +50,4 @@ int vsp1_drm_init(struct vsp1_device *vsp1);
>  void vsp1_drm_cleanup(struct vsp1_device *vsp1);
>  int vsp1_drm_create_links(struct vsp1_device *vsp1);
>  
> -void vsp1_drm_display_start(struct vsp1_device *vsp1);
> -
>  #endif /* __VSP1_DRM_H__ */
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 95c26edead85..6b35e043b554 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -68,14 +68,6 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
>  		}
>  	}
>  
> -	status = vsp1_read(vsp1, VI6_DISP_IRQ_STA);
> -	vsp1_write(vsp1, VI6_DISP_IRQ_STA, ~status & VI6_DISP_IRQ_STA_DST);
> -
> -	if (status & VI6_DISP_IRQ_STA_DST) {
> -		vsp1_drm_display_start(vsp1);
> -		ret = IRQ_HANDLED;
> -	}
> -
>  	return ret;
>  }
>  
> 
