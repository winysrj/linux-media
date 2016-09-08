Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56849 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936551AbcIHVhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Zahari Doychev <zahari.doychev@linux.com>
Subject: [PATCH 02/15] [media] v4l2-mem2mem.h: move descriptions from .c file
Date: Thu,  8 Sep 2016 18:37:28 -0300
Message-Id: <9d7197bc6632058e990a5acbff57c43cf4d8ae98.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several routines are somewhat documented at v4l2-mem2mem.c
file. Move what's there to the header file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 128 +-------------------------------
 include/media/v4l2-mem2mem.h           | 132 +++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 127 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 61d56c940f80..6bc27e7b2a33 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -76,9 +76,6 @@ static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
 		return &m2m_ctx->cap_q_ctx;
 }
 
-/**
- * v4l2_m2m_get_vq() - return vb2_queue for the given type
- */
 struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 				       enum v4l2_buf_type type)
 {
@@ -92,9 +89,6 @@ struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL(v4l2_m2m_get_vq);
 
-/**
- * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
- */
 void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
@@ -113,10 +107,6 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_next_buf);
 
-/**
- * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
- * return it
- */
 void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
 {
 	struct v4l2_m2m_buffer *b;
@@ -140,10 +130,6 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove);
  * Scheduling handlers
  */
 
-/**
- * v4l2_m2m_get_curr_priv() - return driver private data for the currently
- * running instance or NULL if no instance is running
- */
 void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev)
 {
 	unsigned long flags;
@@ -188,26 +174,6 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
 	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
 }
 
-/**
- * v4l2_m2m_try_schedule() - check whether an instance is ready to be added to
- * the pending job queue and add it if so.
- * @m2m_ctx:	m2m context assigned to the instance to be checked
- *
- * There are three basic requirements an instance has to meet to be able to run:
- * 1) at least one source buffer has to be queued,
- * 2) at least one destination buffer has to be queued,
- * 3) streaming has to be on.
- *
- * If a queue is buffered (for example a decoder hardware ringbuffer that has
- * to be drained before doing streamoff), allow scheduling without v4l2 buffers
- * on that queue.
- *
- * There may also be additional, custom requirements. In such case the driver
- * should supply a custom callback (job_ready in v4l2_m2m_ops) that should
- * return 1 if the instance is ready.
- * An example of the above could be an instance that requires more than one
- * src/dst buffer per transaction.
- */
 void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	struct v4l2_m2m_dev *m2m_dev;
@@ -311,18 +277,6 @@ static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
 	}
 }
 
-/**
- * v4l2_m2m_job_finish() - inform the framework that a job has been finished
- * and have it clean up
- *
- * Called by a driver to yield back the device after it has finished with it.
- * Should be called as soon as possible after reaching a state which allows
- * other instances to take control of the device.
- *
- * This function has to be called only after device_run() callback has been
- * called on the driver. To prevent recursion, it should not be called directly
- * from the device_run() callback though.
- */
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -350,9 +304,6 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 }
 EXPORT_SYMBOL(v4l2_m2m_job_finish);
 
-/**
- * v4l2_m2m_reqbufs() - multi-queue-aware REQBUFS multiplexer
- */
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		     struct v4l2_requestbuffers *reqbufs)
 {
@@ -370,11 +321,6 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-/**
- * v4l2_m2m_querybuf() - multi-queue-aware QUERYBUF multiplexer
- *
- * See v4l2_m2m_mmap() documentation for details.
- */
 int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      struct v4l2_buffer *buf)
 {
@@ -400,10 +346,6 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 
-/**
- * v4l2_m2m_qbuf() - enqueue a source or destination buffer, depending on
- * the type
- */
 int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf)
 {
@@ -419,10 +361,6 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
-/**
- * v4l2_m2m_dqbuf() - dequeue a source or destination buffer, depending on
- * the type
- */
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf)
 {
@@ -433,10 +371,6 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
-/**
- * v4l2_m2m_prepare_buf() - prepare a source or destination buffer, depending on
- * the type
- */
 int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_buffer *buf)
 {
@@ -452,10 +386,6 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
-/**
- * v4l2_m2m_create_bufs() - create a source or destination buffer, depending
- * on the type
- */
 int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_create_buffers *create)
 {
@@ -466,10 +396,6 @@ int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_create_bufs);
 
