Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32477 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0IIJUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 05:20:09 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8H002UF39IJ7@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:06 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8H0058739H1E@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:06 +0100 (BST)
Date: Thu, 09 Sep 2010 11:19:44 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 3/7] v4l: mem2mem: port to videobuf2
In-reply-to: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1284023988-23351-4-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Port memory-to-memory framework to videobuf2 framework.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig        |    3 +-
 drivers/media/video/v4l2-mem2mem.c |  185 ++++++++++++++++++------------------
 include/media/v4l2-mem2mem.h       |   49 ++++++----
 3 files changed, 124 insertions(+), 113 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e4ac3e2..c2f99d8 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -47,7 +47,8 @@ config VIDEO_TUNER
 
 config V4L2_MEM2MEM_DEV
 	tristate
-	depends on VIDEOBUF_GEN
+	depends on VIDEOBUF2_CORE
+
 config VIDEOBUF2_CORE
 	tristate
 
diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
index f45f940..fa50dd0 100644
--- a/drivers/media/video/v4l2-mem2mem.c
+++ b/drivers/media/video/v4l2-mem2mem.c
@@ -17,7 +17,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include <media/v4l2-mem2mem.h>
 
 MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
@@ -77,9 +77,9 @@ static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
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
@@ -95,26 +95,21 @@ EXPORT_SYMBOL(v4l2_m2m_get_vq);
 /**
  * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
  */
-void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type)
+void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
-	struct v4l2_m2m_queue_ctx *q_ctx;
-	struct videobuf_buffer *vb = NULL;
+	struct vb2_buffer *vb = NULL;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, type);
-	if (!q_ctx)
-		return NULL;
-
-	spin_lock_irqsave(q_ctx->q.irqlock, flags);
+	spin_lock_irqsave(q_ctx->q.drv_lock, flags);
 
 	if (list_empty(&q_ctx->rdy_queue))
 		goto end;
 
-	vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer, queue);
-	vb->state = VIDEOBUF_ACTIVE;
+	vb = list_entry(q_ctx->rdy_queue.next, struct vb2_buffer, drv_entry);
+	vb->state = VB2_BUF_STATE_ACTIVE;
 
 end:
-	spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
+	spin_unlock_irqrestore(q_ctx->q.drv_lock, flags);
 	return vb;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
@@ -123,24 +118,19 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
  * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
  * return it
  */
-void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type)
+void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 {
-	struct v4l2_m2m_queue_ctx *q_ctx;
-	struct videobuf_buffer *vb = NULL;
+	struct vb2_buffer *vb = NULL;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, type);
-	if (!q_ctx)
-		return NULL;
-
-	spin_lock_irqsave(q_ctx->q.irqlock, flags);
+	spin_lock_irqsave(q_ctx->q.drv_lock, flags);
 	if (!list_empty(&q_ctx->rdy_queue)) {
-		vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer,
-				queue);
-		list_del(&vb->queue);
+		vb = list_entry(q_ctx->rdy_queue.next, struct vb2_buffer,
+				drv_entry);
+		list_del(&vb->drv_entry);
 		q_ctx->num_rdy--;
 	}
-	spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
+	spin_unlock_irqrestore(q_ctx->q.drv_lock, flags);
 
 	return vb;
 }
@@ -235,20 +225,20 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 		return;
 	}
 
-	spin_lock_irqsave(m2m_ctx->out_q_ctx.q.irqlock, flags);
+	spin_lock_irqsave(m2m_ctx->out_q_ctx.q.drv_lock, flags);
 	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
-		spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
+		spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.drv_lock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No input buffers available\n");
 		return;
 	}
 	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
-		spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
+		spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.drv_lock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No output buffers available\n");
 		return;
 	}
