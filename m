Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46923 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbeDDQAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 12:00:16 -0400
Subject: Re: [PATCH 13/15] v4l: vsp1: Assign BRU and BRS to pipelines
 dynamically
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-14-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <48239272-4f3f-1245-5ad9-c54c1413c1c2@ideasonboard.com>
Date: Wed, 4 Apr 2018 17:00:10 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-14-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the patch.

I don't envy you on having to deal with this one ... it's a bit of a pain ...

On 26/02/18 21:45, Laurent Pinchart wrote:
> The VSPDL variant drives two DU channels through two LIF and two
> blenders, BRU and BRS. The DU channels thus share the five available
> VSPDL inputs and expose them as five KMS planes.
> 
> The current implementation assigns the BRS to the second LIF and thus
> artificially limits the number of planes for the second display channel
> to two at most.
> 
> Lift this artificial limitation by assigning the BRU and BRS to the
> display pipelines on demand based on the number of planes used by each
> pipeline. When a display pipeline needs more than two inputs and the BRU
> is already in use by the other pipeline, this requires reconfiguring the
> other pipeline to free the BRU before processing, which can result in
> frame drop on both pipelines.

So this is a hard one!
 - Having to dynamically reconfigure "someone else's" pipes ...


> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Except for the recursion, which is unavoidable, and the lock handling across
function calls which is ... unavoidable I think as well (at least for the
moment), my only quibble is the naming of the 'notify' variable, which is not
particularly clear in terms of who it notifies. (Internal, vs DRM)

I'll leave it up to you to decide whether or not to rename it though, and if
you're happy with the naming then fine.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 160 +++++++++++++++++++++++++++------
>  drivers/media/platform/vsp1/vsp1_drm.h |   9 ++
>  2 files changed, 144 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 6c60b72b6f50..87e31ba0ddf5 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -39,7 +39,13 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>  	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
>  
>  	if (drm_pipe->du_complete)
> -		drm_pipe->du_complete(drm_pipe->du_private, completed);
> +		drm_pipe->du_complete(drm_pipe->du_private,
> +				      completed && !notify);
> +
> +	if (notify) {
> +		drm_pipe->force_bru_release = false;
> +		wake_up(&drm_pipe->wait_queue);
> +	}

Notify seems such a nondescript verb to use here, and confuses me against who we
are notifying  - and why (it's an internal notification, but notify makes me
think we are 'notifying' the DU - which is exactly the opposite).

(Perhaps this is actually a comment for the previous patch, but I've gone
out-of-order, due to the complexities here...)

Could this be 'internal', 'released' or 'reconfigured', or something to
distinguish that this frame-end is not a normal frame-completion event ?


>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -149,6 +155,10 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
>  }
>  
>  /* Setup the BRU source pad. */
> +static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
> +					struct vsp1_pipeline *pipe);
> +static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe);
> +

Ohhh lovely, recursion...
Ohhh lovely, recursion...

