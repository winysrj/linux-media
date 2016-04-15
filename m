Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40316 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbcDOO1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 10:27:14 -0400
Subject: Re: [PATCH 3/7] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1460548915-17536-1-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-2-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-3-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-4-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5710FA3A.2030603@xs4all.nl>
Date: Fri, 15 Apr 2016 16:27:06 +0200
MIME-Version: 1.0
In-Reply-To: <1460548915-17536-4-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2016 02:01 PM, Tiffany Lin wrote:
> Add v4l2 layer decoder driver for MT8173
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/platform/mtk-vcodec/Makefile         |   10 +-
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1429 ++++++++++++++++++++
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |   81 ++
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  469 +++++++
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |  153 +++
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   28 +
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   98 +-
>  drivers/media/platform/mtk-vcodec/vdec_drv_base.h  |   56 +
>  drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |  113 ++
>  drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |   93 ++
>  drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h   |   86 ++
>  11 files changed, 2596 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_base.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
> 
> diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
> index dc5cb00..4c8ed2f 100644
> --- a/drivers/media/platform/mtk-vcodec/Makefile
> +++ b/drivers/media/platform/mtk-vcodec/Makefile
> @@ -1,7 +1,13 @@
>  
>  
> -obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-enc.o mtk-vcodec-common.o
> -
> +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-dec.o \
> +				       mtk-vcodec-enc.o \
> +				       mtk-vcodec-common.o
> +
> +mtk-vcodec-dec-y := mtk_vcodec_dec_drv.o \
> +		vdec_drv_if.o \
> +		mtk_vcodec_dec.o \
> +		mtk_vcodec_dec_pm.o \
>  
>  
>  mtk-vcodec-enc-y := venc/venc_vp8_if.o \
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> new file mode 100644
> index 0000000..0499413
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> @@ -0,0 +1,1429 @@
> +/*
> +* Copyright (c) 2016 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "mtk_vcodec_drv.h"
> +#include "mtk_vcodec_dec.h"
> +#include "mtk_vcodec_intr.h"
> +#include "mtk_vcodec_util.h"
> +#include "vdec_drv_if.h"
> +#include "mtk_vcodec_dec_pm.h"
> +
> +static struct mtk_video_fmt mtk_video_formats[] = {
> +	{
> +		.fourcc = V4L2_PIX_FMT_H264,
> +		.type = MTK_FMT_DEC,
> +		.num_planes	= 1,
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_VP8,
> +		.type = MTK_FMT_DEC,
> +		.num_planes	= 1,
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_VP9,
> +		.type = MTK_FMT_DEC,
> +		.num_planes	= 1,
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_MT21,
> +		.type = MTK_FMT_FRAME,
> +		.num_planes = 2,
> +	},
> +};
> +#define OUT_FMT_IDX	0
> +#define CAP_FMT_IDX	3
> +
> +#define VCODEC_CAPABILITY_4K_DISABLED	0x10
> +#define VCODEC_DEC_4K_CODED_WIDTH	4096U
> +#define VCODEC_DEC_4K_CODED_HEIGHT	2304U
> +
> +#define MTK_VDEC_MIN_W	64U
> +#define MTK_VDEC_MIN_H	64U
> +#define MTK_VDEC_MAX_W	2048U
> +#define MTK_VDEC_MAX_H	1088U
> +#define DFT_CFG_WIDTH	MTK_VDEC_MIN_W
> +#define DFT_CFG_HEIGHT	MTK_VDEC_MIN_H
> +
> +static const struct mtk_codec_framesizes mtk_vdec_framesizes[] = {
> +	{
> +		.fourcc	= V4L2_PIX_FMT_H264,
> +		.stepwise = {  MTK_VDEC_MIN_W, MTK_VDEC_MAX_W, 16,
> +					MTK_VDEC_MIN_H, MTK_VDEC_MAX_H, 16 },
> +	},
> +	{
> +		.fourcc	= V4L2_PIX_FMT_VP8,
> +		.stepwise = {  MTK_VDEC_MIN_W, MTK_VDEC_MAX_W, 16,
> +					MTK_VDEC_MIN_H, MTK_VDEC_MAX_H, 16 },
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_VP9,
> +		.stepwise = {  MTK_VDEC_MIN_W, MTK_VDEC_MAX_W, 16,
> +					MTK_VDEC_MIN_H, MTK_VDEC_MAX_H, 16 },
> +	},
> +};
> +
> +#define NUM_SUPPORTED_FRAMESIZE ARRAY_SIZE(mtk_vdec_framesizes)
> +#define NUM_FORMATS ARRAY_SIZE(mtk_video_formats)
> +
> +
> +const struct vb2_ops mtk_vdec_vb2_ops;
> +
> +static struct mtk_video_fmt *mtk_vdec_find_format(struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < NUM_FORMATS; k++) {
> +		fmt = &mtk_video_formats[k];
> +		if (fmt->fourcc == f->fmt.pix_mp.pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct mtk_q_data *mtk_vdec_get_q_data(struct mtk_vcodec_ctx *ctx,
> +					      enum v4l2_buf_type type)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(type))
> +		return &ctx->q_data[MTK_Q_DATA_SRC];
> +
> +	return &ctx->q_data[MTK_Q_DATA_DST];
> +}
> +
> +static struct vb2_buffer *get_display_buffer(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct vdec_fb *disp_frame_buffer;
> +	struct vb2_queue *vq;
> +	struct mtk_video_buf *dstbuf;
> +	struct vdec_fb *frame_buffer;
> +
> +	mtk_v4l2_debug(3, "[%d]", ctx->idx);
> +	if (vdec_if_get_param(ctx,
> +				   GET_PARAM_DISP_FRAME_BUFFER,
> +				   &disp_frame_buffer)) {
> +		mtk_v4l2_err("[%d]Cannot get param : GET_PARAM_DISP_FRAME_BUFFER",
> +			     ctx->idx);
> +		return NULL;
> +	}
> +
> +	if (disp_frame_buffer == NULL) {
> +		mtk_v4l2_debug(3, "No display frame buffer");
> +		return NULL;
> +	}
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	if (!vq) {
> +		mtk_v4l2_err("Cannot find V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE queue!");
> +		return NULL;
> +	}
> +
> +	frame_buffer = disp_frame_buffer;
> +	dstbuf = container_of(frame_buffer, struct mtk_video_buf, frame_buffer);
> +	mutex_lock(&dstbuf->lock);
> +	if (dstbuf->used) {
> +		vb2_set_plane_payload(&dstbuf->vb.vb2_buf, 0,
> +							ctx->picinfo.y_bs_sz);
> +		vb2_set_plane_payload(&dstbuf->vb.vb2_buf, 1,
> +							ctx->picinfo.c_bs_sz);
> +
> +		dstbuf->ready_to_display = true;
> +		dstbuf->nonrealdisplay = false;
> +		mtk_v4l2_debug(2,
> +			       "[%d]status=%x queue idx=%d to done_list %d",
> +			       ctx->idx, frame_buffer->status,
> +			       dstbuf->vb.vb2_buf.index,
> +			       dstbuf->queued_in_vb2);
> +
> +		v4l2_m2m_buf_done(&dstbuf->vb, VB2_BUF_STATE_DONE);
> +		ctx->decoded_frame_cnt++;
> +	}
> +	mutex_unlock(&dstbuf->lock);
> +	return &dstbuf->vb.vb2_buf;
> +}
> +
> +static struct vb2_buffer *get_free_buffer(struct mtk_vcodec_ctx *ctx)
> +{
> +	void *tmp_frame_addr;
> +	struct vb2_queue *vq;
> +	struct mtk_video_buf *dstbuf;
> +	struct vdec_fb *frame_buffer;
> +
> +	if (vdec_if_get_param(ctx,
> +				   GET_PARAM_FREE_FRAME_BUFFER,
> +				   &tmp_frame_addr)) {
> +		mtk_v4l2_err("[%d] Error!! Cannot get param", ctx->idx);
> +		return NULL;
> +	}
> +	if (tmp_frame_addr == NULL) {
> +		mtk_v4l2_debug(3, " No free frame buffer");
> +		return NULL;
> +	}
> +
> +	mtk_v4l2_debug(3, "[%d] tmp_frame_addr = 0x%p",
> +			 ctx->idx, tmp_frame_addr);
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	if (!vq) {
> +		mtk_v4l2_err("Cannot find V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE queue!");
> +		return NULL;
> +	}
> +
> +	frame_buffer = tmp_frame_addr;
> +	dstbuf = container_of(frame_buffer, struct mtk_video_buf, frame_buffer);
> +
> +	mutex_lock(&dstbuf->lock);
> +	if (dstbuf->used) {
> +		if ((dstbuf->queued_in_vb2) &&
> +		    (dstbuf->queued_in_v4l2) &&
> +		    (frame_buffer->status == FB_ST_FREE)) {
> +			mtk_v4l2_debug(2,
> +				"[%d]status=%x queue idx=%d to rdy_queue %d",
> +				 ctx->idx, frame_buffer->status,
> +				 dstbuf->vb.vb2_buf.index,
> +				 dstbuf->queued_in_vb2);
> +			v4l2_m2m_buf_queue(ctx->m2m_ctx, &dstbuf->vb);
> +		} else if ((dstbuf->queued_in_vb2 == false) &&
> +			   (dstbuf->queued_in_v4l2 == true)) {
> +			mtk_v4l2_debug(2,
> +					 "[%d]status=%x queue idx=%d to rdy_queue",
> +					 ctx->idx, frame_buffer->status,
> +					 dstbuf->vb.vb2_buf.index);
> +			v4l2_m2m_buf_queue(ctx->m2m_ctx, &dstbuf->vb);
> +			dstbuf->queued_in_vb2 = true;
> +		} else {
> +			mtk_v4l2_debug(2,
> +					"[%d]status=%x err queue idx=%d %d %d",
> +					ctx->idx, frame_buffer->status,
> +					dstbuf->vb.vb2_buf.index,
> +					dstbuf->queued_in_vb2,
> +					dstbuf->queued_in_v4l2);
> +		}
> +		dstbuf->used = false;
> +	}
> +	mutex_unlock(&dstbuf->lock);
> +	return &dstbuf->vb.vb2_buf;
> +}
> +
> +static void clean_display_buffer(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct vb2_buffer *framptr;
> +
> +	do {
> +		framptr = get_display_buffer(ctx);
> +	} while (framptr);
> +}
> +
> +static void clean_free_buffer(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct vb2_buffer *framptr;
> +
> +	do {
> +		framptr = get_free_buffer(ctx);
> +	} while (framptr);
> +}
> +
> +static int mtk_vdec_queue_res_chg_event(struct mtk_vcodec_ctx *ctx)
> +{
> +	static const struct v4l2_event ev_src_ch = {
> +		.type = V4L2_EVENT_SOURCE_CHANGE,
> +		.u.src_change.changes =
> +		V4L2_EVENT_SRC_CH_RESOLUTION,
> +	};
> +
> +	mtk_v4l2_debug(1, "[%d]", ctx->idx);
> +	v4l2_event_queue_fh(&ctx->fh, &ev_src_ch);
> +
> +	return 0;
> +}
> +
> +static void mtk_vdec_flush_decoder(struct mtk_vcodec_ctx *ctx)
> +{
> +	bool res_chg;
> +	int ret = 0;
> +
> +	ret = vdec_if_decode(ctx, NULL, NULL, &res_chg);
> +	if (ret)
> +		mtk_v4l2_err("DecodeFinal failed");
> +
> +	clean_display_buffer(ctx);
> +	clean_free_buffer(ctx);
> +}
> +
> +static bool mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
> +{
> +	int dpbsize;
> +
> +	if (vdec_if_get_param(ctx,
> +				   GET_PARAM_PIC_INFO,
> +				   &ctx->last_decoded_picinfo)) {
> +		mtk_v4l2_err("[%d]Error!! Cannot get param : GET_PARAM_PICTURE_INFO ERR",
> +				ctx->idx);
> +		return false;
> +	}
> +
> +	if (ctx->last_decoded_picinfo.pic_w == 0 ||
> +		ctx->last_decoded_picinfo.pic_h == 0 ||
> +		ctx->last_decoded_picinfo.buf_w == 0 ||
> +		ctx->last_decoded_picinfo.buf_h == 0)
> +		return false;
> +
> +	if ((ctx->last_decoded_picinfo.pic_w != ctx->picinfo.pic_w) ||
> +	    (ctx->last_decoded_picinfo.pic_h != ctx->picinfo.pic_h)) {
> +
> +		mtk_v4l2_debug(1,
> +				"[%d]-> new(%d,%d), old(%d,%d), real(%d,%d)",
> +				 ctx->idx, ctx->last_decoded_picinfo.pic_w,
> +				 ctx->last_decoded_picinfo.pic_h,
> +				 ctx->picinfo.pic_w, ctx->picinfo.pic_h,
> +				 ctx->last_decoded_picinfo.buf_w,
> +				 ctx->last_decoded_picinfo.buf_h);
> +
> +		vdec_if_get_param(ctx, GET_PARAM_DPB_SIZE, &dpbsize);
> +		if (dpbsize == 0)
> +			dpbsize = 1;
> +		ctx->dpb_count = dpbsize;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +void mtk_vdec_worker(struct work_struct *work)
> +{
> +	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
> +				    decode_work);
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	struct mtk_vcodec_mem buf;
> +	struct vdec_fb *pfb;
> +	bool res_chg = false;
> +	int ret;
> +	struct mtk_video_buf *dst_buf_info, *src_buf_info;
> +	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	if (src_buf == NULL) {
> +		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
> +		mtk_v4l2_debug(1, "[%d] src_buf empty!!", ctx->idx);
> +		return;
> +	}
> +
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	if (dst_buf == NULL) {
> +		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
> +		mtk_v4l2_debug(1, "[%d] dst_buf empty!!", ctx->idx);
> +		return;
> +	}
> +
> +	src_vb2_v4l2 = container_of(src_buf, struct vb2_v4l2_buffer, vb2_buf);
> +	src_buf_info = container_of(src_vb2_v4l2, struct mtk_video_buf, vb);
> +
> +	dst_vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
> +	dst_buf_info = container_of(dst_vb2_v4l2, struct mtk_video_buf, vb);
> +
> +	buf.va = vb2_plane_vaddr(src_buf, 0);
> +	buf.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	buf.size = (unsigned int)src_buf->planes[0].bytesused;
> +	if (!buf.va) {
> +		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
> +		mtk_v4l2_err("[%d] idx=%d src_addr is NULL!!",
> +			       ctx->idx, src_buf->index);
> +		return;
> +	}
> +
> +	pfb = &dst_buf_info->frame_buffer;
> +	pfb->base_y.va = vb2_plane_vaddr(dst_buf, 0);
> +	pfb->base_y.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	pfb->base_y.size = ctx->picinfo.y_bs_sz + ctx->picinfo.y_len_sz;
> +
> +	pfb->base_c.va = vb2_plane_vaddr(dst_buf, 1);
> +	pfb->base_c.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 1);
> +	pfb->base_c.size = ctx->picinfo.c_bs_sz + ctx->picinfo.c_len_sz;
> +	pfb->status = 0;
> +	mtk_v4l2_debug(3, "===>[%d] vdec_if_decode() ===>", ctx->idx);
> +	mtk_v4l2_debug(3,
> +			 "[%d] Bitstream VA=%p DMA=%llx Size=0x%lx vb=%p",
> +			 ctx->idx, buf.va,
> +			 (u64)buf.dma_addr,
> +			 buf.size, src_buf);
> +
> +	mtk_v4l2_debug(3,
> +			"idx=%d Framebuf  pfb=%p VA=%p Y_DMA=%llx C_DMA=%llx Size=0x%lx",
> +			dst_buf->index, pfb,
> +			pfb->base_y.va, (u64)pfb->base_y.dma_addr,
> +			(u64)pfb->base_c.dma_addr, pfb->base_y.size);
> +
> +	if (src_buf_info->lastframe == true) {
> +		/* update src buf status */
> +		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		src_buf_info->lastframe = false;
> +		v4l2_m2m_buf_done(&src_buf_info->vb, VB2_BUF_STATE_DONE);
> +
> +		/* update dst buf status */
> +		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +		dst_buf_info->used = false;
> +
> +		clean_display_buffer(ctx);
> +		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 0, 0);
> +		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 1, 0);
> +		v4l2_m2m_buf_done(&dst_buf_info->vb, VB2_BUF_STATE_DONE);
> +		clean_free_buffer(ctx);
> +	} else {
> +
> +		dst_buf_info->vb.timestamp
> +					= src_buf_info->vb.timestamp;
> +		dst_buf_info->vb.timecode
> +					= src_buf_info->vb.timecode;
> +		mutex_lock(&dst_buf_info->lock);
> +		dst_buf_info->used = true;
> +		mutex_unlock(&dst_buf_info->lock);
> +		src_buf_info->used = true;
> +
> +		ret = vdec_if_decode(ctx, &buf, pfb, &res_chg);
> +
> +		if (ret) {
> +			mtk_v4l2_err(
> +				" <===[%d], src_buf[%d]%d sz=0x%zx pts=(%lu %lu) dst_buf[%d] vdec_if_decode() ret=%d res_chg=%d===>",
> +				ctx->idx,
> +				src_buf->index,
> +				src_buf_info->lastframe,
> +				buf.size,
> +				src_buf_info->vb.timestamp.tv_sec,
> +				src_buf_info->vb.timestamp.tv_usec,
> +				dst_buf->index,
> +				ret, res_chg);
> +			src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +			v4l2_m2m_buf_done(&src_buf_info->vb,
> +					VB2_BUF_STATE_ERROR);
> +		} else if (res_chg == false) {
> +			/* we only return src buffer with VB2_BUF_STATE_DONE
> +			  * when decode success without resolution change
> +			  */
> +			src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +			v4l2_m2m_buf_done(&src_buf_info->vb,
> +							VB2_BUF_STATE_DONE);
> +		}
> +
> +		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +		clean_display_buffer(ctx);
> +		clean_free_buffer(ctx);
> +
> +		if ((ret == 0) && (res_chg == true)) {
> +			mtk_vdec_pic_info_update(ctx);
> +			/*
> +			  * On encountering a resolution change in the stream.
> +			  * The driver must first process and decode all
> +			  * remaining buffers from before the resolution change
> +			  * point, so call flush decode here
> +			  */
> +			mtk_vdec_flush_decoder(ctx);
> +			/*
> +			  * After all buffers containing decoded frames from
> +			  * before the resolution change point ready to be
> +			  * dequeued on the CAPTURE queue, the driver sends a
> +			  * V4L2_EVENT_SOURCE_CHANGE event for source change
> +			  * type V4L2_EVENT_SRC_CH_RESOLUTION
> +			  */
> +			mtk_vdec_queue_res_chg_event(ctx);
> +		}
> +	}
> +
> +	v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
> +
> +}
> +
> +int mtk_vdec_unlock(struct mtk_vcodec_ctx *ctx)
> +{
> +	mutex_unlock(&ctx->dev->dec_mutex);
> +	return 0;
> +}
> +
> +int mtk_vdec_lock(struct mtk_vcodec_ctx *ctx)
> +{
> +	mutex_lock(&ctx->dev->dec_mutex);
> +	return 0;
> +}
> +
> +int m2mctx_vdec_queue_init(void *priv, struct vb2_queue *src_vq,
> +			   struct vb2_queue *dst_vq)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	int ret = 0;
> +
> +	mtk_v4l2_debug(3, "[%d]", ctx->idx);
> +
> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP;
> +	src_vq->drv_priv	= ctx;
> +	src_vq->buf_struct_size = sizeof(struct mtk_video_buf);
> +	src_vq->ops		= &mtk_vdec_vb2_ops;
> +	src_vq->mem_ops		= &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret) {
> +		mtk_v4l2_err("Failed to initialize videobuf2 queue(output)");
> +		return ret;
> +	}
> +	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP;
> +	dst_vq->drv_priv	= ctx;
> +	dst_vq->buf_struct_size = sizeof(struct mtk_video_buf);
> +	dst_vq->ops		= &mtk_vdec_vb2_ops;
> +	dst_vq->mem_ops		= &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
> +
> +	ret = vb2_queue_init(dst_vq);
> +	if (ret) {
> +		vb2_queue_release(src_vq);
> +		mtk_v4l2_err("Failed to initialize videobuf2 queue(capture)");
> +	}
> +
> +	return ret;
> +}
> +
> +void mtk_vcodec_vdec_release(struct mtk_vcodec_ctx *ctx)
> +{
> +	vdec_if_deinit(ctx);
> +	ctx->state = MTK_STATE_FREE;
> +}
> +
> +void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_q_data *q_data;
> +
> +	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
> +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
> +	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
> +	INIT_WORK(&ctx->decode_work, mtk_vdec_worker);
> +
> +	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
> +	memset(q_data, 0, sizeof(struct mtk_q_data));
> +	q_data->visible_width = DFT_CFG_WIDTH;
> +	q_data->visible_height = DFT_CFG_HEIGHT;
> +	q_data->fmt = &mtk_video_formats[OUT_FMT_IDX];
> +	q_data->colorspace = V4L2_COLORSPACE_REC709;
> +	q_data->field = V4L2_FIELD_NONE;
> +	ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] =
> +		DFT_CFG_WIDTH * DFT_CFG_HEIGHT;
> +	ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] = 0;
> +
> +
> +	q_data = &ctx->q_data[MTK_Q_DATA_DST];
> +	memset(q_data, 0, sizeof(struct mtk_q_data));
> +	q_data->visible_width = DFT_CFG_WIDTH;
> +	q_data->visible_height = DFT_CFG_HEIGHT;
> +	q_data->coded_width = DFT_CFG_WIDTH;
> +	q_data->coded_height = DFT_CFG_HEIGHT;
> +	q_data->colorspace = V4L2_COLORSPACE_REC709;
> +	q_data->field = V4L2_FIELD_NONE;
> +
> +	q_data->fmt = &mtk_video_formats[CAP_FMT_IDX];
> +
> +	v4l_bound_align_image(&q_data->coded_width,
> +					MTK_VDEC_MIN_W,
> +					MTK_VDEC_MAX_W, 4,
> +					&q_data->coded_height,
> +					MTK_VDEC_MIN_H,
> +					MTK_VDEC_MAX_H, 5, 6);
> +
> +	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
> +	q_data->bytesperline[0] = q_data->coded_width;
> +	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
> +	q_data->bytesperline[1] = q_data->coded_width;
> +
> +}
> +
> +static int vidioc_vdec_streamon(struct file *file, void *priv,
> +				enum v4l2_buf_type type)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	mtk_v4l2_debug(3, "[%d] (%d)", ctx->idx, type);
> +
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}
> +
> +static int vidioc_vdec_streamoff(struct file *file, void *priv,
> +				 enum v4l2_buf_type type)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	mtk_v4l2_debug(3, "[%d] (%d)", ctx->idx, type);
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +static int vidioc_vdec_reqbufs(struct file *file, void *priv,
> +			       struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	int ret;
> +
> +	mtk_v4l2_debug(3, "[%d] (%d) count=%d", ctx->idx,
> +			 reqbufs->type, reqbufs->count);
> +	ret = v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +
> +	return ret;
> +}

