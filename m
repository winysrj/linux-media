Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60829 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbbAWQvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 21/21] [media] coda: simplify check in coda_buf_queue
Date: Fri, 23 Jan 2015 17:51:35 +0100
Message-Id: <1422031895-7740-22-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the bitstream buffer is only allocated for the BIT decoder
case, we can use bitstream.size to check for bitstream ringbuffer
operation.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c19f4b7..3118076 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1154,6 +1154,7 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_queue *vq = vb->vb2_queue;
 	struct coda_q_data *q_data;
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
@@ -1162,8 +1163,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 	 * In the decoder case, immediately try to copy the buffer into the
 	 * bitstream ringbuffer and mark it as ready to be dequeued.
 	 */
-	if (ctx->use_bit && ctx->inst_type == CODA_INST_DECODER &&
-	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+	if (ctx->bitstream.size && vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/*
 		 * For backwards compatibility, queuing an empty buffer marks
 		 * the stream end
-- 
2.1.4

