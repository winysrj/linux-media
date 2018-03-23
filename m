Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47203 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbeCWVS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org
Subject: [RFC v2 08/10] v4l: m2m: Support requests with video buffers
Date: Fri, 23 Mar 2018 23:17:42 +0200
Message-Id: <1521839864-10146-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable supporting requests on V4L2 buffer queues on M2M devices. This
requires Media controller.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 109 +++++++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |  28 +++++++++
 2 files changed, 137 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 9fbf778..effdd15 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
+#include <media/media-device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-dev.h>
@@ -57,6 +58,8 @@ module_param(debug, bool, 0644);
  * @job_queue:		instances queued to run
  * @job_spinlock:	protects job_queue
  * @m2m_ops:		driver callbacks
+ * @mdev:		media device; optional
+ * @allow_requests:	whether requests are allowed on the M2M device
  */
 struct v4l2_m2m_dev {
 	struct v4l2_m2m_ctx	*curr_ctx;
@@ -65,6 +68,9 @@ struct v4l2_m2m_dev {
 	spinlock_t		job_spinlock;
 
 	const struct v4l2_m2m_ops *m2m_ops;
+
+	struct media_device	*mdev;
+	bool			allow_requests;
 };
 
 static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
@@ -89,6 +95,78 @@ struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL(v4l2_m2m_get_vq);
 
+struct media_request *v4l2_m2m_req_alloc(struct media_device *mdev)
+{
+	struct v4l2_m2m_request *vreq;
+
+	vreq = kzalloc(sizeof(*vreq), GFP_KERNEL);
+	if (!vreq)
+		return NULL;
+
+	return &vreq->req;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_req_alloc);
+
+void v4l2_m2m_req_free(struct media_request *req)
+{
+	struct v4l2_m2m_request *vreq =
+		container_of(req, struct v4l2_m2m_request, req);
+
+	kfree(vreq);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_req_free);
+
+int v4l2_m2m_req_queue(struct media_request *req)
+{
+	struct v4l2_m2m_request *vreq =
+		container_of(req, struct v4l2_m2m_request, req);
+	struct v4l2_m2m_ctx *m2m_ctx = vreq->ctx;
+	struct v4l2_m2m_dev *m2m_dev = m2m_ctx->m2m_dev;
+	struct media_request_ref *iter;
+	unsigned long flags;
+
+	media_request_for_each_ref(iter, req)
+		if (iter->new->class == m2m_ctx->cap_q_ctx.q.class)
+			vreq->cap_ref = iter;
+		else if (iter->new->class == m2m_ctx->out_q_ctx.q.class)
+			vreq->out_ref = iter;
+		else
+			return -EINVAL;
+
+	if (!vreq->out_ref || !vreq->cap_ref)
+		return -EINVAL;
+
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	list_add(&vreq->queue_list, &m2m_ctx->request_queue);
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_req_queue);
+
+struct v4l2_m2m_request *v4l2_m2m_next_req(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	struct v4l2_m2m_dev *m2m_dev = m2m_ctx->m2m_dev;
+	struct v4l2_m2m_request *vreq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	if (list_empty(&m2m_ctx->request_queue)) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		return NULL;
+	}
+
+	vreq = list_first_entry(&m2m_ctx->request_queue,
+				struct v4l2_m2m_request, queue_list);
+
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+
+	return vreq;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_next_req);
+
 void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
@@ -239,6 +317,11 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 		goto out_unlock;
 	}
 
+	if (m2m_dev->allow_requests && list_empty(&m2m_ctx->request_queue)) {
+		dprintk("No requests queued\n");
+		goto out_unlock;
+	}
+
 	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
 	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)
 	    && !m2m_ctx->out_q_ctx.buffered) {
@@ -393,6 +476,9 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	struct vb2_queue *vq;
 	int ret;
 
+	if (m2m_ctx->m2m_dev->allow_requests && !buf->request_fd)
+		return -EINVAL;
+
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_qbuf(vq, buf);
 	if (!ret)
@@ -618,6 +704,17 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_init);
 
