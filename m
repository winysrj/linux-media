Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2030 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab3LINnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 08:43:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, g.liakhovetski@gmx.de,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 1/8] vb2: push the mmap semaphore down to __buf_prepare()
Date: Mon,  9 Dec 2013 14:43:05 +0100
Message-Id: <1386596592-48678-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl>
References: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rather than taking the mmap semaphore at a relatively high-level function,
push it down to the place where it is really needed.

It was placed in vb2_queue_or_prepare_buf() to prevent racing with other
vb2 calls. The only way I can see that a race can happen is when two
threads queue the same buffer. The solution for that it to introduce
a PREPARING state.

Moving it down offers opportunities to simplify the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 82 ++++++++++++++------------------
 include/media/videobuf2-core.h           |  2 +
 2 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 57ba131..634dc95 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -462,6 +462,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	case VB2_BUF_STATE_PREPARED:
 		b->flags |= V4L2_BUF_FLAG_PREPARED;
 		break;
+	case VB2_BUF_STATE_PREPARING:
 	case VB2_BUF_STATE_DEQUEUED:
 		/* nothing */
 		break;
@@ -1207,6 +1208,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	struct rw_semaphore *mmap_sem;
 	int ret;
 
 	ret = __verify_length(vb, b);
@@ -1216,12 +1218,31 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		return ret;
 	}
 
+	vb->state = VB2_BUF_STATE_PREPARING;
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
 		break;
 	case V4L2_MEMORY_USERPTR:
+		/*
+		 * In case of user pointer buffers vb2 allocators need to get direct
+		 * access to userspace pages. This requires getting the mmap semaphore
+		 * for read access in the current process structure. The same semaphore
+		 * is taken before calling mmap operation, while both qbuf/prepare_buf
+		 * and mmap are called by the driver or v4l2 core with the driver's lock
+		 * held. To avoid an AB-BA deadlock (mmap_sem then driver's lock in mmap
+		 * and driver's lock then mmap_sem in qbuf/prepare_buf) the videobuf2
+		 * core releases the driver's lock, takes mmap_sem and then takes the
+		 * driver's lock again.
+		 */
+		mmap_sem = &current->mm->mmap_sem;
+		call_qop(q, wait_prepare, q);
+		down_read(mmap_sem);
+		call_qop(q, wait_finish, q);
+
 		ret = __qbuf_userptr(vb, b);
+
+		up_read(mmap_sem);
 		break;
 	case V4L2_MEMORY_DMABUF:
 		ret = __qbuf_dmabuf(vb, b);
@@ -1235,8 +1256,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = call_qop(q, buf_prepare, vb);
 	if (ret)
 		dprintk(1, "qbuf: buffer preparation failed: %d\n", ret);
-	else
-		vb->state = VB2_BUF_STATE_PREPARED;
+	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
 
 	return ret;
 }
@@ -1247,80 +1267,47 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 						   struct v4l2_buffer *,
 						   struct vb2_buffer *))
 {
-	struct rw_semaphore *mmap_sem = NULL;
 	struct vb2_buffer *vb;
 	int ret;
 
-	/*
-	 * In case of user pointer buffers vb2 allocators need to get direct
-	 * access to userspace pages. This requires getting the mmap semaphore
-	 * for read access in the current process structure. The same semaphore
-	 * is taken before calling mmap operation, while both qbuf/prepare_buf
-	 * and mmap are called by the driver or v4l2 core with the driver's lock
-	 * held. To avoid an AB-BA deadlock (mmap_sem then driver's lock in mmap
-	 * and driver's lock then mmap_sem in qbuf/prepare_buf) the videobuf2
-	 * core releases the driver's lock, takes mmap_sem and then takes the
-	 * driver's lock again.
-	 *
-	 * To avoid racing with other vb2 calls, which might be called after
-	 * releasing the driver's lock, this operation is performed at the
-	 * beginning of qbuf/prepare_buf processing. This way the queue status
-	 * is consistent after getting the driver's lock back.
-	 */
-	if (q->memory == V4L2_MEMORY_USERPTR) {
-		mmap_sem = &current->mm->mmap_sem;
-		call_qop(q, wait_prepare, q);
-		down_read(mmap_sem);
-		call_qop(q, wait_finish, q);
-	}
-
 	if (q->fileio) {
 		dprintk(1, "%s(): file io in progress\n", opname);
-		ret = -EBUSY;
-		goto unlock;
+		return -EBUSY;
 	}
 
 	if (b->type != q->type) {
 		dprintk(1, "%s(): invalid buffer type\n", opname);
-		ret = -EINVAL;
-		goto unlock;
+		return -EINVAL;
 	}
 
 	if (b->index >= q->num_buffers) {
 		dprintk(1, "%s(): buffer index out of range\n", opname);
-		ret = -EINVAL;
-		goto unlock;
+		return -EINVAL;
 	}
 
 	vb = q->bufs[b->index];
 	if (NULL == vb) {
 		/* Should never happen */
 		dprintk(1, "%s(): buffer is NULL\n", opname);
-		ret = -EINVAL;
-		goto unlock;
+		return -EINVAL;
 	}
 
 	if (b->memory != q->memory) {
 		dprintk(1, "%s(): invalid memory type\n", opname);
-		ret = -EINVAL;
-		goto unlock;
+		return -EINVAL;
 	}
 
 	ret = __verify_planes_array(vb, b);
 	if (ret)
-		goto unlock;
+		return ret;
 
 	ret = handler(q, b, vb);
-	if (ret)
-		goto unlock;
-
-	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
+	if (!ret) {
+		/* Fill buffer information for the userspace */
+		__fill_v4l2_buffer(vb, b);
 
-	dprintk(1, "%s() of buffer %d succeeded\n", opname, vb->v4l2_buf.index);
-unlock:
-	if (mmap_sem)
-		up_read(mmap_sem);
+		dprintk(1, "%s() of buffer %d succeeded\n", opname, vb->v4l2_buf.index);
+	}
 	return ret;
 }
 
@@ -1369,6 +1356,9 @@ static int __vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 			return ret;
 	case VB2_BUF_STATE_PREPARED:
 		break;
+	case VB2_BUF_STATE_PREPARING:
+		dprintk(1, "qbuf: buffer still being prepared\n");
+		return -EINVAL;
 	default:
 		dprintk(1, "qbuf: buffer already in use\n");
 		return -EINVAL;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 941055e..67972f6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -142,6 +142,7 @@ enum vb2_fileio_flags {
 /**
  * enum vb2_buffer_state - current video buffer state
  * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
+ * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
  * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
  * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
@@ -154,6 +155,7 @@ enum vb2_fileio_flags {
  */
 enum vb2_buffer_state {
 	VB2_BUF_STATE_DEQUEUED,
+	VB2_BUF_STATE_PREPARING,
 	VB2_BUF_STATE_PREPARED,
 	VB2_BUF_STATE_QUEUED,
 	VB2_BUF_STATE_ACTIVE,
-- 
1.8.4.3

