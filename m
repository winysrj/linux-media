Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59255 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbaGWP3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/8] [media] coda: add coda_bit_stream_set_flag helper
Date: Wed, 23 Jul 2014 17:28:42 +0200
Message-Id: <1406129325-10771-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a helper function to consolidate three occurences where
the bitstream parameter stream end flag is set during operation.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 52 +++++++++++--------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04a7b12..547744a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -187,6 +187,20 @@ static int coda_hw_reset(struct coda_ctx *ctx)
 	return ret;
 }
 
+static void coda_bit_stream_end_flag(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+
+	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+
+	if ((dev->devtype->product == CODA_960) &&
+	    coda_isbusy(dev) &&
+	    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
+		/* If this context is currently running, update the hardware flag */
+		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
+	}
+}
+
 static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
 					 enum v4l2_buf_type type)
 {
@@ -732,7 +746,6 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 			    struct v4l2_decoder_cmd *dc)
 {
 	struct coda_ctx *ctx = fh_to_ctx(fh);
-	struct coda_dev *dev = ctx->dev;
 	int ret;
 
 	ret = coda_try_decoder_cmd(file, fh, dc);
@@ -743,15 +756,8 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 	if (ctx->inst_type != CODA_INST_DECODER)
 		return 0;
 
-	/* Set the strem-end flag on this context */
-	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
-
-	if ((dev->devtype->product == CODA_960) &&
-	    coda_isbusy(dev) &&
-	    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
-		/* If this context is currently running, update the hardware flag */
-		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
-	}
+	/* Set the stream-end flag on this context */
+	coda_bit_stream_end_flag(ctx);
 	ctx->hold = false;
 	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
 
@@ -1474,7 +1480,6 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data;
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
@@ -1489,15 +1494,8 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		 * For backwards compatibility, queuing an empty buffer marks
 		 * the stream end
 		 */
-		if (vb2_get_plane_payload(vb, 0) == 0) {
-			ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
-			if ((dev->devtype->product == CODA_960) &&
-			    coda_isbusy(dev) &&
-			    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
-				/* if this decoder instance is running, set the stream end flag */
-				coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
-			}
-		}
+		if (vb2_get_plane_payload(vb, 0) == 0)
+			coda_bit_stream_end_flag(ctx);
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 		if (vb2_is_streaming(vb->vb2_queue))
@@ -2494,19 +2492,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			 "%s: output\n", __func__);
 		ctx->streamon_out = 0;
 
-		if (ctx->inst_type == CODA_INST_DECODER &&
-		    coda_isbusy(dev) && ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX)) {
-			/* if this decoder instance is running, set the stream end flag */
-			if (dev->devtype->product == CODA_960) {
-				u32 val = coda_read(dev, CODA_REG_BIT_BIT_STREAM_PARAM);
-
-				val |= CODA_BIT_STREAM_END_FLAG;
-				coda_write(dev, val, CODA_REG_BIT_BIT_STREAM_PARAM);
-				ctx->bit_stream_param = val;
-			}
-		}
-		ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
-
+		coda_bit_stream_end_flag(ctx);
 		ctx->isequence = 0;
 	} else {
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-- 
2.0.1

