Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34439 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbcDRJwy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 05:52:54 -0400
Subject: Re: [PATCHv4] [media] rcar-vin: add Renesas R-Car VIN driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	ulrich.hecht@gmail.com
References: <1460471585-11225-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5714AE70.6030804@xs4all.nl>
Date: Mon, 18 Apr 2016 11:52:48 +0200
MIME-Version: 1.0
In-Reply-To: <1460471585-11225-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thanks for the patch. I've been testing this a bit more and there are a
few things missing.

On 04/12/2016 04:33 PM, Niklas Söderlund wrote:
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> new file mode 100644
> index 0000000..a752171
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -0,0 +1,732 @@
> +/*
> + * Driver for Renesas R-Car VIN
> + *
> + * Copyright (C) 2016 Renesas Electronics Corp.
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on the soc-camera rcar_vin driver
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/pm_runtime.h>
> +
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "rcar-vin.h"
> +
> +#define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_MAX_WIDTH		2048
> +#define RVIN_MAX_HEIGHT		2048
> +
> +/* -----------------------------------------------------------------------------
> + * Format Conversions
> + */
> +
> +static const struct rvin_video_format rvin_formats[] = {
> +	{
> +		.fourcc			= V4L2_PIX_FMT_NV16,
> +		.bpp			= 1,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_UYVY,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB565,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_XRGB555,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_XBGR32,
> +		.bpp			= 4,
> +	},
> +};
> +
> +const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(rvin_formats); i++)
> +		if (rvin_formats[i].fourcc == pixelformat)
> +			return rvin_formats + i;
> +
> +	return NULL;
> +}
> +
> +static u32 rvin_format_bytesperline(struct v4l2_pix_format *pix)
> +{
> +	const struct rvin_video_format *fmt;
> +
> +	fmt = rvin_format_from_pixel(pix->pixelformat);
> +
> +	if (WARN_ON(!fmt))
> +		return -EINVAL;
> +
> +	return pix->width * fmt->bpp;
> +}
> +
> +static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
> +{
> +	if (pix->pixelformat == V4L2_PIX_FMT_NV16)
> +		return pix->bytesperline * pix->height * 2;
> +
> +	return pix->bytesperline * pix->height;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2
> + */
> +
> +static int __rvin_try_format_sensor(struct rvin_dev *vin,
> +					u32 which,
> +					struct v4l2_pix_format *pix,
> +					struct rvin_sensor *sensor)
> +{
> +	struct v4l2_subdev *sd;
> +	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_format format = {
> +		.which = which,
> +	};
> +	int ret;
> +
> +	sd = vin_to_sd(vin);
> +
> +	v4l2_fill_mbus_format(&format.format, pix, vin->sensor.code);
> +
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
> +					 &pad_cfg, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pix, &format.format);
> +
> +	sensor->width = pix->width;
> +	sensor->height = pix->height;
> +
> +	vin_dbg(vin, "Sensor format: %ux%u\n", sensor->width, sensor->height);
> +
> +	return 0;
> +}
> +
> +static int __rvin_try_format(struct rvin_dev *vin,
> +				 u32 which,
> +				 struct v4l2_pix_format *pix,
> +				 struct rvin_sensor *sensor)
> +{
> +	const struct rvin_video_format *info;
> +	u32 rwidth, rheight, walign;
> +
> +	/* Requested */
> +	rwidth = pix->width;
> +	rheight = pix->height;
> +
> +	/*
> +	 * Retrieve format information and select the current format if the
> +	 * requested format isn't supported.
> +	 */
> +	info = rvin_format_from_pixel(pix->pixelformat);
> +	if (!info) {
> +		vin_dbg(vin, "Format %x not found, keeping %x\n",
> +			pix->pixelformat, vin->format.pixelformat);
> +		*pix = vin->format;
> +		pix->width = rwidth;
> +		pix->height = rheight;
> +	}
> +
> +	/* Always recalculate */
> +	pix->bytesperline = 0;
> +	pix->sizeimage = 0;
> +
> +	/* Limit to sensor capabilities */
> +	__rvin_try_format_sensor(vin, which, pix, sensor);
> +
> +	/* If sensor can't match format try if VIN can scale */
> +	if (sensor->width != rwidth || sensor->height != rheight)
> +		rvin_scale_try(vin, pix, rwidth, rheight);
> +
> +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> +	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
> +			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
> +
> +	switch (pix->field) {
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	default:
> +		pix->field = V4L2_FIELD_NONE;
> +		break;
> +	}
> +
> +	pix->bytesperline = max_t(u32, pix->bytesperline,
> +				  rvin_format_bytesperline(pix));
> +	pix->sizeimage = max_t(u32, pix->sizeimage,
> +			       rvin_format_sizeimage(pix));
> +
> +	vin_dbg(vin, "Requested %ux%u Got %ux%u bpl: %d size: %d\n",
> +		rwidth, rheight, pix->width, pix->height,
> +		pix->bytesperline, pix->sizeimage);
> +
> +	return 0;
> +}
> +
> +static int rvin_querycap(struct file *file, void *priv,
> +			 struct v4l2_capability *cap)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(vin->dev));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +		V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

