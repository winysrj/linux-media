Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35733 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbeAaKZK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:25:10 -0500
Received: by mail-pf0-f195.google.com with SMTP id t12so12152141pfg.2
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:25:10 -0800 (PST)
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
Subject: [RFCv2 03/17] media: videobuf2: add support for requests
Date: Wed, 31 Jan 2018 19:24:21 +0900
Message-Id: <20180131102427.207721-4-acourbot@chromium.org>
In-Reply-To: <20180131102427.207721-1-acourbot@chromium.org>
References: <20180131102427.207721-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make vb2 aware of requests. Drivers can specify whether a given queue
can accept requests or not. Queues that accept requests will block on a
buffer that is part of a request until that request is submitted.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 133 +++++++++++++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c |  28 ++++++-
 include/media/videobuf2-core.h           |  15 +++-
 3 files changed, 168 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index cb115ba6a1d2..4a69ac12ee88 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -26,6 +26,7 @@
 
 #include <media/videobuf2-core.h>
 #include <media/v4l2-mc.h>
+#include <media/media-request.h>
 
 #include <trace/events/vb2.h>
 
@@ -922,6 +923,17 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		vb->state = state;
 	}
 	atomic_dec(&q->owned_by_drv_count);
+	if (vb->request) {
+		struct media_request *req = vb->request;
+
+		if (atomic_dec_and_test(&req->buf_cpt))
+			media_request_complete(vb->request);
+
+		/* release reference acquired during qbuf */
+		vb->request = NULL;
+		media_request_put(req);
+	}
+
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	trace_vb2_buf_done(q, vb);
@@ -1298,6 +1310,53 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+/**
+ * vb2_check_buf_req_status() - Validate request state of a buffer
+ * @vb:		buffer to check
+ *
+ * Returns true if a buffer is ready to be passed to the driver request-wise.
+ * This means that neither this buffer nor any previously-queued buffer is
+ * associated to a request that is not yet submitted.
+ *
+ * If this function returns false, then the buffer shall not be passed to its
+ * driver since the request state is not completely built yet. In that case,
+ * this function will register a notifier to be called when the request is
+ * submitted and the queue can be unblocked.
+ *
+ * This function must be called with req_lock held.
+ */
+static bool vb2_check_buf_req_status(struct vb2_buffer *vb)
+{
+	struct media_request *req = vb->request;
+	struct vb2_queue *q = vb->vb2_queue;
+	int ret = false;
+
+	mutex_lock(&q->req_lock);
+
+	if (!req) {
+		ret = !q->waiting_req;
+		goto done;
+	}
+
+	mutex_lock(&req->lock);
+	if (req->state == MEDIA_REQUEST_STATE_SUBMITTED) {
+		mutex_unlock(&req->lock);
+		ret = !q->waiting_req;
+		goto done;
+	}
+
+	if (!q->waiting_req) {
+		q->waiting_req = true;
+		atomic_notifier_chain_register(&req->submit_notif,
+					       &q->req_blk);
+	}
+	mutex_unlock(&req->lock);
+
+done:
+	mutex_unlock(&q->req_lock);
+	return ret;
+}
+
 /**
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
@@ -1318,8 +1377,11 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	 * If any buffers were queued before streamon,
 	 * we can now pass them to driver for processing.
 	 */
-	list_for_each_entry(vb, &q->queued_list, queued_entry)
+	list_for_each_entry(vb, &q->queued_list, queued_entry) {
+		if (!vb2_check_buf_req_status(vb))
+			break;
 		__enqueue_in_driver(vb);
+	}
 
 	/* Tell the driver to start streaming */
 	q->start_streaming_called = 1;
@@ -1361,7 +1423,46 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+/**
+ * vb2_unblock_requests() - unblock a queue waiting for a request submission
+ * @nb:		notifier block that has been registered
+ * @action:	unused
+ * @data:	request that has been submitted
+ *
+ * This is a callback function that is registered when
+ * vb2_check_buf_req_status() returns false. It is invoked when the request
+ * blocking the queue has been submitted. This means its buffers (and all
+ * following valid buffers) can be passed to drivers.
+ */
+static int vb2_unblock_requests(struct notifier_block *nb, unsigned long action,
+				void *data)
+{
+	struct vb2_queue *q = container_of(nb, struct vb2_queue, req_blk);
+	struct media_request *req = data;
+	struct vb2_buffer *vb;
+	bool found_request = false;
+
+	mutex_lock(&q->req_lock);
+	atomic_notifier_chain_unregister(&req->submit_notif, &q->req_blk);
+	q->waiting_req = false;
+	mutex_unlock(&q->req_lock);
+
+	list_for_each_entry(vb, &q->queued_list, queued_entry) {
+		/* All buffers before our request are already passed to the driver */
+		if (!found_request && vb->request != req)
+			continue;
+		found_request = true;
+
+		if (!vb2_check_buf_req_status(vb))
+			break;
+		__enqueue_in_driver(vb);
+	}
+
+	return 0;
+}
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index,
+		  struct media_request *req, void *pb)
 {
 	struct vb2_buffer *vb;
 	int ret;
@@ -1384,6 +1485,24 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 		return -EINVAL;
 	}
 
