Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3304 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3JCGyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 02:54:46 -0400
Message-ID: <524D149B.1000006@xs4all.nl>
Date: Thu, 03 Oct 2013 08:54:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/6] v4l: omap4iss: Add support for OMAP4 camera interface
 - Video devices
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com> <1380758133-16866-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1380758133-16866-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/2013 01:55 AM, Laurent Pinchart wrote:
> From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> This adds a very simplistic driver to utilize the CSI2A interface inside
> the ISS subsystem in OMAP4, and dump the data to memory.
> 
> Check Documentation/video4linux/omap4_camera.txt for details.
> 
> This commit adds video devices support.
> 
> Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> [Port the driver to v3.12-rc3, including the following changes
> - Don't include plat/ headers
> - Don't use cpu_is_omap44xx() macro
> - Don't depend on EXPERIMENTAL
> - Fix s_crop operation prototype
> - Update link_notify prototype
> - Rename media_entity_remote_source to media_entity_remote_pad]
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/staging/media/omap4iss/iss_video.c | 1129 ++++++++++++++++++++++++++++
>  drivers/staging/media/omap4iss/iss_video.h |  201 +++++
>  2 files changed, 1330 insertions(+)
>  create mode 100644 drivers/staging/media/omap4iss/iss_video.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_video.h
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> new file mode 100644
> index 0000000..31f1b88
> --- /dev/null
> +++ b/drivers/staging/media/omap4iss/iss_video.c

<snip>

> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int
> +iss_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +
> +	strlcpy(cap->driver, ISS_VIDEO_DRIVER_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, video->video.name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
> +
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	else
> +		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;

Set device_caps instead of capabilities and add:

	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

> +
> +	return 0;
> +}
> +
> +static int
> +iss_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +	struct iss_video *video = video_drvdata(file);
> +
> +	if (format->type != video->type)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->mutex);
> +	*format = vfh->format;
> +	mutex_unlock(&video->mutex);
> +
> +	return 0;
> +}
> +
> +static int
> +iss_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +	struct iss_video *video = video_drvdata(file);
> +	struct v4l2_mbus_framefmt fmt;
> +
> +	if (format->type != video->type)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->mutex);
> +
> +	/* Fill the bytesperline and sizeimage fields by converting to media bus
> +	 * format and back to pixel format.
> +	 */
> +	iss_video_pix_to_mbus(&format->fmt.pix, &fmt);
> +	iss_video_mbus_to_pix(video, &fmt, &format->fmt.pix);
> +
> +	vfh->format = *format;
> +
> +	mutex_unlock(&video->mutex);
> +	return 0;
> +}
> +
> +static int
> +iss_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +	struct v4l2_subdev_format fmt;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	if (format->type != video->type)
> +		return -EINVAL;
> +
> +	subdev = iss_video_remote_subdev(video, &pad);
> +	if (subdev == NULL)
> +		return -EINVAL;
> +
> +	iss_video_pix_to_mbus(&format->fmt.pix, &fmt.format);
> +
> +	fmt.pad = pad;
> +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> +	if (ret)
> +		return ret == -ENOIOCTLCMD ? -EINVAL : ret;

Return ENOTTY instead of EINVAL. Even better, use v4l2_subdev_has_op() + v4l2_disable_ioctl()
to just disable ioctls based on the available subdev ops in probe().

