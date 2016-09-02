Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:29388 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753204AbcIBMUU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 08:20:20 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
        <Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v5 3/9] vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver
Date: Fri, 2 Sep 2016 20:19:54 +0800
Message-ID: <1472818800-22558-4-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1472818800-22558-3-git-send-email-tiffany.lin@mediatek.com>
References: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-2-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-3-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2 layer decoder driver for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/Makefile         |   12 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1433 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |   88 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  394 ++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |  205 +++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   28 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   62 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    8 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |    3 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   33 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |    5 +
 drivers/media/platform/mtk-vcodec/vdec_drv_base.h  |   55 +
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |  112 ++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  101 ++
 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h   |  103 ++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |  168 +++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   96 ++
 17 files changed, 2884 insertions(+), 22 deletions(-)
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h

diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
index dc5cb00..b54e823 100644
--- a/drivers/media/platform/mtk-vcodec/Makefile
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -1,7 +1,13 @@
 
-
-obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-enc.o mtk-vcodec-common.o
-
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-dec.o \
+				       mtk-vcodec-enc.o \
+				       mtk-vcodec-common.o
+
+mtk-vcodec-dec-y := mtk_vcodec_dec_drv.o \
+		vdec_drv_if.o \
+		vdec_vpu_if.o \
+		mtk_vcodec_dec.o \
+		mtk_vcodec_dec_pm.o \
 
 
 mtk-vcodec-enc-y := venc/venc_vp8_if.o \
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
new file mode 100644
index 0000000..d634e61
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -0,0 +1,1433 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_dec.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+#include "vdec_drv_if.h"
+#include "mtk_vcodec_dec_pm.h"
+
+#define OUT_FMT_IDX	0
+#define CAP_FMT_IDX	0
+
+#define MTK_VDEC_MIN_W	64U
+#define MTK_VDEC_MIN_H	64U
+#define DFT_CFG_WIDTH	MTK_VDEC_MIN_W
+#define DFT_CFG_HEIGHT	MTK_VDEC_MIN_H
+
+static struct mtk_video_fmt mtk_video_formats[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_H264,
+		.type = MTK_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_VP8,
+		.type = MTK_FMT_DEC,
+		.num_planes = 1,
+	},
+};
+
+static const struct mtk_codec_framesizes mtk_vdec_framesizes[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_H264,
+		.stepwise = {  MTK_VDEC_MIN_W, MTK_VDEC_MAX_W, 16,
+				MTK_VDEC_MIN_H, MTK_VDEC_MAX_H, 16 },
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_VP8,
+		.stepwise = {  MTK_VDEC_MIN_W, MTK_VDEC_MAX_W, 16,
+				MTK_VDEC_MIN_H, MTK_VDEC_MAX_H, 16 },
+	},
+};
+
+#define NUM_SUPPORTED_FRAMESIZE ARRAY_SIZE(mtk_vdec_framesizes)
+#define NUM_FORMATS ARRAY_SIZE(mtk_video_formats)
+
+static struct mtk_video_fmt *mtk_vdec_find_format(struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &mtk_video_formats[k];
+		if (fmt->fourcc == f->fmt.pix_mp.pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static struct mtk_q_data *mtk_vdec_get_q_data(struct mtk_vcodec_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	if (V4L2_TYPE_IS_OUTPUT(type))
+		return &ctx->q_data[MTK_Q_DATA_SRC];
+
+	return &ctx->q_data[MTK_Q_DATA_DST];
+}
+
+/*
+ * This function tries to clean all display buffers, the buffers will return
+ * in display order.
+ * Note the buffers returned from codec driver may still be in driver's
+ * reference list.
+ */
+static struct vb2_buffer *get_display_buffer(struct mtk_vcodec_ctx *ctx)
+{
+	struct vdec_fb *disp_frame_buffer = NULL;
+	struct mtk_video_dec_buf *dstbuf;
+
+	mtk_v4l2_debug(3, "[%d]", ctx->id);
+	if (vdec_if_get_param(ctx,
+			GET_PARAM_DISP_FRAME_BUFFER,
+			&disp_frame_buffer)) {
+		mtk_v4l2_err("[%d]Cannot get param : GET_PARAM_DISP_FRAME_BUFFER",
+			ctx->id);
+		return NULL;
+	}
+
+	if (disp_frame_buffer == NULL) {
+		mtk_v4l2_debug(3, "No display frame buffer");
+		return NULL;
+	}
+
+	dstbuf = container_of(disp_frame_buffer, struct mtk_video_dec_buf,
+				frame_buffer);
+	mutex_lock(&ctx->lock);
+	if (dstbuf->used) {
+		vb2_set_plane_payload(&dstbuf->vb.vb2_buf, 0,
+					ctx->picinfo.y_bs_sz);
+		vb2_set_plane_payload(&dstbuf->vb.vb2_buf, 1,
+					ctx->picinfo.c_bs_sz);
+
+		dstbuf->ready_to_display = true;
+
+		mtk_v4l2_debug(2,
+				"[%d]status=%x queue id=%d to done_list %d",
+				ctx->id, disp_frame_buffer->status,
+				dstbuf->vb.vb2_buf.index,
+				dstbuf->queued_in_vb2);
+
+		v4l2_m2m_buf_done(&dstbuf->vb, VB2_BUF_STATE_DONE);
+		ctx->decoded_frame_cnt++;
+	}
+	mutex_unlock(&ctx->lock);
+	return &dstbuf->vb.vb2_buf;
+}
+
+/*
+ * This function tries to clean all capture buffers that are not used as
+ * reference buffers by codec driver any more
+ * In this case, we need re-queue buffer to vb2 buffer if user space
+ * already returns this buffer to v4l2 or this buffer is just the output of
+ * previous sps/pps/resolution change decode, or do nothing if user
+ * space still owns this buffer
+ */
+static struct vb2_buffer *get_free_buffer(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_video_dec_buf *dstbuf;
+	struct vdec_fb *free_frame_buffer = NULL;
+
+	if (vdec_if_get_param(ctx,
+				GET_PARAM_FREE_FRAME_BUFFER,
+				&free_frame_buffer)) {
+		mtk_v4l2_err("[%d] Error!! Cannot get param", ctx->id);
+		return NULL;
+	}
+	if (free_frame_buffer == NULL) {
+		mtk_v4l2_debug(3, " No free frame buffer");
+		return NULL;
+	}
+
+	mtk_v4l2_debug(3, "[%d] tmp_frame_addr = 0x%p",
+			ctx->id, free_frame_buffer);
+
+	dstbuf = container_of(free_frame_buffer, struct mtk_video_dec_buf,
+				frame_buffer);
+
+	mutex_lock(&ctx->lock);
+	if (dstbuf->used) {
+		if ((dstbuf->queued_in_vb2) &&
+		    (dstbuf->queued_in_v4l2) &&
+		    (free_frame_buffer->status == FB_ST_FREE)) {
+			/*
+			 * After decode sps/pps or non-display buffer, we don't
+			 * need to return capture buffer to user space, but
+			 * just re-queue this capture buffer to vb2 queue.
+			 * This reduce overheads that dq/q unused capture
+			 * buffer. In this case, queued_in_vb2 = true.
+			 */
+			mtk_v4l2_debug(2,
+				"[%d]status=%x queue id=%d to rdy_queue %d",
+				ctx->id, free_frame_buffer->status,
+				dstbuf->vb.vb2_buf.index,
+				dstbuf->queued_in_vb2);
+			v4l2_m2m_buf_queue(ctx->m2m_ctx, &dstbuf->vb);
+		} else if ((dstbuf->queued_in_vb2 == false) &&
+			   (dstbuf->queued_in_v4l2 == true)) {
+			/*
+			 * If buffer in v4l2 driver but not in vb2 queue yet,
+			 * and we get this buffer from free_list, it means
+			 * that codec driver do not use this buffer as
+			 * reference buffer anymore. We should q buffer to vb2
+			 * queue, so later work thread could get this buffer
+			 * for decode. In this case, queued_in_vb2 = false
+			 * means this buffer is not from previous decode
+			 * output.
+			 */
+			mtk_v4l2_debug(2,
+					"[%d]status=%x queue id=%d to rdy_queue",
+					ctx->id, free_frame_buffer->status,
+					dstbuf->vb.vb2_buf.index);
+			v4l2_m2m_buf_queue(ctx->m2m_ctx, &dstbuf->vb);
+			dstbuf->queued_in_vb2 = true;
+		} else {
+			/*
+			 * Codec driver do not need to reference this capture
+			 * buffer and this buffer is not in v4l2 driver.
+			 * Then we don't need to do any thing, just add log when
+			 * we need to debug buffer flow.
+			 * When this buffer q from user space, it could
+			 * directly q to vb2 buffer
+			 */
+			mtk_v4l2_debug(3, "[%d]status=%x err queue id=%d %d %d",
+					ctx->id, free_frame_buffer->status,
+					dstbuf->vb.vb2_buf.index,
+					dstbuf->queued_in_vb2,
+					dstbuf->queued_in_v4l2);
+		}
+		dstbuf->used = false;
+	}
+	mutex_unlock(&ctx->lock);
+	return &dstbuf->vb.vb2_buf;
+}
+
+static void clean_display_buffer(struct mtk_vcodec_ctx *ctx)
+{
+	struct vb2_buffer *framptr;
+
+	do {
+		framptr = get_display_buffer(ctx);
+	} while (framptr);
+}
+
+static void clean_free_buffer(struct mtk_vcodec_ctx *ctx)
+{
+	struct vb2_buffer *framptr;
+
+	do {
+		framptr = get_free_buffer(ctx);
+	} while (framptr);
+}
+
+static void mtk_vdec_queue_res_chg_event(struct mtk_vcodec_ctx *ctx)
+{
+	static const struct v4l2_event ev_src_ch = {
+		.type = V4L2_EVENT_SOURCE_CHANGE,
+		.u.src_change.changes =
+		V4L2_EVENT_SRC_CH_RESOLUTION,
+	};
+
+	mtk_v4l2_debug(1, "[%d]", ctx->id);
+	v4l2_event_queue_fh(&ctx->fh, &ev_src_ch);
+}
+
+static void mtk_vdec_flush_decoder(struct mtk_vcodec_ctx *ctx)
+{
+	bool res_chg;
+	int ret = 0;
+
+	ret = vdec_if_decode(ctx, NULL, NULL, &res_chg);
+	if (ret)
+		mtk_v4l2_err("DecodeFinal failed, ret=%d", ret);
+
+	clean_display_buffer(ctx);
+	clean_free_buffer(ctx);
+}
+
+static void mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
+{
+	unsigned int dpbsize = 0;
+	int ret;
+
+	if (vdec_if_get_param(ctx,
+				GET_PARAM_PIC_INFO,
+				&ctx->last_decoded_picinfo)) {
+		mtk_v4l2_err("[%d]Error!! Cannot get param : GET_PARAM_PICTURE_INFO ERR",
+				ctx->id);
+		return;
+	}
+
+	if (ctx->last_decoded_picinfo.pic_w == 0 ||
+		ctx->last_decoded_picinfo.pic_h == 0 ||
+		ctx->last_decoded_picinfo.buf_w == 0 ||
+		ctx->last_decoded_picinfo.buf_h == 0) {
+		mtk_v4l2_err("Cannot get correct pic info");
+		return;
+	}
+
+	if ((ctx->last_decoded_picinfo.pic_w == ctx->picinfo.pic_w) ||
+	    (ctx->last_decoded_picinfo.pic_h == ctx->picinfo.pic_h))
+		return;
+
+	mtk_v4l2_debug(1,
+			"[%d]-> new(%d,%d), old(%d,%d), real(%d,%d)",
+			ctx->id, ctx->last_decoded_picinfo.pic_w,
+			ctx->last_decoded_picinfo.pic_h,
+			ctx->picinfo.pic_w, ctx->picinfo.pic_h,
+			ctx->last_decoded_picinfo.buf_w,
+			ctx->last_decoded_picinfo.buf_h);
+
+	ret = vdec_if_get_param(ctx, GET_PARAM_DPB_SIZE, &dpbsize);
+	if (dpbsize == 0)
+		mtk_v4l2_err("Incorrect dpb size, ret=%d", ret);
+
+	ctx->dpb_size = dpbsize;
+}
+
+static void mtk_vdec_worker(struct work_struct *work)
+{
+	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
+				decode_work);
+	struct mtk_vcodec_dev *dev = ctx->dev;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct mtk_vcodec_mem buf;
+	struct vdec_fb *pfb;
+	bool res_chg = false;
+	int ret;
+	struct mtk_video_dec_buf *dst_buf_info, *src_buf_info;
+	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	if (src_buf == NULL) {
+		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
+		mtk_v4l2_debug(1, "[%d] src_buf empty!!", ctx->id);
+		return;
+	}
+
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	if (dst_buf == NULL) {
+		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
+		mtk_v4l2_debug(1, "[%d] dst_buf empty!!", ctx->id);
+		return;
+	}
+
+	src_vb2_v4l2 = container_of(src_buf, struct vb2_v4l2_buffer, vb2_buf);
+	src_buf_info = container_of(src_vb2_v4l2, struct mtk_video_dec_buf, vb);
+
+	dst_vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
+	dst_buf_info = container_of(dst_vb2_v4l2, struct mtk_video_dec_buf, vb);
+
+	buf.va = vb2_plane_vaddr(src_buf, 0);
+	buf.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	buf.size = (size_t)src_buf->planes[0].bytesused;
+	if (!buf.va) {
+		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
+		mtk_v4l2_err("[%d] id=%d src_addr is NULL!!",
+				ctx->id, src_buf->index);
+		return;
+	}
+
+	pfb = &dst_buf_info->frame_buffer;
+	pfb->base_y.va = vb2_plane_vaddr(dst_buf, 0);
+	pfb->base_y.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	pfb->base_y.size = ctx->picinfo.y_bs_sz + ctx->picinfo.y_len_sz;
+
+	pfb->base_c.va = vb2_plane_vaddr(dst_buf, 1);
+	pfb->base_c.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 1);
+	pfb->base_c.size = ctx->picinfo.c_bs_sz + ctx->picinfo.c_len_sz;
+	pfb->status = 0;
+	mtk_v4l2_debug(3, "===>[%d] vdec_if_decode() ===>", ctx->id);
+	mtk_v4l2_debug(3, "[%d] Bitstream VA=%p DMA=%pad Size=%zx vb=%p",
+			ctx->id, buf.va, &buf.dma_addr, buf.size, src_buf);
+
+	mtk_v4l2_debug(3,
+			"id=%d Framebuf  pfb=%p VA=%p Y_DMA=%pad C_DMA=%pad Size=%zx",
+			dst_buf->index, pfb,
+			pfb->base_y.va, &pfb->base_y.dma_addr,
+			&pfb->base_c.dma_addr, pfb->base_y.size);
+
+	if (src_buf_info->lastframe) {
+		/* update src buf status */
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		src_buf_info->lastframe = false;
+		v4l2_m2m_buf_done(&src_buf_info->vb, VB2_BUF_STATE_DONE);
+
+		/* update dst buf status */
+		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		dst_buf_info->used = false;
+
+		vdec_if_decode(ctx, NULL, NULL, &res_chg);
+		clean_display_buffer(ctx);
+		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 0, 0);
+		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 1, 0);
+		v4l2_m2m_buf_done(&dst_buf_info->vb, VB2_BUF_STATE_DONE);
+		clean_free_buffer(ctx);
+		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
+		return;
+	}
+	dst_buf_info->vb.vb2_buf.timestamp
+			= src_buf_info->vb.vb2_buf.timestamp;
+	dst_buf_info->vb.timecode
+			= src_buf_info->vb.timecode;
+	mutex_lock(&ctx->lock);
+	dst_buf_info->used = true;
+	mutex_unlock(&ctx->lock);
+	src_buf_info->used = true;
+
+	ret = vdec_if_decode(ctx, &buf, pfb, &res_chg);
+
+	if (ret) {
+		mtk_v4l2_err(
+			" <===[%d], src_buf[%d]%d sz=0x%zx pts=%llu dst_buf[%d] vdec_if_decode() ret=%d res_chg=%d===>",
+			ctx->id,
+			src_buf->index,
+			src_buf_info->lastframe,
+			buf.size,
+			src_buf_info->vb.vb2_buf.timestamp,
+			dst_buf->index,
+			ret, res_chg);
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(&src_buf_info->vb, VB2_BUF_STATE_ERROR);
+	} else if (res_chg == false) {
+		/*
+		 * we only return src buffer with VB2_BUF_STATE_DONE
+		 * when decode success without resolution change
+		 */
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(&src_buf_info->vb, VB2_BUF_STATE_DONE);
+	}
+
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	clean_display_buffer(ctx);
+	clean_free_buffer(ctx);
+
+	if (!ret && res_chg) {
+		mtk_vdec_pic_info_update(ctx);
+		/*
+		 * On encountering a resolution change in the stream.
+		 * The driver must first process and decode all
+		 * remaining buffers from before the resolution change
+		 * point, so call flush decode here
+		 */
+		mtk_vdec_flush_decoder(ctx);
+		/*
+		 * After all buffers containing decoded frames from
+		 * before the resolution change point ready to be
+		 * dequeued on the CAPTURE queue, the driver sends a
+		 * V4L2_EVENT_SOURCE_CHANGE event for source change
+		 * type V4L2_EVENT_SRC_CH_RESOLUTION
+		 */
+		mtk_vdec_queue_res_chg_event(ctx);
+	}
+	v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
+}
+
+void mtk_vdec_unlock(struct mtk_vcodec_ctx *ctx)
+{
+	mutex_unlock(&ctx->dev->dec_mutex);
+}
+
+void mtk_vdec_lock(struct mtk_vcodec_ctx *ctx)
+{
+	mutex_lock(&ctx->dev->dec_mutex);
+}
+
+void mtk_vcodec_dec_release(struct mtk_vcodec_ctx *ctx)
+{
+	vdec_if_deinit(ctx);
+	ctx->state = MTK_STATE_FREE;
+}
+
+void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_q_data *q_data;
+
+	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
+	ctx->fh.m2m_ctx = ctx->m2m_ctx;
+	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
+	INIT_WORK(&ctx->decode_work, mtk_vdec_worker);
+	ctx->colorspace = V4L2_COLORSPACE_REC709;
+	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
+	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
+	memset(q_data, 0, sizeof(struct mtk_q_data));
+	q_data->visible_width = DFT_CFG_WIDTH;
+	q_data->visible_height = DFT_CFG_HEIGHT;
+	q_data->fmt = &mtk_video_formats[OUT_FMT_IDX];
+	q_data->field = V4L2_FIELD_NONE;
+
+	q_data->sizeimage[0] = DFT_CFG_WIDTH * DFT_CFG_HEIGHT;
+	q_data->bytesperline[0] = 0;
+
+	q_data = &ctx->q_data[MTK_Q_DATA_DST];
+	memset(q_data, 0, sizeof(struct mtk_q_data));
+	q_data->visible_width = DFT_CFG_WIDTH;
+	q_data->visible_height = DFT_CFG_HEIGHT;
+	q_data->coded_width = DFT_CFG_WIDTH;
+	q_data->coded_height = DFT_CFG_HEIGHT;
+	q_data->fmt = &mtk_video_formats[CAP_FMT_IDX];
+	q_data->field = V4L2_FIELD_NONE;
+
+	v4l_bound_align_image(&q_data->coded_width,
+				MTK_VDEC_MIN_W,
+				MTK_VDEC_MAX_W, 4,
+				&q_data->coded_height,
+				MTK_VDEC_MIN_H,
+				MTK_VDEC_MAX_H, 5, 6);
+
+	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
+	q_data->bytesperline[0] = q_data->coded_width;
+	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
+	q_data->bytesperline[1] = q_data->coded_width;
+}
+
+static int vidioc_vdec_qbuf(struct file *file, void *priv,
+			    struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq;
+	struct vb2_buffer *vb;
+	struct mtk_video_dec_buf *mtkbuf;
+	struct vb2_v4l2_buffer	*vb2_v4l2;
+
+	if (ctx->state == MTK_STATE_ABORT) {
+		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
+				ctx->id);
+		return -EIO;
+	}
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
+	vb = vq->bufs[buf->index];
+	vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
+	mtkbuf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
+
+	if ((buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+	    (buf->m.planes[0].bytesused == 0)) {
+		mtkbuf->lastframe = true;
+		mtk_v4l2_debug(1, "[%d] (%d) id=%d lastframe=%d (%d,%d, %d) vb=%p",
+			 ctx->id, buf->type, buf->index,
+			 mtkbuf->lastframe, buf->bytesused,
+			 buf->m.planes[0].bytesused, buf->length,
+			 vb);
+	}
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_vdec_dqbuf(struct file *file, void *priv,
+			     struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (ctx->state == MTK_STATE_ABORT) {
+		mtk_v4l2_err("[%d] Call on DQBUF after unrecoverable error",
+				ctx->id);
+		return -EIO;
+	}
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_vdec_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, MTK_VCODEC_DEC_NAME, sizeof(cap->driver));
+	strlcpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
+	strlcpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
+
+	return 0;
+}
+
+static int vidioc_vdec_subscribe_evt(struct v4l2_fh *fh,
+				     const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subscribe(fh, sub);
+	default:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	}
+}
+
+static int vidioc_try_fmt(struct v4l2_format *f, struct mtk_video_fmt *fmt)
+{
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	int i;
+
+	pix_fmt_mp->field = V4L2_FIELD_NONE;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		pix_fmt_mp->num_planes = 1;
+		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		int tmp_w, tmp_h;
+
+		pix_fmt_mp->height = clamp(pix_fmt_mp->height,
+					MTK_VDEC_MIN_H,
+					MTK_VDEC_MAX_H);
+		pix_fmt_mp->width = clamp(pix_fmt_mp->width,
+					MTK_VDEC_MIN_W,
+					MTK_VDEC_MAX_W);
+
+		/*
+		 * Find next closer width align 64, heign align 64, size align
+		 * 64 rectangle
+		 * Note: This only get default value, the real HW needed value
+		 *       only available when ctx in MTK_STATE_HEADER state
+		 */
+		tmp_w = pix_fmt_mp->width;
+		tmp_h = pix_fmt_mp->height;
+		v4l_bound_align_image(&pix_fmt_mp->width,
+					MTK_VDEC_MIN_W,
+					MTK_VDEC_MAX_W, 6,
+					&pix_fmt_mp->height,
+					MTK_VDEC_MIN_H,
+					MTK_VDEC_MAX_H, 6, 9);
+
+		if (pix_fmt_mp->width < tmp_w &&
+			(pix_fmt_mp->width + 64) <= MTK_VDEC_MAX_W)
+			pix_fmt_mp->width += 64;
+		if (pix_fmt_mp->height < tmp_h &&
+			(pix_fmt_mp->height + 64) <= MTK_VDEC_MAX_H)
+			pix_fmt_mp->height += 64;
+
+		mtk_v4l2_debug(0,
+			"before resize width=%d, height=%d, after resize width=%d, height=%d, sizeimage=%d",
+			tmp_w, tmp_h, pix_fmt_mp->width,
+			pix_fmt_mp->height,
+			pix_fmt_mp->width * pix_fmt_mp->height);
+
+		pix_fmt_mp->num_planes = fmt->num_planes;
+		pix_fmt_mp->plane_fmt[0].sizeimage =
+				pix_fmt_mp->width * pix_fmt_mp->height;
+		pix_fmt_mp->plane_fmt[0].bytesperline = pix_fmt_mp->width;
+
+		if (pix_fmt_mp->num_planes == 2) {
+			pix_fmt_mp->plane_fmt[1].sizeimage =
+				(pix_fmt_mp->width * pix_fmt_mp->height) / 2;
+			pix_fmt_mp->plane_fmt[1].bytesperline =
+				pix_fmt_mp->width;
+		}
+	}
+
+	for (i = 0; i < pix_fmt_mp->num_planes; i++)
+		memset(&(pix_fmt_mp->plane_fmt[i].reserved[0]), 0x0,
+			   sizeof(pix_fmt_mp->plane_fmt[0].reserved));
+
+	pix_fmt_mp->flags = 0;
+	memset(&pix_fmt_mp->reserved, 0x0, sizeof(pix_fmt_mp->reserved));
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+
+	fmt = mtk_vdec_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = mtk_video_formats[CAP_FMT_IDX].fourcc;
+		fmt = mtk_vdec_find_format(f);
+	}
+
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	struct mtk_video_fmt *fmt;
+
+	fmt = mtk_vdec_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = mtk_video_formats[OUT_FMT_IDX].fourcc;
+		fmt = mtk_vdec_find_format(f);
+	}
+
+	if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
+		mtk_v4l2_err("sizeimage of output format must be given");
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_vdec_g_selection(struct file *file, void *priv,
+			struct v4l2_selection *s)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct mtk_q_data *q_data;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	q_data = &ctx->q_data[MTK_Q_DATA_DST];
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = ctx->picinfo.pic_w;
+		s->r.height = ctx->picinfo.pic_h;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = ctx->picinfo.buf_w;
+		s->r.height = ctx->picinfo.buf_h;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (vdec_if_get_param(ctx, GET_PARAM_CROP_INFO, &(s->r))) {
+			/* set to default value if header info not ready yet*/
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = q_data->visible_width;
+			s->r.height = q_data->visible_height;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (ctx->state < MTK_STATE_HEADER) {
+		/* set to default value if header info not ready yet*/
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = q_data->visible_width;
+		s->r.height = q_data->visible_height;
+		return 0;
+	}
+
+	return 0;
+}
+
+static int vidioc_vdec_s_selection(struct file *file, void *priv,
+				struct v4l2_selection *s)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = ctx->picinfo.pic_w;
+		s->r.height = ctx->picinfo.pic_h;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_vdec_s_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp;
+	struct mtk_q_data *q_data;
+	int ret = 0;
+	struct mtk_video_fmt *fmt;
+
+	mtk_v4l2_debug(3, "[%d]", ctx->id);
+
+	q_data = mtk_vdec_get_q_data(ctx, f->type);
+	if (!q_data)
+		return -EINVAL;
+
+	pix_mp = &f->fmt.pix_mp;
+	if ((f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+	    vb2_is_busy(&ctx->m2m_ctx->out_q_ctx.q)) {
+		mtk_v4l2_err("out_q_ctx buffers already requested");
+		ret = -EBUSY;
+	}
+
+	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
+	    vb2_is_busy(&ctx->m2m_ctx->cap_q_ctx.q)) {
+		mtk_v4l2_err("cap_q_ctx buffers already requested");
+		ret = -EBUSY;
+	}
+
+	fmt = mtk_vdec_find_format(f);
+	if (fmt == NULL) {
+		if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			f->fmt.pix.pixelformat =
+				mtk_video_formats[OUT_FMT_IDX].fourcc;
+			fmt = mtk_vdec_find_format(f);
+		} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+			f->fmt.pix.pixelformat =
+				mtk_video_formats[CAP_FMT_IDX].fourcc;
+			fmt = mtk_vdec_find_format(f);
+		}
+	}
+
+	q_data->fmt = fmt;
+	vidioc_try_fmt(f, q_data->fmt);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		q_data->sizeimage[0] = pix_mp->plane_fmt[0].sizeimage;
+		q_data->coded_width = pix_mp->width;
+		q_data->coded_height = pix_mp->height;
+
+		ctx->colorspace = f->fmt.pix_mp.colorspace;
+		ctx->ycbcr_enc = f->fmt.pix_mp.ycbcr_enc;
+		ctx->quantization = f->fmt.pix_mp.quantization;
+		ctx->xfer_func = f->fmt.pix_mp.xfer_func;
+
+		if (ctx->state == MTK_STATE_FREE) {
+			ret = vdec_if_init(ctx, q_data->fmt->fourcc);
+			if (ret) {
+				mtk_v4l2_err("[%d]: vdec_if_init() fail ret=%d",
+					ctx->id, ret);
+				return -EINVAL;
+			}
+			ctx->state = MTK_STATE_INIT;
+		}
+	}
+
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				struct v4l2_frmsizeenum *fsize)
+{
+	int i = 0;
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
+		if (fsize->pixel_format != mtk_vdec_framesizes[i].fourcc)
+			continue;
+
+		fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+		fsize->stepwise = mtk_vdec_framesizes[i].stepwise;
+		if (!(ctx->dev->dec_capability &
+				VCODEC_CAPABILITY_4K_DISABLED)) {
+			mtk_v4l2_debug(3, "4K is enabled");
+			fsize->stepwise.max_width =
+					VCODEC_DEC_4K_CODED_WIDTH;
+			fsize->stepwise.max_height =
+					VCODEC_DEC_4K_CODED_HEIGHT;
+		}
+		mtk_v4l2_debug(1, "%x, %d %d %d %d %d %d",
+				ctx->dev->dec_capability,
+				fsize->stepwise.min_width,
+				fsize->stepwise.max_width,
+				fsize->stepwise.step_width,
+				fsize->stepwise.min_height,
+				fsize->stepwise.max_height,
+				fsize->stepwise.step_height);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool output_queue)
+{
+	struct mtk_video_fmt *fmt;
+	int i, j = 0;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (output_queue && (mtk_video_formats[i].type != MTK_FMT_DEC))
+			continue;
+		if (!output_queue &&
+			(mtk_video_formats[i].type != MTK_FMT_FRAME))
+			continue;
+
+		if (j == f->index)
+			break;
+		++j;
+	}
+
+	if (i == NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = &mtk_video_formats[i];
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+
+static int vidioc_vdec_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
+					       struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false);
+}
+
+static int vidioc_vdec_enum_fmt_vid_out_mplane(struct file *file, void *priv,
+					       struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true);
+}
+
+static int vidioc_vdec_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+	struct mtk_q_data *q_data;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq) {
+		mtk_v4l2_err("no vb2 queue for type=%d", f->type);
+		return -EINVAL;
+	}
+
+	q_data = mtk_vdec_get_q_data(ctx, f->type);
+
+	pix_mp->field = V4L2_FIELD_NONE;
+	pix_mp->colorspace = ctx->colorspace;
+	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
+	pix_mp->quantization = ctx->quantization;
+	pix_mp->xfer_func = ctx->xfer_func;
+
+	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
+	    (ctx->state >= MTK_STATE_HEADER)) {
+		/* Until STREAMOFF is called on the CAPTURE queue
+		 * (acknowledging the event), the driver operates as if
+		 * the resolution hasn't changed yet.
+		 * So we just return picinfo yet, and update picinfo in
+		 * stop_streaming hook function
+		 */
+		q_data->sizeimage[0] = ctx->picinfo.y_bs_sz +
+					ctx->picinfo.y_len_sz;
+		q_data->sizeimage[1] = ctx->picinfo.c_bs_sz +
+					ctx->picinfo.c_len_sz;
+		q_data->bytesperline[0] = ctx->last_decoded_picinfo.buf_w;
+		q_data->bytesperline[1] = ctx->last_decoded_picinfo.buf_w;
+		q_data->coded_width = ctx->picinfo.buf_w;
+		q_data->coded_height = ctx->picinfo.buf_h;
+
+		/*
+		 * Width and height are set to the dimensions
+		 * of the movie, the buffer is bigger and
+		 * further processing stages should crop to this
+		 * rectangle.
+		 */
+		pix_mp->width = q_data->coded_width;
+		pix_mp->height = q_data->coded_height;
+
+		/*
+		 * Set pixelformat to the format in which mt vcodec
+		 * outputs the decoded frame
+		 */
+		pix_mp->num_planes = q_data->fmt->num_planes;
+		pix_mp->pixelformat = q_data->fmt->fourcc;
+		pix_mp->plane_fmt[0].bytesperline = q_data->bytesperline[0];
+		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
+		pix_mp->plane_fmt[1].bytesperline = q_data->bytesperline[1];
+		pix_mp->plane_fmt[1].sizeimage = q_data->sizeimage[1];
+
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/*
+		 * This is run on OUTPUT
+		 * The buffer contains compressed image
+		 * so width and height have no meaning.
+		 * Assign value here to pass v4l2-compliance test
+		 */
+		pix_mp->width = q_data->visible_width;
+		pix_mp->height = q_data->visible_height;
+		pix_mp->plane_fmt[0].bytesperline = q_data->bytesperline[0];
+		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
+		pix_mp->pixelformat = q_data->fmt->fourcc;
+		pix_mp->num_planes = q_data->fmt->num_planes;
+	} else {
+		pix_mp->width = q_data->coded_width;
+		pix_mp->height = q_data->coded_height;
+		pix_mp->num_planes = q_data->fmt->num_planes;
+		pix_mp->pixelformat = q_data->fmt->fourcc;
+		pix_mp->plane_fmt[0].bytesperline = q_data->bytesperline[0];
+		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
+		pix_mp->plane_fmt[1].bytesperline = q_data->bytesperline[1];
+		pix_mp->plane_fmt[1].sizeimage = q_data->sizeimage[1];
+
+		mtk_v4l2_debug(1, "[%d] type=%d state=%d Format information could not be read, not ready yet!",
+				ctx->id, f->type, ctx->state);
+	}
+
+	return 0;
+}
+
+static int vb2ops_vdec_queue_setup(struct vb2_queue *vq,
+				unsigned int *nbuffers,
+				unsigned int *nplanes,
+				unsigned int sizes[],
+				struct device *alloc_devs[])
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mtk_q_data *q_data;
+	unsigned int i;
+
+	q_data = mtk_vdec_get_q_data(ctx, vq->type);
+
+	if (q_data == NULL) {
+		mtk_v4l2_err("vq->type=%d err\n", vq->type);
+		return -EINVAL;
+	}
+
+	if (*nplanes) {
+		for (i = 0; i < *nplanes; i++) {
+			if (sizes[i] < q_data->sizeimage[i])
+				return -EINVAL;
+		}
+	} else {
+		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+			*nplanes = 2;
+		else
+			*nplanes = 1;
+
+		for (i = 0; i < *nplanes; i++)
+			sizes[i] = q_data->sizeimage[i];
+	}
+
+	mtk_v4l2_debug(1,
+			"[%d]\t type = %d, get %d plane(s), %d buffer(s) of size 0x%x 0x%x ",
+			ctx->id, vq->type, *nplanes, *nbuffers,
+			sizes[0], sizes[1]);
+
+	return 0;
+}
+
+static int vb2ops_vdec_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mtk_q_data *q_data;
+	int i;
+
+	mtk_v4l2_debug(3, "[%d] (%d) id=%d",
+			ctx->id, vb->vb2_queue->type, vb->index);
+
+	q_data = mtk_vdec_get_q_data(ctx, vb->vb2_queue->type);
+
+	for (i = 0; i < q_data->fmt->num_planes; i++) {
+		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
+			mtk_v4l2_err("data will not fit into plane %d (%lu < %d)",
+				i, vb2_plane_size(vb, i),
+				q_data->sizeimage[i]);
+		}
+	}
+
+	return 0;
+}
+
+static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_buffer *src_buf;
+	struct mtk_vcodec_mem src_mem;
+	bool res_chg = false;
+	int ret = 0;
+	unsigned int dpbsize = 1;
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vb2_v4l2 = container_of(vb,
+				struct vb2_v4l2_buffer, vb2_buf);
+	struct mtk_video_dec_buf *buf = container_of(vb2_v4l2,
+				struct mtk_video_dec_buf, vb);
+
+	mtk_v4l2_debug(3, "[%d] (%d) id=%d, vb=%p",
+			ctx->id, vb->vb2_queue->type,
+			vb->index, vb);
+	/*
+	 * check if this buffer is ready to be used after decode
+	 */
+	if (vb->vb2_queue->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mutex_lock(&ctx->lock);
+		if (buf->used == false) {
+			v4l2_m2m_buf_queue(ctx->m2m_ctx,
+					to_vb2_v4l2_buffer(vb));
+			buf->queued_in_vb2 = true;
+			buf->queued_in_v4l2 = true;
+			buf->ready_to_display = false;
+		} else {
+			buf->queued_in_vb2 = false;
+			buf->queued_in_v4l2 = true;
+			buf->ready_to_display = false;
+		}
+		mutex_unlock(&ctx->lock);
+		return;
+	}
+
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb2_v4l2);
+
+	if (ctx->state != MTK_STATE_INIT) {
+		mtk_v4l2_debug(3, "[%d] already init driver %d",
+				ctx->id, ctx->state);
+		return;
+	}
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	if (!src_buf) {
+		mtk_v4l2_err("No src buffer");
+		return;
+	}
+
+	src_mem.va = vb2_plane_vaddr(src_buf, 0);
+	src_mem.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	src_mem.size = (size_t)src_buf->planes[0].bytesused;
+	mtk_v4l2_debug(2,
+			"[%d] buf id=%d va=%p dma=%pad size=%zx",
+			ctx->id, src_buf->index,
+			src_mem.va, &src_mem.dma_addr,
+			src_mem.size);
+
+	ret = vdec_if_decode(ctx, &src_mem, NULL, &res_chg);
+	if (ret || !res_chg) {
+		/*
+		 * fb == NULL menas to parse SPS/PPS header or
+		 * resolution info in src_mem. Decode can fail
+		 * if there is no SPS header or picture info
+		 * in bs
+		 */
+		int log_level = ret ? 0 : 1;
+
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
+					VB2_BUF_STATE_DONE);
+		mtk_v4l2_debug(log_level,
+				"[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
+				ctx->id, src_buf->index,
+				src_mem.size, ret, res_chg);
+		return;
+	}
+
+	if (vdec_if_get_param(ctx, GET_PARAM_PIC_INFO, &ctx->picinfo)) {
+		mtk_v4l2_err("[%d]Error!! Cannot get param : GET_PARAM_PICTURE_INFO ERR",
+				ctx->id);
+		return;
+	}
+
+	ctx->last_decoded_picinfo = ctx->picinfo;
+	ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] =
+						ctx->picinfo.y_bs_sz +
+						ctx->picinfo.y_len_sz;
+	ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] =
+						ctx->picinfo.buf_w;
+	ctx->q_data[MTK_Q_DATA_DST].sizeimage[1] =
+						ctx->picinfo.c_bs_sz +
+						ctx->picinfo.c_len_sz;
+	ctx->q_data[MTK_Q_DATA_DST].bytesperline[1] = ctx->picinfo.buf_w;
+	mtk_v4l2_debug(2, "[%d] vdec_if_init() OK wxh=%dx%d pic wxh=%dx%d sz[0]=0x%x sz[1]=0x%x",
+			ctx->id,
+			ctx->picinfo.buf_w, ctx->picinfo.buf_h,
+			ctx->picinfo.pic_w, ctx->picinfo.pic_h,
+			ctx->q_data[MTK_Q_DATA_DST].sizeimage[0],
+			ctx->q_data[MTK_Q_DATA_DST].sizeimage[1]);
+
+	ret = vdec_if_get_param(ctx, GET_PARAM_DPB_SIZE, &dpbsize);
+	if (dpbsize == 0)
+		mtk_v4l2_err("[%d] GET_PARAM_DPB_SIZE fail=%d", ctx->id, ret);
+
+	ctx->dpb_size = dpbsize;
+	ctx->state = MTK_STATE_HEADER;
+	mtk_v4l2_debug(1, "[%d] dpbsize=%d", ctx->id, ctx->dpb_size);
+}
+
+static void vb2ops_vdec_buf_finish(struct vb2_buffer *vb)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vb2_v4l2;
+	struct mtk_video_dec_buf *buf;
+
+	if (vb->vb2_queue->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return;
+
+	vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
+	buf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
+	mutex_lock(&ctx->lock);
+	buf->queued_in_v4l2 = false;
+	buf->queued_in_vb2 = false;
+	mutex_unlock(&ctx->lock);
+}
+
+static int vb2ops_vdec_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vb2_v4l2 = container_of(vb,
+					struct vb2_v4l2_buffer, vb2_buf);
+	struct mtk_video_dec_buf *buf = container_of(vb2_v4l2,
+					struct mtk_video_dec_buf, vb);
+
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		buf->used = false;
+		buf->ready_to_display = false;
+		buf->queued_in_v4l2 = false;
+	} else {
+		buf->lastframe = false;
+	}
+
+	return 0;
+}
+
+static int vb2ops_vdec_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
+
+	if (ctx->state == MTK_STATE_FLUSH)
+		ctx->state = MTK_STATE_HEADER;
+
+	return 0;
+}
+
+static void vb2ops_vdec_stop_streaming(struct vb2_queue *q)
+{
+	struct vb2_buffer *src_buf = NULL, *dst_buf = NULL;
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
+
+	mtk_v4l2_debug(3, "[%d] (%d) state=(%x) ctx->decoded_frame_cnt=%d",
+			ctx->id, q->type, ctx->state, ctx->decoded_frame_cnt);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
+			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
+					VB2_BUF_STATE_ERROR);
+		return;
+	}
+
+	if (ctx->state >= MTK_STATE_HEADER) {
+
+		/* Until STREAMOFF is called on the CAPTURE queue
+		 * (acknowledging the event), the driver operates
+		 * as if the resolution hasn't changed yet, i.e.
+		 * VIDIOC_G_FMT< etc. return previous resolution.
+		 * So we update picinfo here
+		 */
+		ctx->picinfo = ctx->last_decoded_picinfo;
+
+		mtk_v4l2_debug(2,
+				"[%d]-> new(%d,%d), old(%d,%d), real(%d,%d)",
+				ctx->id, ctx->last_decoded_picinfo.pic_w,
+				ctx->last_decoded_picinfo.pic_h,
+				ctx->picinfo.pic_w, ctx->picinfo.pic_h,
+				ctx->last_decoded_picinfo.buf_w,
+				ctx->last_decoded_picinfo.buf_h);
+
+		mtk_vdec_flush_decoder(ctx);
+	}
+	ctx->state = MTK_STATE_FLUSH;
+
+	while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
+		vb2_set_plane_payload(dst_buf, 0, 0);
+		vb2_set_plane_payload(dst_buf, 1, 0);
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
+					VB2_BUF_STATE_ERROR);
+	}
+
+}
+
+static void m2mops_vdec_device_run(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+	struct mtk_vcodec_dev *dev = ctx->dev;
+
+	queue_work(dev->decode_workqueue, &ctx->decode_work);
+}
+
+static int m2mops_vdec_job_ready(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mtk_v4l2_debug(3, "[%d]", ctx->id);
+
+	if (ctx->state == MTK_STATE_ABORT)
+		return 0;
+
+	if ((ctx->last_decoded_picinfo.pic_w != ctx->picinfo.pic_w) ||
+	    (ctx->last_decoded_picinfo.pic_h != ctx->picinfo.pic_h))
+		return 0;
+
+	if (ctx->state != MTK_STATE_HEADER)
+		return 0;
+
+	return 1;
+}
+
+static void m2mops_vdec_job_abort(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+
+	ctx->state = MTK_STATE_ABORT;
+}
+
+static int mtk_vdec_g_v_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
+		if (ctx->state >= MTK_STATE_HEADER) {
+			ctrl->val = ctx->dpb_size;
+		} else {
+			mtk_v4l2_debug(0, "Seqinfo not ready");
+			ctrl->val = 0;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops mtk_vcodec_dec_ctrl_ops = {
+	.g_volatile_ctrl = mtk_vdec_g_v_ctrl,
+};
+
+int mtk_vcodec_dec_ctrls_setup(struct mtk_vcodec_ctx *ctx)
+{
+	struct v4l2_ctrl *ctrl;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_hdl, 1);
+
+	ctrl = v4l2_ctrl_new_std(&ctx->ctrl_hdl,
+				&mtk_vcodec_dec_ctrl_ops,
+				V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
+				0, 32, 1, 1);
+	ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	if (ctx->ctrl_hdl.error) {
+		mtk_v4l2_err("Adding control failed %d",
+				ctx->ctrl_hdl.error);
+		return ctx->ctrl_hdl.error;
+	}
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
+	return 0;
+}
+
+static void m2mops_vdec_lock(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mtk_v4l2_debug(3, "[%d]", ctx->id);
+	mutex_lock(&ctx->dev->dev_mutex);
+}
+
+static void m2mops_vdec_unlock(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mtk_v4l2_debug(3, "[%d]", ctx->id);
+	mutex_unlock(&ctx->dev->dev_mutex);
+}
+
+const struct v4l2_m2m_ops mtk_vdec_m2m_ops = {
+	.device_run	= m2mops_vdec_device_run,
+	.job_ready	= m2mops_vdec_job_ready,
+	.job_abort	= m2mops_vdec_job_abort,
+	.lock		= m2mops_vdec_lock,
+	.unlock		= m2mops_vdec_unlock,
+};
+
+static const struct vb2_ops mtk_vdec_vb2_ops = {
+	.queue_setup	= vb2ops_vdec_queue_setup,
+	.buf_prepare	= vb2ops_vdec_buf_prepare,
+	.buf_queue	= vb2ops_vdec_buf_queue,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
+	.buf_init	= vb2ops_vdec_buf_init,
+	.buf_finish	= vb2ops_vdec_buf_finish,
+	.start_streaming	= vb2ops_vdec_start_streaming,
+	.stop_streaming	= vb2ops_vdec_stop_streaming,
+};
+
+const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops = {
+	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
+	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
+	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
+
+	.vidioc_qbuf		= vidioc_vdec_qbuf,
+	.vidioc_dqbuf		= vidioc_vdec_dqbuf,
+
+	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
+
+	.vidioc_s_fmt_vid_cap_mplane	= vidioc_vdec_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane	= vidioc_vdec_s_fmt,
+	.vidioc_g_fmt_vid_cap_mplane	= vidioc_vdec_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane	= vidioc_vdec_g_fmt,
+
+	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= vidioc_vdec_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= vidioc_vdec_enum_fmt_vid_out_mplane,
+	.vidioc_enum_framesizes	= vidioc_enum_framesizes,
+
+	.vidioc_querycap		= vidioc_vdec_querycap,
+	.vidioc_subscribe_event		= vidioc_vdec_subscribe_evt,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+	.vidioc_g_selection             = vidioc_vdec_g_selection,
+	.vidioc_s_selection             = vidioc_vdec_s_selection,
+};
+
+int mtk_vcodec_dec_queue_init(void *priv, struct vb2_queue *src_vq,
+			   struct vb2_queue *dst_vq)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+	int ret = 0;
+
+	mtk_v4l2_debug(3, "[%d]", ctx->id);
+
+	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP;
+	src_vq->drv_priv	= ctx;
+	src_vq->buf_struct_size = sizeof(struct mtk_video_dec_buf);
+	src_vq->ops		= &mtk_vdec_vb2_ops;
+	src_vq->mem_ops		= &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock		= &ctx->dev->dev_mutex;
+	src_vq->dev             = &ctx->dev->plat_dev->dev;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret) {
+		mtk_v4l2_err("Failed to initialize videobuf2 queue(output)");
+		return ret;
+	}
+	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP;
+	dst_vq->drv_priv	= ctx;
+	dst_vq->buf_struct_size = sizeof(struct mtk_video_dec_buf);
+	dst_vq->ops		= &mtk_vdec_vb2_ops;
+	dst_vq->mem_ops		= &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock		= &ctx->dev->dev_mutex;
+	dst_vq->dev             = &ctx->dev->plat_dev->dev;
+
+	ret = vb2_queue_init(dst_vq);
+	if (ret) {
+		vb2_queue_release(src_vq);
+		mtk_v4l2_err("Failed to initialize videobuf2 queue(capture)");
+	}
+
+	return ret;
+}
+
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
new file mode 100644
index 0000000..fe31193
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
@@ -0,0 +1,88 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VCODEC_DEC_H_
+#define _MTK_VCODEC_DEC_H_
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
+
+#define VCODEC_CAPABILITY_4K_DISABLED	0x10
+#define VCODEC_DEC_4K_CODED_WIDTH	4096U
+#define VCODEC_DEC_4K_CODED_HEIGHT	2304U
+#define MTK_VDEC_MAX_W	2048U
+#define MTK_VDEC_MAX_H	1088U
+
+#define MTK_VDEC_IRQ_STATUS_DEC_SUCCESS        0x10000
+
+/**
+ * struct vdec_fb  - decoder frame buffer
+ * @base_y	: Y plane memory info
+ * @base_c	: C plane memory info
+ * @status      : frame buffer status (vdec_fb_status)
+ */
+struct vdec_fb {
+	struct mtk_vcodec_mem	base_y;
+	struct mtk_vcodec_mem	base_c;
+	unsigned int	status;
+};
+
+/**
+ * struct mtk_video_dec_buf - Private data related to each VB2 buffer.
+ * @b:		VB2 buffer
+ * @list:	link list
+ * @used:	Capture buffer contain decoded frame data and keep in
+ *			codec data structure
+ * @ready_to_display:	Capture buffer not display yet
+ * @queued_in_vb2:	Capture buffer is queue in vb2
+ * @queued_in_v4l2:	Capture buffer is in v4l2 driver, but not in vb2
+ *			queue yet
+ * @lastframe:		Intput buffer is last buffer - EOS
+ * @frame_buffer:	Decode status, and buffer information of Capture buffer
+ *
+ * Note : These status information help us track and debug buffer state
+ */
+struct mtk_video_dec_buf {
+	struct vb2_v4l2_buffer	vb;
+	struct list_head	list;
+
+	bool	used;
+	bool	ready_to_display;
+	bool	queued_in_vb2;
+	bool	queued_in_v4l2;
+	bool	lastframe;
+	struct vdec_fb	frame_buffer;
+};
+
+extern const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops;
+extern const struct v4l2_m2m_ops mtk_vdec_m2m_ops;
+
+
+/*
+ * mtk_vdec_lock/mtk_vdec_unlock are for ctx instance to
+ * get/release lock before/after access decoder hw.
+ * mtk_vdec_lock get decoder hw lock and set curr_ctx
+ * to ctx instance that get lock
+ */
+void mtk_vdec_unlock(struct mtk_vcodec_ctx *ctx);
+void mtk_vdec_lock(struct mtk_vcodec_ctx *ctx);
+int mtk_vcodec_dec_queue_init(void *priv, struct vb2_queue *src_vq,
+			   struct vb2_queue *dst_vq);
+void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx);
+void mtk_vcodec_dec_release(struct mtk_vcodec_ctx *ctx);
+int mtk_vcodec_dec_ctrls_setup(struct mtk_vcodec_ctx *ctx);
+
+
+#endif /* _MTK_VCODEC_DEC_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
new file mode 100644
index 0000000..8070df9
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
@@ -0,0 +1,394 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_dec.h"
+#include "mtk_vcodec_dec_pm.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu.h"
+
+#define VDEC_HW_ACTIVE	0x10
+#define VDEC_IRQ_CFG	0x11
+#define VDEC_IRQ_CLR	0x10
+#define VDEC_IRQ_CFG_REG	0xa4
+
+module_param(mtk_v4l2_dbg_level, int, S_IRUGO | S_IWUSR);
+module_param(mtk_vcodec_dbg, bool, S_IRUGO | S_IWUSR);
+
+/* Wake up context wait_queue */
+static void wake_up_ctx(struct mtk_vcodec_ctx *ctx)
+{
+	ctx->int_cond = 1;
+	wake_up_interruptible(&ctx->queue);
+}
+
+static irqreturn_t mtk_vcodec_dec_irq_handler(int irq, void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+	u32 cg_status = 0;
+	unsigned int dec_done_status = 0;
+	void __iomem *vdec_misc_addr = dev->reg_base[VDEC_MISC] +
+					VDEC_IRQ_CFG_REG;
+
+	ctx = mtk_vcodec_get_curr_ctx(dev);
+
+	/* check if HW active or not */
+	cg_status = readl(dev->reg_base[0]);
+	if ((cg_status & VDEC_HW_ACTIVE) != 0) {
+		mtk_v4l2_err("DEC ISR, VDEC active is not 0x0 (0x%08x)",
+			     cg_status);
+		return IRQ_HANDLED;
+	}
+
+	dec_done_status = readl(vdec_misc_addr);
+	ctx->irq_status = dec_done_status;
+	if ((dec_done_status & MTK_VDEC_IRQ_STATUS_DEC_SUCCESS) !=
+		MTK_VDEC_IRQ_STATUS_DEC_SUCCESS)
+		return IRQ_HANDLED;
+
+	/* clear interrupt */
+	writel((readl(vdec_misc_addr) | VDEC_IRQ_CFG),
+		dev->reg_base[VDEC_MISC] + VDEC_IRQ_CFG_REG);
+	writel((readl(vdec_misc_addr) & ~VDEC_IRQ_CLR),
+		dev->reg_base[VDEC_MISC] + VDEC_IRQ_CFG_REG);
+
+	wake_up_ctx(ctx);
+
+	mtk_v4l2_debug(3,
+			"mtk_vcodec_dec_irq_handler :wake up ctx %d, dec_done_status=%x",
+			ctx->id, dec_done_status);
+
+	return IRQ_HANDLED;
+}
+
+static void mtk_vcodec_dec_reset_handler(void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+
+	mtk_v4l2_err("Watchdog timeout!!");
+
+	mutex_lock(&dev->dev_mutex);
+	list_for_each_entry(ctx, &dev->ctx_list, list) {
+		ctx->state = MTK_STATE_ABORT;
+		mtk_v4l2_debug(0, "[%d] Change to state MTK_STATE_ERROR",
+				ctx->id);
+	}
+	mutex_unlock(&dev->dev_mutex);
+}
+
+static int fops_vcodec_open(struct file *file)
+{
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = NULL;
+	int ret = 0;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	mutex_lock(&dev->dev_mutex);
+	ctx->id = dev->id_counter++;
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+	INIT_LIST_HEAD(&ctx->list);
+	ctx->dev = dev;
+	init_waitqueue_head(&ctx->queue);
+	mutex_init(&ctx->lock);
+
+	ctx->type = MTK_INST_DECODER;
+	ret = mtk_vcodec_dec_ctrls_setup(ctx);
+	if (ret) {
+		mtk_v4l2_err("Failed to setup mt vcodec controls");
+		goto err_ctrls_setup;
+	}
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_dec, ctx,
+		&mtk_vcodec_dec_queue_init);
+	if (IS_ERR((__force void *)ctx->m2m_ctx)) {
+		ret = PTR_ERR((__force void *)ctx->m2m_ctx);
+		mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)",
+			ret);
+		goto err_m2m_ctx_init;
+	}
+	mtk_vcodec_dec_set_default_params(ctx);
+
+	if (v4l2_fh_is_singular(&ctx->fh)) {
+		mtk_vcodec_dec_pw_on(&dev->pm);
+		/*
+		 * vpu_load_firmware checks if it was loaded already and
+		 * does nothing in that case
+		 */
+		ret = vpu_load_firmware(dev->vpu_plat_dev);
+		if (ret < 0) {
+			/*
+			 * Return 0 if downloading firmware successfully,
+			 * otherwise it is failed
+			 */
+			mtk_v4l2_err("vpu_load_firmware failed!");
+			goto err_load_fw;
+		}
+
+		dev->dec_capability =
+			vpu_get_vdec_hw_capa(dev->vpu_plat_dev);
+		mtk_v4l2_debug(0, "decoder capability %x", dev->dec_capability);
+	}
+
+	list_add(&ctx->list, &dev->ctx_list);
+
+	mutex_unlock(&dev->dev_mutex);
+	mtk_v4l2_debug(0, "%s decoder [%d]", dev_name(&dev->plat_dev->dev),
+			ctx->id);
+	return ret;
+
+	/* Deinit when failure occurred */
+err_load_fw:
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+err_m2m_ctx_init:
+	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+err_ctrls_setup:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	mutex_unlock(&dev->dev_mutex);
+
+	return ret;
+}
+
+static int fops_vcodec_release(struct file *file)
+{
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
+
+	mtk_v4l2_debug(0, "[%d] decoder", ctx->id);
+	mutex_lock(&dev->dev_mutex);
+
+	/*
+	 * Call v4l2_m2m_ctx_release before mtk_vcodec_dec_release. First, it
+	 * makes sure the worker thread is not running after vdec_if_deinit.
+	 * Second, the decoder will be flushed and all the buffers will be
+	 * returned in stop_streaming.
+	 */
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mtk_vcodec_dec_release(ctx);
+
+	if (v4l2_fh_is_singular(&ctx->fh))
+		mtk_vcodec_dec_pw_off(&dev->pm);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+
+	list_del_init(&ctx->list);
+	kfree(ctx);
+	mutex_unlock(&dev->dev_mutex);
+	return 0;
+}
+
+static const struct v4l2_file_operations mtk_vcodec_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fops_vcodec_open,
+	.release	= fops_vcodec_release,
+	.poll		= v4l2_m2m_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= v4l2_m2m_fop_mmap,
+};
+
+static int mtk_vcodec_probe(struct platform_device *pdev)
+{
+	struct mtk_vcodec_dev *dev;
+	struct video_device *vfd_dec;
+	struct resource *res;
+	int i, ret;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dev->ctx_list);
+	dev->plat_dev = pdev;
+
+	dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
+	if (dev->vpu_plat_dev == NULL) {
+		mtk_v4l2_err("[VPU] vpu device in not ready");
+		return -EPROBE_DEFER;
+	}
+
+	vpu_wdt_reg_handler(dev->vpu_plat_dev, mtk_vcodec_dec_reset_handler,
+			dev, VPU_RST_DEC);
+
+	ret = mtk_vcodec_init_dec_pm(dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to get mt vcodec clock source");
+		return ret;
+	}
+
+	for (i = 0; i < NUM_MAX_VDEC_REG_BASE; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (res == NULL) {
+			dev_err(&pdev->dev, "get memory resource failed.");
+			ret = -ENXIO;
+			goto err_res;
+		}
+		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR((__force void *)dev->reg_base[i])) {
+			ret = PTR_ERR((__force void *)dev->reg_base);
+			goto err_res;
+		}
+		mtk_v4l2_debug(2, "reg[%d] base=%p", i, dev->reg_base[i]);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get irq resource");
+		ret = -ENOENT;
+		goto err_res;
+	}
+
+	dev->dec_irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(&pdev->dev, dev->dec_irq,
+			mtk_vcodec_dec_irq_handler, 0, pdev->name, dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to install dev->dec_irq %d (%d)",
+			dev->dec_irq,
+			ret);
+		goto err_res;
+	}
+
+	disable_irq(dev->dec_irq);
+	mutex_init(&dev->dec_mutex);
+	mutex_init(&dev->dev_mutex);
+	spin_lock_init(&dev->irqlock);
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
+		"[/MTK_V4L2_VDEC]");
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret) {
+		mtk_v4l2_err("v4l2_device_register err=%d", ret);
+		goto err_res;
+	}
+
+	init_waitqueue_head(&dev->queue);
+
+	vfd_dec = video_device_alloc();
+	if (!vfd_dec) {
+		mtk_v4l2_err("Failed to allocate video device");
+		ret = -ENOMEM;
+		goto err_dec_alloc;
+	}
+	vfd_dec->fops		= &mtk_vcodec_fops;
+	vfd_dec->ioctl_ops	= &mtk_vdec_ioctl_ops;
+	vfd_dec->release	= video_device_release;
+	vfd_dec->lock		= &dev->dev_mutex;
+	vfd_dec->v4l2_dev	= &dev->v4l2_dev;
+	vfd_dec->vfl_dir	= VFL_DIR_M2M;
+	vfd_dec->device_caps	= V4L2_CAP_VIDEO_M2M_MPLANE |
+			V4L2_CAP_STREAMING;
+
+	snprintf(vfd_dec->name, sizeof(vfd_dec->name), "%s",
+		MTK_VCODEC_DEC_NAME);
+	video_set_drvdata(vfd_dec, dev);
+	dev->vfd_dec = vfd_dec;
+	platform_set_drvdata(pdev, dev);
+
+	dev->m2m_dev_dec = v4l2_m2m_init(&mtk_vdec_m2m_ops);
+	if (IS_ERR((__force void *)dev->m2m_dev_dec)) {
+		mtk_v4l2_err("Failed to init mem2mem dec device");
+		ret = PTR_ERR((__force void *)dev->m2m_dev_dec);
+		goto err_dec_mem_init;
+	}
+
+	dev->decode_workqueue =
+		alloc_ordered_workqueue(MTK_VCODEC_DEC_NAME,
+			WQ_MEM_RECLAIM | WQ_FREEZABLE);
+	if (!dev->decode_workqueue) {
+		mtk_v4l2_err("Failed to create decode workqueue");
+		ret = -EINVAL;
+		goto err_event_workq;
+	}
+
+	ret = video_register_device(vfd_dec, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		mtk_v4l2_err("Failed to register video device");
+		goto err_dec_reg;
+	}
+
+	mtk_v4l2_debug(0, "decoder registered as /dev/video%d",
+		vfd_dec->num);
+
+	return 0;
+
+err_dec_reg:
+	destroy_workqueue(dev->decode_workqueue);
+err_event_workq:
+	v4l2_m2m_release(dev->m2m_dev_dec);
+err_dec_mem_init:
+	video_unregister_device(vfd_dec);
+err_dec_alloc:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_res:
+	mtk_vcodec_release_dec_pm(dev);
+	return ret;
+}
+
+static const struct of_device_id mtk_vcodec_match[] = {
+	{.compatible = "mediatek,mt8173-vcodec-dec",},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, mtk_vcodec_match);
+
+static int mtk_vcodec_dec_remove(struct platform_device *pdev)
+{
+	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
+
+	flush_workqueue(dev->decode_workqueue);
+	destroy_workqueue(dev->decode_workqueue);
+	if (dev->m2m_dev_dec)
+		v4l2_m2m_release(dev->m2m_dev_dec);
+
+	if (dev->vfd_dec)
+		video_unregister_device(dev->vfd_dec);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+	mtk_vcodec_release_dec_pm(dev);
+	return 0;
+}
+
+static struct platform_driver mtk_vcodec_dec_driver = {
+	.probe	= mtk_vcodec_probe,
+	.remove	= mtk_vcodec_dec_remove,
+	.driver	= {
+		.name	= MTK_VCODEC_DEC_NAME,
+		.of_match_table = mtk_vcodec_match,
+	},
+};
+
+module_platform_driver(mtk_vcodec_dec_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek video codec V4L2 decoder driver");
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
new file mode 100644
index 0000000..7eb8973
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -0,0 +1,205 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/clk.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
+#include <soc/mediatek/smi.h>
+
+#include "mtk_vcodec_dec_pm.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu.h"
+
+int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
+{
+	struct device_node *node;
+	struct platform_device *pdev;
+	struct device *dev;
+	struct mtk_vcodec_pm *pm;
+	int ret = 0;
+
+	pdev = mtkdev->plat_dev;
+	pm = &mtkdev->pm;
+	pm->mtkdev = mtkdev;
+	dev = &pdev->dev;
+	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
+	if (!node) {
+		mtk_v4l2_err("of_parse_phandle mediatek,larb fail!");
+		return -1;
+	}
+
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -1;
+	}
+	pm->larbvdec = &pdev->dev;
+	pdev = mtkdev->plat_dev;
+	pm->dev = &pdev->dev;
+
+	pm->vcodecpll = devm_clk_get(&pdev->dev, "vcodecpll");
+	if (IS_ERR(pm->vcodecpll)) {
+		mtk_v4l2_err("devm_clk_get vcodecpll fail");
+		ret = PTR_ERR(pm->vcodecpll);
+	}
+
+	pm->univpll_d2 = devm_clk_get(&pdev->dev, "univpll_d2");
+	if (IS_ERR(pm->univpll_d2)) {
+		mtk_v4l2_err("devm_clk_get univpll_d2 fail");
+		ret = PTR_ERR(pm->univpll_d2);
+	}
+
+	pm->clk_cci400_sel = devm_clk_get(&pdev->dev, "clk_cci400_sel");
+	if (IS_ERR(pm->clk_cci400_sel)) {
+		mtk_v4l2_err("devm_clk_get clk_cci400_sel fail");
+		ret = PTR_ERR(pm->clk_cci400_sel);
+	}
+
+	pm->vdec_sel = devm_clk_get(&pdev->dev, "vdec_sel");
+	if (IS_ERR(pm->vdec_sel)) {
+		mtk_v4l2_err("devm_clk_get vdec_sel fail");
+		ret = PTR_ERR(pm->vdec_sel);
+	}
+
+	pm->vdecpll = devm_clk_get(&pdev->dev, "vdecpll");
+	if (IS_ERR(pm->vdecpll)) {
+		mtk_v4l2_err("devm_clk_get vdecpll fail");
+		ret = PTR_ERR(pm->vdecpll);
+	}
+
+	pm->vencpll = devm_clk_get(&pdev->dev, "vencpll");
+	if (IS_ERR(pm->vencpll)) {
+		mtk_v4l2_err("devm_clk_get vencpll fail");
+		ret = PTR_ERR(pm->vencpll);
+	}
+
+	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
+	if (IS_ERR(pm->venc_lt_sel)) {
+		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
+		ret = PTR_ERR(pm->venc_lt_sel);
+	}
+
+	pm->vdec_bus_clk_src = devm_clk_get(&pdev->dev, "vdec_bus_clk_src");
+	if (IS_ERR(pm->vdec_bus_clk_src)) {
+		mtk_v4l2_err("devm_clk_get vdec_bus_clk_src");
+		ret = PTR_ERR(pm->vdec_bus_clk_src);
+	}
+
+	pm_runtime_enable(&pdev->dev);
+
+	return ret;
+}
+
+void mtk_vcodec_release_dec_pm(struct mtk_vcodec_dev *dev)
+{
+	pm_runtime_disable(dev->pm.dev);
+}
+
+void mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm)
+{
+	int ret;
+
+	ret = pm_runtime_get_sync(pm->dev);
+	if (ret)
+		mtk_v4l2_err("pm_runtime_get_sync fail %d", ret);
+}
+
+void mtk_vcodec_dec_pw_off(struct mtk_vcodec_pm *pm)
+{
+	int ret;
+
+	ret = pm_runtime_put_sync(pm->dev);
+	if (ret)
+		mtk_v4l2_err("pm_runtime_put_sync fail %d", ret);
+}
+
+void mtk_vcodec_dec_clock_on(struct mtk_vcodec_pm *pm)
+{
+	int ret;
+
+	ret = clk_set_rate(pm->vcodecpll, 1482 * 1000000);
+	if (ret)
+		mtk_v4l2_err("clk_set_rate vcodecpll fail %d", ret);
+
+	ret = clk_set_rate(pm->vencpll, 800 * 1000000);
+	if (ret)
+		mtk_v4l2_err("clk_set_rate vencpll fail %d", ret);
+
+	ret = clk_prepare_enable(pm->vcodecpll);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable vcodecpll fail %d", ret);
+
+	ret = clk_prepare_enable(pm->vencpll);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable vencpll fail %d", ret);
+
+	ret = clk_prepare_enable(pm->vdec_bus_clk_src);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable vdec_bus_clk_src fail %d",
+				ret);
+
+	ret = clk_prepare_enable(pm->venc_lt_sel);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable venc_lt_sel fail %d", ret);
+
+	ret = clk_set_parent(pm->venc_lt_sel, pm->vdec_bus_clk_src);
+	if (ret)
+		mtk_v4l2_err("clk_set_parent venc_lt_sel vdec_bus_clk_src fail %d",
+				ret);
+
+	ret = clk_prepare_enable(pm->univpll_d2);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable univpll_d2 fail %d", ret);
+
+	ret = clk_prepare_enable(pm->clk_cci400_sel);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable clk_cci400_sel fail %d", ret);
+
+	ret = clk_set_parent(pm->clk_cci400_sel, pm->univpll_d2);
+	if (ret)
+		mtk_v4l2_err("clk_set_parent clk_cci400_sel univpll_d2 fail %d",
+				ret);
+
+	ret = clk_prepare_enable(pm->vdecpll);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable vdecpll fail %d", ret);
+
+	ret = clk_prepare_enable(pm->vdec_sel);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable vdec_sel fail %d", ret);
+
+	ret = clk_set_parent(pm->vdec_sel, pm->vdecpll);
+	if (ret)
+		mtk_v4l2_err("clk_set_parent vdec_sel vdecpll fail %d", ret);
+
+	ret = mtk_smi_larb_get(pm->larbvdec);
+	if (ret)
+		mtk_v4l2_err("mtk_smi_larb_get larbvdec fail %d", ret);
+
+}
+
+void mtk_vcodec_dec_clock_off(struct mtk_vcodec_pm *pm)
+{
+	mtk_smi_larb_put(pm->larbvdec);
+	clk_disable_unprepare(pm->vdec_sel);
+	clk_disable_unprepare(pm->vdecpll);
+	clk_disable_unprepare(pm->univpll_d2);
+	clk_disable_unprepare(pm->clk_cci400_sel);
+	clk_disable_unprepare(pm->venc_lt_sel);
+	clk_disable_unprepare(pm->vdec_bus_clk_src);
+	clk_disable_unprepare(pm->vencpll);
+	clk_disable_unprepare(pm->vcodecpll);
+}
+
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
new file mode 100644
index 0000000..b8bf56f
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
@@ -0,0 +1,28 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VCODEC_DEC_PM_H_
+#define _MTK_VCODEC_DEC_PM_H_
+
+#include "mtk_vcodec_drv.h"
+
+int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *dev);
+void mtk_vcodec_release_dec_pm(struct mtk_vcodec_dev *dev);
+
+void mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm);
+void mtk_vcodec_dec_pw_off(struct mtk_vcodec_pm *pm);
+void mtk_vcodec_dec_clock_on(struct mtk_vcodec_pm *pm);
+void mtk_vcodec_dec_clock_off(struct mtk_vcodec_pm *pm);
+
+#endif /* _MTK_VCODEC_DEC_PM_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
index c8eaa41..d7eb8ef 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
@@ -22,13 +22,13 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
-
+#include "mtk_vcodec_util.h"
 
 #define MTK_VCODEC_DRV_NAME	"mtk_vcodec_drv"