-/**
- * v4l2_m2m_expbuf() - export a source or destination buffer, depending on
- * the type
- */
 int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_exportbuffer *eb)
 {
@@ -479,9 +405,7 @@ int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	return vb2_expbuf(vq, eb);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_expbuf);
-/**
- * v4l2_m2m_streamon() - turn on streaming for a video queue
- */
+
 int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      enum v4l2_buf_type type)
 {
@@ -497,9 +421,6 @@ int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
 
-/**
- * v4l2_m2m_streamoff() - turn off streaming for a video queue
- */
 int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		       enum v4l2_buf_type type)
 {
@@ -540,14 +461,6 @@ int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
 
-/**
- * v4l2_m2m_poll() - poll replacement, for destination buffers only
- *
- * Call from the driver's poll() function. Will poll both queues. If a buffer
- * is available to dequeue (with dqbuf) from the source queue, this will
- * indicate that a non-blocking write can be performed, while read will be
- * returned in case of the destination queue.
- */
 unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			   struct poll_table_struct *wait)
 {
@@ -626,16 +539,6 @@ end:
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_poll);
 
-/**
- * v4l2_m2m_mmap() - source and destination queues-aware mmap multiplexer
- *
- * Call from driver's mmap() function. Will handle mmap() for both queues
- * seamlessly for videobuffer, which will receive normal per-queue offsets and
- * proper videobuf queue pointers. The differentiation is made outside videobuf
- * by adding a predefined offset to buffers from one of the queues and
- * subtracting it before passing it back to videobuf. Only drivers (and
- * thus applications) receive modified offsets.
- */
 int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct vm_area_struct *vma)
 {
@@ -653,11 +556,6 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL(v4l2_m2m_mmap);
 
-/**
- * v4l2_m2m_init() - initialize per-driver m2m data
- *
- * Usually called from driver's probe() function.
- */
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 {
 	struct v4l2_m2m_dev *m2m_dev;
@@ -679,26 +577,12 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_init);
 
-/**
- * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
- *
- * Usually called from driver's remove() function.
- */
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
 {
 	kfree(m2m_dev);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_release);
 
-/**
- * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
- * @priv - driver's instance private data
- * @m2m_dev - a previously initialized m2m_dev struct
- * @vq_init - a callback for queue type-specific initialization function to be
- * used for initializing videobuf_queues
- *
- * Usually called from driver's open() function.
- */
 struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
 		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq))
@@ -744,11 +628,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 
-/**
- * v4l2_m2m_ctx_release() - release m2m context
- *
- * Usually called from driver's release() function.
- */
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	/* wait until the current context is dequeued from job_queue */
@@ -761,11 +640,6 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
 
-/**
- * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
- *
- * Call from buf_queue(), videobuf_queue_ops callback.
- */
 void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 		struct vb2_v4l2_buffer *vbuf)
 {
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 5a9597dd1ee0..e5449a2c8475 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -94,13 +94,52 @@ struct v4l2_m2m_buffer {
 	struct list_head	list;
 };
 
+/**
+ * v4l2_m2m_get_curr_priv() - return driver private data for the currently
+ * running instance or NULL if no instance is running
+ */
 void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
 
+/**
+ * v4l2_m2m_get_vq() - return vb2_queue for the given type
+ */
 struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 				       enum v4l2_buf_type type);
 
+/**
+ * v4l2_m2m_try_schedule() - check whether an instance is ready to be added to
+ * the pending job queue and add it if so.
+ * @m2m_ctx:	m2m context assigned to the instance to be checked
+ *
+ * There are three basic requirements an instance has to meet to be able to run:
+ * 1) at least one source buffer has to be queued,
+ * 2) at least one destination buffer has to be queued,
+ * 3) streaming has to be on.
+ *
+ * If a queue is buffered (for example a decoder hardware ringbuffer that has
+ * to be drained before doing streamoff), allow scheduling without v4l2 buffers
+ * on that queue.
+ *
+ * There may also be additional, custom requirements. In such case the driver
+ * should supply a custom callback (job_ready in v4l2_m2m_ops) that should
+ * return 1 if the instance is ready.
+ * An example of the above could be an instance that requires more than one
+ * src/dst buffer per transaction.
+ */
 void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
 
