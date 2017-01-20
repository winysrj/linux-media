Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42531 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752378AbdATOAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 09:00:40 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v4 6/7] [media] coda: use VDOA for un-tiling custom macroblock format
Date: Fri, 20 Jan 2017 15:00:24 +0100
Message-Id: <20170120140025.3338-7-m.tretter@pengutronix.de>
In-Reply-To: <20170120140025.3338-1-m.tretter@pengutronix.de>
References: <20170120140025.3338-1-m.tretter@pengutronix.de>
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
 drivers/media/platform/coda/coda-bit.c    |  86 +++++++++++++++++-------
 drivers/media/platform/coda/coda-common.c | 104 ++++++++++++++++++++++++++++--
 drivers/media/platform/coda/coda.h        |   3 +
 3 files changed, 163 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 309eb4eb5ad1..f608de4c52ac 100644
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
@@ -1618,6 +1624,15 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		 __func__, ctx->idx, width, height);
 
 	ctx->num_internal_frames = coda_read(dev, CODA_RET_DEC_SEQ_FRAME_NEED);
+	/*
+	 * If the VDOA is used, the decoder needs one additional frame,
+	 * because the frames are freed when the next frame is decoded.
+	 * Otherwise there are visible errors in the decoded frames (green
+	 * regions in displayed frames) and a broken order of frames (earlier
+	 * frames are sporadically displayed after later frames).
+	 */
+	if (ctx->use_vdoa)
+		ctx->num_internal_frames += 1;
 	if (ctx->num_internal_frames > CODA_MAX_FRAMEBUFFERS) {
 		v4l2_err(&dev->v4l2_dev,
 			 "not enough framebuffers to decode (%d < %d)\n",
@@ -1724,6 +1739,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
 	unsigned long flags;
+	u32 rot_mode = 0;
 	u32 reg_addr, reg_stride;
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -1759,27 +1775,40 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
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
@@ -1851,6 +1880,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	u32 src_fourcc;
 	int success;
 	u32 err_mb;
+	int err_vdoa = 0;
 	u32 val;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
@@ -1934,13 +1964,17 @@ static void coda_finish_decode(struct coda_ctx *ctx)
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
@@ -2057,8 +2091,10 @@ static void coda_finish_decode(struct coda_ctx *ctx)
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
index b23fe0f0fb56..13ee6cba6847 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -41,6 +41,7 @@
 #include <media/videobuf2-vmalloc.h>
 
 #include "coda.h"
+#include "imx-vdoa.h"
 
 #define CODA_NAME		"coda"
 
@@ -66,6 +67,10 @@ static int disable_tiling;
 module_param(disable_tiling, int, 0644);
 MODULE_PARM_DESC(disable_tiling, "Disable tiled frame buffers");
 
+static int disable_vdoa;
+module_param(disable_vdoa, int, 0644);
+MODULE_PARM_DESC(disable_vdoa, "Disable Video Data Order Adapter tiled to raster-scan conversion");
+
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
@@ -325,6 +330,31 @@ const char *coda_product_name(int product)
 	}
 }
 
+static struct vdoa_data *coda_get_vdoa_data(void)
+{
+	struct device_node *vdoa_node;
+	struct platform_device *vdoa_pdev;
+	struct vdoa_data *vdoa_data = NULL;
+
+	vdoa_node = of_find_compatible_node(NULL, NULL, "fsl,imx6q-vdoa");
+	if (!vdoa_node)
+		return NULL;
+
+	vdoa_pdev = of_find_device_by_node(vdoa_node);
+	if (!vdoa_pdev)
+		goto out;
+
+	vdoa_data = platform_get_drvdata(vdoa_pdev);
+	if (!vdoa_data)
+		vdoa_data = ERR_PTR(-EPROBE_DEFER);
+
+out:
+	if (vdoa_node)
+		of_node_put(vdoa_node);
+
+	return vdoa_data;
+}
+
 /*
  * V4L2 ioctl() operations.
  */
@@ -417,6 +447,33 @@ static int coda_try_pixelformat(struct coda_ctx *ctx, struct v4l2_format *f)
 	return 0;
 }
 
