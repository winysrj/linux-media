Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60838 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751AbbAWQvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:47 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 17/21] [media] coda: make seq_end_work optional
Date: Fri, 23 Jan 2015 17:51:31 +0100
Message-Id: <1422031895-7740-18-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for CODA9 JPEG support, which doesn't have to call
SEQ_END on the BIT processor.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 24d9f8a..40074fa 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -921,7 +921,8 @@ static void coda_pic_run_work(struct work_struct *work)
 		ctx->ops->finish_run(ctx);
 	}
 
-	if (ctx->aborting || (!ctx->streamon_cap && !ctx->streamon_out))
+	if ((ctx->aborting || (!ctx->streamon_cap && !ctx->streamon_out)) &&
+	    ctx->ops->seq_end_work)
 		queue_work(dev->workqueue, &ctx->seq_end_work);
 
 	mutex_unlock(&dev->coda_mutex);
@@ -1627,7 +1628,8 @@ static int coda_open(struct file *file)
 	ctx->ops = ctx->cvd->ops;
 	init_completion(&ctx->completion);
 	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
-	INIT_WORK(&ctx->seq_end_work, ctx->ops->seq_end_work);
+	if (ctx->ops->seq_end_work)
+		INIT_WORK(&ctx->seq_end_work, ctx->ops->seq_end_work);
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
@@ -1748,7 +1750,7 @@ static int coda_release(struct file *file)
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
 	/* In case the instance was not running, we still need to call SEQ_END */
-	if (ctx->initialized) {
+	if (ctx->initialized && ctx->ops->seq_end_work) {
 		queue_work(dev->workqueue, &ctx->seq_end_work);
 		flush_work(&ctx->seq_end_work);
 	}
-- 
2.1.4