> +
> +	iss_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
> +	return 0;
> +}
> +
> +static int
> +iss_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	subdev = iss_video_remote_subdev(video, NULL);
> +	if (subdev == NULL)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->mutex);
> +	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
> +	mutex_unlock(&video->mutex);
> +
> +	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +}
> +
> +static int
> +iss_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +	struct v4l2_subdev_format format;
> +	struct v4l2_subdev *subdev;
> +	u32 pad;
> +	int ret;
> +
> +	subdev = iss_video_remote_subdev(video, &pad);
> +	if (subdev == NULL)
> +		return -EINVAL;
> +
> +	/* Try the get crop operation first and fallback to get format if not
> +	 * implemented.
> +	 */
> +	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
> +	if (ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	format.pad = pad;
> +	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
> +	if (ret < 0)
> +		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +
> +	crop->c.left = 0;
> +	crop->c.top = 0;
> +	crop->c.width = format.format.width;
> +	crop->c.height = format.format.height;
> +
> +	return 0;
> +}
> +
> +static int
> +iss_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	subdev = iss_video_remote_subdev(video, NULL);
> +	if (subdev == NULL)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->mutex);
> +	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
> +	mutex_unlock(&video->mutex);
> +
> +	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +}
> +
> +static int
> +iss_video_get_param(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +	struct iss_video *video = video_drvdata(file);
> +
> +	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
> +	    video->type != a->type)
> +		return -EINVAL;
> +
> +	memset(a, 0, sizeof(*a));
> +	a->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
> +	a->parm.output.timeperframe = vfh->timeperframe;
> +
> +	return 0;
> +}
> +
> +static int
> +iss_video_set_param(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +	struct iss_video *video = video_drvdata(file);
> +
> +	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
> +	    video->type != a->type)
> +		return -EINVAL;
> +
> +	if (a->parm.output.timeperframe.denominator == 0)
> +		a->parm.output.timeperframe.denominator = 1;
> +
> +	vfh->timeperframe = a->parm.output.timeperframe;
> +
> +	return 0;
> +}
> +
> +static int
> +iss_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +
> +	return vb2_reqbufs(&vfh->queue, rb);
> +}
> +
> +static int
> +iss_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +
> +	return vb2_querybuf(&vfh->queue, b);
> +}
> +
> +static int
> +iss_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +
> +	return vb2_qbuf(&vfh->queue, b);
> +}
> +
> +static int
> +iss_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +
> +	return vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
> +}
> +
> +/*
> + * Stream management
> + *
> + * Every ISS pipeline has a single input and a single output. The input can be
> + * either a sensor or a video node. The output is always a video node.
> + *
> + * As every pipeline has an output video node, the ISS video objects at the
> + * pipeline output stores the pipeline state. It tracks the streaming state of
> + * both the input and output, as well as the availability of buffers.
> + *
> + * In sensor-to-memory mode, frames are always available at the pipeline input.
> + * Starting the sensor usually requires I2C transfers and must be done in
> + * interruptible context. The pipeline is started and stopped synchronously
> + * to the stream on/off commands. All modules in the pipeline will get their
> + * subdev set stream handler called. The module at the end of the pipeline must
> + * delay starting the hardware until buffers are available at its output.
> + *
> + * In memory-to-memory mode, starting/stopping the stream requires
> + * synchronization between the input and output. ISS modules can't be stopped
> + * in the middle of a frame, and at least some of the modules seem to become
> + * busy as soon as they're started, even if they don't receive a frame start
> + * event. For that reason frames need to be processed in single-shot mode. The
> + * driver needs to wait until a frame is completely processed and written to
> + * memory before restarting the pipeline for the next frame. Pipelined
> + * processing might be possible but requires more testing.
> + *
> + * Stream start must be delayed until buffers are available at both the input
> + * and output. The pipeline must be started in the videobuf queue callback with
> + * the buffers queue spinlock held. The modules subdev set stream operation must
> + * not sleep.
> + */
> +static int
> +iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +	struct iss_video *video = video_drvdata(file);
> +	enum iss_pipeline_state state;
> +	struct iss_pipeline *pipe;
> +	struct iss_video *far_end;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (type != video->type)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->stream_lock);
> +
> +	if (video->streaming) {
> +		mutex_unlock(&video->stream_lock);
> +		return -EBUSY;
> +	}
> +
> +	/* Start streaming on the pipeline. No link touching an entity in the
> +	 * pipeline can be activated or deactivated once streaming is started.
> +	 */
> +	pipe = video->video.entity.pipe
> +	     ? to_iss_pipeline(&video->video.entity) : &video->pipe;
> +	pipe->external = NULL;
> +	pipe->external_rate = 0;
> +	pipe->external_bpp = 0;
> +
> +	if (video->iss->pdata->set_constraints)
> +		video->iss->pdata->set_constraints(video->iss, true);
> +
> +	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> +	if (ret < 0)
> +		goto err_media_entity_pipeline_start;
> +
> +	/* Verify that the currently configured format matches the output of
> +	 * the connected subdev.
> +	 */
> +	ret = iss_video_check_format(video, vfh);
> +	if (ret < 0)
> +		goto err_iss_video_check_format;
> +
> +	video->bpl_padding = ret;
> +	video->bpl_value = vfh->format.fmt.pix.bytesperline;
> +
> +	/* Find the ISS video node connected at the far end of the pipeline and
> +	 * update the pipeline.
> +	 */
> +	far_end = iss_video_far_end(video);
> +
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		state = ISS_PIPELINE_STREAM_OUTPUT | ISS_PIPELINE_IDLE_OUTPUT;
> +		pipe->input = far_end;
> +		pipe->output = video;
> +	} else {
> +		if (far_end == NULL) {
> +			ret = -EPIPE;
> +			goto err_iss_video_check_format;
> +		}
> +
> +		state = ISS_PIPELINE_STREAM_INPUT | ISS_PIPELINE_IDLE_INPUT;
> +		pipe->input = video;
> +		pipe->output = far_end;
> +	}
> +
> +	spin_lock_irqsave(&pipe->lock, flags);
> +	pipe->state &= ~ISS_PIPELINE_STREAM;
> +	pipe->state |= state;
> +	spin_unlock_irqrestore(&pipe->lock, flags);
> +
> +	/* Set the maximum time per frame as the value requested by userspace.
> +	 * This is a soft limit that can be overridden if the hardware doesn't
> +	 * support the request limit.
> +	 */
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		pipe->max_timeperframe = vfh->timeperframe;
> +
> +	video->queue = &vfh->queue;
> +	INIT_LIST_HEAD(&video->dmaqueue);
> +	spin_lock_init(&video->qlock);
> +	atomic_set(&pipe->frame_number, -1);
> +
> +	ret = vb2_streamon(&vfh->queue, type);
> +	if (ret < 0)
> +		goto err_iss_video_check_format;
> +
> +	/* In sensor-to-memory mode, the stream can be started synchronously
> +	 * to the stream on command. In memory-to-memory mode, it will be
> +	 * started when buffers are queued on both the input and output.
> +	 */
> +	if (pipe->input == NULL) {
> +		unsigned long flags;
> +		ret = omap4iss_pipeline_set_stream(pipe,
> +					      ISS_PIPELINE_STREAM_CONTINUOUS);
> +		if (ret < 0)
> +			goto err_omap4iss_set_stream;
> +		spin_lock_irqsave(&video->qlock, flags);
> +		if (list_empty(&video->dmaqueue))
> +			video->dmaqueue_flags |= ISS_VIDEO_DMAQUEUE_UNDERRUN;
> +		spin_unlock_irqrestore(&video->qlock, flags);
> +	}
> +
> +	if (ret < 0) {
> +err_omap4iss_set_stream:
> +		vb2_streamoff(&vfh->queue, type);
> +err_iss_video_check_format:
> +		media_entity_pipeline_stop(&video->video.entity);
> +err_media_entity_pipeline_start:
> +		if (video->iss->pdata->set_constraints)
> +			video->iss->pdata->set_constraints(video->iss, false);
> +		video->queue = NULL;
> +	}
> +
> +	if (!ret)
> +		video->streaming = 1;

