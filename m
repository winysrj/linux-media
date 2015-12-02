Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59784 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758965AbbLBRAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2015 12:00:19 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/5] [media] coda: relax coda_jpeg_check_buffer for trailing bytes
Date: Wed,  2 Dec 2015 17:58:51 +0100
Message-Id: <1449075534-8072-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
References: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

coda_jpeg_check_buffer only cares about the buffer length and contents,
so change the parameter type back from v4l2_vb2_buffer to just the
vb2_buffer.
Instead of just checking the first and last bytes for the SOI and EOI
markers, relax the EOI marker check a bit and allow up to 32 trailing
bytes after the EOI marker as hardware generated JPEGs sometimes contain
some alignment overhead.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c  |  2 +-
 drivers/media/platform/coda/coda-jpeg.c | 26 ++++++++++++++++++++------
 drivers/media/platform/coda/coda.h      |  2 +-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 654e964..36424ae 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -246,7 +246,7 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 
 		/* Drop frames that do not start/end with a SOI/EOI markers */
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG &&
-		    !coda_jpeg_check_buffer(ctx, src_buf)) {
+		    !coda_jpeg_check_buffer(ctx, &src_buf->vb2_buf)) {
 			v4l2_err(&ctx->dev->v4l2_dev,
 				 "dropping invalid JPEG frame %d\n",
 				 ctx->qsequence);
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 96cd42a..9f899a6 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -178,14 +178,28 @@ int coda_jpeg_write_tables(struct coda_ctx *ctx)
 	return 0;
 }
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb)
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb)
 {
-	void *vaddr = vb2_plane_vaddr(&vb->vb2_buf, 0);
-	u16 soi = be16_to_cpup((__be16 *)vaddr);
-	u16 eoi = be16_to_cpup((__be16 *)(vaddr +
-			  vb2_get_plane_payload(&vb->vb2_buf, 0) - 2));
+	void *vaddr = vb2_plane_vaddr(vb, 0);
+	u16 soi, eoi;
+	int len, i;
+
+	soi = be16_to_cpup((__be16 *)vaddr);
+	if (soi != SOI_MARKER)
+		return false;
+
+	len = vb2_get_plane_payload(vb, 0);
+	vaddr += len - 2;
+	for (i = 0; i < 32; i++) {
+		eoi = be16_to_cpup((__be16 *)(vaddr - i));
+		if (eoi == EOI_MARKER) {
+			if (i > 0)
+				vb2_set_plane_payload(vb, 0, len - i);
+			return true;
+		}
+	}
 
-	return soi == SOI_MARKER && eoi == EOI_MARKER;
+	return false;
 }
 
 /*
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 96532b0..ce5f5ad 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -289,7 +289,7 @@ void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 
 int coda_h264_padding(int size, char *p);
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb);
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
 void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality);
 
-- 
2.6.2

