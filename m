Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3FMNMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 09:12:39 -0400
Date: Thu, 13 Jun 2013 15:12:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
In-Reply-To: <201305240211.29665.sergei.shtylyov@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1306131245420.31976@axis700.grange>
References: <201305240211.29665.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei

Patches, that this commit is based upon are hopefully moving towards the 
mainline, but it's still possible, that some more changes will be 
required. In any case, I wanted to comment to this version to let you 
prepare for a new version in advance.

In general - looks better!

On Fri, 24 May 2013, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add Renesas R-Car VIN (Video In) V4L2 driver.
> 
> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> *if* statement  and  used 'bool' values instead of 0/1 where necessary, removed
> unused macros, done some reformatting and clarified some comments.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---

[snip]

> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> ===================================================================
> --- /dev/null
> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -0,0 +1,1476 @@
> +/*
> + * SoC-camera host driver for Renesas R-Car VIN unit
> + *
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + *
> + * Based on V4L2 Driver for SuperH Mobile CEU interface "sh_mobile_ceu_camera.c"
> + *
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/platform_data/camera-rcar.h>

"l" before "m" please :)

[snip]

> +static void rcar_vin_setup(struct rcar_vin_priv *priv)
> +{
> +	struct soc_camera_device *icd = priv->icd;
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	u32 vnmc, dmr, interrupts;
> +	bool progressive = false, output_is_yuv = false;
> +
> +	switch (priv->field) {
> +	case V4L2_FIELD_TOP:
> +		vnmc = VNMC_IM_ODD;
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		vnmc = VNMC_IM_EVEN;
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +		vnmc = VNMC_IM_FULL;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +		vnmc = VNMC_IM_FULL | VNMC_FOC;
> +		break;
> +	case V4L2_FIELD_NONE:
> +		if (is_continuous_transfer(priv)) {
> +			vnmc = VNMC_IM_ODD_EVEN;
> +			progressive = true;
> +		} else {
> +			vnmc = VNMC_IM_ODD;
> +		}
> +		break;
> +	default:
> +		vnmc = VNMC_IM_ODD;
> +		break;
> +	}
> +
> +	/* input interface */
> +	switch (icd->current_fmt->code) {
> +	case V4L2_MBUS_FMT_YUYV8_1X16:
> +		/* BT.601/BT.1358 16bit YCbCr422 */
> +		vnmc |= VNMC_INF_YUV16;
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> +		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
> +			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> +	default:
> +		break;
> +	}
> +
> +	/* output format */
> +	switch (icd->current_fmt->host_fmt->fourcc) {
> +	case V4L2_PIX_FMT_NV16:
> +		iowrite32(ALIGN(cam->width * cam->height, 0x80),
> +			  priv->base + VNUVAOF_REG);
> +		dmr = VNDMR_DTMD_YCSEP;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		dmr = VNDMR_BPSM;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		dmr = 0;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_RGB555X:
> +		dmr = VNDMR_DTMD_ARGB1555;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		dmr = 0;
> +		break;
> +	case V4L2_PIX_FMT_RGB32:
> +		if (priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
> +			dmr = VNDMR_EXRGB;
> +			break;
> +		}
> +	default:
> +		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
> +			 icd->current_fmt->host_fmt->fourcc);

I'll put a marker here for now: I don't understand the logic - either you 
don't support this case, then you should either fail somehow or switch to 
a supported case, or you do support it, then you don't need a warning

[snip]

> +static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	unsigned long size;
> +	int bytes_per_line;
> +
> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						 icd->current_fmt->host_fmt);
> +	if (bytes_per_line < 0)
> +		goto error;
> +
> +	size = icd->user_height * bytes_per_line;

You haven't fixed this

[snip]

