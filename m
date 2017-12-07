Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: set min_buffers_needed
Date: Thu,  7 Dec 2017 12:09:46 +0100
Message-Id: <20171207110946.691-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

The current driver implementation expects at least one buffer on
all queues to start streaming. Properly signal this to the vb2
core, to avoid confusion when streamon is racing with qbuf.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 15eb5dc4dff9a..46a628a548d9f 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1884,6 +1884,12 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
 	 * that videobuf2 will keep the value of bytesused intact.
 	 */
 	vq->allow_zero_bytesused = 1;
+	/*
+	 * We might be fine with no buffers on some of the queues, but that
+	 * would need to be reflected in job_ready(). Currently we expect all
+	 * queues to have at least one buffer queued.
+	 */
+	vq->min_buffers_needed = 1;
 	vq->dev = &ctx->dev->plat_dev->dev;
 
 	return vb2_queue_init(vq);
-- 
2.11.0