+/**
+ * v4l2_m2m_job_finish() - inform the framework that a job has been finished
+ * and have it clean up
+ *
+ * Called by a driver to yield back the device after it has finished with it.
+ * Should be called as soon as possible after reaching a state which allows
+ * other instances to take control of the device.
+ *
+ * This function has to be called only after device_run() callback has been
+ * called on the driver. To prevent recursion, it should not be called directly
+ * from the device_run() callback though.
+ */
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
 
@@ -110,38 +149,114 @@ v4l2_m2m_buf_done(struct vb2_v4l2_buffer *buf, enum vb2_buffer_state state)
 	vb2_buffer_done(&buf->vb2_buf, state);
 }
 
+/**
+ * v4l2_m2m_reqbufs() - multi-queue-aware REQBUFS multiplexer
+ */
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		     struct v4l2_requestbuffers *reqbufs);
 
+/**
+ * v4l2_m2m_querybuf() - multi-queue-aware QUERYBUF multiplexer
+ *
+ * See v4l2_m2m_mmap() documentation for details.
+ */
 int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      struct v4l2_buffer *buf);
 
+/**
+ * v4l2_m2m_qbuf() - enqueue a source or destination buffer, depending on
+ * the type
+ */
 int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf);
+
+/**
+ * v4l2_m2m_dqbuf() - dequeue a source or destination buffer, depending on
+ * the type
+ */
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf);
+
+/**
+ * v4l2_m2m_prepare_buf() - prepare a source or destination buffer, depending on
+ * the type
+ */
 int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_buffer *buf);
+
+/**
+ * v4l2_m2m_create_bufs() - create a source or destination buffer, depending
+ * on the type
+ */
 int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_create_buffers *create);
 
+/**
+ * v4l2_m2m_expbuf() - export a source or destination buffer, depending on
+ * the type
+ */
 int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_exportbuffer *eb);
 
+/**
+ * v4l2_m2m_streamon() - turn on streaming for a video queue
+ */
 int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      enum v4l2_buf_type type);
+
+/**
+ * v4l2_m2m_streamoff() - turn off streaming for a video queue
+ */
 int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		       enum v4l2_buf_type type);
 
+/**
+ * v4l2_m2m_poll() - poll replacement, for destination buffers only
+ *
+ * Call from the driver's poll() function. Will poll both queues. If a buffer
+ * is available to dequeue (with dqbuf) from the source queue, this will
+ * indicate that a non-blocking write can be performed, while read will be
+ * returned in case of the destination queue.
+ */
 unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			   struct poll_table_struct *wait);
 
+/**
+ * v4l2_m2m_mmap() - source and destination queues-aware mmap multiplexer
+ *
+ * Call from driver's mmap() function. Will handle mmap() for both queues
+ * seamlessly for videobuffer, which will receive normal per-queue offsets and
+ * proper videobuf queue pointers. The differentiation is made outside videobuf
+ * by adding a predefined offset to buffers from one of the queues and
+ * subtracting it before passing it back to videobuf. Only drivers (and
+ * thus applications) receive modified offsets.
+ */
 int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct vm_area_struct *vma);
 
+/**
+ * v4l2_m2m_init() - initialize per-driver m2m data
+ *
+ * Usually called from driver's probe() function.
+ */
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
+
+/**
+ * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
+ *
+ * Usually called from driver's remove() function.
+ */
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
+/**
+ * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
+ * @priv - driver's instance private data
+ * @m2m_dev - a previously initialized m2m_dev struct
+ * @vq_init - a callback for queue type-specific initialization function to be
+ * used for initializing videobuf_queues
+ *
+ * Usually called from driver's open() function.
+ */
 struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
 		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
@@ -158,8 +273,18 @@ static inline void v4l2_m2m_set_dst_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 	m2m_ctx->cap_q_ctx.buffered = buffered;
 }
 
+/**
+ * v4l2_m2m_ctx_release() - release m2m context
+ *
+ * Usually called from driver's release() function.
+ */
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
+/**
+ * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
+ *
+ * Call from buf_queue(), videobuf_queue_ops callback.
+ */
 void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 			struct vb2_v4l2_buffer *vbuf);
 
@@ -187,6 +312,9 @@ unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 	return m2m_ctx->cap_q_ctx.num_rdy;
 }
 
+/**
+ * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
+ */
 void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
@@ -233,6 +361,10 @@ struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
 	return &m2m_ctx->cap_q_ctx.q;
 }
 
+/**
+ * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
+ * return it
+ */
 void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
 
 /**
-- 
2.7.4


