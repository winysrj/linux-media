Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:50384 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3CWSiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 14:38:16 -0400
Message-ID: <514DF693.2080308@gmail.com>
Date: Sat, 23 Mar 2013 19:38:11 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 07/12] exynos-fimc-is: Adds isp subdev
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-8-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-8-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> fimc-is driver takes video data input from the ISP video node
> which is added in this patch. This node accepts Bayer input
> buffers which is given from the IS sensors.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-isp.c |  546 +++++++++++++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-isp.h |   88 ++++
>   2 files changed, 634 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-isp.c b/drivers/media/platform/exynos5-is/fimc-is-isp.c
> new file mode 100644
> index 0000000..e68e936
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-isp.c
> @@ -0,0 +1,546 @@
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
> +static struct fimc_is_fmt formats[] = {

static const ?

> +	{
> +		.name           = "Bayer GR-BG 8bits",
> +		.fourcc         = V4L2_PIX_FMT_SGRBG8,
> +		.depth		= {8},

nit:

> +		.num_planes     = 1,
> +	},
> +	{
> +		.name           = "Bayer GR-BG 10bits",
> +		.fourcc         = V4L2_PIX_FMT_SGRBG10,
> +		.depth		= {10},
> +		.num_planes     = 1,
> +	},
> +	{
> +		.name           = "Bayer GR-BG 12bits",
> +		.fourcc         = V4L2_PIX_FMT_SGRBG12,
> +		.depth		= {12},
> +		.num_planes     = 1,
> +	},
> +};
> +#define NUM_FORMATS ARRAY_SIZE(formats)
[...]
> +static int isp_video_output_open(struct file *file)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret = 0;
> +
> +	/* Check if opened before */
> +	if (isp->refcount>= FIMC_IS_MAX_INSTANCES) {
> +		is_err("All instances are in use.\n");
> +		return -EBUSY;
> +	}
> +
> +	INIT_LIST_HEAD(&isp->wait_queue);
> +	isp->wait_queue_cnt = 0;
> +	INIT_LIST_HEAD(&isp->run_queue);
> +	isp->run_queue_cnt = 0;
> +
> +	isp->refcount++;
> +	return ret;
> +}
> +
> +static int isp_video_output_close(struct file *file)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret = 0;
> +
> +	isp->refcount--;
> +	vb2_queue_release(&isp->vbq);
> +	isp->output_state = 0;
> +	return ret;
> +}
> +
> +static unsigned int isp_video_output_poll(struct file *file,
> +				   struct poll_table_struct *wait)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&isp->video_lock))
> +		return POLL_ERR;
> +
> +	ret = vb2_poll(&isp->vbq, file, wait);
> +	mutex_unlock(&isp->video_lock);
> +
> +	return ret;
> +}
> +
> +static int isp_video_output_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&isp->video_lock))
> +		return -ERESTARTSYS;
> +
> +	ret = vb2_mmap(&isp->vbq, vma);
> +	mutex_unlock(&isp->video_lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations isp_video_output_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= isp_video_output_open,
> +	.release	= isp_video_output_close,
> +	.poll		= isp_video_output_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= isp_video_output_mmap,

I suggest to use vb2_fop_poll/mmap/release, v4l2_fh_open where possible.

> +};
> +
> +/*
> + * Video node ioctl operations
> + */
> +static int isp_querycap_output(struct file *file, void *priv,
> +					struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, "fimc-is-isp", sizeof(cap->driver));
> +	cap->bus_info[0] = 0;

bus_info must not be empty, it could be fimc-is platform device name.

> +	cap->card[0] = 0;
> +	cap->capabilities = V4L2_CAP_STREAMING;

Please set cap->device_caps as well.

> +	return 0;
> +}

