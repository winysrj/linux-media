Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:49609 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751677AbeEAJA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 05:00:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv12 PATCH 17/29] videobuf2-core: integrate with media requests
Date: Tue,  1 May 2018 11:00:39 +0200
Message-Id: <20180501090051.9321-18-hverkuil@xs4all.nl>
In-Reply-To: <20180501090051.9321-1-hverkuil@xs4all.nl>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Buffers can now be prepared or queued for a request.

A buffer is unbound from the request at vb2_buffer_done time or
when the queue is cancelled.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-core.c   | 146 ++++++++++++++++--
 .../media/common/videobuf2/videobuf2-v4l2.c   |   4 +-
 drivers/media/dvb-core/dvb_vb2.c              |   2 +-
 include/media/videobuf2-core.h                |  17 +-
 4 files changed, 152 insertions(+), 17 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70ba43c5b3e2..31b86bfa52bd 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -930,6 +930,14 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
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
@@ -1236,6 +1244,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 static int __buf_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	enum vb2_buffer_state orig_state = vb->state;
 	unsigned int plane;
 	int ret;
 
@@ -1263,7 +1272,7 @@ static int __buf_prepare(struct vb2_buffer *vb)
 
 	if (ret) {
 		dprintk(1, "buffer preparation failed: %d\n", ret);
-		vb->state = VB2_BUF_STATE_DEQUEUED;
+		vb->state = orig_state;
 		return ret;
 	}
 
@@ -1276,11 +1285,70 @@ static int __buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
+static int vb2_req_prepare(struct media_request_object *obj)
 {
-	struct vb2_buffer *vb;
+	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
 	int ret;
 
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
+static void vb2_req_cancel(struct media_request_object *obj)
+{
+	/* Nothing to do here, buffers are cancelled in __vb2_queue_cancel() */
+}
+
+static const struct media_request_object_ops vb2_core_req_ops = {
+	.prepare = vb2_req_prepare,
+	.unprepare = vb2_req_unprepare,
+	.queue = vb2_req_queue,
+	.cancel = vb2_req_cancel,
+	.release = vb2_req_release,
+};
+
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
+			 struct media_request *req)
+{
+	struct vb2_buffer *vb;
+
 	vb = q->bufs[index];
 	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 		dprintk(1, "invalid buffer state %d\n",
@@ -1288,16 +1356,36 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 		return -EINVAL;
 	}
 
-	ret = __buf_prepare(vb);
-	if (ret)
-		return ret;
+	if (req) {
+		int ret;
+
+		media_request_object_init(&vb->req_obj);
+		/*
+		 * Note: the bind function checks if the request is in
+		 * IDLE state and returns an error if it isn't. It uses
+		 * the req->lock spinlock and so we do not need to take
+		 * the media_device req_queue_mutex here in order to
+		 * prevent a race condition with the QUEUE ioctl.
+		 */
+		ret = media_request_object_bind(req, &vb2_core_req_ops,
+						q, &vb->req_obj);
+		if (ret)
+			return ret;
+
+		vb->state = VB2_BUF_STATE_IN_REQUEST;
+	} else {
+		int ret = __buf_prepare(vb);
+
+		if (ret)
+			return ret;
+	}
 
 	/* Fill buffer information for the userspace */
 	call_void_bufop(q, fill_user_buffer, vb, pb);
 
 	dprintk(2, "prepare of buffer %d succeeded\n", vb->index);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
@@ -1364,13 +1452,39 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct media_request *req)
 {
 	struct vb2_buffer *vb;
 	int ret;
 
 	vb = q->bufs[index];
 
+	if (vb->state == VB2_BUF_STATE_DEQUEUED && req) {
+		int ret;
+
+		media_request_object_init(&vb->req_obj);
+		/*
+		 * Note: the bind function checks if the request is in
+		 * IDLE state and returns an error if it isn't. It uses
+		 * the req->lock spinlock and so we do not need to take
+		 * the media_device req_queue_mutex here in order to
+		 * prevent a race condition with the QUEUE ioctl.
+		 */
+		ret = media_request_object_bind(req, &vb2_core_req_ops,
+						q, &vb->req_obj);
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
 		ret = __buf_prepare(vb);
@@ -1578,6 +1692,10 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
 			vb->planes[i].dbuf_mapped = 0;
 		}
+	if (vb->req_obj.req) {
+		media_request_object_unbind(&vb->req_obj);
+		media_request_object_put(&vb->req_obj);
+	}
 }
 
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
@@ -1691,6 +1809,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	for (i = 0; i < q->num_buffers; ++i) {
 		struct vb2_buffer *vb = q->bufs[i];
 
+		if (vb->req_obj.req)
+			media_request_cancel(vb->req_obj.req);
+
 		if (vb->state == VB2_BUF_STATE_PREPARED ||
 		    vb->state == VB2_BUF_STATE_QUEUED) {
 			unsigned int plane;
@@ -1700,7 +1821,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 						vb->planes[plane].mem_priv);
 		}
 
-		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		if (vb->state != VB2_BUF_STATE_DEQUEUED &&
+		    vb->state != VB2_BUF_STATE_IN_REQUEST) {
 			vb->state = VB2_BUF_STATE_PREPARED;
 			call_void_vb_qop(vb, buf_finish, vb);
 		}
@@ -2259,7 +2381,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2438,7 +2560,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2541,7 +2663,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index bf7a3ba9fed0..b8d370b97cca 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -544,7 +544,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 
 	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
 
-	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
+	return ret ? ret : vb2_core_prepare_buf(q, b->index, b, NULL);
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
@@ -612,7 +612,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
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
index 3d54654c3cd4..72663c2a3ba3 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -204,6 +204,7 @@ enum vb2_io_modes {
 /**
  * enum vb2_buffer_state - current video buffer state.
  * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control.
+ * @VB2_BUF_STATE_IN_REQUEST:	buffer is queued in media request.
  * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf.
  * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver.
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver.
@@ -218,6 +219,7 @@ enum vb2_io_modes {
  */
 enum vb2_buffer_state {
 	VB2_BUF_STATE_DEQUEUED,
+	VB2_BUF_STATE_IN_REQUEST,
 	VB2_BUF_STATE_PREPARING,
 	VB2_BUF_STATE_PREPARED,
 	VB2_BUF_STATE_QUEUED,
@@ -732,6 +734,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  * @index:	id number of the buffer.
  * @pb:		buffer structure passed from userspace to
  *		&v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
+ * @req:	pointer to &struct media_request, may be NULL.
  *
  * Videobuf2 core helper to implement VIDIOC_PREPARE_BUF() operation. It is
  * called internally by VB2 by an API-specific handler, like
@@ -743,9 +746,13 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  * (if provided), in which driver-specific buffer initialization can
  * be performed.
  *
+ * If @req is non-NULL, then the prepared buffer will be bound to this
+ * media request.
+ *
  * Return: returns zero on success; an error code otherwise.
  */
-int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
+			 struct media_request *req);
 
 /**
  * vb2_core_qbuf() - Queue a buffer from userspace
@@ -754,12 +761,17 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
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
@@ -768,7 +780,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  *
  * Return: returns zero on success; an error code otherwise.
  */
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
+		  struct media_request *req);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
-- 
2.17.0
