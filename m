Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56895 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938562AbcIHVhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 11/15] [media] videobuf2-v4l2.h: get kernel-doc tags from C file
Date: Thu,  8 Sep 2016 18:37:37 -0300
Message-Id: <93c5879b33b44ec86634438a43756727380c53e3.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several functions documented at the C file. Move
them to the header, as this is the one used to build the
media books.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 142 -----------------------------
 include/media/videobuf2-v4l2.h           | 151 ++++++++++++++++++++++++++++++-
 2 files changed, 150 insertions(+), 143 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 9cfbb6e4bc28..52ef8833f6b6 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -483,13 +483,6 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL(vb2_querybuf);
 
-/**
- * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
- * the memory and type values.
- * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler
- *		in driver
- */
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	int ret = vb2_verify_memory_type(q, req->memory, req->type);
@@ -498,21 +491,6 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
-/**
- * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_prepare_buf
- *		handler in driver
- *
- * Should be called from vidioc_prepare_buf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_prepare callback in the driver (if provided), in which
- *    driver-specific buffer initialization can be performed,
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_prepare_buf handler in driver.
- */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret;
@@ -528,13 +506,6 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
-/**
- * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
- * the memory and type values.
- * @q:		videobuf2 queue
- * @create:	creation parameters, passed from userspace to vidioc_create_bufs
- *		handler in driver
- */
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 {
 	unsigned requested_planes = 1;
@@ -586,23 +557,6 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
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
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret;
@@ -617,27 +571,6 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
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
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	int ret;
@@ -664,19 +597,6 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
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
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
@@ -687,21 +607,6 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
 
-/**
- * vb2_streamoff - stop streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamoff handler
- *
- * Should be called from vidioc_streamoff handler of a driver.
- * This function:
- * 1) verifies current state,
- * 2) stop streaming and dequeues any queued buffers, including those previously
- *    passed to the driver (after waiting for the driver to finish).
- *
- * This call can be used for pausing playback.
- * The return values from this function are intended to be directly returned
- * from vidioc_streamoff handler in the driver
- */
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
@@ -712,15 +617,6 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 }
 EXPORT_SYMBOL_GPL(vb2_streamoff);
 
-/**
- * vb2_expbuf() - Export a buffer as a file descriptor
- * @q:		videobuf2 queue
- * @eb:		export buffer structure passed from userspace to vidioc_expbuf
- *		handler in driver
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_expbuf handler in driver.
- */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
 	return vb2_core_expbuf(q, &eb->fd, eb->type, eb->index,
@@ -728,17 +624,6 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 }
 EXPORT_SYMBOL_GPL(vb2_expbuf);
 
-/**
- * vb2_queue_init() - initialize a videobuf2 queue
- * @q:		videobuf2 queue; this structure should be allocated in driver
- *
- * The vb2_queue structure should be allocated by the driver. The driver is
- * responsible of clearing it's content and setting initial values for some
- * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
- * for more information.
- */
 int vb2_queue_init(struct vb2_queue *q)
 {
 	/*
@@ -779,39 +664,12 @@ int vb2_queue_init(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
-/**
- * vb2_queue_release() - stop streaming, release the queue and free memory
- * @q:		videobuf2 queue
- *
- * This function stops streaming and performs necessary clean ups, including
- * freeing video buffer memory. The driver is responsible for freeing
- * the vb2_queue structure itself.
- */
 void vb2_queue_release(struct vb2_queue *q)
 {
 	vb2_core_queue_release(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
-/**
- * vb2_poll() - implements poll userspace operation
- * @q:		videobuf2 queue
- * @file:	file argument passed to the poll file operation handler
- * @wait:	wait argument passed to the poll file operation handler
- *
- * This function implements poll file operation handler for a driver.
- * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
- * be informed that the file descriptor of a video device is available for
- * reading.
- * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
- * will be reported as available for writing.
- *
- * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
- * pending events.
- *
- * The return values from this function are intended to be directly returned
- * from poll handler in driver.
- */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
 	struct video_device *vfd = video_devdata(file);
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 3cc836f76675..01b1b71fc6fd 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -49,22 +49,171 @@ struct vb2_v4l2_buffer {
 	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
+
+/**
+ * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
+ * the memory and type values.
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler
+ *		in driver
+ */
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
+/**
+ * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
+ * the memory and type values.
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
+ */
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
+
+/**
+ * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_prepare_buf
+ *		handler in driver
+ *
+ * Should be called from vidioc_prepare_buf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_prepare callback in the driver (if provided), in which
+ *    driver-specific buffer initialization can be performed,
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_prepare_buf handler in driver.
+ */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
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
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+
+/**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @eb:		export buffer structure passed from userspace to vidioc_expbuf
+ *		handler in driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
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
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
+/**
+ * vb2_streamon - start streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamon handler
+ *
+ * Should be called from vidioc_streamon handler of a driver.
+ * This function:
+ * 1) verifies current state
+ * 2) passes any previously queued buffers to the driver and starts streaming
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamon handler in the driver.
+ */
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
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
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
+/**
+ * vb2_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ *
+ * The vb2_queue structure should be allocated by the driver. The driver is
+ * responsible of clearing it's content and setting initial values for some
+ * required entries before calling this function.
+ * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * for more information.
+ */
 int __must_check vb2_queue_init(struct vb2_queue *q);
+
+/**
+ * vb2_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
+ */
 void vb2_queue_release(struct vb2_queue *q);
+
+/**
+ * vb2_poll() - implements poll userspace operation
+ * @q:		videobuf2 queue
+ * @file:	file argument passed to the poll file operation handler
+ * @wait:	wait argument passed to the poll file operation handler
+ *
+ * This function implements poll file operation handler for a driver.
+ * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
+ * be informed that the file descriptor of a video device is available for
+ * reading.
+ * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
+ * will be reported as available for writing.
+ *
+ * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
+ * pending events.
+ *
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
+ */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file,
-		poll_table *wait);
+		      poll_table *wait);
 
 /*
  * The following functions are not part of the vb2 core API, but are simple
-- 
2.7.4


