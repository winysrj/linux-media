Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40089 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaI2MyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/6] [media] coda: add coda_write_base helper
Date: Mon, 29 Sep 2014 14:53:44 +0200
Message-Id: <1411995227-3623-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
References: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper function that writes a vb2_buffer's Y, Cb, and
Cr plane base addresses of into three consecutive registers.
This moves common code out of coda-bit.c.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 68 +++++++------------------------
 drivers/media/platform/coda/coda-common.c | 24 +++++++++++
 drivers/media/platform/coda/coda.h        |  2 +
 3 files changed, 40 insertions(+), 54 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 9b8ea8b..f01393c 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1036,9 +1036,9 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	int force_ipicture;
 	int quant_param = 0;
-	u32 picture_y, picture_cb, picture_cr;
 	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
 	u32 dst_fourcc;
+	u32 reg;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -1129,37 +1129,17 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
 
 
-	picture_y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	switch (q_data_src->fourcc) {
-	case V4L2_PIX_FMT_YVU420:
-		/* Switch Cb and Cr for YVU420 format */
-		picture_cr = picture_y + q_data_src->bytesperline *
-				q_data_src->height;
-		picture_cb = picture_cr + q_data_src->bytesperline / 2 *
-				q_data_src->height / 2;
-		break;
-	case V4L2_PIX_FMT_YUV420:
-	default:
-		picture_cb = picture_y + q_data_src->bytesperline *
-				q_data_src->height;
-		picture_cr = picture_cb + q_data_src->bytesperline / 2 *
-				q_data_src->height / 2;
-		break;
-	}
-
 	if (dev->devtype->product == CODA_960) {
 		coda_write(dev, 4/*FIXME: 0*/, CODA9_CMD_ENC_PIC_SRC_INDEX);
 		coda_write(dev, q_data_src->width, CODA9_CMD_ENC_PIC_SRC_STRIDE);
 		coda_write(dev, 0, CODA9_CMD_ENC_PIC_SUB_FRAME_SYNC);
 
-		coda_write(dev, picture_y, CODA9_CMD_ENC_PIC_SRC_ADDR_Y);
-		coda_write(dev, picture_cb, CODA9_CMD_ENC_PIC_SRC_ADDR_CB);
-		coda_write(dev, picture_cr, CODA9_CMD_ENC_PIC_SRC_ADDR_CR);
+		reg = CODA9_CMD_ENC_PIC_SRC_ADDR_Y;
 	} else {
-		coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
-		coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
-		coda_write(dev, picture_cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
+		reg = CODA_CMD_ENC_PIC_SRC_ADDR_Y;
 	}
+	coda_write_base(ctx, q_data_src, src_buf, reg);
+
 	coda_write(dev, force_ipicture << 1 & 0x2,
 		   CODA_CMD_ENC_PIC_OPTION);
 
@@ -1501,20 +1481,11 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	struct vb2_buffer *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
-	u32 stridey, height;
-	u32 picture_y, picture_cb, picture_cr;
+	u32 reg_addr, reg_stride;
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
-	if (ctx->params.rot_mode & CODA_ROT_90) {
-		stridey = q_data_dst->height;
-		height = q_data_dst->width;
-	} else {
-		stridey = q_data_dst->width;
-		height = q_data_dst->height;
-	}
-
 	/* Try to copy source buffer contents into the bitstream ringbuffer */
 	mutex_lock(&ctx->bitstream_mutex);
 	coda_fill_bitstream(ctx);
@@ -1545,17 +1516,6 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	if (dev->devtype->product == CODA_960)
 		coda_set_gdi_regs(ctx);
 
-	/* Set rotator output */
-	picture_y = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
-	if (q_data_dst->fourcc == V4L2_PIX_FMT_YVU420) {
-		/* Switch Cr and Cb for YVU420 format */
-		picture_cr = picture_y + stridey * height;
-		picture_cb = picture_cr + stridey / 2 * height / 2;
-	} else {
-		picture_cb = picture_y + stridey * height;
-		picture_cr = picture_cb + stridey / 2 * height / 2;
-	}
-
 	if (dev->devtype->product == CODA_960) {
 		/*
 		 * The CODA960 seems to have an internal list of buffers with
@@ -1565,16 +1525,16 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		 */
 		coda_write(dev, CODA_MAX_FRAMEBUFFERS + dst_buf->v4l2_buf.index,
 				CODA9_CMD_DEC_PIC_ROT_INDEX);
-		coda_write(dev, picture_y, CODA9_CMD_DEC_PIC_ROT_ADDR_Y);
-		coda_write(dev, picture_cb, CODA9_CMD_DEC_PIC_ROT_ADDR_CB);
-		coda_write(dev, picture_cr, CODA9_CMD_DEC_PIC_ROT_ADDR_CR);
-		coda_write(dev, stridey, CODA9_CMD_DEC_PIC_ROT_STRIDE);
+
+		reg_addr = CODA9_CMD_DEC_PIC_ROT_ADDR_Y;
+		reg_stride = CODA9_CMD_DEC_PIC_ROT_STRIDE;
 	} else {
-		coda_write(dev, picture_y, CODA_CMD_DEC_PIC_ROT_ADDR_Y);
-		coda_write(dev, picture_cb, CODA_CMD_DEC_PIC_ROT_ADDR_CB);
-		coda_write(dev, picture_cr, CODA_CMD_DEC_PIC_ROT_ADDR_CR);
-		coda_write(dev, stridey, CODA_CMD_DEC_PIC_ROT_STRIDE);
+		reg_addr = CODA_CMD_DEC_PIC_ROT_ADDR_Y;
+		reg_stride = CODA_CMD_DEC_PIC_ROT_STRIDE;
 	}
+	coda_write_base(ctx, q_data_dst, dst_buf, reg_addr);
+	coda_write(dev, q_data_dst->bytesperline, reg_stride);
+
 	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode,
 			CODA_CMD_DEC_PIC_ROT_MODE);
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 538d4ac..fac2517 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -82,6 +82,30 @@ unsigned int coda_read(struct coda_dev *dev, u32 reg)
 	return data;
 }
 
+void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
+		     struct vb2_buffer *buf, unsigned int reg_y)
+{
+	u32 base_y = vb2_dma_contig_plane_dma_addr(buf, 0);
+	u32 base_cb, base_cr;
+
+	switch (q_data->fourcc) {
+	case V4L2_PIX_FMT_YVU420:
+		/* Switch Cb and Cr for YVU420 format */
+		base_cr = base_y + q_data->bytesperline * q_data->height;
+		base_cb = base_cr + q_data->bytesperline * q_data->height / 4;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+	default:
+		base_cb = base_y + q_data->bytesperline * q_data->height;
+		base_cr = base_cb + q_data->bytesperline * q_data->height / 4;
+		break;
+	}
+
+	coda_write(ctx->dev, base_y, reg_y);
+	coda_write(ctx->dev, base_cb, reg_y + 4);
+	coda_write(ctx->dev, base_cr, reg_y + 8);
+}
+
 /*
  * Array of all formats supported by any version of Coda:
  */
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index bbc18c0..76ba83c 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -232,6 +232,8 @@ extern int coda_debug;
 
 void coda_write(struct coda_dev *dev, u32 data, u32 reg);
 unsigned int coda_read(struct coda_dev *dev, u32 reg);
+void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
+		     struct vb2_buffer *buf, unsigned int reg_y);
 
 int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 		       size_t size, const char *name, struct dentry *parent);
-- 
2.1.0

