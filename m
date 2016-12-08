Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55401 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751827AbcLHPZc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 10:25:32 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 8/9] [media] coda: use VDOA for un-tiling custom macroblock format
Date: Thu,  8 Dec 2016 16:24:15 +0100
Message-Id: <20161208152416.16031-8-m.tretter@pengutronix.de>
In-Reply-To: <20161208152416.16031-1-m.tretter@pengutronix.de>
References: <20161208152416.16031-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the CODA driver is configured to produce NV12 output and the VDOA is
available, the VDOA can be used to transform the custom macroblock tiled
format to a raster-ordered format for scanout.

In this case, set the output format of the CODA to the custom macroblock
tiled format, disable the rotator, and use the VDOA to write to the v4l2
buffer. The VDOA is synchronized with the CODA to always un-tile the
frame that the CODA finished in the previous run.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 77 +++++++++++++++++++++----------
 drivers/media/platform/coda/coda-common.c | 55 ++++++++++++++++++++--
 drivers/media/platform/coda/coda.h        |  2 +
 3 files changed, 104 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 309eb4e..3e2f830 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -30,6 +30,7 @@
 #include <media/videobuf2-vmalloc.h>
 
 #include "coda.h"
+#include "imx-vdoa.h"
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
@@ -1517,6 +1518,10 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	u32 val;
 	int ret;
 
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "Video Data Order Adapter: %s\n",
+		 ctx->use_vdoa ? "Enabled" : "Disabled");
+
 	/* Start decoding */
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
@@ -1535,7 +1540,8 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	if (dst_fourcc == V4L2_PIX_FMT_NV12)
 		ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
 	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
-		ctx->frame_mem_ctrl |= (0x3 << 9) | CODA9_FRAME_TILED2LINEAR;
+		ctx->frame_mem_ctrl |= (0x3 << 9) |
+			((ctx->use_vdoa) ? 0 : CODA9_FRAME_TILED2LINEAR);
 	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	ctx->display_idx = -1;
@@ -1724,6 +1730,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
 	unsigned long flags;
+	u32 rot_mode = 0;
 	u32 reg_addr, reg_stride;
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -1759,27 +1766,40 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	if (dev->devtype->product == CODA_960)
 		coda_set_gdi_regs(ctx);
 
-	if (dev->devtype->product == CODA_960) {
-		/*
-		 * The CODA960 seems to have an internal list of buffers with
-		 * 64 entries that includes the registered frame buffers as
-		 * well as the rotator buffer output.
-		 * ROT_INDEX needs to be < 0x40, but > ctx->num_internal_frames.
-		 */
-		coda_write(dev, CODA_MAX_FRAMEBUFFERS + dst_buf->vb2_buf.index,
-				CODA9_CMD_DEC_PIC_ROT_INDEX);
-
-		reg_addr = CODA9_CMD_DEC_PIC_ROT_ADDR_Y;
-		reg_stride = CODA9_CMD_DEC_PIC_ROT_STRIDE;
+	if (ctx->use_vdoa &&
+	    ctx->display_idx >= 0 &&
+	    ctx->display_idx < ctx->num_internal_frames) {
+		vdoa_device_run(ctx->vdoa,
+				vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0),
+				ctx->internal_frames[ctx->display_idx].paddr);
 	} else {
-		reg_addr = CODA_CMD_DEC_PIC_ROT_ADDR_Y;
-		reg_stride = CODA_CMD_DEC_PIC_ROT_STRIDE;
+		if (dev->devtype->product == CODA_960) {
+			/*
+			 * The CODA960 seems to have an internal list of
+			 * buffers with 64 entries that includes the
+			 * registered frame buffers as well as the rotator
+			 * buffer output.
+			 *
+			 * ROT_INDEX needs to be < 0x40, but >
+			 * ctx->num_internal_frames.
+			 */
+			coda_write(dev,
+				   CODA_MAX_FRAMEBUFFERS + dst_buf->vb2_buf.index,
+				   CODA9_CMD_DEC_PIC_ROT_INDEX);
+
+			reg_addr = CODA9_CMD_DEC_PIC_ROT_ADDR_Y;
+			reg_stride = CODA9_CMD_DEC_PIC_ROT_STRIDE;
+		} else {
+			reg_addr = CODA_CMD_DEC_PIC_ROT_ADDR_Y;
+			reg_stride = CODA_CMD_DEC_PIC_ROT_STRIDE;
+		}
+		coda_write_base(ctx, q_data_dst, dst_buf, reg_addr);
+		coda_write(dev, q_data_dst->bytesperline, reg_stride);
+
+		rot_mode = CODA_ROT_MIR_ENABLE | ctx->params.rot_mode;
 	}
-	coda_write_base(ctx, q_data_dst, dst_buf, reg_addr);
-	coda_write(dev, q_data_dst->bytesperline, reg_stride);
 
