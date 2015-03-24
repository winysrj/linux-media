Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39360 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbbCXRq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:46:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 2/4] [media] videobuf2: return -EPIPE from DQBUF after the last buffer
Date: Tue, 24 Mar 2015 18:46:52 +0100
Message-Id: <1427219214-5368-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
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
Changes since v3:
 - Added DocBook update mentioning DQBUF returning -EPIPE in the encoder/decoder
   stop command documentation.
---
 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml |  4 +++-
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml |  4 +++-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml        |  8 ++++++++
 drivers/media/v4l2-core/v4l2-mem2mem.c                 | 10 +++++++++-
 drivers/media/v4l2-core/videobuf2-core.c               | 18 +++++++++++++++++-
 include/media/videobuf2-core.h                         | 10 ++++++++++
 6 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
index cbb7135..2601c37 100644
--- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
@@ -200,7 +200,9 @@ set the picture to black after it stopped decoding. Otherwise the last image wil
 repeat. mem2mem decoders will stop producing new frames altogether. They will send
 a <constant>V4L2_EVENT_EOS</constant> event after the last frame was decoded and
 will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag when there will
-be no new buffers produced to dequeue.
+be no new buffers produced to dequeue. Once this flag was set, the
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block anymore,
+but return an &EPIPE;.
 If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
 stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
 will keep decoding until timestamp >= pts or until the last of the pending data from
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index e9cf601..def688f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -132,7 +132,9 @@ When the encoder is already stopped, this command does
 nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
 after the last frame was encoded and will set the
 <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the capture queue when
-there will be no new buffers produced to dequeue</entry>
+there will be no new buffers produced to dequeue. Once this flag was set, the
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block anymore,
+but return an &EPIPE;.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_ENC_CMD_PAUSE</constant></entry>
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