Please use the v4l2_m2m_ioctl_* helper functions were applicable.

> +
> +static int vidioc_vdec_querybuf(struct file *file, void *priv,
> +				struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	mtk_v4l2_debug(3, "[%d] (%d) id=%d", ctx->idx,
> +			 buf->type, buf->index);
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_vdec_qbuf(struct file *file, void *priv,
> +			    struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	struct vb2_buffer *vb;
> +	struct mtk_video_buf *mtkbuf;
> +	struct vb2_v4l2_buffer	*vb2_v4l2;
> +
> +	if (ctx->state == MTK_STATE_ABORT) {
> +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
> +					ctx->idx);
> +		return -EIO;
> +	}
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
> +	vb = vq->bufs[buf->index];
> +	vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> +	mtkbuf = container_of(vb2_v4l2, struct mtk_video_buf, vb);
> +
> +	if ((buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
> +	    (buf->m.planes[0].bytesused == 0)) {
> +		mtkbuf->lastframe = true;
> +		mtk_v4l2_debug(1, "[%d] (%d) id=%d lastframe=%d (%d,%d, %d) vb=%p",
> +			 ctx->idx, buf->type, buf->index,
> +			 mtkbuf->lastframe, buf->bytesused,
> +			 buf->m.planes[0].bytesused, buf->length,
> +			 vb);
> +	}
> +
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_vdec_dqbuf(struct file *file, void *priv,
> +			     struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->state == MTK_STATE_ABORT) {
> +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
> +					ctx->idx);
> +		return -EIO;
> +	}
> +
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_vdec_expbuf(struct file *file, void *priv,
> +			      struct v4l2_exportbuffer *eb)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
> +}
> +
> +static int vidioc_vdec_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, MTK_VCODEC_DEC_NAME, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
> +	strlcpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
> +	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

