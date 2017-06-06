Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51887 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751427AbdFFP7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 11:59:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] coda: copy headers in front of every I-frame
Date: Tue,  6 Jun 2017 17:59:02 +0200
Message-Id: <20170606155902.3703-2-p.zabel@pengutronix.de>
In-Reply-To: <20170606155902.3703-1-p.zabel@pengutronix.de>
References: <20170606155902.3703-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That way we don't have to rely on userspace to inject the headers on IDR
requests, and there is always enough information to start decoding at an
I-frame.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 22e4630f36711..2ec41375a896f 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1270,10 +1270,10 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 		coda_set_gdi_regs(ctx);
 
 	/*
-	 * Copy headers at the beginning of the first frame for H.264 only.
-	 * In MPEG4 they are already copied by the coda.
+	 * Copy headers in front of the first frame and forced I frames for
+	 * H.264 only. In MPEG4 they are already copied by the CODA.
 	 */
-	if (src_buf->sequence == 0) {
+	if (src_buf->sequence == 0 || force_ipicture) {
 		pic_stream_buffer_addr =
 			vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0) +
 			ctx->vpu_header_size[0] +
@@ -1386,7 +1386,8 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
 
 	/* Calculate bytesused field */
-	if (dst_buf->sequence == 0) {
+	if (dst_buf->sequence == 0 ||
+	    src_buf->flags & V4L2_BUF_FLAG_KEYFRAME) {
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, wr_ptr - start_ptr +
 					ctx->vpu_header_size[0] +
 					ctx->vpu_header_size[1] +
-- 
2.11.0
