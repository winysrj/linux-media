Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44430 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1FTFNM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 01:13:12 -0400
Received: by pzk9 with SMTP id 9so3186774pzk.19
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 22:13:11 -0700 (PDT)
Message-ID: <4DFED6E1.3000700@gmail.com>
Date: Mon, 20 Jun 2011 10:43:05 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	jtp.park@samsung.com
Subject: Re: [PATCH 4/4 v9] MFC: Add MFC 5.1 V4L2 driver
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <1308069416-24723-5-git-send-email-k.debski@samsung.com>
In-Reply-To: <1308069416-24723-5-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kamil,

I went through the decoder flow (not codec specific yet) of your MFC 
driver. Since I havent acquired/produced a v4l2 based test case, I didnt 
check the functionality yet. Below are some of minor comments I found 
during my review.

Regards,
Subash
SISO-SLG

On 06/14/2011 10:06 PM, Kamil Debski wrote:
...
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
> new file mode 100644
...
> +/* Open an MFC node */
> +static int s5p_mfc_open(struct file *file)
> +{
> +	struct s5p_mfc_ctx *ctx = NULL;
> +	struct s5p_mfc_dev *dev = video_drvdata(file);
> +	struct vb2_queue *q;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	mfc_debug_enter();
> +
> +	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
> +
> +	/* Allocate memory for context */
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx) {
> +		mfc_err("Not enough memory.\n");
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	ret = v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	if (ret) {
> +		mfc_err("Failed to init v4l2_fh\n");
> +		goto err_fh;
> +	}
> +
> +	file->private_data =&ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	ctx->dev = dev;
> +	INIT_LIST_HEAD(&ctx->src_queue);
> +	INIT_LIST_HEAD(&ctx->dst_queue);
> +	ctx->src_queue_cnt = 0;
> +	ctx->dst_queue_cnt = 0;
> +	/* Get context number */
> +	ctx->num = 0;
> +	while (dev->ctx[ctx->num]) {
> +		ctx->num++;
> +		if (ctx->num>= MFC_NUM_CONTEXTS) {
> +			mfc_err("Too many open contexts.\n");
> +			ret = -EBUSY;
> +			goto err_no_ctx;
> +		}
> +	}
> +	/* Mark context as idle */
> +	spin_lock_irqsave(&dev->condlock, flags);
> +	clear_bit(ctx->num,&dev->ctx_work_bits);
> +	spin_unlock_irqrestore(&dev->condlock, flags);
> +	dev->ctx[ctx->num] = ctx;
> +	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
> +		ctx->type = MFCINST_DECODER;
> +		ctx->c_ops = get_dec_codec_ops();
> +		/* Setup ctrl handler */
> +		ret = s5p_mfc_dec_ctrls_setup(ctx);
> +		if (ret) {
> +			mfc_err("Failed to setup mfc controls\n");
> +			goto err_ctrls_setup;
> +		}
> +
> +
> +	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
> +		ctx->type = MFCINST_ENCODER;
> +		ctx->c_ops = get_enc_codec_ops();
> +		/* only for encoder */
> +		INIT_LIST_HEAD(&ctx->ref_queue);
> +		ctx->ref_queue_cnt = 0;
> +
> +		/* Setup ctrl handler */
> +		ret = s5p_mfc_enc_ctrls_setup(ctx);
> +		if (ret) {
> +			mfc_err("Failed to setup mfc controls\n");
> +			goto err_ctrls_setup;
> +		}
> +	} else {
> +		ret = -ENOENT;
> +		goto err_bad_node;
> +	}
> +
> +	ctx->fh.ctrl_handler =&ctx->ctrl_handler;
> +	ctx->inst_no = -1;
> +	/* Load firmware if this is the first instance */
> +	if (dev->num_inst == 1) {
> +		dev->watchdog_timer.expires = jiffies +
> +					msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
> +		add_timer(&dev->watchdog_timer);
> +
> +		mfc_debug(2, "power on\n");
> +		ret = s5p_mfc_power_on();
> +		if (ret<  0) {
> +			mfc_err("power on failed\n");
> +			goto err_pwr_enable;
> +		}
> +
> +		s5p_mfc_clock_on();
> +
> +		/* Load the FW */
> +		ret = s5p_mfc_alloc_firmware(dev);
> +		if (ret != 0)
> +			goto err_alloc_fw;
> +		ret = s5p_mfc_load_firmware(dev);
> +		if (ret != 0)
> +			goto err_load_fw;
> +
> +		/* Init the FW */
> +		ret = s5p_mfc_init_hw(dev);
> +		if (ret != 0)
> +			goto err_init_hw;
> +
> +		s5p_mfc_clock_off();
> +	}
> +
> +	/* Init videobuf2 queue for CAPTURE */
> +	q =&ctx->vq_dst;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	q->drv_priv =&ctx->fh;
> +	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
> +		q->io_modes = VB2_MMAP;
> +		q->ops = get_dec_queue_ops();
> +	} else {
> +		q->io_modes = VB2_MMAP | VB2_USERPTR;
> +		q->ops = get_enc_queue_ops();
> +	}