> +static irqreturn_t rcar_vin_irq(int irq, void *data)
> +{
> +	struct rcar_vin_priv *priv = data;
> +	u32 int_status;
> +	bool can_run = false, hw_stopped;
> +	int slot;
> +	unsigned int handled = 0;
> +
> +	spin_lock(&priv->lock);
> +
> +	int_status = ioread32(priv->base + VNINTS_REG);
> +	if (!int_status)
> +		goto done;
> +	/* ack interrupts */
> +	iowrite32(int_status, priv->base + VNINTS_REG);
> +	handled = 1;
> +
> +	/* nothing to do if capture status is 'STOPPED' */
> +	if (priv->state == STOPPED)
> +		goto done;
> +
> +	hw_stopped = !(ioread32(priv->base + VNMS_REG) & VNMS_CA);
> +
> +	if (!priv->request_to_stop) {
> +		if (is_continuous_transfer(priv))
> +			slot = (ioread32(priv->base + VNMS_REG) &
> +				VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
> +		else
> +			slot = 0;
> +
> +		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
> +		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
> +		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
> +		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
> +		priv->queue_buf[slot] = NULL;
> +
> +		if (priv->state != STOPPING)
> +			can_run = rcar_vin_fill_hw_slot(priv);
> +
> +		if (hw_stopped || !can_run) {
> +			priv->state = STOPPED;
> +		} else if (is_continuous_transfer(priv) &&
> +			   list_empty(&priv->capture) &&
> +			   priv->state == RUNNING) {
> +			/*
> +			 * The continuous capturing requires an explicit stop
> +			 * operation when there is no buffer to be set into
> +			 * the VnMBm registers.
> +			 */
> +			rcar_vin_request_capture_stop(priv);
> +		} else {
> +			rcar_vin_capture(priv);
> +		}

You don't need braces here

> +
> +	} else if (hw_stopped) {
> +		priv->state = STOPPED;
> +		priv->request_to_stop = false;
> +		complete(&priv->capture_stop);
> +	}
> +
> +done:
> +	spin_unlock(&priv->lock);
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
> +static int rcar_vin_add_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	int i;
> +
> +	if (priv->icd)
> +		return -EBUSY;
> +
> +	for (i = 0; i < MAX_BUFFER_NUM; i++)
> +		priv->queue_buf[i] = NULL;
> +
> +	pm_runtime_get_sync(ici->v4l2_dev.dev);
> +	priv->icd = icd;
> +
> +	dev_dbg(icd->parent, "R-Car VIN driver attached to camera %d\n",
> +		icd->devnum);
> +
> +	return 0;
> +}
> +
> +static void rcar_vin_remove_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct vb2_buffer *vb;
> +	int i;
> +
> +	if (icd != priv->icd) {
> +		WARN_ON(1);
> +		return;
> +	}

Make it

	if (WARN_ON(icd != priv->icd))
		return;

> +
> +	/* disable capture, disable interrupts */
> +	iowrite32(ioread32(priv->base + VNMC_REG) & ~VNMC_ME,
> +		  priv->base + VNMC_REG);
> +	iowrite32(0, priv->base + VNIE_REG);
> +
> +	priv->state = STOPPED;
> +	priv->request_to_stop = false;
> +
> +	/* make sure active buffer is cancelled */
> +	spin_lock_irq(&priv->lock);
> +	for (i = 0; i < MAX_BUFFER_NUM; i++) {
> +		vb = priv->queue_buf[i];
> +		if (vb) {
> +			list_del_init(to_buf_list(vb));
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +			vb = NULL;

I asked to remove this assignment in my previous review

[snip]

> +static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
> +	{
> +		.fourcc			= V4L2_PIX_FMT_NV16,
> +		.name			= "NV16",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,

This should be SOC_MBUS_LAYOUT_PLANAR_Y_C

> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_UYVY,
> +		.name			= "UYVY",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB565,
> +		.name			= "RGB565",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB555X,
> +		.name			= "ARGB1555",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.name			= "RGB888",
> +		.bits_per_sample	= 32,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> +	},
> +};
> +
> +static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
> +				struct soc_camera_format_xlate *xlate)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct device *dev = icd->parent;
> +	int ret, k, n;
> +	int formats = 0;
> +	struct rcar_vin_cam *cam;
> +	enum v4l2_mbus_pixelcode code;
> +	const struct soc_mbus_pixelfmt *fmt;
> +
> +	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
> +	if (ret < 0)
> +		return 0;
> +
> +	fmt = soc_mbus_get_fmtdesc(code);
> +	if (!fmt) {
> +		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code);
> +		return 0;
> +	}
> +
> +	ret = rcar_vin_try_bus_param(icd, fmt->bits_per_sample);
> +	if (ret < 0)
> +		return 0;
> +
> +	if (!icd->host_priv) {
> +		struct v4l2_mbus_framefmt mf;
> +		struct v4l2_rect rect;
> +		struct device *dev = icd->parent;
> +		int shift;
> +
> +		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Cache current client geometry */
> +		ret = soc_camera_client_g_rect(sd, &rect);
> +		if (ret < 0) {
> +			/* Sensor driver doesn't support cropping */

I don't think it's right. soc_camera_client_g_rect() should only return an 
error, if the subdevice driver implements g_crop or cropcap and returns an 
error from them. If those methods are just unimplemented, you get a 0 
back. Do you see anything different?

> +			rect.left = 0;
> +			rect.top = 0;
> +			rect.width = mf.width;
> +			rect.height = mf.height;
> +		}
> +
> +		/*
> +		 * If sensor proposes too large format then try smaller ones:
> +		 * 1280x960, 640x480, 320x240
> +		 */
> +		for (shift = 0; shift < 3; shift++) {
> +			if (mf.width <= VIN_MAX_WIDTH &&
> +			    mf.height <= VIN_MAX_HEIGHT)
> +				break;
> +
> +			mf.width = 1280 >> shift;
> +			mf.height = 960 >> shift;
> +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +							 soc_camera_grp_id(icd),
> +							 video, s_mbus_fmt,
> +							 &mf);
> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +		if (shift == 3) {
> +			dev_err(dev,
> +				"Failed to configure the client below %ux%x\n",
> +				mf.width, mf.height);
> +			return -EIO;
> +		}
> +
> +		dev_dbg(dev, "camera fmt %ux%u\n", mf.width, mf.height);
> +
> +		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
> +		if (!cam)
> +			return -ENOMEM;
> +		/*
> +		 * We are called with current camera crop,
> +		 * initialise subrect with it
> +		 */
> +		cam->rect = rect;
> +		cam->subrect = rect;
> +		cam->width = mf.width;
> +		cam->height = mf.height;
> +
> +		icd->host_priv = cam;
> +	} else {
> +		cam = icd->host_priv;
> +	}
> +
> +	/* Beginning of a pass */
> +	if (!idx)
> +		cam->extra_fmt = NULL;
> +
> +	switch (code) {
> +	case V4L2_MBUS_FMT_YUYV8_1X16:
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		if (cam->extra_fmt)
> +			break;
> +
> +		/* Add all our formats that can be generated by VIN */
> +		cam->extra_fmt = rcar_vin_formats;
> +
> +		n = ARRAY_SIZE(rcar_vin_formats);
> +		formats += n;
> +		for (k = 0; xlate && k < n; k++, xlate++) {
> +			xlate->host_fmt = &rcar_vin_formats[k];
> +			xlate->code = code;
> +			dev_dbg(dev, "Providing format %s using code %d\n",
> +				rcar_vin_formats[k].name, code);
> +		}
> +		break;
> +	default:
> +		if (!rcar_vin_packing_supported(fmt))
> +			return 0;
> +
> +		dev_dbg(dev, "Providing format %s in pass-through mode\n",
> +			fmt->name);
> +		break;

Ok, you added pass-through...

> +	}
> +
> +	/* Generic pass-through */
> +	formats++;
> +	if (xlate) {
> +		xlate->host_fmt = fmt;
> +		xlate->code = code;
> +		xlate++;
> +	}
> +
> +	return formats;
> +}