+void v4l2_m2m_allow_requests(struct v4l2_m2m_dev *m2m_dev,
+			     struct media_device *mdev)
+{
+	if (WARN_ON(!mdev))
+		return;
+
+	m2m_dev->mdev = mdev;
+	m2m_dev->allow_requests = true;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_allow_requests);
+
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
 {
 	kfree(m2m_dev);
@@ -643,6 +740,7 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 	out_q_ctx = &m2m_ctx->out_q_ctx;
 	cap_q_ctx = &m2m_ctx->cap_q_ctx;
 
+	INIT_LIST_HEAD(&m2m_ctx->request_queue);
 	INIT_LIST_HEAD(&out_q_ctx->rdy_queue);
 	INIT_LIST_HEAD(&cap_q_ctx->rdy_queue);
 	spin_lock_init(&out_q_ctx->rdy_spinlock);
@@ -651,9 +749,17 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 	INIT_LIST_HEAD(&m2m_ctx->queue);
 
 	ret = queue_init(drv_priv, &out_q_ctx->q, &cap_q_ctx->q);
+	if (ret)
+		goto err;
+
+	ret = vb2_queue_allow_requests(&cap_q_ctx->q, m2m_dev->mdev);
+	if (ret)
+		goto err;
 
+	ret = vb2_queue_allow_requests(&out_q_ctx->q, m2m_dev->mdev);
 	if (ret)
 		goto err;
+
 	/*
 	 * If both queues use same mutex assign it as the common buffer
 	 * queues lock to the m2m context. This lock is used in the
@@ -663,7 +769,10 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		m2m_ctx->q_lock = out_q_ctx->q.lock;
 
 	return m2m_ctx;
+
 err:
+	vb2_queue_deny_requests(&out_q_ctx->q);
+	vb2_queue_deny_requests(&cap_q_ctx->q);
 	kfree(m2m_ctx);
 	return ERR_PTR(ret);
 }
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3..92732a7 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -18,6 +18,7 @@
 #define _MEDIA_V4L2_MEM2MEM_H
 
 #include <media/videobuf2-v4l2.h>
+#include <media/media-request.h>
 
 /**
  * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
@@ -53,6 +54,7 @@ struct v4l2_m2m_ops {
 	void (*unlock)(void *priv);
 };
 
+struct media_device;
 struct v4l2_m2m_dev;
 
 /**
@@ -85,7 +87,9 @@ struct v4l2_m2m_queue_ctx {
  * @m2m_dev: opaque pointer to the internal data to handle M2M context
  * @cap_q_ctx: Capture (output to memory) queue context
  * @out_q_ctx: Output (input from memory) queue context
+ * @mdev: The media device; optional
  * @queue: List of memory to memory contexts
+ * @request_queue: queued requests in this context
  * @job_flags: Job queue flags, used internally by v4l2-mem2mem.c:
  *		%TRANS_QUEUED, %TRANS_RUNNING and %TRANS_ABORT.
  * @finished: Wait queue used to signalize when a job queue finished.
@@ -109,6 +113,7 @@ struct v4l2_m2m_ctx {
 	struct list_head		queue;
 	unsigned long			job_flags;
 	wait_queue_head_t		finished;
+	struct list_head		request_queue;
 
 	void				*priv;
 };
@@ -124,6 +129,17 @@ struct v4l2_m2m_buffer {
 	struct list_head	list;
 };
 
+struct v4l2_m2m_request {
+	struct list_head queue_list;
+	struct v4l2_m2m_ctx *ctx;
+	struct media_request_ref *cap_ref, *out_ref;
+	struct media_request req;
+};
+
+struct media_request *v4l2_m2m_req_alloc(struct media_device *mdev);
+void v4l2_m2m_req_free(struct media_request *req);
+int v4l2_m2m_req_queue(struct media_request *req);
+
 /**
  * v4l2_m2m_get_curr_priv() - return driver private data for the currently
  * running instance or NULL if no instance is running
@@ -329,6 +345,17 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 
 /**
+ * v4l2_m2m_allow_requests - allow requests on an m2m device
+ *
+ * @m2m_dev: the m2m device
+ * @mdev: the media device
+ *
+ * Allow using media requests on an M2M device.
+ */
+void v4l2_m2m_allow_requests(struct v4l2_m2m_dev *m2m_dev,
+			     struct media_device *mdev);
+
+/**
  * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
  *
  * @m2m_dev: opaque pointer to the internal data to handle M2M context
@@ -407,6 +434,7 @@ unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 	return m2m_ctx->cap_q_ctx.num_rdy;
 }
 
+struct v4l2_m2m_request *v4l2_m2m_next_req(struct v4l2_m2m_ctx *m2m_ctx);
 /**
  * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
  *
-- 
2.7.4
