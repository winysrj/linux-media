Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2451 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbaDKIM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 09/13] vb2: add vb2_fileio_is_active and check it more often
Date: Fri, 11 Apr 2014 10:11:15 +0200
Message-Id: <1397203879-37443-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Added a vb2_fileio_is_active inline function that returns true if fileio
is in progress. Check for this too in mmap() (you don't want apps mmap()ing
buffers used by fileio) and expbuf() (same reason).

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
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 39 ++++++++++++++++++++------------
 include/media/videobuf2-core.h           | 17 ++++++++++++++
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 3d2a003..acabf1f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -755,7 +755,7 @@ static int __verify_memory_type(struct vb2_queue *q,
 	 * create_bufs is called with count == 0, but count == 0 should still
 	 * do the memory and type validation.
 	 */
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
@@ -1617,7 +1617,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 	struct vb2_buffer *vb;
 	int ret;
 
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
@@ -1786,7 +1786,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
@@ -2006,7 +2006,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
  */
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
@@ -2136,7 +2136,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
  */
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
@@ -2183,7 +2183,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
  */
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	if (q->fileio) {
+	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
@@ -2268,6 +2268,11 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EINVAL;
 	}
 
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "expbuf: file io in progress\n");
+		return -EBUSY;
+	}
+
 	vb_plane = &vb->planes[eb->plane];
 
 	dbuf = call_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
@@ -2344,6 +2349,10 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 			return -EINVAL;
 		}
 	}
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "mmap: file io in progress\n");
+		return -EBUSY;
+	}
 
 	/*
 	 * Find the plane corresponding to the offset passed by userspace.
@@ -2455,7 +2464,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
-	if (q->num_buffers == 0 && q->fileio == NULL) {
+	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
 		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM))) {
 			if (__vb2_init_fileio(q, 1))
@@ -2660,7 +2669,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	fileio->req.count = count;
 	fileio->req.memory = V4L2_MEMORY_MMAP;
 	fileio->req.type = q->type;
-	ret = vb2_reqbufs(q, &fileio->req);
+	q->fileio = fileio;
+	ret = __reqbufs(q, &fileio->req);
 	if (ret)
 		goto err_kfree;
 
@@ -2698,7 +2708,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			b->type = q->type;
 			b->memory = q->memory;
 			b->index = i;
-			ret = vb2_qbuf(q, b);
+			ret = vb2_internal_qbuf(q, b);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2714,19 +2724,18 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
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
@@ -2784,7 +2793,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	/*
 	 * Initialize emulator on first call.
 	 */
-	if (!q->fileio) {
+	if (!vb2_fileio_is_active(q)) {
 		ret = __vb2_init_fileio(q, read);
 		dprintk(3, "vb2_init_fileio result: %d\n", ret);
 		if (ret)
@@ -3152,7 +3161,7 @@ unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
 
 	/* Try to be smart: only lock if polling might start fileio,
 	   otherwise locking will only introduce unwanted delays. */
-	if (q->num_buffers == 0 && q->fileio == NULL) {
+	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
 		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM)))
 			must_lock = true;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 3b57851..af34ae0 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -472,6 +472,23 @@ static inline bool vb2_is_streaming(struct vb2_queue *q)
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
1.9.1