No necessary, vb2_is_streaming already keeps track of that.

> +
> +	mutex_unlock(&video->stream_lock);
> +	return ret;
> +}
> +
> +static int
> +iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(fh);
> +	struct iss_video *video = video_drvdata(file);
> +	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
> +	enum iss_pipeline_state state;
> +	unsigned long flags;
> +
> +	if (type != video->type)
> +		return -EINVAL;
> +
> +	mutex_lock(&video->stream_lock);
> +
> +	if (!vb2_is_streaming(&vfh->queue))
> +		goto done;
> +
> +	/* Update the pipeline state. */
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		state = ISS_PIPELINE_STREAM_OUTPUT
> +		      | ISS_PIPELINE_QUEUE_OUTPUT;
> +	else
> +		state = ISS_PIPELINE_STREAM_INPUT
> +		      | ISS_PIPELINE_QUEUE_INPUT;
> +
> +	spin_lock_irqsave(&pipe->lock, flags);
> +	pipe->state &= ~state;
> +	spin_unlock_irqrestore(&pipe->lock, flags);
> +
> +	/* Stop the stream. */
> +	omap4iss_pipeline_set_stream(pipe, ISS_PIPELINE_STREAM_STOPPED);
> +	vb2_streamoff(&vfh->queue, type);
> +	video->queue = NULL;
> +	video->streaming = 0;
> +
> +	if (video->iss->pdata->set_constraints)
> +		video->iss->pdata->set_constraints(video->iss, false);
> +	media_entity_pipeline_stop(&video->video.entity);
> +
> +done:
> +	mutex_unlock(&video->stream_lock);
> +	return 0;
> +}
> +
> +static int
> +iss_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
> +{
> +	if (input->index > 0)
> +		return -EINVAL;
> +
> +	strlcpy(input->name, "camera", sizeof(input->name));
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +	return 0;
> +}
> +
> +static int
> +iss_video_g_input(struct file *file, void *fh, unsigned int *input)
> +{
> +	*input = 0;
> +
> +	return 0;
> +}

