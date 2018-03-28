Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57845 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbeC1Nqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:46:36 -0400
Subject: Re: [PATCH 04/15] v4l: vsp1: Store pipeline pointer in vsp1_entity
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-5-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <61e47d2c-878d-b6ac-1469-6a31d16d82a1@ideasonboard.com>
Date: Wed, 28 Mar 2018 14:46:32 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-5-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the patch.

On 26/02/18 21:45, Laurent Pinchart wrote:
> Various types of objects subclassing vsp1_entity currently store a
> pointer to the pipeline. Move the pointer to vsp1_entity to simplify the
> code and avoid storing the pipeline in more entity subclasses later.

This certainly seems like a good improvement to make.

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Some terse diffstat there to get through - but it all looks good in the end.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_drm.c    | 20 +++++++++++++------
>  drivers/media/platform/vsp1/vsp1_drv.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_entity.h |  2 ++
>  drivers/media/platform/vsp1/vsp1_histo.c  |  2 +-
>  drivers/media/platform/vsp1/vsp1_histo.h  |  3 ---
>  drivers/media/platform/vsp1/vsp1_pipe.c   | 33 +++++++++----------------------
>  drivers/media/platform/vsp1/vsp1_rwpf.h   |  2 --
>  drivers/media/platform/vsp1/vsp1_video.c  | 17 +++++++---------
>  8 files changed, 34 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index a267f12f0cc8..a7ad85ab0b08 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -120,6 +120,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  			 * inputs.
>  			 */
>  			WARN_ON(list_empty(&rpf->entity.list_pipe));
> +			rpf->entity.pipe = NULL;

Aha - This reads confusingly as a diff ... because first it ensures the entity
is in a pipe with the WARN_ON, but then sets the pipe to NULL. But I'm going to
hazard a guess and say this is the (!cfg) section of the vsp1_du_setup_lif()
call...

/me checks.

Yes, of course it is... so that's fine.


>  			list_del_init(&rpf->entity.list_pipe);
>  			pipe->inputs[i] = NULL;
>  
> @@ -536,8 +537,10 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  			continue;
>  		}
>  
> -		if (list_empty(&rpf->entity.list_pipe))
> +		if (list_empty(&rpf->entity.list_pipe)) {
> +			rpf->entity.pipe = pipe;
>  			list_add_tail(&rpf->entity.list_pipe, &pipe->entities);
> +		}
>  
>  		bru->inputs[i].rpf = rpf;
>  		rpf->bru_input = i;
> @@ -562,6 +565,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  			vsp1_dl_list_write(dl, entity->route->reg,
>  					   VI6_DPR_NODE_UNUSED);
>  
> +			entity->pipe = NULL;
>  			list_del_init(&entity->list_pipe);
>  
>  			continue;
> @@ -625,24 +629,28 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  
>  		vsp1_pipeline_init(pipe);
>  
> +		pipe->frame_end = vsp1_du_pipeline_frame_end;
> +

Aha - just a code move - I was going to ask why this was here. That's fine.


>  		/*
>  		 * The DRM pipeline is static, add entities manually. The first
>  		 * pipeline uses the BRU and the second pipeline the BRS.
>  		 */
>  		pipe->bru = i == 0 ? &vsp1->bru->entity : &vsp1->brs->entity;
> -		pipe->lif = &vsp1->lif[i]->entity;
>  		pipe->output = vsp1->wpf[i];
> -		pipe->output->pipe = pipe;
> -		pipe->frame_end = vsp1_du_pipeline_frame_end;
> +		pipe->lif = &vsp1->lif[i]->entity;
>  
> +		pipe->bru->pipe = pipe;
>  		pipe->bru->sink = &pipe->output->entity;
>  		pipe->bru->sink_pad = 0;
> +		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
> +
> +		pipe->output->entity.pipe = pipe;

Ick ... pipe->bru->pipe, but pipe->output->entity.pipe ...
 BRU is already an entity, whereas output is an RPF.

A bit painful on the eyes for review - but nothing to be done there I don't think.




