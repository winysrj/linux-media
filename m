Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:58994 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760389AbbKTQed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:34:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv10 05/15] media: videobuf2: Separate vb2_poll()
Date: Fri, 20 Nov 2015 17:34:08 +0100
Message-Id: <1448037258-36305-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

Separate vb2_poll() into core and v4l2 part.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 93 ++++++++++++++++++++------------
 1 file changed, 59 insertions(+), 34 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index e03f700..a6945ee 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -783,7 +783,7 @@ void vb2_queue_release(struct vb2_queue *q)
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
 /**
- * vb2_poll() - implements poll userspace operation
+ * vb2_core_poll() - implements poll userspace operation
  * @q:		videobuf2 queue
  * @file:	file argument passed to the poll file operation handler
  * @wait:	wait argument passed to the poll file operation handler
@@ -795,33 +795,20 @@ EXPORT_SYMBOL_GPL(vb2_queue_release);
  * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
  * will be reported as available for writing.
  *
- * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
- * pending events.
- *
  * The return values from this function are intended to be directly returned
  * from poll handler in driver.
  */
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
+unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
+		poll_table *wait)
 {
-	struct video_device *vfd = video_devdata(file);
 	unsigned long req_events = poll_requested_events(wait);
 	struct vb2_buffer *vb = NULL;
-	unsigned int res = 0;
 	unsigned long flags;
 
-	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
-		struct v4l2_fh *fh = file->private_data;
-
-		if (v4l2_event_pending(fh))
-			res = POLLPRI;
-		else if (req_events & POLLPRI)
-			poll_wait(file, &fh->wait, wait);
-	}
-
 	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
-		return res;
+		return 0;
 	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
-		return res;
+		return 0;
 
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
@@ -830,16 +817,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 		if (!q->is_output && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM))) {
 			if (__vb2_init_fileio(q, 1))
-				return res | POLLERR;
+				return POLLERR;
 		}
 		if (q->is_output && (q->io_modes & VB2_WRITE) &&
 				(req_events & (POLLOUT | POLLWRNORM))) {
 			if (__vb2_init_fileio(q, 0))
-				return res | POLLERR;
+				return POLLERR;
 			/*
 			 * Write to OUTPUT queue can be done immediately.
 			 */
-			return res | POLLOUT | POLLWRNORM;
+			return POLLOUT | POLLWRNORM;
 		}
 	}
 
@@ -848,21 +835,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * error flag is set.
 	 */
 	if (!vb2_is_streaming(q) || q->error)
-		return res | POLLERR;
-	/*
-	 * For compatibility with vb1: if QBUF hasn't been called yet, then
-	 * return POLLERR as well. This only affects capture queues, output
-	 * queues will always initialize waiting_for_buffers to false.
-	 */
-	if (q->waiting_for_buffers)
-		return res | POLLERR;
+		return POLLERR;
 
 	/*
 	 * For output streams you can call write() as long as there are fewer
 	 * buffers queued than there are buffers available.
 	 */
 	if (q->is_output && q->fileio && q->queued_count < q->num_buffers)
-		return res | POLLOUT | POLLWRNORM;
+		return POLLOUT | POLLWRNORM;
 
 	if (list_empty(&q->done_list)) {
 		/*
@@ -870,7 +850,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 		 * return immediately. DQBUF will return -EPIPE.
 		 */
 		if (q->last_buffer_dequeued)
-			return res | POLLIN | POLLRDNORM;
+			return POLLIN | POLLRDNORM;
 
 		poll_wait(file, &q->done_wq, wait);
 	}
@@ -887,10 +867,55 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if (vb && (vb->state == VB2_BUF_STATE_DONE
 			|| vb->state == VB2_BUF_STATE_ERROR)) {
 		return (q->is_output) ?
-				res | POLLOUT | POLLWRNORM :
-				res | POLLIN | POLLRDNORM;
+				POLLOUT | POLLWRNORM :
+				POLLIN | POLLRDNORM;
 	}
-	return res;
+	return 0;
+}
+
+/**
+ * vb2_poll() - implements poll userspace operation
+ * @q:		videobuf2 queue
+ * @file:	file argument passed to the poll file operation handler
+ * @wait:	wait argument passed to the poll file operation handler
+ *
+ * This function implements poll file operation handler for a driver.
+ * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
+ * be informed that the file descriptor of a video device is available for
+ * reading.
+ * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
+ * will be reported as available for writing.
+ *
+ * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
+ * pending events.
+ *
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
+ */
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
+{
+	struct video_device *vfd = video_devdata(file);
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned int res = 0;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
+
+		if (v4l2_event_pending(fh))
+			res = POLLPRI;
+		else if (req_events & POLLPRI)
+			poll_wait(file, &fh->wait, wait);
+	}
+
+	/*
+	 * For compatibility with vb1: if QBUF hasn't been called yet, then
+	 * return POLLERR as well. This only affects capture queues, output
+	 * queues will always initialize waiting_for_buffers to false.
+	 */
+	if (q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
+		return POLLERR;
+
+	return res | vb2_core_poll(q, file, wait);
 }
 EXPORT_SYMBOL_GPL(vb2_poll);
 
-- 
2.6.2

