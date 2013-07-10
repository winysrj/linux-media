Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:50329 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3GJMey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 08:34:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH 5/5] v4l: Renesas R-Car VSP1 driver
Date: Wed, 10 Jul 2013 14:34:24 +0200
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
References: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1373451572-3892-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1373451572-3892-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307101434.25019.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 10 July 2013 12:19:32 Laurent Pinchart wrote:
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
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/Kconfig            |   10 +
>  drivers/media/platform/Makefile           |    2 +
>  drivers/media/platform/vsp1/Makefile      |    5 +
>  drivers/media/platform/vsp1/vsp1.h        |   73 ++
>  drivers/media/platform/vsp1/vsp1_drv.c    |  475 ++++++++++++
>  drivers/media/platform/vsp1/vsp1_entity.c |  186 +++++
>  drivers/media/platform/vsp1/vsp1_entity.h |   68 ++
>  drivers/media/platform/vsp1/vsp1_lif.c    |  237 ++++++
>  drivers/media/platform/vsp1/vsp1_lif.h    |   38 +
>  drivers/media/platform/vsp1/vsp1_regs.h   |  581 +++++++++++++++
>  drivers/media/platform/vsp1/vsp1_rpf.c    |  209 ++++++
>  drivers/media/platform/vsp1/vsp1_rwpf.c   |  124 ++++
>  drivers/media/platform/vsp1/vsp1_rwpf.h   |   56 ++
>  drivers/media/platform/vsp1/vsp1_uds.c    |  346 +++++++++
>  drivers/media/platform/vsp1/vsp1_uds.h    |   41 +
>  drivers/media/platform/vsp1/vsp1_video.c  | 1154 +++++++++++++++++++++++++++++
>  drivers/media/platform/vsp1/vsp1_video.h  |  144 ++++
>  drivers/media/platform/vsp1/vsp1_wpf.c    |  233 ++++++
>  include/linux/platform_data/vsp1.h        |   25 +
>  19 files changed, 4007 insertions(+)
>  create mode 100644 drivers/media/platform/vsp1/Makefile
>  create mode 100644 drivers/media/platform/vsp1/vsp1.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
>  create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
>  create mode 100644 include/linux/platform_data/vsp1.h
> 

Hi Laurent,

It took some effort, but I finally did find some things to complain about :-)

> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> new file mode 100644
> index 0000000..47a739a
> --- /dev/null
> +++ b/drivers/media/platform/vsp1/vsp1_video.c

