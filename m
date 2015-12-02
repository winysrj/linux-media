Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19239 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbbLBIXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 03:23:39 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NYQ00AFS1ZEIN00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2015 08:23:38 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...), s.nawrocki@samsung.com
Subject: [PATCH 2/6] s5p-mfc: make queue cleanup code common
Date: Wed, 02 Dec 2015 09:22:29 +0100
Message-id: <1449044553-27115-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
References: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Code for queue cleanup has nothing specific to hardware version.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 26 +++++++++++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 16 ---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 16 ---------------
 7 files changed, 23 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8bae7df..79f5c81 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -125,6 +125,20 @@ static void wake_up_dev(struct s5p_mfc_dev *dev, unsigned int reason,
 	wake_up(&dev->queue);
 }
 
+void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq)
+{
+	struct s5p_mfc_buf *b;
+	int i;
+
+	while (!list_empty(lh)) {
+		b = list_entry(lh->next, struct s5p_mfc_buf, list);
+		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
+		list_del(&b->list);
+	}
+}
+
 static void s5p_mfc_watchdog(unsigned long arg)
 {
 	struct s5p_mfc_dev *dev = (struct s5p_mfc_dev *)arg;
@@ -170,10 +184,8 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 		if (!ctx)
 			continue;
 		ctx->state = MFCINST_ERROR;
-		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->dst_queue, &ctx->vq_dst);
-		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->src_queue, &ctx->vq_src);
+		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
 		clear_work_bit(ctx);
 		wake_up_ctx(ctx, S5P_MFC_R2H_CMD_ERR_RET, 0);
 	}
@@ -471,11 +483,9 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 			ctx->state = MFCINST_ERROR;
 			/* Mark all dst buffers as having an error */
 			spin_lock_irqsave(&dev->irqlock, flags);
-			s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->dst_queue, &ctx->vq_dst);
+			s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 			/* Mark all src buffers as having an error */
-			s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->src_queue, &ctx->vq_src);
+			s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
 			wake_up_ctx(ctx, reason, err);
 			break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 0cdb37e..f560240 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -711,6 +711,7 @@ void set_work_bit(struct s5p_mfc_ctx *ctx);
 void clear_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev);
+void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 
 #define HAS_PORTNUM(dev)	(dev ? (dev->variant ? \
 				(dev->variant->port_num ? 1 : 0) : 0) : 0)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 1c4998c..c9999bb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1033,8 +1033,7 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		spin_lock_irqsave(&dev->irqlock, flags);
-		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 		ctx->dpb_flush_flag = 1;
@@ -1051,8 +1050,7 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		spin_lock_irqsave(&dev->irqlock, flags);
-		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->src_queue, &ctx->vq_src);
+		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 115b7da..58008b0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1990,15 +1990,13 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	ctx->state = MFCINST_FINISHED;
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
-						&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		cleanup_ref_queue(ctx);
-		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
-				&ctx->vq_src);
+		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
 	}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 77a08b1..b89df89 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -296,8 +296,6 @@ struct s5p_mfc_hw_ops {
 	int (*init_encode)(struct s5p_mfc_ctx *ctx);
 	int (*encode_one_frame)(struct s5p_mfc_ctx *ctx);
 	void (*try_run)(struct s5p_mfc_dev *dev);
-	void (*cleanup_queue)(struct list_head *lh,
-			struct vb2_queue *vq);
 	void (*clear_int_flags)(struct s5p_mfc_dev *dev);
 	void (*write_info)(struct s5p_mfc_ctx *ctx, unsigned int data,
 			unsigned int ofs);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index d9e5d68..ae4c950 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1451,21 +1451,6 @@ static void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 	}
 }
 
-
-static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
-{
-	struct s5p_mfc_buf *b;
-	int i;
-
-	while (!list_empty(lh)) {
-		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
-			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
-		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
-		list_del(&b->list);
-	}
-}
-
 static void s5p_mfc_clear_int_flags_v5(struct s5p_mfc_dev *dev)
 {
 	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
@@ -1677,7 +1662,6 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
 	.init_encode = s5p_mfc_init_encode_v5,
 	.encode_one_frame = s5p_mfc_encode_one_frame_v5,
 	.try_run = s5p_mfc_try_run_v5,
-	.cleanup_queue = s5p_mfc_cleanup_queue_v5,
 	.clear_int_flags = s5p_mfc_clear_int_flags_v5,
 	.write_info = s5p_mfc_write_info_v5,
 	.read_info = s5p_mfc_read_info_v5,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index f68653f..fbff09a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1822,21 +1822,6 @@ static void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 	}
 }
 
-
-static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
-{
-	struct s5p_mfc_buf *b;
-	int i;
-
-	while (!list_empty(lh)) {
-		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
-			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
-		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
-		list_del(&b->list);
-	}
-}
-
 static void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
 {
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
@@ -2268,7 +2253,6 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
 	.init_encode = s5p_mfc_init_encode_v6,
 	.encode_one_frame = s5p_mfc_encode_one_frame_v6,
 	.try_run = s5p_mfc_try_run_v6,
-	.cleanup_queue = s5p_mfc_cleanup_queue_v6,
 	.clear_int_flags = s5p_mfc_clear_int_flags_v6,
 	.write_info = s5p_mfc_write_info_v6,
 	.read_info = s5p_mfc_read_info_v6,
-- 
1.9.1