Node type is declared as one of MFCNODE_INVALID = -1,MFCNODE_DECODER = 
0, MFCNODE_ENCODER = 1. Hence it would be good to check even for encoder 
and return error for the invalid case.

> +
> +	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
> +		goto err_queue_init;
> +	}
> +
> +	/* Init videobuf2 queue for OUTPUT */
> +	q =&ctx->vq_src;
> +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	q->io_modes = VB2_MMAP;
> +	q->drv_priv =&ctx->fh;
> +	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
> +		q->io_modes = VB2_MMAP;
> +		q->ops = get_dec_queue_ops();
> +	} else {
> +		q->io_modes = VB2_MMAP | VB2_USERPTR;
> +		q->ops = get_enc_queue_ops();
> +	}
> +

Same as above.

> +	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		mfc_err("Failed to initialize videobuf2 queue(output)\n");
> +		goto err_queue_init;
> +	}
> +
> +	init_waitqueue_head(&ctx->queue);
> +	mfc_debug(2, "%s-- (via irq_cleanup_hw)\n", __func__);
> +	return ret;
> +
> +	/* Deinit when failure occured */
> +err_queue_init:
> +err_init_hw:
> +err_load_fw:
> +	s5p_mfc_release_firmware(dev);
> +err_alloc_fw:
> +	dev->ctx[ctx->num] = 0;
> +	del_timer_sync(&dev->watchdog_timer);
> +	s5p_mfc_clock_off();
> +err_pwr_enable:
> +	if (dev->num_inst == 1) {
> +		if (s5p_mfc_power_off()<  0)
> +			mfc_err("power off failed\n");
> +		s5p_mfc_release_firmware(dev);
> +	}
> +err_ctrls_setup:
> +	s5p_mfc_dec_ctrls_delete(ctx);
> +err_bad_node:
> +err_no_ctx:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +err_fh:
> +	kfree(ctx);
> +err_alloc:
> +	dev->num_inst--;
> +	mfc_debug_leave();
> +	return ret;
> +}
> +

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> new file mode 100644
> index 0000000..a3d7378
...
> +/* Get format */
> +static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp;
> +
> +	mfc_debug_enter();
> +	pix_mp =&f->fmt.pix_mp;
> +	mfc_debug(2, "f->type = %d ctx->state = %d\n", f->type, ctx->state);
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE&&
> +	    (ctx->state == MFCINST_GOT_INST || ctx->state ==
> +						MFCINST_RES_CHANGE_END)) {
> +		/* If the MFC is parsing the header,
> +		 * so wait until it is finished */
> +		s5p_mfc_clean_ctx_int_flags(ctx);
> +		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
> +									0);
> +	}
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE&&
> +	    ctx->state>= MFCINST_HEAD_PARSED&&
> +	    ctx->state<  MFCINST_ABORT) {
> +		/* This is run on CAPTURE (deocde output) */
  decode

> +		/* Width and height are set to the dimensions
> +		   of the movie, the buffer is bigger and
> +		   further processing stages should crop to this
> +		   rectangle. */
> +		pix_mp->width = ctx->buf_width;
> +		pix_mp->height = ctx->buf_height;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +		pix_mp->num_planes = 2;
> +		/* Set pixelformat to the format in which MFC
> +		   outputs the decoded frame */
> +		pix_mp->pixelformat = V4L2_PIX_FMT_NV12MT;
> +		pix_mp->plane_fmt[0].bytesperline = ctx->buf_width;
> +		pix_mp->plane_fmt[0].sizeimage = ctx->luma_size;
> +		pix_mp->plane_fmt[1].bytesperline = ctx->buf_width;
> +		pix_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		/* This is run on OUTPUT
> +		   The buffer contains compressed image
> +		   so width and height have no meaning */
> +		pix_mp->width = 0;
> +		pix_mp->height = 0;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +		pix_mp->plane_fmt[0].bytesperline = ctx->dec_src_buf_size;
> +		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size;
> +		pix_mp->pixelformat = ctx->src_fmt->fourcc;
> +		pix_mp->num_planes = ctx->src_fmt->num_planes;
> +	} else {
> +		mfc_err("Format could not be read\n");
> +		mfc_debug(2, "%s-- with error\n", __func__);
> +		return -EINVAL;
> +	}
> +	mfc_debug_leave();
> +	return 0;
> +}
> +
...
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_mem.h b/drivers/media/video/s5p-mfc/s5p_mfc_mem.h
> new file mode 100644
> index 0000000..0ffa931
> --- /dev/null
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_mem.h
> @@ -0,0 +1,55 @@
> +/*
> + * linux/drivers/media/video/s5p-mfc/s5p_mfc_mem.h
> + *
> + * Copyright (c) 2010 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __S5P_MFC_MEM_H_
> +#define __S5P_MFC_MEM_H_ __FILE__
> +
> +#include<linux/platform_device.h>
> +#include "s5p_mfc_common.h"
> +
> +/* Offset base used to differentiate between CAPTURE and OUTPUT
> +*  while mmaping */
> +
> +#define MFC_OFFSET_SHIFT	11
> +
> +#define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
> +
> +#define FIRMWARE_CODE_SIZE	0x60000		/* 384KB */

