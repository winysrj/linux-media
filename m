Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:30377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0JUIUs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 04:20:48 -0400
Date: Thu, 21 Oct 2010 17:21:06 +0900
From: Sewoon Park <seuni.park@samsung.com>
Subject: RE: [PATCH 5/6 v5] V4L/DVB: s5p-fimc: Add camera capture support
In-reply-to: <1286817993-21558-6-git-send-email-s.nawrocki@samsung.com>
To: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <001a01cb70f8$ea978530$bfc68f90$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
 <1286817993-21558-6-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Latest your reply is easy to understand.
And I send you another parts review comments.

Tuesday, October 12, 2010 2:27, Sylwester Nawrocki wrote :
> 
> Add a video device driver per each FIMC entity to support
> the camera capture input mode. Video capture node is registered
> only if CCD sensor data is provided through driver's platfrom data
> and board setup code.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/s5p-fimc/Makefile       |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c |  819
> +++++++++++++++++++++++++++
>  drivers/media/video/s5p-fimc/fimc-core.c    |  563 +++++++++++++------
>  drivers/media/video/s5p-fimc/fimc-core.h    |  205 +++++++-
>  drivers/media/video/s5p-fimc/fimc-reg.c     |  173 +++++-
>  include/media/s3c_fimc.h                    |   60 ++
>  6 files changed, 1630 insertions(+), 192 deletions(-)
>  create mode 100644 drivers/media/video/s5p-fimc/fimc-capture.c
>  create mode 100644 include/media/s3c_fimc.h
> 
> diff --git a/drivers/media/video/s5p-fimc/Makefile
> b/drivers/media/video/s5p-fimc/Makefile
> index 0d9d541..7ea1b14 100644
> --- a/drivers/media/video/s5p-fimc/Makefile
> +++ b/drivers/media/video/s5p-fimc/Makefile
> @@ -1,3 +1,3 @@
> 
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) := s5p-fimc.o
> -s5p-fimc-y := fimc-core.o fimc-reg.o
> +s5p-fimc-y := fimc-core.o fimc-reg.o fimc-capture.o
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c
> b/drivers/media/video/s5p-fimc/fimc-capture.c
> new file mode 100644
> index 0000000..e8f13d3
> --- /dev/null
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -0,0 +1,819 @@
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
> +					    struct s3c_fimc_isp_info *isp_info)
> +{
> +	struct i2c_adapter *i2c_adap;
> +	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> +	struct v4l2_subdev *sd = NULL;
> +
> +	i2c_adap = i2c_get_adapter(isp_info->i2c_bus_num);
> +	if (!i2c_adap)
> +		return ERR_PTR(-ENOMEM);
> +
> +	sd = v4l2_i2c_new_subdev_board(&vid_cap->v4l2_dev, i2c_adap,
> +				       MODULE_NAME, isp_info->board_info, NULL);
> +	if (!sd) {
> +		v4l2_err(&vid_cap->v4l2_dev, "failed to acquire subdev\n");
> +		return NULL;
> +	}
> +
> +	v4l2_info(&vid_cap->v4l2_dev, "subdevice %s registered
> successfuly\n",
> +		isp_info->board_info->type);
> +
> +	return sd;
> +}
> +
> +static void fimc_subdev_unregister(struct fimc_dev *fimc)
> +{
> +	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
> +	struct i2c_client *client;
> +
> +	if (vid_cap->input_index < 0)
> +		return;	/* Subdevice already released or not registered.
> */
> +
> +	if (vid_cap->sd) {
> +		v4l2_device_unregister_subdev(vid_cap->sd);
> +		client = v4l2_get_subdevdata(vid_cap->sd);
> +		i2c_unregister_device(client);
> +		i2c_put_adapter(client->adapter);
> +		vid_cap->sd = NULL;
> +	}
> +
> +	vid_cap->input_index = -1;
> +}

(snip)

