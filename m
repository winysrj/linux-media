Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19239 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbLBIXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 03:23:38 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NYQ00BDD1ZC1Q00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2015 08:23:36 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...), s.nawrocki@samsung.com
Subject: [PATCH 1/6] s5p-mfc: use one implementation of s5p_mfc_get_new_ctx
Date: Wed, 02 Dec 2015 09:22:28 +0100
Message-id: <1449044553-27115-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
References: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both version of MFC driver uses functions with the same body and name.
The patch moves them to common location. It also simplifies it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 20 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 21 ---------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 24 ------------------------
 4 files changed, 21 insertions(+), 45 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3ffe2ec..8bae7df 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -85,6 +85,26 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx)
 	spin_unlock_irqrestore(&dev->condlock, flags);
 }
 
+int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
+{
+	unsigned long flags;
+	int ctx;
+
+	spin_lock_irqsave(&dev->condlock, flags);
+	ctx = dev->curr_ctx;
+	do {
+		ctx = (ctx + 1) % MFC_NUM_CONTEXTS;
+		if (ctx == dev->curr_ctx) {
+			if (!test_bit(ctx, &dev->ctx_work_bits))
+				ctx = -EAGAIN;
+			break;
+		}
+	} while (!test_bit(ctx, &dev->ctx_work_bits));
+	spin_unlock_irqrestore(&dev->condlock, flags);
+
+	return ctx;
+}
+
 /* Wake up context wait_queue */
 static void wake_up_ctx(struct s5p_mfc_ctx *ctx, unsigned int reason,
 			unsigned int err)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index d1a3f9b..0cdb37e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -710,6 +710,7 @@ void clear_work_bit(struct s5p_mfc_ctx *ctx);
 void set_work_bit(struct s5p_mfc_ctx *ctx);
 void clear_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev);
 
 #define HAS_PORTNUM(dev)	(dev ? (dev->variant ? \
 				(dev->variant->port_num ? 1 : 0) : 0) : 0)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 873c933..d9e5d68 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1153,27 +1153,6 @@ static int s5p_mfc_encode_one_frame_v5(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
-static int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
-{
-	unsigned long flags;
-	int new_ctx;
-	int cnt;
-
-	spin_lock_irqsave(&dev->condlock, flags);
-	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
-	cnt = 0;
-	while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
-		new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
-		if (++cnt > MFC_NUM_CONTEXTS) {
-			/* No contexts to run */
-			spin_unlock_irqrestore(&dev->condlock, flags);
-			return -EAGAIN;
-		}
-	}
-	spin_unlock_irqrestore(&dev->condlock, flags);
-	return new_ctx;
-}
-
 static void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index b958453..f68653f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1507,30 +1507,6 @@ static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
-static inline int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
-{
-	unsigned long flags;
-	int new_ctx;
-	int cnt;
-
-	spin_lock_irqsave(&dev->condlock, flags);
-	mfc_debug(2, "Previous context: %d (bits %08lx)\n", dev->curr_ctx,
-							dev->ctx_work_bits);
-	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
-	cnt = 0;
-	while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
-		new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
-		cnt++;
-		if (cnt > MFC_NUM_CONTEXTS) {
-			/* No contexts to run */
-			spin_unlock_irqrestore(&dev->condlock, flags);
-			return -EAGAIN;
-		}
-	}
-	spin_unlock_irqrestore(&dev->condlock, flags);
-	return new_ctx;
-}
-
 static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-- 
1.9.1

