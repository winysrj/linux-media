Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58600 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbeC1OnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:43:17 -0400
Subject: Re: [PATCH 07/15] v4l: vsp1: Move DRM atomic commit pipeline setup to
 separate function
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-8-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <80250bdd-dda3-5a2f-02e8-1121197949f5@ideasonboard.com>
Date: Wed, 28 Mar 2018 15:43:13 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-8-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/02/18 21:45, Laurent Pinchart wrote:
> The DRM pipeline setup code used at atomic commit time is similar to the
> setup code used when enabling the pipeline. Move it to a separate
> function in order to share it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Assuming no hidden secret code addition in this code move that I haven't seen..

Only a minor nit below asking if the function should be pluralised (_inputs,
rather than _input)

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 347 +++++++++++++++++----------------
>  1 file changed, 180 insertions(+), 167 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 9a043a915c0b..7bf697ba7969 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -46,6 +46,185 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>   * Pipeline Configuration
>   */
>  
> +/* Setup one RPF and the connected BRU sink pad. */
> +static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
> +				      struct vsp1_pipeline *pipe,
> +				      struct vsp1_rwpf *rpf,
> +				      unsigned int bru_input)
> +{
> +	struct v4l2_subdev_selection sel;
> +	struct v4l2_subdev_format format;
> +	const struct v4l2_rect *crop;
> +	int ret;
> +
> +	/*
> +	 * Configure the format on the RPF sink pad and propagate it up to the
> +	 * BRU sink pad.
> +	 */
> +	crop = &vsp1->drm->inputs[rpf->entity.index].crop;
> +
> +	memset(&format, 0, sizeof(format));
> +	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	format.pad = RWPF_PAD_SINK;
> +	format.format.width = crop->width + crop->left;
> +	format.format.height = crop->height + crop->top;
> +	format.format.code = rpf->fmtinfo->mbus;
> +	format.format.field = V4L2_FIELD_NONE;
> +
> +	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_fmt, NULL,
> +			       &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(vsp1->dev,
> +		"%s: set format %ux%u (%x) on RPF%u sink\n",
> +		__func__, format.format.width, format.format.height,
> +		format.format.code, rpf->entity.index);
> +
> +	memset(&sel, 0, sizeof(sel));
> +	sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	sel.pad = RWPF_PAD_SINK;
> +	sel.target = V4L2_SEL_TGT_CROP;
> +	sel.r = *crop;
> +
> +	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_selection, NULL,
> +			       &sel);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(vsp1->dev,
> +		"%s: set selection (%u,%u)/%ux%u on RPF%u sink\n",
> +		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
> +		rpf->entity.index);
> +
> +	/*
> +	 * RPF source, hardcode the format to ARGB8888 to turn on format
> +	 * conversion if needed.
> +	 */
> +	format.pad = RWPF_PAD_SOURCE;
> +
> +	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, get_fmt, NULL,
> +			       &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(vsp1->dev,
> +		"%s: got format %ux%u (%x) on RPF%u source\n",
> +		__func__, format.format.width, format.format.height,
> +		format.format.code, rpf->entity.index);
> +
> +	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
> +
> +	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_fmt, NULL,
> +			       &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* BRU sink, propagate the format from the RPF source. */
> +	format.pad = bru_input;
> +
> +	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
> +			       &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
> +		__func__, format.format.width, format.format.height,
> +		format.format.code, BRU_NAME(pipe->bru), format.pad);
> +
> +	sel.pad = bru_input;
> +	sel.target = V4L2_SEL_TGT_COMPOSE;
> +	sel.r = vsp1->drm->inputs[rpf->entity.index].compose;
> +
> +	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_selection, NULL,
> +			       &sel);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(vsp1->dev, "%s: set selection (%u,%u)/%ux%u on %s pad %u\n",
> +		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
> +		BRU_NAME(pipe->bru), sel.pad);
> +
> +	return 0;
> +}
> +
> +static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
> +{
> +	return vsp1->drm->inputs[rpf->entity.index].zpos;
> +}
> +
> +/* Setup the input side of the pipeline (RPFs and BRU sink pads). */
> +static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,

Minor nit - shouldn't this be _setup_inputs(..)
as we could have multiple inputs, and it configures them all.


