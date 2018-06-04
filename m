Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52419 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752793AbeFDLrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 17/35] vb2: drop VB2_BUF_STATE_PREPARED, use bool prepared/synced instead
Date: Mon,  4 Jun 2018 13:46:30 +0200
Message-Id: <20180604114648.26159-18-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The PREPARED state becomes a problem with the request API: a buffer
could be PREPARED but dequeued, or PREPARED and in state IN_REQUEST.

PREPARED is really not a state as such, but more a property of the
buffer. So make new 'prepared' and 'synced' bools instead to remember
whether the buffer is prepared and/or synced or not.

V4L2_BUF_FLAG_PREPARED is only set if the buffer is both synced and
prepared and in the DEQUEUED state.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-core.c   | 38 +++++++++++++------
 .../media/common/videobuf2/videobuf2-v4l2.c   | 16 +++++---
 include/media/videobuf2-core.h                |  6 ++-
 3 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index c25bad134ba3..997673b62afc 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -682,7 +682,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		}
 
 		/*
-		 * Call queue_cancel to clean up any buffers in the PREPARED or
+		 * Call queue_cancel to clean up any buffers in the
 		 * QUEUED state which is possible if buffers were prepared or
 		 * queued without ever calling STREAMON.
 		 */
@@ -921,6 +921,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		/* sync buffers */
 		for (plane = 0; plane < vb->num_planes; ++plane)
 			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+		vb->synced = false;
 	}
 
 	spin_lock_irqsave(&q->done_lock, flags);
@@ -1239,6 +1240,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 static int __buf_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	enum vb2_buffer_state orig_state = vb->state;
 	unsigned int plane;
 	int ret;
 
@@ -1247,6 +1249,10 @@ static int __buf_prepare(struct vb2_buffer *vb)
 		return -EIO;
 	}
 
+	if (vb->prepared)
+		return 0;
+	WARN_ON(vb->synced);
+
 	vb->state = VB2_BUF_STATE_PREPARING;
 
 	switch (q->memory) {
@@ -1262,11 +1268,12 @@ static int __buf_prepare(struct vb2_buffer *vb)
 	default:
 		WARN(1, "Invalid queue type\n");
 		ret = -EINVAL;
+		break;
 	}
 
 	if (ret) {
 		dprintk(1, "buffer preparation failed: %d\n", ret);
-		vb->state = VB2_BUF_STATE_DEQUEUED;
+		vb->state = orig_state;
 		return ret;
 	}
 
@@ -1274,7 +1281,9 @@ static int __buf_prepare(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
 
-	vb->state = VB2_BUF_STATE_PREPARED;
+	vb->synced = true;
+	vb->prepared = true;
+	vb->state = orig_state;
 
 	return 0;
 }
@@ -1290,6 +1299,10 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 			vb->state);
 		return -EINVAL;
 	}
+	if (vb->prepared) {
+		dprintk(1, "buffer already prepared\n");
+		return -EINVAL;
+	}
 
 	ret = __buf_prepare(vb);
 	if (ret)
@@ -1376,11 +1389,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
-		ret = __buf_prepare(vb);
-		if (ret)
-			return ret;
-		break;
-	case VB2_BUF_STATE_PREPARED:
+		if (!vb->prepared) {
+			ret = __buf_prepare(vb);
+			if (ret)
+				return ret;
+		}
 		break;
 	case VB2_BUF_STATE_PREPARING:
 		dprintk(1, "buffer still being prepared\n");
@@ -1606,6 +1619,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	}
 
 	call_void_vb_qop(vb, buf_finish, vb);
+	vb->prepared = false;
 
 	if (pindex)
 		*pindex = vb->index;
@@ -1694,18 +1708,18 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	for (i = 0; i < q->num_buffers; ++i) {
 		struct vb2_buffer *vb = q->bufs[i];
 
-		if (vb->state == VB2_BUF_STATE_PREPARED ||
-		    vb->state == VB2_BUF_STATE_QUEUED) {
+		if (vb->synced) {
 			unsigned int plane;
 
 			for (plane = 0; plane < vb->num_planes; ++plane)
 				call_void_memop(vb, finish,
 						vb->planes[plane].mem_priv);
+			vb->synced = false;
 		}
 
-		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-			vb->state = VB2_BUF_STATE_PREPARED;
+		if (vb->prepared) {
 			call_void_vb_qop(vb, buf_finish, vb);
+			vb->prepared = false;
 		}
 		__vb2_dqbuf(vb);
 	}
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 360dc4e7d413..a677e2c26247 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -352,9 +352,13 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 	if (ret)
 		return ret;
 
-	/* Copy relevant information provided by the userspace */
-	memset(vbuf->planes, 0, sizeof(vbuf->planes[0]) * vb->num_planes);
-	return vb2_fill_vb2_v4l2_buffer(vb, b);
+	if (!vb->prepared) {
+		/* Copy relevant information provided by the userspace */
+		memset(vbuf->planes, 0,
+		       sizeof(vbuf->planes[0]) * vb->num_planes);
+		ret = vb2_fill_vb2_v4l2_buffer(vb, b);
+	}
+	return ret;
 }
 
 /*
@@ -443,9 +447,6 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	case VB2_BUF_STATE_DONE:
 		b->flags |= V4L2_BUF_FLAG_DONE;
 		break;
-	case VB2_BUF_STATE_PREPARED:
-		b->flags |= V4L2_BUF_FLAG_PREPARED;
-		break;
 	case VB2_BUF_STATE_PREPARING:
 	case VB2_BUF_STATE_DEQUEUED:
 	case VB2_BUF_STATE_REQUEUEING:
@@ -453,6 +454,9 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 		break;
 	}
 
+	if (vb->state == VB2_BUF_STATE_DEQUEUED && vb->synced && vb->prepared)
+		b->flags |= V4L2_BUF_FLAG_PREPARED;
+
 	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 224c4820a044..5e760d5f280a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -204,7 +204,6 @@ enum vb2_io_modes {
  * enum vb2_buffer_state - current video buffer state.
  * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control.
  * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf.
- * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver.
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver.
  * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver.
  * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
@@ -218,7 +217,6 @@ enum vb2_io_modes {
 enum vb2_buffer_state {
 	VB2_BUF_STATE_DEQUEUED,
 	VB2_BUF_STATE_PREPARING,
-	VB2_BUF_STATE_PREPARED,
 	VB2_BUF_STATE_QUEUED,
 	VB2_BUF_STATE_REQUEUEING,
 	VB2_BUF_STATE_ACTIVE,
@@ -250,6 +248,8 @@ struct vb2_buffer {
 	/* private: internal use only
 	 *
 	 * state:		current buffer state; do not change
+	 * synced:		this buffer has been synced
+	 * prepared:		this buffer has been prepared
 	 * queued_entry:	entry on the queued buffers list, which holds
 	 *			all buffers queued from userspace
 	 * done_entry:		entry on the list that stores all buffers ready
@@ -257,6 +257,8 @@ struct vb2_buffer {
 	 * vb2_plane:		per-plane information; do not change
 	 */
 	enum vb2_buffer_state	state;
+	bool			synced;
+	bool			prepared;
 
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 	struct list_head	queued_entry;
-- 
2.17.0
