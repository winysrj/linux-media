Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59739 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754231AbdFWJyQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 05:54:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: rename the picture run timeout error handler
Date: Fri, 23 Jun 2017 11:54:09 +0200
Message-Id: <20170623095409.23108-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would have liked the the picture run timeout error handler to be renamed to
something a bit more descriptive in the original commit fb2be08f8cb3 ("[media]
coda: first step at error recovery").
Somehow v1 [1] was merged instead of v2 [2].

[1] https://patchwork.kernel.org/patch/9663965/
[2] https://patchwork.kernel.org/patch/9774239/

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 4 ++--
 drivers/media/platform/coda/coda-common.c | 4 ++--
 drivers/media/platform/coda/coda.h        | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 25cbf9e5ac5a7..795b6d7584320 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2198,7 +2198,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	ctx->display_idx = display_idx;
 }
 
-static void coda_error_decode(struct coda_ctx *ctx)
+static void coda_decode_timeout(struct coda_ctx *ctx)
 {
 	struct vb2_v4l2_buffer *dst_buf;
 
@@ -2223,7 +2223,7 @@ const struct coda_context_ops coda_bit_decode_ops = {
 	.start_streaming = coda_start_decoding,
 	.prepare_run = coda_prepare_decode,
 	.finish_run = coda_finish_decode,
-	.error_run = coda_error_decode,
+	.run_timeout = coda_decode_timeout,
 	.seq_end_work = coda_seq_end_work,
 	.release = coda_bit_release,
 };
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f92cc7df58fb8..829c7895a98a2 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1164,8 +1164,8 @@ static void coda_pic_run_work(struct work_struct *work)
 
 		coda_hw_reset(ctx);
 
-		if (ctx->ops->error_run)
-			ctx->ops->error_run(ctx);
+		if (ctx->ops->run_timeout)
+			ctx->ops->run_timeout(ctx);
 	} else if (!ctx->aborting) {
 		ctx->ops->finish_run(ctx);
 	}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 40fe22f0d7573..c5f504d8cf67f 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -183,7 +183,7 @@ struct coda_context_ops {
 	int (*start_streaming)(struct coda_ctx *ctx);
 	int (*prepare_run)(struct coda_ctx *ctx);
 	void (*finish_run)(struct coda_ctx *ctx);
-	void (*error_run)(struct coda_ctx *ctx);
+	void (*run_timeout)(struct coda_ctx *ctx);
 	void (*seq_end_work)(struct work_struct *work);
 	void (*release)(struct coda_ctx *ctx);
 };
-- 
2.11.0
