Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44514 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaFMQJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 23/30] [media] coda: add sequence counter offset
Date: Fri, 13 Jun 2014 18:08:49 +0200
Message-Id: <1402675736-15379-24-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda h.264 decoder also counts PIC_RUNs where no frame was decoded but
a frame was rotated out / marked as ready to be displayed. This causes an
offset between the incoming encoded frame's sequence number and the decode
sequence number returned by the coda. This patch introduces a sequence
counter offset variable to keep track of the difference.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 93836c8..4641667dbc 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -222,6 +222,7 @@ struct coda_ctx {
 	u32				isequence;
 	u32				qsequence;
 	u32				osequence;
+	u32				sequence_offset;
 	struct coda_q_data		q_data[2];
 	enum coda_inst_type		inst_type;
 	struct coda_codec		*codec;
@@ -2674,6 +2675,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 		ctx->streamon_cap = 0;
 
 		ctx->osequence = 0;
+		ctx->sequence_offset = 0;
 	}
 
 	if (!ctx->streamon_out && !ctx->streamon_cap) {
@@ -3179,7 +3181,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 	if (decoded_idx == -1) {
 		/* no frame was decoded, but we might have a display frame */
-		if (display_idx < 0 && ctx->display_idx < 0)
+		if (display_idx >= 0 && display_idx < ctx->num_internal_frames)
+			ctx->sequence_offset++;
+		else if (ctx->display_idx < 0)
 			ctx->prescan_failed = true;
 	} else if (decoded_idx == -2) {
 		/* no frame was decoded, we still return the remaining buffers */
@@ -3191,10 +3195,11 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 				      struct coda_timestamp, list);
 		list_del(&ts->list);
 		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
+		val -= ctx->sequence_offset;
 		if (val != ts->sequence) {
 			v4l2_err(&dev->v4l2_dev,
-				 "sequence number mismatch (%d != %d)\n",
-				 val, ts->sequence);
+				 "sequence number mismatch (%d(%d) != %d)\n",
+				 val, ctx->sequence_offset, ts->sequence);
 		}
 		ctx->frame_timestamps[decoded_idx] = *ts;
 		kfree(ts);
-- 
2.0.0.rc2

