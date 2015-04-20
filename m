Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39630 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbbDTI21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 04:28:27 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 3/5] [media] videobuf2: return -EPIPE from DQBUF after the last buffer
Date: Mon, 20 Apr 2015 10:28:22 +0200
Message-Id: <1429518504-14880-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1429518504-14880-1-git-send-email-p.zabel@pengutronix.de>
References: <1429518504-14880-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the last buffer was dequeued from a capture queue, let poll return
immediately and let DQBUF return -EPIPE to signal there will no more
buffers to dequeue until STREAMOFF.
The driver signals the last buffer by setting the V4L2_BUF_FLAG_LAST.
To reenable dequeuing on the capture queue, the driver must explicitly
call vb2_clear_last_buffer_queued. The last buffer queued flag is
cleared automatically during STREAMOFF.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v4:
 - Split out DocBook changes into a separate patch.
 - Documented last_buffer_dequeued flag in vb2_queue comment.
 - Moved last_buffer_dequeued check from vb2_internal_dqbuf
   into __vb2_wait_for_done_vb.
 - Dropped superfluous check in vb2_poll.
---
 drivers/media/v4l2-core/v4l2-mem2mem.c   | 10 +++++++++-
 drivers/media/v4l2-core/videobuf2-core.c | 19 ++++++++++++++++++-
 include/media/videobuf2-core.h           | 13 +++++++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 80c588f..1b5b432 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -564,8 +564,16 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	if (list_empty(&src_q->done_list))
 		poll_wait(file, &src_q->done_wq, wait);
-	if (list_empty(&dst_q->done_list))
+	if (list_empty(&dst_q->done_list)) {
+		/*
+		 * If the last buffer was dequeued from the capture queue,
+		 * return immediately. DQBUF will return -EPIPE.
+		 */
+		if (dst_q->last_buffer_dequeued)
+			return rc | POLLIN | POLLRDNORM;
+
 		poll_wait(file, &dst_q->done_wq, wait);
+	}
 
 	if (m2m_ctx->m2m_dev->m2m_ops->lock)
 		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index cc16e76..3b2188e 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1918,6 +1918,11 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 			return -EIO;
 		}
 
+		if (q->last_buffer_dequeued) {
+			dprintk(3, "last buffer dequeued already, will not wait for buffers\n");
+			return -EPIPE;
+		}
+
 		if (!list_empty(&q->done_list)) {
 			/*
 			 * Found a buffer that we were waiting for.
@@ -2073,6 +2078,9 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
+	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
+		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
@@ -2286,6 +2294,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	 */
 	__vb2_queue_cancel(q);
 	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->last_buffer_dequeued = false;
 
 	dprintk(3, "successful\n");
 	return 0;
@@ -2628,8 +2637,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
 		return res | POLLOUT | POLLWRNORM;
 
-	if (list_empty(&q->done_list))
+	if (list_empty(&q->done_list)) {
+		/*
+		 * If the last buffer was dequeued from a capture queue,
+		 * return immediately. DQBUF will return -EPIPE.
+		 */
+		if (q->last_buffer_dequeued)
+			return res | POLLIN | POLLRDNORM;
+
 		poll_wait(file, &q->done_wq, wait);
+	}
 
 	/*
 	 * Take first buffer available for dequeuing.
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bd2cec2..a689d25 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -390,6 +390,9 @@ struct v4l2_fh;
  * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
  *		buffers. Only set for capture queues if qbuf has not yet been
  *		called since poll() needs to return POLLERR in that situation.
+ * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
+ *		last decoded buffer was already dequeued. Set for capture queues
+ *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -429,6 +432,7 @@ struct vb2_queue {
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
+	unsigned int			last_buffer_dequeued:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
@@ -609,6 +613,15 @@ static inline bool vb2_start_streaming_called(struct vb2_queue *q)
 	return q->start_streaming_called;
 }
 
+/**
+ * vb2_clear_last_buffer_dequeued() - clear last buffer dequeued flag of queue
+ * @q:		videobuf queue
+ */
+static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
+{
+	q->last_buffer_dequeued = false;
+}
+
 /*
  * The following functions are not part of the vb2 core API, but are simple
  * helper functions that you can use in your struct v4l2_file_operations,
-- 
2.1.4

