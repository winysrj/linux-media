Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56841 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936532AbcIHVhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 03/15] [media] v4l2-mem2mem.h: document function arguments
Date: Thu,  8 Sep 2016 18:37:29 -0300
Message-Id: <b73eea259ec3d125ae45f842826cb2def9dfe4eb.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of troubles with the function arguments on this
file. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-mem2mem.h | 93 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 80 insertions(+), 13 deletions(-)

diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index e5449a2c8475..78eadca27a21 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -97,11 +97,16 @@ struct v4l2_m2m_buffer {
 /**
  * v4l2_m2m_get_curr_priv() - return driver private data for the currently
  * running instance or NULL if no instance is running
+ *
+ * @m2m_dev: pointer to struct &v4l2_m2m_dev
  */
 void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
 
 /**
  * v4l2_m2m_get_vq() - return vb2_queue for the given type
+ *
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @type: type of the V4L2 buffer, as defined by enum &v4l2_buf_type
  */
 struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 				       enum v4l2_buf_type type);
@@ -109,7 +114,8 @@ struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_try_schedule() - check whether an instance is ready to be added to
  * the pending job queue and add it if so.
- * @m2m_ctx:	m2m context assigned to the instance to be checked
+ *
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  *
  * There are three basic requirements an instance has to meet to be able to run:
  * 1) at least one source buffer has to be queued,
@@ -132,6 +138,9 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
  * v4l2_m2m_job_finish() - inform the framework that a job has been finished
  * and have it clean up
  *
+ * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ *
  * Called by a driver to yield back the device after it has finished with it.
  * Should be called as soon as possible after reaching a state which allows
  * other instances to take control of the device.
@@ -151,6 +160,10 @@ v4l2_m2m_buf_done(struct vb2_v4l2_buffer *buf, enum vb2_buffer_state state)
 
 /**
  * v4l2_m2m_reqbufs() - multi-queue-aware REQBUFS multiplexer
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @reqbufs: pointer to struct &v4l2_requestbuffers
  */
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		     struct v4l2_requestbuffers *reqbufs);
@@ -158,6 +171,10 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_querybuf() - multi-queue-aware QUERYBUF multiplexer
  *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @buf: pointer to struct &v4l2_buffer
+ *
  * See v4l2_m2m_mmap() documentation for details.
  */
 int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
@@ -166,6 +183,10 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_qbuf() - enqueue a source or destination buffer, depending on
  * the type
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @buf: pointer to struct &v4l2_buffer
  */
 int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		  struct v4l2_buffer *buf);
@@ -173,6 +194,10 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_dqbuf() - dequeue a source or destination buffer, depending on
  * the type
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @buf: pointer to struct &v4l2_buffer
  */
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf);
@@ -180,6 +205,10 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_prepare_buf() - prepare a source or destination buffer, depending on
  * the type
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @buf: pointer to struct &v4l2_buffer
  */
 int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_buffer *buf);
@@ -187,6 +216,10 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_create_bufs() - create a source or destination buffer, depending
  * on the type
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @create: pointer to struct &v4l2_create_buffers
  */
 int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_create_buffers *create);
@@ -194,18 +227,30 @@ int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_expbuf() - export a source or destination buffer, depending on
  * the type
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @eb: pointer to struct &v4l2_exportbuffer
  */
 int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_exportbuffer *eb);
 
 /**
  * v4l2_m2m_streamon() - turn on streaming for a video queue
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @type: type of the V4L2 buffer, as defined by enum &v4l2_buf_type
  */
 int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      enum v4l2_buf_type type);
 
 /**
  * v4l2_m2m_streamoff() - turn off streaming for a video queue
+ *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @type: type of the V4L2 buffer, as defined by enum &v4l2_buf_type
  */
 int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		       enum v4l2_buf_type type);
@@ -213,6 +258,10 @@ int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_poll() - poll replacement, for destination buffers only
  *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @wait: pointer to struct &poll_table_struct
+ *
  * Call from the driver's poll() function. Will poll both queues. If a buffer
  * is available to dequeue (with dqbuf) from the source queue, this will
  * indicate that a non-blocking write can be performed, while read will be
@@ -224,6 +273,10 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_mmap() - source and destination queues-aware mmap multiplexer
  *
+ * @file: pointer to struct &file
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @vma: pointer to struct &vm_area_struct
+ *
  * Call from driver's mmap() function. Will handle mmap() for both queues
  * seamlessly for videobuffer, which will receive normal per-queue offsets and
  * proper videobuf queue pointers. The differentiation is made outside videobuf
@@ -237,6 +290,8 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_init() - initialize per-driver m2m data
  *
+ * @m2m_ops: pointer to struct v4l2_m2m_ops
+ *
  * Usually called from driver's probe() function.
  */
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
@@ -244,16 +299,19 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 /**
  * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
  *
+ * @m2m_dev: pointer to struct &v4l2_m2m_dev
+ *
  * Usually called from driver's remove() function.
  */
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
 /**
  * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
- * @priv - driver's instance private data
- * @m2m_dev - a previously initialized m2m_dev struct
- * @vq_init - a callback for queue type-specific initialization function to be
- * used for initializing videobuf_queues
+ *
+ * @m2m_dev: a previously initialized m2m_dev struct
+ * @drv_priv: driver's instance private data
+ * @queue_init: a callback for queue type-specific initialization function
+ * 	to be used for initializing videobuf_queues
  *
  * Usually called from driver's open() function.
  */
@@ -276,6 +334,8 @@ static inline void v4l2_m2m_set_dst_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 /**
  * v4l2_m2m_ctx_release() - release m2m context
  *
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ *
  * Usually called from driver's release() function.
  */
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
@@ -283,6 +343,9 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 /**
  * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
  *
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
+ * @vbuf: pointer to struct &vb2_v4l2_buffer
+ *
  * Call from buf_queue(), videobuf_queue_ops callback.
  */
 void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
@@ -292,7 +355,7 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
  * use
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline
 unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
@@ -304,7 +367,7 @@ unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
  * v4l2_m2m_num_src_bufs_ready() - return the number of destination buffers
  * ready for use
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline
 unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
@@ -314,6 +377,8 @@ unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
 
 /**
  * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
+ *
+ * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
  */
 void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
 
@@ -321,7 +386,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
  * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
  * buffers
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -332,7 +397,7 @@ static inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
  * v4l2_m2m_next_dst_buf() - return next destination buffer from the list of
  * ready buffers
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -342,7 +407,7 @@ static inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
 /**
  * v4l2_m2m_get_src_vq() - return vb2_queue for source buffers
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline
 struct vb2_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
@@ -353,7 +418,7 @@ struct vb2_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
 /**
  * v4l2_m2m_get_dst_vq() - return vb2_queue for destination buffers
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline
 struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
@@ -364,6 +429,8 @@ struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
 /**
  * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
  * return it
+ *
+ * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
  */
 void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
 
@@ -371,7 +438,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
  * v4l2_m2m_src_buf_remove() - take off a source buffer from the list of ready
  * buffers and return it
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
@@ -382,7 +449,7 @@ static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
  * v4l2_m2m_dst_buf_remove() - take off a destination buffer from the list of
  * ready buffers and return it
  *
- * @m2m_ctx: pointer to struct v4l2_m2m_ctx
+ * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
  */
 static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
 {
-- 
2.7.4


