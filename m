Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:44431 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752674AbdI1JvT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:19 -0400
Received: by mail-pf0-f172.google.com with SMTP id e1so614942pfk.1
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:19 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 6/9] [media] m2m: add generic support for jobs API
Date: Thu, 28 Sep 2017 18:50:24 +0900
Message-Id: <20170928095027.127173-7-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2_mem_ctx_job_init() function that drivers using m2m can call
at init time in order to set the state handler.

Also make sure to call v4l2_jobqueue_job_finish() when the jobs API is
used and all buffers for the current job have been processed.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 19 +++++++++++++++++++
 include/media/v4l2-mem2mem.h           | 11 +++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index f62e68aa04c4..dc4d8b16c0e2 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -22,6 +22,8 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-job-state.h>
+#include <media/v4l2-jobqueue.h>
 
 MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -333,6 +335,13 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 
+	/* Jobs mode: if we have no more buffers for the current job,
+	 * consider it completed */
+	if (m2m_ctx->state && m2m_ctx->state->active_state &&
+	    v4l2_m2m_next_src_buf(m2m_ctx) == NULL &&
+	    v4l2_m2m_next_dst_buf(m2m_ctx) == NULL)
+		v4l2_jobqueue_job_finish(m2m_ctx->state);
+
 	/* This instance might have more buffers ready, but since we do not
 	 * allow more than one job on the job_queue per instance, each has
 	 * to be scheduled separately after the previous one finishes. */
@@ -665,6 +674,16 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 
+void v4l2_mem_ctx_job_init(struct v4l2_m2m_ctx *ctx,
+			   struct v4l2_job_state_handler *hdl)
+{
+	ctx->state = hdl;
+
+	ctx->out_q_ctx.q.state_handler = hdl;
+	ctx->cap_q_ctx.q.state_handler = hdl;
+}
+EXPORT_SYMBOL_GPL(v4l2_mem_ctx_job_init);
+
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	/* wait until the current context is dequeued from job_queue */
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index e157d5c9b224..4ba18a32c9b0 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -83,6 +83,7 @@ struct v4l2_m2m_queue_ctx {
  *
  * @q_lock: struct &mutex lock
  * @m2m_dev: opaque pointer to the internal data to handle M2M context
+ * @state: Pointer to state handler for channel support
  * @cap_q_ctx: Capture (output to memory) queue context
  * @out_q_ctx: Output (input from memory) queue context
  * @queue: List of memory to memory contexts
@@ -100,6 +101,7 @@ struct v4l2_m2m_ctx {
 
 	/* internal use only */
 	struct v4l2_m2m_dev		*m2m_dev;
+	struct v4l2_job_state_handler	*state;
 
 	struct v4l2_m2m_queue_ctx	cap_q_ctx;
 
@@ -351,6 +353,15 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
 		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
 
+/**
+ * v4l2_mem_ctx_channel_init() - enable a context to be used in a channel
+ *
+ * @ctx: context to potentially use within a channel
+ * @hal: state handler that will be used with this context
+ */
+void v4l2_mem_ctx_job_init(struct v4l2_m2m_ctx *ctx,
+			       struct v4l2_job_state_handler *hdl);
+
 static inline void v4l2_m2m_set_src_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 					     bool buffered)
 {
-- 
2.14.2.822.g60be5d43e6-goog