-	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode,
-			CODA_CMD_DEC_PIC_ROT_MODE);
+	coda_write(dev, rot_mode, CODA_CMD_DEC_PIC_ROT_MODE);
 
 	switch (dev->devtype->product) {
 	case CODA_DX6:
@@ -1851,6 +1871,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	u32 src_fourcc;
 	int success;
 	u32 err_mb;
+	int err_vdoa = 0;
 	u32 val;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
@@ -1934,13 +1955,17 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		}
 	}
 
+	/* Wait until the VDOA finished writing the previous display frame */
+	if (ctx->use_vdoa &&
+	    ctx->display_idx >= 0 &&
+	    ctx->display_idx < ctx->num_internal_frames) {
+		err_vdoa = vdoa_wait_for_completion(ctx->vdoa);
+	}
+
 	ctx->frm_dis_flg = coda_read(dev,
 				     CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
 
-	/*
-	 * The previous display frame was copied out by the rotator,
-	 * now it can be overwritten again
-	 */
+	/* The previous display frame was copied out and can be overwritten */
 	if (ctx->display_idx >= 0 &&
 	    ctx->display_idx < ctx->num_internal_frames) {
 		ctx->frm_dis_flg &= ~(1 << ctx->display_idx);
@@ -2057,8 +2082,10 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		}
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
 
-		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[ctx->display_idx] ?
-				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		if (ctx->frame_errors[ctx->display_idx] || err_vdoa)
+			coda_m2m_buf_done(ctx, dst_buf, VB2_BUF_STATE_ERROR);
+		else
+			coda_m2m_buf_done(ctx, dst_buf, VB2_BUF_STATE_DONE);
 
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			"job finished: decoding frame (%d) (%s)\n",
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 3a21000..8b23ea4 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -450,6 +450,30 @@ static int coda_try_pixelformat(struct coda_ctx *ctx, struct v4l2_format *f)
 	return 0;
 }
 
+static int coda_try_vdoa(struct coda_ctx *ctx, struct v4l2_format *f)
+{
+	int err;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (!ctx->vdoa) {
+		ctx->use_vdoa = false;
+		return 0;
+	}
+
+	err = vdoa_context_configure(ctx->vdoa, f->fmt.pix.width,
+				     f->fmt.pix.height, f->fmt.pix.pixelformat);
+	if (err) {
+		ctx->use_vdoa = false;
+		return 0;
+	}
+
+	ctx->use_vdoa = true;
+
+	return 0;
+}
+
 static unsigned int coda_estimate_sizeimage(struct coda_ctx *ctx, u32 sizeimage,
 					    u32 width, u32 height)
 {
@@ -564,6 +588,10 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 				       f->fmt.pix.height * 3 / 2;
+
+		ret = coda_try_vdoa(ctx, f);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
@@ -632,13 +660,20 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 		q_data->rect.height = f->fmt.pix.height;
 	}
 
+	/*
+	 * It would be nice to set use_vdoa in coda_s_fmt instead of
+	 * coda_try_vdoa() to have a single location where this is changed.
+	 * Unfortunately, if the capture format is V4L2_PIX_FMT_NV12, we
+	 * cannot be sure if the VDOA should be used, without storing the
+	 * result of coda_try_vdoa() or calling vdoa_context_configure()
+	 * again. Therefore, set use_vdoa in coda_try_vdoa.
+	 */
+
 	switch (f->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_NV12:
-		if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-			ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
-			if (!disable_tiling)
-				break;
-		}
+		ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
+		if (!disable_tiling)
+			break;
 		/* else fall through */
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
@@ -1764,6 +1799,13 @@ static int coda_open(struct file *file)
 	default:
 		ctx->reg_idx = idx;
 	}
+	if (ctx->dev->vdoa) {
+		ctx->vdoa = vdoa_context_create(dev->vdoa);
+		if (!ctx->vdoa)
+			v4l2_warn(&dev->v4l2_dev,
+				  "Failed to create vdoa context: not using vdoa");
+	}
+	ctx->use_vdoa = false;
 
 	/* Power up and upload firmware if necessary */
 	ret = pm_runtime_get_sync(&dev->plat_dev->dev);
@@ -1839,6 +1881,9 @@ static int coda_release(struct file *file)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
 		 ctx);
 
+	if (ctx->vdoa)
+		vdoa_context_destroy(ctx->vdoa);
+
 	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit)
 		coda_bit_stream_end_flag(ctx);
 
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index ae202dc..7ed79eb 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -237,6 +237,8 @@ struct coda_ctx {
 	int				display_idx;
 	struct dentry			*debugfs_entry;
 	bool				use_bit;
+	bool				use_vdoa;
+	struct vdoa_ctx			*vdoa;
 };
 
 extern int coda_debug;
-- 
2.10.2

