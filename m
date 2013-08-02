Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3316 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3HBJYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:24:07 -0400
Message-ID: <51FB7AA2.7080305@xs4all.nl>
Date: Fri, 02 Aug 2013 11:23:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 7/9] v4l: Renesas R-Car VSP1 driver
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375405408-17134-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

See my single remark below...

On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
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
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>



> diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
> new file mode 100644
> index 0000000..972a285
> --- /dev/null
> +++ b/drivers/media/platform/vsp1/vsp1_uds.h

...

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
> +	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> +			  | V4L2_CAP_VIDEO_CAPTURE_MPLANE
> +			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE
> +				 | V4L2_CAP_STREAMING;
> +	else
> +		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT_MPLANE
> +				 | V4L2_CAP_STREAMING;
> +
> +	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
> +	strlcpy(cap->card, video->video.name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(video->vsp1->dev));
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
> +	if (vb2_is_busy(&video->queue)) {
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
> +	ret = vb2_ioctl_reqbufs(file, fh, rb);
> +	mutex_unlock(&video->lock);
> +
> +	return ret;
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
> +	ret = vb2_ioctl_qbuf(file, fh, buf);
> +	mutex_unlock(&video->lock);
> +
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
> +	ret = vb2_ioctl_dqbuf(file, fh, buf);
> +	mutex_unlock(&video->lock);
> +
> +	return ret;
> +}
> +
> +static int
> +vsp1_video_create_bufs(struct file *file, void *fh,
> +		       struct v4l2_create_buffers *bufs)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +	ret = vb2_ioctl_create_bufs(file, fh, bufs);
> +	mutex_unlock(&video->lock);
> +
> +	return ret;
> +}
> +
> +static int
> +vsp1_video_prepare_buf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&video->lock);
> +	ret = vb2_ioctl_prepare_buf(file, fh, buf);
> +	mutex_unlock(&video->lock);
> +
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
> +	if (video->queue.owner && video->queue.owner != file->private_data) {
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
> +	ret = vb2_ioctl_streamoff(file, fh, type);
> +	mutex_unlock(&video->lock);
> +
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
> +	.vidioc_create_bufs		= vsp1_video_create_bufs,
> +	.vidioc_prepare_buf		= vsp1_video_prepare_buf,
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

If you set video->queue.lock to &video->lock, then you can drop all the vb2 ioctl
and fop helper functions directly without having to make your own wrapper functions.

It saves a fair bit of code that way. The only place where there is a difference
as far as I can see is in vb2_fop_mmap: there the queue.lock isn't taken whereas
you do take the lock. It has never been 100% clear to me whether or not that lock should
be taken. However, as far as I can tell vb2_mmap never calls any driver callbacks, so
it seems to be me that there is no need to take the lock.

> +	ret = vb2_queue_init(&video->queue);
> +	if (ret < 0) {
> +		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
> +		goto error;
> +	}
> +
> +	/* ... and register the video device. */
> +	video->video.queue = &video->queue;
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
