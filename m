Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40052 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaI2MyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6/6] [media] coda: add support for partial interleaved YCbCr 4:2:0 (NV12) format
Date: Mon, 29 Sep 2014 14:53:47 +0200
Message-Id: <1411995227-3623-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
References: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the two-plane NV12 format with one luma plane
and one interleaved chroma plane.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 26 +++++++++++++++++++++-----
 drivers/media/platform/coda/coda-common.c |  8 ++++++++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 3839e35..fde7775 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -729,6 +729,9 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		break;
 	}
 
+	ctx->frame_mem_ctrl &= ~CODA_FRAME_CHROMA_INTERLEAVE;
+	if (q_data_src->fourcc == V4L2_PIX_FMT_NV12)
+		ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
 	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	if (dev->devtype->product == CODA_DX6) {
@@ -1128,7 +1131,6 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	coda_write(dev, rot_mode, CODA_CMD_ENC_PIC_ROT_MODE);
 	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
 
-
 	if (dev->devtype->product == CODA_960) {
 		coda_write(dev, 4/*FIXME: 0*/, CODA9_CMD_ENC_PIC_SRC_INDEX);
 		coda_write(dev, q_data_src->width, CODA9_CMD_ENC_PIC_SRC_STRIDE);
@@ -1273,7 +1275,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	u32 bitstream_buf, bitstream_size;
 	struct coda_dev *dev = ctx->dev;
 	int width, height;
-	u32 src_fourcc;
+	u32 src_fourcc, dst_fourcc;
 	u32 val;
 	int ret;
 
@@ -1283,6 +1285,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	bitstream_buf = ctx->bitstream.paddr;
 	bitstream_size = ctx->bitstream.size;
 	src_fourcc = q_data_src->fourcc;
+	dst_fourcc = q_data_dst->fourcc;
 
 	/* Allocate per-instance buffers */
 	ret = coda_alloc_context_buffers(ctx, q_data_src);
@@ -1294,6 +1297,9 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	/* Update coda bitstream read and write pointers from kfifo */
 	coda_kfifo_sync_to_device_full(ctx);
 
+	ctx->frame_mem_ctrl &= ~CODA_FRAME_CHROMA_INTERLEAVE;
+	if (dst_fourcc == V4L2_PIX_FMT_NV12)
+		ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
 	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	ctx->display_idx = -1;
@@ -1424,13 +1430,23 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	}
 
 	if (dev->devtype->product == CODA_960) {
-		coda_write(dev, -1, CODA9_CMD_SET_FRAME_DELAY);
+		int cbb_size, crb_size;
 
+		coda_write(dev, -1, CODA9_CMD_SET_FRAME_DELAY);
+		/* Luma 2x0 page, 2x6 cache, chroma 2x0 page, 2x4 cache size */
 		coda_write(dev, 0x20262024, CODA9_CMD_SET_FRAME_CACHE_SIZE);
+
+		if (dst_fourcc == V4L2_PIX_FMT_NV12) {
+			cbb_size = 0;
+			crb_size = 16;
+		} else {
+			cbb_size = 8;
+			crb_size = 8;
+		}
 		coda_write(dev, 2 << CODA9_CACHE_PAGEMERGE_OFFSET |
 				32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
-				8 << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET |
-				8 << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET,
+				cbb_size << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET |
+				crb_size << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET,
 				CODA9_CMD_SET_FRAME_CACHE_CONFIG);
 	}
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index feb270f..02d47fa 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -95,6 +95,7 @@ void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
 		base_cb = base_cr + q_data->bytesperline * q_data->height / 4;
 		break;
 	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_NV12:
 	default:
 		base_cb = base_y + q_data->bytesperline * q_data->height;
 		base_cr = base_cb + q_data->bytesperline * q_data->height / 4;
@@ -119,6 +120,10 @@ static const struct coda_fmt coda_formats[] = {
 		.fourcc = V4L2_PIX_FMT_YVU420,
 	},
 	{
+		.name = "YUV 4:2:0 Partial interleaved Y/CbCr",
+		.fourcc = V4L2_PIX_FMT_NV12,
+	},
+	{
 		.name = "H264 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H264,
 	},
@@ -162,6 +167,7 @@ static bool coda_format_is_yuv(u32 fourcc)
 	switch (fourcc) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_NV12:
 		return true;
 	default:
 		return false;
@@ -366,6 +372,7 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 	switch (f->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
 	case V4L2_PIX_FMT_JPEG:
@@ -380,6 +387,7 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 	switch (f->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_NV12:
 		/* Frame stride must be multiple of 8, but 16 for h.264 */
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
-- 
2.1.0