See my comment about the new device_caps field in struct video_device from my
review of the encoder driver.

> +
> +	return 0;
> +}
> +
> +static int vidioc_vdec_unsubscribe_evt(struct v4l2_fh *fh,
> +				     const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_EOS:
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_event_unsubscribe(fh, sub);
> +	default:
> +		return -EINVAL;
> +	}
> +}

No need for this function, just use v4l2_event_unsubscribe.

> +
> +static int vidioc_vdec_subscribe_evt(struct v4l2_fh *fh,
> +				     const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_EOS:
> +		return v4l2_event_subscribe(fh, sub, 2, NULL);
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subscribe(fh, sub);
> +	default:
> +		return -EINVAL;

Can't you just call v4l2_ctrl_subscribe_event() in the default case?

> +	}
> +}
> +
> +static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +
> +	fmt = mtk_vdec_find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = mtk_video_formats[CAP_FMT_IDX].fourcc;
> +		fmt = mtk_vdec_find_format(f);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +	struct mtk_video_fmt *fmt;
> +
> +	fmt = mtk_vdec_find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = mtk_video_formats[OUT_FMT_IDX].fourcc;
> +		fmt = mtk_vdec_find_format(f);
> +	}
> +
> +	if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
> +		mtk_v4l2_err("sizeimage of output format must be given");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_vdec_g_crop(struct file *file, void *priv,
> +			 struct v4l2_crop *cr)

