Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53261 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031341Ab3HIWc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 18:32:27 -0400
Message-ID: <52056DF5.90701@gmail.com>
Date: Sat, 10 Aug 2013 00:32:21 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v4 06/13] [media] exynos5-fimc-is: Add isp subdev
References: <1375866242-18084-1-git-send-email-arun.kk@samsung.com> <1375866242-18084-7-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375866242-18084-7-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/2013 11:03 AM, Arun Kumar K wrote:
> fimc-is driver takes video data input from the ISP video node
> which is added in this patch. This node accepts Bayer input
> buffers which is given from the IS sensors.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-isp.c |  516 +++++++++++++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-isp.h |   90 ++++
>   2 files changed, 606 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-isp.c b/drivers/media/platform/exynos5-is/fimc-is-isp.c
> new file mode 100644
> index 0000000..afbf4a2
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-isp.c
> @@ -0,0 +1,516 @@
> +/*
> + * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *  Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<media/v4l2-ioctl.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#include "fimc-is.h"
> +
> +#define ISP_DRV_NAME "fimc-is-isp"
> +
> +static const struct fimc_is_fmt formats[] = {
> +	{
> +		.name           = "Bayer GR-BG 8bits",
> +		.fourcc         = V4L2_PIX_FMT_SGRBG8,
> +		.depth		= { 8 },
> +		.num_planes     = 1,
> +	},
> +	{
> +		.name           = "Bayer GR-BG 10bits",
> +		.fourcc         = V4L2_PIX_FMT_SGRBG10,
> +		.depth		= { 16 },
> +		.num_planes     = 1,
> +	},
> +	{
> +		.name           = "Bayer GR-BG 12bits",
> +		.fourcc         = V4L2_PIX_FMT_SGRBG12,
> +		.depth		= { 16 },
> +		.num_planes     = 1,
> +	},
> +};
> +#define NUM_FORMATS ARRAY_SIZE(formats)
> +
> +static const struct fimc_is_fmt *find_format(struct v4l2_format *f)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i<  NUM_FORMATS; i++)
> +		if (formats[i].fourcc == f->fmt.pix_mp.pixelformat)
> +			return&formats[i];
> +	return NULL;
> +}
> +
> +static int isp_video_output_start_streaming(struct vb2_queue *vq,
> +					unsigned int count)
> +{
> +	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
> +
> +	set_bit(STATE_RUNNING,&isp->output_state);
> +	return 0;
> +}
> +
> +static int isp_video_output_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
> +	struct fimc_is_buf *buf;
> +
> +	/* Release un-used buffers */

s/un-used/unused

