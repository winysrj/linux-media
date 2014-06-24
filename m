Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaFXO43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 21/29] [media] coda: alert userspace about macroblock errors
Date: Tue, 24 Jun 2014 16:56:03 +0200
Message-Id: <1403621771-11636-22-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the CODA reports macroblock errors, also set the VB2_BUF_STATE_ERROR flag
to alert userspace.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index a929bbd..6e65ab9 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -243,6 +243,7 @@ struct coda_ctx {
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
 	u32				frame_types[CODA_MAX_FRAMEBUFFERS];
 	struct coda_timestamp		frame_timestamps[CODA_MAX_FRAMEBUFFERS];
+	u32				frame_errors[CODA_MAX_FRAMEBUFFERS];
 	struct list_head		timestamp_list;
 	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
@@ -3015,6 +3016,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	int display_idx;
 	u32 src_fourcc;
 	int success;
+	u32 err_mb;
 	u32 val;
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -3084,10 +3086,10 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		/* no cropping */
 	}
 
-	val = coda_read(dev, CODA_RET_DEC_PIC_ERR_MB);
-	if (val > 0)
+	err_mb = coda_read(dev, CODA_RET_DEC_PIC_ERR_MB);
+	if (err_mb > 0)
 		v4l2_err(&dev->v4l2_dev,
-			 "errors in %d macroblocks\n", val);
+			 "errors in %d macroblocks\n", err_mb);
 
 	if (dev->devtype->product == CODA_7541) {
 		val = coda_read(dev, CODA_RET_DEC_PIC_OPTION);
@@ -3150,6 +3152,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_PFRAME;
 		else
 			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_BFRAME;
+
+		ctx->frame_errors[decoded_idx] = err_mb;
 	}
 
 	if (display_idx == -1) {
@@ -3182,8 +3186,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 		vb2_set_plane_payload(dst_buf, 0, width * height * 3 / 2);
 
-		v4l2_m2m_buf_done(dst_buf, success ? VB2_BUF_STATE_DONE :
-						     VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_buf, ctx->frame_errors[display_idx] ?
+				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			"job finished: decoding frame (%d) (%s)\n",
-- 
2.0.0

