Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3293 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KPNqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 08:46:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC v3 1/3] V4L: Add driver for S3C244X/S3C64XX SoC series camera interface
Date: Fri, 16 Nov 2012 14:45:34 +0100
Cc: linux-media@vger.kernel.org, dron0gus@gmail.com,
	tomasz.figa@gmail.com, oselas@community.pengutronix.de
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com> <1353017115-11492-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1353017115-11492-2-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161445.34285.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Just one comment, see below...

On Thu November 15 2012 23:05:13 Sylwester Nawrocki wrote:
> This patch adds V4L2 driver for Samsung S3C244X/S3C64XX SoC series
> camera interface. The driver exposes a subdev device node for CAMIF
> pixel resolution and crop control and two video capture nodes - for
> the "codec" and "preview" data paths. It has been tested on Mini2440
> (s3c2440) and Mini6410 (s3c6410) board with gstreamer and mplayer.
> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  drivers/media/platform/Kconfig                   |   12 +
>  drivers/media/platform/Makefile                  |    1 +
>  drivers/media/platform/s3c-camif/Makefile        |    5 +
>  drivers/media/platform/s3c-camif/camif-capture.c | 1636 ++++++++++++++++++++++
>  drivers/media/platform/s3c-camif/camif-core.c    |  661 +++++++++
>  drivers/media/platform/s3c-camif/camif-core.h    |  382 +++++
>  drivers/media/platform/s3c-camif/camif-regs.c    |  579 ++++++++
>  drivers/media/platform/s3c-camif/camif-regs.h    |  267 ++++
>  include/media/s3c_camif.h                        |   45 +
>  9 files changed, 3588 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/platform/s3c-camif/Makefile
>  create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
>  create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
>  create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
>  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
>  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
>  create mode 100644 include/media/s3c_camif.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 181c768..3dcfea6 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -109,6 +109,18 @@ config VIDEO_OMAP3_DEBUG
>  	---help---
>  	  Enable debug messages on OMAP 3 camera controller driver.
>  
> +config VIDEO_S3C_CAMIF
> +	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +	depends on (PLAT_S3C64XX || PLAT_S3C24XX) && PM_RUNTIME
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
> +	  host interface (CAMIF).
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called s3c-camif.
> +
>  source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/s5p-fimc/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index baaa550..4817d28 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_VIDEO_CODA) 		+= coda.o
>  
>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
>  
> +obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
> diff --git a/drivers/media/platform/s3c-camif/Makefile b/drivers/media/platform/s3c-camif/Makefile
> new file mode 100644
> index 0000000..50bf8c5
> --- /dev/null
> +++ b/drivers/media/platform/s3c-camif/Makefile
> @@ -0,0 +1,5 @@
> +# Makefile for s3c244x/s3c64xx CAMIF driver
> +
> +s3c-camif-objs := camif-core.o camif-capture.o camif-regs.o
> +
> +obj-$(CONFIG_VIDEO_S3C_CAMIF) += s3c-camif.o
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> new file mode 100644
> index 0000000..8daf684
> --- /dev/null
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -0,0 +1,1636 @@
> +/*
> + * s3c24xx/s3c64xx SoC series Camera Interface (CAMIF) driver
> + *
> + * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> + * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
> + *
> + * Based on drivers/media/platform/s5p-fimc,
> + * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
> +
> +#include <linux/bug.h>
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/ratelimit.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-device.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "camif-core.h"
> +#include "camif-regs.h"
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +
> +/* Locking: called with vp->camif->slock held */
> +static void camif_cfg_video_path(struct camif_vp *vp)
> +{
> +	WARN_ON(s3c_camif_get_scaler_config(vp, &vp->scaler));
> +	camif_hw_set_scaler(vp);
> +	camif_hw_set_flip(vp);
> +	camif_hw_set_target_format(vp);
> +	/* camif_hw_set_rotation(vp); */
> +	camif_hw_set_output_dma(vp);
> +}
> +
> +static void camif_prepare_dma_offset(struct camif_vp *vp)
> +{
> +	struct camif_frame *f = &vp->out_frame;
> +
> +	f->dma_offset.initial = f->rect.top * f->f_width + f->rect.left;
> +	f->dma_offset.line = f->f_width - (f->rect.left + f->rect.width);
> +
> +	pr_debug("dma_offset: initial=%d, line=%d\n",
> +		 f->dma_offset.initial, f->dma_offset.line);
> +}
> +
> +static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
> +{
> +	unsigned int ip_rev = camif->variant->ip_revision;
> +	unsigned long flags;
> +
> +	if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +
> +	if (ip_rev == S3C244X_CAMIF_IP_REV)
> +		camif_hw_clear_fifo_overflow(vp);
> +	camif_hw_set_camera_bus(camif);
> +	camif_hw_set_source_format(camif);
> +	camif_hw_set_camera_crop(camif);
> +	camif_hw_set_test_pattern(camif, camif->test_pattern->val);
> +	if (ip_rev == S3C6410_CAMIF_IP_REV)
> +		camif_hw_set_input_path(vp);
> +	camif_cfg_video_path(vp);
> +	vp->state &= ~ST_VP_CONFIG;
> +
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +	return 0;
> +}
> +
> +/*
> + * Initialize the video path, only up from the scaler stage. The camera
> + * input interface set up is skipped. This is useful to enable one of the
> + * video paths when the other is already running.
> + */
> +static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct camif_vp *vp)
> +{
> +	unsigned int ip_rev = camif->variant->ip_revision;
> +	unsigned long flags;
> +
> +	if (vp->out_fmt == NULL)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	camif_prepare_dma_offset(vp);
> +	if (ip_rev == S3C244X_CAMIF_IP_REV)
> +		camif_hw_clear_fifo_overflow(vp);
> +	camif_cfg_video_path(vp);
> +	if (ip_rev == S3C6410_CAMIF_IP_REV)
> +		camif_hw_set_effect(vp, false);
> +	vp->state &= ~ST_VP_CONFIG;
> +
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +	return 0;
> +}
> +
> +static int sensor_set_power(struct camif_dev *camif, int on)
> +{
> +	struct cam_sensor *sensor = &camif->sensor;
> +	int err = 0;
> +
> +	if (!on == camif->sensor.power_count)
> +		err = v4l2_subdev_call(sensor->sd, core, s_power, on);
> +	if (!err)
> +		sensor->power_count += on ? 1 : -1;
> +
> +	pr_debug("on: %d, power_count: %d, err: %d\n",
> +		 on, sensor->power_count, err);
> +
> +	return err;
> +}
> +
> +static int sensor_set_streaming(struct camif_dev *camif, int on)
> +{
> +	struct cam_sensor *sensor = &camif->sensor;
> +	int err = 0;
> +
> +	if (!on == camif->sensor.stream_count)
> +		err = v4l2_subdev_call(sensor->sd, video, s_stream, on);
> +	if (!err)
> +		sensor->stream_count += on ? 1 : -1;
> +
> +	pr_debug("on: %d, stream_count: %d, err: %d\n",
> +		 on, sensor->stream_count, err);
> +
> +	return err;
> +}
> +
> +/*
> + * Reinitialize the driver so it is ready to start streaming again.
> + * Return any buffers to vb2, perform CAMIF software reset and
> + * turn off streaming at the data pipeline (sensor) if required.
> + */
> +static int camif_reinitialize(struct camif_vp *vp)
> +{
> +	struct camif_dev *camif = vp->camif;
> +	struct camif_buffer *buf;
> +	unsigned long flags;
> +	bool streaming;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	streaming = vp->state & ST_VP_SENSOR_STREAMING;
> +
> +	vp->state &= ~(ST_VP_PENDING | ST_VP_RUNNING | ST_VP_OFF |
> +		       ST_VP_ABORTING | ST_VP_STREAMING |
> +		       ST_VP_SENSOR_STREAMING | ST_VP_LASTIRQ);
> +
> +	/* Release unused buffers */
> +	while (!list_empty(&vp->pending_buf_q)) {
> +		buf = camif_pending_queue_pop(vp);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	while (!list_empty(&vp->active_buf_q)) {
> +		buf = camif_active_queue_pop(vp);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +
> +	if (!streaming)
> +		return 0;
> +
> +	return sensor_set_streaming(camif, 0);
> +}
> +
> +static bool s3c_vp_active(struct camif_vp *vp)
> +{
> +	struct camif_dev *camif = vp->camif;
> +	unsigned long flags;
> +	bool ret;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	ret = (vp->state & ST_VP_RUNNING) || (vp->state & ST_VP_PENDING);
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +
> +	return ret;
> +}
> +
> +static bool camif_is_streaming(struct camif_dev *camif)
> +{
> +	unsigned long flags;
> +	bool status;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	status = camif->stream_count > 0;
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +
> +	return status;
> +}
> +
> +static int camif_stop_capture(struct camif_vp *vp)
> +{
> +	struct camif_dev *camif = vp->camif;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!s3c_vp_active(vp))
> +		return 0;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	vp->state &= ~(ST_VP_OFF | ST_VP_LASTIRQ);
> +	vp->state |= ST_VP_ABORTING;
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +
> +	ret = wait_event_timeout(vp->irq_queue,
> +			   !(vp->state & ST_VP_ABORTING),
> +			   msecs_to_jiffies(CAMIF_STOP_TIMEOUT));
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +
> +	if (ret == 0 && !(vp->state & ST_VP_OFF)) {
> +		/* Timed out, forcibly stop capture */
> +		vp->state &= ~(ST_VP_OFF | ST_VP_ABORTING |
> +			       ST_VP_LASTIRQ);
> +
> +		camif_hw_disable_capture(vp);
> +		camif_hw_enable_scaler(vp, false);
> +	}
> +
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +
> +	return camif_reinitialize(vp);
> +}
> +
> +static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer *vb,
> +			      struct camif_addr *paddr)
> +{
> +	struct camif_frame *frame = &vp->out_frame;
> +	u32 pix_size;
> +
> +	if (vb == NULL || frame == NULL)
> +		return -EINVAL;
> +
> +	pix_size = frame->rect.width * frame->rect.height;
> +
> +	pr_debug("colplanes: %d, pix_size: %u\n",
> +		 vp->out_fmt->colplanes, pix_size);
> +
> +	paddr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	switch (vp->out_fmt->colplanes) {
> +	case 1:
> +		paddr->cb = 0;
> +		paddr->cr = 0;
> +		break;
> +	case 2:
> +		/* decompose Y into Y/Cb */
> +		paddr->cb = (u32)(paddr->y + pix_size);
> +		paddr->cr = 0;
> +		break;
> +	case 3:
> +		paddr->cb = (u32)(paddr->y + pix_size);
> +		/* decompose Y into Y/Cb/Cr */
> +		if (vp->out_fmt->color == IMG_FMT_YCBCR422P)
> +			paddr->cr = (u32)(paddr->cb + (pix_size >> 1));
> +		else /* 420 */
> +			paddr->cr = (u32)(paddr->cb + (pix_size >> 2));
> +
> +		if (vp->out_fmt->color == IMG_FMT_YCRCB420)
> +			swap(paddr->cb, paddr->cr);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
> +		 paddr->y, paddr->cb, paddr->cr);
> +
> +	return 0;
> +}
> +
> +irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
> +{
> +	struct camif_vp *vp = priv;
> +	struct camif_dev *camif = vp->camif;
> +	unsigned int ip_rev = camif->variant->ip_revision;
> +	unsigned int status;
> +
> +	spin_lock(&camif->slock);
> +
> +	if (ip_rev == S3C6410_CAMIF_IP_REV)
> +		camif_hw_clear_pending_irq(vp);
> +
> +	status = camif_hw_get_status(vp);
> +
> +	if (ip_rev == S3C244X_CAMIF_IP_REV && (status & CISTATUS_OVF_MASK)) {
> +		camif_hw_clear_fifo_overflow(vp);
> +		goto unlock;
> +	}
> +
> +	if (vp->state & ST_VP_ABORTING) {
> +		if (vp->state & ST_VP_OFF) {
> +			/* Last IRQ */
> +			vp->state &= ~(ST_VP_OFF | ST_VP_ABORTING |
> +				       ST_VP_LASTIRQ);
> +			wake_up(&vp->irq_queue);
> +			goto unlock;
> +		} else if (vp->state & ST_VP_LASTIRQ) {
> +			camif_hw_disable_capture(vp);
> +			camif_hw_enable_scaler(vp, false);
> +			camif_hw_set_lastirq(vp, false);
> +			vp->state |= ST_VP_OFF;
> +		} else {
> +			/* Disable capture, enable last IRQ */
> +			camif_hw_set_lastirq(vp, true);
> +			vp->state |= ST_VP_LASTIRQ;
> +		}
> +	}
> +
> +	if (!list_empty(&vp->pending_buf_q) && (vp->state & ST_VP_RUNNING) &&
> +	    !list_empty(&vp->active_buf_q)) {
> +		unsigned int index;
> +		struct camif_buffer *vbuf;
> +		struct timeval *tv;
> +		struct timespec ts;
> +		/*
> +		 * Get previous DMA write buffer index:
> +		 * 0 => DMA buffer 0, 2;
> +		 * 1 => DMA buffer 1, 3.
> +		 */
> +		index = (CISTATUS_FRAMECNT(status) + 2) & 1;
> +
> +		ktime_get_ts(&ts);
> +		vbuf = camif_active_queue_peek(vp, index);
> +
> +		if (!WARN_ON(vbuf == NULL)) {
> +			/* Dequeue a filled buffer */
> +			tv = &vbuf->vb.v4l2_buf.timestamp;
> +			tv->tv_sec = ts.tv_sec;
> +			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> +			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
> +			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
> +
> +			/* Set up an empty buffer at the DMA engine */
> +			vbuf = camif_pending_queue_pop(vp);
> +			vbuf->index = index;
> +			camif_hw_set_output_addr(vp, &vbuf->paddr, index);
> +			camif_hw_set_output_addr(vp, &vbuf->paddr, index + 2);
> +
> +			/* Scheduled in H/W, add to the queue */
> +			camif_active_queue_add(vp, vbuf);
> +		}
> +	} else if (!(vp->state & ST_VP_ABORTING) &&
> +		   (vp->state & ST_VP_PENDING))  {
> +		vp->state |= ST_VP_RUNNING;
> +	}
> +
> +	if (vp->state & ST_VP_CONFIG) {
> +		camif_prepare_dma_offset(vp);
> +		camif_hw_set_camera_crop(camif);
> +		camif_hw_set_scaler(vp);
> +		camif_hw_set_flip(vp);
> +		camif_hw_set_test_pattern(camif, camif->test_pattern->val);
> +		vp->state &= ~ST_VP_CONFIG;
> +	}
> +unlock:
> +	spin_unlock(&camif->slock);
> +	return IRQ_HANDLED;
> +}
> +
> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct camif_vp *vp = vb2_get_drv_priv(vq);
> +	struct camif_dev *camif = vp->camif;
> +	unsigned long flags;
> +	int ret;
> +
> +	/*
> +	 * We assume the codec capture path is always activated
> +	 * first, before the preview path starts streaming.
> +	 * This is required to avoid internal FIFO overflow and
> +	 * a need for CAMIF software reset.
> +	 */
> +	spin_lock_irqsave(&camif->slock, flags);
> +
> +	if (camif->stream_count == 0) {
> +		camif_hw_reset(camif);
> +		spin_unlock_irqrestore(&camif->slock, flags);
> +		ret = s3c_camif_hw_init(camif, vp);
> +	} else {
> +		spin_unlock_irqrestore(&camif->slock, flags);
> +		ret = s3c_camif_hw_vp_init(camif, vp);
> +	}
> +
> +	if (ret < 0) {
> +		camif_reinitialize(vp);
> +		return ret;
> +	}
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	vp->frame_sequence = 0;
> +	vp->state |= ST_VP_PENDING;
> +
> +	if (!list_empty(&vp->pending_buf_q) &&
> +	    (!(vp->state & ST_VP_STREAMING) ||
> +	     !(vp->state & ST_VP_SENSOR_STREAMING))) {
> +
> +		camif_hw_enable_scaler(vp, vp->scaler.enable);
> +		camif_hw_enable_capture(vp);
> +		vp->state |= ST_VP_STREAMING;
> +
> +		if (!(vp->state & ST_VP_SENSOR_STREAMING)) {
> +			vp->state |= ST_VP_SENSOR_STREAMING;
> +			spin_unlock_irqrestore(&camif->slock, flags);
> +			ret = sensor_set_streaming(camif, 1);
> +			if (ret)
> +				v4l2_err(&vp->vdev, "Sensor s_stream failed\n");
> +			if (debug)
> +				camif_hw_dump_regs(camif, __func__);
> +
> +			return ret;
> +		}
> +	}
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +
> +	return 0;
> +}
> +
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct camif_vp *vp = vb2_get_drv_priv(vq);
> +	return camif_stop_capture(vp);
> +}
> +
> +static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
> +		       unsigned int *num_buffers, unsigned int *num_planes,
> +		       unsigned int sizes[], void *allocators[])
> +{
> +	const struct v4l2_pix_format *pix = NULL;
> +	struct camif_vp *vp = vb2_get_drv_priv(vq);
> +	struct camif_dev *camif = vp->camif;
> +	struct camif_frame *frame = &vp->out_frame;
> +	const struct camif_fmt *fmt = vp->out_fmt;
> +	unsigned int size;
> +
> +	if (pfmt) {
> +		pix = &pfmt->fmt.pix;
> +		fmt = s3c_camif_find_format(vp, &pix->pixelformat, -1);
> +		size = (pix->width * pix->height * fmt->depth) / 8;
> +	} else {
> +		size = (frame->f_width * frame->f_height * fmt->depth) / 8;
> +	}
> +
> +	if (fmt == NULL)
> +		return -EINVAL;
> +	*num_planes = 1;
> +
> +	if (pix)
> +		sizes[0] = max(size, pix->sizeimage);
> +	else
> +		sizes[0] = size;
> +	allocators[0] = camif->alloc_ctx;
> +
> +	pr_debug("size: %u\n", sizes[0]);
> +	return 0;
> +}
> +
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	if (vp->out_fmt == NULL)
> +		return -EINVAL;
> +
> +	if (vb2_plane_size(vb, 0) < vp->payload) {
> +		v4l2_err(&vp->vdev, "buffer too small: %lu, required: %u\n",
> +			 vb2_plane_size(vb, 0), vp->payload);
> +		return -EINVAL;
> +	}
> +	vb2_set_plane_payload(vb, 0, vp->payload);
> +
> +	return 0;
> +}
> +
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct camif_buffer *buf = container_of(vb, struct camif_buffer, vb);
> +	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
> +	struct camif_dev *camif = vp->camif;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&camif->slock, flags);
> +	WARN_ON(camif_prepare_addr(vp, &buf->vb, &buf->paddr));
> +
> +	if (!(vp->state & ST_VP_STREAMING) && vp->active_buffers < 2) {
> +		/* Schedule an empty buffer in H/W */
> +		buf->index = vp->buf_index;
> +
> +		camif_hw_set_output_addr(vp, &buf->paddr, buf->index);
> +		camif_hw_set_output_addr(vp, &buf->paddr, buf->index + 2);
> +
> +		camif_active_queue_add(vp, buf);
> +		vp->buf_index = !vp->buf_index;
> +	} else {
> +		camif_pending_queue_add(vp, buf);
> +	}
> +
> +	if (vb2_is_streaming(&vp->vb_queue) && !list_empty(&vp->pending_buf_q)
> +		&& !(vp->state & ST_VP_STREAMING)) {
> +
> +		vp->state |= ST_VP_STREAMING;
> +		camif_hw_enable_scaler(vp, vp->scaler.enable);
> +		camif_hw_enable_capture(vp);
> +		spin_unlock_irqrestore(&camif->slock, flags);
> +
> +		if (!(vp->state & ST_VP_SENSOR_STREAMING)) {
> +			if (sensor_set_streaming(camif, 1) == 0)
> +				vp->state |= ST_VP_SENSOR_STREAMING;
> +			else
> +				v4l2_err(&vp->vdev, "Sensor s_stream failed\n");
> +
> +			if (debug)
> +				camif_hw_dump_regs(camif, __func__);
> +		}
> +		return;
> +	}
> +	spin_unlock_irqrestore(&camif->slock, flags);
> +}
> +
> +static void camif_lock(struct vb2_queue *vq)
> +{
> +	struct camif_vp *vp = vb2_get_drv_priv(vq);
> +	mutex_lock(&vp->camif->lock);
> +}
> +
> +static void camif_unlock(struct vb2_queue *vq)
> +{
> +	struct camif_vp *vp = vb2_get_drv_priv(vq);
> +	mutex_unlock(&vp->camif->lock);
> +}
> +
> +static const struct vb2_ops s3c_camif_qops = {
> +	.queue_setup	 = queue_setup,
> +	.buf_prepare	 = buffer_prepare,
> +	.buf_queue	 = buffer_queue,
> +	.wait_prepare	 = camif_unlock,
> +	.wait_finish	 = camif_lock,
> +	.start_streaming = start_streaming,
> +	.stop_streaming	 = stop_streaming,
> +};
> +
> +static int s3c_camif_open(struct file *file)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct camif_dev *camif = vp->camif;
> +	int ret;
> +
> +	pr_debug("[vp%d] state: %#x,  owner: %p, pid: %d\n", vp->id,
> +		 vp->state, vp->owner, task_pid_nr(current));
> +
> +	if (mutex_lock_interruptible(&camif->lock))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	ret = pm_runtime_get_sync(camif->dev);
> +	if (ret < 0)
> +		goto err_pm;
> +
> +	ret = sensor_set_power(camif, 1);
> +	if (!ret)
> +		goto unlock;
> +
> +	pm_runtime_put(camif->dev);
> +err_pm:
> +	v4l2_fh_release(file);
> +unlock:
> +	mutex_unlock(&camif->lock);
> +	return ret;
> +}
> +
> +static int s3c_camif_close(struct file *file)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct camif_dev *camif = vp->camif;
> +	int ret;
> +
> +	pr_debug("[vp%d] state: %#x, owner: %p, pid: %d\n", vp->id,
> +		 vp->state, vp->owner, task_pid_nr(current));
> +
> +	if (mutex_lock_interruptible(&camif->lock))
> +		return -ERESTARTSYS;
> +
> +	if (vp->owner == file->private_data) {
> +		camif_stop_capture(vp);
> +		vb2_queue_release(&vp->vb_queue);
> +		vp->owner = NULL;
> +	}
> +
> +	sensor_set_power(camif, 0);
> +
> +	pm_runtime_put(camif->dev);
> +	ret = v4l2_fh_release(file);
> +
> +	mutex_unlock(&camif->lock);
> +	return ret;
> +}
> +
> +static unsigned int s3c_camif_poll(struct file *file,
> +				   struct poll_table_struct *wait)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct camif_dev *camif = vp->camif;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&camif->lock))
> +		return -ERESTARTSYS;
> +
> +	if (vp->owner && vp->owner != file->private_data)
> +		ret = -EBUSY;
> +	else
> +		ret = vb2_poll(&vp->vb_queue, file, wait);
> +
> +	mutex_unlock(&camif->lock);
> +	return ret;
> +}
> +
> +static int s3c_camif_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	int ret;
> +
> +	if (vp->owner && vp->owner != file->private_data)
> +		ret = -EBUSY;
> +	else
> +		ret = vb2_mmap(&vp->vb_queue, vma);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations s3c_camif_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= s3c_camif_open,
> +	.release	= s3c_camif_close,
> +	.poll		= s3c_camif_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= s3c_camif_mmap,
> +};
> +
> +/*
> + * Video node IOCTLs
> + */
> +
> +static int s3c_camif_vidioc_querycap(struct file *file, void *priv,
> +				     struct v4l2_capability *cap)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +
> +	strlcpy(cap->driver, S3C_CAMIF_DRIVER_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, S3C_CAMIF_DRIVER_NAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s.%d",
> +		 dev_name(vp->camif->dev), vp->id);
> +
> +	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int s3c_camif_vidioc_enum_input(struct file *file, void *priv,
> +				       struct v4l2_input *input)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct v4l2_subdev *sensor = vp->camif->sensor.sd;
> +
> +	if (input->index || sensor == NULL)
> +		return -EINVAL;
> +
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(input->name, sensor->name, sizeof(input->name));
> +	return 0;
> +}
> +
> +static int s3c_camif_vidioc_s_input(struct file *file, void *priv,
> +				    unsigned int i)
> +{
> +	return i == 0 ? 0 : -EINVAL;
> +}
> +
> +static int s3c_camif_vidioc_g_input(struct file *file, void *priv,
> +				    unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int s3c_camif_vidioc_enum_fmt(struct file *file, void *priv,
> +				     struct v4l2_fmtdesc *f)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	const struct camif_fmt *fmt;
> +
> +	fmt = s3c_camif_find_format(vp, NULL, f->index);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	strlcpy(f->description, fmt->name, sizeof(f->description));
> +	f->pixelformat = fmt->fourcc;
> +
> +	pr_debug("fmt(%d): %s\n", f->index, f->description);
> +	return 0;
> +}
> +
> +static int s3c_camif_vidioc_g_fmt(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct camif_frame *frame = &vp->out_frame;
> +	const struct camif_fmt *fmt = vp->out_fmt;
> +
> +	pix->bytesperline = frame->f_width * fmt->ybpp;
> +	pix->sizeimage = vp->payload;
> +
> +	pix->pixelformat = fmt->fourcc;
> +	pix->width = frame->f_width;
> +	pix->height = frame->f_height;
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->colorspace = V4L2_COLORSPACE_JPEG;
> +
> +	return 0;
> +}
> +
> +static int __camif_video_try_format(struct camif_vp *vp,
> +				    struct v4l2_pix_format *pix,
> +				    const struct camif_fmt **ffmt)
> +{
> +	struct camif_dev *camif = vp->camif;
> +	struct v4l2_rect *crop = &camif->camif_crop;
> +	unsigned int wmin, hmin, sc_hrmax, sc_vrmax;
> +	const struct vp_pix_limits *pix_lim;
> +	const struct camif_fmt *fmt;
> +
> +	fmt = s3c_camif_find_format(vp, &pix->pixelformat, 0);
> +
> +	if (WARN_ON(fmt == NULL))
> +		return -EINVAL;
> +
> +	if (ffmt)
> +		*ffmt = fmt;
> +
> +	pix_lim = &camif->variant->vp_pix_limits[vp->id];
> +
> +	pr_debug("fmt: %ux%u, crop: %ux%u, bytesperline: %u\n",
> +		 pix->width, pix->height, crop->width, crop->height,
> +		 pix->bytesperline);
> +	/*
> +	 * Calculate minimum width and height according to the configured
> +	 * camera input interface crop rectangle and the resizer's capabilities.
> +	 */
> +	sc_hrmax = min(SCALER_MAX_RATIO, 1 << (ffs(crop->width) - 3));
> +	sc_vrmax = min(SCALER_MAX_RATIO, 1 << (ffs(crop->height) - 1));
> +
> +	wmin = max_t(u32, pix_lim->min_out_width, crop->width / sc_hrmax);
> +	wmin = round_up(wmin, pix_lim->out_width_align);
> +	hmin = max_t(u32, 8, crop->height / sc_vrmax);
> +	hmin = round_up(hmin, 8);
> +
> +	v4l_bound_align_image(&pix->width, wmin, pix_lim->max_sc_out_width,
> +			      ffs(pix_lim->out_width_align) - 1,
> +			      &pix->height, hmin, pix_lim->max_height, 0, 0);
> +
> +	pix->bytesperline = pix->width * fmt->ybpp;
> +	pix->sizeimage = (pix->width * pix->height * fmt->depth) / 8;
> +	pix->pixelformat = fmt->fourcc;
> +	pix->colorspace = V4L2_COLORSPACE_JPEG;
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	pr_debug("%ux%u, wmin: %d, hmin: %d, sc_hrmax: %d, sc_vrmax: %d\n",
> +		 pix->width, pix->height, wmin, hmin, sc_hrmax, sc_vrmax);
> +
> +	return 0;
> +}
> +
> +static int s3c_camif_vidioc_try_fmt(struct file *file, void *priv,
> +				    struct v4l2_format *f)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	return __camif_video_try_format(vp, &f->fmt.pix, NULL);
> +}
> +
> +static int s3c_camif_vidioc_s_fmt(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct camif_frame *out_frame = &vp->out_frame;
> +	const struct camif_fmt *fmt = NULL;
> +	int ret;
> +
> +	pr_debug("[vp%d]\n", vp->id);
> +
> +	if (vb2_is_busy(&vp->vb_queue))
> +		return -EBUSY;
> +
> +	ret = __camif_video_try_format(vp, &f->fmt.pix, &fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	vp->out_fmt = fmt;
> +	vp->payload = pix->sizeimage;
> +	out_frame->f_width = pix->width;
> +	out_frame->f_height = pix->height;
> +
> +	/* Reset composition rectangle */
> +	out_frame->rect.width = pix->width;
> +	out_frame->rect.height = pix->height;
> +	out_frame->rect.left = 0;
> +	out_frame->rect.top = 0;
> +
> +	if (vp->owner == NULL)
> +		vp->owner = priv;
> +
> +	pr_debug("%ux%u. payload: %u. fmt: %s. %d %d. sizeimage: %d. bpl: %d\n",
> +		out_frame->f_width, out_frame->f_height, vp->payload, fmt->name,
> +		pix->width * pix->height * fmt->depth, fmt->depth,
> +		pix->sizeimage, pix->bytesperline);
> +
> +	return 0;
> +}
> +
> +/* Only check pixel formats at the sensor and the camif subdev pads */
> +static int camif_pipeline_validate(struct camif_dev *camif)
> +{
> +	struct v4l2_subdev_format src_fmt;
> +	struct media_pad *pad;
> +	int ret;
> +
> +	/* Retrieve format at the sensor subdev source pad */
> +	pad = media_entity_remote_source(&camif->pads[0]);
> +	if (!pad || media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return -EPIPE;
> +
> +	src_fmt.pad = pad->index;
> +	src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(camif->sensor.sd, pad, get_fmt, NULL, &src_fmt);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		return -EPIPE;
> +
> +	if (src_fmt.format.width != camif->mbus_fmt.width ||
> +	    src_fmt.format.height != camif->mbus_fmt.height ||
> +	    src_fmt.format.code != camif->mbus_fmt.code)
> +		return -EPIPE;
> +
> +	return 0;
> +}
> +
> +static int s3c_camif_streamon(struct file *file, void *priv,
> +			      enum v4l2_buf_type type)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct camif_dev *camif = vp->camif;
> +	struct media_entity *sensor = &camif->sensor.sd->entity;
> +	int ret;
> +
> +	pr_debug("[vp%d]\n", vp->id);
> +
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	if (vp->owner && vp->owner != priv)
> +		return -EBUSY;
> +
> +	if (s3c_vp_active(vp))
> +		return 0;
> +
> +	ret = media_entity_pipeline_start(sensor, camif->m_pipeline);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = camif_pipeline_validate(camif);
> +	if (ret < 0) {
> +		media_entity_pipeline_stop(sensor);
> +		return ret;
> +	}
> +
> +	return vb2_streamon(&vp->vb_queue, type);
> +}
> +
> +static int s3c_camif_streamoff(struct file *file, void *priv,
> +			       enum v4l2_buf_type type)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	struct camif_dev *camif = vp->camif;
> +	int ret;
> +
> +	pr_debug("[vp%d]\n", vp->id);
> +
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	if (vp->owner && vp->owner != priv)
> +		return -EBUSY;
> +
> +	ret = vb2_streamoff(&vp->vb_queue, type);
> +	if (ret == 0)
> +		media_entity_pipeline_stop(&camif->sensor.sd->entity);
> +	return ret;
> +}
> +
> +static int s3c_camif_reqbufs(struct file *file, void *priv,
> +			     struct v4l2_requestbuffers *rb)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	int ret;
> +
> +	pr_debug("[vp%d] rb count: %d, owner: %p, priv: %p\n",
> +		 vp->id, rb->count, vp->owner, priv);
> +
> +	if (vp->owner && vp->owner != priv)
> +		return -EBUSY;
> +
> +	if (rb->count)
> +		rb->count = max_t(u32, CAMIF_REQ_BUFS_MIN, rb->count);
> +	else
> +		vp->owner = NULL;
> +
> +	ret = vb2_reqbufs(&vp->vb_queue, rb);
> +	if (!ret) {
> +		vp->reqbufs_count = rb->count;
> +		if (vp->owner == NULL && rb->count > 0)
> +			vp->owner = priv;
> +	}
> +
> +	return ret;
> +}
> +
> +static int s3c_camif_querybuf(struct file *file, void *priv,
> +			      struct v4l2_buffer *buf)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	return vb2_querybuf(&vp->vb_queue, buf);
> +}
> +
> +static int s3c_camif_qbuf(struct file *file, void *priv,
> +			  struct v4l2_buffer *buf)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +
> +	pr_debug("[vp%d]\n", vp->id);
> +
> +	if (vp->owner && vp->owner != priv)
> +		return -EBUSY;
> +
> +	return vb2_qbuf(&vp->vb_queue, buf);
> +}
> +
> +static int s3c_camif_dqbuf(struct file *file, void *priv,
> +			   struct v4l2_buffer *buf)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +
> +	pr_debug("[vp%d] sequence: %d\n", vp->id, vp->frame_sequence);
> +
> +	if (vp->owner && vp->owner != priv)
> +		return -EBUSY;
> +
> +	return vb2_dqbuf(&vp->vb_queue, buf, file->f_flags & O_NONBLOCK);
> +}
> +
> +static int s3c_camif_create_bufs(struct file *file, void *priv,
> +				 struct v4l2_create_buffers *create)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	int ret;
> +
> +	if (vp->owner && vp->owner != priv)
> +		return -EBUSY;
> +
> +	create->count = max_t(u32, 1, create->count);
> +	ret = vb2_create_bufs(&vp->vb_queue, create);
> +
> +	if (!ret && vp->owner == NULL)
> +		vp->owner = priv;
> +
> +	return ret;
> +}
> +
> +static int s3c_camif_prepare_buf(struct file *file, void *priv,
> +				 struct v4l2_buffer *b)
> +{
> +	struct camif_vp *vp = video_drvdata(file);
> +	return vb2_prepare_buf(&vp->vb_queue, b);
> +}
> +

Are you aware of the vb2 ioctl helper functions I've added? See videobuf2-core.h,
at the end.

They can probably replace some of these ioctls. It's something you can do later
in a separate patch, so this isn't blocking as far as I am concerned. It's just
a hint.

Regards,

	Hans
