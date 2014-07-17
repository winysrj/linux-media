Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39230 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934692AbaGQQFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 06/11] [media] coda: delay coda_fill_bitstream()
Date: Thu, 17 Jul 2014 18:05:07 +0200
Message-Id: <1405613112-22442-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Olbrich <m.olbrich@pengutronix.de>

coda_fill_bitstream() calls v4l2_m2m_buf_done() which is no longer allowed
before streaming was started.
Delay coda_fill_bitstream() until coda_start_streaming() and explicitly set
'start_streaming_called' before calling coda_fill_bitstream()

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 141ec29..3d57986 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1682,7 +1682,8 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		}
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
-		coda_fill_bitstream(ctx);
+		if (vb2_is_streaming(vb->vb2_queue))
+			coda_fill_bitstream(ctx);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
@@ -2272,6 +2273,15 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
+			struct vb2_queue *vq;
+			/* start_streaming_called must be set, for v4l2_m2m_buf_done() */
+			vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+			vq->start_streaming_called = 1;
+			/* copy the buffers that where queued before streamon */
+			mutex_lock(&ctx->bitstream_mutex);
+			coda_fill_bitstream(ctx);
+			mutex_unlock(&ctx->bitstream_mutex);
+
 			if (coda_get_bitstream_payload(ctx) < 512)
 				return -EINVAL;
 		} else {
-- 
2.0.1

