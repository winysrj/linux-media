Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46407 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdHASjx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 14:39:53 -0400
Subject: Re: [PATCH v2 10/14] v4l: vsp1: Add support for multiple DRM
 pipelines
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-11-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <2a9f5843-8343-b5b9-e32f-9ba21d146ae4@ideasonboard.com>
Date: Tue, 1 Aug 2017 19:39:49 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-11-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Last one - (and I thought I'd already done this one in the last batch .. but
perhaps I lost it before hitting send)

On 26/06/17 19:12, Laurent Pinchart wrote:
> The R-Car H3 ES2.0 VSP-DL instance has two LIF entities and can drive
> two display pipelines at the same time. Refactor the VSP DRM code to
> support that by introducing a vsp_drm_pipeline object that models one
> display pipeline.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

I can't see anything wrong here, so maybe my eyes are going fuzzy from all the
blue text in my mail client :-)

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 200 ++++++++++++++++++++-------------
>  drivers/media/platform/vsp1/vsp1_drm.h |  35 +++---
>  2 files changed, 141 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 4e1b893e8f51..7791d7b5a743 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -34,10 +34,10 @@
>  
>  static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
>  {
> -	struct vsp1_drm *drm = to_vsp1_drm(pipe);
> +	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
>  
> -	if (drm->du_complete)
> -		drm->du_complete(drm->du_private);
> +	if (drm_pipe->du_complete)
> +		drm_pipe->du_complete(drm_pipe->du_private);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -80,15 +80,22 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		      const struct vsp1_du_lif_config *cfg)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> -	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
> -	struct vsp1_bru *bru = vsp1->bru;
> +	struct vsp1_drm_pipeline *drm_pipe;
> +	struct vsp1_pipeline *pipe;
> +	struct vsp1_bru *bru;
>  	struct v4l2_subdev_format format;
> +	const char *bru_name;
>  	unsigned int i;
>  	int ret;
>  
> -	if (pipe_index > 0)
> +	if (pipe_index >= vsp1->info->lif_count)
>  		return -EINVAL;
>  
> +	drm_pipe = &vsp1->drm->pipe[pipe_index];
> +	pipe = &drm_pipe->pipe;
> +	bru = to_bru(&pipe->bru->subdev);
> +	bru_name = pipe->bru->type == VSP1_ENTITY_BRU ? "BRU" : "BRS";
> +
>  	if (!cfg) {
>  		/*
>  		 * NULL configuration means the CRTC is being disabled, stop
> @@ -100,14 +107,25 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  
>  		media_pipeline_stop(&pipe->output->entity.subdev.entity);
>  
> -		for (i = 0; i < bru->entity.source_pad; ++i) {
> -			vsp1->drm->inputs[i].enabled = false;
> -			bru->inputs[i].rpf = NULL;
> +		for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i) {
> +			struct vsp1_rwpf *rpf = pipe->inputs[i];
> +
> +			if (!rpf)
> +				continue;
> +
> +			/*
> +			 * Remove the RPF from the pipe and the list of BRU
> +			 * inputs.
> +			 */
> +			WARN_ON(list_empty(&rpf->entity.list_pipe));
> +			list_del_init(&rpf->entity.list_pipe);
>  			pipe->inputs[i] = NULL;
> +
> +			bru->inputs[rpf->bru_input].rpf = NULL;
>  		}
>  
> +		drm_pipe->du_complete = NULL;
>  		pipe->num_inputs = 0;
> -		vsp1->drm->du_complete = NULL;
>  
>  		vsp1_dlm_reset(pipe->output->dlm);
>  		vsp1_device_put(vsp1);
> @@ -117,8 +135,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		return 0;
>  	}
>  
> -	dev_dbg(vsp1->dev, "%s: configuring LIF with format %ux%u\n",
> -		__func__, cfg->width, cfg->height);
> +	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
> +		__func__, pipe_index, cfg->width, cfg->height);
>  
>  	/*
>  	 * Configure the format at the BRU sinks and propagate it through the
> @@ -127,7 +145,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	memset(&format, 0, sizeof(format));
>  	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>  
> -	for (i = 0; i < bru->entity.source_pad; ++i) {
> +	for (i = 0; i < pipe->bru->source_pad; ++i) {
>  		format.pad = i;
>  
>  		format.format.width = cfg->width;
> @@ -135,60 +153,60 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
>  		format.format.field = V4L2_FIELD_NONE;
>  
> -		ret = v4l2_subdev_call(&bru->entity.subdev, pad,
> +		ret = v4l2_subdev_call(&pipe->bru->subdev, pad,
>  				       set_fmt, NULL, &format);
>  		if (ret < 0)
>  			return ret;
>  
> -		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on BRU pad %u\n",
> +		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
>  			__func__, format.format.width, format.format.height,
> -			format.format.code, i);
> +			format.format.code, bru_name, i);
>  	}
>  
> -	format.pad = bru->entity.source_pad;
> +	format.pad = pipe->bru->source_pad;
>  	format.format.width = cfg->width;
>  	format.format.height = cfg->height;
>  	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
>  	format.format.field = V4L2_FIELD_NONE;
>  
> -	ret = v4l2_subdev_call(&bru->entity.subdev, pad, set_fmt, NULL,
> +	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on BRU pad %u\n",
> +	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code, i);
> +		format.format.code, bru_name, i);
>  
>  	format.pad = RWPF_PAD_SINK;
> -	ret = v4l2_subdev_call(&vsp1->wpf[0]->entity.subdev, pad, set_fmt, NULL,
> +	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on WPF0 sink\n",
> +	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on WPF%u sink\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code);
> +		format.format.code, pipe->output->entity.index);
>  
>  	format.pad = RWPF_PAD_SOURCE;
> -	ret = v4l2_subdev_call(&vsp1->wpf[0]->entity.subdev, pad, get_fmt, NULL,
> +	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, get_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev, "%s: got format %ux%u (%x) on WPF0 source\n",
> +	dev_dbg(vsp1->dev, "%s: got format %ux%u (%x) on WPF%u source\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code);
> +		format.format.code, pipe->output->entity.index);
>  
>  	format.pad = LIF_PAD_SINK;
> -	ret = v4l2_subdev_call(&vsp1->lif[0]->entity.subdev, pad, set_fmt, NULL,
> +	ret = v4l2_subdev_call(&pipe->lif->subdev, pad, set_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on LIF sink\n",
> +	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on LIF%u sink\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code);
> +		format.format.code, pipe_index);
>  
>  	/*
>  	 * Verify that the format at the output of the pipeline matches the
> @@ -216,8 +234,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	 * Register a callback to allow us to notify the DRM driver of frame
>  	 * completion events.
>  	 */
> -	vsp1->drm->du_complete = cfg->callback;
> -	vsp1->drm->du_private = cfg->callback_data;
> +	drm_pipe->du_complete = cfg->callback;
> +	drm_pipe->du_private = cfg->callback_data;
>  
>  	ret = media_pipeline_start(&pipe->output->entity.subdev.entity,
>  					  &pipe->pipe);
> @@ -245,9 +263,9 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> -	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
> +	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
>  
> -	vsp1->drm->num_inputs = pipe->num_inputs;
> +	drm_pipe->enabled = drm_pipe->pipe.num_inputs != 0;
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
>  
> @@ -286,6 +304,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  			  const struct vsp1_du_atomic_config *cfg)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> +	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
>  	const struct vsp1_format_info *fmtinfo;
>  	struct vsp1_rwpf *rpf;
>  
> @@ -298,7 +317,12 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  		dev_dbg(vsp1->dev, "%s: RPF%u: disable requested\n", __func__,
>  			rpf_index);
>  
> -		vsp1->drm->inputs[rpf_index].enabled = false;
> +		/*
> +		 * Remove the RPF from the pipe's inputs. The atomic flush
> +		 * handler will disable the input and remove the entity from the
> +		 * pipe's entities list.
> +		 */
> +		drm_pipe->pipe.inputs[rpf_index] = NULL;
>  		return 0;
>  	}
>  
> @@ -334,13 +358,15 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  	vsp1->drm->inputs[rpf_index].crop = cfg->src;
>  	vsp1->drm->inputs[rpf_index].compose = cfg->dst;
>  	vsp1->drm->inputs[rpf_index].zpos = cfg->zpos;
> -	vsp1->drm->inputs[rpf_index].enabled = true;
> +
> +	drm_pipe->pipe.inputs[rpf_index] = rpf;
>  
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
>  
>  static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
> +				  struct vsp1_pipeline *pipe,
>  				  struct vsp1_rwpf *rpf, unsigned int bru_input)
>  {
>  	struct v4l2_subdev_selection sel;
> @@ -414,7 +440,7 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	/* BRU sink, propagate the format from the RPF source. */
>  	format.pad = bru_input;
>  
> -	ret = v4l2_subdev_call(&vsp1->bru->entity.subdev, pad, set_fmt, NULL,
> +	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
>  		return ret;
> @@ -427,8 +453,8 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	sel.target = V4L2_SEL_TGT_COMPOSE;
>  	sel.r = vsp1->drm->inputs[rpf->entity.index].compose;
>  
> -	ret = v4l2_subdev_call(&vsp1->bru->entity.subdev, pad, set_selection,
> -			       NULL, &sel);
> +	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_selection, NULL,
> +			       &sel);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -453,14 +479,20 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
>  void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> -	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
> +	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> +	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
>  	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
> +	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
>  	struct vsp1_entity *entity;
> +	struct vsp1_entity *next;
>  	struct vsp1_dl_list *dl;
> +	const char *bru_name;
>  	unsigned long flags;
>  	unsigned int i;
>  	int ret;
>  
> +	bru_name = pipe->bru->type == VSP1_ENTITY_BRU ? "BRU" : "BRS";
> +
>  	/* Prepare the display list. */
>  	dl = vsp1_dl_list_get(pipe->output->dlm);
>  
> @@ -471,12 +503,8 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  		struct vsp1_rwpf *rpf = vsp1->rpf[i];
>  		unsigned int j;
>  
> -		if (!vsp1->drm->inputs[i].enabled) {
> -			pipe->inputs[i] = NULL;
> +		if (!pipe->inputs[i])
>  			continue;
> -		}
> -
> -		pipe->inputs[i] = rpf;
>  
>  		/* Insert the RPF in the sorted RPFs array. */
>  		for (j = pipe->num_inputs++; j > 0; --j) {
> @@ -489,23 +517,26 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  	}
>  
>  	/* Setup the RPF input pipeline for every enabled input. */
> -	for (i = 0; i < vsp1->info->num_bru_inputs; ++i) {
> +	for (i = 0; i < pipe->bru->source_pad; ++i) {
>  		struct vsp1_rwpf *rpf = inputs[i];
>  
>  		if (!rpf) {
> -			vsp1->bru->inputs[i].rpf = NULL;
> +			bru->inputs[i].rpf = NULL;
>  			continue;
>  		}
>  
> -		vsp1->bru->inputs[i].rpf = rpf;
> +		if (list_empty(&rpf->entity.list_pipe))
> +			list_add_tail(&rpf->entity.list_pipe, &pipe->entities);
> +
> +		bru->inputs[i].rpf = rpf;
>  		rpf->bru_input = i;
> -		rpf->entity.sink = &vsp1->bru->entity;
> +		rpf->entity.sink = pipe->bru;
>  		rpf->entity.sink_pad = i;
>  
> -		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to BRU:%u\n",
> -			__func__, rpf->entity.index, i);
> +		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
> +			__func__, rpf->entity.index, bru_name, i);
>  
> -		ret = vsp1_du_setup_rpf_pipe(vsp1, rpf, i);
> +		ret = vsp1_du_setup_rpf_pipe(vsp1, pipe, rpf, i);
>  		if (ret < 0)
>  			dev_err(vsp1->dev,
>  				"%s: failed to setup RPF.%u\n",
> @@ -513,16 +544,16 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  	}
>  
>  	/* Configure all entities in the pipeline. */
> -	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> +	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
>  		/* Disconnect unused RPFs from the pipeline. */
> -		if (entity->type == VSP1_ENTITY_RPF) {
> -			struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
> +		if (entity->type == VSP1_ENTITY_RPF &&
> +		    !pipe->inputs[entity->index]) {
> +			vsp1_dl_list_write(dl, entity->route->reg,
> +					   VI6_DPR_NODE_UNUSED);
>  
> -			if (!pipe->inputs[rpf->entity.index]) {
> -				vsp1_dl_list_write(dl, entity->route->reg,
> -						   VI6_DPR_NODE_UNUSED);
> -				continue;
> -			}
> +			list_del_init(&entity->list_pipe);
> +
> +			continue;
>  		}
>  
>  		vsp1_entity_route_setup(entity, pipe, dl);
> @@ -540,11 +571,11 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  	vsp1_dl_list_commit(dl);
>  
>  	/* Start or stop the pipeline if needed. */
> -	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
> +	if (!drm_pipe->enabled && pipe->num_inputs) {
>  		spin_lock_irqsave(&pipe->irqlock, flags);
>  		vsp1_pipeline_run(pipe);
>  		spin_unlock_irqrestore(&pipe->irqlock, flags);
> -	} else if (vsp1->drm->num_inputs && !pipe->num_inputs) {
> +	} else if (drm_pipe->enabled && !pipe->num_inputs) {
>  		vsp1_pipeline_stop(pipe);
>  	}
>  }
> @@ -579,39 +610,46 @@ EXPORT_SYMBOL_GPL(vsp1_du_unmap_sg);
>  
>  int vsp1_drm_init(struct vsp1_device *vsp1)
>  {
> -	struct vsp1_pipeline *pipe;
>  	unsigned int i;
>  
>  	vsp1->drm = devm_kzalloc(vsp1->dev, sizeof(*vsp1->drm), GFP_KERNEL);
>  	if (!vsp1->drm)
>  		return -ENOMEM;
>  
> -	pipe = &vsp1->drm->pipe;
> +	/* Create one DRM pipeline per LIF. */
> +	for (i = 0; i < vsp1->info->lif_count; ++i) {
> +		struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[i];
> +		struct vsp1_pipeline *pipe = &drm_pipe->pipe;
>  
> -	vsp1_pipeline_init(pipe);
> +		vsp1_pipeline_init(pipe);
>  
> -	/* The DRM pipeline is static, add entities manually. */
> +		/*
> +		 * The DRM pipeline is static, add entities manually. The first
> +		 * pipeline uses the BRU and the second pipeline the BRS.
> +		 */
> +		pipe->bru = i == 0 ? &vsp1->bru->entity : &vsp1->brs->entity;
> +		pipe->lif = &vsp1->lif[i]->entity;
> +		pipe->output = vsp1->wpf[i];
> +		pipe->output->pipe = pipe;
> +		pipe->frame_end = vsp1_du_pipeline_frame_end;
> +
> +		pipe->bru->sink = &pipe->output->entity;
> +		pipe->bru->sink_pad = 0;
> +		pipe->output->entity.sink = pipe->lif;
> +		pipe->output->entity.sink_pad = 0;
> +
> +		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
> +		list_add_tail(&pipe->lif->list_pipe, &pipe->entities);
> +		list_add_tail(&pipe->output->entity.list_pipe, &pipe->entities);
> +	}
> +
> +	/* Disable all RPFs initially. */
>  	for (i = 0; i < vsp1->info->rpf_count; ++i) {
>  		struct vsp1_rwpf *input = vsp1->rpf[i];
>  
> -		list_add_tail(&input->entity.list_pipe, &pipe->entities);
> +		INIT_LIST_HEAD(&input->entity.list_pipe);
>  	}
>  
> -	vsp1->bru->entity.sink = &vsp1->wpf[0]->entity;
> -	vsp1->bru->entity.sink_pad = 0;
> -	vsp1->wpf[0]->entity.sink = &vsp1->lif[0]->entity;
> -	vsp1->wpf[0]->entity.sink_pad = 0;
> -
> -	list_add_tail(&vsp1->bru->entity.list_pipe, &pipe->entities);
> -	list_add_tail(&vsp1->wpf[0]->entity.list_pipe, &pipe->entities);
> -	list_add_tail(&vsp1->lif[0]->entity.list_pipe, &pipe->entities);
> -
> -	pipe->bru = &vsp1->bru->entity;
> -	pipe->lif = &vsp1->lif[0]->entity;
> -	pipe->output = vsp1->wpf[0];
> -	pipe->output->pipe = pipe;
> -	pipe->frame_end = vsp1_du_pipeline_frame_end;
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index 67d6549edfad..fca553ddd184 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -18,32 +18,41 @@
>  #include "vsp1_pipe.h"
>  
>  /**
> - * vsp1_drm - State for the API exposed to the DRM driver
> + * vsp1_drm_pipeline - State for the API exposed to the DRM driver
>   * @pipe: the VSP1 pipeline used for display
> - * @num_inputs: number of active pipeline inputs at the beginning of an update
> - * @inputs: source crop rectangle, destination compose rectangle and z-order
> - *	position for every input
> + * @enabled: pipeline state at the beginning of an update
>   * @du_complete: frame completion callback for the DU driver (optional)
>   * @du_private: data to be passed to the du_complete callback
>   */
> -struct vsp1_drm {
> +struct vsp1_drm_pipeline {
>  	struct vsp1_pipeline pipe;
> -	unsigned int num_inputs;
> +	bool enabled;
> +
> +	/* Frame synchronisation */
> +	void (*du_complete)(void *);
> +	void *du_private;
> +};
> +
> +/**
> + * vsp1_drm - State for the API exposed to the DRM driver
> + * @pipe: the VSP1 DRM pipeline used for display
> + * @inputs: source crop rectangle, destination compose rectangle and z-order
> + *	position for every input (indexed by RPF index)
> + */
> +struct vsp1_drm {
> +	struct vsp1_drm_pipeline pipe[VSP1_MAX_LIF];
> +
>  	struct {
> -		bool enabled;
>  		struct v4l2_rect crop;
>  		struct v4l2_rect compose;
>  		unsigned int zpos;
>  	} inputs[VSP1_MAX_RPF];
> -
> -	/* Frame synchronisation */
> -	void (*du_complete)(void *);
> -	void *du_private;
>  };
>  
> -static inline struct vsp1_drm *to_vsp1_drm(struct vsp1_pipeline *pipe)
> +static inline struct vsp1_drm_pipeline *
> +to_vsp1_drm_pipeline(struct vsp1_pipeline *pipe)
>  {
> -	return container_of(pipe, struct vsp1_drm, pipe);
> +	return container_of(pipe, struct vsp1_drm_pipeline, pipe);
>  }
>  
>  int vsp1_drm_init(struct vsp1_device *vsp1);
> 