In the very latest master branch support was added for a device_caps field in
struct video_device. It is recommended to fill in the device caps there when the
video_device struct is initialized. You can then drop initializing the device_caps
and capabilities here since the core will initialize them for you.

The advantage of this is that the core now knows the capabilities of the device.

> +	return 0;
> +}
> +
> +static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct rvin_sensor sensor;
> +
> +	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
> +				     &sensor);
> +}
> +
> +static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct rvin_sensor sensor;
> +	int ret;
> +
> +	if (vb2_is_busy(&vin->queue))
> +		return -EBUSY;
> +
> +	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> +				    &sensor);
> +	if (ret)
> +		return ret;
> +
> +	vin->sensor.width = sensor.width;
> +	vin->sensor.height = sensor.height;
> +
> +	vin->format = f->fmt.pix;
> +
> +	return 0;
> +}
> +
> +static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	f->fmt.pix = vin->format;
> +
> +	return 0;
> +}
> +
> +static int rvin_enum_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= ARRAY_SIZE(rvin_formats))
> +		return -EINVAL;
> +
> +	f->pixelformat = rvin_formats[f->index].fourcc;
> +
> +	return 0;
> +}
> +
> +static int rvin_g_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width = vin->sensor.width;
> +		s->r.height = vin->sensor.height;
> +		break;
> +	case V4L2_SEL_TGT_CROP:
> +		s->r = vin->crop;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width = vin->format.width;
> +		s->r.height = vin->format.height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		s->r = vin->compose;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

Both g_selection and s_selection do not check the type field. I've updated
v4l2-compliance so that it checks for that.

> +
> +static void rect_set_min_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *min_size)
> +{
> +	if (r->width < min_size->width)
> +		r->width = min_size->width;
> +	if (r->height < min_size->height)
> +		r->height = min_size->height;
> +}
> +
> +static void rect_set_max_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *max_size)
> +{
> +	if (r->width > max_size->width)
> +		r->width = max_size->width;
> +	if (r->height > max_size->height)
> +		r->height = max_size->height;
> +}
> +
> +static void rect_map_inside(struct v4l2_rect *r,
> +			    const struct v4l2_rect *boundary)
> +{
> +	rect_set_max_size(r, boundary);
> +
> +	if (r->left < boundary->left)
> +		r->left = boundary->left;
> +	if (r->top < boundary->top)
> +		r->top = boundary->top;
> +	if (r->left + r->width > boundary->width)
> +		r->left = boundary->width - r->width;
> +	if (r->top + r->height > boundary->height)
> +		r->top = boundary->height - r->height;
> +}
> +
> +static int rvin_s_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	const struct rvin_video_format *fmt;
> +	struct v4l2_rect r = s->r;
> +	struct v4l2_rect max_rect;
> +	struct v4l2_rect min_rect = {
> +		.width = 6,
> +		.height = 2,
> +	};
> +
> +	rect_set_min_size(&r, &min_rect);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		/* Can't crop outside of sensor input */
> +		max_rect.top = max_rect.left = 0;
> +		max_rect.width = vin->sensor.width;
> +		max_rect.height = vin->sensor.height;
> +		rect_map_inside(&r, &max_rect);
> +
> +		v4l_bound_align_image(&r.width, 2, vin->sensor.width, 1,
> +				      &r.height, 4, vin->sensor.height, 2, 0);
> +
> +		r.top  = clamp_t(s32, r.top, 0, vin->sensor.height - r.height);
> +		r.left = clamp_t(s32, r.left, 0, vin->sensor.width - r.width);
> +
> +		vin->crop = s->r = r;
> +
> +		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
> +			 r.width, r.height, r.left, r.top,
> +			 vin->sensor.width, vin->sensor.height);
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		/* Make sure compose rect fits inside output format */
> +		max_rect.top = max_rect.left = 0;
> +		max_rect.width = vin->format.width;
> +		max_rect.height = vin->format.height;
> +		rect_map_inside(&r, &max_rect);
> +
> +		/*
> +		 * Composing is done by adding a offset to the buffer address,
> +		 * the HW wants this address to be aligned to HW_BUFFER_MASK.
> +		 * Make sure the top and left values meets this requirement.
> +		 */
> +		while ((r.top * vin->format.bytesperline) & HW_BUFFER_MASK)
> +			r.top--;
> +
> +		fmt = rvin_format_from_pixel(vin->format.pixelformat);
> +		while ((r.left * fmt->bpp) & HW_BUFFER_MASK)
> +			r.left--;
> +
> +		vin->compose = s->r = r;
> +
> +		vin_dbg(vin, "Compose %dx%d@%d:%d in %dx%d\n",
> +			 r.width, r.height, r.left, r.top,
> +			 vin->format.width, vin->format.height);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* HW supports modifying configuration while running */
> +	rvin_crop_scale_comp(vin);
> +
> +	return 0;
> +}
> +
> +static int rvin_cropcap(struct file *file, void *priv,
> +			struct v4l2_cropcap *crop)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, cropcap, crop);
> +}