> +static int isp_try_fmt_mplane(struct file *file, void *fh,
> +		struct v4l2_format *f)
> +{
> +	struct fimc_is_fmt *fmt;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;

This check is not needed.

> +	fmt = find_format(f);
> +	if (!fmt) {
> +		is_err("Format not supported.\n");
> +		return -EINVAL;

Instead some default format should be picked, and no error returned here.

> +	}
> +
> +	if (fmt->num_planes != f->fmt.pix_mp.num_planes) {

Again, the kernel is supposed to adjust and fill in the format data
structure with valid values. So you should just do

	f->fmt.pix_mp.num_planes = fmt->num_planes;

And no error must be returned.

> +		is_err("Number of planes mismatch\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int isp_s_fmt_mplane(struct file *file, void *priv,
> +		struct v4l2_format *f)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	struct fimc_is_pipeline *p = isp->pipeline;
> +	struct fimc_is_fmt *fmt;
> +	unsigned int sensor_width, sensor_height;
> +	int ret;
> +
> +	ret = isp_try_fmt_mplane(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	/* Get format type */
> +	fmt = find_format(f);
> +	if (!fmt) {
> +		is_err("Format not supported.\n");
> +		return -EINVAL;

Same as above, just pick some default format.

> +	}
> +
> +	/* Check if same as sensor width&  height */
> +	sensor_width = p->sensor->sensor_info->pixel_width;
> +	sensor_height = p->sensor->sensor_info->pixel_height;
> +	if ((sensor_width != f->fmt.pix_mp.width) ||
> +		(sensor_height != f->fmt.pix_mp.height)) {
> +		is_err("ISP resolution should be same as sensor\n");

If these resolutions need to match then you may want to do:

f->fmt.pix_mp.width = sensor_width;
f->fmt.pix_mp.height = sensor_height;

> +		return -EINVAL;

No, this is incorrect.

> +	}
> +
> +	isp->fmt = fmt;
> +	isp->width = f->fmt.pix_mp.width;
> +	isp->height = f->fmt.pix_mp.height;
> +	isp->size_image = f->fmt.pix_mp.plane_fmt[0].sizeimage;
> +	set_bit(STATE_INIT,&isp->output_state);

The driver should have some initial default values, so the configuration
is valid right after initialization. rather than tracking which calls
took place in user space.

> +	return 0;
> +}
> +
> +static int isp_streamon(struct file *file, void *priv,
> +		enum v4l2_buf_type type)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret;
> +
> +	ret = vb2_streamon(&isp->vbq, type);
> +	return 0;
> +}
> +
> +static int isp_streamoff(struct file *file, void *priv,
> +		enum v4l2_buf_type type)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret;
> +
> +	ret = vb2_streamoff(&isp->vbq, type);
> +	return 0;
> +}

I suggest you to use vb2_ioctl_* helpers where possible. Lots of such
boilerplate code can be removed when you switch to use those.

> +static int isp_reqbufs(struct file *file, void *priv,
> +		struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	int ret;
> +
> +	if (!isp->fmt) {
> +		is_err("Set format not done\n");
> +		return -EINVAL;

That's wrong. As mentioned above, there must be some initial valid
configuration (image format), so you can call reqbufs ioctl right
after opening /dev/video.

Whether the whole processing pipeline is consistent or not should be 
checked
in streamon ioctl.

> +	}
> +
> +	/* Check whether buffers are already allocated */
> +	if (test_bit(STATE_BUFS_ALLOCATED,&isp->output_state)) {
> +		is_err("Buffers already allocated\n");
> +		return -EINVAL;

What happens when reqbufs->count == 0 ? How is this code supposed to 
allow to
actually free buffers ?

I don't think you need this kind of checks in this ioctl handler. videobuf2
is supposed to handle that sort of things.

> +	}
> +
> +	ret = vb2_reqbufs(&isp->vbq, reqbufs);
> +	if (ret) {
> +		is_err("vb2 req buffers failed\n");

Would be better to use standard error logging APIs, e.g. v4l2_err().

> +		return ret;
> +	}
> +
> +	isp->num_buffers = reqbufs->count;
> +	isp->out_buf_cnt = 0;
> +	set_bit(STATE_BUFS_ALLOCATED,&isp->output_state);
> +	return 0;
> +}

