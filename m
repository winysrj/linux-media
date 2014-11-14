Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42479 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbaKNLU7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 06:20:59 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id sAEBKwOO021149
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 05:20:58 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id sAEBKwC3002918
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 05:20:58 -0600
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [PATCH v2 3/4] media: ti-vpe: Do not perform job transaction atomically
Date: Fri, 14 Nov 2014 16:50:51 +0530
Message-ID: <1415964052-30351-4-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
References: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current VPE driver does not start the job untill all the buffers for
a transaction are not queued. When running in multiple context, this might
increase the processing latency.

Alternate solution would be to try to continue the same context as long as
buffers for the transaction are ready; else switch the conext. This may
increase number of context switches but it reduces latency significantly.

In this approach, the job_ready always succeeds as long as there are buffers
on the CAPTURE and OUTPUT stream. Processing may start immediately as the
first 2 iterations don't need extra source buffers. Shift all the source buffers
after each iteration and remove the oldest buffer.

Also, with this removes the constraint of pre buffering 3 buffers before call
to STREAMON in case of deinterlacing.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4d3ab43..939f083 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -906,15 +906,14 @@ static struct vpe_ctx *file2ctx(struct file *file)
 static int job_ready(void *priv)
 {
 	struct vpe_ctx *ctx = priv;
-	int needed = ctx->bufs_per_job;
 
-	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL)
-		needed += 2;	/* need additional two most recent fields */
-
-	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) < needed)
-		return 0;
-
-	if (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) < needed)
+	/*
+	 * This check is needed as this might be called directly from driver
+	 * When called by m2m framework, this will always satisy, but when
+	 * called from vpe_irq, this might fail. (src stream with zero buffers)
+	 */
+	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) <= 0 ||
+		v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) <= 0)
 		return 0;
 
 	return 1;
@@ -1123,19 +1122,20 @@ static void device_run(void *priv)
 	struct sc_data *sc = ctx->dev->sc;
 	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
 
-	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL) {
-		ctx->src_vbs[2] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-		WARN_ON(ctx->src_vbs[2] == NULL);
-		ctx->src_vbs[1] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-		WARN_ON(ctx->src_vbs[1] == NULL);
-	}
-
 	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	WARN_ON(ctx->src_vbs[0] == NULL);
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
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
@@ -1359,7 +1359,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	}
 
 	ctx->bufs_completed++;
-	if (ctx->bufs_completed < ctx->bufs_per_job) {
+	if (ctx->bufs_completed < ctx->bufs_per_job && job_ready(ctx)) {
 		device_run(ctx);
 		goto handled;
 	}
-- 
1.7.9.5