> +					struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
> +	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
> +	unsigned int i;
> +	int ret;
> +
> +	/* Count the number of enabled inputs and sort them by Z-order. */
> +	pipe->num_inputs = 0;
> +
> +	for (i = 0; i < vsp1->info->rpf_count; ++i) {
> +		struct vsp1_rwpf *rpf = vsp1->rpf[i];
> +		unsigned int j;
> +
> +		/*
> +		 * Make sure we don't accept more inputs than the hardware can
> +		 * handle. This is a temporary fix to avoid display stall, we
> +		 * need to instead allocate the BRU or BRS to display pipelines
> +		 * dynamically based on the number of planes they each use.
> +		 */
> +		if (pipe->num_inputs >= pipe->bru->source_pad)
> +			pipe->inputs[i] = NULL;
> +
> +		if (!pipe->inputs[i])
> +			continue;
> +
> +		/* Insert the RPF in the sorted RPFs array. */
> +		for (j = pipe->num_inputs++; j > 0; --j) {
> +			if (rpf_zpos(vsp1, inputs[j-1]) <= rpf_zpos(vsp1, rpf))
> +				break;
> +			inputs[j] = inputs[j-1];
> +		}
> +
> +		inputs[j] = rpf;
> +	}
> +
> +	/* Setup the RPF input pipeline for every enabled input. */
> +	for (i = 0; i < pipe->bru->source_pad; ++i) {
> +		struct vsp1_rwpf *rpf = inputs[i];
> +
> +		if (!rpf) {
> +			bru->inputs[i].rpf = NULL;
> +			continue;
> +		}
> +
> +		if (!rpf->entity.pipe) {
> +			rpf->entity.pipe = pipe;
> +			list_add_tail(&rpf->entity.list_pipe, &pipe->entities);
> +		}
> +
> +		bru->inputs[i].rpf = rpf;
> +		rpf->bru_input = i;
> +		rpf->entity.sink = pipe->bru;
> +		rpf->entity.sink_pad = i;
> +
> +		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
> +			__func__, rpf->entity.index, BRU_NAME(pipe->bru), i);
> +
> +		ret = vsp1_du_pipeline_setup_rpf(vsp1, pipe, rpf, i);
> +		if (ret < 0) {
> +			dev_err(vsp1->dev,
> +				"%s: failed to setup RPF.%u\n",
> +				__func__, rpf->entity.index);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /* Configure all entities in the pipeline. */
>  static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  {
> @@ -396,111 +575,6 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
>  
> -static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
> -				  struct vsp1_pipeline *pipe,
> -				  struct vsp1_rwpf *rpf, unsigned int bru_input)
> -{
> -	struct v4l2_subdev_selection sel;
> -	struct v4l2_subdev_format format;
> -	const struct v4l2_rect *crop;
> -	int ret;
> -
> -	/*
> -	 * Configure the format on the RPF sink pad and propagate it up to the
> -	 * BRU sink pad.
> -	 */
> -	crop = &vsp1->drm->inputs[rpf->entity.index].crop;
> -
> -	memset(&format, 0, sizeof(format));
> -	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	format.pad = RWPF_PAD_SINK;
> -	format.format.width = crop->width + crop->left;
> -	format.format.height = crop->height + crop->top;
> -	format.format.code = rpf->fmtinfo->mbus;
> -	format.format.field = V4L2_FIELD_NONE;
> -
> -	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_fmt, NULL,
> -			       &format);
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_dbg(vsp1->dev,
> -		"%s: set format %ux%u (%x) on RPF%u sink\n",
> -		__func__, format.format.width, format.format.height,
> -		format.format.code, rpf->entity.index);
> -
> -	memset(&sel, 0, sizeof(sel));
> -	sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	sel.pad = RWPF_PAD_SINK;
> -	sel.target = V4L2_SEL_TGT_CROP;
> -	sel.r = *crop;
> -
> -	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_selection, NULL,
> -			       &sel);
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_dbg(vsp1->dev,
> -		"%s: set selection (%u,%u)/%ux%u on RPF%u sink\n",
> -		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
> -		rpf->entity.index);
> -
> -	/*
> -	 * RPF source, hardcode the format to ARGB8888 to turn on format
> -	 * conversion if needed.
> -	 */
> -	format.pad = RWPF_PAD_SOURCE;
> -
> -	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, get_fmt, NULL,
> -			       &format);
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_dbg(vsp1->dev,
> -		"%s: got format %ux%u (%x) on RPF%u source\n",
> -		__func__, format.format.width, format.format.height,
> -		format.format.code, rpf->entity.index);
> -
> -	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
> -
> -	ret = v4l2_subdev_call(&rpf->entity.subdev, pad, set_fmt, NULL,
> -			       &format);
> -	if (ret < 0)
> -		return ret;
> -
> -	/* BRU sink, propagate the format from the RPF source. */
> -	format.pad = bru_input;
> -
> -	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
> -			       &format);
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
> -		__func__, format.format.width, format.format.height,
> -		format.format.code, BRU_NAME(pipe->bru), format.pad);
> -
> -	sel.pad = bru_input;
> -	sel.target = V4L2_SEL_TGT_COMPOSE;
> -	sel.r = vsp1->drm->inputs[rpf->entity.index].compose;
> -
> -	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_selection, NULL,
> -			       &sel);
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_dbg(vsp1->dev, "%s: set selection (%u,%u)/%ux%u on %s pad %u\n",
> -		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
> -		BRU_NAME(pipe->bru), sel.pad);
> -
> -	return 0;
> -}
> -
> -static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
> -{
> -	return vsp1->drm->inputs[rpf->entity.index].zpos;
> -}
> -
>  /**
>   * vsp1_du_atomic_flush - Commit an atomic update
>   * @dev: the VSP device
> @@ -511,69 +585,8 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
>  	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
> -	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
> -	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
> -	unsigned int i;
> -	int ret;
> -
> -	/* Count the number of enabled inputs and sort them by Z-order. */
> -	pipe->num_inputs = 0;
> -
> -	for (i = 0; i < vsp1->info->rpf_count; ++i) {
> -		struct vsp1_rwpf *rpf = vsp1->rpf[i];
> -		unsigned int j;
> -
> -		/*
> -		 * Make sure we don't accept more inputs than the hardware can
> -		 * handle. This is a temporary fix to avoid display stall, we
> -		 * need to instead allocate the BRU or BRS to display pipelines
> -		 * dynamically based on the number of planes they each use.
> -		 */
> -		if (pipe->num_inputs >= pipe->bru->source_pad)
> -			pipe->inputs[i] = NULL;
> -
> -		if (!pipe->inputs[i])
> -			continue;
> -
> -		/* Insert the RPF in the sorted RPFs array. */
> -		for (j = pipe->num_inputs++; j > 0; --j) {
> -			if (rpf_zpos(vsp1, inputs[j-1]) <= rpf_zpos(vsp1, rpf))
> -				break;
> -			inputs[j] = inputs[j-1];
> -		}
> -
> -		inputs[j] = rpf;
> -	}
> -
> -	/* Setup the RPF input pipeline for every enabled input. */
> -	for (i = 0; i < pipe->bru->source_pad; ++i) {
> -		struct vsp1_rwpf *rpf = inputs[i];
> -
> -		if (!rpf) {
> -			bru->inputs[i].rpf = NULL;
> -			continue;
> -		}
> -
> -		if (!rpf->entity.pipe) {
> -			rpf->entity.pipe = pipe;
> -			list_add_tail(&rpf->entity.list_pipe, &pipe->entities);
> -		}
> -
> -		bru->inputs[i].rpf = rpf;
> -		rpf->bru_input = i;
> -		rpf->entity.sink = pipe->bru;
> -		rpf->entity.sink_pad = i;
> -
> -		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
> -			__func__, rpf->entity.index, BRU_NAME(pipe->bru), i);
> -
> -		ret = vsp1_du_setup_rpf_pipe(vsp1, pipe, rpf, i);
> -		if (ret < 0)
> -			dev_err(vsp1->dev,
> -				"%s: failed to setup RPF.%u\n",
> -				__func__, rpf->entity.index);
> -	}
>  
> +	vsp1_du_pipeline_setup_input(vsp1, pipe);
>  	vsp1_du_pipeline_configure(pipe);
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
> 
