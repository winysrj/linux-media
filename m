Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51574 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaGKJhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:37:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 23/32] [media] coda: rename prescan_failed to hold and stop stream after timeout
Date: Fri, 11 Jul 2014 11:36:34 +0200
Message-Id: <1405071403-1859-24-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the per-context prescan_failed variable to hold, as this is what the
flag  does: it temporarily keeps the coda from running until new data is fed
into the bitstream buffer or stop_streaming is called on the input side.
A prescan failure on i.MX5 is one possible reason to enter this state, another
one is a picture run timeout on i.MX6.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index d7404e9..4f3d535 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -237,7 +237,7 @@ struct coda_ctx {
 	struct kfifo			bitstream_fifo;
 	struct mutex			bitstream_mutex;
 	struct coda_aux_buf		bitstream;
-	bool				prescan_failed;
+	bool				hold;
 	struct coda_aux_buf		parabuf;
 	struct coda_aux_buf		psbuf;
 	struct coda_aux_buf		slicebuf;
@@ -920,7 +920,7 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 		/* If this context is currently running, update the hardware flag */
 		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
 	}
-	ctx->prescan_failed = false;
+	ctx->hold = false;
 	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
 
 	return 0;
@@ -1052,7 +1052,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 	if (ctx == v4l2_m2m_get_curr_priv(ctx->dev->m2m_dev))
 		coda_kfifo_sync_to_device_write(ctx);
 
-	ctx->prescan_failed = false;
+	ctx->hold = false;
 
 	return true;
 }
@@ -1423,6 +1423,8 @@ static void coda_pic_run_work(struct work_struct *work)
 
 	if (!wait_for_completion_timeout(&ctx->completion, msecs_to_jiffies(1000))) {
 		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
+
+		ctx->hold = true;
 	} else if (!ctx->aborting) {
 		if (ctx->inst_type == CODA_INST_DECODER)
 			coda_finish_decode(ctx);
@@ -1461,7 +1463,7 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
-	if (ctx->prescan_failed ||
+	if (ctx->hold ||
 	    ((ctx->inst_type == CODA_INST_DECODER) &&
 	     (coda_get_bitstream_payload(ctx) < 512) &&
 	     !(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
@@ -3102,7 +3104,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			/* not enough bitstream data */
 			v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 				 "prescan failed: %d\n", val);
-			ctx->prescan_failed = true;
+			ctx->hold = true;
 			return;
 		}
 	}
@@ -3133,7 +3135,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		if (display_idx >= 0 && display_idx < ctx->num_internal_frames)
 			ctx->sequence_offset++;
 		else if (ctx->display_idx < 0)
-			ctx->prescan_failed = true;
+			ctx->hold = true;
 	} else if (decoded_idx == -2) {
 		/* no frame was decoded, we still return the remaining buffers */
 	} else if (decoded_idx < 0 || decoded_idx >= ctx->num_internal_frames) {
@@ -3169,7 +3171,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		 * no more frames to be decoded, but there could still
 		 * be rotator output to dequeue
 		 */
-		ctx->prescan_failed = true;
+		ctx->hold = true;
 	} else if (display_idx == -3) {
 		/* possibly prescan failure */
 	} else if (display_idx < 0 || display_idx >= ctx->num_internal_frames) {
-- 
2.0.0

