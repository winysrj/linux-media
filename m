Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56583 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751325AbeCIXtZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 18:49:25 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org
Subject: [RFC 8/8] vb2: Add support for requests
Date: Sat, 10 Mar 2018 01:48:52 +0200
Message-Id: <1520639332-19190-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Associate a buffer to a request when it is queued and disassociate when it
is done.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 43 ++++++++++++++++++++++++-
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 24 +++++++++++++-
 include/media/videobuf2-core.h                  | 19 +++++++++++
 include/media/videobuf2-v4l2.h                  |  2 ++
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3f7bb3..0e8d555 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -346,6 +346,9 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			break;
 		}
 
+		if (q->class)
+			media_request_object_init(q->class, &vb->req_obj);
+
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
 		vb->num_planes = num_planes;
@@ -520,7 +523,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	/* Free videobuf buffers */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		kfree(q->bufs[buffer]);
+		if (q->class)
+			media_request_object_put(&q->bufs[buffer]->req_obj);
+		else
+			kfree(q->bufs[buffer]);
 		q->bufs[buffer] = NULL;
 	}
 
@@ -944,6 +950,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	default:
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
+		if (vb->req_ref) {
+			media_request_ref_complete(vb->req_ref);
+			vb->req_ref = NULL;
+		}
 		break;
 	}
 }
@@ -1249,6 +1259,32 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 		return -EIO;
 	}
 
+	if (vb->request_fd) {
+		struct media_device_request *req;
+		struct media_request_ref *ref;
+
+		if (!q->class) {
+			dprintk(1, "requests not enabled for the queue\n");
+			return -EINVAL;
+		}
+
+		req = media_device_request_find(q->class->mdev, vb->request_fd);
+		if (IS_ERR(req)) {
+			dprintk(1, "no request found for fd %d (%ld)\n",
+				vb->request_fd, PTR_ERR(req));
+			return PTR_ERR(req);
+		}
+
+		ref = media_request_object_bind(req,
+						&q->bufs[vb->index]->req_obj);
+		media_device_request_put(req);
+
+		if (IS_ERR(ref))
+			return PTR_ERR(ref);
+
+		vb->req_ref = ref;
+	}
+
 	vb->state = VB2_BUF_STATE_PREPARING;
 
 	switch (q->memory) {
@@ -1269,6 +1305,8 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 	if (ret) {
 		dprintk(1, "buffer preparation failed: %d\n", ret);
 		vb->state = VB2_BUF_STATE_DEQUEUED;
+		media_request_ref_unbind(vb->req_ref);
+		vb->req_ref = NULL;
 		return ret;
 	}
 
@@ -2037,6 +2075,9 @@ void vb2_core_queue_release(struct vb2_queue *q)
 	mutex_lock(&q->mmap_lock);
 	__vb2_queue_free(q, q->num_buffers);
 	mutex_unlock(&q->mmap_lock);
+	media_request_class_unregister(q->class);
+	kfree(q->class);
+	q->class = NULL;
 }
 EXPORT_SYMBOL_GPL(vb2_core_queue_release);
 
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 6d4d184..ca36109 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -196,6 +196,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->index = vb->index;
 	b->type = vb->type;
 	b->memory = vb->memory;
+	b->request_fd = vb->request_fd;
 	b->bytesused = 0;
 
 	b->flags = vbuf->flags;
@@ -203,7 +204,6 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->request_fd = 0;
 	b->reserved = 0;
 
 	if (q->is_multiplanar) {
@@ -319,6 +319,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 		return -EINVAL;
 	}
 	vb->timestamp = 0;
+	vb->request_fd = b->request_fd;
 	vbuf->sequence = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
@@ -667,6 +668,27 @@ int vb2_queue_init(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
+void vb2_media_req_class_release(struct media_request_object *obj)
+{
+	struct vb2_v4l2_buffer *vbuf =
+		to_vb2_v4l2_buffer(media_request_object_to_vb2_buffer(obj));
+
+	kfree(vbuf);
+}
+
+int vb2_queue_allow_requests(struct vb2_queue *q, struct media_device *mdev)
+{
+	q->class = kzalloc(sizeof(*q->class), GFP_KERNEL);
+	if (!q->class)
+		return -ENOMEM;
+
+	media_request_class_register(mdev, q->class,
+				     vb2_media_req_class_release, true);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_queue_allow_requests);
+
 void vb2_queue_release(struct vb2_queue *q)
 {
 	vb2_core_queue_release(q);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5b6c541..7aab811 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -18,6 +18,8 @@
 #include <linux/dma-buf.h>
 #include <linux/bitops.h>
 
+#include <media/media-request.h>
+
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
 
@@ -42,6 +44,8 @@ enum vb2_memory {
 	VB2_MEMORY_DMABUF	= 4,
 };
 
+struct media_request_class;
+struct media_request_ref;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
 
@@ -255,12 +259,19 @@ struct vb2_buffer {
 	 * done_entry:		entry on the list that stores all buffers ready
 	 *			to be dequeued to userspace
 	 * vb2_plane:		per-plane information; do not change
+	 * req_obj:		media request object
+	 * req_ref:		media request reference (stored between qbuf --
+	 *			dqbuf)
+	 * request_fd		file descriptor of the request
 	 */
 	enum vb2_buffer_state	state;
 
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
+	struct media_request_object req_obj;
+	struct media_request_ref *req_ref;
+	int			request_fd;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -293,6 +304,12 @@ struct vb2_buffer {
 #endif
 };
 
+static inline struct vb2_buffer *
+media_request_object_to_vb2_buffer(struct media_request_object *obj)
+{
+	return container_of(obj, struct vb2_buffer, req_obj);
+}
+
 /**
  * struct vb2_ops - driver-specific callbacks.
  *
@@ -502,6 +519,7 @@ struct vb2_buf_ops {
  *		when a buffer with the %V4L2_BUF_FLAG_LAST is dequeued.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
+ * @req_class:	The media request class for buffers in this queue
  */
 struct vb2_queue {
 	unsigned int			type;
@@ -555,6 +573,7 @@ struct vb2_queue {
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
+	struct media_request_class	*class;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 3d5e2d7..5d20e2e 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -32,6 +32,7 @@
  *		&enum v4l2_field.
  * @timecode:	frame timecode.
  * @sequence:	sequence count of this frame.
+ * @request:	request used by the buffer
  *
  * Should contain enough information to be able to cover all the fields
  * of &struct v4l2_buffer at ``videodev2.h``.
@@ -43,6 +44,7 @@ struct vb2_v4l2_buffer {
 	__u32			field;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
+	__u32			request;
 };
 
 /*
-- 
2.7.4
