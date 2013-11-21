Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4256 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3KUPWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 10:22:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	awalls@md.metrocast.net, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/8] vb2: retry start_streaming in case of insufficient buffers.
Date: Thu, 21 Nov 2013 16:22:02 +0100
Message-Id: <1385047326-23099-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If start_streaming returns -ENODATA, then it will be retried the next time
a buffer is queued. This means applications no longer need to know how many
buffers need to be queued before STREAMON can be called. This is particularly
useful for output stream I/O.

If a DMA engine needs at least X buffers before it can start streaming, then
for applications to get a buffer out as soon as possible they need to know
the minimum number of buffers to queue before STREAMON can be called. You can't
just try STREAMON after every buffer since on failure STREAMON will dequeue
all your buffers. (Is that a bug or a feature? Frankly, I'm not sure).

This patch simplifies applications substantially: they can just call STREAMON
at the beginning and then start queuing buffers and the DMA engine will
kick in automagically once enough buffers are available.

This also fixes using write() to stream video: the fileio implementation
calls streamon without having any queued buffers, which will fail today for
any driver that requires a minimum number of buffers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 66 +++++++++++++++++++++++++-------
 include/media/videobuf2-core.h           | 15 ++++++--
 2 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9ea3ae9..5bb91f7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1332,6 +1332,39 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
+/**
+ * vb2_start_streaming() - Attempt to start streaming.
+ * @q:		videobuf2 queue
+ *
+ * If there are not enough buffers, then retry_start_streaming is set to
+ * true and 0 is returned. The next time a buffer is queued and
+ * retry_start_streaming is true, this function will be called again to
+ * retry starting the DMA engine.
+ */
+static int vb2_start_streaming(struct vb2_queue *q)
+{
+	int ret;
+
+	/* Tell the driver to start streaming */
+	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
+
+	/*
+	 * If there are not enough buffers queued to start streaming, then
+	 * the start_streaming operation will return -ENODATA and you have to
+	 * retry when the next buffer is queued.
+	 */
+	if (ret == -ENODATA) {
+		dprintk(1, "qbuf: not enough buffers, retry when more buffers are queued.\n");
+		q->retry_start_streaming = true;
+		return 0;
+	}
+	if (ret)
+		dprintk(1, "qbuf: driver refused to start streaming\n");
+	else
+		q->retry_start_streaming = false;
+	return ret;
+}
+
 static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
@@ -1377,6 +1410,12 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
 
+	if (q->retry_start_streaming) {
+		ret = vb2_start_streaming(q);
+		if (ret)
+			return ret;
+	}
+
 	dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb->v4l2_buf.index);
 	return 0;
 }
@@ -1526,7 +1565,8 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
 		return -EINVAL;
 	}
 
-	wait_event(q->done_wq, !atomic_read(&q->queued_count));
+	if (!q->retry_start_streaming)
+		wait_event(q->done_wq, !atomic_read(&q->queued_count));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
@@ -1640,6 +1680,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
 
+	if (q->retry_start_streaming)
+		q->retry_start_streaming = q->streaming = 0;
+
 	/*
 	 * Tell driver to stop all transactions and release all queued
 	 * buffers.
@@ -1689,12 +1732,9 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	list_for_each_entry(vb, &q->queued_list, queued_entry)
 		__enqueue_in_driver(vb);
 
-	/*
-	 * Let driver notice that streaming state has been enabled.
-	 */
-	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
+	/* Tell driver to start streaming. */
+	ret = vb2_start_streaming(q);
 	if (ret) {
-		dprintk(1, "streamon: driver refused to start streaming\n");
 		__vb2_queue_cancel(q);
 		return ret;
 	}
@@ -2264,15 +2304,15 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
 		}
-
-		/*
-		 * Start streaming.
-		 */
-		ret = vb2_streamon(q, q->type);
-		if (ret)
-			goto err_reqbufs;
 	}
 
+	/*
+	 * Start streaming.
+	 */
+	ret = vb2_streamon(q, q->type);
+	if (ret)
+		goto err_reqbufs;
+
 	q->fileio = fileio;
 
 	return ret;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bd8218b..2d88897 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -250,10 +250,13 @@ struct vb2_buffer {
  *			receive buffers with @buf_queue callback before
  *			@start_streaming is called; the driver gets the number
  *			of already queued buffers in count parameter; driver
- *			can return an error if hardware fails or not enough
- *			buffers has been queued, in such case all buffers that
- *			have been already given by the @buf_queue callback are
- *			invalidated.
+ *			can return an error if hardware fails, in that case all
+ *			buffers that have been already given by the @buf_queue
+ *			callback are invalidated.
+ *			If there were not enough queued buffers to start
+ *			streaming, then this callback returns -ENODATA, and the
+ *			vb2 core will retry calling @start_streaming when a new
+ *			buffer is queued.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from buf_queue()
@@ -321,6 +324,9 @@ struct v4l2_fh;
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
  * @alloc_ctx:	memory type/allocator-specific contexts for each plane
  * @streaming:	current streaming state
+ * @retry_start_streaming: start_streaming() was called, but there were not enough
+ *		buffers queued. If set, then retry calling start_streaming when
+ *		queuing a new buffer.
  * @fileio:	file io emulator internal data, used only if emulator is active
  */
 struct vb2_queue {
@@ -353,6 +359,7 @@ struct vb2_queue {
 	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
 
 	unsigned int			streaming:1;
+	unsigned int			retry_start_streaming:1;
 
 	struct vb2_fileio_data		*fileio;
 };
-- 
1.8.4.3