Instead of hard-coding firware size value, cant we pick it up from 
.config file? I hope with more codecs being supported, this size will 
change in future.

> +#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264 instance */
> +#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
> +#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC buffer */
> +#define SHARED_BUF_SIZE		0x1000		/* 4KB for shared buffer */
> +
> +#define DEF_CPB_SIZE		0x40000		/* 512KB */
> +
> +#define MFC_BANK_A_ALLOC_CTX	0
> +#define MFC_BANK_B_ALLOC_CTX	1
> +#define MFC_FW_ALLOC_CTX	0

Since we are loading the firmware into bank-0, cant this be
#define MFC_FW_ALLOC_CTX MFC_BANK_A_ALLOC_CTX

But what in future, if this needs to be configurable?
	
> +
> +#define MFC_BANK1_ALIGN_ORDER	13
> +#define MFC_BANK2_ALIGN_ORDER	13
> +#define MFC_FW_ALIGN_ORDER	17
> +
> +#define MFC_BASE_ALIGN_ORDER	MFC_FW_ALIGN_ORDER
> +
> +#include<media/videobuf2-dma-contig.h>
> +
> +static inline size_t s5p_mfc_mem_cookie(void *a, void *b)
> +{
> +	/* Same functionality as the vb2_dma_contig_plane_paddr */
> +	dma_addr_t *paddr = vb2_dma_contig_memops.cookie(b);
> +
> +	return *paddr;
> +}
> +
> +
> +#endif /* __S5P_MFC_MEM_H_ */

Regards,
Subash
