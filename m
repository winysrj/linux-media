Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4347 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaBYKE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 19/20] vb2: add vb2_fileio_is_active and check it more often
Date: Tue, 25 Feb 2014 11:04:24 +0100
Message-Id: <1393322665-29889-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Added a vb2_fileio_is_active inline function that returns true if fileio
is in progress. Use it in the source. Check for this too in mmap() (you
don't want apps mmap()ing buffers used by fileio) and expbuf() (same reason).

In addition drivers should be able to check for this in queue_setup() to
return an error if an attempt is made to read() or write() with
V4L2_FIELD_ALTERNATE being configured. This is illegal (there is no way
to pass the TOP/BOTTOM information around using file I/O).

However, in order to be able to check for this the init_fileio function
needs to set q->fileio early on, before the buffers are allocated. So switch
to using internal functions (__reqbufs, vb2_internal_qbuf and
vb2_internal_streamon) to skip the fileio check. Well, that's why the internal
functions were created...

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 35 ++++++++++++++++++++------------
 include/media/videobuf2-core.h           | 17 ++++++++++++++++
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index face6e9..8ea78d6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -747,7 +747,7 @@ static int __verify_memory_type(struct vb2_queue *q,
 	 * create_bufs is called with count == 0, but count == 0 should still
 	 * do the memory and type validation.
 	 */
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "reqbufs: file io in progress\n");
 		return -EBUSY;
 	}
@@ -1658,7 +1658,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 	struct vb2_buffer *vb;
 	int ret;
 
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "%s(): file io in progress\n", __func__);
 		return -EBUSY;
 	}
@@ -1827,7 +1827,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "%s(): file io in progress\n", __func__);
 		return -EBUSY;
 	}
@@ -2047,7 +2047,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
  */
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "dqbuf: file io in progress\n");
 		return -EBUSY;
 	}
@@ -2173,7 +2173,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
  */
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "streamon: file io in progress\n");
 		return -EBUSY;
 	}
@@ -2220,7 +2220,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
  */
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "streamoff: file io in progress\n");
 		return -EBUSY;
 	}
@@ -2305,6 +2305,11 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EINVAL;
 	}
 
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "expbuf: file io in progress\n");
+		return -EBUSY;
+	}
+
 	vb_plane = &vb->planes[eb->plane];
 
 	dbuf = call_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
@@ -2381,6 +2386,10 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 			return -EINVAL;
 		}
 	}
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "mmap: file io in progress\n");
+		return -EBUSY;
+	}
 
 	/*
 	 * Find the plane corresponding to the offset passed by userspace.
@@ -2695,7 +2704,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	fileio->req.count = count;
 	fileio->req.memory = V4L2_MEMORY_MMAP;
 	fileio->req.type = q->type;
-	ret = vb2_reqbufs(q, &fileio->req);
+	q->fileio = fileio;
+	ret = __reqbufs(q, &fileio->req);
 	if (ret)
 		goto err_kfree;
 
@@ -2741,7 +2751,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			}
 			b->memory = q->memory;
 			b->index = i;
-			ret = vb2_qbuf(q, b);
+			ret = vb2_internal_qbuf(q, b);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2757,19 +2767,18 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Start streaming.
 	 */
-	ret = vb2_streamon(q, q->type);
+	ret = vb2_internal_streamon(q, q->type);
 	if (ret)
 		goto err_reqbufs;
 
-	q->fileio = fileio;
-
 	return ret;
 
 err_reqbufs:
 	fileio->req.count = 0;
-	vb2_reqbufs(q, &fileio->req);
+	__reqbufs(q, &fileio->req);
 
 err_kfree:
+	q->fileio = NULL;
 	kfree(fileio);
 	return ret;
 }
@@ -3200,7 +3209,7 @@ unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
 
 	/* Try to be smart: only lock if polling might start fileio,
 	   otherwise locking will only introduce unwanted delays. */
-	if (q->num_buffers == 0 && q->fileio == NULL) {
+	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
 		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM)))
 			must_lock = true;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index df5e75a..e242f35 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -470,6 +470,23 @@ static inline bool vb2_is_streaming(struct vb2_queue *q)
 }
 
 /**
+ * vb2_fileio_is_active() - return true if fileio is active.
+ * @q:		videobuf queue
+ *
+ * This returns true if read() or write() is used to stream the data
+ * as opposed to stream I/O. This is almost never an important distinction,
+ * except in rare cases. One such case is that using read() or write() to
+ * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
+ * is no way you can pass the field information of each buffer to/from
+ * userspace. A driver that supports this field format should check for
+ * this in the queue_setup op and reject it if this function returns true.
+ */
+static inline bool vb2_fileio_is_active(struct vb2_queue *q)
+{
+	return q->fileio;
+}
+
+/**
  * vb2_is_busy() - return busy status of the queue
  * @q:		videobuf queue
  *
-- 
1.9.0

