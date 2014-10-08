Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaJHQJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 12:09:30 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: drop JPEG buffers not framed by SOI and EOI markers
Date: Wed,  8 Oct 2014 18:09:27 +0200
Message-Id: <1412784567-18222-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a quick check for valid JPEG frames before feeding them into
the bitstream buffer: Frames that do not begin with the JPEG start of image
marker and end with the end of image marker are dropped.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c  | 10 ++++++++++
 drivers/media/platform/coda/coda-jpeg.c | 13 +++++++++++++
 drivers/media/platform/coda/coda.h      |  1 +
 3 files changed, 24 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 0c67cfd..b4029ae 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -231,6 +231,16 @@ void coda_fill_bitstream(struct coda_ctx *ctx)
 
 		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
+		/* Drop frames that do not start/end with a SOI/EOI markers */
+		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG &&
+		    !coda_jpeg_check_buffer(ctx, src_buf)) {
+			v4l2_err(&ctx->dev->v4l2_dev,
+				 "dropping invalid JPEG frame\n");
+			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+			continue;
+		}
+
 		/* Buffer start position */
 		start = ctx->bitstream_fifo.kfifo.in &
 			ctx->bitstream_fifo.kfifo.mask;
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 967b015..8fa3e35 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -14,6 +14,9 @@
 
 #include "coda.h"
 
+#define SOI_MARKER	0xffd8
+#define EOI_MARKER	0xffd9
+
 /*
  * Typical Huffman tables for 8-bit precision luminance and
  * chrominance from JPEG ITU-T.81 (ISO/IEC 10918-1) Annex K.3
@@ -174,6 +177,16 @@ int coda_jpeg_write_tables(struct coda_ctx *ctx)
 	return 0;
 }
 
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb)
+{
+	void *vaddr = vb2_plane_vaddr(vb, 0);
+	u16 soi = be16_to_cpup((__be16 *)vaddr);
+	u16 eoi = be16_to_cpup((__be16 *)(vaddr +
+					  vb2_get_plane_payload(vb, 0) - 2));
+
+	return soi == SOI_MARKER && eoi == EOI_MARKER;
+}
+
 /*
  * Scale quantization table using nonlinear scaling factor
  * u8 qtab[64], scale [50,190]
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 8dd81a7..5dd47e5 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -293,6 +293,7 @@ void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 
 int coda_h264_padding(int size, char *p);
 
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
 void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality);
 
-- 
2.1.0

