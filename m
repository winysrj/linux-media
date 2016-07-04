Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44119 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbcGDJkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 05:40:49 -0400
Subject: Re: [PATCH RFC v2 2/2] media: platform: pxa_camera: make a standalone
 v4l2 device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
 <1459607213-15774-3-git-send-email-robert.jarzmik@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0b6d669c-3b31-e165-da77-85af526b696b@xs4all.nl>
Date: Mon, 4 Jul 2016 11:40:43 +0200
MIME-Version: 1.0
In-Reply-To: <1459607213-15774-3-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

Thanks for the patch!

On 04/02/2016 04:26 PM, Robert Jarzmik wrote:
> This patch removes the soc_camera API dependency from pxa_camera.
> In the current status :
>  - all previously captures are working the same on pxa270
>  - the s_crop() call was removed, judged not working
>    (see what happens soc_camera_s_crop() when get_crop() == NULL)
>  - if the pixel clock is provided by then sensor, ie. not MCLK, the dual
>    stage change is not handled yet.
>    => there is no in-tree user of this, so I'll let it that way
> 
>  - the MCLK is not yet finished, it's as in the legacy way,
>    ie. activated at video device opening and closed at video device
>    closing.
>    In a subsequence patch pxa_camera_mclk_ops should be used, and
>    platform data MCLK ignored. It will be the sensor's duty to request
>    the clock and enable it, which will end in pxa_camera_mclk_ops.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> Since v1:
>   - function namings were cleaned into pxac_XXX_YYYY()
>   - function were regrouped in the 3 big categories :
>     - device probing/removal : pxa_camera_*()
>     - videobuf2 : pxac_vb2_*()
>     - v42l file operations : pxac_vidioc_*()
>     - internal driver functions : pxa_camera_*() : to be found a cute
>       pattern for RFC v3
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 1086 ++++++++++++++----------
>  include/linux/platform_data/media/camera-pxa.h |    2 +
>  2 files changed, 620 insertions(+), 468 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index b8dd878e98d6..30d266bbab55 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c

When you prepare the final patch series, please put the driver in drivers/media/platform/pxa-camera and not in the soc-camera directory.

<snip>

> -static int pxa_camera_set_crop(struct soc_camera_device *icd,
> -			       const struct v4l2_crop *a)
> +static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
> +					struct v4l2_fmtdesc *f)
>  {
> -	const struct v4l2_rect *rect = &a->c;
> -	struct device *dev = icd->parent;
> -	struct soc_camera_host *ici = to_soc_camera_host(dev);
> -	struct pxa_camera_dev *pcdev = ici->priv;
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct soc_camera_sense sense = {
> -		.master_clock = pcdev->mclk,
> -		.pixel_clock_max = pcdev->ciclk / 4,
> -	};
> -	struct v4l2_subdev_format fmt = {
> -		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> -	};
> -	struct v4l2_mbus_framefmt *mf = &fmt.format;
> -	struct pxa_cam *cam = icd->host_priv;
> -	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
> -	int ret;
> -
> -	/* If PCLK is used to latch data from the sensor, check sense */
> -	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
> -		icd->sense = &sense;
> -
> -	ret = v4l2_subdev_call(sd, video, s_crop, a);
> -
> -	icd->sense = NULL;
> -
> -	if (ret < 0) {
> -		dev_warn(dev, "Failed to crop to %ux%u@%u:%u\n",
> -			 rect->width, rect->height, rect->left, rect->top);
> -		return ret;
> -	}
> -
> -	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> -	if (ret < 0)
> -		return ret;
> +	struct pxa_camera_dev *pcdev = video_drvdata(filp);
> +	const struct soc_mbus_pixelfmt *format;
> +	unsigned int idx;
>  
> -	if (pxa_camera_check_frame(mf->width, mf->height)) {
> -		/*
> -		 * Camera cropping produced a frame beyond our capabilities.
> -		 * FIXME: just extract a subframe, that we can process.
> -		 */
> -		v4l_bound_align_image(&mf->width, 48, 2048, 1,
> -			&mf->height, 32, 2048, 0,
> -			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
> -		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &fmt);
> -		if (ret < 0)
> -			return ret;
> -
> -		if (pxa_camera_check_frame(mf->width, mf->height)) {
> -			dev_warn(icd->parent,
> -				 "Inconsistent state. Use S_FMT to repair\n");
> -			return -EINVAL;
> -		}
> -	}
> +	for (idx = 0; pcdev->user_formats[idx].code; idx++);
> +	if (f->index >= idx)
> +		return -EINVAL;
>  
> -	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
> -		if (sense.pixel_clock > sense.pixel_clock_max) {
> -			dev_err(dev,
> -				"pixel clock %lu set by the camera too high!",
> -				sense.pixel_clock);
> -			return -EIO;
> -		}
> -		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
> -	}
> +	format = pcdev->user_formats[f->index].host_fmt;
>  
> -	icd->user_width		= mf->width;
> -	icd->user_height	= mf->height;
> +	if (format->name)
> +		strlcpy(f->description, format->name, sizeof(f->description));

