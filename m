Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2KPOKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:10:09 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so2797632obb.19
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 06:10:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALW4P+JQUcywagZAe5qHRifsSwAnKoDccmhpQ=TSWvxcS-6CqA@mail.gmail.com>
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
	<1353017115-11492-2-git-send-email-sylvester.nawrocki@gmail.com>
	<CALW4P+JQUcywagZAe5qHRifsSwAnKoDccmhpQ=TSWvxcS-6CqA@mail.gmail.com>
Date: Fri, 16 Nov 2012 18:10:08 +0400
Message-ID: <CALW4P+KBd8fxCX8qSuZGYPx8pYj6LhEZfCurzuKuZzApe7Z7Aw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/3] V4L: Add driver for S3C244X/S3C64XX SoC series
 camera interface
From: Alexey Klimov <klimov.linux@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, dron0gus@gmail.com,
	tomasz.figa@gmail.com, oselas@community.pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

> On Fri, Nov 16, 2012 at 2:05 AM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>>
>> This patch adds V4L2 driver for Samsung S3C244X/S3C64XX SoC series
>> camera interface. The driver exposes a subdev device node for CAMIF
>> pixel resolution and crop control and two video capture nodes - for
>> the "codec" and "preview" data paths. It has been tested on Mini2440
>> (s3c2440) and Mini6410 (s3c6410) board with gstreamer and mplayer.
>>
>> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>> ---
>>  drivers/media/platform/Kconfig                   |   12 +
>>  drivers/media/platform/Makefile                  |    1 +
>>  drivers/media/platform/s3c-camif/Makefile        |    5 +
>>  drivers/media/platform/s3c-camif/camif-capture.c | 1636
>> ++++++++++++++++++++++
>>  drivers/media/platform/s3c-camif/camif-core.c    |  661 +++++++++
>>  drivers/media/platform/s3c-camif/camif-core.h    |  382 +++++
>>  drivers/media/platform/s3c-camif/camif-regs.c    |  579 ++++++++
>>  drivers/media/platform/s3c-camif/camif-regs.h    |  267 ++++
>>  include/media/s3c_camif.h                        |   45 +
>>  9 files changed, 3588 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/platform/s3c-camif/Makefile
>>  create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
>>  create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
>>  create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
>>  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
>>  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
>>  create mode 100644 include/media/s3c_camif.h
>>
>> diff --git a/drivers/media/platform/Kconfig
>> b/drivers/media/platform/Kconfig
>> index 181c768..3dcfea6 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -109,6 +109,18 @@ config VIDEO_OMAP3_DEBUG
>>         ---help---
>>           Enable debug messages on OMAP 3 camera controller driver.
>>
>> +config VIDEO_S3C_CAMIF
>> +       tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
>> +       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>> +       depends on (PLAT_S3C64XX || PLAT_S3C24XX) && PM_RUNTIME
>> +       select VIDEOBUF2_DMA_CONTIG
>> +       ---help---
>> +         This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
>> +         host interface (CAMIF).
>> +
>> +         To compile this driver as a module, choose M here: the module
>> +         will be called s3c-camif.
>> +
>>  source "drivers/media/platform/soc_camera/Kconfig"
>>  source "drivers/media/platform/s5p-fimc/Kconfig"
>>  source "drivers/media/platform/s5p-tv/Kconfig"
>> diff --git a/drivers/media/platform/Makefile
>> b/drivers/media/platform/Makefile
>> index baaa550..4817d28 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -27,6 +27,7 @@ obj-$(CONFIG_VIDEO_CODA)              += coda.o
>>
>>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)        += m2m-deinterlace.o
>>
>> +obj-$(CONFIG_VIDEO_S3C_CAMIF)          += s3c-camif/
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC)   += s5p-fimc/
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)   += s5p-jpeg/
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)    += s5p-mfc/
>> diff --git a/drivers/media/platform/s3c-camif/Makefile
>> b/drivers/media/platform/s3c-camif/Makefile
>> new file mode 100644
>> index 0000000..50bf8c5
>> --- /dev/null
>> +++ b/drivers/media/platform/s3c-camif/Makefile
>> @@ -0,0 +1,5 @@
>> +# Makefile for s3c244x/s3c64xx CAMIF driver
>> +
>> +s3c-camif-objs := camif-core.o camif-capture.o camif-regs.o
>> +
>> +obj-$(CONFIG_VIDEO_S3C_CAMIF) += s3c-camif.o
>> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
>> b/drivers/media/platform/s3c-camif/camif-capture.c
>> new file mode 100644
>> index 0000000..8daf684
>> --- /dev/null
>> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
>> @@ -0,0 +1,1636 @@
>> +/*
>> + * s3c24xx/s3c64xx SoC series Camera Interface (CAMIF) driver
>> + *
>> + * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> + * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
>> + *
>> + * Based on drivers/media/platform/s5p-fimc,
>> + * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> +*/
>> +#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
>> +
>> +#include <linux/bug.h>
>> +#include <linux/clk.h>
>> +#include <linux/device.h>
>> +#include <linux/errno.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/ratelimit.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/videodev2.h>
>> +
>> +#include <media/media-device.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#include "camif-core.h"
>> +#include "camif-regs.h"
>> +
>> +static int debug;
>> +module_param(debug, int, 0644);
>> +
>> +/* Locking: called with vp->camif->slock held */
>> +static void camif_cfg_video_path(struct camif_vp *vp)
>> +{
>> +       WARN_ON(s3c_camif_get_scaler_config(vp, &vp->scaler));
>> +       camif_hw_set_scaler(vp);
>> +       camif_hw_set_flip(vp);
>> +       camif_hw_set_target_format(vp);
>> +       /* camif_hw_set_rotation(vp); */
>> +       camif_hw_set_output_dma(vp);
>> +}
>> +
>> +static void camif_prepare_dma_offset(struct camif_vp *vp)
>> +{
>> +       struct camif_frame *f = &vp->out_frame;
>> +
>> +       f->dma_offset.initial = f->rect.top * f->f_width + f->rect.left;
>> +       f->dma_offset.line = f->f_width - (f->rect.left + f->rect.width);
>> +
>> +       pr_debug("dma_offset: initial=%d, line=%d\n",
>> +                f->dma_offset.initial, f->dma_offset.line);
>> +}
>> +
>> +static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp
>> *vp)
>> +{
>> +       unsigned int ip_rev = camif->variant->ip_revision;
>> +       unsigned long flags;
>> +
>> +       if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
>> +               return -EINVAL;
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +
>> +       if (ip_rev == S3C244X_CAMIF_IP_REV)
>> +               camif_hw_clear_fifo_overflow(vp);
>> +       camif_hw_set_camera_bus(camif);
>> +       camif_hw_set_source_format(camif);
>> +       camif_hw_set_camera_crop(camif);
>> +       camif_hw_set_test_pattern(camif, camif->test_pattern->val);
>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>> +               camif_hw_set_input_path(vp);
>> +       camif_cfg_video_path(vp);
>> +       vp->state &= ~ST_VP_CONFIG;
>> +
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Initialize the video path, only up from the scaler stage. The camera
>> + * input interface set up is skipped. This is useful to enable one of
>> the
>> + * video paths when the other is already running.
>> + */
>> +static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct camif_vp
>> *vp)
>> +{
>> +       unsigned int ip_rev = camif->variant->ip_revision;
>> +       unsigned long flags;
>> +
>> +       if (vp->out_fmt == NULL)
>> +               return -EINVAL;
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +       camif_prepare_dma_offset(vp);
>> +       if (ip_rev == S3C244X_CAMIF_IP_REV)
>> +               camif_hw_clear_fifo_overflow(vp);
>> +       camif_cfg_video_path(vp);
>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>> +               camif_hw_set_effect(vp, false);
>> +       vp->state &= ~ST_VP_CONFIG;
>> +
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +       return 0;
>> +}
>> +
>> +static int sensor_set_power(struct camif_dev *camif, int on)
>> +{
>> +       struct cam_sensor *sensor = &camif->sensor;
>> +       int err = 0;
>> +
>> +       if (!on == camif->sensor.power_count)
>> +               err = v4l2_subdev_call(sensor->sd, core, s_power, on);
>> +       if (!err)
>> +               sensor->power_count += on ? 1 : -1;
>> +
>> +       pr_debug("on: %d, power_count: %d, err: %d\n",
>> +                on, sensor->power_count, err);
>> +
>> +       return err;
>> +}
>> +
>> +static int sensor_set_streaming(struct camif_dev *camif, int on)
>> +{
>> +       struct cam_sensor *sensor = &camif->sensor;
>> +       int err = 0;
>> +
>> +       if (!on == camif->sensor.stream_count)
>> +               err = v4l2_subdev_call(sensor->sd, video, s_stream, on);
>> +       if (!err)
>> +               sensor->stream_count += on ? 1 : -1;
>> +
>> +       pr_debug("on: %d, stream_count: %d, err: %d\n",
>> +                on, sensor->stream_count, err);
>> +
>> +       return err;
>> +}
>> +
>> +/*
>> + * Reinitialize the driver so it is ready to start streaming again.
>> + * Return any buffers to vb2, perform CAMIF software reset and
>> + * turn off streaming at the data pipeline (sensor) if required.
>> + */
>> +static int camif_reinitialize(struct camif_vp *vp)
>> +{
>> +       struct camif_dev *camif = vp->camif;
>> +       struct camif_buffer *buf;
>> +       unsigned long flags;
>> +       bool streaming;
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +       streaming = vp->state & ST_VP_SENSOR_STREAMING;
>> +
>> +       vp->state &= ~(ST_VP_PENDING | ST_VP_RUNNING | ST_VP_OFF |
>> +                      ST_VP_ABORTING | ST_VP_STREAMING |
>> +                      ST_VP_SENSOR_STREAMING | ST_VP_LASTIRQ);
>> +
>> +       /* Release unused buffers */
>> +       while (!list_empty(&vp->pending_buf_q)) {
>> +               buf = camif_pending_queue_pop(vp);
>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +       }
>> +
>> +       while (!list_empty(&vp->active_buf_q)) {
>> +               buf = camif_active_queue_pop(vp);
>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +       }
>> +
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +
>> +       if (!streaming)
>> +               return 0;
>> +
>> +       return sensor_set_streaming(camif, 0);
>> +}
>> +
>> +static bool s3c_vp_active(struct camif_vp *vp)
>> +{
>> +       struct camif_dev *camif = vp->camif;
>> +       unsigned long flags;
>> +       bool ret;
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +       ret = (vp->state & ST_VP_RUNNING) || (vp->state & ST_VP_PENDING);
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +
>> +       return ret;
>> +}
>> +
>> +static bool camif_is_streaming(struct camif_dev *camif)
>> +{
>> +       unsigned long flags;
>> +       bool status;
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +       status = camif->stream_count > 0;
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +
>> +       return status;
>> +}
>> +
>> +static int camif_stop_capture(struct camif_vp *vp)
>> +{
>> +       struct camif_dev *camif = vp->camif;
>> +       unsigned long flags;
>> +       int ret;
>> +
>> +       if (!s3c_vp_active(vp))
>> +               return 0;
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +       vp->state &= ~(ST_VP_OFF | ST_VP_LASTIRQ);
>> +       vp->state |= ST_VP_ABORTING;
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +
>> +       ret = wait_event_timeout(vp->irq_queue,
>> +                          !(vp->state & ST_VP_ABORTING),
>> +                          msecs_to_jiffies(CAMIF_STOP_TIMEOUT));
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);
>> +
>> +       if (ret == 0 && !(vp->state & ST_VP_OFF)) {
>> +               /* Timed out, forcibly stop capture */
>> +               vp->state &= ~(ST_VP_OFF | ST_VP_ABORTING |
>> +                              ST_VP_LASTIRQ);
>> +
>> +               camif_hw_disable_capture(vp);
>> +               camif_hw_enable_scaler(vp, false);
>> +       }
>> +
>> +       spin_unlock_irqrestore(&camif->slock, flags);
>> +
>> +       return camif_reinitialize(vp);
>> +}
>> +
>> +static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer
>> *vb,
>> +                             struct camif_addr *paddr)
>> +{
>> +       struct camif_frame *frame = &vp->out_frame;
>> +       u32 pix_size;
>> +
>> +       if (vb == NULL || frame == NULL)
>> +               return -EINVAL;
>> +
>> +       pix_size = frame->rect.width * frame->rect.height;
>> +
>> +       pr_debug("colplanes: %d, pix_size: %u\n",
>> +                vp->out_fmt->colplanes, pix_size);
>> +
>> +       paddr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +
>> +       switch (vp->out_fmt->colplanes) {
>> +       case 1:
>> +               paddr->cb = 0;
>> +               paddr->cr = 0;
>> +               break;
>> +       case 2:
>> +               /* decompose Y into Y/Cb */
>> +               paddr->cb = (u32)(paddr->y + pix_size);
>> +               paddr->cr = 0;
>> +               break;
>> +       case 3:
>> +               paddr->cb = (u32)(paddr->y + pix_size);
>> +               /* decompose Y into Y/Cb/Cr */
>> +               if (vp->out_fmt->color == IMG_FMT_YCBCR422P)
>> +                       paddr->cr = (u32)(paddr->cb + (pix_size >> 1));
>> +               else /* 420 */
>> +                       paddr->cr = (u32)(paddr->cb + (pix_size >> 2));
>> +
>> +               if (vp->out_fmt->color == IMG_FMT_YCRCB420)
>> +                       swap(paddr->cb, paddr->cr);
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
>> +                paddr->y, paddr->cb, paddr->cr);
>> +
>> +       return 0;
>> +}
>> +
>> +irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
>> +{
>> +       struct camif_vp *vp = priv;
>> +       struct camif_dev *camif = vp->camif;
>> +       unsigned int ip_rev = camif->variant->ip_revision;
>> +       unsigned int status;
>> +
>> +       spin_lock(&camif->slock);
>> +
>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>> +               camif_hw_clear_pending_irq(vp);
>> +
>> +       status = camif_hw_get_status(vp);
>> +
>> +       if (ip_rev == S3C244X_CAMIF_IP_REV && (status &
>> CISTATUS_OVF_MASK)) {
>> +               camif_hw_clear_fifo_overflow(vp);
>> +               goto unlock;
>> +       }
>> +
>> +       if (vp->state & ST_VP_ABORTING) {
>> +               if (vp->state & ST_VP_OFF) {
>> +                       /* Last IRQ */
>> +                       vp->state &= ~(ST_VP_OFF | ST_VP_ABORTING |
>> +                                      ST_VP_LASTIRQ);
>> +                       wake_up(&vp->irq_queue);
>> +                       goto unlock;
>> +               } else if (vp->state & ST_VP_LASTIRQ) {
>> +                       camif_hw_disable_capture(vp);
>> +                       camif_hw_enable_scaler(vp, false);
>> +                       camif_hw_set_lastirq(vp, false);
>> +                       vp->state |= ST_VP_OFF;
>> +               } else {
>> +                       /* Disable capture, enable last IRQ */
>> +                       camif_hw_set_lastirq(vp, true);
>> +                       vp->state |= ST_VP_LASTIRQ;
>> +               }
>> +       }
>> +
>> +       if (!list_empty(&vp->pending_buf_q) && (vp->state &
>> ST_VP_RUNNING) &&
>> +           !list_empty(&vp->active_buf_q)) {
>> +               unsigned int index;
>> +               struct camif_buffer *vbuf;
>> +               struct timeval *tv;
>> +               struct timespec ts;
>> +               /*
>> +                * Get previous DMA write buffer index:
>> +                * 0 => DMA buffer 0, 2;
>> +                * 1 => DMA buffer 1, 3.
>> +                */
>> +               index = (CISTATUS_FRAMECNT(status) + 2) & 1;
>> +
>> +               ktime_get_ts(&ts);
>> +               vbuf = camif_active_queue_peek(vp, index);
>> +
>> +               if (!WARN_ON(vbuf == NULL)) {
>> +                       /* Dequeue a filled buffer */
>> +                       tv = &vbuf->vb.v4l2_buf.timestamp;
>> +                       tv->tv_sec = ts.tv_sec;
>> +                       tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>> +                       vbuf->vb.v4l2_buf.sequence =
>> vp->frame_sequence++;
>> +                       vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
>> +
>> +                       /* Set up an empty buffer at the DMA engine */
>> +                       vbuf = camif_pending_queue_pop(vp);
>> +                       vbuf->index = index;
>> +                       camif_hw_set_output_addr(vp, &vbuf->paddr,
>> index);
>> +                       camif_hw_set_output_addr(vp, &vbuf->paddr, index
>> + 2);
>> +
>> +                       /* Scheduled in H/W, add to the queue */
>> +                       camif_active_queue_add(vp, vbuf);
>> +               }
>> +       } else if (!(vp->state & ST_VP_ABORTING) &&
>> +                  (vp->state & ST_VP_PENDING))  {
>> +               vp->state |= ST_VP_RUNNING;
>> +       }
>> +
>> +       if (vp->state & ST_VP_CONFIG) {
>> +               camif_prepare_dma_offset(vp);
>> +               camif_hw_set_camera_crop(camif);
>> +               camif_hw_set_scaler(vp);
>> +               camif_hw_set_flip(vp);
>> +               camif_hw_set_test_pattern(camif,
>> camif->test_pattern->val);
>> +               vp->state &= ~ST_VP_CONFIG;
>> +       }
>> +unlock:
>> +       spin_unlock(&camif->slock);
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +       struct camif_vp *vp = vb2_get_drv_priv(vq);
>> +       struct camif_dev *camif = vp->camif;
>> +       unsigned long flags;
>> +       int ret;
>> +
>> +       /*
>> +        * We assume the codec capture path is always activated
>> +        * first, before the preview path starts streaming.
>> +        * This is required to avoid internal FIFO overflow and
>> +        * a need for CAMIF software reset.
>> +        */
>> +       spin_lock_irqsave(&camif->slock, flags);

Here.

>>
>> +
>> +       if (camif->stream_count == 0) {
>> +               camif_hw_reset(camif);
>> +               spin_unlock_irqrestore(&camif->slock, flags);
>> +               ret = s3c_camif_hw_init(camif, vp);
>> +       } else {
>> +               spin_unlock_irqrestore(&camif->slock, flags);
>> +               ret = s3c_camif_hw_vp_init(camif, vp);
>> +       }
>> +
>> +       if (ret < 0) {
>> +               camif_reinitialize(vp);
>> +               return ret;
>> +       }
>> +
>> +       spin_lock_irqsave(&camif->slock, flags);

Could you please check this function? Is it ok that you have double
spin_lock_irqsave()? I don't know may be it's okay. Also when you call
camif_reinitialize() you didn't call spin_unlock_irqrestore() before and
inside camif_reinitialize() you will also call spin_lock_irqsave()..


--
Best regards, Klimov Alexey
