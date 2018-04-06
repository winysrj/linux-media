Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35434 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbeDFQRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 12:17:00 -0400
Subject: Re: [PATCH v2 11/15] v4l: vsp1: Add per-display list internal
 completion notification support
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180405091840.30728-12-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <d1eaf202-4029-6d5f-91e4-7de1265ab208@ideasonboard.com>
Date: Fri, 6 Apr 2018 17:16:56 +0100
MIME-Version: 1.0
In-Reply-To: <20180405091840.30728-12-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 05/04/18 10:18, Laurent Pinchart wrote:
> Display list completion is already reported to the frame end handler,
> but that mechanism is global to all display lists. In order to implement
> BRU and BRS reassignment in DRM pipelines we will need to commit a
> display list and wait for its completion internally, without reporting
> it to the DRM driver. Extend the display list API to support such an
> internal use of the display list.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
> Changes since v1:
> 
> - Use the frame end status flags to report notification
> - Rename the notify flag to internal

This reads much better to me.

Thanks for the respin.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_dl.c    | 23 ++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_dl.h    |  3 ++-
>  drivers/media/platform/vsp1/vsp1_drm.c   |  2 +-
>  drivers/media/platform/vsp1/vsp1_video.c |  2 +-
>  4 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 662fa2a347c9..30ad491605ff 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -72,6 +72,7 @@ struct vsp1_dl_body {
>   * @fragments: list of extra display list bodies
>   * @has_chain: if true, indicates that there's a partition chain
>   * @chain: entry in the display list partition chain
> + * @internal: whether the display list is used for internal purpose
>   */
>  struct vsp1_dl_list {
>  	struct list_head list;
> @@ -85,6 +86,8 @@ struct vsp1_dl_list {
>  
>  	bool has_chain;
>  	struct list_head chain;
> +
> +	bool internal;
>  };
>  
>  enum vsp1_dl_mode {
> @@ -550,8 +553,16 @@ static void vsp1_dl_list_commit_continuous(struct vsp1_dl_list *dl)
>  	 * case we can't replace the queued list by the new one, as we could
>  	 * race with the hardware. We thus mark the update as pending, it will
>  	 * be queued up to the hardware by the frame end interrupt handler.
> +	 *
> +	 * If a display list is already pending we simply drop it as the new
> +	 * display list is assumed to contain a more recent configuration. It is
> +	 * an error if the already pending list has the internal flag set, as
> +	 * there is then a process waiting for that list to complete. This
> +	 * shouldn't happen as the waiting process should perform proper
> +	 * locking, but warn just in case.
>  	 */
>  	if (vsp1_dl_list_hw_update_pending(dlm)) {
> +		WARN_ON(dlm->pending && dlm->pending->internal);
>  		__vsp1_dl_list_put(dlm->pending);
>  		dlm->pending = dl;
>  		return;
> @@ -581,7 +592,7 @@ static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
>  	dlm->active = dl;
>  }
>  
> -void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
> +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
>  {
>  	struct vsp1_dl_manager *dlm = dl->dlm;
>  	struct vsp1_dl_list *dl_child;
> @@ -598,6 +609,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
>  		}
>  	}
>  
> +	dl->internal = internal;
> +
>  	spin_lock_irqsave(&dlm->lock, flags);
>  
>  	if (dlm->singleshot)
> @@ -624,6 +637,10 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
>   * raced with the frame end interrupt. The function always returns with the flag
>   * set in header mode as display list processing is then not continuous and
>   * races never occur.
> + *
> + * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the previous display list
> + * has completed and had been queued with the internal notification flag.
> + * Internal notification is only supported for continuous mode.
>   */
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  {
> @@ -656,6 +673,10 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  	 * frame end interrupt. The display list thus becomes active.
>  	 */
>  	if (dlm->queued) {
> +		if (dlm->queued->internal)
> +			flags |= VSP1_DL_FRAME_END_INTERNAL;
> +		dlm->queued->internal = false;
> +
>  		__vsp1_dl_list_put(dlm->active);
>  		dlm->active = dlm->queued;
>  		dlm->queued = NULL;
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
> index cbc2fc53e10b..1a5bbd5ddb7b 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -21,6 +21,7 @@ struct vsp1_dl_list;
>  struct vsp1_dl_manager;
>  
>  #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
> +#define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
>  
>  void vsp1_dlm_setup(struct vsp1_device *vsp1);
>  
> @@ -34,7 +35,7 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
>  struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
>  void vsp1_dl_list_put(struct vsp1_dl_list *dl);
>  void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
> -void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
> +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal);
>  
>  struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
>  					    unsigned int num_entries);
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 541473b1df67..68b126044ea1 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -370,7 +370,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  		}
>  	}
>  
> -	vsp1_dl_list_commit(dl);
> +	vsp1_dl_list_commit(dl, false);
>  }
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 4152704c2ccb..a76a44698aff 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -437,7 +437,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
>  	}
>  
>  	/* Complete, and commit the head display list. */
> -	vsp1_dl_list_commit(pipe->dl);
> +	vsp1_dl_list_commit(pipe->dl, false);
>  	pipe->dl = NULL;
>  
>  	vsp1_pipeline_run(pipe);
> 
