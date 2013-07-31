Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:34308 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3GaVCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 17:02:10 -0400
Message-ID: <51F97B4D.70305@gmail.com>
Date: Wed, 31 Jul 2013 23:02:05 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH v4 5/7] v4l: Renesas R-Car VSP1 driver
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375285954-32153-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375285954-32153-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

just a few small remarks...

On 07/31/2013 05:52 PM, Laurent Pinchart wrote:
> The VSP1 is a video processing engine that includes a blender, scalers,
> filters and statistics computation. Configurable data path routing logic
> allows ordering the internal blocks in a flexible way.
>
> Due to the configurable nature of the pipeline the driver implements the
> media controller API and doesn't use the V4L2 mem-to-mem framework, even
> though the device usually operates in memory to memory mode.
>
> Only the read pixel formatters, up/down scalers, write pixel formatters
> and LCDC interface are supported at this stage.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart+renesas@ideasonboard.com>
>
> Changes since v1:
>
> - Updated to the v3.11 media controller API changes
> - Only add the LIF entity to the entities list when the LIF is present
> - Added a MODULE_ALIAS()
> - Fixed file descriptions in comment blocks
> - Removed function prototypes for the unimplemented destroy functions
> - Fixed a typo in the HST register name
> - Fixed format propagation for the UDS entities
> - Added v4l2_capability::device_caps support
> - Prefix the device name with "platform:" in bus_info
> - Zero the v4l2_pix_format priv field in the internal try format handler
> - Use vb2_is_busy() instead of vb2_is_streaming() when setting the
>    format
> - Use the vb2_ioctl_* handlers where possible
> - Fix register macros that were missing a n argument
> - Mask unused bits when clearing the interrupt status register
> - Explain why stride alignment to 128 bytes is needed
> - Use the aligned stride value when computing the image size
> - Assorted cosmetic changes
> ---
>   drivers/media/platform/Kconfig            |   10 +
>   drivers/media/platform/Makefile           |    2 +
>   drivers/media/platform/vsp1/Makefile      |    5 +
>   drivers/media/platform/vsp1/vsp1.h        |   73 ++
>   drivers/media/platform/vsp1/vsp1_drv.c    |  497 +++++++++++++
>   drivers/media/platform/vsp1/vsp1_entity.c |  181 +++++
>   drivers/media/platform/vsp1/vsp1_entity.h |   68 ++
>   drivers/media/platform/vsp1/vsp1_lif.c    |  238 ++++++
>   drivers/media/platform/vsp1/vsp1_lif.h    |   37 +
>   drivers/media/platform/vsp1/vsp1_regs.h   |  581 +++++++++++++++
>   drivers/media/platform/vsp1/vsp1_rpf.c    |  209 ++++++
>   drivers/media/platform/vsp1/vsp1_rwpf.c   |  124 ++++
>   drivers/media/platform/vsp1/vsp1_rwpf.h   |   53 ++
>   drivers/media/platform/vsp1/vsp1_uds.c    |  346 +++++++++
>   drivers/media/platform/vsp1/vsp1_uds.h    |   40 +
>   drivers/media/platform/vsp1/vsp1_video.c  | 1135 +++++++++++++++++++++++++++++
>   drivers/media/platform/vsp1/vsp1_video.h  |  144 ++++
>   drivers/media/platform/vsp1/vsp1_wpf.c    |  233 ++++++
>   include/linux/platform_data/vsp1.h        |   25 +
>   19 files changed, 4001 insertions(+)
>   create mode 100644 drivers/media/platform/vsp1/Makefile
>   create mode 100644 drivers/media/platform/vsp1/vsp1.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
>   create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
>   create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
>   create mode 100644 include/linux/platform_data/vsp1.h
>
[...]
> +/* -----------------------------------------------------------------------------
> + * Platform Driver
> + */
[...]
> +static int vsp1_probe(struct platform_device *pdev)
> +{
> +	struct vsp1_device *vsp1;
> +	struct resource *irq;
> +	struct resource *io;
> +	int ret;
> +
> +	vsp1 = devm_kzalloc(&pdev->dev, sizeof(*vsp1), GFP_KERNEL);
> +	if (vsp1 == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate private data\n");

k*alloc already log any errors, hence this line could be dropped. I've
seen patches removing such logging.

> +		return -ENOMEM;
> +	}
> +
> +	vsp1->dev =&pdev->dev;
> +	mutex_init(&vsp1->lock);
> +	INIT_LIST_HEAD(&vsp1->entities);
> +
> +	vsp1->pdata = vsp1_get_platform_data(pdev);
> +	if (vsp1->pdata == NULL)
> +		return -ENODEV;
> +
> +	/* I/O, IRQ and clock resources */
> +	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +
> +	if (!io || !irq) {
> +		dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
> +		return -EINVAL;
> +	}
> +
> +	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
> +	if (IS_ERR((void *)vsp1->mmio)) {
> +		dev_err(&pdev->dev, "failed to remap memory resource\n");

Similarly devm_ioremap_resource() already logs any errors, including 
checking
if the second argument is valid.

> +		return PTR_ERR((void *)vsp1->mmio);
> +	}
> +
> +	vsp1->clock = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(vsp1->clock)) {
> +		dev_err(&pdev->dev, "failed to get clock\n");
> +		return PTR_ERR(vsp1->clock);
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, irq->start, vsp1_irq_handler,
> +			      IRQF_SHARED, dev_name(&pdev->dev), vsp1);
> +	if (ret<  0) {
> +		dev_err(&pdev->dev, "failed to request IRQ\n");
> +		return ret;
> +	}
> +
> +	/* Instanciate entities */
> +	ret = vsp1_create_entities(vsp1);
> +	if (ret<  0) {
> +		dev_err(&pdev->dev, "failed to create entities\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, vsp1);
> +
> +	return 0;
> +}
> +
[...]
> +/* -----------------------------------------------------------------------------
> + * Initialization and Cleanup
> + */
> +
> +struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
> +{
> +	struct v4l2_subdev *subdev;
> +	struct vsp1_lif *lif;
> +	int ret;
> +
> +	lif = devm_kzalloc(vsp1->dev, sizeof(*lif), GFP_KERNEL);
> +	if (lif == NULL)
> +		return ERR_PTR(-ENOMEM);
> +
> +	lif->entity.type = VSP1_ENTITY_LIF;
> +	lif->entity.id = VI6_DPR_NODE_LIF;
> +
> +	ret = vsp1_entity_init(vsp1,&lif->entity, 2);
> +	if (ret<  0)
> +		return ERR_PTR(ret);
> +
> +	/* Initialize the V4L2 subdev. */
> +	subdev =&lif->entity.subdev;
> +	v4l2_subdev_init(subdev,&lif_ops);
> +
> +	subdev->entity.ops =&vsp1_media_ops;
> +	subdev->internal_ops =&vsp1_subdev_internal_ops;
> +	snprintf(subdev->name, sizeof(subdev->name), "%s lif",
> +		 dev_name(vsp1->dev));

Using dev_name() looks reasonable since it guarantees the subdev names
are unique. But for dt and non-dt boot you will get different device
names. Not sure if it would have been really an issue though.

> +	v4l2_set_subdevdata(subdev, lif);
> +	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	vsp1_entity_init_formats(subdev, NULL);
> +
> +	return lif;
> +}
[...]
> +static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_entity *entity;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&pipe->irqlock, flags);
> +	pipe->state = VSP1_PIPELINE_STOPPING;
> +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> +
> +	ret = wait_event_timeout(pipe->wq, pipe->state == VSP1_PIPELINE_STOPPED,
> +				 msecs_to_jiffies(500));
> +	ret = ret == 0 ? -ETIMEDOUT : 0;

