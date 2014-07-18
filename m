Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35209 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761589AbaGRKXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:23:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 06/11] [media] coda: delay coda_fill_bitstream()
Date: Fri, 18 Jul 2014 12:22:40 +0200
Message-Id: <1405678965-10473-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
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
Changes since v1:
 - Don't set vb2_queue start_streaming_called anymore, it is now set by
   the core before coda_start_streaming is called.
---
 drivers/media/platform/coda.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 141ec29..924ad58 100644
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
@@ -2272,6 +2273,11 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
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

