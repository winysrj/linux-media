Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52368 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdCDXyc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 18:54:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 2/3] v4l: vsp1: Postpone page flip in event of display list race
Date: Sun, 05 Mar 2017 01:46:57 +0200
Message-ID: <2000889.heoPCI45nc@avalon>
In-Reply-To: <7b4ce1b20550d8651feceacf638ffc46be7400f7.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com> <7b4ce1b20550d8651feceacf638ffc46be7400f7.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Saturday 04 Mar 2017 02:01:18 Kieran Bingham wrote:
> If we try to commit the display list while an update is pending, we have
> missed our opportunity. The display list manager will hold the commit
> until the next interrupt.
> 
> In this event, we inform the vsp1 completion callback handler so that
> the du will not perform a page flip out of turn.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c   |  9 +++++++--
>  drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
>  drivers/media/platform/vsp1/vsp1_drm.c  |  4 +++-
>  drivers/media/platform/vsp1/vsp1_pipe.c |  6 +++++-
>  drivers/media/platform/vsp1/vsp1_pipe.h |  2 ++
>  5 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index ad545aff4e35..f8e8c90f22bc
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -557,9 +557,10 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager
> *dlm)
>  	spin_unlock(&dlm->lock);
>  }
> 
> -void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
> +int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  {
>  	struct vsp1_device *vsp1 = dlm->vsp1;
> +	int ret = 0;
> 
>  	spin_lock(&dlm->lock);
> 
> @@ -578,8 +579,10 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager
> *dlm) * before interrupt processing. The hardware hasn't taken the update *
> into account yet, we'll thus skip one frame and retry.
>  	 */
> -	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD)
> +	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD) {
> +		ret = -EBUSY;

Getting there, but not quite :-)

What we need to protect against is the display list not being committed early 
enough, resulting in one frame skip in the hardware. The good news is that the 
driver already detects the opposite condition just below. 

>  		goto done;
> +	}
> 
>  	/* The device starts processing the queued display list right after 
the
>  	 * frame end interrupt. The display list thus becomes active.

This is what we want to report. You can simply return a bool that will tell 
whether the previous display list has completed at frame end. You should 
return true when the condition right below this comment is true, as well as 
when using header mode (to avoid breaking mem-to-mem pipelines), and false in 
all other cases.

> @@ -606,6 +609,8 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
> 
>  done:
>  	spin_unlock(&dlm->lock);
> +
> +	return ret;
>  }
> 
>  /* Hardware Setup */
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
> b/drivers/media/platform/vsp1/vsp1_dl.h index 7131aa3c5978..c772a1d92513
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -28,7 +28,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device
> *vsp1, void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
>  void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
>  void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
> -void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
> +int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
> 
>  struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
>  void vsp1_dl_list_put(struct vsp1_dl_list *dl);
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> b/drivers/media/platform/vsp1/vsp1_drm.c index 85e5ebca82a5..6f2dd42ca01b
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -40,10 +40,12 @@ static void vsp1_du_pipeline_frame_end(struct
> vsp1_pipeline *pipe) {
>  	struct vsp1_drm *drm = to_vsp1_drm(pipe);
> 
> -	if (drm->du_complete && drm->du_pending) {
> +	if (drm->du_complete && drm->du_pending && !pipe->dl_postponed) {
>  		drm->du_complete(drm->du_private);
>  		drm->du_pending = false;
>  	}
> +
> +	pipe->dl_postponed = false;
>  }
> 
>  /* ------------------------------------------------------------------------
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
> b/drivers/media/platform/vsp1/vsp1_pipe.c index 280ba0804699..3c5aae8767dd
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -297,10 +297,14 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
> 
>  void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
>  {
> +	int ret;
> +
>  	if (pipe == NULL)
>  		return;
> 
> -	vsp1_dlm_irq_frame_end(pipe->output->dlm);
> +	ret = vsp1_dlm_irq_frame_end(pipe->output->dlm);
> +	if (ret)
> +		pipe->dl_postponed = true;

This can be simplified greatly. If vsp1_dlm_irq_frame_end() returns false, 
return immediately without calling the pipe->frame_end() handler or 
incrementing the sequence number, as the frame has not completed. You can then 
remove the dl_postponed field from the vsp1_pipeline structure and call the 
.du_complete() handler unconditionally in vsp1_du_pipeline_frame_end() 
(provided it's not NULL of course). As the vsp1_dlm_irq_frame_end() function 
can't return true if a commit hasn't been queued in the first place, there's 
no need for a dl_pending flag either.

> 
>  	if (pipe->frame_end)
>  		pipe->frame_end(pipe);
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index ac4ad2655551..65cc8fb76662
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -77,6 +77,7 @@ enum vsp1_pipeline_state {
>   * @uds_input: entity at the input of the UDS, if the UDS is present
>   * @entities: list of entities in the pipeline
>   * @dl: display list associated with the pipeline
> + * @dl_postponed: identifies if the dl commit was caught by a race
> condition * @div_size: The maximum allowed partition size for the pipeline
> * @partitions: The number of partitions used to process one frame *
> @current_partition: The partition number currently being configured @@
> -107,6 +108,7 @@ struct vsp1_pipeline {
>  	struct list_head entities;
> 
>  	struct vsp1_dl_list *dl;
> +	bool dl_postponed;
> 
>  	unsigned int div_size;
>  	unsigned int partitions;

-- 
Regards,

Laurent Pinchart