+	vb->request = req;
+	if (req) {
+		struct vb2_buffer *_vb;
+
+		/* does the queue support requests? */
+		if (!q->allow_requests)
+			return -EINVAL;
+
+		/* do we already have a buffer for this request in the queue? */
+		list_for_each_entry(_vb, &q->queued_list, queued_entry)
+			if (_vb->request == req)
+				return -EBUSY;
+
+		/* make sure the request stays alive as long as we need */
+		media_request_get(req);
+		atomic_inc(&req->buf_cpt);
+	}
+
 	/*
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
@@ -1402,7 +1521,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	 * If already streaming, give the buffer to driver for processing.
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
-	if (q->start_streaming_called)
+	if (q->start_streaming_called && vb2_check_buf_req_status(vb))
 		__enqueue_in_driver(vb);
 
 	/* Fill buffer information for the userspace */
@@ -1993,6 +2112,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	spin_lock_init(&q->done_lock);
 	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
+	mutex_init(&q->req_lock);
+	q->req_blk.notifier_call = vb2_unblock_requests;
 
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_buffer);
@@ -2242,7 +2363,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		 * Queue all buffers.
 		 */
 		for (i = 0; i < q->num_buffers; i++) {
-			ret = vb2_core_qbuf(q, i, NULL);
+			ret = vb2_core_qbuf(q, i, NULL, NULL);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2421,7 +2542,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 
 		if (copy_timestamp)
 			b->timestamp = ktime_get_ns();
-		ret = vb2_core_qbuf(q, index, NULL);
+		ret = vb2_core_qbuf(q, index, NULL, NULL);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
@@ -2524,7 +2645,7 @@ static int vb2_thread(void *data)
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();;
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, vb->index, NULL);
+			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 0f8edbdebe30..267fe2d669b2 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-common.h>
 
 #include <media/videobuf2-v4l2.h>
+#include <media/media-request.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -561,6 +562,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
+	struct media_request *req = NULL;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -568,8 +570,32 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
+	/*
+	 * The caller should have validated that the request is valid,
+	 * so we just need to look it up without further checking
+	 */
+	if (b->request_fd > 0) {
+		req = media_request_get_from_fd(b->request_fd);
+		if (!req)
+			return -EINVAL;
+
+		mutex_lock(&req->lock);
+		if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+			mutex_unlock(&req->lock);
+			media_request_put(req);
+			return -EINVAL;
+		}
+		mutex_unlock(&req->lock);
+	}
+
 	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	return ret ? ret : vb2_core_qbuf(q, b->index, b);
+	if (!ret)
+		ret = vb2_core_qbuf(q, b->index, req, b);
+
+	if (req)
+		media_request_put(req);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef9b64398c8c..7bb17c842ab4 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -237,6 +237,7 @@ struct vb2_queue;
  *			on an internal driver queue
  * @planes:		private per-plane information; do not change
  * @timestamp:		frame timestamp in ns
+ * @request:		request the buffer belongs to, if any
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -246,6 +247,7 @@ struct vb2_buffer {
 	unsigned int		num_planes;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 	u64			timestamp;
+	struct media_request	*request;
 
 	/* private: internal use only
 	 *
@@ -443,6 +445,7 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @allow_requests:	whether requests are supported on this queue.
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -500,6 +503,9 @@ struct vb2_buf_ops {
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
+ * @req_lock:	protects req_blk and waiting_req
+ * @req_blk:	notifier to be called when waiting for a request to be submitted
+ * @waiting_req:whether this queue is currently waiting on a request submission
  */
 struct vb2_queue {
 	unsigned int			type;
@@ -511,6 +517,7 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			allow_requests:1;
 
 	struct mutex			*lock;
 	void				*owner;
@@ -554,6 +561,10 @@ struct vb2_queue {
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
 
+	struct mutex			req_lock;
+	struct notifier_block		req_blk;
+	bool				waiting_req;
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these queue-related ops are
@@ -724,6 +735,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  *
  * @q:		videobuf2 queue
  * @index:	id number of the buffer
+ * @req:	request this buffer belongs to, if any
  * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
  *		in driver
  *
@@ -740,7 +752,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index,
+		  struct media_request *req, void *pb);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
-- 
2.16.0.rc1.238.g530d649a79-goog
