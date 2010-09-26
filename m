Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60045 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0IZK7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 06:59:00 -0400
Received: by wyb28 with SMTP id 28so3083334wyb.19
        for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 03:58:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285091337-12598-1-git-send-email-s.nawrocki@samsung.com>
References: <1285091337-12598-1-git-send-email-s.nawrocki@samsung.com>
Date: Sun, 26 Sep 2010 19:58:57 +0900
Message-ID: <AANLkTinoasrBkek7094h45rdqcPMqFmZGtp8T+Keh_Si@mail.gmail.com>
Subject: Re: [PATCH] v4l: s5p-fimc: Add camera capture support
From: Kyungmin Park <kmpark@infradead.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

Please make several patches, one for samsung, others are for media.
and if possible please make patches orthogonal between samsung SOC and media.
it don't make a build problem when if media patches are merged and
samsung doesn't.

Thank you,
Kyungmin Park

On Wed, Sep 22, 2010 at 2:48 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> This patch implements second video node per each FIMC entity
> providing V4L2 camera capture interface in additions to existing
> mem-to-mem functionality. Each of the two /dev/videoX nodes
> associated with single FIMC hardware entity should be used
> exclusively, i.e. v4l2 mem2mem or capture node.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> ---
>
> Hi all,
>
> This patch adds camera capture capablity to the s5p-fimc driver.
> The driver is based on videobuf 1 however it is meant as a first step
> to videobuf 2 based implementation.
>
> arch/arm/plat-samsung/include/plat/fimc.h header adds platform data
> declarations for camera host interface, which allows to define image
> sensors available at host interface multiplexer in board setup code.
>
> I've tried to keep the driver and platform code independent for easier
> merging however I could not find a way to avoid the above shared
> header file.
>
> The host interface driver has been tested on Samsung Aquila and GONI
> boards with SR030PC30 (VGA) and NOON010PC30 (CIF) image sensors.
> I am working on common driver for these image sensors so the patches
> providing support for them might be available soon.
>
> Next item on my job queue is support for MIPI-CSI2 interface
> in S5P Samsung SoCs. Although most of work related to that is done
> I'm looking toward integration with the media controller API due to
> complex configuration. For example, one of the SoC types contains
> 4 host interfaces and additional 2 MIPI-CSI2 front-ends freely
> interconnectable with any of those 4 host interfaces. Moreover single
> image sensor can be attached to 2 or more host interfaces/scalers
> e.g for preview and image capture.
>
> The patch has been prepared in assumption that the following patches,
> posted by Marek Szyprowski, were applied:
>
> [3/8] v4l: s5p-fimc: Register definition cleanup
> [2/8] v4l: s5p-fimc: Fix 3-planar formats handling and pixel
> offset error on S5PV210 SoCs
> [1/8] v4l: s5p-fimc: Fix return value on probe() failure
>
> Any comments are welcomed.
>
> Regards,
> Sylwester Nawrocki
>
> ---
>  arch/arm/plat-samsung/include/plat/fimc.h   |   31 +
>  drivers/media/video/s5p-fimc/Makefile       |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c |  922 +++++++++++++++++++++++++++
>  drivers/media/video/s5p-fimc/fimc-core.c    |  347 +++++++----
>  drivers/media/video/s5p-fimc/fimc-core.h    |  295 +++++++--
>  drivers/media/video/s5p-fimc/fimc-reg.c     |  194 +++++-
>  drivers/media/video/s5p-fimc/regs-fimc.h    |   23 +-
>  include/media/s3c_fimc.h                    |   48 ++
>  8 files changed, 1661 insertions(+), 201 deletions(-)
>  create mode 100644 arch/arm/plat-samsung/include/plat/fimc.h
>  create mode 100644 drivers/media/video/s5p-fimc/fimc-capture.c
>  create mode 100644 include/media/s3c_fimc.h
>
> diff --git a/arch/arm/plat-samsung/include/plat/fimc.h b/arch/arm/plat-samsung/include/plat/fimc.h
> new file mode 100644
> index 0000000..351eb7e
> --- /dev/null
> +++ b/arch/arm/plat-samsung/include/plat/fimc.h
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (c) 2010 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com/
> + *
> + * Common FIMC devices definitions and helper functions
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#ifndef __PLAT_SAMSUNG_FIMC_H
> +#define __PLAT_SAMSUNG_FIMC_H __FILE__
> +
> +#include <media/s3c_fimc.h>
> +
> +/*
> + * The maximum number of image sensors that can be multiplexed into single FIMC
> + */
> +#define FIMC_MAX_CAM_SOURCES   2
> +
> +/**
> + * struct s3c_platform_fimc - camera host interface platform data
> + *
> + * @cam_info: properties of camera sensor required for host interface setup
> + */
> +struct s3c_platform_fimc {
> +       struct s3c_fimc_isp_info *isp_info[FIMC_MAX_CAM_SOURCES];
> +};
> +
> +#endif /* __PLAT_SAMSUNG_FIMC_H */
> diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/video/s5p-fimc/Makefile
> index 0d9d541..7ea1b14 100644
> --- a/drivers/media/video/s5p-fimc/Makefile
> +++ b/drivers/media/video/s5p-fimc/Makefile
> @@ -1,3 +1,3 @@
>
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) := s5p-fimc.o
> -s5p-fimc-y := fimc-core.o fimc-reg.o
> +s5p-fimc-y := fimc-core.o fimc-reg.o fimc-capture.o
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> new file mode 100644
> index 0000000..ca3ae2d
> --- /dev/null
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -0,0 +1,922 @@
> +/*
> + * Samsung S5P SoC series camera interface (camera capture) driver
> + *
> + * Copyright (c) 2010 Samsung Electronics Co., Ltd
> + * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/version.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/bug.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/clk.h>
> +#include <linux/i2c.h>
> +
> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf-core.h>
> +#include <media/videobuf-dma-contig.h>
> +
> +#include "fimc-core.h"
> +
> +static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
> +                                           struct s3c_fimc_isp_info *isp_info)
> +{
> +       struct i2c_adapter *i2c_adap;
> +       struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> +       struct v4l2_subdev *sd = NULL;
> +
> +       i2c_adap = i2c_get_adapter(isp_info->i2c_bus_num);
> +       if (!i2c_adap)
> +               return ERR_PTR(-ENOMEM);
> +
> +       sd = v4l2_i2c_new_subdev_board(&vid_cap->v4l2_dev, i2c_adap,
> +                                      MODULE_NAME, isp_info->board_info, NULL);
> +       if (!sd) {
> +               v4l2_err(&vid_cap->v4l2_dev, "failed to acquire subdev\n");
> +               return NULL;
> +       }
> +
> +       v4l2_info(&vid_cap->v4l2_dev, "subdevice %s registered successfuly\n",
> +               isp_info->board_info->type);
> +
> +       return sd;
> +}
> +
> +static void fimc_subdev_unregister(struct fimc_dev *fimc)
> +{
> +       struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> +       struct i2c_client *client;
> +
> +       if (vid_cap->input_index < 0)
> +               return; /* Subdevice already released or not registered. */
> +
> +       if (vid_cap->sd) {
> +               v4l2_device_unregister_subdev(vid_cap->sd);
> +               client = v4l2_get_subdevdata(vid_cap->sd);
> +               i2c_unregister_device(client);
> +               i2c_put_adapter(client->adapter);
> +               vid_cap->sd = NULL;
> +       }
> +
> +       vid_cap->input_index = -1;
> +}
> +
> +/**
> + * fimc_subdev_attach - attach v4l2_subdev to camera host interface
> + *
> + * @fimc: FIMC device information
> + * @index: index to the array of available subdevices,
> + *        -1 for full array search or non negative value
> + *        to select specific subdevice
> + */
> +static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
> +{
> +       struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> +       struct s3c_platform_fimc *pdata = fimc->pdata;
> +       struct s3c_fimc_isp_info *isp_info;
> +       struct v4l2_subdev *sd;
> +       int i;
> +
> +       for (i = 0; i < FIMC_MAX_CAM_SOURCES; ++i) {
> +               isp_info = pdata->isp_info[i];
> +
> +               if (!isp_info || (index >= 0 && i != index))
> +                       continue;
> +
> +               sd = fimc_subdev_register(fimc, isp_info);
> +               if (sd) {
> +                       vid_cap->sd = sd;
> +                       vid_cap->input_index = i;
> +
> +                       return 0;
> +               }
> +       }
> +
> +       vid_cap->input_index = -1;
> +       vid_cap->sd = NULL;
> +       v4l2_err(&vid_cap->v4l2_dev, "fimc%d: sensor attach failed\n",
> +                fimc->id);
> +       return -ENODEV;
> +}
> +
> +static int fimc_isp_subdev_init(struct fimc_dev *fimc, int index)
> +{
> +       struct s3c_fimc_isp_info *cam_inf;
> +       int ret;
> +
> +       ret = fimc_subdev_attach(fimc, index);
> +       if (ret)
> +               return ret;
> +
> +       cam_inf = fimc->pdata->isp_info[fimc->vid_cap.input_index];
> +       ret = fimc_hw_set_camera_polarity(fimc, cam_inf);
> +       if (!ret) {
> +               ret = v4l2_subdev_call(fimc->vid_cap.sd, core,
> +                                      s_power, 1);
> +               if (!ret)
> +                       return ret;
> +       }
> +
> +       fimc_subdev_unregister(fimc);
> +       err("ISP initialization failed: %d", ret);
> +       return ret;
> +}
> +
> +/*
> + * At least one buffer on the pending_buf_q queue is required.
> + * Locking: The caller holds fimc->slock spinlock.
> + */
> +int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
> +                            struct fimc_vid_buffer *fimc_vb)
> +{
> +       struct fimc_vid_cap *cap = &fimc->vid_cap;
> +       struct fimc_ctx *ctx = cap->ctx;
> +       int ret = 0;
> +
> +       assert(fimc != NULL);
> +       assert(fimc_vb != NULL);
> +
> +       ret = fimc_prepare_addr(ctx, fimc_vb, &ctx->d_frame,
> +                               &fimc_vb->paddr);
> +       if (ret)
> +               return ret;
> +
> +       if (test_bit(ST_CAPT_STREAM, &fimc->state)) {
> +               fimc_pending_queue_add(cap, fimc_vb);
> +       } else {
> +               /* Setup the buffer directly for processing. */
> +               int buf_id = (cap->reqbufs_count == 1) ? -1 : cap->buf_index;
> +               fimc_hw_set_output_addr(fimc, &fimc_vb->paddr, buf_id);
> +
> +               fimc_vb->index = cap->buf_index;
> +               active_queue_add(cap, fimc_vb);
> +
> +               if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
> +                       cap->buf_index = 0;
> +       }
> +       return ret;
> +}
> +
> +static int fimc_stop_capture(struct fimc_dev *fimc)
> +{
> +       unsigned long flags;
> +       struct fimc_vid_cap *cap;
> +       int ret;
> +
> +       cap = &fimc->vid_cap;
> +
> +       if (!fimc_capture_active(fimc))
> +               return 0;
> +
> +       spin_lock_irqsave(&fimc->slock, flags);
> +       set_bit(ST_CAPT_SHUT, &fimc->state);
> +       fimc_deactivate_capture(fimc);
> +       spin_unlock_irqrestore(&fimc->slock, flags);
> +
> +       wait_event_timeout(fimc->irq_queue,
> +                          test_bit(ST_CAPT_SHUT, &fimc->state),
> +                          FIMC_SHUTDOWN_TIMEOUT);
> +
> +       ret = v4l2_subdev_call(cap->sd, video, s_stream, 0);
> +       if (ret)
> +               v4l2_err(&fimc->vid_cap.v4l2_dev, "s_stream(0) failed\n");
> +
> +       spin_lock_irqsave(&fimc->slock, flags);
> +       fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
> +                       1 << ST_CAPT_STREAM);
> +
> +       fimc->vid_cap.active_buf_cnt = 0;
> +       spin_unlock_irqrestore(&fimc->slock, flags);
> +
> +       dbg("state= 0x%lx", fimc->state);
> +       return 0;
> +}
> +
> +static int fimc_capture_open(struct file *file)
> +{
> +       struct fimc_dev *fimc = video_drvdata(file);
> +       int ret = 0;
> +
> +       mutex_lock(&fimc->lock);
> +
> +       dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
> +
> +       if (++fimc->vid_cap.refcnt == 1) {
> +               ret = fimc_isp_subdev_init(fimc, -1);
> +               if (ret) {
> +                       fimc->vid_cap.refcnt--;
> +                       ret = -EIO;
> +               } else {
> +                       file->private_data = fimc->vid_cap.ctx;
> +               }
> +       }
> +
> +       mutex_unlock(&fimc->lock);
> +
> +       return ret;
> +}
> +
> +static int fimc_capture_close(struct file *file)
> +{
> +       struct fimc_dev *fimc = video_drvdata(file);
> +
> +       mutex_lock(&fimc->lock);
> +       dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
> +
> +       fimc_stop_capture(fimc);
> +
> +       videobuf_stop(&fimc->vid_cap.vbq);
> +       videobuf_mmap_free(&fimc->vid_cap.vbq);
> +
> +       if (--fimc->vid_cap.refcnt == 0) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev, "releasing ISP\n");
> +               v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
> +               fimc_subdev_unregister(fimc);
> +       }
> +       mutex_unlock(&fimc->lock);
> +
> +       return 0;
> +}
> +
> +static unsigned int fimc_capture_poll(struct file *file,
> +                                    struct poll_table_struct *wait)
> +{
> +       return POLLERR;
> +}
> +
> +static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct fimc_ctx *ctx = file->private_data;
> +       struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
> +
> +       return videobuf_mmap_mapper(&cap->vbq, vma);
> +}
> +
> +/* video device file operations */
> +static const struct v4l2_file_operations fimc_capture_fops = {
> +       .owner          = THIS_MODULE,
> +       .open           = fimc_capture_open,
> +       .release        = fimc_capture_close,
> +       .poll           = fimc_capture_poll,
> +       .ioctl          = video_ioctl2,
> +       .mmap           = fimc_capture_mmap,
> +};
> +
> +static int vidioc_querycap_capture(struct file *file, void *priv,
> +                          struct v4l2_capability *cap)
> +{
> +       struct fimc_ctx *ctx = file->private_data;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +
> +       strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
> +       strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
> +       cap->bus_info[0] = 0;
> +       cap->version = KERNEL_VERSION(1, 0, 0);
> +       cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
> +
> +       return 0;
> +}
> +
> +static int vidioc_g_fmt_capture(struct file *file, void *priv,
> +                             struct v4l2_format *f)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_frame *frame = &ctx->s_frame;
> +
> +       mutex_lock(&ctx->fimc_dev->lock);
> +
> +       f->fmt.pix.width        = frame->width;
> +       f->fmt.pix.height       = frame->height;
> +       f->fmt.pix.field        = V4L2_FIELD_NONE;
> +       f->fmt.pix.pixelformat  = frame->fmt->fourcc;
> +
> +       mutex_unlock(&ctx->fimc_dev->lock);
> +       return 0;
> +}
> +
> +static int vidioc_try_fmt_capture(struct file *file, void *priv,
> +                            struct v4l2_format *f)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       struct samsung_fimc_variant *variant = fimc->variant;
> +       struct v4l2_pix_format *pix = &f->fmt.pix;
> +       struct fimc_fmt *fmt;
> +       u32 max_width, max_height;
> +       u32 mod_x, mod_y;
> +
> +       fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
> +       if (!fmt) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev,
> +                        "Fourcc format (0x%08x) invalid.\n",
> +                        pix->pixelformat);
> +               return -EINVAL;
> +       }
> +
> +       if (pix->field == V4L2_FIELD_ANY)
> +               pix->field = V4L2_FIELD_NONE;
> +       else if (V4L2_FIELD_NONE != pix->field)
> +               return -EINVAL;
> +
> +       max_width = fimc->variant->scaler_dis_w;
> +       max_height = fimc->variant->scaler_dis_w;
> +       mod_x = variant->min_out_pixsize;
> +       mod_y = variant->min_out_pixsize;
> +
> +       if (pix->height > max_height)
> +               pix->height = max_height;
> +       if (pix->width > max_width)
> +               pix->width = max_width;
> +
> +       if (tiled_fmt(fmt)) {
> +               mod_x = 64; /* 64x32 tile */
> +               mod_y = 32;
> +       }
> +
> +       pix->width = (pix->width == 0) ? mod_x : ALIGN(pix->width, mod_x);
> +       pix->height = (pix->height == 0) ? mod_y : ALIGN(pix->height, mod_y);
> +
> +       if (pix->bytesperline == 0 ||
> +           pix->bytesperline * 8 / fmt->depth > pix->width)
> +               pix->bytesperline = (pix->width * fmt->depth) >> 3;
> +
> +       if (pix->sizeimage == 0)
> +               pix->sizeimage = pix->height * pix->bytesperline;
> +
> +       dbg("pix->bytesperline= %d, fmt->depth= %d",
> +           pix->bytesperline, fmt->depth);
> +
> +       return 0;
> +}
> +
> +/* Synchronize formats of the camera interface input and attached  sensor. */
> +static int sync_capture_fmt(struct fimc_ctx *ctx)
> +{
> +       struct fimc_frame *frame = &ctx->s_frame;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       struct v4l2_mbus_framefmt *fmt = &fimc->vid_cap.fmt;
> +       int ret;
> +
> +       fmt->width  = ctx->d_frame.o_width;
> +       fmt->height = ctx->d_frame.o_height;
> +
> +       ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_mbus_fmt, fmt);
> +       if (ret == -ENOIOCTLCMD) {
> +               err("s_mbus_fmt failed");
> +               return ret;
> +       }
> +       ret = v4l2_subdev_call(fimc->vid_cap.sd, video, g_mbus_fmt, fmt);
> +       if (ret) {
> +               err("g_mbus_fmt failed: %d", ret);
> +               return ret;
> +       }
> +       dbg("w= %d, h= %d, code= %d", fmt->width, fmt->height, fmt->code);
> +
> +       frame->fmt = find_mbus_format(fmt, FMT_FLAGS_CAM);
> +       if (!frame->fmt) {
> +               err("fimc source format not found\n");
> +               return -EINVAL;
> +       }
> +
> +       frame->size     = (fmt->width * fmt->height * frame->fmt->depth) >> 3;
> +       frame->f_width          = fmt->width;
> +       frame->f_height = fmt->height;
> +       frame->width    = fmt->width;
> +       frame->height   = fmt->height;
> +       frame->o_width          = fmt->width;
> +       frame->o_height = fmt->height;
> +       frame->offs_h   = 0;
> +       frame->offs_v   = 0;
> +
> +       return 0;
> +}
> +
> +static int vidioc_s_fmt_capture(struct file *file, void *priv,
> +                            struct v4l2_format *f)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       struct fimc_frame *frame;
> +       struct v4l2_pix_format *pix;
> +       int ret;
> +
> +       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       ret = vidioc_try_fmt_capture(file, priv, f);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&fimc->lock);
> +
> +       if (fimc_capture_active(fimc)) {
> +               ret = -EBUSY;
> +               goto sf_unlock;
> +       }
> +
> +       frame = &ctx->d_frame;
> +
> +       pix = &f->fmt.pix;
> +       frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
> +       if (!frame->fmt) {
> +               err("fimc target format not found\n");
> +               ret = -EINVAL;
> +               goto sf_unlock;
> +       }
> +
> +       /* Output DMA frame pixel size and offsets. */
> +       frame->f_width  = pix->bytesperline * 8 / frame->fmt->depth;
> +       frame->f_height = pix->height;
> +       frame->width    = pix->width;
> +       frame->height   = pix->height;
> +       frame->o_width  = pix->width;
> +       frame->o_height = pix->height;
> +       frame->size     = (pix->width * pix->height * frame->fmt->depth) >> 3;
> +       frame->offs_h   = 0;
> +       frame->offs_v   = 0;
> +
> +       ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
> +
> +sf_unlock:
> +       mutex_unlock(&fimc->lock);
> +       return ret;
> +}
> +
> +static int vidioc_enum_input_capture(struct file *file, void *priv,
> +                                    struct v4l2_input *i)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct s3c_platform_fimc *pldata = ctx->fimc_dev->pdata;
> +       struct s3c_fimc_isp_info *isp_info;
> +
> +       dbg("i->index= %d", i->index);
> +
> +       if (i->index >= FIMC_MAX_CAM_SOURCES)
> +               return -EINVAL;
> +
> +       isp_info = pldata->isp_info[i->index];
> +       if (isp_info == NULL)
> +               return -EINVAL; /* FIXME: is this right error code? */
> +
> +       i->type = V4L2_INPUT_TYPE_CAMERA;
> +       strncpy(i->name, isp_info->board_info->type, 32);
> +
> +       return 0;
> +}
> +
> +static int vidioc_s_input_capture(struct file *file, void *priv,
> +                                 unsigned int i)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       struct s3c_platform_fimc *pdata = fimc->pdata;
> +       int ret;
> +
> +       if (fimc_capture_active(ctx->fimc_dev))
> +               return -EBUSY;
> +
> +       mutex_lock(&fimc->lock);
> +
> +       if (i >= FIMC_MAX_CAM_SOURCES || !pdata->isp_info[i]) {
> +               ret = -EINVAL;
> +               goto si_unlock;
> +       }
> +
> +       if (fimc->vid_cap.sd) {
> +               ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
> +               if (ret)
> +                       err("s_power failed: %d", ret);
> +       }
> +
> +       /* Release the attached sensor subdevice. */
> +       fimc_subdev_unregister(fimc);
> +
> +       ret = fimc_isp_subdev_init(fimc, i);
> +
> +si_unlock:
> +       mutex_unlock(&fimc->lock);
> +       return ret;
> +}
> +
> +static int vidioc_g_input_capture(struct file *file, void *priv,
> +                                      unsigned int *i)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
> +
> +       *i = cap->input_index;
> +       return 0;
> +}
> +
> +static int vidioc_streamon_capture(struct file *file, void *priv,
> +                          enum v4l2_buf_type type)
> +{
> +       struct s3c_fimc_isp_info *isp_info;
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       int ret;
> +
> +       mutex_lock(&fimc->lock);
> +
> +       if (fimc_capture_active(fimc) || !fimc->vid_cap.sd) {
> +               ret = -EBUSY;
> +               goto s_unlock;
> +       }
> +
> +       if (!(ctx->state & FIMC_DST_FMT)) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev, "Format is not set\n");
> +               ret = -EINVAL;
> +               goto s_unlock;
> +       }
> +
> +       /*
> +        * s_mbus_fmt is called on camera sensor subdevice here to enable
> +        * reasonable operation in the configuration where single camera sensor
> +        * is attached to more than one brigde (FIMC).
> +        */
> +       ret = sync_capture_fmt(ctx);
> +       if (!ret)
> +               ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
> +
> +       if (ret && ret != -ENOIOCTLCMD) {
> +               ret = -EBUSY;
> +               goto s_unlock;
> +       }
> +
> +       dbg("buf_index: %d", fimc->vid_cap.buf_index);
> +
> +       ctx->state &= ~(FIMC_SRC_ADDR | FIMC_DST_ADDR);
> +       ret = fimc_prepare_config(ctx, ctx->state);
> +       if (ret) {
> +               ret = -EBUSY;
> +               goto s_unlock;
> +       }
> +
> +       isp_info = fimc->pdata->isp_info[fimc->vid_cap.input_index];
> +       fimc_hw_set_camera_type(fimc, isp_info);
> +       fimc_hw_set_camera_source(fimc, isp_info);
> +       fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
> +       fimc_hw_set_input_path(ctx);
> +
> +       if (fimc_set_scaler_info(ctx)) {
> +               err("scaler configuration failure");
> +               ret = -EBUSY;
> +               goto s_unlock;
> +       }
> +
> +       fimc_hw_set_scaler(ctx);
> +       fimc_hw_set_target_format(ctx);
> +       fimc_hw_set_rotation(ctx);
> +       fimc_hw_set_effect(ctx);
> +
> +       fimc_hw_set_output_path(ctx);
> +       fimc_hw_set_out_dma(ctx);
> +
> +       INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
> +       INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
> +       fimc->vid_cap.active_buf_cnt = 0;
> +       fimc->vid_cap.frame_count = 0;
> +
> +       set_bit(ST_CAPT_PEND, &fimc->state);
> +       ret = videobuf_streamon(&fimc->vid_cap.vbq);
> +
> +s_unlock:
> +       mutex_unlock(&fimc->lock);
> +       return ret;
> +}
> +
> +static int vidioc_streamoff_capture(struct file *file, void *priv,
> +                           enum v4l2_buf_type type)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       struct fimc_vid_cap *cap = &fimc->vid_cap;
> +       unsigned long flags;
> +       int ret;
> +
> +       spin_lock_irqsave(&fimc->slock, flags);
> +       if (!fimc_capture_running(fimc) && !fimc_capture_pending(fimc)) {
> +               spin_unlock_irqrestore(&fimc->slock, flags);
> +               dbg("state: 0x%lx", fimc->state);
> +               return -EINVAL;
> +       }
> +       spin_unlock_irqrestore(&fimc->slock, flags);
> +
> +       mutex_lock(&fimc->lock);
> +       fimc_stop_capture(fimc);
> +       ret = videobuf_streamoff(&cap->vbq);
> +       mutex_unlock(&fimc->lock);
> +       return ret;
> +}
> +
> +static int vidioc_reqbufs_capture(struct file *file, void *priv,
> +                         struct v4l2_requestbuffers *reqbufs)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
> +       int ret;
> +
> +       if (fimc_capture_active(ctx->fimc_dev))
> +               return -EBUSY;
> +
> +       ret = videobuf_reqbufs(&cap->vbq, reqbufs);
> +       cap->reqbufs_count = reqbufs->count;
> +       dbg("reqbufs_count: %d", cap->reqbufs_count);
> +       return ret;
> +}
> +
> +static int vidioc_querybuf_capture(struct file *file, void *priv,
> +                          struct v4l2_buffer *buf)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
> +
> +       if (fimc_capture_active(ctx->fimc_dev))
> +               return -EBUSY;
> +
> +       return videobuf_querybuf(&cap->vbq, buf);
> +}
> +
> +static int vidioc_qbuf_capture(struct file *file, void *priv,
> +                         struct v4l2_buffer *buf)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
> +
> +       return videobuf_qbuf(&cap->vbq, buf);
> +}
> +
> +static int vidioc_dqbuf_capture(struct file *file, void *priv,
> +                          struct v4l2_buffer *buf)
> +{
> +       struct fimc_ctx *ctx = priv;
> +
> +       return videobuf_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
> +               file->f_flags & O_NONBLOCK);
> +}
> +
> +static int vidioc_s_ctrl(struct file *file, void *priv,
> +                        struct v4l2_control *ctrl)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       int ret;
> +
> +       if (fimc_capture_active(ctx->fimc_dev))
> +               return -EBUSY;
> +
> +       ret = check_ctrl_val(ctx, ctrl);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&ctx->fimc_dev->lock);
> +       ret = fimc_s_ctrl(ctx, ctrl);
> +       if (!ret)
> +               ctx->state |= FIMC_PARAMS;
> +       mutex_unlock(&ctx->fimc_dev->lock);
> +       return 0;
> +}
> +
> +static int vidioc_cropcap_capture(struct file *file, void *fh,
> +                            struct v4l2_cropcap *cr)
> +{
> +       struct fimc_ctx *ctx = fh;
> +       struct fimc_frame *f = &ctx->d_frame;
> +
> +       if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       cr->bounds.left = 0;
> +       cr->bounds.top = 0;
> +
> +       mutex_lock(&ctx->fimc_dev->lock);
> +
> +       cr->bounds.width = f->f_width;
> +       cr->bounds.height = f->f_height;
> +       cr->defrect.left = f->offs_h;
> +       cr->defrect.top = f->offs_v;
> +       cr->defrect.width = f->o_width;
> +       cr->defrect.height = f->o_height;
> +
> +       mutex_unlock(&ctx->fimc_dev->lock);
> +       return 0;
> +}
> +
> +static int vidioc_g_crop_capture(struct file *file, void *fh,
> +                              struct v4l2_crop *cr)
> +{
> +       struct fimc_ctx *ctx = file->private_data;
> +       struct fimc_frame *f = &ctx->s_frame;
> +
> +       if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       mutex_lock(&ctx->fimc_dev->lock);
> +
> +       cr->c.left = f->offs_h;
> +       cr->c.top = f->offs_v;
> +       cr->c.width = f->width;
> +       cr->c.height = f->height;
> +
> +       mutex_unlock(&ctx->fimc_dev->lock);
> +       return 0;
> +}
> +
> +static int vidioc_s_crop_capture(struct file *file, void *fh,
> +                              struct v4l2_crop *cr)
> +{
> +       struct fimc_frame *f;
> +       struct fimc_ctx *ctx = file->private_data;
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       int ret = -EINVAL;
> +
> +       if (fimc_capture_active(fimc))
> +               return -EBUSY;
> +
> +       mutex_lock(&fimc->lock);
> +       f = &ctx->s_frame;
> +
> +       if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +           !(ctx->state & FIMC_DST_FMT)) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev,
> +                        "Wrong video buffer type or format not set\n");
> +               goto sc_unlock;
> +       }
> +
> +       if (cr->c.top < 0 || cr->c.left < 0) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev,
> +                       "Doesn't support negative values for top & left\n");
> +               goto sc_unlock;
> +       }
> +
> +       /* Adjust to DMA_MIN_SIZE pixels boundary. */
> +       cr->c.width = ALIGN(cr->c.width, DMA_MIN_SIZE) ;
> +       cr->c.height = ALIGN(cr->c.height, DMA_MIN_SIZE);
> +       cr->c.left = ALIGN(cr->c.left, DMA_MIN_SIZE);
> +       cr->c.top = ALIGN(cr->c.top, DMA_MIN_SIZE);
> +
> +       dbg("%d %d %d %d f_w= %d, f_h= %d",
> +               cr->c.left, cr->c.top, cr->c.width, cr->c.height,
> +               f->f_width, f->f_height);
> +
> +       if ((cr->c.left + cr->c.width > f->o_width)
> +               || (cr->c.top + cr->c.height > f->o_height)) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev, "Error in S_CROP params\n");
> +               goto sc_unlock;
> +       }
> +
> +       /* Check for the pixel scaling ratio when cropping input image. */
> +       ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
> +       if (ret) {
> +               v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range");
> +               goto sc_unlock;
> +       }
> +
> +       ret = 0;
> +       f->offs_h = cr->c.left;
> +       f->offs_v = cr->c.top;
> +       f->width = cr->c.width;
> +       f->height = cr->c.height;
> +
> +sc_unlock:
> +       mutex_lock(&fimc->lock);
> +       return ret;
> +}
> +
> +
> +static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
> +       .vidioc_querycap                = vidioc_querycap_capture,
> +
> +       .vidioc_enum_fmt_vid_cap        = fimc_m2m_enum_fmt,
> +       .vidioc_try_fmt_vid_cap         = vidioc_try_fmt_capture,
> +       .vidioc_s_fmt_vid_cap           = vidioc_s_fmt_capture,
> +       .vidioc_g_fmt_vid_cap           = vidioc_g_fmt_capture,
> +
> +       .vidioc_reqbufs                 = vidioc_reqbufs_capture,
> +       .vidioc_querybuf                = vidioc_querybuf_capture,
> +
> +       .vidioc_qbuf                    = vidioc_qbuf_capture,
> +       .vidioc_dqbuf                   = vidioc_dqbuf_capture,
> +
> +       .vidioc_streamon                = vidioc_streamon_capture,
> +       .vidioc_streamoff               = vidioc_streamoff_capture,
> +
> +       .vidioc_queryctrl               = fimc_m2m_queryctrl,
> +       .vidioc_g_ctrl                  = fimc_m2m_g_ctrl,
> +       .vidioc_s_ctrl                  = vidioc_s_ctrl,
> +
> +       .vidioc_g_crop                  = vidioc_g_crop_capture,
> +       .vidioc_s_crop                  = vidioc_s_crop_capture,
> +       .vidioc_cropcap                 = vidioc_cropcap_capture,
> +
> +       .vidioc_enum_input              = vidioc_enum_input_capture,
> +       .vidioc_s_input                 = vidioc_s_input_capture,
> +       .vidioc_g_input                 = vidioc_g_input_capture,
> +};
> +
> +int fimc_register_capture_device(struct fimc_dev *fimc)
> +{
> +       struct v4l2_device *v4l2_dev = &fimc->vid_cap.v4l2_dev;
> +       struct video_device *vfd;
> +       struct fimc_vid_cap *vid_cap;
> +       struct fimc_ctx *ctx;
> +       struct v4l2_format f;
> +       int ret;
> +
> +       ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +       if (!ctx)
> +               return -ENOMEM;
> +
> +       ctx->fimc_dev    = fimc;
> +       ctx->effect.type = S5P_FIMC_EFFECT_ORIGINAL;
> +       ctx->in_path     = FIMC_CAMERA;
> +       ctx->out_path    = FIMC_DMA;
> +       ctx->state       = FIMC_CTX_CAP;
> +
> +       f.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
> +       ctx->d_frame.fmt = find_format(&f, FMT_FLAGS_M2M);
> +
> +       if (!v4l2_dev->name[0])
> +               snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
> +                        "%s.capture", dev_name(&fimc->pdev->dev));
> +
> +       ret = v4l2_device_register(NULL, v4l2_dev);
> +       if (ret)
> +               goto err_info;
> +
> +       vfd = video_device_alloc();
> +       if (!vfd) {
> +               v4l2_err(v4l2_dev, "Failed to allocate video device\n");
> +               goto err_v4l2_reg;
> +       }
> +
> +       snprintf(vfd->name, sizeof(vfd->name), "%s:cap",
> +                dev_name(&fimc->pdev->dev));
> +
> +       vfd->fops       = &fimc_capture_fops;
> +       vfd->ioctl_ops  = &fimc_capture_ioctl_ops;
> +       vfd->minor      = -1;
> +       vfd->release    = video_device_release;
> +       video_set_drvdata(vfd, fimc);
> +
> +       vid_cap = &fimc->vid_cap;
> +       vid_cap->vfd = vfd;
> +       vid_cap->active_buf_cnt = 0;
> +       vid_cap->reqbufs_count  = 0;
> +       vid_cap->refcnt = 0;
> +       /* The default color format for image sensor. */
> +       vid_cap->fmt.code = V4L2_MBUS_FMT_VYUY8_2X8;
> +
> +       INIT_LIST_HEAD(&vid_cap->pending_buf_q);
> +       INIT_LIST_HEAD(&vid_cap->active_buf_q);
> +       spin_lock_init(&ctx->slock);
> +       vid_cap->ctx = ctx;
> +
> +       videobuf_queue_dma_contig_init(&vid_cap->vbq, &fimc_qops,
> +               vid_cap->v4l2_dev.dev, &fimc->irqlock,
> +               V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> +               sizeof(struct fimc_vid_buffer), (void *)ctx);
> +
> +       ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +       if (ret) {
> +               v4l2_err(v4l2_dev, "Failed to register video device\n");
> +               goto err_vd_reg;
> +       }
> +
> +       v4l2_info(v4l2_dev,
> +                 "FIMC capture driver registered as /dev/video%d\n",
> +                 vfd->num);
> +
> +       return 0;
> +
> +err_vd_reg:
> +       video_device_release(vfd);
> +err_v4l2_reg:
> +       v4l2_device_unregister(v4l2_dev);
> +err_info:
> +       dev_err(&fimc->pdev->dev, "failed to install\n");
> +       return ret;
> +}
> +
> +void fimc_unregister_capture_device(struct fimc_dev *fimc)
> +{
> +       struct fimc_vid_cap *capture = &fimc->vid_cap;
> +
> +       if (capture->vfd)
> +               video_unregister_device(capture->vfd);
> +
> +       kfree(capture->ctx);
> +}
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index e00026b..1efaec4 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -1,9 +1,8 @@
>  /*
> - * S5P camera interface (video postprocessor) driver
> + * Samsung S5P SoC series camera interface (video postprocessor) driver
>  *
> - * Copyright (c) 2010 Samsung Electronics
> - *
> - * Sylwester Nawrocki, <s.nawrocki@samsung.com>
> + * Copyright (c) 2010 Samsung Electronics Co., Ltd
> + * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published
> @@ -38,86 +37,103 @@ static struct fimc_fmt fimc_formats[] = {
>                .depth  = 16,
>                .color  = S5P_FIMC_RGB565,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> +               .planes_cnt = 1,
> +               .mbus_code = V4L2_MBUS_FMT_RGB565_2X8_BE,
> +               .flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>        }, {
>                .name   = "BGR666",
>                .fourcc = V4L2_PIX_FMT_BGR666,
>                .depth  = 32,
>                .color  = S5P_FIMC_RGB666,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> +               .planes_cnt = 1,
> +               .flags = FMT_FLAGS_M2M,
>        }, {
>                .name = "XRGB-8-8-8-8, 24 bpp",
>                .fourcc = V4L2_PIX_FMT_RGB24,
>                .depth = 32,
>                .color  = S5P_FIMC_RGB888,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> +               .planes_cnt = 1,
> +               .flags = FMT_FLAGS_M2M,
>        }, {
>                .name   = "YUV 4:2:2 packed, YCbYCr",
>                .fourcc = V4L2_PIX_FMT_YUYV,
>                .depth  = 16,
>                .color  = S5P_FIMC_YCBYCR422,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> -               }, {
> +               .planes_cnt = 1,
> +               .mbus_code = V4L2_MBUS_FMT_YUYV8_2X8,
> +               .flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
> +       }, {
>                .name   = "YUV 4:2:2 packed, CbYCrY",
>                .fourcc = V4L2_PIX_FMT_UYVY,
>                .depth  = 16,
>                .color  = S5P_FIMC_CBYCRY422,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> +               .planes_cnt = 1,
> +               .mbus_code = V4L2_MBUS_FMT_VYUY8_2X8,
> +               .flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>        }, {
>                .name   = "YUV 4:2:2 packed, CrYCbY",
>                .fourcc = V4L2_PIX_FMT_VYUY,
>                .depth  = 16,
>                .color  = S5P_FIMC_CRYCBY422,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> +               .planes_cnt = 1,
> +               .mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
> +               .flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>        }, {
>                .name   = "YUV 4:2:2 packed, YCrYCb",
>                .fourcc = V4L2_PIX_FMT_YVYU,
>                .depth  = 16,
>                .color  = S5P_FIMC_YCRYCB422,
>                .buff_cnt = 1,
> -               .planes_cnt = 1
> +               .planes_cnt = 1,
> +               .mbus_code = V4L2_MBUS_FMT_YVYU8_2X8,
> +               .flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
>        }, {
>                .name   = "YUV 4:2:2 planar, Y/Cb/Cr",
>                .fourcc = V4L2_PIX_FMT_YUV422P,
>                .depth  = 12,
>                .color  = S5P_FIMC_YCBCR422,
>                .buff_cnt = 1,
> -               .planes_cnt = 3
> +               .planes_cnt = 3,
> +               .flags = FMT_FLAGS_M2M,
>        }, {
>                .name   = "YUV 4:2:2 planar, Y/CbCr",
>                .fourcc = V4L2_PIX_FMT_NV16,
>                .depth  = 16,
>                .color  = S5P_FIMC_YCBCR422,
>                .buff_cnt = 1,
> -               .planes_cnt = 2
> +               .planes_cnt = 2,
> +               .flags = FMT_FLAGS_M2M,
>        }, {
>                .name   = "YUV 4:2:2 planar, Y/CrCb",
>                .fourcc = V4L2_PIX_FMT_NV61,
>                .depth  = 16,
>                .color  = S5P_FIMC_RGB565,
>                .buff_cnt = 1,
> -               .planes_cnt = 2
> +               .planes_cnt = 2,
> +               .flags = FMT_FLAGS_M2M,
>        }, {
>                .name   = "YUV 4:2:0 planar, YCbCr",
>                .fourcc = V4L2_PIX_FMT_YUV420,
>                .depth  = 12,
>                .color  = S5P_FIMC_YCBCR420,
>                .buff_cnt = 1,
> -               .planes_cnt = 3
> +               .planes_cnt = 3,
> +               .flags = FMT_FLAGS_M2M,
>        }, {
>                .name   = "YUV 4:2:0 planar, Y/CbCr",
>                .fourcc = V4L2_PIX_FMT_NV12,
>                .depth  = 12,
>                .color  = S5P_FIMC_YCBCR420,
>                .buff_cnt = 1,
> -               .planes_cnt = 2
> -       }
> - };
> +               .planes_cnt = 2,
> +               .flags = FMT_FLAGS_M2M,
> +       },
> +};
>
>  static struct v4l2_queryctrl fimc_ctrls[] = {
>        {
> @@ -158,7 +174,7 @@ static struct v4l2_queryctrl *get_ctrl(int id)
>        return NULL;
>  }
>
> -static int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
> +int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
>  {
>        if (r->width > f->width) {
>                if (f->width > (r->width * SCALER_MAX_HRATIO))
> @@ -206,7 +222,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
>        return 0;
>  }
>
> -static int fimc_set_scaler_info(struct fimc_ctx *ctx)
> +int fimc_set_scaler_info(struct fimc_ctx *ctx)
>  {
>        struct fimc_scaler *sc = &ctx->scaler;
>        struct fimc_frame *s_frame = &ctx->s_frame;
> @@ -261,12 +277,63 @@ static int fimc_set_scaler_info(struct fimc_ctx *ctx)
>        return 0;
>  }
>
> +static void fimc_capture_handler(struct fimc_dev *fimc)
> +{
> +       struct fimc_vid_cap *cap = &fimc->vid_cap;
> +       struct fimc_vid_buffer *v_buf = NULL;
> +
> +       if (!list_empty(&cap->active_buf_q)) {
> +               v_buf = active_queue_pop(cap);
> +               fimc_buf_finish(fimc, v_buf);
> +       }
> +
> +       if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
> +               wake_up(&fimc->irq_queue);
> +               return;
> +       }
> +
> +       dbg("cap->active_buf_cnt= %d", cap->active_buf_cnt);
> +
> +       if (!list_empty(&cap->pending_buf_q)) {
> +               assert(cap->active_buf_cnt < FIMC_MAX_OUT_BUFS);
> +
> +               v_buf = pending_queue_pop(cap);
> +
> +               fimc_hw_set_output_addr(fimc, &v_buf->paddr, cap->buf_index);
> +               v_buf->index = cap->buf_index;
> +
> +               dbg("hw ptr: %d, sw ptr: %d",
> +                   fimc_hw_get_frame_index(fimc), cap->buf_index);
> +
> +               spin_lock(&fimc->irqlock);
> +               v_buf->vb.state = VIDEOBUF_ACTIVE;
> +               spin_unlock(&fimc->irqlock);
> +
> +               /* Move the buffer to the capture active queue,
> +                 this step is not really necessary. */
> +               active_queue_add(cap, v_buf);
> +
> +               dbg("next frame: %d, done frame: %d",
> +                   fimc_hw_get_frame_index(fimc), v_buf->index);
> +
> +               if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
> +                       cap->buf_index = 0;
> +
> +       } else if (test_and_clear_bit(ST_CAPT_STREAM, &fimc->state) &&
> +                  cap->active_buf_cnt <= 1) {
> +               fimc_deactivate_capture(fimc);
> +               dbg("stopped");
> +       }
> +
> +       dbg("frame: %d, active_buf_cnt= %d",
> +           fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
> +}
>
>  static irqreturn_t fimc_isr(int irq, void *priv)
>  {
>        struct fimc_vid_buffer *src_buf, *dst_buf;
> -       struct fimc_dev *fimc = (struct fimc_dev *)priv;
>        struct fimc_ctx *ctx;
> +       struct fimc_dev *fimc = (struct fimc_dev *)priv;
>
>        BUG_ON(!fimc);
>        fimc_hw_clear_irq(fimc);
> @@ -281,12 +348,22 @@ static irqreturn_t fimc_isr(int irq, void *priv)
>                dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
>                if (src_buf && dst_buf) {
>                        spin_lock(&fimc->irqlock);
> -                       src_buf->vb.state = dst_buf->vb.state =  VIDEOBUF_DONE;
> +                       src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
>                        wake_up(&src_buf->vb.done);
>                        wake_up(&dst_buf->vb.done);
>                        spin_unlock(&fimc->irqlock);
>                        v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
>                }
> +               goto isr_unlock;
> +
> +       }
> +
> +       if (test_bit(ST_CAPT_RUN, &fimc->state))
> +               fimc_capture_handler(fimc);
> +
> +       if (test_and_clear_bit(ST_CAPT_PEND, &fimc->state)) {
> +               set_bit(ST_CAPT_RUN, &fimc->state);
> +               wake_up(&fimc->irq_queue);
>        }
>
>  isr_unlock:
> @@ -295,20 +372,13 @@ isr_unlock:
>  }
>
>  /* The color format (planes_cnt, buff_cnt) must be already configured. */
> -static int fimc_prepare_addr(struct fimc_ctx *ctx,
> -               struct fimc_vid_buffer *buf, enum v4l2_buf_type type)
> +int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
> +                     struct fimc_frame *frame, struct fimc_addr *paddr)
>  {
> -       struct fimc_frame *frame;
> -       struct fimc_addr *paddr;
> -       u32 pix_size;
>        int ret = 0;
> +       u32 pix_size;
>
> -       frame = ctx_m2m_get_frame(ctx, type);
> -       if (IS_ERR(frame))
> -               return PTR_ERR(frame);
> -       paddr = &frame->paddr;
> -
> -       if (!buf)
> +       if (buf == NULL || frame == NULL)
>                return -EINVAL;
>
>        pix_size = frame->width * frame->height;
> @@ -344,8 +414,8 @@ static int fimc_prepare_addr(struct fimc_ctx *ctx,
>                }
>        }
>
> -       dbg("PHYS_ADDR: type= %d, y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
> -       type, paddr->y, paddr->cb, paddr->cr, ret);
> +       dbg("PHYS_ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
> +           paddr->y, paddr->cb, paddr->cr, ret);
>
>        return ret;
>  }
> @@ -410,11 +480,11 @@ static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
>        f->dma_offset.cr_v = f->offs_v;
>
>        if (!variant->pix_hoff) {
> -               if(f->fmt->planes_cnt == 3) {
> +               if (f->fmt->planes_cnt == 3) {
>                        f->dma_offset.cb_h >>= 1;
>                        f->dma_offset.cr_h >>= 1;
>                }
> -               if(f->fmt->color == S5P_FIMC_YCBCR420) {
> +               if (f->fmt->color == S5P_FIMC_YCBCR420) {
>                        f->dma_offset.cb_v >>= 1;
>                        f->dma_offset.cr_v >>= 1;
>                }
> @@ -433,7 +503,7 @@ static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
>  *
>  * Return: 0 if dimensions are valid or non zero otherwise.
>  */
> -static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
> +int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
>  {
>        struct fimc_frame *s_frame, *d_frame;
>        struct fimc_vid_buffer *buf = NULL;
> @@ -466,16 +536,14 @@ static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
>
>        if (flags & FIMC_SRC_ADDR) {
>                buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> -               ret = fimc_prepare_addr(ctx, buf,
> -                       V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +               ret = fimc_prepare_addr(ctx, buf, s_frame, &s_frame->paddr);
>                if (ret)
>                        return ret;
>        }
>
>        if (flags & FIMC_DST_ADDR) {
>                buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> -               ret = fimc_prepare_addr(ctx, buf,
> -                       V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +               ret = fimc_prepare_addr(ctx, buf, d_frame, &d_frame->paddr);
>        }
>
>        return ret;
> @@ -502,9 +570,11 @@ static void fimc_dma_run(void *priv)
>                err("general configuration error");
>                goto dma_unlock;
>        }
> -
> -       if (fimc->m2m.ctx != ctx)
> +       /* Reconfigure hardware if the context has changed. */
> +       if (fimc->m2m.ctx != ctx) {
>                ctx->state |= FIMC_PARAMS;
> +               fimc->m2m.ctx = ctx;
> +       }
>
>        fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
>
> @@ -515,7 +585,6 @@ static void fimc_dma_run(void *priv)
>                        err("scaler configuration error");
>                        goto dma_unlock;
>                }
> -               fimc_hw_set_prescaler(ctx);
>                fimc_hw_set_scaler(ctx);
>                fimc_hw_set_target_format(ctx);
>                fimc_hw_set_rotation(ctx);
> @@ -524,19 +593,15 @@ static void fimc_dma_run(void *priv)
>
>        fimc_hw_set_output_path(ctx);
>        if (ctx->state & (FIMC_DST_ADDR | FIMC_PARAMS))
> -               fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr);
> +               fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr, -1);
>
>        if (ctx->state & FIMC_PARAMS)
>                fimc_hw_set_out_dma(ctx);
>
> -       if (ctx->scaler.enabled)
> -               fimc_hw_start_scaler(fimc);
> -       fimc_hw_en_capture(ctx);
> -
> -       ctx->state = 0;
> -       fimc_hw_start_in_dma(fimc);
> +       fimc_activate_capture(ctx);
>
> -       fimc->m2m.ctx = ctx;
> +       ctx->state &= FIMC_CTX_M2M;
> +       fimc_hw_activate_input_dma(fimc, true);
>
>  dma_unlock:
>        spin_unlock_irqrestore(&ctx->slock, flags);
> @@ -560,7 +625,7 @@ static int fimc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
>        struct fimc_ctx *ctx = vq->priv_data;
>        struct fimc_frame *frame;
>
> -       frame = ctx_m2m_get_frame(ctx, vq->type);
> +       frame = ctx_get_frame(ctx, vq->type);
>        if (IS_ERR(frame))
>                return PTR_ERR(frame);
>
> @@ -578,7 +643,7 @@ static int fimc_buf_prepare(struct videobuf_queue *vq,
>        struct fimc_frame *frame;
>        int ret;
>
> -       frame = ctx_m2m_get_frame(ctx, vq->type);
> +       frame = ctx_get_frame(ctx, vq->type);
>        if (IS_ERR(frame))
>                return PTR_ERR(frame);
>
> @@ -618,10 +683,30 @@ static void fimc_buf_queue(struct videobuf_queue *vq,
>                                  struct videobuf_buffer *vb)
>  {
>        struct fimc_ctx *ctx = vq->priv_data;
> -       v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
> +       struct fimc_dev *fimc = ctx->fimc_dev;
> +       struct fimc_vid_cap *cap = &fimc->vid_cap;
> +       unsigned long flags;
> +
> +       dbg("ctx= %p, ctx->state= 0x%x", ctx, ctx->state);
> +
> +       if ((ctx->state & FIMC_CTX_M2M) && ctx->m2m_ctx) {
> +               v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
> +       } else if (ctx->state & FIMC_CTX_CAP) {
> +               spin_lock_irqsave(&fimc->slock, flags);
> +               fimc_vid_cap_buf_queue(fimc, (struct fimc_vid_buffer *)vb);
> +               dbg("fimc->cap.active_buf_cnt: %d",
> +                   fimc->vid_cap.active_buf_cnt);
> +
> +               if (cap->active_buf_cnt >= cap->reqbufs_count ||
> +                  cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
> +                       if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
> +                               fimc_activate_capture(ctx);
> +               }
> +               spin_unlock_irqrestore(&fimc->slock, flags);
> +       }
>  }
>
> -static struct videobuf_queue_ops fimc_qops = {
> +struct videobuf_queue_ops fimc_qops = {
>        .buf_setup      = fimc_buf_setup,
>        .buf_prepare    = fimc_buf_prepare,
>        .buf_queue      = fimc_buf_queue,
> @@ -644,7 +729,7 @@ static int fimc_m2m_querycap(struct file *file, void *priv,
>        return 0;
>  }
>
> -static int fimc_m2m_enum_fmt(struct file *file, void *priv,
> +int fimc_m2m_enum_fmt(struct file *file, void *priv,
>                                struct v4l2_fmtdesc *f)
>  {
>        struct fimc_fmt *fmt;
> @@ -663,7 +748,7 @@ static int fimc_m2m_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>        struct fimc_ctx *ctx = priv;
>        struct fimc_frame *frame;
>
> -       frame = ctx_m2m_get_frame(ctx, f->type);
> +       frame = ctx_get_frame(ctx, f->type);
>        if (IS_ERR(frame))
>                return PTR_ERR(frame);
>
> @@ -675,20 +760,34 @@ static int fimc_m2m_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>        return 0;
>  }
>
> -static struct fimc_fmt *find_format(struct v4l2_format *f)
> +struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask)
> +{
> +       struct fimc_fmt *fmt;
> +       unsigned int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
> +               fmt = &fimc_formats[i];
> +               if (fmt->fourcc == f->fmt.pix.pixelformat &&
> +                  (fmt->flags & mask))
> +                       break;
> +       }
> +
> +       return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
> +}
> +
> +struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
> +                                 unsigned int mask)
>  {
>        struct fimc_fmt *fmt;
>        unsigned int i;
>
>        for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
>                fmt = &fimc_formats[i];
> -               if (fmt->fourcc == f->fmt.pix.pixelformat)
> +               if (fmt->mbus_code == f->code && (fmt->flags & mask))
>                        break;
>        }
> -       if (i == ARRAY_SIZE(fimc_formats))
> -               return NULL;
>
> -       return fmt;
> +       return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
>  }
>
>  static int fimc_m2m_try_fmt(struct file *file, void *priv,
> @@ -701,7 +800,7 @@ static int fimc_m2m_try_fmt(struct file *file, void *priv,
>        struct v4l2_pix_format *pix = &f->fmt.pix;
>        struct samsung_fimc_variant *variant = fimc->variant;
>
> -       fmt = find_format(f);
> +       fmt = find_format(f, FMT_FLAGS_M2M);
>        if (!fmt) {
>                v4l2_err(&fimc->m2m.v4l2_dev,
>                         "Fourcc format (0x%X) invalid.\n",  pix->pixelformat);
> @@ -746,7 +845,7 @@ static int fimc_m2m_try_fmt(struct file *file, void *priv,
>        pix->height = (pix->height == 0) ? mod_y : ALIGN(pix->height, mod_y);
>
>        if (pix->bytesperline == 0 ||
> -           pix->bytesperline * 8 / fmt->depth > pix->width)
> +           (pix->bytesperline * 8 / fmt->depth) > pix->width)
>                pix->bytesperline = (pix->width * fmt->depth) >> 3;
>
>        if (pix->sizeimage == 0)
> @@ -807,18 +906,19 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
>        } else {
>                v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
>                         "Wrong buffer/video queue type (%d)\n", f->type);
> -               return -EINVAL;
> +               ret = -EINVAL;
> +               goto s_fmt_out;
>        }
>
>        pix = &f->fmt.pix;
> -       frame->fmt = find_format(f);
> +       frame->fmt = find_format(f, FMT_FLAGS_M2M);
>        if (!frame->fmt) {
>                ret = -EINVAL;
>                goto s_fmt_out;
>        }
>
>        frame->f_width = pix->bytesperline * 8 / frame->fmt->depth;
> -       frame->f_height = pix->sizeimage/pix->bytesperline;
> +       frame->f_height = pix->height;
>        frame->width = pix->width;
>        frame->height = pix->height;
>        frame->o_width = pix->width;
> @@ -917,8 +1017,7 @@ int fimc_m2m_g_ctrl(struct file *file, void *priv,
>        return 0;
>  }
>
> -static int check_ctrl_val(struct fimc_ctx *ctx,
> -                         struct v4l2_control *ctrl)
> +int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl)
>  {
>        struct v4l2_queryctrl *c;
>        c = get_ctrl(ctrl->id);
> @@ -935,18 +1034,9 @@ static int check_ctrl_val(struct fimc_ctx *ctx,
>        return 0;
>  }
>
> -int fimc_m2m_s_ctrl(struct file *file, void *priv,
> -                        struct v4l2_control *ctrl)
> +int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
>  {
> -       struct fimc_ctx *ctx = priv;
>        struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
> -       unsigned long flags;
> -       int ret = 0;
> -
> -       ret = check_ctrl_val(ctx, ctrl);
> -       if (ret)
> -               return ret;
> -
>        switch (ctrl->id) {
>        case V4L2_CID_HFLIP:
>                if (ctx->rotation != 0)
> @@ -985,20 +1075,37 @@ int fimc_m2m_s_ctrl(struct file *file, void *priv,
>                v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev, "Invalid control\n");
>                return -EINVAL;
>        }
> +       return 0;
> +}
> +
> +static int fimc_m2m_s_ctrl(struct file *file, void *priv,
> +                        struct v4l2_control *ctrl)
> +{
> +       struct fimc_ctx *ctx = priv;
> +       unsigned long flags;
> +       int ret = 0;
> +
> +       ret = check_ctrl_val(ctx, ctrl);
> +       if (ret)
> +               return ret;
> +
>        spin_lock_irqsave(&ctx->slock, flags);
> +       ret = fimc_s_ctrl(ctx, ctrl);
>        ctx->state |= FIMC_PARAMS;
>        spin_unlock_irqrestore(&ctx->slock, flags);
>        return 0;
>  }
>
> -
>  static int fimc_m2m_cropcap(struct file *file, void *fh,
>                             struct v4l2_cropcap *cr)
>  {
>        struct fimc_frame *frame;
>        struct fimc_ctx *ctx = fh;
>
> -       frame = ctx_m2m_get_frame(ctx, cr->type);
> +       if (WARN(!ctx, "null hardware context"))
> +               return -ENOENT;
> +
> +       frame = ctx_get_frame(ctx, cr->type);
>        if (IS_ERR(frame))
>                return PTR_ERR(frame);
>
> @@ -1018,7 +1125,7 @@ static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
>        struct fimc_frame *frame;
>        struct fimc_ctx *ctx = file->private_data;
>
> -       frame = ctx_m2m_get_frame(ctx, cr->type);
> +       frame = ctx_get_frame(ctx, cr->type);
>        if (IS_ERR(frame))
>                return PTR_ERR(frame);
>
> @@ -1051,7 +1158,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
>                return -EINVAL;
>        }
>
> -       f = ctx_m2m_get_frame(ctx, cr->type);
> +       f = ctx_get_frame(ctx, cr->type);
>        if (IS_ERR(f))
>                return PTR_ERR(f);
>
> @@ -1085,12 +1192,13 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
>                }
>        }
>        ctx->state |= FIMC_PARAMS;
> -       spin_unlock_irqrestore(&ctx->slock, flags);
>
>        f->offs_h = cr->c.left;
>        f->offs_v = cr->c.top;
>        f->width = cr->c.width;
>        f->height = cr->c.height;
> +
> +       spin_unlock_irqrestore(&ctx->slock, flags);
>        return 0;
>  }
>
> @@ -1135,7 +1243,7 @@ static void queue_init(void *priv, struct videobuf_queue *vq,
>        struct fimc_dev *fimc = ctx->fimc_dev;
>
>        videobuf_queue_dma_contig_init(vq, &fimc_qops,
> -               fimc->m2m.v4l2_dev.dev,
> +               &fimc->pdev->dev,
>                &fimc->irqlock, type, V4L2_FIELD_NONE,
>                sizeof(struct fimc_vid_buffer), priv);
>  }
> @@ -1151,7 +1259,6 @@ static int fimc_m2m_open(struct file *file)
>        set_bit(ST_OUTDMA_RUN, &fimc->state);
>        mutex_unlock(&fimc->lock);
>
> -
>        ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
>        if (!ctx)
>                return -ENOMEM;
> @@ -1162,7 +1269,7 @@ static int fimc_m2m_open(struct file *file)
>        ctx->s_frame.fmt = &fimc_formats[0];
>        ctx->d_frame.fmt = &fimc_formats[0];
>        /* per user process device context initialization */
> -       ctx->state = 0;
> +       ctx->state = FIMC_CTX_M2M;
>        ctx->flags = 0;
>        ctx->effect.type = S5P_FIMC_EFFECT_ORIGINAL;
>        ctx->in_path = FIMC_DMA;
> @@ -1182,6 +1289,9 @@ static int fimc_m2m_release(struct file *file)
>        struct fimc_ctx *ctx = file->private_data;
>        struct fimc_dev *fimc = ctx->fimc_dev;
>
> +       dbg("pid: %d, state: 0x%lx, refcnt= %d",
> +               task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
> +
>        v4l2_m2m_ctx_release(ctx->m2m_ctx);
>        kfree(ctx);
>        mutex_lock(&fimc->lock);
> @@ -1240,7 +1350,7 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
>
>        ret = v4l2_device_register(&pdev->dev, v4l2_dev);
>        if (ret)
> -               return ret;;
> +               goto err_m2m_r1;
>
>        vfd = video_device_alloc();
>        if (!vfd) {
> @@ -1292,7 +1402,7 @@ static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
>        if (fimc) {
>                v4l2_m2m_release(fimc->m2m.m2m_dev);
>                video_unregister_device(fimc->m2m.vfd);
> -               video_device_release(fimc->m2m.vfd);
> +
>                v4l2_device_unregister(&fimc->m2m.v4l2_dev);
>        }
>  }
> @@ -1349,9 +1459,11 @@ static int fimc_probe(struct platform_device *pdev)
>        fimc->id = pdev->id;
>        fimc->variant = drv_data->variant[fimc->id];
>        fimc->pdev = pdev;
> +       fimc->pdata = pdev->dev.platform_data;
>        fimc->state = ST_IDLE;
>
>        spin_lock_init(&fimc->irqlock);
> +       init_waitqueue_head(&fimc->irq_queue);
>        spin_lock_init(&fimc->slock);
>
>        mutex_init(&fimc->lock);
> @@ -1381,6 +1493,7 @@ static int fimc_probe(struct platform_device *pdev)
>        ret = fimc_clk_get(fimc);
>        if (ret)
>                goto err_regs_unmap;
> +       clk_set_rate(fimc->clock[0], drv_data->lclk_frequency);
>
>        res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>        if (!res) {
> @@ -1398,25 +1511,31 @@ static int fimc_probe(struct platform_device *pdev)
>                goto err_clk;
>        }
>
> -       fimc->work_queue = create_workqueue(dev_name(&fimc->pdev->dev));
> -       if (!fimc->work_queue) {
> -               ret = -ENOMEM;
> -               goto err_irq;
> -       }
> -
>        ret = fimc_register_m2m_device(fimc);
>        if (ret)
> -               goto err_wq;
> +               goto err_irq;
>
> -       fimc_hw_en_lastirq(fimc, true);
> +       /* At least one camera sensor is required to register capture node */
> +       if (fimc->pdata) {
> +               int i;
> +               for (i = 0; i < FIMC_MAX_CAM_SOURCES; ++i)
> +                       if (fimc->pdata->isp_info[i])
> +                               break;
> +
> +               if (i < FIMC_MAX_CAM_SOURCES) {
> +                       ret = fimc_register_capture_device(fimc);
> +                       if (ret)
> +                               goto err_m2m;
> +               }
> +       }
>
>        dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
>                __func__, fimc->id);
>
>        return 0;
>
> -err_wq:
> -       destroy_workqueue(fimc->work_queue);
> +err_m2m:
> +       fimc_unregister_m2m_device(fimc);
>  err_irq:
>        free_irq(fimc->irq, fimc);
>  err_clk:
> @@ -1428,7 +1547,7 @@ err_req_region:
>        kfree(fimc->regs_res);
>  err_info:
>        kfree(fimc);
> -       dev_err(&pdev->dev, "failed to install\n");
> +
>        return ret;
>  }
>
> @@ -1437,18 +1556,20 @@ static int __devexit fimc_remove(struct platform_device *pdev)
>        struct fimc_dev *fimc =
>                (struct fimc_dev *)platform_get_drvdata(pdev);
>
> -       v4l2_info(&fimc->m2m.v4l2_dev, "Removing %s\n", pdev->name);
> -
>        free_irq(fimc->irq, fimc);
>
>        fimc_hw_reset(fimc);
>
>        fimc_unregister_m2m_device(fimc);
> +       fimc_unregister_capture_device(fimc);
>        fimc_clk_release(fimc);
>        iounmap(fimc->regs);
>        release_resource(fimc->regs_res);
>        kfree(fimc->regs_res);
>        kfree(fimc);
> +
> +       dev_info(&pdev->dev, "%s driver unloaded\n", pdev->name);
> +
>        return 0;
>  }
>
> @@ -1512,7 +1633,8 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5p = {
>                [1] = &fimc01_variant_s5p,
>                [2] = &fimc2_variant_s5p,
>        },
> -       .devs_cnt = 3
> +       .devs_cnt       = 3,
> +       .lclk_frequency = 133000000UL,
>  };
>
>  static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
> @@ -1521,7 +1643,8 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
>                [1] = &fimc01_variant_s5pv210,
>                [2] = &fimc2_variant_s5pv210,
>        },
> -       .devs_cnt = 3
> +       .devs_cnt       = 3,
> +       .lclk_frequency = 133000000UL,
>  };
>
>  static struct platform_device_id fimc_driver_ids[] = {
> @@ -1546,15 +1669,9 @@ static struct platform_driver fimc_driver = {
>        }
>  };
>
> -static char banner[] __initdata = KERN_INFO
> -       "S5PC Camera Interface V4L2 Driver, (c) 2010 Samsung Electronics\n";
> -
>  static int __init fimc_init(void)
>  {
> -       u32 ret;
> -       printk(banner);
> -
> -       ret = platform_driver_register(&fimc_driver);
> +       u32 ret = platform_driver_register(&fimc_driver);
>        if (ret) {
>                printk(KERN_ERR "FIMC platform driver register failed\n");
>                return -1;
> @@ -1571,5 +1688,5 @@ module_init(fimc_init);
>  module_exit(fimc_exit);
>
>  MODULE_AUTHOR("Sylwester Nawrocki, s.nawrocki@samsung.com");
> -MODULE_DESCRIPTION("S3C/S5P FIMC (video postprocessor) driver");
> +MODULE_DESCRIPTION("S5P SoC Camera Host Interface driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
> index 6b3e0cd..be911b6 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -11,10 +11,15 @@
>  #ifndef FIMC_CORE_H_
>  #define FIMC_CORE_H_
>
> +/*#define DEBUG*/
> +
>  #include <linux/types.h>
> +#include <plat/fimc.h>
>  #include <media/videobuf-core.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-mediabus.h>
> +#include <media/s3c_fimc.h>
>  #include <linux/videodev2.h>
>  #include "regs-fimc.h"
>
> @@ -23,31 +28,66 @@
>
>  #ifdef DEBUG
>  #define dbg(fmt, args...) \
> -       printk(KERN_DEBUG "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
> +       printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
> +
> +#define assert(cond) do {      \
> +       if (!(cond)) {          \
> +               printk(KERN_CRIT "BUG at %s:%d assert(%s)\n",   \
> +                      __FILE__, __LINE__, #cond);              \
> +               BUG();  \
> +       }               \
> +} while (0)
>  #else
>  #define dbg(fmt, args...)
> +#define assert(cond)
>  #endif
>
> +
> +/* Time to wait for next frame VSYNC interrupt while stoping operation. */
> +#define FIMC_SHUTDOWN_TIMEOUT  ((100*HZ)/1000)
>  #define NUM_FIMC_CLOCKS                2
>  #define MODULE_NAME            "s5p-fimc"
>  #define FIMC_MAX_DEVS          3
>  #define FIMC_MAX_OUT_BUFS      4
>  #define SCALER_MAX_HRATIO      64
>  #define SCALER_MAX_VRATIO      64
> +#define DMA_MIN_SIZE           16
>
> -enum {
> +/* FIMC device state flags */
> +enum fimc_dev_flags {
> +       /* for m2m node */
>        ST_IDLE,
>        ST_OUTDMA_RUN,
>        ST_M2M_PEND,
> +       /* for capture node */
> +       ST_CAPT_PEND,
> +       ST_CAPT_RUN,
> +       ST_CAPT_STREAM,
> +       ST_CAPT_SHUT,
>  };
>
>  #define fimc_m2m_active(dev) test_bit(ST_OUTDMA_RUN, &(dev)->state)
>  #define fimc_m2m_pending(dev) test_bit(ST_M2M_PEND, &(dev)->state)
>
> +#define fimc_capture_running(dev) test_bit(ST_CAPT_RUN, &(dev)->state)
> +#define fimc_capture_pending(dev) test_bit(ST_CAPT_PEND, &(dev)->state)
> +
> +#define fimc_capture_active(dev) \
> +       (test_bit(ST_CAPT_RUN, &(dev)->state) || \
> +        test_bit(ST_CAPT_PEND, &(dev)->state))
> +
> +#define fimc_capture_streaming(dev) \
> +       test_bit(ST_CAPT_STREAM, &(dev)->state)
> +
> +#define fimc_buf_finish(dev, vid_buf) do { \
> +       spin_lock(&(dev)->irqlock); \
> +       (vid_buf)->vb.state = VIDEOBUF_DONE; \
> +       spin_unlock(&(dev)->irqlock); \
> +       wake_up(&(vid_buf)->vb.done); \
> +} while (0)
> +
>  enum fimc_datapath {
> -       FIMC_ITU_CAM_A,
> -       FIMC_ITU_CAM_B,
> -       FIMC_MIPI_CAM,
> +       FIMC_CAMERA,
>        FIMC_DMA,
>        FIMC_LCDFIFO,
>        FIMC_WRITEBACK
> @@ -93,11 +133,13 @@ enum fimc_color_fmt {
>  #define        S5P_FIMC_EFFECT_SIKHOUETTE      S5P_CIIMGEFF_FIN_SILHOUETTE
>
>  /* The hardware context state. */
> -#define        FIMC_PARAMS                     (1 << 0)
> -#define        FIMC_SRC_ADDR                   (1 << 1)
> -#define        FIMC_DST_ADDR                   (1 << 2)
> -#define        FIMC_SRC_FMT                    (1 << 3)
> -#define        FIMC_DST_FMT                    (1 << 4)
> +#define        FIMC_PARAMS             (1 << 0)
> +#define        FIMC_SRC_ADDR           (1 << 1)
> +#define        FIMC_DST_ADDR           (1 << 2)
> +#define        FIMC_SRC_FMT            (1 << 3)
> +#define        FIMC_DST_FMT            (1 << 4)
> +#define        FIMC_CTX_M2M            (1 << 5)
> +#define        FIMC_CTX_CAP            (1 << 6)
>
>  /* Image conversion flags */
>  #define        FIMC_IN_DMA_ACCESS_TILED        (1 << 0)
> @@ -118,20 +160,25 @@ enum fimc_color_fmt {
>
>  /**
>  * struct fimc_fmt - the driver's internal color format data
> + * @mbus_code: Media Bus pixel code, -1 if not applicable
>  * @name: format description
> - * @fourcc: the fourcc code for this format
> + * @fourcc: the fourcc code for this format, 0 if not applicable
>  * @color: the corresponding fimc_color_fmt
> - * @depth: number of bits per pixel
> + * @depth: driver's private 'number of bits per pixel'
>  * @buff_cnt: number of physically non-contiguous data planes
>  * @planes_cnt: number of physically contiguous data planes
>  */
>  struct fimc_fmt {
> +       enum v4l2_mbus_pixelcode mbus_code;
>        char    *name;
>        u32     fourcc;
>        u32     color;
> -       u32     depth;
>        u16     buff_cnt;
>        u16     planes_cnt;
> +       u16     depth;
> +       u16     flags;
> +#define FMT_FLAGS_CAM  (1 << 0)
> +#define FMT_FLAGS_M2M  (1 << 1)
>  };
>
>  /**
> @@ -184,7 +231,6 @@ struct fimc_effect {
>  *                     and color format conversion
>  */
>  struct fimc_scaler {
> -       u32     enabled;
>        u32     hfactor;
>        u32     vfactor;
>        u32     pre_hratio;
> @@ -197,7 +243,8 @@ struct fimc_scaler {
>        u32     main_vratio;
>        u32     real_width;
>        u32     real_height;
> -       u32     copy_mode;
> +       u16     copy_mode;
> +       u16     enabled;
>  };
>
>  /**
> @@ -215,15 +262,17 @@ struct fimc_addr {
>
>  /**
>  * struct fimc_vid_buffer - the driver's video buffer
> + *
>  * @vb:        v4l videobuf buffer
>  */
>  struct fimc_vid_buffer {
>        struct videobuf_buffer  vb;
> +       struct fimc_addr        paddr;
> +       int                     index;
>  };
>
>  /**
> - * struct fimc_frame - input/output frame format properties
> - *
> + * struct fimc_frame - source/target frame properties
>  * @f_width:   image full width (virtual screen size)
>  * @f_height:  image full height (virtual screen size)
>  * @o_width:   original image width as set by S_FMT
> @@ -270,6 +319,40 @@ struct fimc_m2m_device {
>  };
>
>  /**
> + * struct fimc_vid_cap - camera capture device information
> + * @ctx: hardware context data
> + * @vfd: video device node for camera capture mode
> + * @v4l2_dev: v4l2_device struct to manage subdevs
> + * @sd: pointer to camera sensor subdevice currently in use
> + * @fmt: Media Bus format configured at selected image sensor
> + * @pending_buf_q: the pending buffer queue head
> + * @active_buf_q: the queue head of buffers scheduled in hardware
> + * @vbq: the capture am video buffer queue
> + * @active_buf_cnt: number of video buffers scheduled in hardware
> + * @buf_index: index for managing the output DMA buffers
> + * @frame_count: the frame counter for statistics
> + * @reqbufs_count: the number of buffers requested in REQBUFS ioctl
> + * @input_index: input (camera sensor) index
> + * @refcnt: driver's private reference counter
> + */
> +struct fimc_vid_cap {
> +       struct fimc_ctx                 *ctx;
> +       struct video_device             *vfd;
> +       struct v4l2_device              v4l2_dev;
> +       struct v4l2_subdev              *sd;
> +       struct v4l2_mbus_framefmt       fmt;
> +       struct list_head                pending_buf_q;
> +       struct list_head                active_buf_q;
> +       struct videobuf_queue           vbq;
> +       int                             active_buf_cnt;
> +       int                             buf_index;
> +       unsigned int                    frame_count;
> +       unsigned int                    reqbufs_count;
> +       int                             input_index;
> +       int                             refcnt;
> +};
> +
> +/**
>  * struct samsung_fimc_variant - camera interface variant information
>  *
>  * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
> @@ -279,10 +362,10 @@ struct fimc_m2m_device {
>  * @min_out_pixsize: minimum output pixel size
>  * @scaler_en_w: maximum input pixel width when the scaler is enabled
>  * @scaler_dis_w: maximum input pixel width when the scaler is disabled
> - * @in_rot_en_h: maximum input width when the input rotator is used
> - * @in_rot_dis_w: maximum input width when the input rotator is used
> - * @out_rot_en_w: maximum output width for the output rotator enabled
> - * @out_rot_dis_w: maximum output width for the output rotator enabled
> + * @in_rot_en_h: maximum input width when the input rotator is enabled
> + * @in_rot_dis_w: maximum input width when the input rotator is disabled
> + * @out_rot_en_w: maximum target width when the output rotator enabled
> + * @out_rot_dis_w: maximum target width when the output rotator disnabled
>  */
>  struct samsung_fimc_variant {
>        unsigned int    pix_hoff:1;
> @@ -300,37 +383,43 @@ struct samsung_fimc_variant {
>  };
>
>  /**
> - * struct samsung_fimc_driverdata - per-device type driver data for init time.
> + * struct samsung_fimc_driverdata - per device type driver data for init time.
>  *
>  * @variant: the variant information for this driver.
>  * @dev_cnt: number of fimc sub-devices available in SoC
> + * @lclk_frequency: fimc bus clock frequency
>  */
>  struct samsung_fimc_driverdata {
>        struct samsung_fimc_variant *variant[FIMC_MAX_DEVS];
> -       int     devs_cnt;
> +       unsigned long   lclk_frequency;
> +       int             devs_cnt;
>  };
>
>  struct fimc_ctx;
>
>  /**
> - * struct fimc_subdev - abstraction for a FIMC entity
> + * struct fimc_dev - abstraction for FIMC entity
>  *
>  * @slock:     the spinlock protecting this data structure
>  * @lock:      the mutex protecting this data structure
>  * @pdev:      pointer to the FIMC platform device
> + * @pdata:     pointer to the device platform data
>  * @id:                FIMC device index (0..2)
>  * @clock[]:   the clocks required for FIMC operation
>  * @regs:      the mapped hardware registers
>  * @regs_res:  the resource claimed for IO registers
>  * @irq:       interrupt number of the FIMC subdevice
> - * @irqlock:   spinlock protecting videbuffer queue
> + * @irqlock:   spinlock protecting videobuffer queue
> + * @irq_queue:
>  * @m2m:       memory-to-memory V4L2 device information
> + * @cap:       camera capture device information
>  * @state:     the FIMC device state flags
>  */
>  struct fimc_dev {
>        spinlock_t                      slock;
>        struct mutex                    lock;
>        struct platform_device          *pdev;
> +       struct s3c_platform_fimc        *pdata;
>        struct samsung_fimc_variant     *variant;
>        int                             id;
>        struct clk                      *clock[NUM_FIMC_CLOCKS];
> @@ -338,8 +427,9 @@ struct fimc_dev {
>        struct resource                 *regs_res;
>        int                             irq;
>        spinlock_t                      irqlock;
> -       struct workqueue_struct         *work_queue;
> +       wait_queue_head_t               irq_queue;
>        struct fimc_m2m_device          m2m;
> +       struct fimc_vid_cap             vid_cap;
>        unsigned long                   state;
>  };
>
> @@ -359,7 +449,7 @@ struct fimc_dev {
>  * @effect:            image effect
>  * @rotation:          image clockwise rotation in degrees
>  * @flip:              image flip mode
> - * @flags:             an additional flags for image conversion
> + * @flags:             additional flags for image conversion
>  * @state:             flags to keep track of user configuration
>  * @fimc_dev:          the FIMC device this context applies to
>  * @m2m_ctx:           memory-to-memory device context
> @@ -384,6 +474,7 @@ struct fimc_ctx {
>        struct v4l2_m2m_ctx     *m2m_ctx;
>  };
>
> +extern struct videobuf_queue_ops fimc_qops;
>
>  static inline int tiled_fmt(struct fimc_fmt *fmt)
>  {
> @@ -397,18 +488,24 @@ static inline void fimc_hw_clear_irq(struct fimc_dev *dev)
>        writel(cfg, dev->regs + S5P_CIGCTRL);
>  }
>
> -static inline void fimc_hw_start_scaler(struct fimc_dev *dev)
> +static inline void fimc_hw_enable_scaler(struct fimc_dev *dev, bool on)
>  {
>        u32 cfg = readl(dev->regs + S5P_CISCCTRL);
> -       cfg |= S5P_CISCCTRL_SCALERSTART;
> +       if (on)
> +               cfg |= S5P_CISCCTRL_SCALERSTART;
> +       else
> +               cfg &= ~S5P_CISCCTRL_SCALERSTART;
>        writel(cfg, dev->regs + S5P_CISCCTRL);
>  }
>
> -static inline void fimc_hw_stop_scaler(struct fimc_dev *dev)
> +static inline void fimc_hw_activate_input_dma(struct fimc_dev *dev, bool on)
>  {
> -       u32 cfg = readl(dev->regs + S5P_CISCCTRL);
> -       cfg &= ~S5P_CISCCTRL_SCALERSTART;
> -       writel(cfg, dev->regs + S5P_CISCCTRL);
> +       u32 cfg = readl(dev->regs + S5P_MSCTRL);
> +       if (on)
> +               cfg |= S5P_MSCTRL_ENVID;
> +       else
> +               cfg &= ~S5P_MSCTRL_ENVID;
> +       writel(cfg, dev->regs + S5P_MSCTRL);
>  }
>
>  static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
> @@ -418,21 +515,7 @@ static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
>        writel(cfg, dev->regs + S5P_CIIMGCPT);
>  }
>
> -static inline void fimc_hw_start_in_dma(struct fimc_dev *dev)
> -{
> -       u32 cfg = readl(dev->regs + S5P_MSCTRL);
> -       cfg |= S5P_MSCTRL_ENVID;
> -       writel(cfg, dev->regs + S5P_MSCTRL);
> -}
> -
> -static inline void fimc_hw_stop_in_dma(struct fimc_dev *dev)
> -{
> -       u32 cfg = readl(dev->regs + S5P_MSCTRL);
> -       cfg &= ~S5P_MSCTRL_ENVID;
> -       writel(cfg, dev->regs + S5P_MSCTRL);
> -}
> -
> -static inline struct fimc_frame *ctx_m2m_get_frame(struct fimc_ctx *ctx,
> +static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
>                                                   enum v4l2_buf_type type)
>  {
>        struct fimc_frame *frame;
> @@ -450,22 +533,126 @@ static inline struct fimc_frame *ctx_m2m_get_frame(struct fimc_ctx *ctx,
>        return frame;
>  }
>
> +static inline u32 fimc_hw_get_frame_index(struct fimc_dev *dev)
> +{
> +       u32 reg = readl(dev->regs + S5P_CISTATUS);
> +       return (reg & S5P_CISTATUS_FRAMECNT_MASK) >>
> +               S5P_CISTATUS_FRAMECNT_SHIFT;
> +}
> +
>  /* -----------------------------------------------------*/
>  /* fimc-reg.c                                          */
> -void fimc_hw_reset(struct fimc_dev *dev);
> +void fimc_hw_reset(struct fimc_dev *fimc);
>  void fimc_hw_set_rotation(struct fimc_ctx *ctx);
>  void fimc_hw_set_target_format(struct fimc_ctx *ctx);
>  void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
> -void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable);
> -void fimc_hw_en_irq(struct fimc_dev *dev, int enable);
> -void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
> +void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
> +void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
>  void fimc_hw_set_scaler(struct fimc_ctx *ctx);
>  void fimc_hw_en_capture(struct fimc_ctx *ctx);
>  void fimc_hw_set_effect(struct fimc_ctx *ctx);
>  void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
>  void fimc_hw_set_input_path(struct fimc_ctx *ctx);
>  void fimc_hw_set_output_path(struct fimc_ctx *ctx);
> -void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr);
> -void fimc_hw_set_output_addr(struct fimc_dev *dev, struct fimc_addr *paddr);
> +void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
> +void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
> +                             int index);
> +void fimc_hw_shadow_dis(struct fimc_dev *ctx, int off);
> +int fimc_hw_set_camera_source(struct fimc_dev *fimc,
> +                             struct s3c_fimc_isp_info *cam);
> +int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
> +int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
> +                               struct s3c_fimc_isp_info *cam);
> +int fimc_hw_set_camera_type(struct fimc_dev *fimc,
> +                           struct s3c_fimc_isp_info *cam);
> +
> +/* -----------------------------------------------------*/
> +/* fimc-core.c */
> +int fimc_set_scaler_info(struct fimc_ctx *ctx);
> +struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
> +struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
> +                                 unsigned int mask);
> +int fimc_m2m_enum_fmt(struct file *file, void *priv,
> +                     struct v4l2_fmtdesc *f);
> +int fimc_m2m_queryctrl(struct file *file, void *priv,
> +                      struct v4l2_queryctrl *qc);
> +int fimc_m2m_g_ctrl(struct file *file, void *priv,
> +                   struct v4l2_control *ctrl);
> +int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl);
> +int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl);
> +int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
> +int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
> +                     struct fimc_frame *frame, struct fimc_addr *paddr);
> +int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
> +
> +/* -----------------------------------------------------*/
> +/* fimc-capture.c                                      */
> +int fimc_register_capture_device(struct fimc_dev *fimc);
> +void fimc_unregister_capture_device(struct fimc_dev *fimc);
> +int fimc_sensor_sd_init(struct fimc_dev *fimc, int index);
> +int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
> +                            struct fimc_vid_buffer *fimc_vb);
> +
> +/* Locking: the caller holds fimc->slock */
> +static inline void fimc_activate_capture(struct fimc_ctx *ctx)
> +{
> +       fimc_hw_enable_scaler(ctx->fimc_dev, ctx->scaler.enabled);
> +       fimc_hw_en_capture(ctx);
> +}
> +
> +static inline void fimc_deactivate_capture(struct fimc_dev *fimc)
> +{
> +       fimc_hw_en_lastirq(fimc, true);
> +       fimc_hw_dis_capture(fimc);
> +       fimc_hw_enable_scaler(fimc, false);
> +       fimc_hw_en_lastirq(fimc, false);
> +}
> +
> +/*
> + * Add video buffer to the active buffers queue.
> + * The caller holds irqlock spinlock.
> + */
> +static inline void active_queue_add(struct fimc_vid_cap *vid_cap,
> +                                        struct fimc_vid_buffer *buf)
> +{
> +       buf->vb.state = VIDEOBUF_ACTIVE;
> +       list_add_tail(&buf->vb.queue, &vid_cap->active_buf_q);
> +       vid_cap->active_buf_cnt++;
> +}
> +
> +/*
> + * Pop a video buffer from the capture active buffers queue
> + * Locking: Need to be called with dev->slock held.
> + */
> +static inline struct fimc_vid_buffer *
> +active_queue_pop(struct fimc_vid_cap *vid_cap)
> +{
> +       struct fimc_vid_buffer *buf;
> +       buf = list_entry(vid_cap->active_buf_q.next,
> +                        struct fimc_vid_buffer, vb.queue);
> +       list_del(&buf->vb.queue);
> +       vid_cap->active_buf_cnt--;
> +       return buf;
> +}
> +
> +/* Add video buffer to the capture pending buffers queue */
> +static inline void fimc_pending_queue_add(struct fimc_vid_cap *vid_cap,
> +                                         struct fimc_vid_buffer *buf)
> +{
> +       buf->vb.state = VIDEOBUF_QUEUED;
> +       list_add_tail(&buf->vb.queue, &vid_cap->pending_buf_q);
> +}
> +
> +/* Add video buffer to the capture pending buffers queue */
> +static inline struct fimc_vid_buffer *
> +pending_queue_pop(struct fimc_vid_cap *vid_cap)
> +{
> +       struct fimc_vid_buffer *buf;
> +       buf = list_entry(vid_cap->pending_buf_q.next,
> +                       struct fimc_vid_buffer, vb.queue);
> +       list_del(&buf->vb.queue);
> +       return buf;
> +}
> +
>
>  #endif /* FIMC_CORE_H_ */
> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
> index 70f29c5..fc58cdd 100644
> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
> @@ -13,6 +13,7 @@
>  #include <linux/io.h>
>  #include <linux/delay.h>
>  #include <mach/map.h>
> +#include <media/s3c_fimc.h>
>
>  #include "fimc-core.h"
>
> @@ -29,7 +30,7 @@ void fimc_hw_reset(struct fimc_dev *dev)
>        cfg = readl(dev->regs + S5P_CIGCTRL);
>        cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
>        writel(cfg, dev->regs + S5P_CIGCTRL);
> -       msleep(1);
> +       usleep_range(1000, 5000);
>
>        cfg = readl(dev->regs + S5P_CIGCTRL);
>        cfg &= ~S5P_CIGCTRL_SWRST;
> @@ -43,7 +44,8 @@ void fimc_hw_set_rotation(struct fimc_ctx *ctx)
>        struct fimc_dev *dev = ctx->fimc_dev;
>
>        cfg = readl(dev->regs + S5P_CITRGFMT);
> -       cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90);
> +       cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90 |
> +                 S5P_CITRGFMT_FLIP_180);
>
>        flip = readl(dev->regs + S5P_MSCTRL);
>        flip &= ~S5P_MSCTRL_FLIP_MASK;
> @@ -177,6 +179,15 @@ static void fimc_hw_set_out_dma_size(struct fimc_ctx *ctx)
>                cfg |= S5P_ORIG_SIZE_VER(frame->f_height);
>        }
>        writel(cfg, dev->regs + S5P_ORGOSIZE);
> +
> +       /* Select color space conversion equation (HD/SD size).*/
> +       cfg = readl(dev->regs + S5P_CIGCTRL);
> +       if (frame->f_width >= 1280) /* HD */
> +               cfg |= S5P_CIGCTRL_CSC_ITU601_709;
> +       else    /* SD */
> +               cfg &= ~S5P_CIGCTRL_CSC_ITU601_709;
> +       writel(cfg, dev->regs + S5P_CIGCTRL);
> +
>  }
>
>  void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
> @@ -232,22 +243,15 @@ static void fimc_hw_en_autoload(struct fimc_dev *dev, int enable)
>
>  void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
>  {
> -       unsigned long flags;
> -       u32 cfg;
> -
> -       spin_lock_irqsave(&dev->slock, flags);
> -
> -       cfg = readl(dev->regs + S5P_CIOCTRL);
> +       u32 cfg = readl(dev->regs + S5P_CIOCTRL);
>        if (enable)
>                cfg |= S5P_CIOCTRL_LASTIRQ_ENABLE;
>        else
>                cfg &= ~S5P_CIOCTRL_LASTIRQ_ENABLE;
>        writel(cfg, dev->regs + S5P_CIOCTRL);
> -
> -       spin_unlock_irqrestore(&dev->slock, flags);
>  }
>
> -void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
> +static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
>  {
>        struct fimc_dev *dev =  ctx->fimc_dev;
>        struct fimc_scaler *sc = &ctx->scaler;
> @@ -274,6 +278,8 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
>        struct fimc_frame *dst_frame = &ctx->d_frame;
>        u32 cfg = 0;
>
> +       fimc_hw_set_prescaler(ctx);
> +
>        if (!(ctx->flags & FIMC_COLOR_RANGE_NARROW))
>                cfg |= (S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE);
>
> @@ -325,14 +331,18 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
>  void fimc_hw_en_capture(struct fimc_ctx *ctx)
>  {
>        struct fimc_dev *dev = ctx->fimc_dev;
> -       u32 cfg;
>
> -       cfg = readl(dev->regs + S5P_CIIMGCPT);
> -       /* One shot mode for output DMA or freerun for FIFO. */
> -       if (ctx->out_path == FIMC_DMA)
> -               cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE;
> -       else
> -               cfg &= ~S5P_CIIMGCPT_CPT_FREN_ENABLE;
> +       u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
> +
> +       if (ctx->out_path == FIMC_DMA) {
> +               /* one shot mode */
> +               cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE | S5P_CIIMGCPT_IMGCPTEN;
> +       } else {
> +               /* Continous frame capture mode (freerun). */
> +               cfg &= ~(S5P_CIIMGCPT_CPT_FREN_ENABLE |
> +                        S5P_CIIMGCPT_CPT_FRMOD_CNT);
> +               cfg |= S5P_CIIMGCPT_IMGCPTEN;
> +       }
>
>        if (ctx->scaler.enabled)
>                cfg |= S5P_CIIMGCPT_IMGCPTEN_SC;
> @@ -501,9 +511,7 @@ void fimc_hw_set_output_path(struct fimc_ctx *ctx)
>
>  void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
>  {
> -       u32 cfg = 0;
> -
> -       cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
> +       u32 cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
>        cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DIS;
>        writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
>
> @@ -515,13 +523,149 @@ void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
>        writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
>  }
>
> -void fimc_hw_set_output_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
> +void fimc_hw_set_output_addr(struct fimc_dev *dev,
> +                            struct fimc_addr *paddr, int index)
>  {
> -       int i;
> -       /* Set all the output register sets to point to single video buffer. */
> -       for (i = 0; i < FIMC_MAX_OUT_BUFS; i++) {
> +       int i = (index == -1) ? 0 : index;
> +       do {
>                writel(paddr->y, dev->regs + S5P_CIOYSA(i));
>                writel(paddr->cb, dev->regs + S5P_CIOCBSA(i));
>                writel(paddr->cr, dev->regs + S5P_CIOCRSA(i));
> +               dbg("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
> +                   i, paddr->y, paddr->cb, paddr->cr);
> +       } while (index == -1 && ++i < FIMC_MAX_OUT_BUFS);
> +}
> +
> +int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
> +                               struct s3c_fimc_isp_info *cam)
> +{
> +       u32 cfg = readl(fimc->regs + S5P_CIGCTRL);
> +
> +       cfg &= ~(S5P_CIGCTRL_INVPOLPCLK | S5P_CIGCTRL_INVPOLVSYNC |
> +                S5P_CIGCTRL_INVPOLHREF | S5P_CIGCTRL_INVPOLHSYNC);
> +
> +       if (cam->flags & FIMC_CLK_INV_PCLK)
> +               cfg |= S5P_CIGCTRL_INVPOLPCLK;
> +
> +       if (cam->flags & FIMC_CLK_INV_VSYNC)
> +               cfg |= S5P_CIGCTRL_INVPOLVSYNC;
> +
> +       if (cam->flags & FIMC_CLK_INV_HREF)
> +               cfg |= S5P_CIGCTRL_INVPOLHREF;
> +
> +       if (cam->flags & FIMC_CLK_INV_HSYNC)
> +               cfg |= S5P_CIGCTRL_INVPOLHSYNC;
> +
> +       writel(cfg, fimc->regs + S5P_CIGCTRL);
> +
> +       return 0;
> +}
> +
> +int fimc_hw_set_camera_source(struct fimc_dev *fimc,
> +                             struct s3c_fimc_isp_info *cam)
> +{
> +       struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
> +       u32 cfg = 0;
> +
> +       if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
> +
> +               switch (fimc->vid_cap.fmt.code) {
> +               case V4L2_MBUS_FMT_YUYV8_2X8:
> +                       cfg = S5P_CISRCFMT_ORDER422_YCBYCR;
> +                       break;
> +               case V4L2_MBUS_FMT_YVYU8_2X8:
> +                       cfg = S5P_CISRCFMT_ORDER422_YCRYCB;
> +                       break;
> +               case V4L2_MBUS_FMT_VYUY8_2X8:
> +                       cfg = S5P_CISRCFMT_ORDER422_CBYCRY;
> +                       break;
> +               case V4L2_MBUS_FMT_UYVY8_2X8:
> +                       cfg = S5P_CISRCFMT_ORDER422_CRYCBY;
> +                       break;
> +               default:
> +                       err("camera image format not supported: %d",
> +                           fimc->vid_cap.fmt.code);
> +                       return -EINVAL;
> +               }
> +
> +               if (cam->bus_type == FIMC_ITU_601) {
> +                       if (cam->bus_width == 8) {
> +                               cfg |= S5P_CISRCFMT_ITU601_8BIT;
> +                       } else if (cam->bus_width == 16) {
> +                               cfg |= S5P_CISRCFMT_ITU601_16BIT;
> +                       } else {
> +                               err("invalid bus width: %d", cam->bus_width);
> +                               return -EINVAL;
> +                       }
> +               } /* else defaults to ITU-R BT.656 8-bit */
> +       }
> +
> +       cfg |= S5P_CISRCFMT_HSIZE(f->width) | S5P_CISRCFMT_VSIZE(f->height);
> +       writel(cfg, fimc->regs + S5P_CISRCFMT);
> +
> +       return 0;
> +}
> +
> +int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
> +{
> +       u32 hoff2, voff2;
> +
> +       u32 cfg = readl(fimc->regs + S5P_CIWDOFST);
> +       cfg &= ~(S5P_CIWDOFST_HOROFF_MASK | S5P_CIWDOFST_VEROFF_MASK);
> +       cfg |= S5P_CIWDOFST_OFF_EN |
> +               S5P_CIWDOFST_HOROFF(f->offs_h) | S5P_CIWDOFST_VEROFF(f->offs_v);
> +       writel(cfg, fimc->regs + S5P_CIWDOFST);
> +
> +       /* See CIWDOFSTn register description in the datasheet for details. */
> +       hoff2 = f->o_width - f->width - f->offs_h;
> +       voff2 = f->o_height - f->height - f->offs_v;
> +
> +       cfg = S5P_CIWDOFST2_HOROFF(hoff2) | S5P_CIWDOFST2_VEROFF(voff2);
> +       writel(cfg, fimc->regs + S5P_CIWDOFST2);
> +
> +       return 0;
> +}
> +
> +int fimc_hw_set_camera_type(struct fimc_dev *fimc,
> +                           struct s3c_fimc_isp_info *cam)
> +{
> +       u32 cfg, tmp;
> +       struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> +
> +       cfg = readl(fimc->regs + S5P_CIGCTRL);
> +
> +       /* Select ITU B interface, disable Writeback path and test pattern. */
> +       cfg &= ~(S5P_CIGCTRL_TESTPAT_MASK | S5P_CIGCTRL_SELCAM_ITU_A |
> +               S5P_CIGCTRL_SELCAM_MIPI | S5P_CIGCTRL_CAMIF_SELWB |
> +               S5P_CIGCTRL_SELCAM_MIPI_A);
> +
> +       /* Camera bus selection. */
> +       if (cam->bus_type == FIMC_MIPI_CSI2) {
> +               cfg |= S5P_CIGCTRL_SELCAM_MIPI;
> +               if (cam->mux_id == 0)
> +                       cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
> +
> +               /* TODO: add remaining formats supported by FIMC. */
> +               if (vid_cap->fmt.code == V4L2_MBUS_FMT_VYUY8_2X8) {
> +                       tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
> +               } else {
> +                       err("camera image format not supported: %d",
> +                           vid_cap->fmt.code);
> +                       return -EINVAL;
> +               }
> +               writel(tmp | (0x1 << 8), fimc->regs + S5P_CSIIMGFMT);
> +
> +       } else if (cam->bus_type == FIMC_ITU_601 ||
> +                 cam->bus_type == FIMC_ITU_656) {
> +               if (cam->mux_id == 0) /* ITU-A, ITU-B: 0, 1 */
> +                       cfg |= S5P_CIGCTRL_SELCAM_ITU_A;
> +       } else if (cam->bus_type == FIMC_LCD_WB) {
> +               cfg |= S5P_CIGCTRL_CAMIF_SELWB;
> +       } else {
> +               err("invalid camera bus type selected\n");
> +               return -EINVAL;
>        }
> +       writel(cfg, fimc->regs + S5P_CIGCTRL);
> +
> +       return 0;
>  }
> diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
> index df8cdfb..9e83315 100644
> --- a/drivers/media/video/s5p-fimc/regs-fimc.h
> +++ b/drivers/media/video/s5p-fimc/regs-fimc.h
> @@ -24,22 +24,21 @@
>
>  /* Window offset */
>  #define S5P_CIWDOFST                   0x04
> -#define S5P_CIWDOFST_WINOFSEN          (1 << 31)
> +#define S5P_CIWDOFST_OFF_EN            (1 << 31)
>  #define S5P_CIWDOFST_CLROVFIY          (1 << 30)
>  #define S5P_CIWDOFST_CLROVRLB          (1 << 29)
> -#define S5P_CIWDOFST_WINHOROFST_MASK   (0x7ff << 16)
> +#define S5P_CIWDOFST_HOROFF_MASK       (0x7ff << 16)
>  #define S5P_CIWDOFST_CLROVFICB         (1 << 15)
>  #define S5P_CIWDOFST_CLROVFICR         (1 << 14)
> -#define S5P_CIWDOFST_WINHOROFST(x)     ((x) << 16)
> -#define S5P_CIWDOFST_WINVEROFST(x)     ((x) << 0)
> -#define S5P_CIWDOFST_WINVEROFST_MASK   (0xfff << 0)
> +#define S5P_CIWDOFST_HOROFF(x)         ((x) << 16)
> +#define S5P_CIWDOFST_VEROFF(x)         ((x) << 0)
> +#define S5P_CIWDOFST_VEROFF_MASK       (0xfff << 0)
>
>  /* Global control */
>  #define S5P_CIGCTRL                    0x08
>  #define S5P_CIGCTRL_SWRST              (1 << 31)
>  #define S5P_CIGCTRL_CAMRST_A           (1 << 30)
>  #define S5P_CIGCTRL_SELCAM_ITU_A       (1 << 29)
> -#define S5P_CIGCTRL_SELCAM_ITU_MASK    (1 << 29)
>  #define S5P_CIGCTRL_TESTPAT_NORMAL     (0 << 27)
>  #define S5P_CIGCTRL_TESTPAT_COLOR_BAR  (1 << 27)
>  #define S5P_CIGCTRL_TESTPAT_HOR_INC    (2 << 27)
> @@ -57,6 +56,8 @@
>  #define S5P_CIGCTRL_SHDW_DISABLE       (1 << 12)
>  #define S5P_CIGCTRL_SELCAM_MIPI_A      (1 << 7)
>  #define S5P_CIGCTRL_CAMIF_SELWB                (1 << 6)
> +/* 0 - ITU601; 1 - ITU709 */
> +#define S5P_CIGCTRL_CSC_ITU601_709     (1 << 5)
>  #define S5P_CIGCTRL_INVPOLHSYNC                (1 << 4)
>  #define S5P_CIGCTRL_SELCAM_MIPI                (1 << 3)
>  #define S5P_CIGCTRL_INTERLACE          (1 << 0)
> @@ -151,6 +152,8 @@
>  #define S5P_CISTATUS_OVFICB            (1 << 30)
>  #define S5P_CISTATUS_OVFICR            (1 << 29)
>  #define S5P_CISTATUS_VSYNC             (1 << 28)
> +#define S5P_CISTATUS_FRAMECNT_MASK     (3 << 26)
> +#define S5P_CISTATUS_FRAMECNT_SHIFT    26
>  #define S5P_CISTATUS_WINOFF_EN         (1 << 25)
>  #define S5P_CISTATUS_IMGCPT_EN         (1 << 22)
>  #define S5P_CISTATUS_IMGCPT_SCEN       (1 << 21)
> @@ -267,5 +270,13 @@
>
>  /* MIPI CSI image format */
>  #define S5P_CSIIMGFMT                  0x194
> +#define S5P_CSIIMGFMT_YCBCR422_8BIT    0x1e
> +#define S5P_CSIIMGFMT_RAW8             0x2a
> +#define S5P_CSIIMGFMT_RAW10            0x2b
> +#define S5P_CSIIMGFMT_RAW12            0x2c
> +#define S5P_CSIIMGFMT_USER1            0x30
> +#define S5P_CSIIMGFMT_USER2            0x31
> +#define S5P_CSIIMGFMT_USER3            0x32
> +#define S5P_CSIIMGFMT_USER4            0x33
>
>  #endif /* REGS_FIMC_H_ */
> diff --git a/include/media/s3c_fimc.h b/include/media/s3c_fimc.h
> new file mode 100644
> index 0000000..37c07f1
> --- /dev/null
> +++ b/include/media/s3c_fimc.h
> @@ -0,0 +1,48 @@
> +/*
> + * Samsung S5P SoC camera interface driver header
> + *
> + * Copyright (c) 2010 Samsung Electronics Co., Ltd
> + * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef S3C_FIMC_H_
> +#define S3C_FIMC_H_
> +
> +enum cam_bus_type {
> +       FIMC_ITU_601 = 1,
> +       FIMC_ITU_656,
> +       FIMC_MIPI_CSI2,
> +       FIMC_LCD_WB, /* FIFO link from LCD mixer */
> +};
> +
> +#define FIMC_CLK_INV_PCLK      (1 << 0)
> +#define FIMC_CLK_INV_VSYNC     (1 << 1)
> +#define FIMC_CLK_INV_HREF      (1 << 2)
> +#define FIMC_CLK_INV_HSYNC     (1 << 3)
> +
> +struct i2c_board_info;
> +
> +/**
> + * struct s3c_fimc_isp_info - image sensor information required for host
> + *                           interace configuration.
> + *
> + * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
> + * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
> + * @bus_width: camera data bus width in bits
> + * @flags: flags defining bus signals polarity inversion (High by default)
> + * @board_info: pointer to I2C subdevice's board info
> + */
> +struct s3c_fimc_isp_info {
> +       struct i2c_board_info *board_info;
> +       int i2c_bus_num;
> +       enum cam_bus_type bus_type;
> +       int mux_id;
> +       u16 bus_width;
> +       u16 flags;
> +};
> +
> +#endif /* S3C_FIMC_H_ */
> --
> 1.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
