Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47366 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab0DAIUe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 04:20:34 -0400
From: hvaibhav@ti.com
To: p.osciak@samsung.com
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/2] v4l2-mem2mem: Code cleanup
Date: Thu,  1 Apr 2010 13:50:24 +0530
Message-Id: <1270110025-1854-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/v4l2-mem2mem.c |   40 ++++++++++++++---------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
index a78157f..4cd79ba 100644
--- a/drivers/media/video/v4l2-mem2mem.c
+++ b/drivers/media/video/v4l2-mem2mem.c
@@ -23,12 +23,12 @@ MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
 MODULE_AUTHOR("Pawel Osciak, <p.osciak@samsung.com>");
 MODULE_LICENSE("GPL");
 
-static int debug;
-module_param(debug, int, 0644);
+static bool debug;
+module_param(debug, bool, 0644);
 
 #define dprintk(fmt, arg...)						\
 	do {								\
-		if (debug >= 1)						\
+		if (debug)						\
 			printk(KERN_DEBUG "%s: " fmt, __func__, ## arg);\
 	} while (0)
 
@@ -215,12 +215,10 @@ EXPORT_SYMBOL(v4l2_m2m_dst_buf_remove);
 void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev)
 {
 	unsigned long flags;
-	void *ret;
+	void *ret = NULL;
 
 	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
-	if (!m2m_dev->curr_ctx)
-		ret = NULL;
-	else
+	if (m2m_dev->curr_ctx)
 		ret = m2m_dev->curr_ctx->priv;
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 
@@ -319,10 +317,9 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 		return;
 	}
 
-	if (!(m2m_ctx->job_flags & TRANS_QUEUED)) {
-		list_add_tail(&m2m_ctx->queue, &m2m_dev->jobqueue);
-		m2m_ctx->job_flags |= TRANS_QUEUED;
-	}
+	list_add_tail(&m2m_ctx->queue, &m2m_dev->jobqueue);
+	m2m_ctx->job_flags |= TRANS_QUEUED;
+
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 
 	v4l2_m2m_try_run(m2m_dev);
@@ -414,12 +411,10 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = videobuf_qbuf(vq, buf);
-	if (ret)
-		return ret;
-
-	v4l2_m2m_try_schedule(m2m_ctx);
+	if (!ret)
+		v4l2_m2m_try_schedule(m2m_ctx);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -448,12 +443,10 @@ int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, type);
 	ret = videobuf_streamon(vq);
-	if (ret)
-		return ret;
-
-	v4l2_m2m_try_schedule(m2m_ctx);
+	if (!ret)
+		v4l2_m2m_try_schedule(m2m_ctx);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
 
@@ -587,8 +580,7 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
 					enum v4l2_buf_type))
 {
 	struct v4l2_m2m_ctx *m2m_ctx;
-	struct v4l2_m2m_queue_ctx *out_q_ctx;
-	struct v4l2_m2m_queue_ctx *cap_q_ctx;
+	struct v4l2_m2m_queue_ctx *out_q_ctx, *cap_q_ctx;
 
 	if (!vq_init)
 		return ERR_PTR(-EINVAL);
@@ -662,7 +654,7 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
 /**
  * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
  *
- * Call from withing buf_queue() videobuf_queue_ops callback.
+ * Call from buf_queue(), videobuf_queue_ops callback.
  *
  * Locking: Caller holds q->irqlock (taken by videobuf before calling buf_queue
  * callback in the driver).
-- 
1.6.2.4

