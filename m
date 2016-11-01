Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50147 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965966AbcKAMTG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2016 08:19:06 -0400
Subject: Re: [RFC 3/3] v4l: vsp1: Provide a writeback video device
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>
References: <1477576885-21978-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1477576885-21978-4-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <7a2f327e-ad38-ff74-f9e9-5c8197bae264@ideasonboard.com>
Date: Tue, 1 Nov 2016 12:19:00 +0000
MIME-Version: 1.0
In-Reply-To: <1477576885-21978-4-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks like I forgot to run checkpatch here, and it picked up a few things.

Please disregard them in your review, and they will be fixed for next
version.


On 27/10/16 15:01, Kieran Bingham wrote:
> When the VSP1 is used in an active display pipeline, the output of the
> WPF can supply the LIF entity directly and simultaneously write to
> memory.
> 
> Support this functionality in the VSP1 driver, by extending the WPF
> source pads, and establishing a V4L2 video device node connected to the
> new source.
> 
> The source will be able to perform pixel format conversion, but not
> rescaling, and as such the output from the memory node will always be
> of the same dimensions as the display output.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1.h       |   1 +
>  drivers/media/platform/vsp1/vsp1_drm.c   |  20 ++++
>  drivers/media/platform/vsp1/vsp1_drv.c   |   5 +-
>  drivers/media/platform/vsp1/vsp1_rwpf.c  |  15 ++-
>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
>  drivers/media/platform/vsp1/vsp1_video.c | 161 ++++++++++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_video.h |   5 +
>  drivers/media/platform/vsp1/vsp1_wpf.c   |  23 ++++-
>  8 files changed, 219 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
> index 85387a64179a..a2d462264312 100644
> --- a/drivers/media/platform/vsp1/vsp1.h
> +++ b/drivers/media/platform/vsp1/vsp1.h
> @@ -54,6 +54,7 @@ struct vsp1_uds;
>  #define VSP1_HAS_WPF_HFLIP	(1 << 6)
>  #define VSP1_HAS_HGO		(1 << 7)
>  #define VSP1_HAS_HGT		(1 << 8)
> +#define VSP1_HAS_WPF_WRITEBACK	(1 << 9)
>  
>  struct vsp1_device_info {
>  	u32 version;
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 0daf5f2c06e2..446188a06a92 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -27,6 +27,7 @@
>  #include "vsp1_lif.h"
>  #include "vsp1_pipe.h"
>  #include "vsp1_rwpf.h"
> +#include "vsp1_video.h"
>  
>  
>  /* -----------------------------------------------------------------------------
> @@ -479,6 +480,13 @@ void vsp1_du_atomic_flush(struct device *dev)
>  				__func__, rpf->entity.index);
>  	}
>  
> +	/*
> +	 * If we have a writeback node attached, we use this opportunity to
> +	 * update the video buffers.
> +	 */
> +	if (pipe->output->video && pipe->output->video->frame_end)
> +		pipe->output->video->frame_end(pipe);
> +
>  	/* Configure all entities in the pipeline. */
>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
>  		/* Disconnect unused RPFs from the pipeline. */
> @@ -590,6 +598,17 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
>  	if (ret < 0)
>  		return ret;
>  
> +	if (!(vsp1->info->features & VSP1_HAS_WPF_WRITEBACK))
> +		return 0;
> +
> +	/* Connect the video device to the WPF for Writeback support */
> +	ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
> +				    RWPF_PAD_SOURCE_WB,
> +				    &vsp1->wpf[0]->video->video.entity,
> +				    0, flags);
> +	if (ret < 0)
> +		return ret;
> +
>  	return 0;
>  }
>  
> @@ -620,6 +639,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  	pipe->bru = &vsp1->bru->entity;
>  	pipe->lif = &vsp1->lif->entity;
>  	pipe->output = vsp1->wpf[0];
> +	pipe->output->pipe = pipe;
>  
>  	return 0;
>  }
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 3b084976094b..42fa822b38d3 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -408,7 +408,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		vsp1->wpf[i] = wpf;
>  		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
>  
> -		if (vsp1->info->uapi) {
> +		if (vsp1->info->uapi || wpf->has_writeback) {
>  			struct vsp1_video *video = vsp1_video_create(vsp1, wpf);
>  
>  			if (IS_ERR(video)) {
> @@ -705,7 +705,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
>  		.model = "VSP2-D",
>  		.gen = 3,
> -		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP
> +			  | VSP1_HAS_WPF_WRITEBACK,
>  		.rpf_count = 5,
>  		.wpf_count = 2,
>  		.num_bru_inputs = 5,
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
> index 7deb6b9acf0b..7ad3ed097d50 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> @@ -83,9 +83,10 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
>  
>  	format = vsp1_entity_get_pad_format(&rwpf->entity, config, fmt->pad);
>  
> -	if (fmt->pad == RWPF_PAD_SOURCE) {
> +	if (fmt->pad == RWPF_PAD_SOURCE ||
> +	    fmt->pad == RWPF_PAD_SOURCE_WB) {
>  		/* The RWPF performs format conversion but can't scale, only the
> -		 * format code can be changed on the source pad.
> +		 * format code can be changed on the source pads.
>  		 */
>  		format->code = fmt->format.code;
>  		fmt->format = *format;
> @@ -113,11 +114,19 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
>  		crop->height = fmt->format.height;
>  	}
>  
> -	/* Propagate the format to the source pad. */
> +	/* Propagate the format to the source pads. */

s/Propagate/Propogate/ will be fixed in next version.

>  	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
>  					    RWPF_PAD_SOURCE);
>  	*format = fmt->format;
>  
> +	if (rwpf->has_writeback) {
> +		/* Propogate the format to the Writeback pad */

Likewise:
s/Propagate/Propogate/ will be fixed in next version.

> +		format = vsp1_entity_get_pad_format(&rwpf->entity, config,
> +				RWPF_PAD_SOURCE_WB);
> +
> +		*format = fmt->format;
> +	}
> +
>  	if (rwpf->flip.rotate) {
>  		format->width = fmt->format.height;
>  		format->height = fmt->format.width;
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index b4ffc38f48af..739088a009e8 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -24,6 +24,7 @@
>  
>  #define RWPF_PAD_SINK				0
>  #define RWPF_PAD_SOURCE				1
> +#define RWPF_PAD_SOURCE_WB			2
>  
>  struct v4l2_ctrl;
>  struct vsp1_dl_manager;
> @@ -53,6 +54,7 @@ struct vsp1_rwpf {
>  
>  	u32 mult_alpha;
>  	u32 outfmt;
> +	bool has_writeback;
>  
>  	struct {
>  		spinlock_t lock;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index f10401065cd3..68cef93117f9 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -81,11 +81,16 @@ static int vsp1_video_verify_format(struct vsp1_video *video)
>  	if (ret < 0)
>  		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
>  
> -	if (video->rwpf->fmtinfo->mbus != fmt.format.code ||
> -	    video->rwpf->format.height != fmt.format.height ||
> +	/* WPF entities can not perform any scaling action */
> +	if (video->rwpf->format.height != fmt.format.height ||
>  	    video->rwpf->format.width != fmt.format.width)
>  		return -EINVAL;
>  
> +	/* Unless we are in writeback mode, we must match the format as well */
> +	if (!video->is_writeback &&
> +	    video->rwpf->fmtinfo->mbus != fmt.format.code)
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> @@ -860,6 +865,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
>  	list_for_each_entry(buffer, &video->irqqueue, queue)
>  		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
>  	INIT_LIST_HEAD(&video->irqqueue);
> +	INIT_LIST_HEAD(&video->wbqueue);
>  	spin_unlock_irqrestore(&video->irqlock, flags);
>  }
>  
> @@ -873,6 +879,149 @@ static const struct vb2_ops vsp1_video_queue_qops = {
>  	.stop_streaming = vsp1_video_stop_streaming,
>  };
>  
> +
> +/* -----------------------------------------------------------------------------
> + * videobuf2 queue operations for writeback nodes
> + */
> +
> +static void vsp1_video_wb_process_buffer(struct vsp1_video *video)
> +{
> +	struct vsp1_vb2_buffer *buf;
> +	unsigned long flags;
> +
> +	/*
> +	 * Writeback uses a running stream, unlike the M2M interface which
> +	 * controls a pipeline process manually though the use of
> +	 * vsp1_pipeline_run().
> +	 *
> +	 * Instead writeback will commence at the next frame interval, and can
> +	 * be marked complete at the interval following that. To handle this we
> +	 * store the configured buffer as pending until the next callback.
> +	 *
> +	 * |    |    |    |    |
> +	 *  A   |<-->|
> +	 *       B   |<-->|
> +	 *            C   |<-->| : Only at interrupt C can A be marked done
> +	 */
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +
> +	/* Move the pending image to the active hw queue */
> +	if (video->pending) {
> +		list_add_tail(&video->pending->queue, &video->irqqueue);
> +		video->pending = NULL;
> +	}
> +
> +	buf = list_first_entry_or_null(&video->wbqueue, struct vsp1_vb2_buffer,
> +					queue);
> +
> +	if (buf) {
> +		video->rwpf->mem = buf->mem;
> +
> +		/* Store this buffer as pending. It will commence at the next
> +		 * frame start interrupt */
> +		video->pending = buf;
> +		list_del(&buf->queue);
> +	} else {
> +		/* Disable writeback with no buffer */
> +		video->rwpf->mem = (struct vsp1_rwpf_memory) { 0 };
> +	}
> +
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +}
> +
> +static void vsp1_video_wb_frame_end(struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_video *video = pipe->output->video;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pipe->irqlock, flags);
> +
> +	/* Complete any buffer on the IRQ queue */
> +	vsp1_video_complete_buffer(video);
> +
> +	/* Queue up any buffer from our wb queue, and place on the IRQ queue */
> +	vsp1_video_wb_process_buffer(video);
> +
> +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> +}
> +
> +static void vsp1_video_wb_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	list_add_tail(&buf->queue, &video->wbqueue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	return;

return statement not needed - will be removed.

> +}
> +
> +static int vsp1_video_wb_start_streaming(struct vb2_queue *vq,
> +		unsigned int count)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +	unsigned long flags;
> +
> +	/* Enable the completion interrupts */
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	video->frame_end = vsp1_video_wb_frame_end;
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	return 0;
> +}
> +
> +static void vsp1_video_wb_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +	struct vsp1_rwpf *rwpf = video->rwpf;
> +	struct vsp1_pipeline *pipe = rwpf->pipe;
> +	struct vsp1_vb2_buffer *buffer;
> +	unsigned long flags;
> +
> +	/*
> +	 * Disable the completion interrupts, and clear the WPF memory to
> +	 * prevent writing out frames
> +	 */
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	video->frame_end = NULL;
> +	rwpf->mem = (struct vsp1_rwpf_memory) { 0 };
> +
> +	/* Return all queued buffers to userspace */
> +	list_for_each_entry(buffer, &video->wbqueue, queue)
> +		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
> +	list_for_each_entry(buffer, &video->irqqueue, queue)
> +		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
> +	if (video->pending) {
> +		vb2_buffer_done(&video->pending->buf.vb2_buf,
> +				VB2_BUF_STATE_ERROR);
> +		video->pending = NULL;
> +	}
> +
> +	INIT_LIST_HEAD(&video->wbqueue);
> +	INIT_LIST_HEAD(&video->irqqueue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	/* Return the reference obtained by vsp1_video_streamon() */
> +	vsp1_video_pipeline_put(pipe);
> +
> +	return;

return statement not needed - will be removed.

> +}
> +
> +static const struct vb2_ops vsp1_video_wb_queue_qops = {
> +	.queue_setup = vsp1_video_queue_setup,
> +	.buf_prepare = vsp1_video_buffer_prepare,
> +	.buf_queue = vsp1_video_wb_buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = vsp1_video_wb_start_streaming,
> +	.stop_streaming = vsp1_video_wb_stop_streaming,
> +};
> +
> +
>  /* -----------------------------------------------------------------------------
>   * V4L2 ioctls
>   */
> @@ -1109,6 +1258,8 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  	video->vsp1 = vsp1;
>  	video->rwpf = rwpf;
>  
> +	video->is_writeback = rwpf->has_writeback;
> +
>  	if (rwpf->entity.type == VSP1_ENTITY_RPF) {
>  		direction = "input";
>  		video->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> @@ -1124,6 +1275,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  	mutex_init(&video->lock);
>  	spin_lock_init(&video->irqlock);
>  	INIT_LIST_HEAD(&video->irqqueue);
> +	INIT_LIST_HEAD(&video->wbqueue);
>  
>  	/* Initialize the media entity... */
>  	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
> @@ -1147,12 +1299,15 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  
>  	video_set_drvdata(&video->video, video);
>  
> +	if (video->is_writeback)
> +		video->queue.ops = &vsp1_video_wb_queue_qops;
> +	else
> +		video->queue.ops = &vsp1_video_queue_qops;
>  	video->queue.type = video->type;
>  	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>  	video->queue.lock = &video->lock;
>  	video->queue.drv_priv = video;
>  	video->queue.buf_struct_size = sizeof(struct vsp1_vb2_buffer);
> -	video->queue.ops = &vsp1_video_queue_qops;
>  	video->queue.mem_ops = &vb2_dma_contig_memops;
>  	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	video->queue.dev = video->vsp1->dev;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
> index 50ea7f02205f..b63e14bbaef0 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.h
> +++ b/drivers/media/platform/vsp1/vsp1_video.h
> @@ -48,6 +48,11 @@ struct vsp1_video {
>  	struct vb2_queue queue;
>  	spinlock_t irqlock;
>  	struct list_head irqqueue;
> +
> +	bool is_writeback;
> +	struct list_head wbqueue;
> +	struct vsp1_vb2_buffer *pending;
> +	void (*frame_end)(struct vsp1_pipeline *pipe);
>  };
>  
>  static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index b5f44d6839c6..fea0fd3e662e 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -248,6 +248,8 @@ static void wpf_configure(struct vsp1_entity *entity,
>  	u32 outfmt = 0;
>  	u32 srcrpf = 0;
>  
> +	bool writeback = pipe->lif && wpf->mem.addr[0];
> +
>  	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
>  		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
>  					| BIT(WPF_CTRL_HFLIP);
> @@ -299,7 +301,14 @@ static void wpf_configure(struct vsp1_entity *entity,
>  			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
>  			       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
>  
> -		if (pipe->lif)
> +		vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, writeback ?
> +						VI6_WPF_WRBCK_CTRL_WBMD : 0);
> +
> +		/*
> +		 * Display pipelines with no writeback memory do not configure
> +		 * the write out address
> +		 */
> +		if (pipe->lif && !writeback)
>  			return;
>  
>  		/*
> @@ -384,7 +393,7 @@ static void wpf_configure(struct vsp1_entity *entity,
>  	}
>  
>  	/* Format */
> -	if (!pipe->lif) {
> +	if (!pipe->lif || writeback) {
>  		const struct v4l2_pix_format_mplane *format = &wpf->format;
>  		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
>  
> @@ -424,8 +433,6 @@ static void wpf_configure(struct vsp1_entity *entity,
>  	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
>  			   VI6_DPR_WPF_FPORCH_FP_WPFN);
>  
> -	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
> -
>  	/* Sources. If the pipeline has a single input and BRU is not used,
>  	 * configure it as the master layer. Otherwise configure all
>  	 * inputs as sub-layers and select the virtual RPF as the master
> @@ -475,6 +482,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
>  {
>  	struct vsp1_rwpf *wpf;
>  	char name[6];
> +	int sink_pads;
>  	int ret;
>  
>  	wpf = devm_kzalloc(vsp1->dev, sizeof(*wpf), GFP_KERNEL);
> @@ -493,8 +501,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
>  	wpf->entity.type = VSP1_ENTITY_WPF;
>  	wpf->entity.index = index;
>  
> +	/* WPF's with Write back support can output to the LIF and Memory */
> +	wpf->has_writeback = (vsp1->info->features & VSP1_HAS_WPF_WRITEBACK)
> +			   && index == 0;
> +	sink_pads = wpf->has_writeback ? 2 : 1;
> +
>  	sprintf(name, "wpf.%u", index);
> -	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 1, 1, &wpf_ops,
> +	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 1, sink_pads, &wpf_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> 