>  		pipe->output->entity.sink = pipe->lif;
>  		pipe->output->entity.sink_pad = 0;
> +		list_add_tail(&pipe->output->entity.list_pipe, &pipe->entities);
>  
> -		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
> +		pipe->lif->pipe = pipe;
>  		list_add_tail(&pipe->lif->list_pipe, &pipe->entities);
> -		list_add_tail(&pipe->output->entity.list_pipe, &pipe->entities);
>  	}
>  
>  	/* Disable all RPFs initially. */
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index eed9516e25e1..58a7993f2306 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -63,7 +63,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
>  		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status & mask);
>  
>  		if (status & VI6_WFP_IRQ_STA_DFE) {
> -			vsp1_pipeline_frame_end(wpf->pipe);
> +			vsp1_pipeline_frame_end(wpf->entity.pipe);
>  			ret = IRQ_HANDLED;
>  		}
>  	}
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index 408602ebeb97..c26523c56c05 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -106,6 +106,8 @@ struct vsp1_entity {
>  	unsigned int index;
>  	const struct vsp1_route *route;
>  
> +	struct vsp1_pipeline *pipe;
> +
>  	struct list_head list_dev;
>  	struct list_head list_pipe;
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
> index afab77cf4fa5..8638ebc514b4 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.c
> +++ b/drivers/media/platform/vsp1/vsp1_histo.c
> @@ -61,7 +61,7 @@ void vsp1_histogram_buffer_complete(struct vsp1_histogram *histo,
>  				    struct vsp1_histogram_buffer *buf,
>  				    size_t size)
>  {
> -	struct vsp1_pipeline *pipe = histo->pipe;
> +	struct vsp1_pipeline *pipe = histo->entity.pipe;
>  	unsigned long flags;
>  
>  	/*
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.h b/drivers/media/platform/vsp1/vsp1_histo.h
> index af2874f6031d..e774adbf251f 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.h
> +++ b/drivers/media/platform/vsp1/vsp1_histo.h
> @@ -25,7 +25,6 @@
>  #include "vsp1_entity.h"
>  
>  struct vsp1_device;
> -struct vsp1_pipeline;
>  
>  #define HISTO_PAD_SINK				0
>  #define HISTO_PAD_SOURCE			1
> @@ -37,8 +36,6 @@ struct vsp1_histogram_buffer {
>  };
>  
>  struct vsp1_histogram {
> -	struct vsp1_pipeline *pipe;
> -
>  	struct vsp1_entity entity;
>  	struct video_device video;
>  	struct media_pad pad;
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index 44944ac86d9b..99ccbac3256a 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -185,6 +185,7 @@ const struct vsp1_format_info *vsp1_get_format_info(struct vsp1_device *vsp1,
>  
>  void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
>  {
> +	struct vsp1_entity *entity;
>  	unsigned int i;
>  
>  	if (pipe->bru) {
> @@ -194,29 +195,13 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
>  			bru->inputs[i].rpf = NULL;
>  	}
>  
> -	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i) {
> -		if (pipe->inputs[i]) {
> -			pipe->inputs[i]->pipe = NULL;
> -			pipe->inputs[i] = NULL;
> -		}
> -	}
> -
> -	if (pipe->output) {
> -		pipe->output->pipe = NULL;
> -		pipe->output = NULL;
> -	}
> +	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i)
> +		pipe->inputs[i] = NULL;
>  
> -	if (pipe->hgo) {
> -		struct vsp1_hgo *hgo = to_hgo(&pipe->hgo->subdev);
> +	pipe->output = NULL;
>  
> -		hgo->histo.pipe = NULL;
> -	}
> -
> -	if (pipe->hgt) {
> -		struct vsp1_hgt *hgt = to_hgt(&pipe->hgt->subdev);
> -
> -		hgt->histo.pipe = NULL;
> -	}
> +	list_for_each_entry(entity, &pipe->entities, list_pipe)
> +		entity->pipe = NULL;

Excellent - looks like that got cleaned up somewhat thanks to this change.


>  
>  	INIT_LIST_HEAD(&pipe->entities);
>  	pipe->state = VSP1_PIPELINE_STOPPED;
> @@ -423,7 +408,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
>  		if (wpf == NULL)
>  			continue;
>  
> -		pipe = wpf->pipe;
> +		pipe = wpf->entity.pipe;
>  		if (pipe == NULL)
>  			continue;
>  
> @@ -440,7 +425,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
>  		if (wpf == NULL)
>  			continue;
>  
> -		pipe = wpf->pipe;
> +		pipe = wpf->entity.pipe;
>  		if (pipe == NULL)
>  			continue;
>  
> @@ -465,7 +450,7 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
>  		if (wpf == NULL)
>  			continue;
>  
> -		pipe = wpf->pipe;
> +		pipe = wpf->entity.pipe;
>  		if (pipe == NULL)
>  			continue;
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index 58215a7ab631..c94ac89abfa7 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -27,7 +27,6 @@
>  
>  struct v4l2_ctrl;
>  struct vsp1_dl_manager;
> -struct vsp1_pipeline;
>  struct vsp1_rwpf;
>  struct vsp1_video;
>  
> @@ -39,7 +38,6 @@ struct vsp1_rwpf {
>  	struct vsp1_entity entity;
>  	struct v4l2_ctrl_handler ctrls;
>  
> -	struct vsp1_pipeline *pipe;
>  	struct vsp1_video *video;
>  
>  	unsigned int max_width;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index c2d3b8f0f487..cdd53d6cc408 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -324,7 +324,7 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
>  static struct vsp1_vb2_buffer *
>  vsp1_video_complete_buffer(struct vsp1_video *video)
>  {
> -	struct vsp1_pipeline *pipe = video->rwpf->pipe;
> +	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
>  	struct vsp1_vb2_buffer *next = NULL;
>  	struct vsp1_vb2_buffer *done;
>  	unsigned long flags;
> @@ -598,20 +598,19 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
>  		subdev = media_entity_to_v4l2_subdev(entity);
>  		e = to_vsp1_entity(subdev);
>  		list_add_tail(&e->list_pipe, &pipe->entities);
> +		e->pipe = pipe;
>  
>  		switch (e->type) {
>  		case VSP1_ENTITY_RPF:
>  			rwpf = to_rwpf(subdev);
>  			pipe->inputs[rwpf->entity.index] = rwpf;
>  			rwpf->video->pipe_index = ++pipe->num_inputs;
> -			rwpf->pipe = pipe;
>  			break;
>  
>  		case VSP1_ENTITY_WPF:
>  			rwpf = to_rwpf(subdev);
>  			pipe->output = rwpf;
>  			rwpf->video->pipe_index = 0;
> -			rwpf->pipe = pipe;
>  			break;
>  
>  		case VSP1_ENTITY_LIF:
> @@ -625,12 +624,10 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
>  
>  		case VSP1_ENTITY_HGO:
>  			pipe->hgo = e;
> -			to_hgo(subdev)->histo.pipe = pipe;
>  			break;
>  
>  		case VSP1_ENTITY_HGT:
>  			pipe->hgt = e;
> -			to_hgt(subdev)->histo.pipe = pipe;
>  			break;
>  
>  		default:
> @@ -682,7 +679,7 @@ static struct vsp1_pipeline *vsp1_video_pipeline_get(struct vsp1_video *video)
>  	 * Otherwise allocate a new pipeline and initialize it, it will be freed
>  	 * when the last reference is released.
>  	 */
> -	if (!video->rwpf->pipe) {
> +	if (!video->rwpf->entity.pipe) {
>  		pipe = kzalloc(sizeof(*pipe), GFP_KERNEL);
>  		if (!pipe)
>  			return ERR_PTR(-ENOMEM);
> @@ -694,7 +691,7 @@ static struct vsp1_pipeline *vsp1_video_pipeline_get(struct vsp1_video *video)
>  			return ERR_PTR(ret);
>  		}
>  	} else {
> -		pipe = video->rwpf->pipe;
> +		pipe = video->rwpf->entity.pipe;
>  		kref_get(&pipe->kref);
>  	}
>  
> @@ -777,7 +774,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
>  {
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
> -	struct vsp1_pipeline *pipe = video->rwpf->pipe;
> +	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
>  	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
>  	unsigned long flags;
>  	bool empty;
> @@ -872,7 +869,7 @@ static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
>  static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>  	struct vsp1_video *video = vb2_get_drv_priv(vq);
> -	struct vsp1_pipeline *pipe = video->rwpf->pipe;
> +	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
>  	bool start_pipeline = false;
>  	unsigned long flags;
>  	int ret;
> @@ -913,7 +910,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
>  static void vsp1_video_stop_streaming(struct vb2_queue *vq)
>  {
>  	struct vsp1_video *video = vb2_get_drv_priv(vq);
> -	struct vsp1_pipeline *pipe = video->rwpf->pipe;
> +	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
>  	unsigned long flags;
>  	int ret;
>  
> 
