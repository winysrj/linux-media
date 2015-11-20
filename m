Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:60281 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163044AbbKTQuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:50:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv11 11/15] videobuf2-core: fill_user_buffer and copy_timestamp should return void
Date: Fri, 20 Nov 2015 17:45:44 +0100
Message-Id: <1448037948-36820-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ops can never fail, so make these void functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 27 ++++++++++++---------------
 drivers/media/v4l2-core/videobuf2-v4l2.c | 12 +++++-------
 include/media/videobuf2-core.h           | 17 ++++++++++++++---
 3 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4faa066..5cd418e 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -178,6 +178,12 @@ module_param(debug, int, 0644);
 	ret;								\
 })
 
+#define call_void_bufop(q, op, args...)					\
+({									\
+	if (q && q->buf_ops && q->buf_ops->op)				\
+		q->buf_ops->op(args);					\
+})
+
 static void __vb2_queue_cancel(struct vb2_queue *q);
 static void __enqueue_in_driver(struct vb2_buffer *vb);
 
@@ -586,13 +592,10 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * Should be called from vidioc_querybuf ioctl handler in driver.
  * The passed buffer should have been verified.
  * This function fills the relevant information for the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_querybuf handler in driver.
  */
-int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
+void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
-	return call_bufop(q, fill_user_buffer, q->bufs[index], pb);
+	call_void_bufop(q, fill_user_buffer, q->bufs[index], pb);
 }
 EXPORT_SYMBOL_GPL(vb2_core_querybuf);
 
@@ -1420,9 +1423,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 		return ret;
 
 	/* Fill buffer information for the userspace */
-	ret = call_bufop(q, fill_user_buffer, vb, pb);
-	if (ret)
-		return ret;
+	call_void_bufop(q, fill_user_buffer, vb, pb);
 
 	dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
 
@@ -1543,7 +1544,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 
-	call_bufop(q, copy_timestamp, vb, pb);
+	call_void_bufop(q, copy_timestamp, vb, pb);
 
 	trace_vb2_qbuf(q, vb);
 
@@ -1555,9 +1556,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 		__enqueue_in_driver(vb);
 
 	/* Fill buffer information for the userspace */
-	ret = call_bufop(q, fill_user_buffer, vb, pb);
-	if (ret)
-		return ret;
+	call_void_bufop(q, fill_user_buffer, vb, pb);
 
 	/*
 	 * If streamon has been called, and we haven't yet called
@@ -1780,9 +1779,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
 	call_void_vb_qop(vb, buf_finish, vb);
 
 	/* Fill buffer information for the userspace */
-	ret = call_bufop(q, fill_user_buffer, vb, pb);
-	if (ret)
-		return ret;
+	call_void_bufop(q, fill_user_buffer, vb, pb);
 
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index f17b9cf..c9a2860 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -114,7 +114,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	return 0;
 }
 
-static int __copy_timestamp(struct vb2_buffer *vb, const void *pb)
+static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 {
 	const struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -131,7 +131,6 @@ static int __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
 			vbuf->timecode = b->timecode;
 	}
-	return 0;
 };
 
 static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
@@ -182,7 +181,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
+static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 {
 	struct v4l2_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -281,8 +280,6 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 		b->flags & V4L2_BUF_FLAG_DONE &&
 		b->flags & V4L2_BUF_FLAG_LAST)
 		q->last_buffer_dequeued = true;
-
-	return 0;
 }
 
 /**
@@ -474,8 +471,9 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	}
 	vb = q->bufs[b->index];
 	ret = __verify_planes_array(vb, b);
-
-	return ret ? ret : vb2_core_querybuf(q, b->index, b);
+	if (!ret)
+		vb2_core_querybuf(q, b->index, b);
+	return ret;
 }
 EXPORT_SYMBOL(vb2_querybuf);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cc94c9d..b88dbba 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -369,11 +369,22 @@ struct vb2_ops {
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
 
+/**
+ * struct vb2_ops - driver-specific callbacks
+ *
+ * @fill_user_buffer:	given a vb2_buffer fill in the userspace structure.
+ *			For V4L2 this is a struct v4l2_buffer.
+ * @fill_vb2_buffer:	given a userspace structure, fill in the vb2_buffer.
+ *			If the userspace structure is invalid, then this op
+ *			will return an error.
+ * @copy_timestamp:	copy the timestamp from a userspace structure to
+ *			the vb2_buffer struct.
+ */
 struct vb2_buf_ops {
-	int (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
+	void (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
 	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
 				struct vb2_plane *planes);
-	int (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
+	void (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
 };
 
 /**
@@ -512,7 +523,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
-int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
+void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count);
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
-- 
2.6.2