Don't use g_crop, use g_selection instead. The selection API is a superset
of the old crop API.

> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->state < MTK_STATE_HEADER)
> +		return -EINVAL;
> +
> +	if ((ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc == V4L2_PIX_FMT_H264) ||
> +	    (ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc == V4L2_PIX_FMT_VP8) ||
> +	    (ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc == V4L2_PIX_FMT_VP9)) {
> +
> +		if (vdec_if_get_param(ctx,
> +					   GET_PARAM_CROP_INFO,
> +					   cr)) {
> +			mtk_v4l2_debug(2,
> +					 "[%d]Error!! Cannot get param : GET_PARAM_CROP_INFO ERR",
> +					 ctx->idx);
> +			cr->c.left = 0;
> +			cr->c.top = 0;
> +			cr->c.width = ctx->picinfo.buf_w;
> +			cr->c.height = ctx->picinfo.buf_h;
> +		}
> +		mtk_v4l2_debug(2, "Cropping info: l=%d t=%d w=%d h=%d",
> +				 cr->c.left, cr->c.top, cr->c.width,
> +				 cr->c.height);
> +	} else {
> +		cr->c.left = 0;
> +		cr->c.top = 0;
> +		cr->c.width = ctx->picinfo.pic_w;
> +		cr->c.height = ctx->picinfo.pic_h;
> +		mtk_v4l2_debug(2, "Cropping info: w=%d h=%d fw=%d fh=%d",
> +				 cr->c.width, cr->c.height, ctx->picinfo.buf_w,
> +				 ctx->picinfo.buf_h);
> +	}
> +	return 0;
> +}
> +
> +static int vidioc_vdec_s_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp;
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +	int ret;
> +	struct mtk_video_fmt *fmt;
> +
> +	mtk_v4l2_debug(3, "[%d]", ctx->idx);
> +
> +	fmt = mtk_vdec_find_format(f);
> +	if (fmt == NULL) {
> +		mtk_v4l2_err("mtk_venc_find_format fail");
> +		return ret;
> +	}
> +
> +	pix_mp = &f->fmt.pix_mp;
> +	if ((f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
> +	    vb2_is_busy(&ctx->m2m_ctx->out_q_ctx.q)) {
> +		mtk_v4l2_err("out_q_ctx buffers already requested");
> +		ret = -EBUSY;
> +	}
> +
> +	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
> +	    vb2_is_busy(&ctx->m2m_ctx->cap_q_ctx.q)) {
> +		mtk_v4l2_err("cap_q_ctx buffers already requested");
> +		ret = -EBUSY;
> +	}
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = mtk_vdec_get_q_data(ctx, f->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		q_data->fmt = fmt;
> +		q_data->sizeimage[0] = pix_mp->plane_fmt[0].sizeimage;
> +		pix_mp->plane_fmt[0].bytesperline = 0;
> +		pix_mp->width = 0;
> +		pix_mp->height = 0;
> +
> +		if (ctx->state == MTK_STATE_FREE) {
> +			ret = vdec_if_init(ctx, q_data->fmt->fourcc);
> +			if (ret) {
> +				mtk_v4l2_err("[%d]: vdec_if_init() fail ret=%d",
> +					       ctx->idx, ret);
> +				return -EINVAL;
> +			}
> +			ctx->state = MTK_STATE_INIT;
> +		}
> +	} else {
> +		q_data->fmt = fmt;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *priv,
> +				struct v4l2_frmsizeenum *fsize)
> +{
> +	int i = 0;
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (fsize->index != 0)
> +		return -EINVAL;
> +
> +	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
> +		if (fsize->pixel_format != mtk_vdec_framesizes[i].fourcc)
> +			continue;
> +
> +		fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +		fsize->stepwise = mtk_vdec_framesizes[i].stepwise;
> +		if (!(ctx->dev->dec_capability &
> +				VCODEC_CAPABILITY_4K_DISABLED)) {
> +			mtk_v4l2_debug(1, "4K is enabled");
> +			fsize->stepwise.max_width =
> +					VCODEC_DEC_4K_CODED_WIDTH;
> +			fsize->stepwise.max_height =
> +					VCODEC_DEC_4K_CODED_HEIGHT;
> +		}
> +		mtk_v4l2_debug(1, "%x, %d %d %d %d %d %d",
> +					ctx->dev->dec_capability,
> +					fsize->stepwise.min_width,
> +					fsize->stepwise.max_width,
> +					fsize->stepwise.step_width,
> +					fsize->stepwise.min_height,
> +					fsize->stepwise.max_height,
> +					fsize->stepwise.step_height);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +
> +}
> +
> +static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool output_queue)
> +{
> +	struct mtk_video_fmt *fmt;
> +	int i, j = 0;
> +
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		if (output_queue && (mtk_video_formats[i].type != MTK_FMT_DEC))
> +			continue;
> +		if (!output_queue &&
> +			(mtk_video_formats[i].type != MTK_FMT_FRAME))
> +			continue;
> +
> +		if (j == f->index)
> +			break;
> +		++j;
> +	}
> +
> +	if (i == NUM_FORMATS)
> +		return -EINVAL;
> +
> +	fmt = &mtk_video_formats[i];
> +	f->pixelformat = fmt->fourcc;
> +	f->flags = 0;

No need.

> +	memset(f->reserved, 0, sizeof(f->reserved));

No need. The core will automatically set flags and reserved.

> +
> +	if (mtk_video_formats[i].type != MTK_FMT_DEC)
> +		f->flags |= V4L2_FMT_FLAG_COMPRESSED;

No need for this, this is automatically done for you.

Note: to support VP9 the DocBook documentation has to be updated and so does v4l_fill_fmtdesc()
in drivers/media/v4l2-core/v4l2-ioctl.c