[snip]

> +/* Similar to set_crop multistage iterative algorithm */
> +static int rcar_vin_set_fmt(struct soc_camera_device *icd,
> +			    struct v4l2_format *f)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_mbus_framefmt mf;
> +	struct device *dev = icd->parent;
> +	__u32 pixfmt = pix->pixelformat;
> +	const struct soc_camera_format_xlate *xlate;
> +	unsigned int vin_sub_width = 0, vin_sub_height = 0;
> +	int ret;
> +	bool can_scale;
> +	enum v4l2_field field;
> +	v4l2_std_id std;
> +
> +	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
> +		pixfmt, pix->width, pix->height);
> +
> +	switch (pix->field) {
> +	default:
> +		pix->field = V4L2_FIELD_NONE;
> +		/* fall-through */
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		field = pix->field;
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +		/* Query for standard if not explicitly mentioned _TB/_BT */
> +		ret = v4l2_subdev_call(sd, video, querystd, &std);
> +		if (ret < 0)
> +			std = V4L2_STD_625_50;
> +
> +		field = std & V4L2_STD_625_50 ? V4L2_FIELD_INTERLACED_TB :
> +						V4L2_FIELD_INTERLACED_BT;
> +		break;
> +	}
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate) {
> +		dev_warn(dev, "Format %x not found\n", pixfmt);
> +		return -EINVAL;
> +	}
> +	/* Calculate client output geometry */
> +	soc_camera_calc_client_output(icd, &cam->rect, &cam->subrect, pix, &mf, 12);
> +	mf.field = pix->field;
> +	mf.colorspace = pix->colorspace;
> +	mf.code	 = xlate->code;
> +
> +	switch (pixfmt) {
> +	case V4L2_PIX_FMT_NV16:
> +		can_scale = false;
> +		break;
> +	case V4L2_PIX_FMT_RGB32:
> +		can_scale = priv->chip != RCAR_E1;
> +		break;
> +	default:
> +		can_scale = true;

You also get here in the pass-through mode, right? I don't think you can 
scale then.

> +		break;
> +	}
> +
> +	dev_dbg(dev, "request camera output %ux%u\n", mf.width, mf.height);
> +
> +	ret = soc_camera_client_scale(icd, &cam->rect, &cam->subrect,
> +				      &mf, &vin_sub_width, &vin_sub_height,
> +				      can_scale, 12);
> +
> +	/* Done with the camera. Now see if we can improve the result */
> +	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
> +		ret, mf.width, mf.height, pix->width, pix->height);
> +
> +	if (ret < 0)
> +		dev_dbg(dev, "Sensor doesn't support cropping\n");

Are you sure this print is correct?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