+#define MTK_VCODEC_DEC_NAME	"mtk-vcodec-dec"
 #define MTK_VCODEC_ENC_NAME	"mtk-vcodec-enc"
 #define MTK_PLATFORM_STR	"platform:mt8173"
 
-
 #define MTK_VCODEC_MAX_PLANES	3
 #define MTK_V4L2_BENCHMARK	0
 #define WAIT_INTR_TIMEOUT_MS	1000
@@ -179,6 +179,9 @@ struct mtk_enc_params {
  * struct mtk_vcodec_pm - Power management data structure
  */
 struct mtk_vcodec_pm {
+	struct clk	*vdec_bus_clk_src;
+	struct clk	*vencpll;
+
 	struct clk	*vcodecpll;
 	struct clk	*univpll_d2;
 	struct clk	*clk_cci400_sel;
@@ -196,6 +199,32 @@ struct mtk_vcodec_pm {
 };
 
 /**
+ * struct vdec_pic_info  - picture size information
+ * @pic_w: picture width
+ * @pic_h: picture height
+ * @buf_w: picture buffer width (64 aligned up from pic_w)
+ * @buf_h: picture buffer heiht (64 aligned up from pic_h)
+ * @y_bs_sz: Y bitstream size
+ * @c_bs_sz: CbCr bitstream size
+ * @y_len_sz: additional size required to store decompress information for y
+ *		plane
+ * @c_len_sz: additional size required to store decompress information for cbcr
+ *		plane
+ * E.g. suppose picture size is 176x144,
+ *      buffer size will be aligned to 176x160.
+ */
+struct vdec_pic_info {
+	unsigned int pic_w;
+	unsigned int pic_h;
+	unsigned int buf_w;
+	unsigned int buf_h;
+	unsigned int y_bs_sz;
+	unsigned int c_bs_sz;
+	unsigned int y_len_sz;
+	unsigned int c_len_sz;
+};
+
+/**
  * struct mtk_vcodec_ctx - Context (instance) private data.
  *
  * @type: type of the instance - decoder or encoder
@@ -209,9 +238,12 @@ struct mtk_vcodec_pm {
  * @state: state of the context
  * @param_change: indicate encode parameter type
  * @enc_params: encoding parameters
+ * @dec_if: hooked decoder driver interface
  * @enc_if: hoooked encoder driver interface
  * @drv_handle: driver handle for specific decode/encode instance
  *
+ * @picinfo: store picture info after header parsing
+ * @dpb_size: store dpb count after header parsing
  * @int_cond: variable used by the waitqueue
  * @int_type: type of the last interrupt
  * @queue: waitqueue that can be used to wait for this context to
@@ -219,12 +251,16 @@ struct mtk_vcodec_pm {
  * @irq_status: irq status
  *
  * @ctrl_hdl: handler for v4l2 framework
+ * @decode_work: worker for the decoding
  * @encode_work: worker for the encoding
+ * @last_decoded_picinfo: pic information get from latest decode
  *
  * @colorspace: enum v4l2_colorspace; supplemental to pixelformat
  * @ycbcr_enc: enum v4l2_ycbcr_encoding, Y'CbCr encoding
  * @quantization: enum v4l2_quantization, colorspace quantization
  * @xfer_func: enum v4l2_xfer_func, colorspace transfer function
+ * @lock: protect variables accessed by V4L2 threads and worker thread such as
+ *	  mtk_video_dec_buf.
  */
 struct mtk_vcodec_ctx {
 	enum mtk_instance_type type;
@@ -239,28 +275,40 @@ struct mtk_vcodec_ctx {
 	enum mtk_encode_param param_change;
 	struct mtk_enc_params enc_params;
 
+	const struct vdec_common_if *dec_if;
 	const struct venc_common_if *enc_if;
 	unsigned long drv_handle;
 
+	struct vdec_pic_info picinfo;
+	int dpb_size;
+
 	int int_cond;
 	int int_type;
 	wait_queue_head_t queue;
 	unsigned int irq_status;
 
 	struct v4l2_ctrl_handler ctrl_hdl;
+	struct work_struct decode_work;
 	struct work_struct encode_work;
+	struct vdec_pic_info last_decoded_picinfo;
 
 	enum v4l2_colorspace colorspace;
 	enum v4l2_ycbcr_encoding ycbcr_enc;
 	enum v4l2_quantization quantization;
 	enum v4l2_xfer_func xfer_func;
+
+	int decoded_frame_cnt;
+	struct mutex lock;
+
 };
 
 /**
  * struct mtk_vcodec_dev - driver data
  * @v4l2_dev: V4L2 device to register video devices for.
+ * @vfd_dec: Video device for decoder
  * @vfd_enc: Video device for encoder.
  *
+ * @m2m_dev_dec: m2m device for decoder
  * @m2m_dev_enc: m2m device for encoder.
  * @plat_dev: platform device
  * @vpu_plat_dev: mtk vpu platform device
@@ -271,7 +319,6 @@ struct mtk_vcodec_ctx {
  * @reg_base: Mapped address of MTK Vcodec registers.
  *
  * @id_counter: used to identify current opened instance
- * @num_instances: counter of active MTK Vcodec instances
  *
  * @encode_workqueue: encode work queue
  *
@@ -280,9 +327,11 @@ struct mtk_vcodec_ctx {
  * @dev_mutex: video_device lock
  * @queue: waitqueue for waiting for completion of device commands
  *
+ * @dec_irq: decoder irq resource
  * @enc_irq: h264 encoder irq resource
  * @enc_lt_irq: vp8 encoder irq resource
  *
+ * @dec_mutex: decoder hardware lock
  * @enc_mutex: encoder hardware lock.
  *
  * @pm: power management control
@@ -291,8 +340,10 @@ struct mtk_vcodec_ctx {
  */
 struct mtk_vcodec_dev {
 	struct v4l2_device v4l2_dev;
+	struct video_device *vfd_dec;
 	struct video_device *vfd_enc;
 
+	struct v4l2_m2m_dev *m2m_dev_dec;
 	struct v4l2_m2m_dev *m2m_dev_enc;
 	struct platform_device *plat_dev;
 	struct platform_device *vpu_plat_dev;
@@ -302,18 +353,19 @@ struct mtk_vcodec_dev {
 	void __iomem *reg_base[NUM_MAX_VCODEC_REG_BASE];
 
 	unsigned long id_counter;
-	int num_instances;
 
+	struct workqueue_struct *decode_workqueue;
 	struct workqueue_struct *encode_workqueue;
-
 	int int_cond;
 	int int_type;
 	struct mutex dev_mutex;
 	wait_queue_head_t queue;
 
+	int dec_irq;
 	int enc_irq;
 	int enc_lt_irq;
 
+	struct mutex dec_mutex;
 	struct mutex enc_mutex;
 
 	struct mtk_vcodec_pm pm;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 5cd2151..aa81f3c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -188,7 +188,6 @@ static int fops_vcodec_open(struct file *file)
 	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p ",
 			ctx->id, ctx, ctx->m2m_ctx);
 
-	dev->num_instances++;
 	list_add(&ctx->list, &dev->ctx_list);
 
 	mutex_unlock(&dev->dev_mutex);
@@ -218,18 +217,13 @@ static int fops_vcodec_release(struct file *file)
 	mtk_v4l2_debug(1, "[%d] encoder", ctx->id);
 	mutex_lock(&dev->dev_mutex);
 
-	/*
-	 * Call v4l2_m2m_ctx_release to make sure the worker thread is not
-	 * running after venc_if_deinit.
-	 */
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	mtk_vcodec_enc_release(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 
 	list_del_init(&ctx->list);
-	dev->num_instances--;
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 	return 0;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
index 52e7e5c..113b209 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
@@ -30,8 +30,7 @@ int mtk_vcodec_wait_for_done_ctx(struct mtk_vcodec_ctx  *ctx, int command,
 	timeout_jiff = msecs_to_jiffies(timeout_ms);
 
 	ret = wait_event_interruptible_timeout(*waitqueue,
-				(ctx->int_cond &&
-				(ctx->int_type == command)),
+				ctx->int_cond,
 				timeout_jiff);
 
 	if (!ret) {
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
index 5e36513..46768c0 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
@@ -81,14 +81,37 @@ void mtk_vcodec_mem_free(struct mtk_vcodec_ctx *data,
 		return;
 	}
 
-	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
-	mem->va = NULL;
-	mem->dma_addr = 0;
-	mem->size = 0;
-
 	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->id, mem->va);
 	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->id,
 		       (unsigned long)mem->dma_addr);
 	mtk_v4l2_debug(3, "[%d]    size = 0x%lx", ctx->id, size);
+
+	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
+	mem->va = NULL;
+	mem->dma_addr = 0;
+	mem->size = 0;
 }
 EXPORT_SYMBOL(mtk_vcodec_mem_free);
+
+void mtk_vcodec_set_curr_ctx(struct mtk_vcodec_dev *dev,
+	struct mtk_vcodec_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	dev->curr_ctx = ctx;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+}
+EXPORT_SYMBOL(mtk_vcodec_set_curr_ctx);
+
+struct mtk_vcodec_ctx *mtk_vcodec_get_curr_ctx(struct mtk_vcodec_dev *dev)
+{
+	unsigned long flags;
+	struct mtk_vcodec_ctx *ctx;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	ctx = dev->curr_ctx;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return ctx;
+}
+EXPORT_SYMBOL(mtk_vcodec_get_curr_ctx);
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
index d6345fc..7d55975 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
@@ -26,6 +26,7 @@ struct mtk_vcodec_mem {
 };
 
 struct mtk_vcodec_ctx;
+struct mtk_vcodec_dev;
 
 extern int mtk_v4l2_dbg_level;
 extern bool mtk_vcodec_dbg;
@@ -84,4 +85,8 @@ int mtk_vcodec_mem_alloc(struct mtk_vcodec_ctx *data,
 				struct mtk_vcodec_mem *mem);
 void mtk_vcodec_mem_free(struct mtk_vcodec_ctx *data,
 				struct mtk_vcodec_mem *mem);
+void mtk_vcodec_set_curr_ctx(struct mtk_vcodec_dev *dev,
+	struct mtk_vcodec_ctx *ctx);
+struct mtk_vcodec_ctx *mtk_vcodec_get_curr_ctx(struct mtk_vcodec_dev *dev);
+
 #endif /* _MTK_VCODEC_UTIL_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_base.h b/drivers/media/platform/mtk-vcodec/vdec_drv_base.h
new file mode 100644
index 0000000..ca022e3
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_base.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VDEC_DRV_BASE_
+#define _VDEC_DRV_BASE_
+
+#include "mtk_vcodec_drv.h"
+
+
+struct vdec_common_if {
+	/**
+	 * (*init)() - initialize decode driver
+	 * @ctx     : [in] mtk v4l2 context
+	 * @h_vdec  : [out] driver handle
+	 */
+	int (*init)(struct mtk_vcodec_ctx *ctx, unsigned long *h_vdec);
+
+	/**
+	 * (*decode)() - trigger decode
+	 * @h_vdec  : [in] driver handle
+	 * @bs      : [in] input bitstream
+	 * @fb      : [in] frame buffer to store decoded frame
+	 * @res_chg : [out] resolution change happen
+	 */
+	int (*decode)(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
+		      struct vdec_fb *fb, bool *res_chg);
+
+	/**
+	 * (*get_param)() - get driver's parameter
+	 * @h_vdec : [in] driver handle
+	 * @type   : [in] input parameter type
+	 * @out    : [out] buffer to store query result
+	 */
+	int (*get_param)(unsigned long h_vdec, enum vdec_get_param_type type,
+			 void *out);
+
+	/**
+	 * (*deinit)() - deinitialize driver.
+	 * @h_vdec : [in] driver handle to be deinit
+	 */
+	void (*deinit)(unsigned long h_vdec);
+};
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
new file mode 100644
index 0000000..3cb04ef
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *         Tiffany Lin <tiffany.lin@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "vdec_drv_if.h"
+#include "mtk_vcodec_dec.h"
+#include "vdec_drv_base.h"
+#include "mtk_vcodec_dec_pm.h"
+#include "mtk_vpu.h"
+
+
+int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
+{
+	int ret = 0;
+
+	switch (fourcc) {
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_VP8:
+	default:
+		return -EINVAL;
+	}
+
+	mtk_vdec_lock(ctx);
+	mtk_vcodec_dec_clock_on(&ctx->dev->pm);
+	ret = ctx->dec_if->init(ctx, &ctx->drv_handle);
+	mtk_vcodec_dec_clock_off(&ctx->dev->pm);
+	mtk_vdec_unlock(ctx);
+
+	return ret;
+}
+
+int vdec_if_decode(struct mtk_vcodec_ctx *ctx, struct mtk_vcodec_mem *bs,
+		   struct vdec_fb *fb, bool *res_chg)
+{
+	int ret = 0;
+
+	if (bs) {
+		if ((bs->dma_addr & 63) != 0) {
+			mtk_v4l2_err("bs dma_addr should 64 byte align");
+			return -EINVAL;
+		}
+	}
+
+	if (fb) {
+		if (((fb->base_y.dma_addr & 511) != 0) ||
+		    ((fb->base_c.dma_addr & 511) != 0)) {
+			mtk_v4l2_err("frame buffer dma_addr should 512 byte align");
+			return -EINVAL;
+		}
+	}
+
+	if (ctx->drv_handle == 0)
+		return -EIO;
+
+	mtk_vdec_lock(ctx);
+
+	mtk_vcodec_set_curr_ctx(ctx->dev, ctx);
+	mtk_vcodec_dec_clock_on(&ctx->dev->pm);
+	enable_irq(ctx->dev->dec_irq);
+	ret = ctx->dec_if->decode(ctx->drv_handle, bs, fb, res_chg);
+	disable_irq(ctx->dev->dec_irq);
+	mtk_vcodec_dec_clock_off(&ctx->dev->pm);
+	mtk_vcodec_set_curr_ctx(ctx->dev, NULL);
+
+	mtk_vdec_unlock(ctx);
+
+	return ret;
+}
+
+int vdec_if_get_param(struct mtk_vcodec_ctx *ctx, enum vdec_get_param_type type,
+		      void *out)
+{
+	int ret = 0;
+
+	if (ctx->drv_handle == 0)
+		return -EIO;
+
+	mtk_vdec_lock(ctx);
+	ret = ctx->dec_if->get_param(ctx->drv_handle, type, out);
+	mtk_vdec_unlock(ctx);
+
+	return ret;
+}
+
+void vdec_if_deinit(struct mtk_vcodec_ctx *ctx)
+{
+	if (ctx->drv_handle == 0)
+		return;
+
+	mtk_vdec_lock(ctx);
+	mtk_vcodec_dec_clock_on(&ctx->dev->pm);
+	ctx->dec_if->deinit(ctx->drv_handle);
+	mtk_vcodec_dec_clock_off(&ctx->dev->pm);
+	mtk_vdec_unlock(ctx);
+
+	ctx->drv_handle = 0;
+}
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
new file mode 100644
index 0000000..db6b520
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *		   Tiffany Lin <tiffany.lin@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VDEC_DRV_IF_H_
+#define _VDEC_DRV_IF_H_
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_dec.h"
+#include "mtk_vcodec_util.h"
+
+
+/**
+ * struct vdec_fb_status  - decoder frame buffer status
+ * @FB_ST_NORMAL	: initial state
+ * @FB_ST_DISPLAY	: frmae buffer is ready to be displayed
+ * @FB_ST_FREE		: frame buffer is not used by decoder any more
+ */
+enum vdec_fb_status {
+	FB_ST_NORMAL		= 0,
+	FB_ST_DISPLAY		= (1 << 0),
+	FB_ST_FREE		= (1 << 1)
+};
+
+/* For GET_PARAM_DISP_FRAME_BUFFER and GET_PARAM_FREE_FRAME_BUFFER,
+ * the caller does not own the returned buffer. The buffer will not be
+ *				released before vdec_if_deinit.
+ * GET_PARAM_DISP_FRAME_BUFFER	: get next displayable frame buffer,
+ *				struct vdec_fb**
+ * GET_PARAM_FREE_FRAME_BUFFER	: get non-referenced framebuffer, vdec_fb**
+ * GET_PARAM_PIC_INFO		: get picture info, struct vdec_pic_info*
+ * GET_PARAM_CROP_INFO		: get crop info, struct v4l2_crop*
+ * GET_PARAM_DPB_SIZE		: get dpb size, unsigned int*
+ */
+enum vdec_get_param_type {
+	GET_PARAM_DISP_FRAME_BUFFER,
+	GET_PARAM_FREE_FRAME_BUFFER,
+	GET_PARAM_PIC_INFO,
+	GET_PARAM_CROP_INFO,
+	GET_PARAM_DPB_SIZE
+};
+
+/**
+ * struct vdec_fb_node  - decoder frame buffer node
+ * @list	: list to hold this node
+ * @fb	: point to frame buffer (vdec_fb), fb could point to frame buffer and
+ *	working buffer this is for maintain buffers in different state
+ */
+struct vdec_fb_node {
+	struct list_head list;
+	struct vdec_fb *fb;
+};
+
+/**
+ * vdec_if_init() - initialize decode driver
+ * @ctx	: [in] v4l2 context
+ * @fourcc	: [in] video format fourcc, V4L2_PIX_FMT_H264/VP8/VP9..
+ */
+int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc);
+
+/**
+ * vdec_if_deinit() - deinitialize decode driver
+ * @ctx	: [in] v4l2 context
+ *
+ */
+void vdec_if_deinit(struct mtk_vcodec_ctx *ctx);
+
+/**
+ * vdec_if_decode() - trigger decode
+ * @ctx	: [in] v4l2 context
+ * @bs	: [in] input bitstream
+ * @fb	: [in] frame buffer to store decoded frame, when null menas parse
+ *	header only
+ * @res_chg	: [out] resolution change happens if current bs have different
+ *	picture width/height
+ * Note: To flush the decoder when reaching EOF, set input bitstream as NULL.
+ */
+int vdec_if_decode(struct mtk_vcodec_ctx *ctx, struct mtk_vcodec_mem *bs,
+		   struct vdec_fb *fb, bool *res_chg);
+
+/**
+ * vdec_if_get_param() - get driver's parameter
+ * @ctx	: [in] v4l2 context
+ * @type	: [in] input parameter type
+ * @out	: [out] buffer to store query result
+ */
+int vdec_if_get_param(struct mtk_vcodec_ctx *ctx, enum vdec_get_param_type type,
+		      void *out);
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h b/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
new file mode 100644
index 0000000..5a8a629
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VDEC_IPI_MSG_H_
+#define _VDEC_IPI_MSG_H_
+
+/**
+ * enum vdec_ipi_msgid - message id between AP and VPU
+ * @AP_IPIMSG_XXX	: AP to VPU cmd message id
+ * @VPU_IPIMSG_XXX_ACK	: VPU ack AP cmd message id
+ */
+enum vdec_ipi_msgid {
+	AP_IPIMSG_DEC_INIT = 0xA000,
+	AP_IPIMSG_DEC_START = 0xA001,
+	AP_IPIMSG_DEC_END = 0xA002,
+	AP_IPIMSG_DEC_DEINIT = 0xA003,
+	AP_IPIMSG_DEC_RESET = 0xA004,
+
+	VPU_IPIMSG_DEC_INIT_ACK = 0xB000,
+	VPU_IPIMSG_DEC_START_ACK = 0xB001,
+	VPU_IPIMSG_DEC_END_ACK = 0xB002,
+	VPU_IPIMSG_DEC_DEINIT_ACK = 0xB003,
+	VPU_IPIMSG_DEC_RESET_ACK = 0xB004,
+};
+
+/**
+ * struct vdec_ap_ipi_cmd - generic AP to VPU ipi command format
+ * @msg_id	: vdec_ipi_msgid
+ * @vpu_inst_addr	: VPU decoder instance address
+ */
+struct vdec_ap_ipi_cmd {
+	uint32_t msg_id;
+	uint32_t vpu_inst_addr;
+};
+
+/**
+ * struct vdec_vpu_ipi_ack - generic VPU to AP ipi command format
+ * @msg_id	: vdec_ipi_msgid
+ * @status	: VPU exeuction result
+ * @ap_inst_addr	: AP video decoder instance address
+ */
+struct vdec_vpu_ipi_ack {
+	uint32_t msg_id;
+	int32_t status;
+	uint64_t ap_inst_addr;
+};
+
+/**
+ * struct vdec_ap_ipi_init - for AP_IPIMSG_DEC_INIT
+ * @msg_id	: AP_IPIMSG_DEC_INIT
+ * @reserved	: Reserved field
+ * @ap_inst_addr	: AP video decoder instance address
+ */
+struct vdec_ap_ipi_init {
+	uint32_t msg_id;
+	uint32_t reserved;
+	uint64_t ap_inst_addr;
+};
+
+/**
+ * struct vdec_ap_ipi_dec_start - for AP_IPIMSG_DEC_START
+ * @msg_id	: AP_IPIMSG_DEC_START
+ * @vpu_inst_addr	: VPU decoder instance address
+ * @data	: Header info
+ *	H264 decoder [0]:buf_sz [1]:nal_start
+ *	VP8 decoder  [0]:width/height
+ *	VP9 decoder  [0]:profile, [1][2] width/height
+ * @reserved	: Reserved field
+ */
+struct vdec_ap_ipi_dec_start {
+	uint32_t msg_id;
+	uint32_t vpu_inst_addr;
+	uint32_t data[3];
+	uint32_t reserved;
+};
+
+/**
+ * struct vdec_vpu_ipi_init_ack - for VPU_IPIMSG_DEC_INIT_ACK
+ * @msg_id	: VPU_IPIMSG_DEC_INIT_ACK
+ * @status	: VPU exeuction result
+ * @ap_inst_addr	: AP vcodec_vpu_inst instance address
+ * @vpu_inst_addr	: VPU decoder instance address
+ */
+struct vdec_vpu_ipi_init_ack {
+	uint32_t msg_id;
+	int32_t status;
+	uint64_t ap_inst_addr;
+	uint32_t vpu_inst_addr;
+};
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
new file mode 100644
index 0000000..0798a6b
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "vdec_ipi_msg.h"
+#include "vdec_vpu_if.h"
+
+static void handle_init_ack_msg(struct vdec_vpu_ipi_init_ack *msg)
+{
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+
+	mtk_vcodec_debug(vpu, "+ ap_inst_addr = 0x%llx", msg->ap_inst_addr);
+
+	/* mapping VPU address to kernel virtual address */
+	/* the content in vsi is initialized to 0 in VPU */
+	vpu->vsi = vpu_mapping_dm_addr(vpu->dev, msg->vpu_inst_addr);
+	vpu->inst_addr = msg->vpu_inst_addr;
+
+	mtk_vcodec_debug(vpu, "- vpu_inst_addr = 0x%x", vpu->inst_addr);
+}
+
+/*
+ * This function runs in interrupt context and it means there's an IPI MSG
+ * from VPU.
+ */
+void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct vdec_vpu_ipi_ack *msg = data;
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+
+	mtk_vcodec_debug(vpu, "+ id=%X", msg->msg_id);
+
+	if (msg->status == 0) {
+		switch (msg->msg_id) {
+		case VPU_IPIMSG_DEC_INIT_ACK:
+			handle_init_ack_msg(data);
+			break;
+
+		case VPU_IPIMSG_DEC_START_ACK:
+		case VPU_IPIMSG_DEC_END_ACK:
+		case VPU_IPIMSG_DEC_DEINIT_ACK:
+		case VPU_IPIMSG_DEC_RESET_ACK:
+			break;
+
+		default:
+			mtk_vcodec_err(vpu, "invalid msg=%X", msg->msg_id);
+			break;
+		}
+	}
+
+	mtk_vcodec_debug(vpu, "- id=%X", msg->msg_id);
+	vpu->failure = msg->status;
+	vpu->signaled = 1;
+}
+
+static int vcodec_vpu_send_msg(struct vdec_vpu_inst *vpu, void *msg, int len)
+{
+	int err;
+	uint32_t msg_id = *(uint32_t *)msg;
+
+	mtk_vcodec_debug(vpu, "id=%X", msg_id);
+
+	vpu->failure = 0;
+	vpu->signaled = 0;
+
+	err = vpu_ipi_send(vpu->dev, vpu->id, msg, len);
+	if (err) {
+		mtk_vcodec_err(vpu, "send fail vpu_id=%d msg_id=%X status=%d",
+			       vpu->id, msg_id, err);
+		return err;
+	}
+
+	return vpu->failure;
+}
+
+static int vcodec_send_ap_ipi(struct vdec_vpu_inst *vpu, unsigned int msg_id)
+{
+	struct vdec_ap_ipi_cmd msg;
+	int err = 0;
+
+	mtk_vcodec_debug(vpu, "+ id=%X", msg_id);
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = msg_id;
+	msg.vpu_inst_addr = vpu->inst_addr;
+
+	err = vcodec_vpu_send_msg(vpu, &msg, sizeof(msg));
+	mtk_vcodec_debug(vpu, "- id=%X ret=%d", msg_id, err);
+	return err;
+}
+
+int vpu_dec_init(struct vdec_vpu_inst *vpu)
+{
+	struct vdec_ap_ipi_init msg;
+	int err;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	init_waitqueue_head(&vpu->wq);
+
+	err = vpu_ipi_register(vpu->dev, vpu->id, vpu->handler, "vdec", NULL);
+	if (err != 0) {
+		mtk_vcodec_err(vpu, "vpu_ipi_register fail status=%d", err);
+		return err;
+	}
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = AP_IPIMSG_DEC_INIT;
+	msg.ap_inst_addr = (unsigned long)vpu;
+
+	mtk_vcodec_debug(vpu, "vdec_inst=%p", vpu);
+
+	err = vcodec_vpu_send_msg(vpu, (void *)&msg, sizeof(msg));
+	mtk_vcodec_debug(vpu, "- ret=%d", err);
+	return err;
+}
+
+int vpu_dec_start(struct vdec_vpu_inst *vpu, uint32_t *data, unsigned int len)
+{
+	struct vdec_ap_ipi_dec_start msg;
+	int i;
+	int err = 0;
+
+	mtk_vcodec_debug_enter(vpu);
+
+	if (len > ARRAY_SIZE(msg.data)) {
+		mtk_vcodec_err(vpu, "invalid len = %d\n", len);
+		return -EINVAL;
+	}
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_id = AP_IPIMSG_DEC_START;
+	msg.vpu_inst_addr = vpu->inst_addr;
+
+	for (i = 0; i < len; i++)
+		msg.data[i] = data[i];
+
+	err = vcodec_vpu_send_msg(vpu, (void *)&msg, sizeof(msg));
+	mtk_vcodec_debug(vpu, "- ret=%d", err);
+	return err;
+}
+
+int vpu_dec_end(struct vdec_vpu_inst *vpu)
+{
+	return vcodec_send_ap_ipi(vpu, AP_IPIMSG_DEC_END);
+}
+
+int vpu_dec_deinit(struct vdec_vpu_inst *vpu)
+{
+	return vcodec_send_ap_ipi(vpu, AP_IPIMSG_DEC_DEINIT);
+}
+
+int vpu_dec_reset(struct vdec_vpu_inst *vpu)
+{
+	return vcodec_send_ap_ipi(vpu, AP_IPIMSG_DEC_RESET);
+}
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
new file mode 100644
index 0000000..8dcc1cb
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: PC Chen <pc.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VDEC_VPU_IF_H_
+#define _VDEC_VPU_IF_H_
+
+#include "mtk_vpu.h"
+
+/**
+ * struct vdec_vpu_inst - VPU instance for video codec
+ * @ipi_id      : ipi id for each decoder
+ * @vsi         : driver structure allocated by VPU side and shared to AP side
+ *                for control and info share
+ * @failure     : VPU execution result status, 0: success, others: fail
+ * @inst_addr	: VPU decoder instance address
+ * @signaled    : 1 - Host has received ack message from VPU, 0 - not received
+ * @ctx         : context for v4l2 layer integration
+ * @dev	        : platform device of VPU
+ * @wq          : wait queue to wait VPU message ack
+ * @handler     : ipi handler for each decoder
+ */
+struct vdec_vpu_inst {
+	enum ipi_id id;
+	void *vsi;
+	int32_t failure;
+	uint32_t inst_addr;
+	unsigned int signaled;
+	struct mtk_vcodec_ctx *ctx;
+	struct platform_device *dev;
+	wait_queue_head_t wq;
+	ipi_handler_t handler;
+};
+
+/**
+ * vpu_dec_init - init decoder instance and allocate required resource in VPU.
+ *
+ * @vpu: instance for vdec_vpu_inst
+ */
+int vpu_dec_init(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_start - start decoding, basically the function will be invoked once
+ *                 every frame.
+ *
+ * @vpu : instance for vdec_vpu_inst
+ * @data: meta data to pass bitstream info to VPU decoder
+ * @len : meta data length
+ */
+int vpu_dec_start(struct vdec_vpu_inst *vpu, uint32_t *data, unsigned int len);
+
+/**
+ * vpu_dec_end - end decoding, basically the function will be invoked once
+ *               when HW decoding done interrupt received successfully. The
+ *               decoder in VPU will continute to do referene frame management
+ *               and check if there is a new decoded frame available to display.
+ *
+ * @vpu : instance for vdec_vpu_inst
+ */
+int vpu_dec_end(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_deinit - deinit decoder instance and resource freed in VPU.
+ *
+ * @vpu: instance for vdec_vpu_inst
+ */
+int vpu_dec_deinit(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_reset - reset decoder, use for flush decoder when end of stream or
+ *                 seek. Remainig non displayed frame will be pushed to display.
+ *
+ * @vpu: instance for vdec_vpu_inst
+ */
+int vpu_dec_reset(struct vdec_vpu_inst *vpu);
+
+/**
+ * vpu_dec_ipi_handler - Handler for VPU ipi message.
+ *
+ * @data: ipi message
+ * @len : length of ipi message
+ * @priv: callback private data whcih is passed by decoder when register.
+ */
+void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv);
+
+#endif
-- 
1.7.9.5

