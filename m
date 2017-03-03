Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:60157 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751611AbdCCMcO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 07:32:14 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/4] [media] coda: pad first h.264 buffer to 512 bytes
Date: Fri,  3 Mar 2017 13:12:49 +0100
Message-Id: <20170303121250.13693-3-p.zabel@pengutronix.de>
In-Reply-To: <20170303121250.13693-1-p.zabel@pengutronix.de>
References: <20170303121250.13693-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bitstream reader needs 512 bytes ready to read to examine the
headers in the first frame. If that frame is too small, prepend it
with a filler NAL.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c  | 28 ++++++++++++++++++++++++++--
 drivers/media/platform/coda/coda-h264.c | 24 ++++++++++++++++++------
 drivers/media/platform/coda/coda.h      |  1 +
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index e3e3225607836..89965ca5bd250 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -179,6 +179,25 @@ static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
 	coda_write(dev, wr_ptr, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
 }
 
+static int coda_bitstream_pad(struct coda_ctx *ctx, u32 size)
+{
+	unsigned char *buf;
+	u32 n;
+
+	if (size < 6)
+		size = 6;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	coda_h264_filler_nal(size, buf);
+	n = kfifo_in(&ctx->bitstream_fifo, buf, size);
+	kfree(buf);
+
+	return (n < size) ? -ENOSPC : 0;
+}
+
 static int coda_bitstream_queue(struct coda_ctx *ctx,
 				struct vb2_v4l2_buffer *src_buf)
 {
@@ -198,10 +217,10 @@ static int coda_bitstream_queue(struct coda_ctx *ctx,
 static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 				     struct vb2_v4l2_buffer *src_buf)
 {
+	unsigned long payload = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
 	int ret;
 
-	if (coda_get_bitstream_payload(ctx) +
-	    vb2_get_plane_payload(&src_buf->vb2_buf, 0) + 512 >=
+	if (coda_get_bitstream_payload(ctx) + payload + 512 >=
 	    ctx->bitstream.size)
 		return false;
 
@@ -210,6 +229,11 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 		return true;
 	}
 
+	/* Add zero padding before the first H.264 buffer, if it is too small */
+	if (ctx->qsequence == 0 && payload < 512 &&
+	    ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
+		coda_bitstream_pad(ctx, 512 - payload);
+
 	ret = coda_bitstream_queue(ctx, src_buf);
 	if (ret < 0) {
 		v4l2_err(&ctx->dev->v4l2_dev, "bitstream buffer overflow\n");
diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index 09dfcca7cc500..dc137c3fd510b 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -15,10 +15,25 @@
 #include <linux/string.h>
 #include <coda.h>
 
-static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
-			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
 static const u8 coda_filler_size[8] = { 0, 7, 14, 13, 12, 11, 10, 9 };
 
+int coda_h264_filler_nal(int size, char *p)
+{
+	if (size < 6)
+		return -EINVAL;
+
+	p[0] = 0x00;
+	p[1] = 0x00;
+	p[2] = 0x00;
+	p[3] = 0x01;
+	p[4] = 0x0c;
+	memset(p + 5, 0xff, size - 6);
+	/* Add rbsp stop bit and trailing at the end */
+	p[size - 1] = 0x80;
+
+	return 0;
+}
+
 int coda_h264_padding(int size, char *p)
 {
 	int nal_size;
@@ -29,10 +44,7 @@ int coda_h264_padding(int size, char *p)
 		return 0;
 
 	nal_size = coda_filler_size[diff];
-	memcpy(p, coda_filler_nal, nal_size);
-
-	/* Add rbsp stop bit and trailing at the end */
-	*(p + nal_size - 1) = 0x80;
+	coda_h264_filler_nal(nal_size, p);
 
 	return nal_size;
 }
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 6aa9c19c4a896..a730bc2a2ff99 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -290,6 +290,7 @@ void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		       enum vb2_buffer_state state);
 
+int coda_h264_filler_nal(int size, char *p);
 int coda_h264_padding(int size, char *p);
 
 bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
-- 
2.11.0