>  static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
>  				      struct vsp1_pipeline *pipe)
>  {
> @@ -156,8 +166,93 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
>  	struct v4l2_subdev_format format = {
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> +	struct vsp1_entity *bru;
>  	int ret;
>  
> +	/*
> +	 * Pick a BRU:
> +	 * - If we need more than two inputs, use the main BRU.
> +	 * - Otherwise, if we are not forced to release our BRU, keep it.
> +	 * - Else, use any free BRU (randomly starting with the main BRU).
> +	 */
> +	if (pipe->num_inputs > 2)
> +		bru = &vsp1->bru->entity;
> +	else if (pipe->bru && !drm_pipe->force_bru_release)
> +		bru = pipe->bru;
> +	else if (!vsp1->bru->entity.pipe)
> +		bru = &vsp1->bru->entity;
> +	else
> +		bru = &vsp1->brs->entity;


Ok - that tooks some iterations to go through - but I think it covers all the bases.

> +
> +	/* Switch BRU if needed. */
> +	if (bru != pipe->bru) {
> +		struct vsp1_entity *released_bru = NULL;
> +
> +		/* Release our BRU if we have one. */
> +		if (pipe->bru) {
> +			/*
> +			 * The BRU might be acquired by the other pipeline in
> +			 * the next step. We must thus remove it from the list
> +			 * of entities for this pipeline. The other pipeline's
> +			 * hardware configuration will reconfigure the BRU
> +			 * routing.
> +			 *
> +			 * However, if the other pipeline doesn't acquire our
> +			 * BRU, we need to keep it in the list, otherwise the
> +			 * hardware configuration step won't disconnect it from
> +			 * the pipeline. To solve this, store the released BRU
> +			 * pointer to add it back to the list of entities later
> +			 * if it isn't acquired by the other pipeline.
> +			 */
> +			released_bru = pipe->bru;
> +
> +			list_del(&pipe->bru->list_pipe);
> +			pipe->bru->sink = NULL;
> +			pipe->bru->pipe = NULL;
> +			pipe->bru = NULL;
> +		}
> +
> +		/*
> +		 * If the BRU we need is in use, force the owner pipeline to
> +		 * switch to the other BRU and wait until the switch completes.
> +		 */
> +		if (bru->pipe) {
> +			struct vsp1_drm_pipeline *owner_pipe;
> +
> +			owner_pipe = to_vsp1_drm_pipeline(bru->pipe);
> +			owner_pipe->force_bru_release = true;
> +
> +			vsp1_du_pipeline_setup_input(vsp1, &owner_pipe->pipe);
> +			vsp1_du_pipeline_configure(&owner_pipe->pipe);
> +
> +			ret = wait_event_timeout(owner_pipe->wait_queue,
> +						 !owner_pipe->force_bru_release,
> +						 msecs_to_jiffies(500));
> +			if (ret == 0)
> +				dev_warn(vsp1->dev,
> +					 "DRM pipeline %u reconfiguration timeout\n",
> +					 owner_pipe->pipe.lif->index);
> +		}
> +
> +		/*
> +		 * If the BRU we have released previously hasn't been acquired
> +		 * by the other pipeline, add it back to the entities list (with
> +		 * the pipe pointer NULL) to let vsp1_du_pipeline_configure()
> +		 * disconnect it from the hardware pipeline.
> +		 */
> +		if (released_bru && !released_bru->pipe)
> +			list_add_tail(&released_bru->list_pipe,
> +				      &pipe->entities);
> +
> +		/* Add the BRU to the pipeline. */
> +		pipe->bru = bru;
> +		pipe->bru->pipe = pipe;
> +		pipe->bru->sink = &pipe->output->entity;
> +		pipe->bru->sink_pad = 0;
> +
> +		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
> +	}
> +


Phew ... that's quite some chunk of interacting code ...

I've gone through it with the combinations of two pipes, 1 and 2, then swapping
them around when say pipe 2 has 3 inputs.

It seems to scan through OK in my head ... but I think I've gone a bit
cross-eyed now :D


Have we got some tests in place for the various combinations of paths through here ?


>  	/*
>  	 * Configure the format on the BRU source and verify that it matches the
>  	 * requested format. We don't set the media bus code as it is configured
> @@ -197,7 +292,7 @@ static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
>  					struct vsp1_pipeline *pipe)
>  {
>  	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
> -	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
> +	struct vsp1_bru *bru;
>  	unsigned int i;
>  	int ret;
>  
> @@ -208,15 +303,6 @@ static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
>  		struct vsp1_rwpf *rpf = vsp1->rpf[i];
>  		unsigned int j;
>  
> -		/*
> -		 * Make sure we don't accept more inputs than the hardware can
> -		 * handle. This is a temporary fix to avoid display stall, we
> -		 * need to instead allocate the BRU or BRS to display pipelines
> -		 * dynamically based on the number of planes they each use.
> -		 */
> -		if (pipe->num_inputs >= pipe->bru->source_pad)
> -			pipe->inputs[i] = NULL;
> -
>  		if (!pipe->inputs[i])
>  			continue;
>  
> @@ -242,6 +328,8 @@ static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
>  		return ret;
>  	}
>  
> +	bru = to_bru(&pipe->bru->subdev);
> +
>  	/* Setup the RPF input pipeline for every enabled input. */
>  	for (i = 0; i < pipe->bru->source_pad; ++i) {
>  		struct vsp1_rwpf *rpf = inputs[i];
> @@ -339,6 +427,7 @@ static int vsp1_du_pipeline_setup_output(struct vsp1_device *vsp1,
>  /* Configure all entities in the pipeline. */
>  static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  {
> +	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
>  	struct vsp1_entity *entity;
>  	struct vsp1_entity *next;
>  	struct vsp1_dl_list *dl;
> @@ -369,7 +458,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  		}
>  	}
>  
> -	vsp1_dl_list_commit(dl, false);
> +	vsp1_dl_list_commit(dl, drm_pipe->force_bru_release);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -414,7 +503,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_drm_pipeline *drm_pipe;
>  	struct vsp1_pipeline *pipe;
> -	struct vsp1_bru *bru;
>  	unsigned long flags;
>  	unsigned int i;
>  	int ret;
> @@ -424,9 +512,14 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  
>  	drm_pipe = &vsp1->drm->pipe[pipe_index];
>  	pipe = &drm_pipe->pipe;
> -	bru = to_bru(&pipe->bru->subdev);
>  
>  	if (!cfg) {
> +		struct vsp1_bru *bru;
> +
> +		mutex_lock(&vsp1->drm->lock);
> +
> +		bru = to_bru(&pipe->bru->subdev);
> +
>  		/*
>  		 * NULL configuration means the CRTC is being disabled, stop
>  		 * the pipeline and turn the light off.
> @@ -456,6 +549,12 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		drm_pipe->du_complete = NULL;
>  		pipe->num_inputs = 0;
>  
> +		list_del(&pipe->bru->list_pipe);
> +		pipe->bru->pipe = NULL;
> +		pipe->bru = NULL;
> +
> +		mutex_unlock(&vsp1->drm->lock);
> +
>  		vsp1_dlm_reset(pipe->output->dlm);
>  		vsp1_device_put(vsp1);
>  
> @@ -470,19 +569,21 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
>  		__func__, pipe_index, cfg->width, cfg->height);
>  
> +	mutex_lock(&vsp1->drm->lock);
> +
>  	/* Setup formats through the pipeline. */
>  	ret = vsp1_du_pipeline_setup_input(vsp1, pipe);
>  	if (ret < 0)
> -		return ret;
> +		goto unlock;
>  
>  	ret = vsp1_du_pipeline_setup_output(vsp1, pipe);
>  	if (ret < 0)
> -		return ret;
> +		goto unlock;
>  
>  	/* Enable the VSP1. */
>  	ret = vsp1_device_get(vsp1);
>  	if (ret < 0)
> -		return ret;
> +		goto unlock;
>  
>  	/*
>  	 * Register a callback to allow us to notify the DRM driver of frame
> @@ -498,6 +599,12 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	/* Configure all entities in the pipeline. */
>  	vsp1_du_pipeline_configure(pipe);
>  
> +unlock:
> +	mutex_unlock(&vsp1->drm->lock);
> +
> +	if (ret < 0)
> +		return ret;
> +
>  	/* Start the pipeline. */
>  	spin_lock_irqsave(&pipe->irqlock, flags);
>  	vsp1_pipeline_run(pipe);
> @@ -516,6 +623,9 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
>   */
>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
>  {
> +	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> +
> +	mutex_lock(&vsp1->drm->lock);

Ouch ... we have to lock ...

>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
>  
> @@ -629,6 +739,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  
>  	vsp1_du_pipeline_setup_input(vsp1, pipe);
>  	vsp1_du_pipeline_configure(pipe);
> +	mutex_unlock(&vsp1->drm->lock);

And unlock in different functions ? :-(

(Yes, I see that we do - because we are crossing pipes...)


>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
>  
> @@ -667,28 +778,26 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  	if (!vsp1->drm)
>  		return -ENOMEM;
>  
> +	mutex_init(&vsp1->drm->lock);
> +
>  	/* Create one DRM pipeline per LIF. */
>  	for (i = 0; i < vsp1->info->lif_count; ++i) {
>  		struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[i];
>  		struct vsp1_pipeline *pipe = &drm_pipe->pipe;
>  
> +		init_waitqueue_head(&drm_pipe->wait_queue);
> +
>  		vsp1_pipeline_init(pipe);
>  
>  		pipe->frame_end = vsp1_du_pipeline_frame_end;
>  
>  		/*
> -		 * The DRM pipeline is static, add entities manually. The first
> -		 * pipeline uses the BRU and the second pipeline the BRS.
> +		 * The output side of the DRM pipeline is static, add the
> +		 * corresponding entities manually.
>  		 */
> -		pipe->bru = i == 0 ? &vsp1->bru->entity : &vsp1->brs->entity;
>  		pipe->output = vsp1->wpf[i];
>  		pipe->lif = &vsp1->lif[i]->entity;
>  
> -		pipe->bru->pipe = pipe;
> -		pipe->bru->sink = &pipe->output->entity;
> -		pipe->bru->sink_pad = 0;
> -		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
> -
>  		pipe->output->entity.pipe = pipe;
>  		pipe->output->entity.sink = pipe->lif;
>  		pipe->output->entity.sink_pad = 0;
> @@ -710,4 +819,5 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  
>  void vsp1_drm_cleanup(struct vsp1_device *vsp1)
>  {
> +	mutex_destroy(&vsp1->drm->lock);
>  }
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index c8dd75ba01f6..c84bc1c456c0 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -13,7 +13,9 @@
>  #ifndef __VSP1_DRM_H__
>  #define __VSP1_DRM_H__
>  
> +#include <linux/mutex.h>
>  #include <linux/videodev2.h>
> +#include <linux/wait.h>
>  
>  #include "vsp1_pipe.h"
>  
> @@ -22,6 +24,8 @@
>   * @pipe: the VSP1 pipeline used for display
>   * @width: output display width
>   * @height: output display height
> + * @force_bru_release: when set, release the BRU during the next reconfiguration
> + * @wait_queue: wait queue to wait for BRU release completion
>   * @du_complete: frame completion callback for the DU driver (optional)
>   * @du_private: data to be passed to the du_complete callback
>   */
> @@ -31,6 +35,9 @@ struct vsp1_drm_pipeline {
>  	unsigned int width;
>  	unsigned int height;
>  
> +	bool force_bru_release;
> +	wait_queue_head_t wait_queue;
> +
>  	/* Frame synchronisation */
>  	void (*du_complete)(void *, bool);
>  	void *du_private;
> @@ -39,11 +46,13 @@ struct vsp1_drm_pipeline {
>  /**
>   * vsp1_drm - State for the API exposed to the DRM driver
>   * @pipe: the VSP1 DRM pipeline used for display
> + * @lock: protects the BRU and BRS allocation
>   * @inputs: source crop rectangle, destination compose rectangle and z-order
>   *	position for every input (indexed by RPF index)
>   */
>  struct vsp1_drm {
>  	struct vsp1_drm_pipeline pipe[VSP1_MAX_LIF];
> +	struct mutex lock;
>  
>  	struct {
>  		struct v4l2_rect crop;
> 
