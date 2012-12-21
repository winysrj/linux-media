Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46019 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2LUJdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 04:33:12 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MFD005TPJUTWAW0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Dec 2012 18:33:11 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MFD003LOJV1V610@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Dec 2012 18:33:11 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] s5p-mfc: Fix interrupt error handling routine
Date: Fri, 21 Dec 2012 10:32:59 +0100
Message-id: <1356082379-7144-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New context states were added but handling in s5p_mfc_handle_error for
these states was not. After this patch these states are be handled
correctly.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Hi,

This is exatly the same patch as https://patchwork.kernel.org/patch/1865541/
with an additional comment added as suggested by Sachin Kamat.

This patch was tested by me and Arun. Unfortunately Sachin and Pawel could
not join in and run their tests.

Best wishes,
Kamil Debski
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   88 +++++++++++++-----------------
 1 file changed, 37 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3afe879..5448ad1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -412,62 +412,48 @@ leave_handle_frame:
 }
 
 /* Error handling for interrupt */
-static void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
-				 unsigned int reason, unsigned int err)
+static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
+		struct s5p_mfc_ctx *ctx, unsigned int reason, unsigned int err)
 {
-	struct s5p_mfc_dev *dev;
 	unsigned long flags;
 
-	/* If no context is available then all necessary
-	 * processing has been done. */
-	if (ctx == NULL)
-		return;
-
-	dev = ctx->dev;
 	mfc_err("Interrupt Error: %08x\n", err);
-	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
-	wake_up_dev(dev, reason, err);
 
-	/* Error recovery is dependent on the state of context */
-	switch (ctx->state) {
-	case MFCINST_INIT:
-		/* This error had to happen while acquireing instance */
-	case MFCINST_GOT_INST:
-		/* This error had to happen while parsing the header */
-	case MFCINST_HEAD_PARSED:
-		/* This error had to happen while setting dst buffers */
-	case MFCINST_RETURN_INST:
-		/* This error had to happen while releasing instance */
-		clear_work_bit(ctx);
-		wake_up_ctx(ctx, reason, err);
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
-		s5p_mfc_clock_off();
-		ctx->state = MFCINST_ERROR;
-		break;
-	case MFCINST_FINISHING:
-	case MFCINST_FINISHED:
-	case MFCINST_RUNNING:
-		/* It is higly probable that an error occured
-		 * while decoding a frame */
-		clear_work_bit(ctx);
-		ctx->state = MFCINST_ERROR;
-		/* Mark all dst buffers as having an error */
-		spin_lock_irqsave(&dev->irqlock, flags);
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
-				&ctx->vq_dst);
-		/* Mark all src buffers as having an error */
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
-				&ctx->vq_src);
-		spin_unlock_irqrestore(&dev->irqlock, flags);
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
-		s5p_mfc_clock_off();
-		break;
-	default:
-		mfc_err("Encountered an error interrupt which had not been handled\n");
-		break;
+	if (ctx != NULL) {
+		/* Error recovery is dependent on the state of context */
+		switch (ctx->state) {
+		case MFCINST_RES_CHANGE_INIT:
+		case MFCINST_RES_CHANGE_FLUSH:
+		case MFCINST_RES_CHANGE_END:
+		case MFCINST_FINISHING:
+		case MFCINST_FINISHED:
+		case MFCINST_RUNNING:
+			/* It is higly probable that an error occured
+			 * while decoding a frame */
+			clear_work_bit(ctx);
+			ctx->state = MFCINST_ERROR;
+			/* Mark all dst buffers as having an error */
+			spin_lock_irqsave(&dev->irqlock, flags);
+			s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
+						&ctx->dst_queue, &ctx->vq_dst);
+			/* Mark all src buffers as having an error */
+			s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
+						&ctx->src_queue, &ctx->vq_src);
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+			wake_up_ctx(ctx, reason, err);
+			break;
+		default:
+			clear_work_bit(ctx);
+			ctx->state = MFCINST_ERROR;
+			wake_up_ctx(ctx, reason, err);
+			break;
+		}
 	}
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		BUG();
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_clock_off();
+	wake_up_dev(dev, reason, err);
 	return;
 }
 
@@ -632,7 +618,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 				dev->warn_start)
 			s5p_mfc_handle_frame(ctx, reason, err);
 		else
-			s5p_mfc_handle_error(ctx, reason, err);
+			s5p_mfc_handle_error(dev, ctx, reason, err);
 		clear_bit(0, &dev->enter_suspend);
 		break;
 
-- 
1.7.9.5