> +static int fimc_cap_s_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct fimc_ctx *ctx = priv;
> +	struct fimc_dev *fimc = ctx->fimc_dev;
> +	struct fimc_frame *frame;
> +	struct v4l2_pix_format *pix;
> +	int ret;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	ret = fimc_vidioc_try_fmt(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	if (mutex_lock_interruptible(&fimc->lock))
> +		return -ERESTARTSYS;
> +
> +	if (fimc_capture_active(fimc)) {
> +		ret = -EBUSY;
> +		goto sf_unlock;
> +	}

I suggest to use vb_lock on here.
You already use vb_lock "fimc_m2m_s_fmt" function in fimc-core.c code

-- sample --
struct fimc_capture_device *cap = &ctx->fimc_dev->vid_cap;
mutex_lock(&cap->vbq->vb->lock);


> +
> +	frame = &ctx->d_frame;
> +
> +	pix = &f->fmt.pix;
> +	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
> +	if (!frame->fmt) {
> +		err("fimc target format not found\n");
> +		ret = -EINVAL;
> +		goto sf_unlock;
> +	}
> +
> +	/* Output DMA frame pixel size and offsets. */
> +	frame->f_width	= pix->bytesperline * 8 / frame->fmt->depth;
> +	frame->f_height = pix->height;
> +	frame->width	= pix->width;
> +	frame->height	= pix->height;
> +	frame->o_width	= pix->width;
> +	frame->o_height = pix->height;
> +	frame->size	= (pix->width * pix->height * frame->fmt->depth) >> 3;
> +	frame->offs_h	= 0;
> +	frame->offs_v	= 0;
> +
> +	ret = sync_capture_fmt(ctx);
> +
> +	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
> +
> +sf_unlock:
> +	mutex_unlock(&fimc->lock);
> +	return ret;
> +}

(snip)

> -static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
> +int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
>  {
>  	struct fimc_frame *s_frame, *d_frame;
>  	struct fimc_vid_buffer *buf = NULL;
> @@ -513,9 +585,9 @@ static void fimc_dma_run(void *priv)
>  	if (ctx->state & FIMC_PARAMS)
>  		fimc_hw_set_out_dma(ctx);
> 
> -	ctx->state = 0;
>  	fimc_activate_capture(ctx);
> 
> +	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP);
>  	fimc_hw_activate_input_dma(fimc, true);
> 
>  dma_unlock:
> @@ -598,10 +670,31 @@ static void fimc_buf_queue(struct videobuf_queue *vq,
>  				  struct videobuf_buffer *vb)
>  {
>  	struct fimc_ctx *ctx = vq->priv_data;
> -	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
> +	struct fimc_dev *fimc = ctx->fimc_dev;
> +	struct fimc_vid_cap *cap = &fimc->vid_cap;
> +	unsigned long flags;
> +
> +	dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
> +
> +	if ((ctx->state & FIMC_CTX_M2M) && ctx->m2m_ctx) {
> +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
> +	} else if (ctx->state & FIMC_CTX_CAP) {
> +		spin_lock_irqsave(&fimc->slock, flags);
> +		fimc_vid_cap_buf_queue(fimc, (struct fimc_vid_buffer *)vb);
> +
> +		dbg("fimc->cap.active_buf_cnt: %d",
> +		    fimc->vid_cap.active_buf_cnt);
> +
> +		if (cap->active_buf_cnt >= cap->reqbufs_count ||
> +		   cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {

1. purpose of queues
In my understand through your code,
The qbuf() which call before streamon() is pushed done_list in videobuf 
framework to use dqbuf().
During streamon(), Number of FIMC h/w output DMA allocated buffers have pushed 
in active_queue(normally 4) and rest allocated buffers have pushed to pending_queue.

It means that, active_queue is connection to FIMC h/w for output DMA.
(maximum 4 in s5pc110, 32 in s5pc210)
pending_queue is available buffer list or returned buffer list from user.

Please let me know if I have misunderstanding.

2. Which case of condition, active_buf_cnt greater than reqbufs_count?
In preview mode normally, reqbufs_count are 4 or more.
Likewise, which case of condition, active_buf_cnt greater than FIMC_MAX_OUT_BUFS(4)?

> +			if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
> +				fimc_activate_capture(ctx);
> +		}

Condition which fimc_deactivate_capture() function run is 
"cap->active_buf_cnt <= 1".
Then I think condition which fimc_activate_capture() function run is
"cap->active_buf_cnt >= 2".
But, your code wait 4 or more.

> +		spin_unlock_irqrestore(&fimc->slock, flags);
> +	}
>  }
> 
> -static struct videobuf_queue_ops fimc_qops = {
> +struct videobuf_queue_ops fimc_qops = {
>  	.buf_setup	= fimc_buf_setup,
>  	.buf_prepare	= fimc_buf_prepare,
>  	.buf_queue	= fimc_buf_queue,
> @@ -624,7 +717,7 @@ static int fimc_m2m_querycap(struct file *file, void
> *priv,
>  	return 0;
>  }
> 

(snip)

> +
> +
> +#define FIMC_MAX_CAMIF_CLIENTS	2
> +
> +/**
> + * struct s3c_platform_fimc - camera host interface platform data
> + *
> + * @isp_info: properties of camera sensor required for host interface
> setup
> + */
> +struct s3c_platform_fimc {
> +	struct s3c_fimc_isp_info *isp_info[FIMC_MAX_CAMIF_CLIENTS];
> +};
> +#endif /* S3C_FIMC_H_ */
> --
> 1.7.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

