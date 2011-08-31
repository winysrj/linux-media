Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab1HaSCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:02:52 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/9 v6] V4L: add a new videobuf2 buffer state VB2_BUF_STATE_PREPARED
Date: Wed, 31 Aug 2011 20:02:40 +0200
Message-Id: <1314813768-27752-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch prepares for a better separation of the buffer preparation
stage.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---

v6: as reported by Pawel: the VB2_BUF_STATE_PREPARED state has to actually be
    set

 drivers/media/video/videobuf2-core.c |   61 +++++++++++++++++++++------------
 include/media/videobuf2-core.h       |    2 +
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 3015e60..4153da2 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -333,6 +333,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		b->flags |= V4L2_BUF_FLAG_DONE;
 		break;
 	case VB2_BUF_STATE_DEQUEUED:
+	case VB2_BUF_STATE_PREPARED:
 		/* nothing */
 		break;
 	}
@@ -817,6 +818,33 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	q->ops->buf_queue(vb);
 }
 
+static int __buf_prepare(struct vb2_buffer *vb, struct v4l2_buffer *b)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	int ret;
+
+	switch (q->memory) {
+	case V4L2_MEMORY_MMAP:
+		ret = __qbuf_mmap(vb, b);
+		break;
+	case V4L2_MEMORY_USERPTR:
+		ret = __qbuf_userptr(vb, b);
+		break;
+	default:
+		WARN(1, "Invalid queue type\n");
+		ret = -EINVAL;
+	}
+
+	if (!ret)
+		ret = call_qop(q, buf_prepare, vb);
+	if (ret)
+		dprintk(1, "qbuf: buffer preparation failed: %d\n", ret);
+	else
+		vb->state = VB2_BUF_STATE_PREPARED;
+
+	return ret;
+}
+
 /**
  * vb2_qbuf() - Queue a buffer from userspace
  * @q:		videobuf2 queue
@@ -826,8 +854,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
  * Should be called from vidioc_qbuf ioctl handler of a driver.
  * This function:
  * 1) verifies the passed buffer,
- * 2) calls buf_prepare callback in the driver (if provided), in which
- *    driver-specific buffer initialization can be performed,
+ * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
  * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
  *    callback for processing.
  *
@@ -837,7 +865,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	struct vb2_buffer *vb;
-	int ret = 0;
+	int ret;
 
 	if (q->fileio) {
 		dprintk(1, "qbuf: file io in progress\n");
@@ -866,29 +894,18 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EINVAL;
 	}
 
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+	switch (vb->state) {
+	case VB2_BUF_STATE_DEQUEUED:
+		ret = __buf_prepare(vb, b);
+		if (ret)
+			return ret;
+	case VB2_BUF_STATE_PREPARED:
+		break;
+	default:
 		dprintk(1, "qbuf: buffer already in use\n");
 		return -EINVAL;
 	}
 
-	if (q->memory == V4L2_MEMORY_MMAP)
-		ret = __qbuf_mmap(vb, b);
-	else if (q->memory == V4L2_MEMORY_USERPTR)
-		ret = __qbuf_userptr(vb, b);
-	else {
-		WARN(1, "Invalid queue type\n");
-		return -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	ret = call_qop(q, buf_prepare, vb);
-	if (ret) {
-		dprintk(1, "qbuf: buffer preparation failed\n");
-		return ret;
-	}
-
 	/*
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f87472a..65946c5 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -106,6 +106,7 @@ enum vb2_fileio_flags {
 /**
  * enum vb2_buffer_state - current video buffer state
  * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
+ * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
  * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
  *				in a hardware operation
@@ -117,6 +118,7 @@ enum vb2_fileio_flags {
  */
 enum vb2_buffer_state {
 	VB2_BUF_STATE_DEQUEUED,
+	VB2_BUF_STATE_PREPARED,
 	VB2_BUF_STATE_QUEUED,
 	VB2_BUF_STATE_ACTIVE,
 	VB2_BUF_STATE_DONE,
-- 
1.7.2.5