-	spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.irqlock, flags);
+	spin_unlock_irqrestore(m2m_ctx->out_q_ctx.q.drv_lock, flags);
 
 	if (m2m_dev->m2m_ops->job_ready
 		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
@@ -309,10 +299,10 @@ EXPORT_SYMBOL(v4l2_m2m_job_finish);
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
 
@@ -324,12 +314,12 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      struct v4l2_buffer *buf)
 {
-	struct videobuf_queue *vq;
-	int ret;
+	struct vb2_queue *vq;
+	int ret = 0;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = videobuf_querybuf(vq, buf);
 
+	ret = vb2_querybuf(vq, buf);
 	if (buf->memory == V4L2_MEMORY_MMAP
 	    && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		buf->m.offset += DST_QUEUE_OFF_BASE;
@@ -346,11 +336,11 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
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
 
@@ -365,10 +355,10 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
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
 
@@ -378,11 +368,11 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
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
 
@@ -396,10 +386,10 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
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
 
@@ -414,9 +404,10 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
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
@@ -424,30 +415,39 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	mutex_lock(&src_q->vb_lock);
 	mutex_lock(&dst_q->vb_lock);
 
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
+	poll_wait(file, &src_q->done_wq, wait);
+	poll_wait(file, &dst_q->done_wq, wait);
+
+	spin_lock_irqsave(&src_q->done_lock, flags);
+	if (!list_empty(&src_q->done_list))
+		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
+						done_entry);
+	spin_unlock_irqrestore(&src_q->done_lock, flags);
+
+	spin_lock_irqsave(&dst_q->done_lock, flags);
+	if (!list_empty(&dst_q->done_list))
+		src_vb = list_first_entry(&dst_q->done_list, struct vb2_buffer,
+						done_entry);
+	spin_unlock_irqrestore(&dst_q->done_lock, flags);
+
+	if (src_vb && (src_vb->state == VB2_BUF_STATE_DONE
+			|| src_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLOUT | POLLWRNORM;
+
+	if (dst_vb && (dst_vb->state == VB2_BUF_STATE_DONE
+			|| dst_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLIN | POLLRDNORM;
 
 end:
 	mutex_unlock(&dst_q->vb_lock);
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
 
@@ -531,21 +531,22 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_release);
  *
  * Usually called from driver's open() function.
  */
-struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
-			void (*vq_init)(void *priv, struct videobuf_queue *,
-					enum v4l2_buf_type))
+struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
+				void *drv_priv, spinlock_t *drv_lock,
+				const struct vb2_ops *src_q_ops,
+				const struct vb2_alloc_ctx *src_q_alloc_ctx,
+				const struct vb2_ops *dst_q_ops,
+				const struct vb2_alloc_ctx *dst_q_alloc_ctx)
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
 
 	out_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -556,11 +557,20 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
 
 	INIT_LIST_HEAD(&m2m_ctx->queue);
 
-	vq_init(priv, &out_q_ctx->q, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	vq_init(priv, &cap_q_ctx->q, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	out_q_ctx->q.priv_data = cap_q_ctx->q.priv_data = priv;
+	ret = vb2_queue_init(&out_q_ctx->q, src_q_ops, src_q_alloc_ctx,
+			drv_lock, V4L2_BUF_TYPE_VIDEO_OUTPUT, drv_priv);
+	if (ret)
+		goto err;
+
+	ret = vb2_queue_init(&cap_q_ctx->q, dst_q_ops, dst_q_alloc_ctx,
+			drv_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE, drv_priv);
+	if (ret)
+		goto err;
 
 	return m2m_ctx;
+err:
+	kfree(m2m_ctx);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 
@@ -572,7 +582,7 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	struct v4l2_m2m_dev *m2m_dev;
-	struct videobuf_buffer *vb;
+	struct vb2_buffer *vb;
 	unsigned long flags;
 
 	m2m_dev = m2m_ctx->m2m_dev;
@@ -584,8 +594,6 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
 		vb = v4l2_m2m_next_dst_buf(m2m_ctx);
 		BUG_ON(NULL == vb);
-		wait_event(vb->done, vb->state != VIDEOBUF_ACTIVE
-				     && vb->state != VIDEOBUF_QUEUED);
 	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
 		list_del(&m2m_ctx->queue);
 		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
@@ -597,11 +605,8 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
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
@@ -615,19 +620,17 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
  * Locking: Caller holds q->irqlock (taken by videobuf before calling buf_queue
  * callback in the driver).
  */
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct videobuf_queue *vq,
-			struct videobuf_buffer *vb)
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb)
 {
 	struct v4l2_m2m_queue_ctx *q_ctx;
 
-	q_ctx = get_queue_ctx(m2m_ctx, vq->type);
+	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2_queue->type);
 	if (!q_ctx)
 		return;
 
-	list_add_tail(&vb->queue, &q_ctx->rdy_queue);
+	list_add_tail(&vb->drv_entry, &q_ctx->rdy_queue);
 	q_ctx->num_rdy++;
-
-	vb->state = VIDEOBUF_QUEUED;
+	vb->state = VB2_BUF_STATE_QUEUED;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 8d149f1..1b49997 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -17,7 +17,7 @@
 #ifndef _MEDIA_V4L2_MEM2MEM_H
 #define _MEDIA_V4L2_MEM2MEM_H
 
-#include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 
 /**
  * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
@@ -51,7 +51,7 @@ struct v4l2_m2m_dev;
 
 struct v4l2_m2m_queue_ctx {
 /* private: internal use only */
-	struct videobuf_queue	q;
+	struct vb2_queue	q;
 
 	/* Queue for buffers ready to be processed as soon as this
 	 * instance receives access to the device */
@@ -79,12 +79,18 @@ struct v4l2_m2m_ctx {
 
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
 
@@ -110,13 +116,15 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops);
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
-struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
-			void (*vq_init)(void *priv, struct videobuf_queue *,
-					enum v4l2_buf_type));
+struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
+				void *drv_priv, spinlock_t *drv_lock,
+				const struct vb2_ops *src_q_ops,
+				const struct vb2_alloc_ctx *src_q_alloc_ctx,
+				const struct vb2_ops *dst_q_ops,
+				const struct vb2_alloc_ctx *dst_q_alloc_ctx);
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct videobuf_queue *vq,
-			struct videobuf_buffer *vb);
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
 
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
@@ -138,7 +146,7 @@ unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 	return m2m_ctx->out_q_ctx.num_rdy;
 }
 
-void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type);
+void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
  * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
@@ -146,7 +154,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx, enum v4l2_buf_type type);
  */
 static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return v4l2_m2m_next_buf(&m2m_ctx->out_q_ctx);
 }
 
 /**
@@ -155,29 +163,28 @@ static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
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
@@ -185,7 +192,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx,
  */
 static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return v4l2_m2m_buf_remove(&m2m_ctx->out_q_ctx);
 }
 
 /**
@@ -194,7 +201,7 @@ static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
  */
 static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
 }
 
 #endif /* _MEDIA_V4L2_MEM2MEM_H */
-- 
1.7.2.1.97.g3235b.dirty

