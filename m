Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4000 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaITI4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 04:56:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, m.chehab@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] vb2: fix VBI/poll regression
Date: Sat, 20 Sep 2014 10:56:13 +0200
Message-Id: <1411203375-15310-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The recent conversion of saa7134 to vb2 unconvered a poll() bug that
broke the teletext applications alevt and mtt. These applications
expect that calling poll() without having called VIDIOC_STREAMON will
cause poll() to return POLLERR. That did not happen in vb2.

This patch fixes that behavior. It also fixes what should happen when
poll() is called when STREAMON is called but no buffers have been
queued. In that case poll() will also return POLLERR, but only for
capture queues since output queues will always return POLLOUT
anyway in that situation.

This brings the vb2 behavior in line with the old videobuf behavior.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 15 ++++++++++++---
 include/media/videobuf2-core.h           |  4 ++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7e6aff6..f3762a8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -977,6 +977,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * to the userspace.
 	 */
 	req->count = allocated_buffers;
+	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
 
 	return 0;
 }
@@ -1801,6 +1802,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 */
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
+	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		/*
@@ -2583,10 +2585,17 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 
 	/*
-	 * There is nothing to wait for if no buffer has been queued and the
-	 * queue isn't streaming, or if the error flag is set.
+	 * There is nothing to wait for if the queue isn't streaming, or if the
+	 * error flag is set.
 	 */
-	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
+	if (!vb2_is_streaming(q) || q->error)
+		return res | POLLERR;
+	/*
+	 * For compatibility with vb1: if QBUF hasn't been called yet, then
+	 * return POLLERR as well. This only affects capture queues, output
+	 * queues will always initialize waiting_for_buffers to false.
+	 */
+	if (q->waiting_for_buffers)
 		return res | POLLERR;
 
 	/*
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5a10d8d..84f790c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -381,6 +381,9 @@ struct v4l2_fh;
  * @start_streaming_called: start_streaming() was called successfully and we
  *		started streaming.
  * @error:	a fatal error occurred on the queue
+ * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
+ *		buffers. Only set for capture queues if qbuf has not yet been
+ *		called since poll() needs to return POLLERR in that situation.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -419,6 +422,7 @@ struct vb2_queue {
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
+	unsigned int			waiting_for_buffers:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
-- 
2.1.0

