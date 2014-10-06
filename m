Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1251 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFHQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 03:16:52 -0400
Message-ID: <543241DE.6090507@xs4all.nl>
Date: Mon, 06 Oct 2014 09:16:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] media/vb2: fix VBI/poll regression
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a backport of mainline commit 58d75f4b1ce26324b4d809b18f94819843a98731
for kernels 3.15 and 3.16. 

The recent conversion of saa7134 to vb2 uncovered a poll() bug that
broke the teletext applications alevt and mtt. These applications
expect that calling poll() without having called VIDIOC_STREAMON will
cause poll() to return POLLERR. That did not happen in vb2.

This patch fixes that behavior. It also fixes what should happen when
poll() is called when STREAMON is called but no buffers have been
queued. In that case poll() will also return POLLERR.

This brings the vb2 behavior in line with the old videobuf behavior.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..ad4dd2d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -967,6 +967,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * to the userspace.
 	 */
 	req->count = allocated_buffers;
+	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
 
 	return 0;
 }
@@ -1014,6 +1015,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 		q->memory = create->memory;
+		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
 	}
 
 	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
@@ -1807,6 +1809,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 */
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
+	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		/*
@@ -2239,6 +2242,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	 * their normal dequeued state.
 	 */
 	__vb2_queue_cancel(q);
+	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
 
 	dprintk(3, "successful\n");
 	return 0;
@@ -2557,9 +2561,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 
 	/*
-	 * There is nothing to wait for if no buffers have already been queued.
+	 * There is nothing to wait for if the queue isn't streaming.
 	 */
-	if (list_empty(&q->queued_list))
+	if (!vb2_is_streaming(q))
+		return res | POLLERR;
+	/*
+	 * For compatibility with vb1: if QBUF hasn't been called yet, then
+	 * return POLLERR as well. This only affects capture queues, output
+	 * queues will always initialize waiting_for_buffers to false.
+	 */
+	if (q->waiting_for_buffers)
 		return res | POLLERR;
 
 	if (list_empty(&q->done_list))
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8fab6fa..d6f010c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -375,6 +375,9 @@ struct v4l2_fh;
  * @streaming:	current streaming state
  * @start_streaming_called: start_streaming() was called successfully and we
  *		started streaming.
+ * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
+ *		buffers. Only set for capture queues if qbuf has not yet been
+ *		called since poll() needs to return POLLERR in that situation.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -411,6 +414,7 @@ struct vb2_queue {
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
+	unsigned int			waiting_for_buffers:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;

