Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33388 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754168AbdLOH5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:57:09 -0500
Received: by mail-pg0-f65.google.com with SMTP id g7so5300564pgs.0
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:57:08 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 7/9] media: v4l2-mem2mem: add request support
Date: Fri, 15 Dec 2017 16:56:23 +0900
Message-Id: <20171215075625.27028-8-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support request API in the mem2mem framework. Drivers that specify ops
for the queue and entities can support requests seamlessly.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 34 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           | 19 +++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index f62e68aa04c4..eb52bee8e06a 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/media-request.h>
 
 MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -219,6 +220,15 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 	m2m_dev = m2m_ctx->m2m_dev;
 	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	/* request is completed if all queues are done with it */
+	if (m2m_ctx->req_queue && m2m_ctx->req_queue->active_request &&
+	    m2m_ctx->cap_q_ctx.q.cur_req == NULL &&
+	    m2m_ctx->out_q_ctx.q.cur_req == NULL)
+		media_request_entity_complete(m2m_ctx->req_queue,
+					      m2m_ctx->entity);
+#endif
+
 	if (!m2m_ctx->out_q_ctx.q.streaming
 	    || !m2m_ctx->cap_q_ctx.q.streaming) {
 		dprintk("Streaming needs to be on for both queues\n");
@@ -665,6 +675,15 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 
+void v4l2_mem_ctx_request_init(struct v4l2_m2m_ctx *ctx,
+			       struct media_request_queue *req_queue,
+			       struct media_entity *entity)
+{
+	ctx->entity = entity;
+	ctx->req_queue = req_queue;
+}
+EXPORT_SYMBOL_GPL(v4l2_mem_ctx_request_init);
+
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	/* wait until the current context is dequeued from job_queue */
@@ -810,3 +829,18 @@ unsigned int v4l2_m2m_fop_poll(struct file *file, poll_table *wait)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_fop_poll);
 
+int v4l2_m2m_process_request(struct media_request *req,
+			     struct media_request_entity_data *data)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct v4l2_fh *fh = data->fh;
+	struct v4l2_m2m_ctx *ctx = fh->m2m_ctx;
+
+	vb2_queue_start_request(&ctx->cap_q_ctx.q, req);
+	vb2_queue_start_request(&ctx->out_q_ctx.q, req);
+
+	v4l2_m2m_try_schedule(ctx);
+#endif
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_process_request);
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index e157d5c9b224..1c9925c3d4ce 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -19,6 +19,10 @@
 
 #include <media/videobuf2-v4l2.h>
 
+struct media_entity;
+struct media_request;
+struct media_request_entity_data;
+
 /**
  * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
  * @device_run:	required. Begin the actual job (transaction) inside this
@@ -83,6 +87,7 @@ struct v4l2_m2m_queue_ctx {
  *
  * @q_lock: struct &mutex lock
  * @m2m_dev: opaque pointer to the internal data to handle M2M context
+ * @state: Pointer to state handler for channel support
  * @cap_q_ctx: Capture (output to memory) queue context
  * @out_q_ctx: Output (input from memory) queue context
  * @queue: List of memory to memory contexts
@@ -100,6 +105,8 @@ struct v4l2_m2m_ctx {
 
 	/* internal use only */
 	struct v4l2_m2m_dev		*m2m_dev;
+	struct media_request_queue	*req_queue;
+	struct media_entity		*entity;
 
 	struct v4l2_m2m_queue_ctx	cap_q_ctx;
 
@@ -351,6 +358,16 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
 		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
 
+/**
+ * v4l2_mem_ctx_request_init() - enable a context to be used with requests
+ *
+ * @ctx: context to potentially use within a channel
+ * @req_queue: request queue that will be used with this context
+ */
+void v4l2_mem_ctx_request_init(struct v4l2_m2m_ctx *ctx,
+			       struct media_request_queue *req_queue,
+			       struct media_entity *entity);
+
 static inline void v4l2_m2m_set_src_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 					     bool buffered)
 {
@@ -602,6 +619,8 @@ int v4l2_m2m_ioctl_streamoff(struct file *file, void *fh,
 				enum v4l2_buf_type type);
 int v4l2_m2m_fop_mmap(struct file *file, struct vm_area_struct *vma);
 unsigned int v4l2_m2m_fop_poll(struct file *file, poll_table *wait);
+int v4l2_m2m_process_request(struct media_request *req,
+			     struct media_request_entity_data *data);
 
 #endif /* _MEDIA_V4L2_MEM2MEM_H */
 
-- 
2.15.1.504.g5279b80103-goog
