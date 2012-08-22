Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40465 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab2HVQTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 12:19:04 -0400
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M960020200R7I00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 17:19:39 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M95000APZZH1920@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 17:19:01 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
 <1344508110-16945-5-git-send-email-arun.kk@samsung.com>
In-reply-to: <1344508110-16945-5-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v4 4/4] [media] s5p-mfc: Update MFC v4l2 driver to support
 MFC6.x
Date: Wed, 22 Aug 2012 18:19:01 +0200
Message-id: <007401cd8081$d756d120$86047360$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find the comments in the patch contents.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 09 August 2012 12:29
> 
> From: Jeongtae Park <jtp.park@samsung.com>
> 

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
b/drivers/media/video/s5p-
> mfc/s5p_mfc.c
> index be8d689..75b9026 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -278,12 +278,13 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx
*ctx,
> 
>  	dst_frame_status = s5p_mfc_get_dspl_status(dev)
>  				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
> -	res_change = s5p_mfc_get_dspl_status(dev)
> -				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
> +	res_change = (s5p_mfc_get_dspl_status(dev)
> +				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK)
> +				>> S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT;
>  	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
>  	if (ctx->state == MFCINST_RES_CHANGE_INIT)
>  		ctx->state = MFCINST_RES_CHANGE_FLUSH;
> -	if (res_change) {
> +	if (res_change == 1 || res_change == 2) {

Here there should be a define instead of these magic numbers.
(something like S5P_FIMV_RES_INCREASE/DECREASE)

>  		ctx->state = MFCINST_RES_CHANGE_INIT;
>  		s5p_mfc_clear_int_flags(dev);
>  		wake_up_ctx(ctx, reason, err);
> @@ -435,10 +436,26 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx
> *ctx,
>  		s5p_mfc_dec_calc_dpb_size(ctx);
> 
>  		ctx->dpb_count = s5p_mfc_get_dpb_count(dev);
> +		ctx->mv_count = s5p_mfc_get_mv_count(dev);
>  		if (ctx->img_width == 0 || ctx->img_height == 0)
>  			ctx->state = MFCINST_ERROR;
>  		else
>  			ctx->state = MFCINST_HEAD_PARSED;
> +
> +		if ((ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
> +			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) &&
> +				!list_empty(&ctx->src_queue)) {
> +			struct s5p_mfc_buf *src_buf;
> +			src_buf = list_entry(ctx->src_queue.next,
> +					struct s5p_mfc_buf, list);
> +			mfc_debug(2, "Check consumed size of header. ");
> +			mfc_debug(2, "source : %d, consumed : %d\n",
> +					s5p_mfc_get_consumed_stream(dev),
> +					src_buf->b->v4l2_planes[0].bytesused);
> +			if (s5p_mfc_get_consumed_stream(dev) <
> +					src_buf->b->v4l2_planes[0].bytesused)
> +				ctx->remained = 1;


> +		}
>  	}

I have already commented about the name remained. In addition the flag should
be
set here to both 0 an 1, as we cannot take previous value for granted.

>  	s5p_mfc_clear_int_flags(dev);
>  	clear_work_bit(ctx);
> @@ -469,7 +486,7 @@ static void s5p_mfc_handle_init_buffers(struct
s5p_mfc_ctx
> *ctx,
>  	spin_unlock(&dev->condlock);
>  	if (err == 0) {
>  		ctx->state = MFCINST_RUNNING;
> -		if (!ctx->dpb_flush_flag) {
> +		if (!ctx->dpb_flush_flag && !ctx->remained) {
>  			spin_lock_irqsave(&dev->irqlock, flags);
>  			if (!list_empty(&ctx->src_queue)) {
>  				src_buf = list_entry(ctx->src_queue.next,
> @@ -1199,12 +1216,47 @@ static struct s5p_mfc_variant mfc_drvdata_v5 = {
>  	.port_num	= 2,
>  	.buf_size	= &buf_size_v5,
>  	.buf_align	= &mfc_buf_align_v5,
> +	.mclk_name	= "sclk_mfc",
> +	.fw_name	= "s5p-mfc.fw",
> +};
> +
> +struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
> +	.dev_ctx	= 0x7000,	/*  28KB */
> +	.h264_dec_ctx	= 0x200000,	/* 1.6MB */
> +	.other_dec_ctx	= 0x5000,	/*  20KB */
> +	.h264_enc_ctx	= 0x19000,	/* 100KB */
> +	.other_enc_ctx	= 0x3000,	/*  12KB */
> +};
> +
> +struct s5p_mfc_buf_size buf_size_v6 = {
> +	.fw	= 0x100000,	/*   1MB */
> +	.cpb	= 0x300000,	/*   3MB */
> +	.priv	= &mfc_buf_size_v6,
> +};

I have already commented about using defines here in the previous patch.
I think it would look much better than numbers.

[snip]

> --- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> @@ -16,13 +16,14 @@
>  #ifndef S5P_MFC_COMMON_H_
>  #define S5P_MFC_COMMON_H_
> 
> -#include "regs-mfc.h"
>  #include <linux/platform_device.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/videobuf2-core.h>
> +#include "regs-mfc.h"
> +#include "regs-mfc-v6.h"
> 
>  /* Definitions related to MFC memory */
> 
> @@ -210,6 +211,14 @@ struct s5p_mfc_buf_size_v5 {
>  	unsigned int shm;
>  };
> 
> +struct s5p_mfc_buf_size_v6 {
> +	unsigned int dev_ctx;
> +	unsigned int h264_dec_ctx;
> +	unsigned int other_dec_ctx;
> +	unsigned int h264_enc_ctx;
> +	unsigned int other_enc_ctx;
> +};
> +
>  struct s5p_mfc_buf_size {
>  	unsigned int fw;
>  	unsigned int cpb;
> @@ -225,6 +234,8 @@ struct s5p_mfc_variant {
>  	unsigned int port_num;
>  	struct s5p_mfc_buf_size *buf_size;
>  	struct s5p_mfc_buf_align *buf_align;
> +	char	*mclk_name;
> +	char	*fw_name;
>  };
> 
>  /**
> @@ -279,6 +290,7 @@ struct s5p_mfc_priv_buf {
>   * @watchdog_work:	worker for the watchdog
>   * @alloc_ctx:		videobuf2 allocator contexts for two memory
banks
>   * @enter_suspend:	flag set when entering suspend
> + * @ctx_buf:		common context memory (MFCv6)
>   * @warn_start:		hardware error code from which warnings start
>   *
>   */
> @@ -318,6 +330,7 @@ struct s5p_mfc_dev {
>  	void *alloc_ctx[2];
>  	unsigned long enter_suspend;
> 
> +	struct s5p_mfc_priv_buf ctx_buf;
>  	int warn_start;
>  };
> 
> @@ -352,6 +365,22 @@ struct s5p_mfc_h264_enc_params {
>  	int level;
>  	u16 cpb_size;
>  	int interlace;
> +	u8 hier_qp;
> +	u8 hier_qp_type;
> +	u8 hier_qp_layer;
> +	u8 hier_qp_layer_qp[7];
> +	u8 sei_frame_packing;
> +	u8 sei_fp_curr_frame_0;
> +	u8 sei_fp_arrangement_type;
> +
> +	u8 fmo;
> +	u8 fmo_map_type;
> +	u8 fmo_slice_grp;
> +	u8 fmo_chg_dir;
> +	u32 fmo_chg_rate;
> +	u32 fmo_run_len[4];
> +	u8 aso;
> +	u32 aso_slice_order[8];
>  };
> 
>  /**
> @@ -394,6 +423,7 @@ struct s5p_mfc_enc_params {
>  	u32 rc_bitrate;
>  	u16 rc_reaction_coeff;
>  	u16 vbv_size;
> +	u32 vbv_delay;
> 
>  	enum v4l2_mpeg_video_header_mode seq_hdr_mode;
>  	enum v4l2_mpeg_mfc51_video_frame_skip_mode frame_skip_mode;
> @@ -574,10 +604,11 @@ struct s5p_mfc_ctx {
>  	int display_delay;
>  	int display_delay_enable;
>  	int after_packed_pb;
> +	int sei_fp_parse;

A description of the new field should be added in the comment above.

> 
>  	int dpb_count;
>  	int total_dpb_count;
> -
> +	int mv_count;

Ditto.

>  	/* Buffers */
>  	struct s5p_mfc_priv_buf ctx;
>  	struct s5p_mfc_priv_buf dsc;
> @@ -586,16 +617,28 @@ struct s5p_mfc_ctx {
>  	struct s5p_mfc_enc_params enc_params;
> 
>  	size_t enc_dst_buf_size;
> +	size_t luma_dpb_size;
> +	size_t chroma_dpb_size;
> +	size_t me_buffer_size;
> +	size_t tmv_buffer_size;

Ditto.

[snip]

> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
> @@ -0,0 +1,50 @@
> +/*
> + * drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
> + *
> + * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
> + * Contains declarations of hw related functions.
> + *
> + * Copyright (c) 2012 Samsung Electronics
> + *		http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef S5P_MFC_OPR_V6_H_
> +#define S5P_MFC_OPR_V6_H_
> +
> +#include "s5p_mfc_common.h"
> +#include "s5p_mfc_opr.h"
> +
> +#define MFC_CTRL_MODE_CUSTOM	MFC_CTRL_MODE_SFR
> +
> +#define mb_width(x_size)		((x_size + 15) / 16)
> +#define mb_height(y_size)		((y_size + 15) / 16)

This can also be replaced in the driver's code with ALIGN(w, MB_WIDTH)
(or similar). By the way the name should be capitalized (the mb_width name
is used as the name of a variable in another part of code!).

> +#define s5p_mfc_dec_mv_size_v6(x, y)	(mb_width(x) * \
> +					(((mb_height(y)+1)/2)*2) * 64 + 128)

I would also capitalize the name of this macro.

[snip]