> +static int isp_querybuf(struct file *file, void *priv,
> +		struct v4l2_buffer *buf)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	return vb2_querybuf(&isp->vbq, buf);
> +}
> +
> +static int isp_qbuf(struct file *file, void *priv,
> +		struct v4l2_buffer *buf)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	return vb2_qbuf(&isp->vbq, buf);
> +}
> +
> +static int isp_dqbuf(struct file *file, void *priv,
> +		struct v4l2_buffer *buf)
> +{
> +	struct fimc_is_isp *isp = video_drvdata(file);
> +	return vb2_dqbuf(&isp->vbq, buf,
> +			file->f_flags&  O_NONBLOCK);
> +}

These are all good candidates for replacing with vb2_ioctl_* helpers.

> +static const struct v4l2_ioctl_ops isp_video_output_ioctl_ops = {
> +	.vidioc_querycap		= isp_querycap_output,
> +	.vidioc_enum_fmt_vid_out_mplane	= isp_enum_fmt_mplane,
> +	.vidioc_try_fmt_vid_out_mplane	= isp_try_fmt_mplane,
> +	.vidioc_s_fmt_vid_out_mplane	= isp_s_fmt_mplane,
> +	.vidioc_g_fmt_vid_out_mplane	= isp_g_fmt_mplane,
> +	.vidioc_reqbufs			= isp_reqbufs,
> +	.vidioc_querybuf		= isp_querybuf,
> +	.vidioc_qbuf			= isp_qbuf,
> +	.vidioc_dqbuf			= isp_dqbuf,
> +	.vidioc_streamon		= isp_streamon,
> +	.vidioc_streamoff		= isp_streamoff,
> +};
> +
> +static int isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	/* Nothing to do.*/
> +	return 0;
> +}
> +
> +static int isp_subdev_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	/* Nothing to do here as everything is turned on from sensor */

Then please remove these empty functions.

> +	return 0;
> +}
> +
[...]
> +int fimc_is_isp_subdev_create(struct fimc_is_isp *isp,
> +		struct vb2_alloc_ctx *alloc_ctx,
> +		struct fimc_is_pipeline *pipeline)
> +{
> +	struct v4l2_ctrl_handler *handler =&isp->ctrl_handler;
> +	struct v4l2_subdev *sd =&isp->subdev;
> +	int ret;
> +
> +	/* Init context vars */
> +	isp->alloc_ctx = alloc_ctx;
> +	isp->pipeline = pipeline;
> +	isp->refcount = 0;
> +	isp->fmt =&formats[1];
> +
> +	v4l2_subdev_init(sd,&isp_subdev_ops);
> +	sd->owner = THIS_MODULE;
> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(sd->name, sizeof(sd->name), "fimc-is-isp");
> +
> +	isp->subdev_pads[ISP_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> +	isp->subdev_pads[ISP_SD_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sd->entity, ISP_SD_PADS_NUM,
> +			isp->subdev_pads, 0);
> +	if (ret<  0)
> +		return ret;
> +
> +	v4l2_ctrl_handler_init(handler, 1);
> +	if (handler->error)
> +		return handler->error;

Memory leak due to missing media_entity_cleanup() and 
v4l2_ctrl_handler_free()
calls.

> +
> +	sd->ctrl_handler = handler;
> +	sd->internal_ops =&isp_subdev_internal_ops;
> +	v4l2_set_subdevdata(sd, isp);
> +
> +	return 0;
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
> index 0000000..be6289f
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-isp.h
> @@ -0,0 +1,88 @@
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
> +#define ISP_SD_PAD_SINK		0
> +#define ISP_SD_PAD_SRC		1
> +#define ISP_SD_PADS_NUM		2

What about the ISP video device entities ? To which ISP pads are these 
connected ?

For Exynos4x12 there are two additional pads where the ISP video output and
capture entities are to be connected. Currently there are only SINK, 
SRC_FIFO
and SRC_DMA pads, but SINK_DMA and an output video device could be added in
future if required.