> +
> +	return 0;
> +}
> +
> +static int vidioc_vdec_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
> +					       struct v4l2_fmtdesc *f)
> +{
> +	return vidioc_enum_fmt(f, false);
> +}
> +
> +static int vidioc_vdec_enum_fmt_vid_out_mplane(struct file *file, void *priv,
> +					       struct v4l2_fmtdesc *f)
> +{
> +	return vidioc_enum_fmt(f, true);
> +}
> +
> +static int vidioc_vdec_g_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq) {
> +		mtk_v4l2_err("no vb2 queue for type=%d",
> +					   f->type);
> +		return -EINVAL;
> +	}
> +
> +	q_data = mtk_vdec_get_q_data(ctx, f->type);
> +
> +	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
> +	    (ctx->state >= MTK_STATE_HEADER)) {
> +		/* previous decode might have resolution change that make
> +		 * picinfo changed update context'x picinfo here to make sure
> +		 * we know what report to user space
> +		 */
> +		memcpy(&ctx->picinfo, &ctx->last_decoded_picinfo,
> +			sizeof(struct vdec_pic_info));
> +		q_data->sizeimage[0] = ctx->picinfo.y_bs_sz +
> +					ctx->picinfo.y_len_sz;
> +		q_data->sizeimage[1] = ctx->picinfo.c_bs_sz +
> +					ctx->picinfo.c_len_sz;
> +		q_data->bytesperline[0] = ctx->last_decoded_picinfo.buf_w;
> +		q_data->bytesperline[1] = ctx->last_decoded_picinfo.buf_w;
> +		q_data->coded_width = ctx->picinfo.buf_w;
> +		q_data->coded_height = ctx->picinfo.buf_h;
> +
> +		/*
> +		 * Width and height are set to the dimensions
> +		 * of the movie, the buffer is bigger and
> +		 * further processing stages should crop to this
> +		 * rectangle.
> +		 */
> +		pix_mp->width = q_data->coded_width;
> +		pix_mp->height = q_data->coded_height;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +
> +		/*
> +		 * Set pixelformat to the format in which mt vcodec
> +		 * outputs the decoded frame
> +		 */
> +		pix_mp->num_planes = q_data->fmt->num_planes;
> +		pix_mp->pixelformat = q_data->fmt->fourcc;
> +		pix_mp->plane_fmt[0].bytesperline = q_data->bytesperline[0];
> +		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
> +		pix_mp->plane_fmt[1].bytesperline = q_data->bytesperline[1];
> +		pix_mp->plane_fmt[1].sizeimage = q_data->sizeimage[1];
> +
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		/*
> +		 * This is run on OUTPUT
> +		 * The buffer contains compressed image
> +		 * so width and height have no meaning.
> +		 * Assign value here to pass v4l2-compliance test
> +		 */
> +		pix_mp->width = q_data->visible_width;
> +		pix_mp->height = q_data->visible_height;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +		pix_mp->plane_fmt[0].bytesperline = q_data->bytesperline[0];
> +		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
> +		pix_mp->pixelformat = q_data->fmt->fourcc;
> +		pix_mp->num_planes = q_data->fmt->num_planes;
> +	} else {
> +		pix_mp->width = q_data->coded_width;
> +		pix_mp->height = q_data->coded_height;
> +		pix_mp->field = V4L2_FIELD_NONE;
> +		pix_mp->num_planes = q_data->fmt->num_planes;
> +		pix_mp->pixelformat = q_data->fmt->fourcc;
> +		pix_mp->plane_fmt[0].bytesperline = q_data->bytesperline[0];
> +		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
> +		pix_mp->plane_fmt[1].bytesperline = q_data->bytesperline[1];
> +		pix_mp->plane_fmt[1].sizeimage = q_data->sizeimage[1];
> +
> +		mtk_v4l2_debug(1, "[%d] state=%d Format could not be read %d, not ready yet!",
> +				ctx->idx, ctx->state, f->type);
> +		return -EAGAIN;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vb2ops_vdec_queue_setup(struct vb2_queue *vq,
> +				   const void *parg,

Just like the encoder driver this patch needs to be rebased. The latest code no
longer has the parg argument.

> +				   unsigned int *nbuffers,
> +				   unsigned int *nplanes,
> +				   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct mtk_q_data *q_data;
> +
> +	q_data = mtk_vdec_get_q_data(ctx, vq->type);
> +
> +	switch (vq->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		*nplanes = 1;
> +
> +		sizes[0] = q_data->sizeimage[0];
> +		alloc_ctxs[0] = ctx->dev->alloc_ctx;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		if (ctx->state < MTK_STATE_HEADER)
> +			return -EINVAL;
> +
> +		/*
> +		 * Output plane count is 2 - one for Y and one for CbCr
> +		 */
> +		*nplanes = 2;
> +
> +		mtk_v4l2_debug(1,
> +				"[%d]\t get %d plane(s), ctx->dpb_count = %d, %d buffer(s)",
> +				ctx->idx, *nplanes, ctx->dpb_count, *nbuffers);
> +
> +		sizes[0] = q_data->sizeimage[0];
> +		sizes[1] = q_data->sizeimage[1];
> +		alloc_ctxs[0] = ctx->dev->alloc_ctx;
> +		alloc_ctxs[1] = ctx->dev->alloc_ctx;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	mtk_v4l2_debug(1,
> +			"[%d]\t type = %d, get %d plane(s), %d buffer(s) of size 0x%x 0x%x ",
> +			ctx->idx, vq->type, *nplanes, *nbuffers,
> +			sizes[0], sizes[1]);
> +
> +	return 0;
> +}
> +
> +static int vb2ops_vdec_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct mtk_q_data *q_data;
> +	int i;
> +
> +	mtk_v4l2_debug(3, "[%d] (%d) id=%d",
> +			 ctx->idx, vb->vb2_queue->type, vb->index);
> +
> +	q_data = mtk_vdec_get_q_data(ctx, vb->vb2_queue->type);
> +
> +	for (i = 0; i < q_data->fmt->num_planes; i++) {
> +		if (vb2_plane_size(vb, i) > q_data->sizeimage[i]) {
> +			mtk_v4l2_err("data will not fit into plane %d (%lu < %d)",
> +				       i, vb2_plane_size(vb, i),
> +				       q_data->sizeimage[i]);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vb2_v4l2 = container_of(vb,
> +					struct vb2_v4l2_buffer, vb2_buf);
> +	struct mtk_video_buf *buf = container_of(vb2_v4l2,
> +					struct mtk_video_buf, vb);
> +
> +	mtk_v4l2_debug(3, "[%d] (%d) id=%d, vb=%p",
> +			ctx->idx, vb->vb2_queue->type,
> +			vb->index, vb);
> +	/*
> +	 * check if this buffer is ready to be used after decode
> +	 */
> +	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		struct vb2_buffer *src_buf;
> +		struct mtk_vcodec_mem buf;
> +		bool res_chg = false;
> +		int ret = 0;
> +		int dpbsize = 1;
> +
> +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb2_v4l2);
> +
> +		if (ctx->state == MTK_STATE_INIT) {
> +			src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +			if (!src_buf) {
> +				mtk_v4l2_err("No src buffer");
> +				return;
> +			}
> +
> +			buf.va	= vb2_plane_vaddr(src_buf, 0);
> +			buf.dma_addr = vb2_dma_contig_plane_dma_addr(
> +							src_buf,
> +							0);
> +			buf.size = (size_t)src_buf->planes[0].bytesused;
> +			mtk_v4l2_debug(2,
> +					"[%d] buf idx=%d va=%p dma=%llx size=%zu",
> +					ctx->idx,
> +					src_buf->index,
> +					buf.va, (u64)buf.dma_addr, buf.size);
> +
> +			ret = vdec_if_decode(ctx, &buf, NULL, &res_chg);
> +			if (ret) {
> +				src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +				v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> +						VB2_BUF_STATE_DONE);
> +				mtk_v4l2_err("[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d",
> +						ctx->idx,
> +						src_buf->index,
> +						buf.size, ret);
> +				return;
> +			}
> +
> +			if (vdec_if_get_param(ctx,
> +						   GET_PARAM_PIC_INFO,
> +						   &ctx->picinfo)) {
> +				mtk_v4l2_err("[%d]Error!! Cannot get param : GET_PARAM_PICTURE_INFO ERR",
> +						ctx->idx);
> +				return;
> +			}
> +
> +			memcpy(&ctx->last_decoded_picinfo, &ctx->picinfo,
> +				sizeof(struct vdec_pic_info));
> +			ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] =
> +						ctx->picinfo.y_bs_sz +
> +						ctx->picinfo.y_len_sz;
> +			ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] =
> +							ctx->picinfo.buf_w;
> +			ctx->q_data[MTK_Q_DATA_DST].sizeimage[1] =
> +						ctx->picinfo.c_bs_sz +
> +						ctx->picinfo.c_len_sz;
> +			ctx->q_data[MTK_Q_DATA_DST].bytesperline[1] =
> +							ctx->picinfo.buf_w;
> +			mtk_v4l2_debug(2, "[%d] vdec_if_init() OK wxh=%dx%d pic wxh=%dx%d sz[0]=0x%x sz[1]=0x%x",
> +				ctx->idx,
> +				ctx->picinfo.buf_w, ctx->picinfo.buf_h,
> +				ctx->picinfo.pic_w, ctx->picinfo.pic_h,
> +				ctx->q_data[MTK_Q_DATA_DST].sizeimage[0],
> +				ctx->q_data[MTK_Q_DATA_DST].sizeimage[1]);
> +
> +			vdec_if_get_param(ctx, GET_PARAM_DPB_SIZE, &dpbsize);
> +			if (dpbsize == 0) {
> +				mtk_v4l2_debug(2,
> +						"[%d] vdec_if_get_param()  GET_PARAM_DPB_SIZE fail=%d",
> +						ctx->idx, ret);
> +				dpbsize = 1;
> +			}
> +			ctx->dpb_count = dpbsize;
> +			ctx->state = MTK_STATE_HEADER;
> +			mtk_v4l2_debug(1, "[%d] dpbsize=%d", ctx->idx,
> +							ctx->dpb_count);
> +		} else {
> +			mtk_v4l2_debug(1, "[%d] already init driver %d",
> +					 ctx->idx, ctx->state);
> +		}
> +
> +	} else {
> +		mutex_lock(&buf->lock);
> +		if (buf->used == false) {
> +			v4l2_m2m_buf_queue(ctx->m2m_ctx,
> +					to_vb2_v4l2_buffer(vb));
> +			buf->queued_in_vb2 = true;
> +			buf->queued_in_v4l2 = true;
> +			buf->ready_to_display = false;
> +		} else {
> +			buf->queued_in_vb2 = false;
> +			buf->queued_in_v4l2 = true;
> +			buf->ready_to_display = false;
> +		}
> +		mutex_unlock(&buf->lock);
> +	}
> +}
> +
> +static void vb2ops_vdec_buf_finish(struct vb2_buffer *vb)
> +{
> +	if (vb->vb2_queue->type ==
> +		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		struct vb2_v4l2_buffer *vb2_v4l2;
> +		struct mtk_video_buf *buf;
> +
> +		vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> +		buf = container_of(vb2_v4l2, struct mtk_video_buf, vb);
> +		mutex_lock(&buf->lock);
> +		buf->queued_in_v4l2 = false;
> +		buf->queued_in_vb2 = false;
> +		mutex_unlock(&buf->lock);
> +	}
> +}
> +
> +static int vb2ops_vdec_buf_init(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vb2_v4l2 = container_of(vb,
> +					struct vb2_v4l2_buffer, vb2_buf);
> +	struct mtk_video_buf *buf = container_of(vb2_v4l2,
> +					struct mtk_video_buf, vb);
> +
> +	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		buf->used = false;
> +		buf->ready_to_display = false;
> +		buf->nonrealdisplay = false;
> +		buf->queued_in_v4l2 = false;
> +		mutex_init(&buf->lock);
> +	} else {
> +		buf->lastframe = false;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vb2ops_vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +
> +	if (ctx->state == MTK_STATE_FLUSH)
> +		ctx->state = MTK_STATE_HEADER;
> +
> +	return 0;
> +}
> +
> +static void vb2ops_vdec_stop_streaming(struct vb2_queue *q)
> +{
> +	struct vb2_buffer *src_buf = NULL, *dst_buf = NULL;
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +
> +	mtk_v4l2_debug(1, "[%d] (%d) state=(%x) ctx->decoded_frame_cnt=%d",
> +			ctx->idx, q->type, ctx->state, ctx->decoded_frame_cnt);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		while (src_buf) {
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> +					VB2_BUF_STATE_ERROR);
> +			src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		}
> +	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		int i;
> +		struct vb2_v4l2_buffer *vb2_v4l2;
> +		struct mtk_video_buf *buf;
> +
> +		if (ctx->state >= MTK_STATE_HEADER)
> +			mtk_vdec_flush_decoder(ctx);
> +
> +		ctx->state = MTK_STATE_FLUSH;
> +
> +		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +		while (dst_buf) {
> +			vb2_set_plane_payload(dst_buf, 0, 0);
> +			vb2_set_plane_payload(dst_buf, 1, 0);
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
> +				VB2_BUF_STATE_ERROR);
> +			dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +		}
> +
> +		for (i = 0; i < q->num_buffers; ++i) {
> +			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
> +				vb2_v4l2 = container_of(q->bufs[i],
> +					struct vb2_v4l2_buffer, vb2_buf);
> +				buf = container_of(vb2_v4l2,
> +					struct mtk_video_buf, vb);
> +
> +				mtk_v4l2_debug(1, "[%d] idx=%d, type=%d, [%d %d] %d -> VB2_BUF_STATE_ERROR",
> +						ctx->idx, i, q->type,
> +						buf->queued_in_vb2,
> +						buf->queued_in_v4l2,
> +						(int)q->bufs[i]->state);
> +				v4l2_m2m_buf_done(vb2_v4l2,
> +						VB2_BUF_STATE_ERROR);
> +			}
> +		}
> +	}
> +}
> +
> +static void m2mops_vdec_device_run(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +
> +	queue_work(dev->decode_workqueue, &ctx->decode_work);
> +}
> +
> +static int m2mops_vdec_job_ready(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mtk_v4l2_debug(3, "[%d]", ctx->idx);
> +
> +	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx))
> +		return 0;
> +
> +	if (!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx))
> +		return 0;
> +
> +	if (ctx->state == MTK_STATE_ABORT)
> +		return 0;
> +
> +	if ((ctx->last_decoded_picinfo.pic_w != ctx->picinfo.pic_w) ||
> +	    (ctx->last_decoded_picinfo.pic_h != ctx->picinfo.pic_h))
> +		return 0;
> +
> +	if (ctx->state != MTK_STATE_HEADER)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static void m2mops_vdec_job_abort(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +
> +	ctx->state = MTK_STATE_ABORT;
> +}
> +
> +static int mtk_vdec_g_v_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
> +		if (ctx->state >= MTK_STATE_HEADER) {
> +			ctrl->val = ctx->dpb_count;
> +		} else {
> +			mtk_v4l2_err("Seqinfo not ready");
> +			ctrl->val = 1;
> +			return -EAGAIN;
> +		}
> +		break;
> +	default:
> +		mtk_v4l2_err("ctrl-id=%d not support!", ctrl->id);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops mtk_vcodec_dec_ctrl_ops = {
> +	.g_volatile_ctrl = mtk_vdec_g_v_ctrl,
> +};
> +
> +int mtk_vdec_ctrls_setup(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_hdl, 1);
> +
> +	ctrl = v4l2_ctrl_new_std(&ctx->ctrl_hdl,
> +					  &mtk_vcodec_dec_ctrl_ops,
> +					  V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
> +					  1, 32, 1, 1);
> +	ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +
> +	if (ctx->ctrl_hdl.error) {
> +		mtk_v4l2_err("Adding control failed %d",
> +					ctx->ctrl_hdl.error);
> +		return ctx->ctrl_hdl.error;
> +	}
> +
> +	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
> +	return 0;
> +}
> +
> +void mtk_vdec_ctrls_free(struct mtk_vcodec_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +}
> +
> +static void m2mops_vdec_lock(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mtk_v4l2_debug(3, "[%d]", ctx->idx);
> +	mutex_lock(&ctx->dev->dev_mutex);
> +}
> +
> +static void m2mops_vdec_unlock(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mtk_v4l2_debug(3, "[%d]", ctx->idx);
> +	mutex_unlock(&ctx->dev->dev_mutex);
> +}
> +
> +const struct v4l2_m2m_ops mtk_vdec_m2m_ops = {
> +	.device_run	= m2mops_vdec_device_run,
> +	.job_ready	= m2mops_vdec_job_ready,
> +	.job_abort	= m2mops_vdec_job_abort,
> +	.lock	= m2mops_vdec_lock,
> +	.unlock	= m2mops_vdec_unlock,
> +};
> +
> +const struct vb2_ops mtk_vdec_vb2_ops = {
> +	.queue_setup	= vb2ops_vdec_queue_setup,
> +	.buf_prepare	= vb2ops_vdec_buf_prepare,
> +	.buf_queue	= vb2ops_vdec_buf_queue,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +	.buf_init	= vb2ops_vdec_buf_init,
> +	.buf_finish	= vb2ops_vdec_buf_finish,
> +	.start_streaming	= vb2ops_vdec_start_streaming,
> +	.stop_streaming	= vb2ops_vdec_stop_streaming,
> +};
> +
> +const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops = {
> +	.vidioc_streamon	= vidioc_vdec_streamon,
> +	.vidioc_streamoff	= vidioc_vdec_streamoff,
> +
> +	.vidioc_reqbufs		= vidioc_vdec_reqbufs,
> +	.vidioc_querybuf	= vidioc_vdec_querybuf,
> +	.vidioc_qbuf	= vidioc_vdec_qbuf,
> +	.vidioc_expbuf	= vidioc_vdec_expbuf,
> +	.vidioc_dqbuf	= vidioc_vdec_dqbuf,
> +
> +	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
> +	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
> +
> +	.vidioc_s_fmt_vid_cap_mplane	= vidioc_vdec_s_fmt,
> +	.vidioc_s_fmt_vid_out_mplane	= vidioc_vdec_s_fmt,
> +	.vidioc_g_fmt_vid_cap_mplane	= vidioc_vdec_g_fmt,
> +	.vidioc_g_fmt_vid_out_mplane	= vidioc_vdec_g_fmt,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane	= vidioc_vdec_enum_fmt_vid_cap_mplane,
> +	.vidioc_enum_fmt_vid_out_mplane	= vidioc_vdec_enum_fmt_vid_out_mplane,
> +	.vidioc_enum_framesizes	= vidioc_enum_framesizes,
> +
> +	.vidioc_querycap	= vidioc_vdec_querycap,
> +	.vidioc_subscribe_event	= vidioc_vdec_subscribe_evt,
> +	.vidioc_unsubscribe_event	= vidioc_vdec_unsubscribe_evt,
> +	.vidioc_g_crop	= vidioc_vdec_g_crop,
> +};
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
> new file mode 100644
> index 0000000..cb5cb42
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
> @@ -0,0 +1,81 @@
> +/*
> +* Copyright (c) 2016 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#ifndef _MTK_VCODEC_DEC_H_
> +#define _MTK_VCODEC_DEC_H_
> +
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +/**
> + * struct vdec_fb  - decoder frame buffer
> + * @base_y	: Y plane memory info
> + * @base_c	: C plane memory info
> + * @status      : frame buffer status (vdec_fb_status)
> + */
> +struct vdec_fb {
> +	struct mtk_vcodec_mem	base_y;
> +	struct mtk_vcodec_mem	base_c;
> +	unsigned int	status;
> +};
> +
> +/**
> + * struct mtk_video_buf - Private data related to each VB2 buffer.
> + * @b:			VB2 buffer
> + * @list:			link list
> + * @used:		Output buffer contain decoded frame data
> + * @ready_to_display:	Output buffer not display yet
> + * @nonrealdisplay:	Output buffer is not display frame
> + * @queued_in_vb2:	Output buffer is queue in vb2
> + * @queued_in_v4l2:	Output buffer is in v4l2
> + * @lastframe:		Intput buffer is last buffer - EOS
> + * @frame_buffer:		Decode status of output buffer
> + * @lock:			V4L2 and decode thread should get mutex
> + *			before r/w info in mtk_video_buf
> + */
> +struct mtk_video_buf {
> +	struct vb2_v4l2_buffer	vb;
> +	struct list_head	list;
> +
> +	bool	used;
> +	bool	ready_to_display;
> +	bool	nonrealdisplay;
> +	bool	queued_in_vb2;
> +	bool	queued_in_v4l2;
> +	bool	lastframe;
> +	struct vdec_fb	frame_buffer;
> +	struct mutex	lock;
> +};
> +
> +extern const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops;
> +extern const struct v4l2_m2m_ops mtk_vdec_m2m_ops;
> +
> +
> +/*
> + * mtk_vdec_lock/mtk_vdec_unlock are for ctx instance to
> + * get/release lock before/after access decoder hw.
> + * mtk_vdec_lock get decoder hw lock and set curr_ctx
> + * to ctx instance that get lock
> + */
> +int mtk_vdec_unlock(struct mtk_vcodec_ctx *ctx);
> +int mtk_vdec_lock(struct mtk_vcodec_ctx *ctx);
> +int m2mctx_vdec_queue_init(void *priv, struct vb2_queue *src_vq,
> +			   struct vb2_queue *dst_vq);
> +void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx);
> +void mtk_vcodec_vdec_release(struct mtk_vcodec_ctx *ctx);
> +int mtk_vdec_ctrls_setup(struct mtk_vcodec_ctx *ctx);
> +void mtk_vdec_ctrls_free(struct mtk_vcodec_ctx *ctx);
> +
> +#endif /* _MTK_VCODEC_DEC_H_ */
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
> new file mode 100644
> index 0000000..34e3217
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
> @@ -0,0 +1,469 @@
> +/*
> +* Copyright (c) 2016 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "mtk_vcodec_drv.h"
> +#include "mtk_vcodec_dec.h"
> +#include "mtk_vcodec_dec_pm.h"
> +#include "mtk_vcodec_intr.h"
> +#include "mtk_vcodec_util.h"
> +#include "vdec_drv_if.h"
> +#include "mtk_vpu.h"
> +
> +module_param(mtk_v4l2_dbg_level, int, S_IRUGO | S_IWUSR);
> +module_param(mtk_vcodec_dbg, bool, S_IRUGO | S_IWUSR);
> +
> +#define VDEC_HW_ACTIVE	0x10
> +#define VDEC_IRQ_CFG	0x11
> +#define VDEC_IRQ_CLR	0x10
> +#define VDEC_IRQ_CFG_REG	0xa4
> +
> +
> +/* Wake up context wait_queue */
> +static void wake_up_ctx(struct mtk_vcodec_ctx *ctx, unsigned int reason)
> +{
> +	ctx->int_cond = 1;
> +	ctx->int_type = reason;
> +	wake_up_interruptible(&ctx->queue);
> +}
> +
> +static irqreturn_t mtk_vcodec_dec_irq_handler(int irq, void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	unsigned long flags;
> +	struct mtk_vcodec_ctx *ctx;
> +	unsigned int cg_status = 0;
> +	unsigned int dec_done_status = 0;
> +
> +	spin_lock_irqsave(&dev->irqlock, flags);
> +	ctx = dev->curr_ctx;
> +	spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +	cg_status = readl(dev->reg_base[0] + (0));
> +	if ((cg_status & VDEC_HW_ACTIVE) != 0) {
> +		mtk_v4l2_err("DEC ISR, VDEC active is not 0x0 (0x%08x)",
> +			       cg_status);
> +		return IRQ_HANDLED;
> +	}
> +
> +	dec_done_status = readl(dev->reg_base[1] + VDEC_IRQ_CFG_REG);
> +	ctx->irq_status = dec_done_status;
> +	if ((dec_done_status & (0x1 << 16)) != 0x10000)
> +		return IRQ_HANDLED;
> +
> +	/* clear interrupt */
> +	writel((readl(dev->reg_base[1] + VDEC_IRQ_CFG_REG) | VDEC_IRQ_CFG),
> +	       dev->reg_base[1] + VDEC_IRQ_CFG_REG);
> +	writel((readl(dev->reg_base[1] + VDEC_IRQ_CFG_REG) & ~VDEC_IRQ_CLR),
> +	       dev->reg_base[1] + VDEC_IRQ_CFG_REG);
> +
> +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> +
> +	mtk_v4l2_debug(3,
> +			"mtk_vcodec_dec_irq_handler :wake up ctx %d, dec_done_status=%x",
> +			ctx->idx, dec_done_status);
> +
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int fops_vcodec_open(struct file *file)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = NULL;
> +	int ret = 0;
> +
> +	if (dev->instance_mask == ~0UL) {
> +		mtk_v4l2_err("Too many open contexts");
> +		ret = -EBUSY;
> +		goto err_alloc;
> +	}
> +
> +	mutex_lock(&dev->dev_mutex);
> +
> +	ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	ctx->idx = ffz(dev->instance_mask);
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	INIT_LIST_HEAD(&ctx->list);
> +	ctx->dev = dev;
> +	init_waitqueue_head(&ctx->queue);
> +
> +	if (vfd == dev->vfd_dec) {
> +		ctx->type = MTK_INST_DECODER;
> +		ret = mtk_vdec_ctrls_setup(ctx);
> +		if (ret) {
> +			mtk_v4l2_err("Failed to setup mt vcodec controls");
> +			goto err_ctrls_setup;
> +		}
> +		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_dec, ctx,
> +						 &m2mctx_vdec_queue_init);
> +		if (IS_ERR(ctx->m2m_ctx)) {
> +			ret = PTR_ERR(ctx->m2m_ctx);
> +			mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)",
> +				       ret);
> +			goto err_ctx_init;
> +		}
> +		mtk_vcodec_dec_set_default_params(ctx);
> +	} else {
> +		mtk_v4l2_err("Invalid vfd !");
> +		ret = -ENOENT;
> +		goto err_ctx_init;
> +	}
> +
> +	if (v4l2_fh_is_singular(&ctx->fh)) {
> +		mtk_vcodec_dec_pw_on(&dev->pm);
> +		ret = vpu_load_firmware(dev->vpu_plat_dev);
> +		if (ret < 0) {
> +			mtk_v4l2_err("vpu_load_firmware failed!");
> +			goto err_load_fw;
> +		}
> +
> +		dev->dec_capability =
> +			vpu_get_vdec_hw_capa(dev->vpu_plat_dev);
> +		mtk_v4l2_debug(0, "decoder capability %x",
> +			       dev->dec_capability);
> +	}
> +
> +	set_bit(ctx->idx, &dev->instance_mask);
> +	dev->num_instances++;
> +	list_add(&ctx->list, &dev->ctx_list);
> +	mutex_unlock(&dev->dev_mutex);
> +	mtk_v4l2_debug(0, "%s decoder [%d]", dev_name(&dev->plat_dev->dev),
> +					ctx->idx);
> +
> +	return ret;
> +
> +	/* Deinit when failure occurred */
> +err_load_fw:
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +err_ctx_init:
> +	mtk_vdec_ctrls_free(ctx);
> +err_ctrls_setup:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	devm_kfree(&dev->plat_dev->dev, ctx);
> +err_alloc:
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return ret;
> +}
> +
> +static int fops_vcodec_release(struct file *file)
> +{
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	mtk_v4l2_debug(0, "[%d] decoder", ctx->idx);
> +
> +	mutex_lock(&dev->dev_mutex);
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	mtk_vcodec_vdec_release(ctx);
> +	mtk_vdec_ctrls_free(ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	list_del_init(&ctx->list);
> +	dev->num_instances--;
> +	if (dev->num_instances == 0)
> +		mtk_vcodec_dec_pw_off(&dev->pm);
> +	clear_bit(ctx->idx, &dev->instance_mask);
> +	devm_kfree(&dev->plat_dev->dev, ctx);
> +	mutex_unlock(&dev->dev_mutex);
> +	return 0;
> +}
> +
> +static unsigned int fops_vcodec_poll(struct file *file,
> +				     struct poll_table_struct *wait)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +	int ret;
> +
> +	mutex_lock(&dev->dev_mutex);
> +	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return ret;
> +}
> +
> +static int fops_vcodec_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +}
> +
> +static const struct v4l2_file_operations mtk_vcodec_fops = {
> +	.owner				= THIS_MODULE,
> +	.open				= fops_vcodec_open,
> +	.release			= fops_vcodec_release,
> +	.poll				= fops_vcodec_poll,
> +	.unlocked_ioctl			= video_ioctl2,
> +	.mmap				= fops_vcodec_mmap,

You should be able to use the v4l2_m2m_fop helper functions for poll and mmap.

> +};
> +
> +static void mtk_vcodec_dec_reset_handler(void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	struct mtk_vcodec_ctx *ctx;
> +
> +	mtk_v4l2_debug(0, "Watchdog timeout!!");
> +
> +	mutex_lock(&dev->dev_mutex);
> +	list_for_each_entry(ctx, &dev->ctx_list, list) {
> +		ctx->state = MTK_STATE_ABORT;
> +		mtk_v4l2_debug(0, "[%d] Change to state MTK_STATE_ERROR",
> +					   ctx->idx);
> +	}
> +	mutex_unlock(&dev->dev_mutex);
> +}
> +
> +static int mtk_vcodec_probe(struct platform_device *pdev)
> +{
> +	struct mtk_vcodec_dev *dev;
> +	struct video_device *vfd_dec;
> +	struct resource *res;
> +	int i, ret;
> +	int reg_base_num;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&dev->ctx_list);
> +	dev->plat_dev = pdev;
> +	dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
> +	if (dev->vpu_plat_dev == NULL) {
> +		mtk_v4l2_err("[VPU] vpu device in not ready");
> +		return -EPROBE_DEFER;
> +	}
> +
> +	vpu_wdt_reg_handler(dev->vpu_plat_dev, mtk_vcodec_dec_reset_handler,
> +				dev, VPU_RST_DEC);
> +
> +	ret = mtk_vcodec_init_dec_pm(dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to get mt vcodec clock source");
> +		return ret;
> +	}
> +
> +	reg_base_num = NUM_MAX_VDEC_REG_BASE;
> +	for (i = 0; i < reg_base_num; i++) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		if (res == NULL) {
> +			dev_err(&pdev->dev, "get memory resource failed.");
> +			ret = -ENXIO;
> +			goto err_res;
> +		}
> +		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(dev->reg_base[i])) {
> +			dev_err(&pdev->dev,
> +				"devm_ioremap_resource %d failed.", i);
> +			ret = PTR_ERR(dev->reg_base);
> +			goto err_res;
> +		}
> +		mtk_v4l2_debug(2, "reg[%d] base=%p", i, dev->reg_base[i]);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get irq resource");
> +		ret = -ENOENT;
> +		goto err_res;
> +	}
> +
> +	dev->dec_irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_irq(&pdev->dev, dev->dec_irq,
> +			       mtk_vcodec_dec_irq_handler, 0, pdev->name, dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to install dev->dec_irq %d (%d)",
> +			dev->dec_irq,
> +			ret);
> +		ret = -EINVAL;
> +		goto err_res;
> +	}
> +
> +	disable_irq(dev->dec_irq);
> +	mutex_init(&dev->dev_mutex);
> +	mutex_init(&dev->dec_mutex);
> +	spin_lock_init(&dev->irqlock);
> +
> +	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
> +		 "[MTK_V4L2]");
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret) {
> +		mtk_v4l2_err("v4l2_device_register err=%d", ret);
> +		return ret;
> +	}
> +
> +	init_waitqueue_head(&dev->queue);
> +
> +	vfd_dec = video_device_alloc();
> +	if (!vfd_dec) {
> +		mtk_v4l2_err("Failed to allocate video device");
> +		ret = -ENOMEM;
> +		goto err_dec_alloc;
> +	}
> +	vfd_dec->fops		= &mtk_vcodec_fops;
> +	vfd_dec->ioctl_ops	= &mtk_vdec_ioctl_ops;
> +	vfd_dec->release	= video_device_release;
> +	vfd_dec->lock		= &dev->dev_mutex;
> +	vfd_dec->v4l2_dev	= &dev->v4l2_dev;
> +	vfd_dec->vfl_dir	= VFL_DIR_M2M;
> +
> +	snprintf(vfd_dec->name, sizeof(vfd_dec->name), "%s",
> +		 MTK_VCODEC_DEC_NAME);
> +	video_set_drvdata(vfd_dec, dev);
> +	dev->vfd_dec = vfd_dec;
> +	platform_set_drvdata(pdev, dev);
> +
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		mtk_v4l2_err("Failed to alloc vb2 dma context 0");
> +		ret = PTR_ERR(dev->alloc_ctx);
> +		goto err_vb2_ctx_init;
> +	}
> +
> +	dev->m2m_dev_dec = v4l2_m2m_init(&mtk_vdec_m2m_ops);
> +	if (IS_ERR(dev->m2m_dev_dec)) {
> +		mtk_v4l2_err("Failed to init mem2mem dec device");
> +		ret = PTR_ERR(dev->m2m_dev_dec);
> +		goto err_dec_mem_init;
> +	}
> +
> +	dev->decode_workqueue =
> +			alloc_ordered_workqueue(MTK_VCODEC_DEC_NAME,
> +			WQ_MEM_RECLAIM | WQ_FREEZABLE);
> +	if (!dev->decode_workqueue) {
> +		mtk_v4l2_err("Failed to create decode workqueue");
> +		ret = -EINVAL;
> +		goto err_event_workq;
> +	}
> +
> +	ret = video_register_device(vfd_dec, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		mtk_v4l2_err("Failed to register video device");
> +		goto err_dec_reg;
> +	}
> +	mtk_v4l2_debug(0, "decoder registered as /dev/video%d",
> +			 vfd_dec->num);
> +
> +	return 0;
> +
> +err_dec_reg:
> +	destroy_workqueue(dev->decode_workqueue);
> +err_event_workq:
> +	v4l2_m2m_release(dev->m2m_dev_dec);
> +err_dec_mem_init:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +err_vb2_ctx_init:
> +	video_unregister_device(vfd_dec);
> +err_dec_alloc:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +err_res:
> +	mtk_vcodec_release_dec_pm(dev);
> +	return ret;
> +}
> +
> +static const struct of_device_id mtk_vcodec_match[] = {
> +	{.compatible = "mediatek,mt8173-vcodec-dec",},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, mtk_vcodec_match);
> +
> +static int mtk_vcodec_dec_remove(struct platform_device *pdev)
> +{
> +	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
> +
> +	mtk_v4l2_debug_enter();
> +	flush_workqueue(dev->decode_workqueue);
> +	destroy_workqueue(dev->decode_workqueue);
> +	if (dev->m2m_dev_dec)
> +		v4l2_m2m_release(dev->m2m_dev_dec);
> +	if (dev->alloc_ctx)
> +		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +
> +	if (dev->vfd_dec)
> +		video_unregister_device(dev->vfd_dec);
> +
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	mtk_vcodec_release_dec_pm(dev);
> +	return 0;
> +}
> +
> +static int mtk_vcodec_vdec_pm_runtime_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct mtk_vcodec_dev *m_dev = platform_get_drvdata(pdev);
> +
> +	mtk_v4l2_debug(3, "m_dev->num_instances=%d", m_dev->num_instances);
> +
> +	if (m_dev->num_instances == 0)
> +		return 0;
> +
> +	return 0;
> +}
> +
> +static int mtk_vcodec_vdec_pm_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct mtk_vcodec_dev *m_dev = platform_get_drvdata(pdev);
> +
> +	mtk_v4l2_debug(3, "m_dev->num_instances=%d", m_dev->num_instances);
> +
> +	if (m_dev->num_instances == 0)
> +		return 0;
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops mtk_vcodec_vdec_pm_ops = {
> +	SET_RUNTIME_PM_OPS(mtk_vcodec_vdec_pm_runtime_suspend,
> +			   mtk_vcodec_vdec_pm_runtime_resume,
> +			   NULL)
> +};
> +
> +static struct platform_driver mtk_vcodec_dec_driver = {
> +	.probe	= mtk_vcodec_probe,
> +	.remove	= mtk_vcodec_dec_remove,
> +	.driver	= {
> +		.name	= MTK_VCODEC_DEC_NAME,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = mtk_vcodec_match,
> +		.pm = &mtk_vcodec_vdec_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(mtk_vcodec_dec_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Mediatek video codec V4L2 driver");

Regards,

	Hans