...

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
> +	struct v4l2_pix_format_mplane *format = &video->format;
> +	unsigned int i;
> +
> +	*nplanes = format->num_planes;
> +
> +	for (i = 0; i < format->num_planes; ++i) {
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
> +	for (i = 0; i < vb->num_planes; ++i) {
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
> +	list_add_tail(&buf->queue, &video->irqqueue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	if (empty) {
> +		spin_lock_irqsave(&pipe->irqlock, flags);
> +
> +		video->ops->queue(video, buf);
> +		pipe->buffers_ready |= 1 << video->pipe_index;
> +
> +		if (vb2_is_streaming(&video->queue) &&
> +		    vsp1_pipeline_ready(pipe))
> +			vsp1_pipeline_run(pipe);
> +
> +		spin_unlock_irqrestore(&pipe->irqlock, flags);
> +	}
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
> +		list_for_each_entry(entity, &pipe->entities, list_pipe) {
> +			vsp1_entity_route_setup(entity);
> +
> +			ret = v4l2_subdev_call(&entity->subdev, video,
> +					       s_stream, 1);
> +			if (ret < 0) {
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
> +
> +static int
> +vsp1_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE_MPLANE
> +				  | V4L2_CAP_STREAMING;
> +	else
> +		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT_MPLANE
> +				  | V4L2_CAP_STREAMING;

cap->device_caps should be filled in here as well.

> +
> +	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
> +	strlcpy(cap->card, video->video.name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));

The bus_info for platform devices should be prefixed with "platform:" as
per the spec.

> +
> +	return 0;
> +}
> +
> +static int
> +vsp1_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +
> +	if (format->type != video->queue.type)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->lock);
> +	format->fmt.pix_mp = video->format;
> +	mutex_unlock(&video->lock);
> +
> +	return 0;
> +}
> +
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
> +	info = vsp1_get_format_info(pix->pixelformat);
> +	if (info == NULL)
> +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> +
> +	pix->pixelformat = info->fourcc;
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> +	pix->field = V4L2_FIELD_NONE;

pix->priv should be set to 0. v4l2-compliance catches such errors, BTW.

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
> +	/* Compute and clamp the stride and image size. */
> +	for (i = 0; i < max(info->planes, 2U); ++i) {
> +		unsigned int hsub = i > 0 ? info->hsub : 1;
> +		unsigned int vsub = i > 0 ? info->vsub : 1;
> +		unsigned int bpl;
> +
> +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> +			      pix->width / hsub * info->bpp[i] / 8,
> +			      round_down(65535U, 128));
> +
> +		pix->plane_fmt[i].bytesperline = round_up(bpl, 128);
> +		pix->plane_fmt[i].sizeimage = bpl * pix->height / vsub;
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
> +static int
> +vsp1_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +
> +	if (format->type != video->queue.type)
> +		return -EINVAL;
> +
> +	return __vsp1_video_try_format(video, &format->fmt.pix_mp, NULL);
> +}
> +
> +static int
> +vsp1_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	const struct vsp1_format_info *info;
> +	int ret;
> +
> +	if (format->type != video->queue.type)
> +		return -EINVAL;
> +
> +	ret = __vsp1_video_try_format(video, &format->fmt.pix_mp, &info);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&video->lock);
> +
> +	if (vb2_is_streaming(&video->queue)) {

That should be vb2_is_busy(): once buffers are allocated you can't change the
format anymore.

> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	video->format = format->fmt.pix_mp;
> +	video->fmtinfo = info;
> +
> +done:
> +	mutex_unlock(&video->lock);
> +	return ret;
> +}
> +
> +static int
> +vsp1_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +
> +	if (video->queue.owner && video->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_reqbufs(&video->queue, rb);
> +	if (ret < 0)
> +		goto done;
> +
> +	video->queue.owner = vfh;
> +
> +done:
> +	mutex_unlock(&video->lock);
> +	return ret ? ret : rb->count;

On success reqbufs should return 0, not the number of allocated buffers.

Have you considered using the vb2 helper functions in videobuf2-core.c? They
take care of the queue ownership and often simplify drivers considerably.

> +}
> +
> +static int
> +vsp1_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +	ret = vb2_querybuf(&video->queue, buf);
> +	mutex_unlock(&video->lock);
> +
> +	return ret;
> +}
> +
> +static int
> +vsp1_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +
> +	if (video->queue.owner && video->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_qbuf(&video->queue, buf);
> +
> +done:
> +	mutex_unlock(&video->lock);
> +	return ret;
> +}
> +
> +static int
> +vsp1_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +
> +	if (video->queue.owner && video->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_dqbuf(&video->queue, buf, file->f_flags & O_NONBLOCK);
> +
> +done:
> +	mutex_unlock(&video->lock);
> +	return ret;
> +}
> +
> +static int
> +vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	struct vsp1_pipeline *pipe;
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +
> +	if (video->queue.owner && video->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto err_unlock;
> +	}
> +
> +	video->sequence = 0;
> +
> +	/* Start streaming on the pipeline. No link touching an entity in the
> +	 * pipeline can be activated or deactivated once streaming is started.
> +	 *
> +	 * Use the VSP1 pipeline object embedded in the first video object that
> +	 * starts streaming.
> +	 */
> +	pipe = video->video.entity.pipe
> +	     ? to_vsp1_pipeline(&video->video.entity) : &video->pipe;
> +
> +	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> +	if (ret < 0)
> +		goto err_unlock;
> +
> +	/* Verify that the configured format matches the output of the connected
> +	 * subdev.
> +	 */
> +	ret = vsp1_video_verify_format(video);
> +	if (ret < 0)
> +		goto err_stop;
> +
> +	ret = vsp1_pipeline_init(pipe, video);
> +	if (ret < 0)
> +		goto err_stop;

Shouldn't the code above be better placed in the vb2 start_streaming op?

