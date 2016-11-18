Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:17469 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753457AbcKRXVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:08 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 06/35] media: ti-vpe: vpe: Do not perform job transaction atomically
Date: Fri, 18 Nov 2016 17:20:16 -0600
Message-ID: <20161118232045.24665-7-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Current VPE driver does not start the job until all the buffers for
a transaction are queued. When running in multiple context, this might
increase the processing latency.

Alternate solution would be to try to continue the same context as long as
buffers for the transaction are ready; else switch the context. This may
increase number of context switches but it reduces latency significantly.

In this approach, the job_ready always succeeds as long as there are
buffers on the CAPTURE and OUTPUT stream. Processing may start immediately
as the first 2 iterations don't need extra source buffers. Shift all the
source buffers after each iteration and remove the oldest buffer.

Also, with this removes the constraint of pre buffering 3 buffers before
call to STREAMON in case of de-interlacing.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ad838b8a98c4..9b7b9be5641d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -898,15 +898,14 @@ static struct vpe_ctx *file2ctx(struct file *file)
 static int job_ready(void *priv)
 {
 	struct vpe_ctx *ctx = priv;
-	int needed = ctx->bufs_per_job;
 
-	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL)
-		needed += 2;	/* need additional two most recent fields */
-
-	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < needed)
-		return 0;
-
-	if (v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < needed)
+	/*
+	 * This check is needed as this might be called directly from driver
+	 * When called by m2m framework, this will always satisfy, but when
+	 * called from vpe_irq, this might fail. (src stream with zero buffers)
+	 */
+	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) <= 0 ||
+		v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) <= 0)
 		return 0;
 
 	return 1;
@@ -1116,19 +1115,20 @@ static void device_run(void *priv)
 	struct sc_data *sc = ctx->dev->sc;
 	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
 
-	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL) {
-		ctx->src_vbs[2] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-		WARN_ON(ctx->src_vbs[2] == NULL);
-		ctx->src_vbs[1] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-		WARN_ON(ctx->src_vbs[1] == NULL);
-	}
-
 	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	WARN_ON(ctx->src_vbs[0] == NULL);
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	WARN_ON(ctx->dst_vb == NULL);
 
 	if (ctx->deinterlacing) {
+
+		if (ctx->src_vbs[2] == NULL) {
+			ctx->src_vbs[2] = ctx->src_vbs[0];
+			WARN_ON(ctx->src_vbs[2] == NULL);
+			ctx->src_vbs[1] = ctx->src_vbs[0];
+			WARN_ON(ctx->src_vbs[1] == NULL);
+		}
+
 		/*
 		 * we have output the first 2 frames through line average, we
 		 * now switch to EDI de-interlacer
@@ -1348,7 +1348,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	}
 
 	ctx->bufs_completed++;
-	if (ctx->bufs_completed < ctx->bufs_per_job) {
+	if (ctx->bufs_completed < ctx->bufs_per_job && job_ready(ctx)) {
 		device_run(ctx);
 		goto handled;
 	}
-- 
2.9.0

