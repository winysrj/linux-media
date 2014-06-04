Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55956 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaFDOFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 10:05:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH/RFC 2/2] v4l: vb2: Add fatal error condition flag
Date: Wed,  4 Jun 2014 16:05:44 +0200
Message-Id: <1401890744-22683-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401890744-22683-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401890744-22683-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a fatal error occurs that render the device unusable, the only
options for a driver to signal the error condition to userspace is to
set the V4L2_BUF_FLAG_ERROR flag when dequeuing buffers and to return an
error from the buffer prepare handler when queuing buffers.

The buffer error flag indicates a transient error and can't be used by
applications to detect fatal errors. Returning an error from vb2_qbuf()
is thus the only real indication that a fatal error occured. However,
this is difficult to handle for multithreaded applications that requeue
buffers from a thread other than the control thread. In particular the
poll() call in the control thread will not notify userspace of the
error.

This patch adds an explicit mechanism to report fatal errors to
userspace. Applications can call the vb2_queue_error() function to
signal a fatal error. From this moment on, buffer preparation will
return -EIO to userspace, and vb2_poll() will set the POLLERR flag and
return immediately. The error flag is cleared when cancelling the queue,
either at stream off time (through vb2_streamoff) or when releasing the
queue with vb2_queue_release().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-core.c | 41 +++++++++++++++++++++++++++++++++---
 include/media/videobuf2-core.h       |  3 +++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 5f38774..76e3456 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1295,6 +1295,12 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		call_qop(q, wait_finish, q);
 	}
 
+	if (q->error) {
+		dprintk(1, "qbuf: fatal error occured on queue\n");
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (q->fileio) {
 		dprintk(1, "qbuf: file io in progress\n");
 		ret = -EBUSY;
@@ -1393,6 +1399,11 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 			return -EINVAL;
 		}
 
+		if (q->error) {
+			dprintk(1, "Queue in error state, will not wait for buffers\n");
+			return -EIO;
+		}
+
 		if (!list_empty(&q->done_list)) {
 			/*
 			 * Found a buffer that we were waiting for.
@@ -1418,7 +1429,8 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 */
 		dprintk(3, "Will sleep waiting for buffers\n");
 		ret = wait_event_interruptible(q->done_wq,
-				!list_empty(&q->done_list) || !q->streaming);
+				!list_empty(&q->done_list) || !q->streaming ||
+				q->error);
 
 		/*
 		 * We need to reevaluate both conditions again after reacquiring
@@ -1602,6 +1614,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	if (q->streaming)
 		call_qop(q, stop_streaming, q);
 	q->streaming = 0;
+	q->error = 0;
 
 	/*
 	 * Remove all buffers from videobuf's list...
@@ -1623,6 +1636,27 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 }
 
 /**
+ * vb2_queue_error() - signal a fatal error on the queue
+ * @q:		videobuf2 queue
+ *
+ * Flag that a fatal unrecoverable error occured and wake up all processes
+ * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
+ * buffers will return -EIO.
+ *
+ * The error flag will be cleared when cancelling the queue, either from
+ * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
+ * function before starting the stream, otherwise the error flag will remain set
+ * until the queue is released when closing the device node.
+ */
+void vb2_queue_error(struct vb2_queue *q)
+{
+	q->error = 1;
+
+	wake_up_all(&q->done_wq);
+}
+EXPORT_SYMBOL_GPL(vb2_queue_error);
+
+/**
  * vb2_streamon - start streaming
  * @q:		videobuf2 queue
  * @type:	type argument passed from userspace to vidioc_streamon handler
@@ -1984,9 +2018,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 
 	/*
-	 * There is nothing to wait for if the queue isn't streaming.
+	 * There is nothing to wait for if the queue isn't streaming or if the
+	 * error flag is set.
 	 */
-	if (!vb2_is_streaming(q))
+	if (!vb2_is_streaming(q) || q->error)
 		return res | POLLERR;
 
 	poll_wait(file, &q->done_wq, wait);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d173206..352e6ca 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -302,6 +302,7 @@ struct vb2_ops {
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
  * @alloc_ctx:	memory type/allocator-specific contexts for each plane
  * @streaming:	current streaming state
+ * @error:	a fatal error occured on the queue
  * @fileio:	file io emulator internal data, used only if emulator is active
  */
 struct vb2_queue {
@@ -330,6 +331,7 @@ struct vb2_queue {
 	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
 
 	unsigned int			streaming:1;
+	unsigned int			error:1;
 
 	struct vb2_fileio_data		*fileio;
 };
@@ -349,6 +351,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 int __must_check vb2_queue_init(struct vb2_queue *q);
 
 void vb2_queue_release(struct vb2_queue *q);
+void vb2_queue_error(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
-- 
1.8.5.5

