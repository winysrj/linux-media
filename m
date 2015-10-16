Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:37279 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbJPG1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 02:27:47 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NWA00VC3VA9C370@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Oct 2015 15:27:45 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v7 3/7] media: videobuf2: Add set_timestamp to struct
 vb2_queue
Date: Fri, 16 Oct 2015 15:27:39 +0900
Message-id: <1444976863-3657-4-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add set_timestamp to struct vb2_queue as a flag set if vb2-core should
set timestamps.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c |   19 +++++++------------
 include/media/videobuf2-core.h           |    2 ++
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index b1334d6..525f4c7 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -118,8 +118,7 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
 		 * For output buffers copy the timestamp if needed,
 		 * and the timecode field and flag if needed.
 		 */
-		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-				V4L2_BUF_FLAG_TIMESTAMP_COPY)
+		if (q->set_timestamp)
 			vb->timestamp = b->timestamp;
 		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
@@ -238,8 +237,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	 */
 	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
 	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
-	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+	if (!q->set_timestamp) {
 		/*
 		 * For non-COPY timestamps, drop timestamp source bits
 		 * and obtain the timestamp source from the queue.
@@ -404,8 +402,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 
 	/* Zero flags that the vb2 core handles */
 	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
-	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
+	if (!vb->vb2_queue->set_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * Non-COPY timestamps and non-OUTPUT queues will get
 		 * their timestamp and timestamp source flags from the
@@ -723,6 +720,8 @@ int vb2_queue_init(struct vb2_queue *q)
 	q->buf_ops = &v4l2_buf_ops;
 	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
 	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
+	q->set_timestamp = (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK)
+			== V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_core_queue_init(q);
 }
@@ -1080,9 +1079,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
 	 * else is able to provide this information with the write() operation.
 	 */
-	bool set_timestamp = !read &&
-		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	bool set_timestamp = !read && q->set_timestamp;
 	int ret, index;
 
 	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
@@ -1271,9 +1268,7 @@ static int vb2_thread(void *data)
 
 	if (q->is_output) {
 		prequeue = q->num_buffers;
-		set_timestamp =
-			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-			V4L2_BUF_FLAG_TIMESTAMP_COPY;
+		set_timestamp = q->set_timestamp;
 	}
 
 	set_freezable();
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f1e7169..6ef7da7 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -431,6 +431,7 @@ struct vb2_buf_ops {
  *		called since poll() needs to return POLLERR in that situation.
  * @is_multiplanar: set if buffer type is multiplanar
  * @is_output:	set if buffer type is output
+ * @copy_timestamp: set if vb2-core should set timestamps
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
@@ -480,6 +481,7 @@ struct vb2_queue {
 	unsigned int			waiting_for_buffers:1;
 	unsigned int			is_multiplanar:1;
 	unsigned int			is_output:1;
+	unsigned int			set_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
 
 	struct vb2_fileio_data		*fileio;
-- 
1.7.9.5