+static int coda_try_fmt_vdoa(struct coda_ctx *ctx, struct v4l2_format *f,
+			     bool *use_vdoa)
+{
+	int err;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (!use_vdoa)
+		return -EINVAL;
+
+	if (!ctx->vdoa) {
+		*use_vdoa = false;
+		return 0;
+	}
+
+	err = vdoa_context_configure(NULL, f->fmt.pix.width, f->fmt.pix.height,
+				     f->fmt.pix.pixelformat);
+	if (err) {
+		*use_vdoa = false;
+		return 0;
+	}
+
+	*use_vdoa = true;
+	return 0;
+}
+
 static unsigned int coda_estimate_sizeimage(struct coda_ctx *ctx, u32 sizeimage,
 					    u32 width, u32 height)
 {
@@ -495,6 +552,7 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 	const struct coda_codec *codec;
 	struct vb2_queue *src_vq;
 	int ret;
+	bool use_vdoa;
 
 	ret = coda_try_pixelformat(ctx, f);
 	if (ret < 0)
@@ -531,6 +589,10 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 				       f->fmt.pix.height * 3 / 2;
+
+		ret = coda_try_fmt_vdoa(ctx, f, &use_vdoa);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
@@ -601,11 +663,9 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 
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
@@ -615,6 +675,15 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 		break;
 	}
 
+	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP &&
+	    !coda_try_fmt_vdoa(ctx, f, &ctx->use_vdoa) &&
+	    ctx->use_vdoa)
+		vdoa_context_configure(ctx->vdoa, f->fmt.pix.width,
+				       f->fmt.pix.height,
+				       f->fmt.pix.pixelformat);
+	else
+		ctx->use_vdoa = false;
+
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 		"Setting format for type %d, wxh: %dx%d, fmt: %4.4s %c\n",
 		f->type, q_data->width, q_data->height,
@@ -1041,6 +1110,16 @@ static int coda_job_ready(void *m2m_priv)
 		bool stream_end = ctx->bit_stream_param &
 				  CODA_BIT_STREAM_END_FLAG;
 		int num_metas = ctx->num_metas;
+		unsigned int count;
+
+		count = hweight32(ctx->frm_dis_flg);
+		if (ctx->use_vdoa && count >= (ctx->num_internal_frames - 1)) {
+			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+				 "%d: not ready: all internal buffers in use: %d/%d (0x%x)",
+				 ctx->idx, count, ctx->num_internal_frames,
+				 ctx->frm_dis_flg);
+			return 0;
+		}
 
 		if (ctx->hold && !src_bufs) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
@@ -1731,6 +1810,13 @@ static int coda_open(struct file *file)
 	default:
 		ctx->reg_idx = idx;
 	}
+	if (ctx->dev->vdoa && !disable_vdoa) {
+		ctx->vdoa = vdoa_context_create(dev->vdoa);
+		if (!ctx->vdoa)
+			v4l2_warn(&dev->v4l2_dev,
+				  "Failed to create vdoa context: not using vdoa");
+	}
+	ctx->use_vdoa = false;
 
 	/* Power up and upload firmware if necessary */
 	ret = pm_runtime_get_sync(&dev->plat_dev->dev);
@@ -1812,6 +1898,9 @@ static int coda_release(struct file *file)
 	/* If this instance is running, call .job_abort and wait for it to end */
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
+	if (ctx->vdoa)
+		vdoa_context_destroy(ctx->vdoa);
+
 	/* In case the instance was not running, we still need to call SEQ_END */
 	if (ctx->ops->seq_end_work) {
 		queue_work(dev->workqueue, &ctx->seq_end_work);
@@ -2258,6 +2347,11 @@ static int coda_probe(struct platform_device *pdev)
 	}
 	dev->iram_pool = pool;
 
+	/* Get vdoa_data if supported by the platform */
+	dev->vdoa = coda_get_vdoa_data();
+	if (PTR_ERR(dev->vdoa) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 53f96661683c..7ed79eb774e7 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -75,6 +75,7 @@ struct coda_dev {
 	struct platform_device	*plat_dev;
 	const struct coda_devtype *devtype;
 	int			firmware;
+	struct vdoa_data	*vdoa;
 
 	void __iomem		*regs_base;
 	struct clk		*clk_per;
@@ -236,6 +237,8 @@ struct coda_ctx {
 	int				display_idx;
 	struct dentry			*debugfs_entry;
 	bool				use_bit;
+	bool				use_vdoa;
+	struct vdoa_ctx			*vdoa;
 };
 
 extern int coda_debug;
-- 
2.11.0

