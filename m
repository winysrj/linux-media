Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4100 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3LEIWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 03:22:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 02/10] vb2: simplify qbuf/prepare_buf by removing callback.
Date: Thu,  5 Dec 2013 09:21:41 +0100
Message-Id: <1386231709-14262-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386231709-14262-1-git-send-email-hverkuil@xs4all.nl>
References: <1386231709-14262-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The callback used to merge the common code of the qbuf/prepare_buf
code can be removed now that the mmap_sem handling is pushed down to
__buf_prepare(). This makes the code more readable.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 118 +++++++++++++++----------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 634dc95..1754d3f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1262,14 +1262,8 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 }
 
 static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname,
-				    int (*handler)(struct vb2_queue *,
-						   struct v4l2_buffer *,
-						   struct vb2_buffer *))
+				    const char *opname)
 {
-	struct vb2_buffer *vb;
-	int ret;
-
 	if (q->fileio) {
 		dprintk(1, "%s(): file io in progress\n", opname);
 		return -EBUSY;
@@ -1285,8 +1279,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}
 
-	vb = q->bufs[b->index];
-	if (NULL == vb) {
+	if (q->bufs[b->index] == NULL) {
 		/* Should never happen */
 		dprintk(1, "%s(): buffer is NULL\n", opname);
 		return -EINVAL;
@@ -1297,30 +1290,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}
 
-	ret = __verify_planes_array(vb, b);
-	if (ret)
-		return ret;
-
-	ret = handler(q, b, vb);
-	if (!ret) {
-		/* Fill buffer information for the userspace */
-		__fill_v4l2_buffer(vb, b);
-
-		dprintk(1, "%s() of buffer %d succeeded\n", opname, vb->v4l2_buf.index);
-	}
-	return ret;
-}
-
-static int __vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-			     struct vb2_buffer *vb)
-{
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
-			vb->state);
-		return -EINVAL;
-	}
-
-	return __buf_prepare(vb, b);
+	return __verify_planes_array(q->bufs[b->index], b);
 }
 
 /**
@@ -1340,20 +1310,68 @@ static int __vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	return vb2_queue_or_prepare_buf(q, b, "prepare_buf", __vb2_prepare_buf);
+	int ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
+	struct vb2_buffer *vb;
+
+	if (ret)
+		return ret;
+
+	vb = q->bufs[b->index];
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
+			vb->state);
+		return -EINVAL;
+	}
+
+	ret = __buf_prepare(vb, b);
+	if (!ret) {
+		/* Fill buffer information for the userspace */
+		__fill_v4l2_buffer(vb, b);
+
+		dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb->v4l2_buf.index);
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
-static int __vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b,
-		      struct vb2_buffer *vb)
+/**
+ * vb2_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
+ * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	int ret;
+	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+	struct vb2_buffer *vb;
+
+	if (ret)
+		return ret;
+
+	vb = q->bufs[b->index];
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
+			vb->state);
+		return -EINVAL;
+	}
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
 		ret = __buf_prepare(vb, b);
 		if (ret)
 			return ret;
+		break;
 	case VB2_BUF_STATE_PREPARED:
 		break;
 	case VB2_BUF_STATE_PREPARING:
@@ -1378,29 +1396,11 @@ static int __vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 	if (q->streaming)
 		__enqueue_in_driver(vb);
 
-	return 0;
-}
+	/* Fill buffer information for the userspace */
+	__fill_v4l2_buffer(vb, b);
 
-/**
- * vb2_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_qbuf handler
- *		in driver
- *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
- */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	return vb2_queue_or_prepare_buf(q, b, "qbuf", __vb2_qbuf);
+	dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb->v4l2_buf.index);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
-- 
1.8.4.3