This should also check the type field. I've updated v4l2-compliance to
check this as well.

> +
> +static int rvin_enum_input(struct file *file, void *priv,
> +			   struct v4l2_input *i)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	if (i->index != 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	i->std = vin->vdev.tvnorms;
> +	strlcpy(i->name, "Camera", sizeof(i->name));

You should call the video op g_input_status() here to fill in the
v4l2_input status field. Without that the application won't know if
there is a valid signal or not.

> +
> +	return 0;
> +}
> +
> +static int rvin_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int rvin_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i > 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int rvin_querystd(struct file *file, void *priv, v4l2_std_id *a)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, querystd, a);
> +}
> +
> +static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, s_std, a);
> +}
> +
> +static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, g_std, a);
> +}
> +
> +static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
> +	.vidioc_querycap		= rvin_querycap,
> +	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= rvin_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
> +
> +	.vidioc_g_selection		= rvin_g_selection,
> +	.vidioc_s_selection		= rvin_s_selection,
> +
> +	.vidioc_cropcap			= rvin_cropcap,
> +
> +	.vidioc_enum_input		= rvin_enum_input,
> +	.vidioc_g_input			= rvin_g_input,
> +	.vidioc_s_input			= rvin_s_input,
> +
> +	.vidioc_querystd		= rvin_querystd,
> +	.vidioc_g_std			= rvin_g_std,
> +	.vidioc_s_std			= rvin_s_std,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * File Operations
> + */
> +
> +static int rvin_power_on(struct rvin_dev *vin)
> +{
> +	int ret;
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	pm_runtime_get_sync(vin->v4l2_dev.dev);
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +	return 0;
> +}
> +
> +static int rvin_power_off(struct rvin_dev *vin)
> +{
> +	int ret;
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 0);
> +
> +	pm_runtime_put(vin->v4l2_dev.dev);
> +
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int rvin_initialize_device(struct file *file)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	int ret;
> +
> +	struct v4l2_format f = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.fmt.pix = {
> +			.width		= vin->format.width,
> +			.height		= vin->format.height,
> +			.field		= vin->format.field,
> +			.colorspace	= vin->format.colorspace,
> +			.pixelformat	= vin->format.pixelformat,
> +		},
> +	};
> +
> +	ret = rvin_power_on(vin);
> +	if (ret < 0)
> +		return ret;
> +
> +	pm_runtime_enable(&vin->vdev.dev);
> +	ret = pm_runtime_resume(&vin->vdev.dev);
> +	if (ret < 0 && ret != -ENOSYS)
> +		goto eresume;
> +
> +	/*
> +	 * Try to configure with default parameters. Notice: this is the
> +	 * very first open, so, we cannot race against other calls,
> +	 * apart from someone else calling open() simultaneously, but
> +	 * .host_lock is protecting us against it.
> +	 */
> +	ret = rvin_s_fmt_vid_cap(file, NULL, &f);
> +	if (ret < 0)
> +		goto esfmt;
> +
> +	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
> +
> +	return 0;
> +esfmt:
> +	pm_runtime_disable(&vin->vdev.dev);
> +eresume:
> +	rvin_power_off(vin);
> +
> +	return ret;
> +}
> +
> +static int rvin_open(struct file *file)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&vin->lock);
> +
> +	file->private_data = vin;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		goto unlock;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	if (rvin_initialize_device(file)) {
> +		v4l2_fh_release(file);
> +		ret = -ENODEV;
> +	}
> +
> +unlock:
> +	mutex_unlock(&vin->lock);
> +	return ret;
> +}
> +
> +static int rvin_release(struct file *file)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	bool fh_singular;
> +	int ret;
> +
> +	mutex_lock(&vin->lock);
> +
> +	/* Save the singular status before we call the clean-up helper */
> +	fh_singular = v4l2_fh_is_singular_file(file);
> +
> +	/* the release helper will cleanup any on-going streaming */
> +	ret = _vb2_fop_release(file, NULL);
> +
> +	/*
> +	 * If this was the last open file.
> +	 * Then de-initialize hw module.
> +	 */
> +	if (fh_singular) {
> +		pm_runtime_suspend(&vin->vdev.dev);
> +		pm_runtime_disable(&vin->vdev.dev);
> +		rvin_power_off(vin);
> +	}
> +
> +	mutex_unlock(&vin->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations rvin_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= rvin_open,
> +	.release	= rvin_release,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +	.read		= vb2_fop_read,
> +};
> +
> +void rvin_v4l2_remove(struct rvin_dev *vin)
> +{
> +	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
> +		  video_device_node_name(&vin->vdev));
> +
> +	/* Checks internaly if handlers have been init or not */
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
> +	/* Checks internaly if vdev have been init or not */
> +	video_unregister_device(&vin->vdev);
> +}
> +
> +int rvin_v4l2_probe(struct rvin_dev *vin)
> +{
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct v4l2_mbus_framefmt *mf = &fmt.format;
> +	struct video_device *vdev = &vin->vdev;
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +	int ret;
> +
> +	v4l2_set_subdev_hostdata(sd, vin);
> +
> +	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	if (vin->vdev.tvnorms == 0) {
> +		/* Disable the STD API if there are no tvnorms defined */
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> +	}
> +
> +	/* Add the controls */
> +	/*
> +	 * Currently the subdev with the largest number of controls (13) is
> +	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> +	 * that this is a hint only: too large and you waste some memory, too
> +	 * small and there is a (very) small performance hit when looking up
> +	 * controls in the internal hash.
> +	 */
> +	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* video node */
> +	vdev->fops = &rvin_fops;
> +	vdev->v4l2_dev = &vin->v4l2_dev;
> +	vdev->queue = &vin->queue;
> +	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	vdev->release = video_device_release_empty;
> +	vdev->ioctl_ops = &rvin_ioctl_ops;
> +	vdev->lock = &vin->lock;
> +	vdev->ctrl_handler = &vin->ctrl_handler;
> +
> +	/* Try to improve our guess of a reasonable window format */
> +	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> +	if (ret) {
> +		vin_err(vin, "Failed to get initial format\n");
> +		return ret;
> +	}
> +
> +	/* Set default format */
> +	vin->format.width	= mf->width;
> +	vin->format.height	= mf->height;
> +	vin->format.colorspace	= mf->colorspace;
> +	vin->format.field	= mf->field;
> +	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
> +
> +
> +	/* Set initial crop and compose */
> +	vin->crop.top = vin->crop.left = 0;
> +	vin->crop.width = mf->width;
> +	vin->crop.height = mf->height;
> +
> +	vin->compose.top = vin->compose.left = 0;
> +	vin->compose.width = mf->width;
> +	vin->compose.height = mf->height;
> +
> +	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		vin_err(vin, "Failed to register video device\n");
> +		return ret;
> +	}
> +
> +	video_set_drvdata(&vin->vdev, vin);
> +
> +	v4l2_info(&vin->v4l2_dev, "Device registered as %s\n",
> +		  video_device_node_name(&vin->vdev));
> +
> +	return ret;
> +}

Regards,

	Hans