Wouldn't be -ETIME more appropriate ?

#define	ETIME		62	/* Timer expired */
...
#define	ETIMEDOUT	110	/* Connection timed out */


> +	list_for_each_entry(entity,&pipe->entities, list_pipe) {
> +		if (entity->route)
> +			vsp1_write(entity->vsp1, entity->route,
> +				   VI6_DPR_NODE_UNUSED);
> +
> +		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
> +	}
> +
> +	return ret;
> +}
[...]
> +/* -----------------------------------------------------------------------------
> + * videobuf2 Queue Operations
> + */
> +
> +static int
> +vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> +		     unsigned int *nbuffers, unsigned int *nplanes,
> +		     unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +	struct v4l2_pix_format_mplane *format =&video->format;
> +	unsigned int i;

If you don't support VIDIOC_CREATE_BUFS ioctl then there should probably
be at least something like:

	if (fmt)
		return -EINVAL;

But it's likely better to add proper handling of 'fmt' right away.

> +	*nplanes = format->num_planes;
> +
> +	for (i = 0; i<  format->num_planes; ++i) {
> +		sizes[i] = format->plane_fmt[i].sizeimage;
> +		alloc_ctxs[i] = video->alloc_ctx;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
> +	unsigned int i;
> +
> +	buf->video = video;
> +
> +	for (i = 0; i<  vb->num_planes; ++i) {
> +		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
> +		buf->length[i] = vb2_plane_size(vb, i);
> +	}
> +
> +	return 0;
> +}
> +
> +static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
> +	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
> +	unsigned long flags;
> +	bool empty;
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	empty = list_empty(&video->irqqueue);
> +	list_add_tail(&buf->queue,&video->irqqueue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	if (!empty)
> +		return;
> +
> +	spin_lock_irqsave(&pipe->irqlock, flags);
> +
> +	video->ops->queue(video, buf);
> +	pipe->buffers_ready |= 1<<  video->pipe_index;
> +
> +	if (vb2_is_streaming(&video->queue)&&
> +	    vsp1_pipeline_ready(pipe))
> +		vsp1_pipeline_run(pipe);
> +
> +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> +}
> +
> +static void vsp1_video_wait_prepare(struct vb2_queue *vq)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +
> +	mutex_unlock(&video->lock);
> +}
> +
> +static void vsp1_video_wait_finish(struct vb2_queue *vq)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +
> +	mutex_lock(&video->lock);
> +}
> +
> +static void vsp1_entity_route_setup(struct vsp1_entity *source)
> +{
> +	struct vsp1_entity *sink;
> +
> +	if (source->route == 0)
> +		return;
> +
> +	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
> +	vsp1_write(source->vsp1, source->route, sink->id);
> +}
> +
> +static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
> +	struct vsp1_entity *entity;
> +	unsigned long flags;
> +	int ret;
> +
> +	mutex_lock(&pipe->lock);
> +	if (pipe->stream_count == pipe->num_video - 1) {
> +		list_for_each_entry(entity,&pipe->entities, list_pipe) {
> +			vsp1_entity_route_setup(entity);
> +
> +			ret = v4l2_subdev_call(&entity->subdev, video,
> +					       s_stream, 1);
> +			if (ret<  0) {
> +				mutex_unlock(&pipe->lock);
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	pipe->stream_count++;
> +	mutex_unlock(&pipe->lock);
> +
> +	spin_lock_irqsave(&pipe->irqlock, flags);
> +	if (vsp1_pipeline_ready(pipe))
> +		vsp1_pipeline_run(pipe);
> +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> +
> +	return 0;
> +}
> +
> +static int vsp1_video_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
> +	unsigned long flags;
> +	int ret;
> +
> +	mutex_lock(&pipe->lock);
> +	if (--pipe->stream_count == 0) {
> +		/* Stop the pipeline. */
> +		ret = vsp1_pipeline_stop(pipe);
> +		if (ret == -ETIMEDOUT)

ETIME ?

> +			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
> +	}
> +	mutex_unlock(&pipe->lock);
> +
> +	vsp1_pipeline_cleanup(pipe);
> +	media_entity_pipeline_stop(&video->video.entity);
> +
> +	/* Remove all buffers from the IRQ queue. */
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	INIT_LIST_HEAD(&video->irqqueue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops vsp1_video_queue_qops = {
> +	.queue_setup = vsp1_video_queue_setup,
> +	.buf_prepare = vsp1_video_buffer_prepare,
> +	.buf_queue = vsp1_video_buffer_queue,
> +	.wait_prepare = vsp1_video_wait_prepare,
> +	.wait_finish = vsp1_video_wait_finish,
> +	.start_streaming = vsp1_video_start_streaming,
> +	.stop_streaming = vsp1_video_stop_streaming,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
[...]
> +static int __vsp1_video_try_format(struct vsp1_video *video,
> +				   struct v4l2_pix_format_mplane *pix,
> +				   const struct vsp1_format_info **fmtinfo)
> +{
> +	const struct vsp1_format_info *info;
> +	unsigned int width = pix->width;
> +	unsigned int height = pix->height;
> +	unsigned int i;
> +
> +	/* Retrieve format information and select the default format if the
> +	 * requested format isn't supported.
> +	 */

Nitpicking: Isn't proper multi-line comment style

	/*
	 * Retrieve format information and select the default format if the
	 * requested format isn't supported.
	 */

? In fact the media subsystem code is pretty messy WRT that detail.

> +	info = vsp1_get_format_info(pix->pixelformat);
> +	if (info == NULL)
> +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> +
> +	pix->pixelformat = info->fourcc;
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> +	pix->field = V4L2_FIELD_NONE;
> +	memset(pix->reserved, 0, sizeof(pix->reserved));
> +
> +	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
> +	width = round_down(width, info->hsub);
> +	height = round_down(height, info->vsub);
> +
> +	/* Clamp the width and height. */
> +	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, VSP1_VIDEO_MAX_WIDTH);
> +	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
> +			    VSP1_VIDEO_MAX_HEIGHT);
> +
> +	/* Compute and clamp the stride and image size. While not documented in
> +	 * the datasheet, strides not aligned to a multiple of 128 bytes result
> +	 * in image corruption.
> +	 */
> +	for (i = 0; i<  max(info->planes, 2U); ++i) {
> +		unsigned int hsub = i>  0 ? info->hsub : 1;
> +		unsigned int vsub = i>  0 ? info->vsub : 1;
> +		unsigned int align = 128;
> +		unsigned int bpl;
> +
> +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> +			      pix->width / hsub * info->bpp[i] / 8,
> +			      round_down(65535U, align));
> +
> +		pix->plane_fmt[i].bytesperline = round_up(bpl, align);
> +		pix->plane_fmt[i].sizeimage = pix->plane_fmt[i].bytesperline
> +					    * pix->height / vsub;
> +	}
> +
> +	if (info->planes == 3) {
> +		/* The second and third planes must have the same stride. */
> +		pix->plane_fmt[2].bytesperline = pix->plane_fmt[1].bytesperline;
> +		pix->plane_fmt[2].sizeimage = pix->plane_fmt[1].sizeimage;
> +	}
> +
> +	pix->num_planes = info->planes;
> +
> +	if (fmtinfo)
> +		*fmtinfo = info;
> +
> +	return 0;
> +}
> +

Regards,
Sylwester
