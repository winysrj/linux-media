Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4277 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3KUPWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 10:22:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	awalls@md.metrocast.net, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/8] vb2: remove the 'fileio = NULL' hack.
Date: Thu, 21 Nov 2013 16:22:01 +0100
Message-Id: <1385047326-23099-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The read/write implementation in vb2 reuses existing vb2 functions, but
it sets q->fileio to NULL before calling them in order to skip the
'q->fileio != NULL' check.

This works today due to the synchronous nature of read/write, but it
1) is ugly, and 2) will fail in an asynchronous use-case such as a
thread queuing and dequeuing buffers. This last example will be necessary
in order to implement vb2 DVB support.

This patch removes the hack by splitting up the dqbuf/qbuf/streamon/streamoff
functions into an external and an internal version. The external version
checks q->fileio and then calls the internal version. The read/write
implementation now just uses the internal version, removing the need to
set q->fileio to NULL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 223 ++++++++++++++++---------------
 1 file changed, 112 insertions(+), 111 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index e90a5be..9ea3ae9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1261,11 +1261,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 				    const char *opname)
 {
-	if (q->fileio) {
-		dprintk(1, "%s(): file io in progress\n", opname);
-		return -EBUSY;
-	}
-
 	if (b->type != q->type) {
 		dprintk(1, "%s(): invalid buffer type\n", opname);
 		return -EINVAL;
@@ -1307,9 +1302,15 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	int ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
 	struct vb2_buffer *vb;
+	int ret;
+
+	if (q->fileio) {
+		dprintk(1, "%s(): file io in progress\n", __func__);
+		return -EBUSY;
+	}
 
+	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
 	if (ret)
 		return ret;
 
@@ -1331,24 +1332,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
-/**
- * vb2_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_qbuf handler
- *		in driver
- *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
- */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
 	struct vb2_buffer *vb;
@@ -1396,6 +1380,33 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	dprintk(1, "%s() of buffer %d succeeded\n", __func__, vb->v4l2_buf.index);
 	return 0;
 }
+
+/**
+ * vb2_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
+ * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	if (q->fileio) {
+		dprintk(1, "%s(): file io in progress\n", __func__);
+		return -EBUSY;
+	}
+
+	return vb2_internal_qbuf(q, b);
+}
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
 /**
@@ -1544,37 +1555,11 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-/**
- * vb2_dqbuf() - Dequeue a buffer to the userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
- *		in driver
- * @nonblocking: if true, this call will not sleep waiting for a buffer if no
- *		 buffers ready for dequeuing are present. Normally the driver
- *		 would be passing (file->f_flags & O_NONBLOCK) here
- *
- * Should be called from vidioc_dqbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_finish callback in the driver (if provided), in which
- *    driver can perform any additional operations that may be required before
- *    returning the buffer to userspace, such as cache sync,
- * 3) the buffer struct members are filled with relevant information for
- *    the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_dqbuf handler in driver.
- */
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
 
-	if (q->fileio) {
-		dprintk(1, "dqbuf: file io in progress\n");
-		return -EBUSY;
-	}
-
 	if (b->type != q->type) {
 		dprintk(1, "dqbuf: invalid buffer type\n");
 		return -EINVAL;
@@ -1613,6 +1598,36 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 
 	return 0;
 }
+
+/**
+ * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
+ *		in driver
+ * @nonblocking: if true, this call will not sleep waiting for a buffer if no
+ *		 buffers ready for dequeuing are present. Normally the driver
+ *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *
+ * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_finish callback in the driver (if provided), in which
+ *    driver can perform any additional operations that may be required before
+ *    returning the buffer to userspace, such as cache sync,
+ * 3) the buffer struct members are filled with relevant information for
+ *    the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_dqbuf handler in driver.
+ */
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+{
+	if (q->fileio) {
+		dprintk(1, "dqbuf: file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_internal_dqbuf(q, b, nonblocking);
+}
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 /**
@@ -1652,29 +1667,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		__vb2_dqbuf(q->bufs[i]);
 }
 
-/**
- * vb2_streamon - start streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamon handler
- *
- * Should be called from vidioc_streamon handler of a driver.
- * This function:
- * 1) verifies current state
- * 2) passes any previously queued buffers to the driver and starts streaming
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_streamon handler in the driver.
- */
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	struct vb2_buffer *vb;
 	int ret;
 
-	if (q->fileio) {
-		dprintk(1, "streamon: file io in progress\n");
-		return -EBUSY;
-	}
-
 	if (type != q->type) {
 		dprintk(1, "streamon: invalid stream type\n");
 		return -EINVAL;
@@ -1707,31 +1704,32 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	dprintk(3, "Streamon successful\n");
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_streamon);
-
 
 /**
- * vb2_streamoff - stop streaming
+ * vb2_streamon - start streaming
  * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamoff handler
+ * @type:	type argument passed from userspace to vidioc_streamon handler
  *
- * Should be called from vidioc_streamoff handler of a driver.
+ * Should be called from vidioc_streamon handler of a driver.
  * This function:
- * 1) verifies current state,
- * 2) stop streaming and dequeues any queued buffers, including those previously
- *    passed to the driver (after waiting for the driver to finish).
+ * 1) verifies current state
+ * 2) passes any previously queued buffers to the driver and starts streaming
  *
- * This call can be used for pausing playback.
  * The return values from this function are intended to be directly returned
- * from vidioc_streamoff handler in the driver
+ * from vidioc_streamon handler in the driver.
  */
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (q->fileio) {
-		dprintk(1, "streamoff: file io in progress\n");
+		dprintk(1, "streamon: file io in progress\n");
 		return -EBUSY;
 	}
+	return vb2_internal_streamon(q, type);
+}
+EXPORT_SYMBOL_GPL(vb2_streamon);
 
+static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+{
 	if (type != q->type) {
 		dprintk(1, "streamoff: invalid stream type\n");
 		return -EINVAL;
@@ -1751,6 +1749,30 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 	dprintk(3, "Streamoff successful\n");
 	return 0;
 }
+
+/**
+ * vb2_streamoff - stop streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamoff handler
+ *
+ * Should be called from vidioc_streamoff handler of a driver.
+ * This function:
+ * 1) verifies current state,
+ * 2) stop streaming and dequeues any queued buffers, including those previously
+ *    passed to the driver (after waiting for the driver to finish).
+ *
+ * This call can be used for pausing playback.
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamoff handler in the driver
+ */
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	if (q->fileio) {
+		dprintk(1, "streamoff: file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_internal_streamoff(q, type);
+}
 EXPORT_SYMBOL_GPL(vb2_streamoff);
 
 /**
@@ -2273,13 +2295,8 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 	struct vb2_fileio_data *fileio = q->fileio;
 
 	if (fileio) {
-		/*
-		 * Hack fileio context to enable direct calls to vb2 ioctl
-		 * interface.
-		 */
+		vb2_internal_streamoff(q, q->type);
 		q->fileio = NULL;
-
-		vb2_streamoff(q, q->type);
 		fileio->req.count = 0;
 		vb2_reqbufs(q, &fileio->req);
 		kfree(fileio);
@@ -2322,12 +2339,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	}
 	fileio = q->fileio;
 
-	/*
-	 * Hack fileio context to enable direct calls to vb2 ioctl interface.
-	 * The pointer will be restored before returning from this function.
-	 */
-	q->fileio = NULL;
-
 	index = fileio->index;
 	buf = &fileio->bufs[index];
 
@@ -2344,10 +2355,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.type = q->type;
 		fileio->b.memory = q->memory;
 		fileio->b.index = index;
-		ret = vb2_dqbuf(q, &fileio->b, nonblock);
+		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
 		dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		if (ret)
-			goto end;
+			return ret;
 		fileio->dq_count += 1;
 
 		/*
@@ -2377,8 +2388,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
 	if (ret) {
 		dprintk(3, "file io: error copying data\n");
-		ret = -EFAULT;
-		goto end;
+		return -EFAULT;
 	}
 
 	/*
@@ -2398,10 +2408,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
 		    fileio->dq_count == 1) {
 			dprintk(3, "file io: read limit reached\n");
-			/*
-			 * Restore fileio pointer and release the context.
-			 */
-			q->fileio = fileio;
 			return __vb2_cleanup_fileio(q);
 		}
 
@@ -2413,10 +2419,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.memory = q->memory;
 		fileio->b.index = index;
 		fileio->b.bytesused = buf->pos;
-		ret = vb2_qbuf(q, &fileio->b);
+		ret = vb2_internal_qbuf(q, &fileio->b);
 		dprintk(5, "file io: vb2_dbuf result: %d\n", ret);
 		if (ret)
-			goto end;
+			return ret;
 
 		/*
 		 * Buffer has been queued, update the status
@@ -2435,9 +2441,9 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 * Start streaming if required.
 		 */
 		if (!read && !q->streaming) {
-			ret = vb2_streamon(q, q->type);
+			ret = vb2_internal_streamon(q, q->type);
 			if (ret)
-				goto end;
+				return ret;
 		}
 	}
 
@@ -2446,11 +2452,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	if (ret == 0)
 		ret = count;
-end:
-	/*
-	 * Restore the fileio context and block vb2 ioctl interface.
-	 */
-	q->fileio = fileio;
 	return ret;
 }
 
-- 
1.8.4.3