Also add s_input.

> +
> +static const struct v4l2_ioctl_ops iss_video_ioctl_ops = {
> +	.vidioc_querycap		= iss_video_querycap,
> +	.vidioc_g_fmt_vid_cap		= iss_video_get_format,
> +	.vidioc_s_fmt_vid_cap		= iss_video_set_format,
> +	.vidioc_try_fmt_vid_cap		= iss_video_try_format,
> +	.vidioc_g_fmt_vid_out		= iss_video_get_format,
> +	.vidioc_s_fmt_vid_out		= iss_video_set_format,
> +	.vidioc_try_fmt_vid_out		= iss_video_try_format,
> +	.vidioc_cropcap			= iss_video_cropcap,
> +	.vidioc_g_crop			= iss_video_get_crop,
> +	.vidioc_s_crop			= iss_video_set_crop,
> +	.vidioc_g_parm			= iss_video_get_param,
> +	.vidioc_s_parm			= iss_video_set_param,
> +	.vidioc_reqbufs			= iss_video_reqbufs,
> +	.vidioc_querybuf		= iss_video_querybuf,
> +	.vidioc_qbuf			= iss_video_qbuf,
> +	.vidioc_dqbuf			= iss_video_dqbuf,
> +	.vidioc_streamon		= iss_video_streamon,
> +	.vidioc_streamoff		= iss_video_streamoff,
> +	.vidioc_enum_input		= iss_video_enum_input,
> +	.vidioc_g_input			= iss_video_g_input,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 file operations
> + */
> +
> +static int iss_video_open(struct file *file)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +	struct iss_video_fh *handle;
> +	struct vb2_queue *q;
> +	int ret = 0;
> +
> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> +	if (handle == NULL)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(&handle->vfh, &video->video);
> +	v4l2_fh_add(&handle->vfh);
> +
> +	/* If this is the first user, initialise the pipeline. */
> +	if (omap4iss_get(video->iss) == NULL) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = omap4iss_pipeline_pm_use(&video->video.entity, 1);
> +	if (ret < 0) {
> +		omap4iss_put(video->iss);
> +		goto done;
> +	}
> +
> +	video->alloc_ctx = vb2_dma_contig_init_ctx(video->iss->dev);
> +	if (IS_ERR(video->alloc_ctx)) {
> +		ret = PTR_ERR(video->alloc_ctx);
> +		omap4iss_put(video->iss);
> +		goto done;
> +	}
> +
> +	q = &handle->queue;
> +
> +	q->type = video->type;
> +	q->io_modes = VB2_MMAP;
> +	q->drv_priv = handle;
> +	q->ops = &iss_video_vb2ops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->buf_struct_size = sizeof(struct iss_buffer);

I'm missing q->timestamp_type.

> +
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		omap4iss_put(video->iss);
> +		goto done;
> +	}
> +
> +	memset(&handle->format, 0, sizeof(handle->format));
> +	handle->format.type = video->type;
> +	handle->timeperframe.denominator = 1;
> +
> +	handle->video = video;
> +	file->private_data = &handle->vfh;
> +
> +done:
> +	if (ret < 0) {
> +		v4l2_fh_del(&handle->vfh);
> +		kfree(handle);
> +	}
> +
> +	return ret;
> +}
> +
> +static int iss_video_release(struct file *file)
> +{
> +	struct iss_video *video = video_drvdata(file);
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct iss_video_fh *handle = to_iss_video_fh(vfh);
> +
> +	/* Disable streaming and free the buffers queue resources. */
> +	iss_video_streamoff(file, vfh, video->type);
> +
> +	omap4iss_pipeline_pm_use(&video->video.entity, 0);
> +
> +	/* Release the videobuf2 queue */
> +	vb2_queue_release(&handle->queue);
> +
> +	/* Release the file handle. */
> +	v4l2_fh_del(vfh);
> +	kfree(handle);
> +	file->private_data = NULL;
> +
> +	omap4iss_put(video->iss);
> +
> +	return 0;
> +}
> +
> +static unsigned int iss_video_poll(struct file *file, poll_table *wait)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(file->private_data);
> +
> +	return vb2_poll(&vfh->queue, file, wait);
> +}
> +
> +static int iss_video_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct iss_video_fh *vfh = to_iss_video_fh(file->private_data);
> +
> +	return vb2_mmap(&vfh->queue, vma);;
> +}
> +
> +static struct v4l2_file_operations iss_video_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.open = iss_video_open,
> +	.release = iss_video_release,
> +	.poll = iss_video_poll,
> +	.mmap = iss_video_mmap,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * ISS video core
> + */
> +
> +static const struct iss_video_operations iss_video_dummy_ops = {
> +};
> +
> +int omap4iss_video_init(struct iss_video *video, const char *name)
> +{
> +	const char *direction;
> +	int ret;
> +
> +	switch (video->type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		direction = "output";
> +		video->pad.flags = MEDIA_PAD_FL_SINK;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		direction = "input";
> +		video->pad.flags = MEDIA_PAD_FL_SOURCE;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_init(&video->mutex);
> +	atomic_set(&video->active, 0);
> +
> +	spin_lock_init(&video->pipe.lock);
> +	mutex_init(&video->stream_lock);
> +
> +	/* Initialize the video device. */
> +	if (video->ops == NULL)
> +		video->ops = &iss_video_dummy_ops;
> +
> +	video->video.fops = &iss_video_fops;
> +	snprintf(video->video.name, sizeof(video->video.name),
> +		 "OMAP4 ISS %s %s", name, direction);
> +	video->video.vfl_type = VFL_TYPE_GRABBER;
> +	video->video.release = video_device_release_empty;
> +	video->video.ioctl_ops = &iss_video_ioctl_ops;
> +	video->pipe.stream_state = ISS_PIPELINE_STREAM_STOPPED;
> +
> +	video_set_drvdata(&video->video, video);
> +
> +	return 0;
> +}
> +
> +void omap4iss_video_cleanup(struct iss_video *video)
> +{
> +	media_entity_cleanup(&video->video.entity);
> +	mutex_destroy(&video->stream_lock);
> +	mutex_destroy(&video->mutex);
> +}
> +
> +int omap4iss_video_register(struct iss_video *video, struct v4l2_device *vdev)
> +{
> +	int ret;
> +
> +	video->video.v4l2_dev = vdev;
> +
> +	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0)
> +		printk(KERN_ERR "%s: could not register video device (%d)\n",
> +			__func__, ret);
> +
> +	return ret;
> +}
> +
> +void omap4iss_video_unregister(struct iss_video *video)
> +{
> +	if (video_is_registered(&video->video))

No need to call video_is_registered(), that's already done by video_unregister_device().

> +		video_unregister_device(&video->video);
> +}
> diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
> new file mode 100644
> index 0000000..8cf1b35
> --- /dev/null
> +++ b/drivers/staging/media/omap4iss/iss_video.h
> @@ -0,0 +1,201 @@
> +/*
> + * TI OMAP4 ISS V4L2 Driver - Generic video node
> + *
> + * Copyright (C) 2012 Texas Instruments, Inc.
> + *
> + * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef OMAP4_ISS_VIDEO_H
> +#define OMAP4_ISS_VIDEO_H
> +
> +#include <linux/v4l2-mediabus.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#define ISS_VIDEO_DRIVER_NAME		"issvideo"
> +#define ISS_VIDEO_DRIVER_VERSION	"0.0.2"
> +
> +struct iss_device;
> +struct iss_video;
> +struct v4l2_mbus_framefmt;
> +struct v4l2_pix_format;
> +
> +/*
> + * struct iss_format_info - ISS media bus format information
> + * @code: V4L2 media bus format code
> + * @truncated: V4L2 media bus format code for the same format truncated to 10
> + *	bits. Identical to @code if the format is 10 bits wide or less.
> + * @uncompressed: V4L2 media bus format code for the corresponding uncompressed
> + *	format. Identical to @code if the format is not DPCM compressed.
> + * @flavor: V4L2 media bus format code for the same pixel layout but
> + *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
> + * @pixelformat: V4L2 pixel format FCC identifier
> + * @bpp: Bits per pixel
> + */
> +struct iss_format_info {
> +	enum v4l2_mbus_pixelcode code;
> +	enum v4l2_mbus_pixelcode truncated;
> +	enum v4l2_mbus_pixelcode uncompressed;
> +	enum v4l2_mbus_pixelcode flavor;
> +	u32 pixelformat;
> +	unsigned int bpp;
> +};
> +
> +enum iss_pipeline_stream_state {
> +	ISS_PIPELINE_STREAM_STOPPED = 0,
> +	ISS_PIPELINE_STREAM_CONTINUOUS = 1,
> +	ISS_PIPELINE_STREAM_SINGLESHOT = 2,
> +};
> +
> +enum iss_pipeline_state {
> +	/* The stream has been started on the input video node. */
> +	ISS_PIPELINE_STREAM_INPUT = 1,
> +	/* The stream has been started on the output video node. */
> +	ISS_PIPELINE_STREAM_OUTPUT = (1 << 1),
> +	/* At least one buffer is queued on the input video node. */
> +	ISS_PIPELINE_QUEUE_INPUT = (1 << 2),
> +	/* At least one buffer is queued on the output video node. */
> +	ISS_PIPELINE_QUEUE_OUTPUT = (1 << 3),
> +	/* The input entity is idle, ready to be started. */
> +	ISS_PIPELINE_IDLE_INPUT = (1 << 4),
> +	/* The output entity is idle, ready to be started. */
> +	ISS_PIPELINE_IDLE_OUTPUT = (1 << 5),
> +	/* The pipeline is currently streaming. */
> +	ISS_PIPELINE_STREAM = (1 << 6),
> +};
> +
> +/*
> + * struct iss_pipeline - An OMAP4 ISS hardware pipeline
> + * @error: A hardware error occurred during capture
> + */
> +struct iss_pipeline {
> +	struct media_pipeline pipe;
> +	spinlock_t lock;		/* Pipeline state and queue flags */
> +	unsigned int state;
> +	enum iss_pipeline_stream_state stream_state;
> +	struct iss_video *input;
> +	struct iss_video *output;
> +	atomic_t frame_number;
> +	bool do_propagation; /* of frame number */
> +	bool error;
> +	struct v4l2_fract max_timeperframe;
> +	struct v4l2_subdev *external;
> +	unsigned int external_rate;
> +	int external_bpp;
> +};
> +
> +#define to_iss_pipeline(__e) \
> +	container_of((__e)->pipe, struct iss_pipeline, pipe)
> +
> +static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
> +{
> +	return pipe->state == (ISS_PIPELINE_STREAM_INPUT |
> +			       ISS_PIPELINE_STREAM_OUTPUT |
> +			       ISS_PIPELINE_QUEUE_INPUT |
> +			       ISS_PIPELINE_QUEUE_OUTPUT |
> +			       ISS_PIPELINE_IDLE_INPUT |
> +			       ISS_PIPELINE_IDLE_OUTPUT);
> +}
> +
> +/*
> + * struct iss_buffer - ISS buffer
> + * @buffer: ISS video buffer
> + * @iss_addr: Physical address of the buffer.
> + */
> +struct iss_buffer {
> +	/* common v4l buffer stuff -- must be first */
> +	struct vb2_buffer	vb;
> +	struct list_head	list;
> +	dma_addr_t iss_addr;
> +};
> +
> +#define to_iss_buffer(buf)	container_of(buf, struct iss_buffer, buffer)
> +
> +enum iss_video_dmaqueue_flags {
> +	/* Set if DMA queue becomes empty when ISS_PIPELINE_STREAM_CONTINUOUS */
> +	ISS_VIDEO_DMAQUEUE_UNDERRUN = (1 << 0),
> +	/* Set when queuing buffer to an empty DMA queue */
> +	ISS_VIDEO_DMAQUEUE_QUEUED = (1 << 1),
> +};
> +
> +#define iss_video_dmaqueue_flags_clr(video)	\
> +			({ (video)->dmaqueue_flags = 0; })
> +
> +/*
> + * struct iss_video_operations - ISS video operations
> + * @queue:	Resume streaming when a buffer is queued. Called on VIDIOC_QBUF
> + *		if there was no buffer previously queued.
> + */
> +struct iss_video_operations {
> +	int(*queue)(struct iss_video *video, struct iss_buffer *buffer);
> +};
> +
> +struct iss_video {
> +	struct video_device video;
> +	enum v4l2_buf_type type;
> +	struct media_pad pad;
> +
> +	struct mutex mutex;		/* format and crop settings */
> +	atomic_t active;
> +
> +	struct iss_device *iss;
> +
> +	unsigned int capture_mem;
> +	unsigned int bpl_alignment;	/* alignment value */
> +	unsigned int bpl_zero_padding;	/* whether the alignment is optional */
> +	unsigned int bpl_max;		/* maximum bytes per line value */
> +	unsigned int bpl_value;		/* bytes per line value */
> +	unsigned int bpl_padding;	/* padding at end of line */
> +
> +	/* Entity video node streaming */
> +	unsigned int streaming:1;
> +
> +	/* Pipeline state */
> +	struct iss_pipeline pipe;
> +	struct mutex stream_lock;	/* pipeline and stream states */
> +
> +	/* Video buffers queue */
> +	struct vb2_queue *queue;
> +	spinlock_t qlock;	/* Spinlock for dmaqueue */
> +	struct list_head dmaqueue;
> +	enum iss_video_dmaqueue_flags dmaqueue_flags;
> +	struct vb2_alloc_ctx *alloc_ctx;
> +
> +	const struct iss_video_operations *ops;
> +};
> +
> +#define to_iss_video(vdev)	container_of(vdev, struct iss_video, video)
> +
> +struct iss_video_fh {
> +	struct v4l2_fh vfh;
> +	struct iss_video *video;
> +	struct vb2_queue queue;
> +	struct v4l2_format format;
> +	struct v4l2_fract timeperframe;
> +};
> +
> +#define to_iss_video_fh(fh)	container_of(fh, struct iss_video_fh, vfh)
> +#define iss_video_queue_to_iss_video_fh(q) \
> +				container_of(q, struct iss_video_fh, queue)
> +
> +int omap4iss_video_init(struct iss_video *video, const char *name);
> +void omap4iss_video_cleanup(struct iss_video *video);
> +int omap4iss_video_register(struct iss_video *video,
> +			    struct v4l2_device *vdev);
> +void omap4iss_video_unregister(struct iss_video *video);
> +struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video);
> +struct media_pad *omap4iss_video_remote_pad(struct iss_video *video);
> +
> +const struct iss_format_info *
> +omap4iss_video_format_info(enum v4l2_mbus_pixelcode code);
> +
> +#endif /* OMAP4_ISS_VIDEO_H */
> 

Regards,

	Hans
