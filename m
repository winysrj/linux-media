Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56805 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728456AbeHDOqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 10:46:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv17 23/34] videobuf2-core: integrate with media requests
Date: Sat,  4 Aug 2018 14:45:15 +0200
Message-Id: <20180804124526.46206-24-hverkuil@xs4all.nl>
In-Reply-To: <20180804124526.46206-1-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Buffers can now be prepared or queued for a request.

A buffer is unbound from the request at vb2_buffer_done time or
when the queue is cancelled.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-core.c   | 133 +++++++++++++++++-
 .../media/common/videobuf2/videobuf2-v4l2.c   |   4 +-
 drivers/media/dvb-core/dvb_vb2.c              |   2 +-
 include/media/videobuf2-core.h                |  18 ++-
 4 files changed, 147 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 230f83d6d094..1efb9c8b359d 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -499,8 +499,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 			pr_info("     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
 				vb->cnt_buf_init, vb->cnt_buf_cleanup,
 				vb->cnt_buf_prepare, vb->cnt_buf_finish);
-			pr_info("     buf_queue: %u buf_done: %u\n",
-				vb->cnt_buf_queue, vb->cnt_buf_done);
+			pr_info("     buf_queue: %u buf_done: %u buf_request_complete: %u\n",
+				vb->cnt_buf_queue, vb->cnt_buf_done,
+				vb->cnt_buf_request_complete);
 			pr_info("     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
 				vb->cnt_mem_alloc, vb->cnt_mem_put,
 				vb->cnt_mem_prepare, vb->cnt_mem_finish,
@@ -936,6 +937,14 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		vb->state = state;
 	}
 	atomic_dec(&q->owned_by_drv_count);
+
+	if (vb->req_obj.req) {
+		/* This is not supported at the moment */
+		WARN_ON(state == VB2_BUF_STATE_REQUEUEING);
+		media_request_object_unbind(&vb->req_obj);
+		media_request_object_put(&vb->req_obj);
+	}
+
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	trace_vb2_buf_done(q, vb);
@@ -1290,6 +1299,60 @@ static int __buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int vb2_req_prepare(struct media_request_object *obj)
+{
+	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
+	int ret;
+
+	if (WARN_ON(vb->state != VB2_BUF_STATE_IN_REQUEST))
+		return -EINVAL;
+
+	mutex_lock(vb->vb2_queue->lock);
+	ret = __buf_prepare(vb);
+	mutex_unlock(vb->vb2_queue->lock);
+	return ret;
+}
+
+static void __vb2_dqbuf(struct vb2_buffer *vb);
+
+static void vb2_req_unprepare(struct media_request_object *obj)
+{
+	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
+
+	mutex_lock(vb->vb2_queue->lock);
+	__vb2_dqbuf(vb);
+	vb->state = VB2_BUF_STATE_IN_REQUEST;
+	mutex_unlock(vb->vb2_queue->lock);
+	WARN_ON(!vb->req_obj.req);
+}
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct media_request *req);
+
+static void vb2_req_queue(struct media_request_object *obj)
+{
+	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
+
+	mutex_lock(vb->vb2_queue->lock);
+	vb2_core_qbuf(vb->vb2_queue, vb->index, NULL, NULL);
+	mutex_unlock(vb->vb2_queue->lock);
+}
+
+static void vb2_req_release(struct media_request_object *obj)
+{
+	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
+
+	if (vb->state == VB2_BUF_STATE_IN_REQUEST)
+		vb->state = VB2_BUF_STATE_DEQUEUED;
+}
+
+static const struct media_request_object_ops vb2_core_req_ops = {
+	.prepare = vb2_req_prepare,
+	.unprepare = vb2_req_unprepare,
+	.queue = vb2_req_queue,
+	.release = vb2_req_release,
+};
+
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
@@ -1315,7 +1378,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 
 	dprintk(2, "prepare of buffer %d succeeded\n", vb->index);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
@@ -1382,7 +1445,8 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct media_request *req)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1394,8 +1458,39 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 
 	vb = q->bufs[index];
 
+	if (req) {
+		int ret;
+
+		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+			dprintk(1, "buffer %d not in dequeued state\n",
+				vb->index);
+			return -EINVAL;
+		}
+
+		media_request_object_init(&vb->req_obj);
+
+		/* Make sure the request is in a safe state for updating. */
+		ret = media_request_lock_for_update(req);
+		if (ret)
+			return ret;
+		ret = media_request_object_bind(req, &vb2_core_req_ops,
+						q, &vb->req_obj);
+		media_request_unlock_for_update(req);
+		if (ret)
+			return ret;
+
+		vb->state = VB2_BUF_STATE_IN_REQUEST;
+		/* Fill buffer information for the userspace */
+		if (pb)
+			call_void_bufop(q, fill_user_buffer, vb, pb);
+
+		dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
+		return 0;
+	}
+
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
+	case VB2_BUF_STATE_IN_REQUEST:
 		if (!vb->prepared) {
 			ret = __buf_prepare(vb);
 			if (ret)
@@ -1601,6 +1696,11 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
 			vb->planes[i].dbuf_mapped = 0;
 		}
