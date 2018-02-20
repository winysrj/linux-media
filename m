Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35973 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbeBTEpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:19 -0500
Received: by mail-pg0-f66.google.com with SMTP id j9so6711612pgv.3
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:19 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 13/21] media: videobuf2-v4l2: support for requests
Date: Tue, 20 Feb 2018 13:44:17 +0900
Message-Id: <20180220044425.169493-14-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new vb2_qbuf_request() (a request-aware version of vb2_qbuf())
that request-aware drivers can call to queue a buffer into a request
instead of directly into the vb2 queue if relevent.

This function expects that drivers invoking it are using instances of
v4l2_request_entity and v4l2_request_entity_data to describe their
entity and entity data respectively.

Also add the vb2_request_submit() helper function which drivers can
invoke in order to queue all the buffers previously queued into a
request into the regular vb2 queue.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 129 +++++++++++++++++-
 include/media/videobuf2-v4l2.h                |  59 ++++++++
 2 files changed, 187 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 6d4d184aa68e..0627c3339572 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -28,8 +28,11 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-request.h>
 
 #include <media/videobuf2-v4l2.h>
+#include <media/media-request.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -569,11 +572,131 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
+	/* drivers supporting requests must call vb2_qbuf_request instead */
+	if (b->request_fd > 0) {
+		dprintk(1, "invalid call to vb2_qbuf with request_fd set\n");
+		return -EINVAL;
+	}
+
 	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
 	return ret ? ret : vb2_core_qbuf(q, b->index, b);
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
+#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
+int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
+		     struct media_request_entity *entity)
+{
+	struct v4l2_request_entity_data *data;
+	struct v4l2_vb2_request_buffer *qb;
+	struct media_request *req;
+	struct vb2_buffer *vb;
+	int ret = 0;
+
+	if (b->request_fd <= 0)
+		return vb2_qbuf(q, b);
+
+	if (!q->allow_requests)
+		return -EINVAL;
+
+	req = media_request_get_from_fd(b->request_fd);
+	if (!req)
+		return -EINVAL;
+
+	data = to_v4l2_entity_data(media_request_get_entity_data(req, entity));
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
+		goto out;
+	}
+
+	mutex_lock(&req->lock);
+
+	if (req->state != MEDIA_REQUEST_STATE_IDLE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+	if (ret)
+		goto out;
+
+	vb = q->bufs[b->index];
+	switch (vb->state) {
+	case VB2_BUF_STATE_DEQUEUED:
+		break;
+	case VB2_BUF_STATE_PREPARED:
+		break;
+	case VB2_BUF_STATE_PREPARING:
+		dprintk(1, "buffer still being prepared\n");
+		ret = -EINVAL;
+		goto out;
+	default:
+		dprintk(1, "invalid buffer state %d\n", vb->state);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* do we already have a buffer for this request in the queue? */
+	list_for_each_entry(qb, &data->queued_buffers, node) {
+		if (qb->queue == q) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
+	qb = kzalloc(sizeof(*qb), GFP_KERNEL);
+	if (!qb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * TODO should be prepare the buffer here if needed, to report errors
+	 * early?
+	 */
+	qb->pre_req_state = vb->state;
+	qb->queue = q;
+	memcpy(&qb->v4l2_buf, b, sizeof(*b));
+	vb->request = req;
+	vb->state = VB2_BUF_STATE_QUEUED;
+	list_add_tail(&qb->node, &data->queued_buffers);
+
+out:
+	mutex_unlock(&req->lock);
+	media_request_put(req);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vb2_qbuf_request);
+
+int vb2_request_submit(struct v4l2_request_entity_data *data)
+{
+	struct v4l2_vb2_request_buffer *qb, *n;
+
+	/* v4l2 requests require at least one buffer to reach the device */
+	if (list_empty(&data->queued_buffers)) {
+		return -EINVAL;
+	}
+
+	list_for_each_entry_safe(qb, n, &data->queued_buffers, node) {
+		struct vb2_queue *q = qb->queue;
+		struct vb2_buffer *vb = q->bufs[qb->v4l2_buf.index];
+		int ret;
+
+		list_del(&qb->node);
+		vb->state = qb->pre_req_state;
+		ret = vb2_core_qbuf(q, vb->index, &qb->v4l2_buf);
+		kfree(qb);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_request_submit);
+
+#endif /* CONFIG_MEDIA_REQUEST_API */
+
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	int ret;
@@ -776,10 +899,14 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
 int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct v4l2_fh *fh = NULL;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags))
+		fh = file->private_data;
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_qbuf(vdev->queue, p);
+	return vb2_qbuf_request(vdev->queue, p, fh ? fh->entity : NULL);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
 
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 3d5e2d739f05..d4dfa266a0da 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -23,6 +23,12 @@
 #error VB2_MAX_PLANES != VIDEO_MAX_PLANES
 #endif
 
+struct media_entity;
+struct v4l2_fh;
+struct media_request;
+struct media_request_entity;
+struct v4l2_request_entity_data;
+
 /**
  * struct vb2_v4l2_buffer - video buffer information for v4l2.
  *
@@ -116,6 +122,59 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
+#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
+
+/**
+ * vb2_qbuf_request() - Queue a buffer, with request support
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @b:		buffer structure passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_qbuf handler in driver
+ * @entity:	request entity to queue for if requests are used.
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_qbuf handler of a driver.
+ *
+ * If requests are not in use, calling this is equivalent to calling vb2_qbuf().
+ *
+ * If the request_fd member of b is set, then the buffer represented by b is
+ * queued in the request instead of the vb2 queue. The buffer will be passed
+ * to the vb2 queue when the request is submitted.
+ *
+ * The return values from this function are intended to be directly returned
+ * from &v4l2_ioctl_ops->vidioc_qbuf handler in driver.
+ */
+int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
+		     struct media_request_entity *entity);
+
+/**
+ * vb2_request_submit() - Queue all the buffers in a v4l2 request.
+ * @data:	request entity data to queue buffers of
+ *
+ * This function should be called from the media_request_entity_ops::submit
+ * hook for instances of media_request_v4l2_entity_data. It will immediately
+ * queue all the request-bound buffers to their respective vb2 queues.
+ *
+ * Errors from vb2_core_qbuf() are returned if something happened. Also, since
+ * v4l2 request entities require at least one buffer for the request to trigger,
+ * this function will return -EINVAL if no buffer have been bound at all for
+ * this entity.
+ */
+int vb2_request_submit(struct v4l2_request_entity_data *data);
+
+#else /* CONFIG_MEDIA_REQUEST_API */
+
+static inline int vb2_qbuf_request(struct vb2_queue *q, struct v4l2_buffer *b,
+				   struct media_request_entity *entity)
+{
+	return vb2_qbuf(q, b);
+}
+
+static inline int vb2_request_submit(struct v4l2_request_entity_data *data)
+{
+	return -ENOTSUPP;
+}
+
+#endif /* CONFIG_MEDIA_REQUEST_API */
+
 /**
  * vb2_expbuf() - Export a buffer as a file descriptor
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
-- 
2.16.1.291.g4437f3f132-goog