> +	while (!list_empty(&isp->wait_queue)) {
> +		buf = fimc_is_isp_wait_queue_get(isp);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +	while (!list_empty(&isp->run_queue)) {
> +		buf = fimc_is_isp_run_queue_get(isp);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	clear_bit(STATE_RUNNING,&isp->output_state);
> +	return 0;
> +}
> +
> +static int isp_video_output_queue_setup(struct vb2_queue *vq,
> +			const struct v4l2_format *pfmt,
> +			unsigned int *num_buffers, unsigned int *num_planes,
> +			unsigned int sizes[], void *allocators[])
> +{
> +	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
> +	const struct fimc_is_fmt *fmt = isp->fmt;
> +	unsigned int wh, i;
> +
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	*num_planes = fmt->num_planes;
> +	wh = isp->width * isp->height;
> +
> +	for (i = 0; i<  *num_planes; i++) {
> +		allocators[i] = isp->alloc_ctx;
> +		sizes[i] = (wh * fmt->depth[i]) / 8;
> +	}
> +	return 0;
> +}
> +
> +static int isp_video_output_buffer_init(struct vb2_buffer *vb)
> +{
> +	struct fimc_is_buf *buf = container_of(vb, struct fimc_is_buf, vb);
> +
> +	buf->paddr[0] = vb2_dma_contig_plane_dma_addr(vb, 0);
> +	return 0;
> +}
> +
> +static void isp_video_output_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
> +	struct fimc_is_buf *buf = container_of(vb, struct fimc_is_buf, vb);
> +
> +	fimc_is_pipeline_buf_lock(isp->pipeline);
> +	fimc_is_isp_wait_queue_add(isp, buf);
> +	fimc_is_pipeline_buf_unlock(isp->pipeline);
> +
> +	/* Call shot command */
> +	fimc_is_pipeline_shot(isp->pipeline);
> +}
> +
> +static const struct vb2_ops isp_video_output_qops = {
> +	.queue_setup	 = isp_video_output_queue_setup,
> +	.buf_init	 = isp_video_output_buffer_init,
> +	.buf_queue	 = isp_video_output_buffer_queue,

Don't you need buf_prepare callback and be checking there is queued buffers
are appropriate for current H/W configuration ?

> +	.wait_prepare	 = vb2_ops_wait_prepare,
> +	.wait_finish	 = vb2_ops_wait_finish,
> +	.start_streaming = isp_video_output_start_streaming,
> +	.stop_streaming	 = isp_video_output_stop_streaming,
> +};
> +
> +static const struct v4l2_file_operations isp_video_output_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= v4l2_fh_open,
> +	.release	= vb2_fop_release,
> +	.poll		= vb2_fop_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= vb2_fop_mmap,
> +};
> +
> +/*
> + * Video node ioctl operations
> + */
> +static int isp_querycap_output(struct file *file, void *priv,
> +					struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, ISP_DRV_NAME, sizeof(cap->driver) - 1);
> +	strncpy(cap->card, ISP_DRV_NAME, sizeof(cap->card) - 1);
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +			ISP_DRV_NAME);
> +	cap->device_caps = V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int isp_enum_fmt_mplane(struct file *file, void *priv,
> +				     struct v4l2_fmtdesc *f)
> +{
> +	const struct fimc_is_fmt *fmt;
> +
> +	if (f->index>= NUM_FORMATS)
> +		return -EINVAL;
> +
> +	fmt =&formats[f->index];
> +	strlcpy(f->description, fmt->name, sizeof(f->description));
> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +
> +static int isp_g_fmt_mplane(struct file *file, void *fh,
> +				  struct v4l2_format *f)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	struct v4l2_pix_format_mplane *pixm =&f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *plane_fmt =&pixm->plane_fmt[0];
> +	const struct fimc_is_fmt *fmt = isp->fmt;
> +
> +	plane_fmt->bytesperline = (isp->width * fmt->depth[0]) / 8;
> +	plane_fmt->sizeimage = plane_fmt->bytesperline * isp->height;
> +	memset(plane_fmt->reserved, 0, sizeof(plane_fmt->reserved));
> +
> +	pixm->num_planes = fmt->num_planes;
> +	pixm->pixelformat = fmt->fourcc;
> +	pixm->width = isp->width;
> +	pixm->height = isp->height;
> +	pixm->field = V4L2_FIELD_NONE;
> +	pixm->colorspace = V4L2_COLORSPACE_JPEG;
> +	memset(pixm->reserved, 0, sizeof(pixm->reserved));
> +
> +	return 0;
> +}
> +
> +static int isp_try_fmt_mplane(struct file *file, void *fh,
> +		struct v4l2_format *f)
> +{
> +	const struct fimc_is_fmt *fmt;
> +	struct v4l2_pix_format_mplane *pixm =&f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *plane_fmt =&pixm->plane_fmt[0];
> +
> +	fmt = find_format(f);
> +	if (!fmt)
> +		fmt = (struct fimc_is_fmt *)&formats[0];
> +
> +	v4l_bound_align_image(&pixm->width,
> +			ISP_MIN_WIDTH + SENSOR_WIDTH_PADDING,
> +			ISP_MAX_WIDTH + SENSOR_WIDTH_PADDING, 0,
> +			&pixm->height,
> +			ISP_MIN_HEIGHT + SENSOR_HEIGHT_PADDING,
> +			ISP_MAX_HEIGHT + SENSOR_HEIGHT_PADDING, 0,
> +			0);
> +
> +	plane_fmt->bytesperline = (pixm->width * fmt->depth[0]) / 8;
> +	plane_fmt->sizeimage = (pixm->width * pixm->height *
> +				fmt->depth[0]) / 8;
> +	memset(plane_fmt->reserved, 0, sizeof(plane_fmt->reserved));
> +
> +	pixm->num_planes = fmt->num_planes;
> +	pixm->pixelformat = fmt->fourcc;
> +	pixm->colorspace = V4L2_COLORSPACE_JPEG;
> +	pixm->field = V4L2_FIELD_NONE;
> +	memset(pixm->reserved, 0, sizeof(pixm->reserved));
> +
> +	return 0;
> +}
> +
> +static int isp_s_fmt_mplane(struct file *file, void *priv,
> +		struct v4l2_format *f)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	const struct fimc_is_fmt *fmt;
> +	struct v4l2_pix_format_mplane *pixm =&f->fmt.pix_mp;
> +	int ret;
> +
> +	ret = isp_try_fmt_mplane(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	/* Get format type */
> +	fmt = find_format(f);
> +	if (!fmt) {
> +		fmt =&formats[0];
> +		pixm->pixelformat = fmt->fourcc;
> +		pixm->num_planes = fmt->num_planes;
> +	}
> +
> +	isp->fmt = fmt;
> +	isp->width = pixm->width;
> +	isp->height = pixm->height;
> +	isp->size_image = pixm->plane_fmt[0].sizeimage;
> +	set_bit(STATE_INIT,&isp->output_state);
> +	return 0;
> +}
> +
> +static int isp_reqbufs(struct file *file, void *priv,
> +		struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret;
> +
> +	reqbufs->count = max_t(u32, FIMC_IS_ISP_REQ_BUFS_MIN, reqbufs->count);
> +	ret = vb2_reqbufs(&isp->vbq, reqbufs);
> +	if (ret) {
> +		v4l2_err(&isp->subdev, "vb2 req buffers failed\n");
> +		return ret;
> +	}
> +
> +	if (reqbufs->count<  FIMC_IS_ISP_REQ_BUFS_MIN) {
> +		reqbufs->count = 0;
> +		vb2_reqbufs(&isp->vbq, reqbufs);
> +		return -ENOMEM;
> +	}
> +	set_bit(STATE_BUFS_ALLOCATED,&isp->output_state);
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops isp_video_output_ioctl_ops = {
> +	.vidioc_querycap		= isp_querycap_output,
> +	.vidioc_enum_fmt_vid_out_mplane	= isp_enum_fmt_mplane,
> +	.vidioc_try_fmt_vid_out_mplane	= isp_try_fmt_mplane,
> +	.vidioc_s_fmt_vid_out_mplane	= isp_s_fmt_mplane,
> +	.vidioc_g_fmt_vid_out_mplane	= isp_g_fmt_mplane,
> +	.vidioc_reqbufs			= isp_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +};
> +
> +static int isp_subdev_registered(struct v4l2_subdev *sd)
> +{
> +	struct fimc_is_isp *isp = v4l2_get_subdevdata(sd);
> +	struct vb2_queue *q =&isp->vbq;
> +	struct video_device *vfd =&isp->vfd;
> +	int ret;
> +
> +	mutex_init(&isp->video_lock);
> +
> +	memset(vfd, 0, sizeof(*vfd));
> +	snprintf(vfd->name, sizeof(vfd->name), "fimc-is-isp.output");
> +
> +	vfd->fops =&isp_video_output_fops;
> +	vfd->ioctl_ops =&isp_video_output_ioctl_ops;
> +	vfd->v4l2_dev = sd->v4l2_dev;
> +	vfd->release = video_device_release_empty;
> +	vfd->lock =&isp->video_lock;
> +	vfd->queue = q;
> +	vfd->vfl_dir = VFL_DIR_TX;
> +	set_bit(V4L2_FL_USE_FH_PRIO,&vfd->flags);
> +
> +	memset(q, 0, sizeof(*q));
> +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	q->io_modes = VB2_MMAP | VB2_DMABUF;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->ops =&isp_video_output_qops;
> +	q->mem_ops =&vb2_dma_contig_memops;
> +	q->buf_struct_size = sizeof(struct fimc_is_buf);
> +	q->drv_priv = isp;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret<  0)
> +		return ret;
> +
> +	isp->vd_pad.flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_init(&vfd->entity, 1,&isp->vd_pad, 0);
> +	if (ret<  0)
> +		return ret;
> +
> +	video_set_drvdata(vfd, isp);
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +	if (ret<  0) {
> +		media_entity_cleanup(&vfd->entity);
> +		return ret;
> +	}
> +
> +	v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
> +		  vfd->name, video_device_node_name(vfd));
> +	return 0;
> +}
> +
> +static void isp_subdev_unregistered(struct v4l2_subdev *sd)
> +{
> +	struct fimc_is_isp *isp = v4l2_get_subdevdata(sd);
> +
> +	if (isp&&  video_is_registered(&isp->vfd))
> +		video_unregister_device(&isp->vfd);
> +}
> +
> +static const struct v4l2_subdev_internal_ops isp_subdev_internal_ops = {
> +	.registered = isp_subdev_registered,
> +	.unregistered = isp_subdev_unregistered,
> +};
> +
> +static struct fimc_is_sensor *fimc_is_get_sensor(struct fimc_is *is,
> +		int sensor_id)
> +{
> +	int i;
> +
> +	for (i = 0; i<  FIMC_IS_NUM_SENSORS; i++) {
> +		if (is->sensor[i].drvdata->id == sensor_id)
> +			return&is->sensor[i];
> +	}
> +	return NULL;
> +}
> +
> +static int isp_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct fimc_is_isp *isp = v4l2_get_subdevdata(sd);
> +	struct fimc_is *is = isp->pipeline->is;
> +	struct v4l2_subdev *sensor_sd = isp->sensor_sd;
> +	struct fimc_is_sensor *sensor;
> +	const struct sensor_drv_data *sdata;
> +	int ret;
> +
> +	if (!sensor_sd)
> +		return -EINVAL;
> +
> +	if (on) {
> +		ret = pm_runtime_get_sync(&is->pdev->dev);
> +		if (ret<  0)
> +			return ret;
> +
> +		sdata = exynos5_is_sensor_get_drvdata(sensor_sd->dev->of_node);
> +		sensor = fimc_is_get_sensor(is, sdata->id);
> +
> +		ret = fimc_is_pipeline_open(isp->pipeline, sensor);
> +		if (ret)
> +			v4l2_err(&isp->subdev, "Pipeline open failed\n");
> +	} else {
> +		ret = fimc_is_pipeline_close(isp->pipeline);
> +		if (ret)
> +			v4l2_err(&isp->subdev, "Pipeline close failed\n");
> +		pm_runtime_put_sync(&is->pdev->dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct v4l2_subdev_core_ops isp_core_ops = {
> +	.s_power = isp_s_power,
> +};
> +
> +static int isp_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct fimc_is_isp *isp = v4l2_get_subdevdata(sd);
> +	struct fimc_is *is = isp->pipeline->is;
> +	struct v4l2_subdev *sensor_sd = isp->sensor_sd;
> +	struct v4l2_subdev_format fmt;
> +	const struct sensor_drv_data *sdata;
> +	struct fimc_is_sensor *sensor;
> +	int ret;
> +
> +	if (!sensor_sd)
> +		return -EINVAL;
> +
> +	if (enable) {
> +		sdata = exynos5_is_sensor_get_drvdata(sensor_sd->dev->of_node);
> +		sensor = fimc_is_get_sensor(is, sdata->id);
> +		/* Retrieve the sensor format */
> +		fmt.pad = 0;
> +		fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		ret = v4l2_subdev_call(sensor_sd, pad, get_fmt, NULL,&fmt);
> +		if (ret)
> +			return ret;
> +
> +		sensor->width = fmt.format.width - SENSOR_WIDTH_PADDING;
> +		sensor->height = fmt.format.height - SENSOR_HEIGHT_PADDING;
> +		sensor->pixel_width = fmt.format.width;
> +		sensor->pixel_height = fmt.format.height;
> +
> +		/* Check sensor resolution match */
> +		if ((sensor->pixel_width != isp->width) ||
> +			(sensor->pixel_height != isp->height)) {
> +			v4l2_err(sd, "Resolution mismatch\n");
> +			return -EPIPE;
> +		}
> +
> +		ret = fimc_is_pipeline_start(isp->pipeline);
> +		if (ret)
> +			v4l2_err(sd, "Pipeline start failed.\n");
> +	} else {
> +		ret = fimc_is_pipeline_stop(isp->pipeline);
> +		if (ret)
> +			v4l2_err(sd, "Pipeline stop failed.\n");
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_video_ops isp_video_ops = {
> +	.s_stream       = isp_s_stream,
> +};
> +
> +static struct v4l2_subdev_ops isp_subdev_ops = {
> +	.core =&isp_core_ops,
> +	.video =&isp_video_ops,
> +};
> +
> +int fimc_is_isp_subdev_create(struct fimc_is_isp *isp,
> +		struct vb2_alloc_ctx *alloc_ctx,
> +		struct fimc_is_pipeline *pipeline)
> +{
> +	struct v4l2_ctrl_handler *handler =&isp->ctrl_handler;
> +	struct v4l2_subdev *sd =&isp->subdev;
> +	int ret;
> +
> +	isp->alloc_ctx = alloc_ctx;
> +	isp->pipeline = pipeline;
> +	isp->fmt =&formats[1];
> +	INIT_LIST_HEAD(&isp->wait_queue);
> +	INIT_LIST_HEAD(&isp->run_queue);
> +	isp->width = ISP_DEF_WIDTH;
> +	isp->height = ISP_DEF_HEIGHT;
> +
> +	v4l2_subdev_init(sd,&isp_subdev_ops);
> +	sd->owner = THIS_MODULE;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(sd->name, sizeof(sd->name), ISP_DRV_NAME);
> +
> +	isp->subdev_pads[ISP_SD_PAD_SINK_DMA].flags = MEDIA_PAD_FL_SINK;
> +	isp->subdev_pads[ISP_SD_PAD_SINK_OTF].flags = MEDIA_PAD_FL_SINK;
> +	isp->subdev_pads[ISP_SD_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sd->entity, ISP_SD_PADS_NUM,
> +			isp->subdev_pads, 0);
> +	if (ret<  0)
> +		return ret;
> +
> +	ret = v4l2_ctrl_handler_init(handler, 1);
> +	if (handler->error)
> +		goto err_ctrl;
> +
> +	sd->ctrl_handler = handler;
> +	sd->internal_ops =&isp_subdev_internal_ops;
> +	v4l2_set_subdevdata(sd, isp);
> +
> +	return 0;
> +
> +err_ctrl:
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_ctrl_handler_free(handler);
> +	return ret;
> +}
> +
> +void fimc_is_isp_subdev_destroy(struct fimc_is_isp *isp)
> +{
> +	struct v4l2_subdev *sd =&isp->subdev;
> +
> +	v4l2_device_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_ctrl_handler_free(&isp->ctrl_handler);
> +	v4l2_set_subdevdata(sd, NULL);
> +}
> +
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-isp.h b/drivers/media/platform/exynos5-is/fimc-is-isp.h
> new file mode 100644
> index 0000000..fdb6d86
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-isp.h
> @@ -0,0 +1,90 @@
> +/*
> + * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
> + *  Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef FIMC_IS_ISP_H_
> +#define FIMC_IS_ISP_H_
> +
> +#include "fimc-is-core.h"
> +#include "fimc-is-pipeline.h"
> +
> +#define FIMC_IS_ISP_REQ_BUFS_MIN	2
> +
> +#define ISP_SD_PAD_SINK_DMA	0
> +#define ISP_SD_PAD_SINK_OTF	1
> +#define ISP_SD_PAD_SRC		2
> +#define ISP_SD_PADS_NUM		3
> +
> +#define ISP_DEF_WIDTH		1296
> +#define ISP_DEF_HEIGHT		732
> +
> +#define ISP_MAX_WIDTH		4808
> +#define ISP_MAX_HEIGHT		3356
> +#define ISP_MIN_WIDTH		32
> +#define ISP_MIN_HEIGHT		32
> +
> +#define ISP_MAX_BUFS		2
> +
> +/**
> + * struct fimc_is_isp - ISP context
> + * @vfd: video device node
> + * @fh: v4l2 file handle
> + * @alloc_ctx: videobuf2 memory allocator context
> + * @subdev: fimc-is-isp subdev
> + * @vd_pad: media pad for the output video node
> + * @subdev_pads: the subdev media pads
> + * @ctrl_handler: v4l2 control handler
> + * @video_lock: video lock mutex
> + * @sensor_sd: sensor subdev used with this isp instance
> + * @pipeline: pipeline instance for this isp context
> + * @vbq: vb2 buffers queue for ISP output video node
> + * @wait_queue: list holding buffers waiting to be queued to HW
> + * @wait_queue_cnt: wait queue number of buffers
> + * @run_queue: list holding buffers queued to HW
> + * @run_queue_cnt: run queue number of buffers
> + * @output_bufs: isp output buffers array
> + * @out_buf_cnt: number of output buffers in use
> + * @fmt: output plane format for isp
> + * @width: user configured input width
> + * @height: user configured input height
> + * @size_image: image size in bytes
> + * @output_state: state of the output video node operations
> + */
> +struct fimc_is_isp {
> +	struct video_device		vfd;
> +	struct v4l2_fh			fh;
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	struct v4l2_subdev		subdev;
> +	struct media_pad		vd_pad;
> +	struct media_pad		subdev_pads[ISP_SD_PADS_NUM];
> +	struct v4l2_ctrl_handler	ctrl_handler;
> +	struct mutex			video_lock;
> +
> +	struct v4l2_subdev		*sensor_sd;
> +	struct fimc_is_pipeline		*pipeline;
> +
> +	struct vb2_queue		vbq;
> +	struct list_head		wait_queue;
> +	unsigned int			wait_queue_cnt;
> +	struct list_head		run_queue;
> +	unsigned int			run_queue_cnt;
> +
> +	const struct fimc_is_fmt	*fmt;
> +	unsigned int			width;
> +	unsigned int			height;
> +	unsigned int			size_image;
> +	unsigned long			output_state;
> +};
> +
> +int fimc_is_isp_subdev_create(struct fimc_is_isp *isp,
> +		struct vb2_alloc_ctx *alloc_ctx,
> +		struct fimc_is_pipeline *pipeline);
> +void fimc_is_isp_subdev_destroy(struct fimc_is_isp *isp);
> +
> +#endif /* FIMC_IS_ISP_H_ */

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester

