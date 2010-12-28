Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21853 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0L1RDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:24 -0500
Date: Tue, 28 Dec 2010 18:03:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 01/15] v4l: mem2mem: port to videobuf2
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Port memory-to-memory framework to videobuf2 framework.

Add support for multi-planar Video for Linux 2 API extensions to the
memory-to-memory driver framework.

Based on the original patch written by Pawel Osciak.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig        |    2 +-
 drivers/media/video/v4l2-mem2mem.c |  232 ++++++++++++++++++------------------
 include/media/v4l2-mem2mem.h       |   56 ++++++----
 3 files changed, 150 insertions(+), 140 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index dda87af..8e5116e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -42,7 +42,7 @@ config VIDEO_TUNER
 
 config V4L2_MEM2MEM_DEV
 	tristate
-	depends on VIDEOBUF_GEN
+	depends on VIDEOBUF2_CORE
 
 config VIDEOBUF2_CORE
 	tristate
diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
index ac832a2..a78e5c9 100644
--- a/drivers/media/video/v4l2-mem2mem.c
+++ b/drivers/media/video/v4l2-mem2mem.c
@@ -17,7 +17,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include <media/v4l2-mem2mem.h>
 
 MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
@@ -65,21 +65,16 @@ struct v4l2_m2m_dev {
 static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
 						enum v4l2_buf_type type)
 {
-	switch (type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		return &m2m_ctx->cap_q_ctx;
-	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+	if (V4L2_TYPE_IS_OUTPUT(type))
 		return &m2m_ctx->out_q_ctx;
-	default:
-		printk(KERN_ERR "Invalid buffer type\n");
-		return NULL;
-	}
+	else
+		return &m2m_ctx->cap_q_ctx;
 }
 
 /**
- * v4l2_m2m_get_vq() - return videobuf_queue for the given type
+ * v4l2_m2m_get_vq() - return vb2_queue for the given type
  */
-struct videobuf_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
+struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 				       enum v4l2_buf_type type)
 {
 	struct v4l2_m2m_queue_ctx *q_ctx;
@@ -95,27 +90,20 @@ EXPORT_SYMBOL(v4l2_m2m_get_vq);
 /**
  * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
  */
-void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type)
+void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
-	struct v4l2_m2m_queue_ctx *q_ctx;
-	struct videobuf_buffer *vb = NULL;
+	struct v4l2_m2m_buffer *b = NULL;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, type);
-	if (!q_ctx)
-		return NULL;
-
-	spin_lock_irqsave(q_ctx->q.irqlock, flags);
+	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
 
 	if (list_empty(&q_ctx->rdy_queue))
 		goto end;
 
-	vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer, queue);
-	vb->state = VIDEOBUF_ACTIVE;
-
+	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
 end:
-	spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
-	return vb;
+	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
+	return &b->vb;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
 
@@ -123,26 +111,21 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
  * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
  * return it
  */
-void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type)
+void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 {
-	struct v4l2_m2m_queue_ctx *q_ctx;
-	struct videobuf_buffer *vb = NULL;
+	struct v4l2_m2m_buffer *b = NULL;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, type);
-	if (!q_ctx)
-		return NULL;
-
-	spin_lock_irqsave(q_ctx->q.irqlock, flags);
+	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
 	if (!list_empty(&q_ctx->rdy_queue)) {
-		vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer,
-				queue);
-		list_del(&vb->queue);
+		b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer,
+				list);
+		list_del(&b->list);
 		q_ctx->num_rdy--;
 	}
-	spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
+	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
 
-	return vb;
+	return &b->vb;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove);
 
@@ -235,20 +218,20 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 		return;
 	}
 
-	spin_lock_irqsave(m2m_ctx->out_q_ctx.q.irqlock, flags);
+	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
-		spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
+		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No input buffers available\n");
 		return;
 	}
 	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
-		spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
+		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No output buffers available\n");
 		return;
 	}
-	spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
+	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 
 	if (m2m_dev->m2m_ops->job_ready
 		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
@@ -291,6 +274,7 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 
 	list_del(&m2m_dev->curr_ctx->queue);
 	m2m_dev->curr_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
+	wake_up(&m2m_dev->curr_ctx->finished);
 	m2m_dev->curr_ctx = NULL;
 
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
@@ -309,10 +293,10 @@ EXPORT_SYMBOL(v4l2_m2m_job_finish);
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		     struct v4l2_requestbuffers *reqbufs)
 {
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
-	return videobuf_reqbufs(vq, reqbufs);
+	return vb2_reqbufs(vq, reqbufs);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
@@ -324,15 +308,22 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      struct v4l2_buffer *buf)
 {
-	struct videobuf_queue *vq;
-	int ret;
+	struct vb2_queue *vq;
+	int ret = 0;
+	unsigned int i;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = videobuf_querybuf(vq, buf);
-
-	if (buf->memory == V4L2_MEMORY_MMAP
-	    && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		buf->m.offset += DST_QUEUE_OFF_BASE;
+	ret = vb2_querybuf(vq, buf);
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
+		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			for (i = 0; i < buf->length; ++i)
+				buf->m.planes[i].m.mem_offset
+					+= DST_QUEUE_OFF_BASE;
+		} else {
+			buf->m.offset += DST_QUEUE_OFF_BASE;
+		}
 	}
 
 	return ret;
@@ -346,11 +337,11 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf)
 {
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = videobuf_qbuf(vq, buf);
+	ret = vb2_qbuf(vq, buf);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
@@ -365,10 +356,10 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf)
 {
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return videobuf_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -378,11 +369,11 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      enum v4l2_buf_type type)
 {
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, type);
-	ret = videobuf_streamon(vq);
+	ret = vb2_streamon(vq, type);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
@@ -396,10 +387,10 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
 int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		       enum v4l2_buf_type type)
 {
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, type);
-	return videobuf_streamoff(vq);
+	return vb2_streamoff(vq, type);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
 
@@ -414,44 +405,53 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
 unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			   struct poll_table_struct *wait)
 {
-	struct videobuf_queue *src_q, *dst_q;
-	struct videobuf_buffer *src_vb = NULL, *dst_vb = NULL;
+	struct vb2_queue *src_q, *dst_q;
+	struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
 	unsigned int rc = 0;
+	unsigned long flags;
 
 	src_q = v4l2_m2m_get_src_vq(m2m_ctx);
 	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
 
-	videobuf_queue_lock(src_q);
-	videobuf_queue_lock(dst_q);
-
-	if (src_q->streaming && !list_empty(&src_q->stream))
-		src_vb = list_first_entry(&src_q->stream,
-					  struct videobuf_buffer, stream);
-	if (dst_q->streaming && !list_empty(&dst_q->stream))
-		dst_vb = list_first_entry(&dst_q->stream,
-					  struct videobuf_buffer, stream);
-
-	if (!src_vb && !dst_vb) {
+	/*
+	 * There has to be at least one buffer queued on each queued_list, which
+	 * means either in driver already or waiting for driver to claim it
+	 * and start processing.
+	 */
+	if ((!src_q->streaming || list_empty(&src_q->queued_list))
+		&& (!dst_q->streaming || list_empty(&dst_q->queued_list))) {
 		rc = POLLERR;
 		goto end;
 	}
 
-	if (src_vb) {
-		poll_wait(file, &src_vb->done, wait);
-		if (src_vb->state == VIDEOBUF_DONE
-		    || src_vb->state == VIDEOBUF_ERROR)
-			rc |= POLLOUT | POLLWRNORM;
-	}
-	if (dst_vb) {
-		poll_wait(file, &dst_vb->done, wait);
-		if (dst_vb->state == VIDEOBUF_DONE
-		    || dst_vb->state == VIDEOBUF_ERROR)
-			rc |= POLLIN | POLLRDNORM;
-	}
+	if (m2m_ctx->m2m_dev->m2m_ops->unlock)
+		m2m_ctx->m2m_dev->m2m_ops->unlock(m2m_ctx->priv);
+
+	poll_wait(file, &src_q->done_wq, wait);
+	poll_wait(file, &dst_q->done_wq, wait);
+
+	if (m2m_ctx->m2m_dev->m2m_ops->lock)
+		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
+
+	spin_lock_irqsave(&src_q->done_lock, flags);
+	if (!list_empty(&src_q->done_list))
+		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
+						done_entry);
+	if (src_vb && (src_vb->state == VB2_BUF_STATE_DONE
+			|| src_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLOUT | POLLWRNORM;
+	spin_unlock_irqrestore(&src_q->done_lock, flags);
+
+	spin_lock_irqsave(&dst_q->done_lock, flags);
+	if (!list_empty(&dst_q->done_list))
+		dst_vb = list_first_entry(&dst_q->done_list, struct vb2_buffer,
+						done_entry);
+	if (dst_vb && (dst_vb->state == VB2_BUF_STATE_DONE
+			|| dst_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLIN | POLLRDNORM;
+	spin_unlock_irqrestore(&dst_q->done_lock, flags);
 
 end:
-	videobuf_queue_unlock(dst_q);
-	videobuf_queue_unlock(src_q);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_poll);
@@ -470,7 +470,7 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct vm_area_struct *vma)
 {
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	struct videobuf_queue *vq;
+	struct vb2_queue *vq;
 
 	if (offset < DST_QUEUE_OFF_BASE) {
 		vq = v4l2_m2m_get_src_vq(m2m_ctx);
@@ -479,7 +479,7 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
 	}
 
-	return videobuf_mmap_mapper(vq, vma);
+	return vb2_mmap(vq, vma);
 }
 EXPORT_SYMBOL(v4l2_m2m_mmap);
 
@@ -531,36 +531,41 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_release);
  *
  * Usually called from driver's open() function.
  */
-struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
-			void (*vq_init)(void *priv, struct videobuf_queue *,
-					enum v4l2_buf_type))
+struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
+		void *drv_priv,
+		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq))
 {
 	struct v4l2_m2m_ctx *m2m_ctx;
 	struct v4l2_m2m_queue_ctx *out_q_ctx, *cap_q_ctx;
-
-	if (!vq_init)
-		return ERR_PTR(-EINVAL);
+	int ret;
 
 	m2m_ctx = kzalloc(sizeof *m2m_ctx, GFP_KERNEL);
 	if (!m2m_ctx)
 		return ERR_PTR(-ENOMEM);
 
-	m2m_ctx->priv = priv;
+	m2m_ctx->priv = drv_priv;
 	m2m_ctx->m2m_dev = m2m_dev;
+	init_waitqueue_head(&m2m_ctx->finished);
 
-	out_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	cap_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	out_q_ctx = &m2m_ctx->out_q_ctx;
+	cap_q_ctx = &m2m_ctx->cap_q_ctx;
 
 	INIT_LIST_HEAD(&out_q_ctx->rdy_queue);
 	INIT_LIST_HEAD(&cap_q_ctx->rdy_queue);
+	spin_lock_init(&out_q_ctx->rdy_spinlock);
+	spin_lock_init(&cap_q_ctx->rdy_spinlock);
 
 	INIT_LIST_HEAD(&m2m_ctx->queue);
 
-	vq_init(priv, &out_q_ctx->q, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	vq_init(priv, &cap_q_ctx->q, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	out_q_ctx->q.priv_data = cap_q_ctx->q.priv_data = priv;
+	ret = queue_init(drv_priv, &out_q_ctx->q, &cap_q_ctx->q);
+
+	if (ret)
+		goto err;
 
 	return m2m_ctx;
+err:
+	kfree(m2m_ctx);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 
@@ -572,7 +577,6 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	struct v4l2_m2m_dev *m2m_dev;
-	struct videobuf_buffer *vb;
 	unsigned long flags;
 
 	m2m_dev = m2m_ctx->m2m_dev;
@@ -582,10 +586,7 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 		m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
 		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
-		vb = v4l2_m2m_next_dst_buf(m2m_ctx);
-		BUG_ON(NULL == vb);
-		wait_event(vb->done, vb->state != VIDEOBUF_ACTIVE
-				     && vb->state != VIDEOBUF_QUEUED);
+		wait_event(m2m_ctx->finished, !(m2m_ctx->job_flags & TRANS_RUNNING));
 	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
 		list_del(&m2m_ctx->queue);
 		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
@@ -597,11 +598,8 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 	}
 
-	videobuf_stop(&m2m_ctx->cap_q_ctx.q);
-	videobuf_stop(&m2m_ctx->out_q_ctx.q);
-
-	videobuf_mmap_free(&m2m_ctx->cap_q_ctx.q);
-	videobuf_mmap_free(&m2m_ctx->out_q_ctx.q);
+	vb2_queue_release(&m2m_ctx->cap_q_ctx.q);
+	vb2_queue_release(&m2m_ctx->out_q_ctx.q);
 
 	kfree(m2m_ctx);
 }
@@ -611,23 +609,21 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
  * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
  *
  * Call from buf_queue(), videobuf_queue_ops callback.
- *
- * Locking: Caller holds q->irqlock (taken by videobuf before calling buf_queue
- * callback in the driver).
  */
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct videobuf_queue *vq,
-			struct videobuf_buffer *vb)
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb)
 {
+	struct v4l2_m2m_buffer *b = container_of(vb, struct v4l2_m2m_buffer, vb);
 	struct v4l2_m2m_queue_ctx *q_ctx;
+	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, vq->type);
+	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2_queue->type);
 	if (!q_ctx)
 		return;
 
-	list_add_tail(&vb->queue, &q_ctx->rdy_queue);
+	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
+	list_add_tail(&b->list, &q_ctx->rdy_queue);
 	q_ctx->num_rdy++;
-
-	vb->state = VIDEOBUF_QUEUED;
+	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 8d149f1..bf5eaaf 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -17,7 +17,7 @@
 #ifndef _MEDIA_V4L2_MEM2MEM_H
 #define _MEDIA_V4L2_MEM2MEM_H
 
-#include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 
 /**
  * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
@@ -45,17 +45,20 @@ struct v4l2_m2m_ops {
 	void (*device_run)(void *priv);
 	int (*job_ready)(void *priv);
 	void (*job_abort)(void *priv);
+	void (*lock)(void *priv);
+	void (*unlock)(void *priv);
 };
 
 struct v4l2_m2m_dev;
 
 struct v4l2_m2m_queue_ctx {
 /* private: internal use only */
-	struct videobuf_queue	q;
+	struct vb2_queue	q;
 
 	/* Queue for buffers ready to be processed as soon as this
 	 * instance receives access to the device */
 	struct list_head	rdy_queue;
+	spinlock_t		rdy_spinlock;
 	u8			num_rdy;
 };
 
@@ -72,19 +75,31 @@ struct v4l2_m2m_ctx {
 	/* For device job queue */
 	struct list_head		queue;
 	unsigned long			job_flags;
+	wait_queue_head_t		finished;
 
 	/* Instance private data */
 	void				*priv;
 };
 
+struct v4l2_m2m_buffer {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
 void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
 
-struct videobuf_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
+struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 				       enum v4l2_buf_type type);
 
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
 
+static inline void
+v4l2_m2m_buf_done(struct vb2_buffer *buf, enum vb2_buffer_state state)
+{
+	vb2_buffer_done(buf, state);
+}
+
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		     struct v4l2_requestbuffers *reqbufs);
 
@@ -110,13 +125,13 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops);
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
-struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
-			void (*vq_init)(void *priv, struct videobuf_queue *,
-					enum v4l2_buf_type));
+struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
+		void *drv_priv,
+		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
+
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct videobuf_queue *vq,
-			struct videobuf_buffer *vb);
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
 
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
@@ -138,7 +153,7 @@ unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 	return m2m_ctx->out_q_ctx.num_rdy;
 }
 
-void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type);
+void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
  * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
@@ -146,7 +161,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type);
  */
 static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return v4l2_m2m_next_buf(&m2m_ctx->out_q_ctx);
 }
 
 /**
@@ -155,29 +170,28 @@ static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
  */
 static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	return v4l2_m2m_next_buf(&m2m_ctx->cap_q_ctx);
 }
 
 /**
- * v4l2_m2m_get_src_vq() - return videobuf_queue for source buffers
+ * v4l2_m2m_get_src_vq() - return vb2_queue for source buffers
  */
 static inline
-struct videobuf_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
+struct vb2_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return &m2m_ctx->out_q_ctx.q;
 }
 
 /**
- * v4l2_m2m_get_dst_vq() - return videobuf_queue for destination buffers
+ * v4l2_m2m_get_dst_vq() - return vb2_queue for destination buffers
  */
 static inline
-struct videobuf_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
+struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	return &m2m_ctx->cap_q_ctx.q;
 }
 
-void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx,
-			  enum v4l2_buf_type type);
+void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
  * v4l2_m2m_src_buf_remove() - take off a source buffer from the list of ready
@@ -185,7 +199,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx,
  */
 static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return v4l2_m2m_buf_remove(&m2m_ctx->out_q_ctx);
 }
 
 /**
@@ -194,7 +208,7 @@ static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
  */
 static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
 }
 
 #endif /* _MEDIA_V4L2_MEM2MEM_H */
-- 
1.7.2.3

