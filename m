Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38078 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161905AbbKTRCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 12:02:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv11 05/15] media: videobuf2: Add copy_timestamp to struct vb2_queue
Date: Fri, 20 Nov 2015 17:45:38 +0100
Message-Id: <1448037948-36820-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

Add copy_timestamp to struct vb2_queue as a flag set if vb2-core should
copy timestamps.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c | 31 +++++++++++++------------------
 include/media/videobuf2-core.h           |  4 +++-
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ebce7c7..bd96fb8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1399,7 +1399,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 
-	call_bufop(q, set_timestamp, vb, pb);
+	call_bufop(q, copy_timestamp, vb, pb);
 
 	trace_vb2_qbuf(q, vb);
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index bfd7e34..e03f700 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -107,7 +107,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	return 0;
 }
 
-static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
+static int __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 {
 	const struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -118,8 +118,7 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
 		 * For output buffers copy the timestamp if needed,
 		 * and the timecode field and flag if needed.
 		 */
-		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-				V4L2_BUF_FLAG_TIMESTAMP_COPY)
+		if (q->copy_timestamp)
 			vb->timestamp = timeval_to_ns(&b->timestamp);
 		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
@@ -238,8 +237,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	 */
 	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
 	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
-	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+	if (!q->copy_timestamp) {
 		/*
 		 * For non-COPY timestamps, drop timestamp source bits
 		 * and obtain the timestamp source from the queue.
@@ -403,8 +401,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 
 	/* Zero flags that the vb2 core handles */
 	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
-	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
+	if (!vb->vb2_queue->copy_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * Non-COPY timestamps and non-OUTPUT queues will get
 		 * their timestamp and timestamp source flags from the
@@ -433,7 +430,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 static const struct vb2_buf_ops v4l2_buf_ops = {
 	.fill_user_buffer	= __fill_v4l2_buffer,
 	.fill_vb2_buffer	= __fill_vb2_buffer,
-	.set_timestamp		= __set_timestamp,
+	.copy_timestamp		= __copy_timestamp,
 };
 
 /**
@@ -760,6 +757,8 @@ int vb2_queue_init(struct vb2_queue *q)
 	q->buf_ops = &v4l2_buf_ops;
 	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
 	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
+	q->copy_timestamp = (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK)
+			== V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_core_queue_init(q);
 }
@@ -1114,12 +1113,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	bool is_multiplanar = q->is_multiplanar;
 	/*
 	 * When using write() to write data to an output video node the vb2 core
-	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
+	 * should copy timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
 	 * else is able to provide this information with the write() operation.
 	 */
-	bool set_timestamp = !read &&
-		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	bool copy_timestamp = !read && q->copy_timestamp;
 	int ret, index;
 
 	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
@@ -1236,7 +1233,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			fileio->b.m.planes = &fileio->p;
 			fileio->b.length = 1;
 		}
-		if (set_timestamp)
+		if (copy_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
 		ret = vb2_internal_qbuf(q, &fileio->b);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
@@ -1301,16 +1298,14 @@ static int vb2_thread(void *data)
 	struct vb2_queue *q = data;
 	struct vb2_threadio_data *threadio = q->threadio;
 	struct vb2_fileio_data *fileio = q->fileio;
-	bool set_timestamp = false;
+	bool copy_timestamp = false;
 	int prequeue = 0;
 	int index = 0;
 	int ret = 0;
 
 	if (q->is_output) {
 		prequeue = q->num_buffers;
-		set_timestamp =
-			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-			V4L2_BUF_FLAG_TIMESTAMP_COPY;
+		copy_timestamp = q->copy_timestamp;
 	}
 
 	set_freezable();
@@ -1343,7 +1338,7 @@ static int vb2_thread(void *data)
 			if (threadio->fnc(vb, threadio->priv))
 				break;
 		call_void_qop(q, wait_finish, q);
-		if (set_timestamp)
+		if (copy_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
 		if (!threadio->stop)
 			ret = vb2_internal_qbuf(q, &fileio->b);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 0774bf3..67da143 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -373,7 +373,7 @@ struct vb2_buf_ops {
 	int (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
 	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
 				struct vb2_plane *planes);
-	int (*set_timestamp)(struct vb2_buffer *vb, const void *pb);
+	int (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
 };
 
 /**
@@ -436,6 +436,7 @@ struct vb2_buf_ops {
  *		called since poll() needs to return POLLERR in that situation.
  * @is_multiplanar: set if buffer type is multiplanar
  * @is_output:	set if buffer type is output
+ * @copy_timestamp: set if vb2-core should set timestamps
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
@@ -485,6 +486,7 @@ struct vb2_queue {
 	unsigned int			waiting_for_buffers:1;
 	unsigned int			is_multiplanar:1;
 	unsigned int			is_output:1;
+	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
 
 	struct vb2_fileio_data		*fileio;
-- 
2.6.2