You can drop this since the core fills in the description. That means the
'name' field of struct soc_mbus_pixelfmt is not needed either.

> +	f->pixelformat = format->fourcc;
> +	return 0;
> +}

<snip>

> +static int pxac_vidioc_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
> +	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Tiny fix: you can drop the capabilities assignment: the v4l2 core does that for you these days.

> +
> +	return 0;
> +}
> +
> +static int pxac_vidioc_enum_input(struct file *file, void *priv,
> +				  struct v4l2_input *i)
> +{
> +	if (i->index > 0)
> +		return -EINVAL;
> +
> +	memset(i, 0, sizeof(*i));

The memset can be dropped, it's cleared for you.

> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(i->name, "Camera", sizeof(i->name));
> +
> +	return 0;
> +}
> +
> +static int pxac_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +
> +	return 0;
> +}
> +
> +static int pxac_vidioc_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i > 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int pxac_fops_camera_open(struct file *filp)
> +{
> +	struct pxa_camera_dev *pcdev = video_drvdata(filp);
> +	int ret;
> +
> +	mutex_lock(&pcdev->mlock);
> +	ret = v4l2_fh_open(filp);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = sensor_call(pcdev, core, s_power, 1);
> +	if (ret)
> +		v4l2_fh_release(filp);
> +out:
> +	mutex_unlock(&pcdev->mlock);
> +	return ret;
> +}
> +
> +static int pxac_fops_camera_release(struct file *filp)
> +{
> +	struct pxa_camera_dev *pcdev = video_drvdata(filp);
> +	int ret;
> +
> +	ret = vb2_fop_release(filp);
>  	if (ret < 0)
>  		return ret;
>  
> -	pix->width		= mf->width;
> -	pix->height		= mf->height;
> -	pix->field		= mf->field;
> -	pix->colorspace		= mf->colorspace;
> -	icd->current_fmt	= xlate;
> +	mutex_lock(&pcdev->mlock);
> +	ret = sensor_call(pcdev, core, s_power, 0);
> +	mutex_unlock(&pcdev->mlock);
>  
>  	return ret;
>  }
>  
> -static int pxa_camera_try_fmt(struct soc_camera_device *icd,
> -			      struct v4l2_format *f)
> +static const struct v4l2_file_operations pxa_camera_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= pxac_fops_camera_open,
> +	.release	= pxac_fops_camera_release,
> +	.read		= vb2_fop_read,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +	.unlocked_ioctl = video_ioctl2,
> +};
> +
> +static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
> +	.vidioc_querycap 		= pxac_vidioc_querycap,
> +
> +	.vidioc_enum_input		= pxac_vidioc_enum_input,
> +	.vidioc_g_input			= pxac_vidioc_g_input,
> +	.vidioc_s_input			= pxac_vidioc_s_input,
> +
> +	.vidioc_enum_fmt_vid_cap	= pxac_vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= pxac_vidioc_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= pxac_vidioc_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= pxac_vidioc_try_fmt_vid_cap,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +};
> +
> +
> +static void pxac_vb2_cleanup(struct vb2_buffer *vb)
>  {
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	const struct soc_camera_format_xlate *xlate;
> -	struct v4l2_pix_format *pix = &f->fmt.pix;
> -	struct v4l2_subdev_pad_config pad_cfg;
> -	struct v4l2_subdev_format format = {
> -		.which = V4L2_SUBDEV_FORMAT_TRY,
> -	};
> -	struct v4l2_mbus_framefmt *mf = &format.format;
> -	__u32 pixfmt = pix->pixelformat;
> -	int ret;
> +	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
>  
> -	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> -	if (!xlate) {
> -		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> +	dev_dbg(pcdev_to_dev(pcdev),
> +		 "%s(vb=%p)\n", __func__, vb);
> +	pxa_buffer_cleanup(buf);
> +}
> +
> +static void pxac_vb2_queue(struct vb2_buffer *vb)
> +{
> +	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	dev_dbg(pcdev_to_dev(pcdev),
> +		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
> +		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
> +		pcdev->active);
> +
> +	list_add_tail(&buf->queue, &pcdev->capture);
> +
> +	pxa_dma_add_tail_buf(pcdev, buf);
> +
> +	if (!pcdev->active)
> +		pxa_camera_start_capture(pcdev);

This is normally done from start_streaming. Are you really sure this is the right
place? I strongly recommend moving this start_capture call.

You may also want to use the struct vb2queue min_buffers_needed field to specify
the minimum number of buffers that should be queued up before start_streaming can
be called. Whether that's needed depends on your DMA engine.

> +}
> +
> +/*
> + * Please check the DMA prepared buffer structure in :
> + *   Documentation/video4linux/pxa_camera.txt
> + * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
> + * modification while DMA chain is running will work anyway.
> + */
> +static int pxac_vb2_prepare(struct vb2_buffer *vb)
> +{
> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
> +	int ret = 0;
> +
> +	switch (pcdev->channels) {
> +	case 1:
> +	case 3:
> +		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
> +		break;
> +	default:
>  		return -EINVAL;
>  	}
>  
> +	dev_dbg(pcdev_to_dev(pcdev),
> +		 "%s (vb=%p) nb_channels=%d size=%lu\n",
> +		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
> +
> +	WARN_ON(!pcdev->current_fmt);
> +
> +#ifdef DEBUG
>  	/*
> -	 * Limit to pxa hardware capabilities.  YUV422P planar format requires
> -	 * images size to be a multiple of 16 bytes.  If not, zeros will be
> -	 * inserted between Y and U planes, and U and V planes, which violates
> -	 * the YUV422P standard.
> +	 * This can be useful if you want to see if we actually fill
> +	 * the buffer with something
>  	 */
> -	v4l_bound_align_image(&pix->width, 48, 2048, 1,
> -			      &pix->height, 32, 2048, 0,
> -			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
> +	for (i = 0; i < vb->num_planes; i++)
> +		memset((void *)vb2_plane_vaddr(vb, i),
> +		       0xaa, vb2_get_plane_payload(vb, i));
> +#endif
>  
> -	/* limit to sensor capabilities */
> -	mf->width	= pix->width;
> -	mf->height	= pix->height;
> -	/* Only progressive video supported so far */
> -	mf->field	= V4L2_FIELD_NONE;
> -	mf->colorspace	= pix->colorspace;
> -	mf->code	= xlate->code;
> +	/*
> +	 * I think, in buf_prepare you only have to protect global data,
> +	 * the actual buffer is yours
> +	 */
> +	buf->inwork = 0;
> +	pxa_videobuf_set_actdma(pcdev, buf);
>  
> -	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
> -	if (ret < 0)
> -		return ret;
> +	return ret;
> +}
> +
> +static int pxac_vb2_init(struct vb2_buffer *vb)
> +{
> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
>  
> -	pix->width	= mf->width;
> -	pix->height	= mf->height;
> -	pix->colorspace	= mf->colorspace;
> +	dev_dbg(pcdev_to_dev(pcdev),
> +		 "%s(nb_channels=%d)\n",
> +		__func__, pcdev->channels);
>  
> -	switch (mf->field) {
> -	case V4L2_FIELD_ANY:
> -	case V4L2_FIELD_NONE:
> -		pix->field	= V4L2_FIELD_NONE;
> +	return pxa_buffer_init(pcdev, buf);
> +}
> +
> +static int pxac_vb2_queue_setup(struct vb2_queue *vq,
> +				unsigned int *nbufs,
> +				unsigned int *num_planes, unsigned int sizes[],
> +				void *alloc_ctxs[])
> +{
> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
> +	int size = pcdev->current_pix.sizeimage;
> +
> +	dev_dbg(pcdev_to_dev(pcdev),
> +		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
> +		__func__, vq, *nbufs, *num_planes, size);
> +	/*
> +	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
> +	 * format, even if there are 3 planes Y, U and V, we reply there is only
> +	 * one plane, containing Y, U and V data, one after the other.
> +	 */
> +	if (*num_planes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
> +	*num_planes = 1;
> +	switch (pcdev->channels) {
> +	case 1:
> +	case 3:
> +		sizes[0] = size;
>  		break;
>  	default:
> -		/* TODO: support interlaced at least in pass-through mode */
> -		dev_err(icd->parent, "Field type %d unsupported.\n",
> -			mf->field);
>  		return -EINVAL;
>  	}
>  
> +	alloc_ctxs[0] = pcdev->alloc_ctx;
> +	if (!*nbufs)
> +		*nbufs = 1;
> +
> +	return 0;
> +}
> +
> +static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +	vb2_wait_for_all_buffers(vq);
> +}
> +
> +static struct vb2_ops pxac_vb2_ops = {
> +	.queue_setup		= pxac_vb2_queue_setup,
> +	.buf_init		= pxac_vb2_init,
> +	.buf_prepare		= pxac_vb2_prepare,
> +	.buf_queue		= pxac_vb2_queue,
> +	.buf_cleanup		= pxac_vb2_cleanup,
> +	.stop_streaming		= pxac_vb2_stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
> +{
> +	int ret;
> +	struct vb2_queue *vq = &pcdev->vb2_vq;
> +
> +	memset(vq, 0, sizeof(*vq));
> +	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	vq->drv_priv = pcdev;
> +	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vq->buf_struct_size = sizeof(struct pxa_buffer);
> +
> +	vq->ops = &pxac_vb2_ops;
> +	vq->mem_ops = &vb2_dma_sg_memops;
> +	vq->lock = &pcdev->mlock;
> +
> +	ret = vb2_queue_init(vq);
> +	dev_dbg(pcdev_to_dev(pcdev),
> +		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
> +
>  	return ret;
>  }
>  
> -static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
> +static struct v4l2_clk_ops pxa_camera_mclk_ops = {
> +};
> +
> +static const struct video_device pxa_camera_videodev_template = {
> +	.name = "pxa-camera",
> +	.minor = -1,
> +	.fops = &pxa_camera_fops,
> +	.ioctl_ops = &pxa_camera_ioctl_ops,
> +	.release = video_device_release_empty,
> +};
> +
> +static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_subdev *subdev,
> +		     struct v4l2_async_subdev *asd)
>  {
> -	struct soc_camera_device *icd = file->private_data;
> +	int err;
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
> +	struct video_device *vdev = &pcdev->vdev;
> +	struct v4l2_pix_format *pix = &pcdev->current_pix;
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct v4l2_mbus_framefmt *mf = &format.format;
>  
> -	return vb2_poll(&icd->vb2_vidq, file, pt);
> +	dev_info(pcdev_to_dev(pcdev), "%s(): trying to bind a device\n",
> +		 __func__);
> +	mutex_lock(&pcdev->mlock);
> +	*vdev = pxa_camera_videodev_template;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->lock = &pcdev->mlock;
> +	pcdev->sensor = subdev;
> +	pcdev->vdev.queue = &pcdev->vb2_vq;
> +	pcdev->vdev.v4l2_dev = &pcdev->v4l2_dev;
> +	video_set_drvdata(&pcdev->vdev, pcdev);
> +
> +	v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
> +	v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
> +	v4l2_disable_ioctl(vdev, VIDIOC_ENUMSTD);

I don't think this is needed since the tvnorms field of struct video_device == 0,
signalling that there is no STD support.

> +
> +	err = pxa_camera_build_formats(pcdev);
> +	if (err) {
> +		dev_err(pcdev_to_dev(pcdev), "building formats failed: %d\n",
> +			err);
> +		goto out;
> +	}
> +
> +	pcdev->current_fmt = pcdev->user_formats;
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->width = DEFAULT_WIDTH;
> +	pix->height = DEFAULT_HEIGHT;
> +	pix->bytesperline =
> +		soc_mbus_bytes_per_line(pix->width,
> +					pcdev->current_fmt->host_fmt);
> +	pix->sizeimage =
> +		soc_mbus_image_size(pcdev->current_fmt->host_fmt,
> +				    pix->bytesperline, pix->height);
> +	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
> +	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
> +	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
> +	if (err)
> +		goto out;
> +
> +	v4l2_fill_pix_format(pix, mf);
> +	pr_info("%s(): colorspace=0x%x pixfmt=0x%x\n",
> +		__func__, pix->colorspace, pix->pixelformat);
> +
> +	err = pxa_camera_init_videobuf2(pcdev);
> +	if (err)
> +		goto out;
> +
> +	err = video_register_device(&pcdev->vdev, VFL_TYPE_GRABBER, -1);
> +	if (err) {
> +		v4l2_err(v4l2_dev, "register video device failed: %d\n", err);
> +		pcdev->sensor = NULL;
> +	} else {
> +		dev_info(pcdev_to_dev(pcdev),
> +			 "PXA Camera driver attached to camera %s\n",
> +			 subdev->name);
> +		subdev->owner = v4l2_dev->dev->driver->owner;
> +	}
> +out:
> +	mutex_unlock(&pcdev->mlock);
> +	return err;
>  }
>  
> -static int pxa_camera_querycap(struct soc_camera_host *ici,
> -			       struct v4l2_capability *cap)
> +static void pxa_camera_sensor_unbind(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_subdev *subdev,
> +		     struct v4l2_async_subdev *asd)
>  {
> -	/* cap->name is set by the firendly caller:-> */
> -	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
> -	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(notifier->v4l2_dev);
>  
> -	return 0;
> +	mutex_lock(&pcdev->mlock);
> +	dev_info(pcdev_to_dev(pcdev),
> +		 "PXA Camera driver detached from camera %s\n",
> +		 subdev->name);
> +
> +	/* disable capture, disable interrupts */
> +	__raw_writel(0x3ff, pcdev->base + CICR0);
> +
> +	/* Stop DMA engine */
> +	pxa_dma_stop_channels(pcdev);
> +
> +	pxa_camera_destroy_formats(pcdev);
> +	video_unregister_device(&pcdev->vdev);
> +	pcdev->sensor = NULL;
> +
> +	mutex_unlock(&pcdev->mlock);
>  }
>  
>  static int pxa_camera_suspend(struct device *dev)
>  {
> -	struct soc_camera_host *ici = to_soc_camera_host(dev);
> -	struct pxa_camera_dev *pcdev = ici->priv;
> +	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
>  	int i = 0, ret = 0;
>  
>  	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
> @@ -1498,9 +1623,8 @@ static int pxa_camera_suspend(struct device *dev)
>  	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
>  	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
>  
> -	if (pcdev->soc_host.icd) {
> -		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
> -		ret = v4l2_subdev_call(sd, core, s_power, 0);
> +	if (pcdev->sensor) {
> +		ret = sensor_call(pcdev, core, s_power, 0);
>  		if (ret == -ENOIOCTLCMD)
>  			ret = 0;
>  	}
> @@ -1510,8 +1634,7 @@ static int pxa_camera_suspend(struct device *dev)
>  
>  static int pxa_camera_resume(struct device *dev)
>  {
> -	struct soc_camera_host *ici = to_soc_camera_host(dev);
> -	struct pxa_camera_dev *pcdev = ici->priv;
> +	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
>  	int i = 0, ret = 0;
>  
>  	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
> @@ -1520,9 +1643,8 @@ static int pxa_camera_resume(struct device *dev)
>  	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
>  	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
>  
> -	if (pcdev->soc_host.icd) {
> -		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
> -		ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (pcdev->sensor) {
> +		ret = sensor_call(pcdev, core, s_power, 1);
>  		if (ret == -ENOIOCTLCMD)
>  			ret = 0;
>  	}
> @@ -1534,28 +1656,12 @@ static int pxa_camera_resume(struct device *dev)
>  	return ret;
>  }
>  
> -static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
> -	.owner		= THIS_MODULE,
> -	.add		= pxa_camera_add_device,
> -	.remove		= pxa_camera_remove_device,
> -	.clock_start	= pxa_camera_clock_start,
> -	.clock_stop	= pxa_camera_clock_stop,
> -	.set_crop	= pxa_camera_set_crop,
> -	.get_formats	= pxa_camera_get_formats,
> -	.put_formats	= pxa_camera_put_formats,
> -	.set_fmt	= pxa_camera_set_fmt,
> -	.try_fmt	= pxa_camera_try_fmt,
> -	.init_videobuf2	= pxa_camera_init_videobuf2,
> -	.poll		= pxa_camera_poll,
> -	.querycap	= pxa_camera_querycap,
> -	.set_bus_param	= pxa_camera_set_bus_param,
> -};
> -
>  static int pxa_camera_pdata_from_dt(struct device *dev,
> -				    struct pxa_camera_dev *pcdev)
> +				    struct pxa_camera_dev *pcdev,
> +				    struct v4l2_async_subdev *asd)
>  {
>  	u32 mclk_rate;
> -	struct device_node *np = dev->of_node;
> +	struct device_node *remote, *np = dev->of_node;
>  	struct v4l2_of_endpoint ep;
>  	int err = of_property_read_u32(np, "clock-frequency",
>  				       &mclk_rate);
> @@ -1607,6 +1713,15 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
>  	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>  		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
>  
> +	asd->match_type = V4L2_ASYNC_MATCH_OF;
> +	remote = of_graph_get_remote_port(np);
> +	if (remote) {
> +		asd->match.of.node = remote;
> +		of_node_put(remote);
> +	} else {
> +		dev_notice(dev, "no remote for %s\n", of_node_full_name(np));
> +	}
> +
>  out:
>  	of_node_put(np);
>  
> @@ -1625,6 +1740,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	};
>  	dma_cap_mask_t mask;
>  	struct pxad_param params;
> +	char clk_name[V4L2_CLK_NAME_SIZE];
>  	int irq;
>  	int err = 0, i;
>  
> @@ -1651,10 +1767,14 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  
>  	pcdev->pdata = pdev->dev.platform_data;
>  	if (&pdev->dev.of_node && !pcdev->pdata) {
> -		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev);
> +		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
>  	} else {
>  		pcdev->platform_flags = pcdev->pdata->flags;
>  		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
> +		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
> +		pcdev->asd.match.i2c.adapter_id =
> +			pcdev->pdata->sensor_i2c_adapter_id;
> +		pcdev->asd.match.i2c.address = pcdev->pdata->sensor_i2c_address;
>  	}
>  	if (err < 0)
>  		return err;
> @@ -1686,6 +1806,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  
>  	INIT_LIST_HEAD(&pcdev->capture);
>  	spin_lock_init(&pcdev->lock);
> +	mutex_init(&pcdev->mlock);
>  
>  	/*
>  	 * Request the regions.
> @@ -1748,19 +1869,48 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  		goto exit_free_dma;
>  	}
>  
> -	pcdev->soc_host.drv_name	= PXA_CAM_DRV_NAME;
> -	pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
> -	pcdev->soc_host.priv		= pcdev;
> -	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
> -	pcdev->soc_host.nr		= pdev->id;
>  	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
>  
> -	err = soc_camera_host_register(&pcdev->soc_host);
> +	pxa_camera_activate(pcdev);
> +
> +	dev_set_drvdata(&pdev->dev, pcdev);
> +	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
>  	if (err)
>  		goto exit_free_dma;
>  
> -	return 0;
> +	pcdev->asds[0] = &pcdev->asd;
> +	pcdev->notifier.subdevs = pcdev->asds;
> +	pcdev->notifier.num_subdevs = 1;
> +	pcdev->notifier.bound = pxa_camera_sensor_bound;
> +	pcdev->notifier.unbind = pxa_camera_sensor_unbind;
> +
> +	if (!of_have_populated_dt())
> +		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
>  
> +	err = pxa_camera_init_videobuf2(pcdev);
> +	if (err)
> +		goto exit_free_v4l2dev;
> +
> +	if (pcdev->mclk) {
> +		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
> +				  pcdev->asd.match.i2c.adapter_id,
> +				  pcdev->asd.match.i2c.address);
> +
> +		pcdev->mclk_clk = v4l2_clk_register(&pxa_camera_mclk_ops,
> +						    clk_name, NULL);
> +		if (IS_ERR(pcdev->mclk_clk))
> +			return PTR_ERR(pcdev->mclk_clk);
> +	}
> +
> +	err = v4l2_async_notifier_register(&pcdev->v4l2_dev, &pcdev->notifier);
> +	if (err)
> +		goto exit_free_clk;
> +
> +	return 0;
> +exit_free_clk:
> +	v4l2_clk_unregister(pcdev->mclk_clk);
> +exit_free_v4l2dev:
> +	v4l2_device_unregister(&pcdev->v4l2_dev);
>  exit_free_dma:
>  	dma_release_channel(pcdev->dma_chans[2]);
>  exit_free_dma_u:
> @@ -1772,16 +1922,16 @@ exit_free_dma_y:
>  
>  static int pxa_camera_remove(struct platform_device *pdev)
>  {
> -	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> -	struct pxa_camera_dev *pcdev = container_of(soc_host,
> -					struct pxa_camera_dev, soc_host);
> +	struct pxa_camera_dev *pcdev = dev_get_drvdata(&pdev->dev);
>  
> +	pxa_camera_deactivate(pcdev);
>  	dma_release_channel(pcdev->dma_chans[0]);
>  	dma_release_channel(pcdev->dma_chans[1]);
>  	dma_release_channel(pcdev->dma_chans[2]);
>  	vb2_dma_sg_cleanup_ctx(pcdev->alloc_ctx);
> +	v4l2_clk_unregister(pcdev->mclk_clk);
>  
> -	soc_camera_host_unregister(soc_host);
> +	v4l2_device_unregister(&pcdev->v4l2_dev);
>  
>  	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
>  
> diff --git a/include/linux/platform_data/media/camera-pxa.h b/include/linux/platform_data/media/camera-pxa.h
> index 6709b1cd7c77..ce5d90e1a6e4 100644
> --- a/include/linux/platform_data/media/camera-pxa.h
> +++ b/include/linux/platform_data/media/camera-pxa.h
> @@ -37,6 +37,8 @@
>  struct pxacamera_platform_data {
>  	unsigned long flags;
>  	unsigned long mclk_10khz;
> +	int sensor_i2c_adapter_id;
> +	int sensor_i2c_address;
>  };
>  
>  extern void pxa_set_camera_info(struct pxacamera_platform_data *);
> 

Thanks!

	Hans
