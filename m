Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56885 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938389AbcIHVhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 12/15] [media] videobuf2-v4l2.h: improve documentation
Date: Thu,  8 Sep 2016 18:37:38 -0300
Message-Id: <f350fff7ade1501e64d7706923c4126774df0ada.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few issues at the documentation: fields not documented,
bad cross refrences, etc.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-v4l2.h | 52 +++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 01b1b71fc6fd..611d4f330a4c 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -25,11 +25,13 @@
 
 /**
  * struct vb2_v4l2_buffer - video buffer information for v4l2
+ *
  * @vb2_buf:	video buffer 2
  * @flags:	buffer informational flags
  * @field:	enum v4l2_field; field order of the image in the buffer
  * @timecode:	frame timecode
  * @sequence:	sequence count of this frame
+ *
  * Should contain enough information to be able to cover all the fields
  * of struct v4l2_buffer at videodev2.h
  */
@@ -53,6 +55,7 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 /**
  * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
  * the memory and type values.
+ *
  * @q:		videobuf2 queue
  * @req:	struct passed from userspace to vidioc_reqbufs handler
  *		in driver
@@ -62,6 +65,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 /**
  * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
  * the memory and type values.
+ *
  * @q:		videobuf2 queue
  * @create:	creation parameters, passed from userspace to vidioc_create_bufs
  *		handler in driver
@@ -70,15 +74,17 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
 
 /**
  * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ *
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_prepare_buf
  *		handler in driver
  *
  * Should be called from vidioc_prepare_buf ioctl handler of a driver.
  * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_prepare callback in the driver (if provided), in which
- *    driver-specific buffer initialization can be performed,
+ *
+ * #) verifies the passed buffer,
+ * #) calls buf_prepare callback in the driver (if provided), in which
+ *    driver-specific buffer initialization can be performed.
  *
  * The return values from this function are intended to be directly returned
  * from vidioc_prepare_buf handler in driver.
@@ -88,53 +94,57 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 /**
  * vb2_qbuf() - Queue a buffer from userspace
  * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ * @b:		buffer structure passed from userspace to VIDIOC_QBUF() handler
  *		in driver
  *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * Should be called from VIDIOC_QBUF() ioctl handler of a driver.
+ *
  * This function:
- * 1) verifies the passed buffer,
- * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *
+ * #) verifies the passed buffer,
+ * #) if necessary, calls buf_prepare callback in the driver (if provided), in
  *    which driver-specific buffer initialization can be performed,
- * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
+ * #) if streaming is on, queues the buffer in driver by the means of buf_queue
  *    callback for processing.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
+ * from VIDIOC_QBUF() handler in driver.
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
  * vb2_expbuf() - Export a buffer as a file descriptor
  * @q:		videobuf2 queue
- * @eb:		export buffer structure passed from userspace to vidioc_expbuf
+ * @eb:		export buffer structure passed from userspace to VIDIOC_EXPBUF()
  *		handler in driver
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_expbuf handler in driver.
+ * from VIDIOC_EXPBUF() handler in driver.
  */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 
 /**
  * vb2_dqbuf() - Dequeue a buffer to the userspace
  * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
+ * @b:		buffer structure passed from userspace to VIDIOC_DQBUF() handler
  *		in driver
  * @nonblocking: if true, this call will not sleep waiting for a buffer if no
  *		 buffers ready for dequeuing are present. Normally the driver
  *		 would be passing (file->f_flags & O_NONBLOCK) here
  *
- * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * Should be called from VIDIOC_DQBUF() ioctl handler of a driver.
+ *
  * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_finish callback in the driver (if provided), in which
+ *
+ * #) verifies the passed buffer,
+ * #) calls buf_finish callback in the driver (if provided), in which
  *    driver can perform any additional operations that may be required before
  *    returning the buffer to userspace, such as cache sync,
- * 3) the buffer struct members are filled with relevant information for
+ * #) the buffer struct members are filled with relevant information for
  *    the userspace.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_dqbuf handler in driver.
+ * from VIDIOC_DQBUF() handler in driver.
  */
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
@@ -144,7 +154,9 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
  * @type:	type argument passed from userspace to vidioc_streamon handler
  *
  * Should be called from vidioc_streamon handler of a driver.
+ *
  * This function:
+ *
  * 1) verifies current state
  * 2) passes any previously queued buffers to the driver and starts streaming
  *
@@ -159,9 +171,11 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
  * @type:	type argument passed from userspace to vidioc_streamoff handler
  *
  * Should be called from vidioc_streamoff handler of a driver.
+ *
  * This function:
- * 1) verifies current state,
- * 2) stop streaming and dequeues any queued buffers, including those previously
+ *
+ * #) verifies current state,
+ * #) stop streaming and dequeues any queued buffers, including those previously
  *    passed to the driver (after waiting for the driver to finish).
  *
  * This call can be used for pausing playback.
-- 
2.7.4