+	if (vb->req_obj.req) {
+		media_request_object_unbind(&vb->req_obj);
+		media_request_object_put(&vb->req_obj);
+	}
+	call_void_bufop(q, init_buffer, vb);
 }
 
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
@@ -1714,6 +1814,25 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	for (i = 0; i < q->num_buffers; ++i) {
 		struct vb2_buffer *vb = q->bufs[i];
+		struct media_request *req = vb->req_obj.req;
+
+		/*
+		 * If a request is associated with this buffer, then
+		 * call buf_request_cancel() to give the driver to complete()
+		 * related request objects. Otherwise those objects would
+		 * never complete.
+		 */
+		if (req) {
+			enum media_request_state state;
+			unsigned long flags;
+
+			spin_lock_irqsave(&req->lock, flags);
+			state = req->state;
+			spin_unlock_irqrestore(&req->lock, flags);
+
+			if (state == MEDIA_REQUEST_STATE_QUEUED)
+				call_void_vb_qop(vb, buf_request_complete, vb);
+		}
 
 		if (vb->synced) {
 			unsigned int plane;
@@ -2283,7 +2402,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2462,7 +2581,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2565,7 +2684,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 64905d87465c..ea9db4b3f59a 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -441,6 +441,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	case VB2_BUF_STATE_ACTIVE:
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
 		break;
+	case VB2_BUF_STATE_IN_REQUEST:
+		break;
 	case VB2_BUF_STATE_ERROR:
 		b->flags |= V4L2_BUF_FLAG_ERROR;
 		/* fall through */
@@ -619,7 +621,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 
 	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+	return ret ? ret : vb2_core_qbuf(q, b->index, b, NULL);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index da6a8cec7d42..f1e7f0536028 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -384,7 +384,7 @@ int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
 	int ret;
 
-	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b);
+	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL);
 	if (ret) {
 		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
 			b->index, ret);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index df92dcdeabb3..8a8d7732d182 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -204,6 +204,7 @@ enum vb2_io_modes {
 /**
  * enum vb2_buffer_state - current video buffer state.
  * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control.
+ * @VB2_BUF_STATE_IN_REQUEST:	buffer is queued in media request.
  * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf.
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver.
  * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver.
@@ -217,6 +218,7 @@ enum vb2_io_modes {
  */
 enum vb2_buffer_state {
 	VB2_BUF_STATE_DEQUEUED,
+	VB2_BUF_STATE_IN_REQUEST,
 	VB2_BUF_STATE_PREPARING,
 	VB2_BUF_STATE_QUEUED,
 	VB2_BUF_STATE_REQUEUEING,
@@ -293,6 +295,7 @@ struct vb2_buffer {
 	u32		cnt_buf_finish;
 	u32		cnt_buf_cleanup;
 	u32		cnt_buf_queue;
+	u32		cnt_buf_request_complete;
 
 	/* This counts the number of calls to vb2_buffer_done() */
 	u32		cnt_buf_done;
@@ -386,6 +389,11 @@ struct vb2_buffer {
  *			ioctl; might be called before @start_streaming callback
  *			if user pre-queued buffers before calling
  *			VIDIOC_STREAMON().
+ * @buf_request_complete: a buffer that was never queued to the driver but is
+ *			associated with a queued request was canceled.
+ *			The driver will have to mark associated objects in the
+ *			request as completed; required if requests are
+ *			supported.
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q,
@@ -404,6 +412,8 @@ struct vb2_ops {
 	void (*stop_streaming)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
+
+	void (*buf_request_complete)(struct vb2_buffer *vb);
 };
 
 /**
@@ -761,12 +771,17 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * @index:	id number of the buffer
  * @pb:		buffer structure passed from userspace to
  *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
+ * @req:	pointer to &struct media_request, may be NULL.
  *
  * Videobuf2 core helper to implement VIDIOC_QBUF() operation. It is called
  * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * This function:
  *
+ * #) If @req is non-NULL, then the buffer will be bound to this
+ *    media request and it returns. The buffer will be prepared and
+ *    queued to the driver (i.e. the next two steps) when the request
+ *    itself is queued.
  * #) if necessary, calls &vb2_ops->buf_prepare callback in the driver
  *    (if provided), in which driver-specific buffer initialization can
  *    be performed;
@@ -775,7 +790,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  *
  * Return: returns zero on success; an error code otherwise.
  */
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct media_request *req);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
-- 
2.18.0
