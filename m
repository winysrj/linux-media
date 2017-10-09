Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42179 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbdJIKTm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 21/24] media: vb2-core: fix descriptions for VB2-only functions
Date: Mon,  9 Oct 2017 07:19:27 -0300
Message-Id: <775a1b7a60c08d3a7fdd3f9828e865a1433ac055.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we split VB2 into an independent streaming module and
a V4L2 one, some vb2-core functions started to have a wrong
description: they're meant to be used only by the API-specific
parts of VB2, like vb2-v4l2, as the functions that V4L2 drivers
should use are all under videobuf2-v4l2.h.

Correct their descriptions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 86 ++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 40 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ce795cd0a7cc..3165f0f9a85f 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -651,12 +651,14 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q);
  * @index:	id number of the buffer.
  * @pb:		buffer struct passed from userspace.
  *
- * Should be called from &v4l2_ioctl_ops->vidioc_querybuf ioctl handler
- * in driver.
+ * Videbuf2 core helper to implement QUERYBUF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * The passed buffer should have been verified.
  *
  * This function fills the relevant information for the userspace.
+ *
+ * Return: returns zero on success; an error code otherwise.
  */
 void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
 
@@ -666,27 +668,26 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
  * @memory:	memory type, as defined by &enum vb2_memory.
  * @count:	requested buffer count.
  *
- * Should be called from &v4l2_ioctl_ops->vidioc_reqbufs ioctl
- * handler of a driver.
+ * Videbuf2 core helper to implement REQBUF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * This function:
  *
- * #) verifies streaming parameters passed from the userspace,
- * #) sets up the queue,
+ * #) verifies streaming parameters passed from the userspace;
+ * #) sets up the queue;
  * #) negotiates number of buffers and planes per buffer with the driver
- *    to be used during streaming,
+ *    to be used during streaming;
  * #) allocates internal buffer structures (&struct vb2_buffer), according to
- *    the agreed parameters,
+ *    the agreed parameters;
  * #) for MMAP memory type, allocates actual video memory, using the
- *    memory handling/allocation routines provided during queue initialization
+ *    memory handling/allocation routines provided during queue initialization.
  *
  * If req->count is 0, all the memory will be freed instead.
  *
  * If the queue has been allocated previously by a previous vb2_core_reqbufs()
  * call and the queue is not busy, memory will be reallocated.
  *
- * The return values from this function are intended to be directly returned
- * from &v4l2_ioctl_ops->vidioc_reqbufs handler in driver.
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count);
@@ -699,17 +700,16 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
  * @requested_planes: number of planes requested.
  * @requested_sizes: array with the size of the planes.
  *
- * Should be called from &v4l2_ioctl_ops->vidioc_create_bufs ioctl handler
- * of a driver.
+ * Videbuf2 core helper to implement CREATE_BUFS operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * This function:
  *
- * #) verifies parameter sanity
- * #) calls the &vb2_ops->queue_setup queue operation
- * #) performs any necessary memory allocations
+ * #) verifies parameter sanity;
+ * #) calls the &vb2_ops->queue_setup queue operation;
+ * #) performs any necessary memory allocations.
  *
- * Return: the return values from this function are intended to be directly
- * returned from &v4l2_ioctl_ops->vidioc_create_bufs handler in driver.
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 			 unsigned int *count, unsigned int requested_planes,
@@ -723,16 +723,16 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
  * @pb:		buffer structure passed from userspace to
  *		&v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
  *
- * Should be called from &v4l2_ioctl_ops->vidioc_prepare_buf ioctl handler
- * of a driver.
+ * Videbuf2 core helper to implement PREPARE_BUF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * The passed buffer should have been verified.
  *
- * This function calls buf_prepare callback in the driver (if provided),
- * in which driver-specific buffer initialization can be performed,
+ * This function calls vb2_ops->buf_prepare callback in the driver
+ * (if provided), in which driver-specific buffer initialization can
+ * be performed.
  *
- * The return values from this function are intended to be directly returned
- * from v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
@@ -744,18 +744,18 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  * @pb:		buffer structure passed from userspace to
  *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
  *
- * Should be called from v4l2_ioctl_ops->vidioc_qbuf ioctl handler of a driver.
- * The passed buffer should have been verified.
+ * Videbuf2 core helper to implement QBUF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * This function:
  *
- * #) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
+ * #) if necessary, calls &vb2_ops->buf_prepare callback in the driver
+ *    (if provided), in which driver-specific buffer initialization can
+ *    be performed;
  * #) if streaming is on, queues the buffer in driver by the means of
  *    &vb2_ops->buf_queue callback for processing.
  *
- * The return values from this function are intended to be directly returned
- * from v4l2_ioctl_ops->vidioc_qbuf handler in driver.
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
 
@@ -769,8 +769,8 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
  *		 buffers ready for dequeuing are present. Normally the driver
  *		 would be passing (file->f_flags & O_NONBLOCK) here.
  *
- * Should be called from v4l2_ioctl_ops->vidioc_dqbuf ioctl handler of a driver.
- * The passed buffer should have been verified.
+ * Videbuf2 core helper to implement DQBUF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
  *
  * This function:
  *
@@ -780,8 +780,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
  * #) the buffer struct members are filled with relevant information for
  *    the userspace.
  *
- * The return values from this function are intended to be directly returned
- * from v4l2_ioctl_ops->vidioc_dqbuf handler in driver.
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 		   bool nonblocking);
@@ -793,8 +792,10 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
  * @type:	type of the queue to be started.
  *		For V4L2, this is defined by &enum v4l2_buf_type type.
  *
- * Should be called from &v4l2_ioctl_ops->vidioc_streamon ioctl handler of
- * a driver.
+ * Videbuf2 core helper to implement STREAMON operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
+ *
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
 
@@ -805,8 +806,10 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
  * @type:	type of the queue to be started.
  *		For V4L2, this is defined by &enum v4l2_buf_type type.
  *
- * Should be called from &v4l2_ioctl_ops->vidioc_streamon ioctl handler of
- * a driver.
+ * Videbuf2 core helper to implement STREAMOFF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
+ *
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
 
@@ -823,8 +826,11 @@ int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
  *		Currently, the only used flag is %O_CLOEXEC.
  *		is supported, refer to manual of open syscall for more details.
  *
- * The return values from this function are intended to be directly returned
- * from v4l2_ioctl_ops->vidioc_expbuf handler in driver.
+ *
+ * Videbuf2 core helper to implement EXPBUF operation. It is called
+ * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
+ *
+ * Return: returns zero on success; an error code otherwise.
  */
 int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 		unsigned int index, unsigned int plane, unsigned int flags);
-- 
2.13.6
