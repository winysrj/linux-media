Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57974 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754091AbdJIKTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 22/24] media: vb2: add cross references at memops and v4l2 kernel-doc markups
Date: Mon,  9 Oct 2017 07:19:28 -0300
Message-Id: <c6f9864e268c38c02724ff2d515a492f5b78a00b.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add cross-references where needed and add periods at the end of
each kernel-doc paragraph, in order to make it coherent with other
VB2 descriptions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-memops.h |   8 +--
 include/media/videobuf2-v4l2.h   | 112 +++++++++++++++++++++------------------
 2 files changed, 63 insertions(+), 57 deletions(-)

diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index a6ed091b79ce..4b5b84f93538 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -19,11 +19,11 @@
 #include <linux/refcount.h>
 
 /**
- * struct vb2_vmarea_handler - common vma refcount tracking handler
+ * struct vb2_vmarea_handler - common vma refcount tracking handler.
  *
- * @refcount:	pointer to refcount entry in the buffer
- * @put:	callback to function that decreases buffer refcount
- * @arg:	argument for @put callback
+ * @refcount:	pointer to &refcount_t entry in the buffer.
+ * @put:	callback to function that decreases buffer refcount.
+ * @arg:	argument for @put callback.
  */
 struct vb2_vmarea_handler {
 	refcount_t		*refcount;
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 036127c54bbf..d38829a9dab3 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -24,16 +24,17 @@
 #endif
 
 /**
- * struct vb2_v4l2_buffer - video buffer information for v4l2
+ * struct vb2_v4l2_buffer - video buffer information for v4l2.
  *
- * @vb2_buf:	video buffer 2
- * @flags:	buffer informational flags
- * @field:	enum v4l2_field; field order of the image in the buffer
- * @timecode:	frame timecode
- * @sequence:	sequence count of this frame
+ * @vb2_buf:	embedded struct &vb2_buffer.
+ * @flags:	buffer informational flags.
+ * @field:	field order of the image in the buffer, as defined by
+ *		&enum v4l2_field.
+ * @timecode:	frame timecode.
+ * @sequence:	sequence count of this frame.
  *
  * Should contain enough information to be able to cover all the fields
- * of struct v4l2_buffer at videodev2.h
+ * of &struct v4l2_buffer at ``videodev2.h``.
  */
 struct vb2_v4l2_buffer {
 	struct vb2_buffer	vb2_buf;
@@ -56,9 +57,9 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
  * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
  * the memory and type values.
  *
- * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler
- *		in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @req:	&struct v4l2_requestbuffers passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_reqbufs handler in driver.
  */
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
@@ -66,94 +67,99 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
  * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
  * the memory and type values.
  *
- * @q:		videobuf2 queue
- * @create:	creation parameters, passed from userspace to vidioc_create_bufs
- *		handler in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @create:	creation parameters, passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_create_bufs handler in driver
  */
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
 
 /**
  * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
  *
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_prepare_buf
- *		handler in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @b:		buffer structure passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_prepare_buf handler in driver
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_prepare_buf ioctl handler
+ * of a driver.
  *
- * Should be called from vidioc_prepare_buf ioctl handler of a driver.
  * This function:
  *
  * #) verifies the passed buffer,
- * #) calls buf_prepare callback in the driver (if provided), in which
- *    driver-specific buffer initialization can be performed.
+ * #) calls &vb2_ops->buf_prepare callback in the driver (if provided),
+ *    in which driver-specific buffer initialization can be performed.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_prepare_buf handler in driver.
+ * from &v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
  * vb2_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to VIDIOC_QBUF() handler
- *		in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @b:		buffer structure passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_qbuf handler in driver
  *
- * Should be called from VIDIOC_QBUF() ioctl handler of a driver.
+ * Should be called from &v4l2_ioctl_ops->vidioc_qbuf handler of a driver.
  *
  * This function:
  *
- * #) verifies the passed buffer,
- * #) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * #) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
+ * #) verifies the passed buffer;
+ * #) if necessary, calls &vb2_ops->buf_prepare callback in the driver
+ *    (if provided), in which driver-specific buffer initialization can
+ *    be performed;
+ * #) if streaming is on, queues the buffer in driver by the means of
+ *    &vb2_ops->buf_queue callback for processing.
  *
  * The return values from this function are intended to be directly returned
- * from VIDIOC_QBUF() handler in driver.
+ * from &v4l2_ioctl_ops->vidioc_qbuf handler in driver.
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
  * vb2_expbuf() - Export a buffer as a file descriptor
- * @q:		videobuf2 queue
- * @eb:		export buffer structure passed from userspace to VIDIOC_EXPBUF()
- *		handler in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @eb:		export buffer structure passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_expbuf handler in driver
  *
  * The return values from this function are intended to be directly returned
- * from VIDIOC_EXPBUF() handler in driver.
+ * from &v4l2_ioctl_ops->vidioc_expbuf handler in driver.
  */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 
 /**
  * vb2_dqbuf() - Dequeue a buffer to the userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to VIDIOC_DQBUF() handler
- *		in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @b:		buffer structure passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_dqbuf handler in driver
  * @nonblocking: if true, this call will not sleep waiting for a buffer if no
  *		 buffers ready for dequeuing are present. Normally the driver
- *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *		 would be passing (&file->f_flags & %O_NONBLOCK) here
  *
- * Should be called from VIDIOC_DQBUF() ioctl handler of a driver.
+ * Should be called from &v4l2_ioctl_ops->vidioc_dqbuf ioctl handler
+ * of a driver.
  *
  * This function:
  *
- * #) verifies the passed buffer,
- * #) calls buf_finish callback in the driver (if provided), in which
+ * #) verifies the passed buffer;
+ * #) calls &vb2_ops->buf_finish callback in the driver (if provided), in which
  *    driver can perform any additional operations that may be required before
- *    returning the buffer to userspace, such as cache sync,
+ *    returning the buffer to userspace, such as cache sync;
  * #) the buffer struct members are filled with relevant information for
  *    the userspace.
  *
  * The return values from this function are intended to be directly returned
- * from VIDIOC_DQBUF() handler in driver.
+ * from &v4l2_ioctl_ops->vidioc_dqbuf handler in driver.
  */
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 /**
  * vb2_streamon - start streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamon handler
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @type:	type argument passed from userspace to vidioc_streamon handler,
+ * 		as defined by &enum v4l2_buf_type.
  *
- * Should be called from vidioc_streamon handler of a driver.
+ * Should be called from &v4l2_ioctl_ops->vidioc_streamon handler of a driver.
  *
  * This function:
  *
@@ -161,13 +167,13 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
  * 2) passes any previously queued buffers to the driver and starts streaming
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_streamon handler in the driver.
+ * from &v4l2_ioctl_ops->vidioc_streamon handler in the driver.
  */
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
 
 /**
  * vb2_streamoff - stop streaming
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @type:	type argument passed from userspace to vidioc_streamoff handler
  *
  * Should be called from vidioc_streamoff handler of a driver.
@@ -186,7 +192,7 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
 /**
  * vb2_queue_init() - initialize a videobuf2 queue
- * @q:		videobuf2 queue; this structure should be allocated in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * The vb2_queue structure should be allocated by the driver. The driver is
  * responsible of clearing it's content and setting initial values for some
@@ -199,7 +205,7 @@ int __must_check vb2_queue_init(struct vb2_queue *q);
 
 /**
  * vb2_queue_release() - stop streaming, release the queue and free memory
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * This function stops streaming and performs necessary clean ups, including
  * freeing video buffer memory. The driver is responsible for freeing
@@ -209,7 +215,7 @@ void vb2_queue_release(struct vb2_queue *q);
 
 /**
  * vb2_poll() - implements poll userspace operation
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @file:	file argument passed to the poll file operation handler
  * @wait:	wait argument passed to the poll file operation handler
  *
@@ -271,7 +277,7 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 /**
  * vb2_ops_wait_prepare - helper function to lock a struct &vb2_queue
  *
- * @vq: pointer to struct vb2_queue
+ * @vq: pointer to &struct vb2_queue
  *
  * ..note:: only use if vq->lock is non-NULL.
  */
@@ -280,7 +286,7 @@ void vb2_ops_wait_prepare(struct vb2_queue *vq);
 /**
  * vb2_ops_wait_finish - helper function to unlock a struct &vb2_queue
  *
- * @vq: pointer to struct vb2_queue
+ * @vq: pointer to &struct vb2_queue
  *
  * ..note:: only use if vq->lock is non-NULL.
  */
-- 
2.13.6
