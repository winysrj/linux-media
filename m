Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45385 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965794AbbBDNOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 08:14:52 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 2/5] [media] videobuf2: return -EPIPE from DQBUF after the last buffer
Date: Wed,  4 Feb 2015 14:14:34 +0100
Message-Id: <1423055677-13161-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1423055677-13161-1-git-send-email-p.zabel@pengutronix.de>
References: <1423055677-13161-1-git-send-email-p.zabel@pengutronix.de>
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
Changes since v1:
 - Added documentation
 - Added vb2_clear_last_buffer_dequeued inline function to clear the flag
---
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml |  8 ++++++++
 drivers/media/v4l2-core/v4l2-mem2mem.c          | 10 +++++++++-
 drivers/media/v4l2-core/videobuf2-core.c        | 18 +++++++++++++++++-
 include/media/videobuf2-core.h                  | 10 ++++++++++
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 3504a7f..6cfc53b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -186,6 +186,14 @@ In that case the application should be able to safely reuse the buffer and
 continue streaming.
 	</para>
 	</listitem>
+	<term><errorcode>EPIPE</errorcode></term>
+	<listitem>
+	  <para><constant>VIDIOC_DQBUF</constant> returns this on an empty
+capture queue for mem2mem codecs if a buffer with the
+<constant>V4L2_BUF_FLAG_LAST</constant> was already dequeued and no new buffers
+are expected to become available.
+	</para>
+	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
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
index bc08a82..a0b9946 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2046,6 +2046,10 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	struct vb2_buffer *vb = NULL;
 	int ret;
 
+	if (q->last_buffer_dequeued) {
+		dprintk(3, "last buffer dequeued already\n");
+		return -EPIPE;
+	}
 	if (b->type != q->type) {
 		dprintk(1, "invalid buffer type\n");
 		return -EINVAL;
@@ -2073,6 +2077,9 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
+	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
+		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
@@ -2286,6 +2293,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	 */
 	__vb2_queue_cancel(q);
 	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->last_buffer_dequeued = false;
 
 	dprintk(3, "successful\n");
 	return 0;
@@ -2628,8 +2636,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
 		return res | POLLOUT | POLLWRNORM;
 
-	if (list_empty(&q->done_list))
+	if (list_empty(&q->done_list)) {
+		/*
+		 * If the last buffer was dequeued from a capture queue,
+		 * return immediately. DQBUF will return -EPIPE.
+		 */
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && q->last_buffer_dequeued)
+			return res | POLLIN | POLLRDNORM;
+
 		poll_wait(file, &q->done_wq, wait);
+	}
 
 	/*
 	 * Take first buffer available for dequeuing.
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bd2cec2..863a8bb 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -429,6 +429,7 @@ struct vb2_queue {
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
+	unsigned int			last_buffer_dequeued:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
@@ -609,6 +610,15 @@ static inline bool vb2_start_streaming_called(struct vb2_queue *q)
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

