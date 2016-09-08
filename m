Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56843 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936484AbcIHVhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 04/15] [media] v4l2-mem2mem.h: document the public structures
Date: Thu,  8 Sep 2016 18:37:30 -0300
Message-Id: <34874b7352c128102e38d3daf8e386fd8af5200e.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most structures here are not documented. Add a documentation
for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-mem2mem.h | 67 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 16 deletions(-)

diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 78eadca27a21..f74ea7026c88 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -41,9 +41,9 @@
  *		This function does not have to (and will usually not) wait
  *		until the device enters a state when it can be stopped.
  * @lock:	optional. Define a driver's own lock callback, instead of using
- *		m2m_ctx->q_lock.
+ *		&v4l2_m2m_ctx->q_lock.
  * @unlock:	optional. Define a driver's own unlock callback, instead of
- *		using m2m_ctx->q_lock.
+ *		using &v4l2_m2m_ctx->q_lock.
  */
 struct v4l2_m2m_ops {
 	void (*device_run)(void *priv);
@@ -53,31 +53,59 @@ struct v4l2_m2m_ops {
 	void (*unlock)(void *priv);
 };
 
+/**
+ * struct v4l2_m2m_dev - opaque struct used to represent a V4L2 M2M device.
+ *
+ * This structure is has the per-device context for a memory to memory
+ * device, and it is used internally at v4l2-mem2mem.c.
+ */
 struct v4l2_m2m_dev;
 
+/**
+ * struct v4l2_m2m_queue_ctx - represents a queue for buffers ready to be
+ *	processed
+ *
+ * @q:		pointer to struct &vb2_queue
+ * @rdy_queue:	List of V4L2 mem-to-mem queues
+ * @rdy_spinlock: spin lock to protect the struct usage
+ * @num_rdy:	number of buffers ready to be processed
+ * @buffered:	is the queue buffered?
+ *
+ * Queue for buffers ready to be processed as soon as this
+ * instance receives access to the device.
+ */
+
 struct v4l2_m2m_queue_ctx {
-/* private: internal use only */
 	struct vb2_queue	q;
 
-	/* Queue for buffers ready to be processed as soon as this
-	 * instance receives access to the device */
 	struct list_head	rdy_queue;
 	spinlock_t		rdy_spinlock;
 	u8			num_rdy;
 	bool			buffered;
 };
 
+/**
+ * struct v4l2_m2m_ctx - Memory to memory context structure
+ *
+ * @q_lock: struct &mutex lock
+ * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ * @cap_q_ctx: Capture (output to memory) queue context
+ * @out_q_ctx: Output (input from memory) queue context
+ * @queue: List of memory to memory contexts
+ * @job_flags: Job queue flags, used internally by v4l2-mem2mem.c:
+ * 		%TRANS_QUEUED, %TRANS_RUNNING and %TRANS_ABORT.
+ * @finished: Wait queue used to signalize when a job queue finished.
+ * @priv: Instance private data
+ */
 struct v4l2_m2m_ctx {
 	/* optional cap/out vb2 queues lock */
 	struct mutex			*q_lock;
 
-/* private: internal use only */
+	/* internal use only */
 	struct v4l2_m2m_dev		*m2m_dev;
 
-	/* Capture (output to memory) queue context */
 	struct v4l2_m2m_queue_ctx	cap_q_ctx;
 
-	/* Output (input from memory) queue context */
 	struct v4l2_m2m_queue_ctx	out_q_ctx;
 
 	/* For device job queue */
@@ -85,10 +113,15 @@ struct v4l2_m2m_ctx {
 	unsigned long			job_flags;
 	wait_queue_head_t		finished;
 
-	/* Instance private data */
 	void				*priv;
 };
 
+/**
+ * struct v4l2_m2m_buffer - Memory to memory buffer
+ *
+ * @vb: pointer to struct &vb2_v4l2_buffer
+ * @list: list of m2m buffers
+ */
 struct v4l2_m2m_buffer {
 	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
@@ -145,9 +178,9 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
  * Should be called as soon as possible after reaching a state which allows
  * other instances to take control of the device.
  *
- * This function has to be called only after device_run() callback has been
- * called on the driver. To prevent recursion, it should not be called directly
- * from the device_run() callback though.
+ * This function has to be called only after &v4l2_m2m_ops->device_run
+ * callback has been called on the driver. To prevent recursion, it should
+ * not be called directly from the &v4l2_m2m_ops->device_run callback though.
  */
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
@@ -292,7 +325,9 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
  *
  * @m2m_ops: pointer to struct v4l2_m2m_ops
  *
- * Usually called from driver's probe() function.
+ * Usually called from driver's ``probe()`` function.
+ *
+ * Return: returns an opaque pointer to the internal data to handle M2M context
  */
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 
@@ -301,7 +336,7 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
  *
  * @m2m_dev: pointer to struct &v4l2_m2m_dev
  *
- * Usually called from driver's remove() function.
+ * Usually called from driver's ``remove()`` function.
  */
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
@@ -313,7 +348,7 @@ void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
  * @queue_init: a callback for queue type-specific initialization function
  * 	to be used for initializing videobuf_queues
  *
- * Usually called from driver's open() function.
+ * Usually called from driver's ``open()`` function.
  */
 struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
@@ -346,7 +381,7 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
  * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  * @vbuf: pointer to struct &vb2_v4l2_buffer
  *
- * Call from buf_queue(), videobuf_queue_ops callback.
+ * Call from videobuf_queue_ops->ops->buf_queue, videobuf_queue_ops callback.
  */
 void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 			struct vb2_v4l2_buffer *vbuf);
-- 
2.7.4