> +
> +	/* Start the queue. */
> +	ret = vb2_streamon(&video->queue, type);
> +	if (ret < 0)
> +		goto err_cleanup;
> +
> +	mutex_unlock(&video->lock);
> +	return 0;
> +
> +err_cleanup:
> +	vsp1_pipeline_cleanup(pipe);
> +err_stop:
> +	media_entity_pipeline_stop(&video->video.entity);
> +err_unlock:
> +	mutex_unlock(&video->lock);
> +	return ret;
> +
> +}
> +
> +static int
> +vsp1_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +
> +	if (video->queue.owner && video->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_streamoff(&video->queue, type);
> +
> +done:
> +	mutex_unlock(&video->lock);
> +	return ret;
> +}
> +
> +static const struct v4l2_ioctl_ops vsp1_video_ioctl_ops = {
> +	.vidioc_querycap		= vsp1_video_querycap,
> +	.vidioc_g_fmt_vid_cap_mplane	= vsp1_video_get_format,
> +	.vidioc_s_fmt_vid_cap_mplane	= vsp1_video_set_format,
> +	.vidioc_try_fmt_vid_cap_mplane	= vsp1_video_try_format,
> +	.vidioc_g_fmt_vid_out_mplane	= vsp1_video_get_format,
> +	.vidioc_s_fmt_vid_out_mplane	= vsp1_video_set_format,
> +	.vidioc_try_fmt_vid_out_mplane	= vsp1_video_try_format,
> +	.vidioc_reqbufs			= vsp1_video_reqbufs,
> +	.vidioc_querybuf		= vsp1_video_querybuf,
> +	.vidioc_qbuf			= vsp1_video_qbuf,
> +	.vidioc_dqbuf			= vsp1_video_dqbuf,
> +	.vidioc_streamon		= vsp1_video_streamon,
> +	.vidioc_streamoff		= vsp1_video_streamoff,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 File Operations
> + */
> +
> +static int vsp1_video_open(struct file *file)
> +{
> +	struct vsp1_video *video = video_drvdata(file);
> +	struct v4l2_fh *vfh;
> +	int ret = 0;
> +
> +	vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
> +	if (vfh == NULL)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(vfh, &video->video);
> +	v4l2_fh_add(vfh);
> +
> +	file->private_data = vfh;
> +
> +	if (!vsp1_device_get(video->vsp1)) {
> +		ret = -EBUSY;
> +		v4l2_fh_del(vfh);
> +		kfree(vfh);
> +	}
> +
> +	return ret;
> +}
> +
> +static int vsp1_video_release(struct file *file)
> +{
> +	struct vsp1_video *video = video_drvdata(file);
> +	struct v4l2_fh *vfh = file->private_data;
> +
> +	mutex_lock(&video->lock);
> +	if (video->queue.owner == vfh) {
> +		vb2_queue_release(&video->queue);
> +		video->queue.owner = NULL;
> +	}
> +	mutex_unlock(&video->lock);
> +
> +	vsp1_device_put(video->vsp1);
> +
> +	v4l2_fh_release(file);
> +
> +	file->private_data = NULL;
> +
> +	return 0;
> +}
> +
> +static unsigned int vsp1_video_poll(struct file *file, poll_table *wait)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +	ret = vb2_poll(&video->queue, file, wait);
> +	mutex_unlock(&video->lock);
> +
> +	return ret;
> +}
> +
> +static int vsp1_video_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +	ret = vb2_mmap(&video->queue, vma);
> +	mutex_unlock(&video->lock);
> +
> +	return ret;
> +}
> +
> +static struct v4l2_file_operations vsp1_video_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.open = vsp1_video_open,
> +	.release = vsp1_video_release,
> +	.poll = vsp1_video_poll,
> +	.mmap = vsp1_video_mmap,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Initialization and Cleanup
> + */
> +
> +int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
> +{
> +	const char *direction;
> +	int ret;
> +
> +	switch (video->type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		direction = "output";
> +		video->pad.flags = MEDIA_PAD_FL_SINK;
> +		break;
> +
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		direction = "input";
> +		video->pad.flags = MEDIA_PAD_FL_SOURCE;
> +		video->video.vfl_dir = VFL_DIR_TX;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	video->rwpf = rwpf;
> +
> +	mutex_init(&video->lock);
> +	spin_lock_init(&video->irqlock);
> +	INIT_LIST_HEAD(&video->irqqueue);
> +
> +	mutex_init(&video->pipe.lock);
> +	spin_lock_init(&video->pipe.irqlock);
> +	INIT_LIST_HEAD(&video->pipe.entities);
> +	init_waitqueue_head(&video->pipe.wq);
> +	video->pipe.state = VSP1_PIPELINE_STOPPED;
> +
> +	/* Initialize the media entity... */
> +	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* ... and the format ... */
> +	video->fmtinfo = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> +	video->format.pixelformat = video->fmtinfo->fourcc;
> +	video->format.colorspace = V4L2_COLORSPACE_SRGB;
> +	video->format.field = V4L2_FIELD_NONE;
> +	video->format.width = VSP1_VIDEO_DEF_WIDTH;
> +	video->format.height = VSP1_VIDEO_DEF_HEIGHT;
> +	video->format.num_planes = 1;
> +	video->format.plane_fmt[0].bytesperline =
> +		video->format.width * video->fmtinfo->bpp[0] / 8;
> +	video->format.plane_fmt[0].sizeimage =
> +		video->format.plane_fmt[0].bytesperline * video->format.height;
> +
> +	/* ... and the video node... */
> +	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
> +	video->video.fops = &vsp1_video_fops;
> +	snprintf(video->video.name, sizeof(video->video.name), "%s %s",
> +		 rwpf->subdev.name, direction);
> +	video->video.vfl_type = VFL_TYPE_GRABBER;
> +	video->video.release = video_device_release_empty;
> +	video->video.ioctl_ops = &vsp1_video_ioctl_ops;
> +
> +	video_set_drvdata(&video->video, video);
> +
> +	/* ... and the buffers queue... */
> +	video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
> +	if (IS_ERR(video->alloc_ctx))
> +		goto error;
> +
> +	video->queue.type = video->type;
> +	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	video->queue.drv_priv = video;
> +	video->queue.buf_struct_size = sizeof(struct vsp1_video_buffer);
> +	video->queue.ops = &vsp1_video_queue_qops;
> +	video->queue.mem_ops = &vb2_dma_contig_memops;
> +	video->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	ret = vb2_queue_init(&video->queue);
> +	if (ret < 0) {
> +		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
> +		goto error;
> +	}
> +
> +	/* ... and register the video device. */
> +	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(video->vsp1->dev, "failed to register video device\n");
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
> +	vsp1_video_cleanup(video);
> +	return ret;
> +}
> +
> +void vsp1_video_cleanup(struct vsp1_video *video)
> +{
> +	if (video_is_registered(&video->video))
> +		video_unregister_device(&video->video);
> +
> +	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
> +	media_entity_cleanup(&video->video.entity);
> +}

Regards,

	Hans
