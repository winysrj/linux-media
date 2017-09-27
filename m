Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33432
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752128AbdI0VrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 16/17] media: videobuf2-core: improve kernel-doc markups
Date: Wed, 27 Sep 2017 18:46:59 -0300
Message-Id: <140c270cf8853087613c8e33c91bff4fb2be562f.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that nested structs are supported, change the
documentation to use it. While here, add cross-references
where pertinent and use monotonic fonts where pertinent,
using the right markup tags.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 59 +++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef9b64398c8c..5f4df060affb 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -69,7 +69,7 @@ struct vb2_threadio_data;
  *		 argument to other ops in this structure.
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
  *		 be used.
- * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
+ * @attach_dmabuf: attach a shared &struct dma_buf for a hardware operation;
  *		   used for DMABUF memory types; dev is the alloc device
  *		   dbuf is the shared dma_buf; returns ERR_PTR() on failure;
  *		   allocator private per-buffer structure on success;
@@ -153,20 +153,19 @@ struct vb2_mem_ops {
  * @length:	size of this plane (NOT the payload) in bytes
  * @min_length:	minimum required size of this plane (NOT the payload) in bytes.
  *		@length is always greater or equal to @min_length.
- * @offset:	when memory in the associated struct vb2_buffer is
- *		VB2_MEMORY_MMAP, equals the offset from the start of
+ * @m:		Union with memtype-specific data
+ * @m.offset:	when memory in the associated struct vb2_buffer is
+ *		%VB2_MEMORY_MMAP, equals the offset from the start of
  *		the device memory for this plane (or is a "cookie" that
  *		should be passed to mmap() called on the video node)
- * @userptr:	when memory is VB2_MEMORY_USERPTR, a userspace pointer
+ * @m.userptr:	when memory is %VB2_MEMORY_USERPTR, a userspace pointer
  *		pointing to this plane
- * @fd:		when memory is VB2_MEMORY_DMABUF, a userspace file
+ * @m.fd:	when memory is %VB2_MEMORY_DMABUF, a userspace file
  *		descriptor associated with this plane
- * @m:		Union with memtype-specific data (@offset, @userptr or
- *		@fd).
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *		unless there is a header in front of the data
  * Should contain enough information to be able to cover all the fields
- * of struct v4l2_plane at videodev2.h
+ * of &struct v4l2_plane at videodev2.h
  */
 struct vb2_plane {
 	void			*mem_priv;
@@ -356,7 +355,7 @@ struct vb2_buffer {
  *			driver can return an error if hardware fails, in that
  *			case all buffers that have been already given by
  *			the @buf_queue callback are to be returned by the driver
- *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED.
+ *			by calling vb2_buffer_done() with %%VB2_BUF_STATE_QUEUED.
  *			If you need a minimum number of buffers before you can
  *			start streaming, then set @min_buffers_needed in the
  *			vb2_queue structure. If that is non-zero then
@@ -366,7 +365,7 @@ struct vb2_buffer {
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from &buf_queue
  *			callback by calling vb2_buffer_done() with either
- *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
+ *			%VB2_BUF_STATE_DONE or %%VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
@@ -401,13 +400,13 @@ struct vb2_ops {
  * @verify_planes_array: Verify that a given user space structure contains
  *			enough planes for the buffer. This is called
  *			for each dequeued buffer.
- * @fill_user_buffer:	given a vb2_buffer fill in the userspace structure.
+ * @fill_user_buffer:	given a &vb2_buffer fill in the userspace structure.
  *			For V4L2 this is a struct v4l2_buffer.
- * @fill_vb2_buffer:	given a userspace structure, fill in the vb2_buffer.
+ * @fill_vb2_buffer:	given a userspace structure, fill in the &vb2_buffer.
  *			If the userspace structure is invalid, then this op
  *			will return an error.
  * @copy_timestamp:	copy the timestamp from a userspace structure to
- *			the vb2_buffer struct.
+ *			the &vb2_buffer struct.
  */
 struct vb2_buf_ops {
 	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
@@ -428,10 +427,10 @@ struct vb2_buf_ops {
  *		doesn't fill in the @alloc_devs array.
  * @dma_attrs:	DMA attributes to use for the DMA.
  * @bidirectional: when this flag is set the DMA direction for the buffers of
- *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
+ *		this queue will be overridden with %DMA_BIDIRECTIONAL direction.
  *		This is useful in cases where the hardware (firmware) writes to
- *		a buffer which is mapped as read (DMA_TO_DEVICE), or reads from
- *		buffer which is mapped for write (DMA_FROM_DEVICE) in order
+ *		a buffer which is mapped as read (%DMA_TO_DEVICE), or reads from
+ *		buffer which is mapped for write (%DMA_FROM_DEVICE) in order
  *		to satisfy some internal hardware restrictions or adds a padding
  *		needed by the processing algorithm. In case the DMA mapping is
  *		not bidirectional but the hardware (firmware) trying to access
@@ -440,10 +439,10 @@ struct vb2_buf_ops {
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
- * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
+ * @quirk_poll_must_check_waiting_for_buffers: Return %POLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
- * @lock:	pointer to a mutex that protects the vb2_queue struct. The
+ * @lock:	pointer to a mutex that protects the &vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
  *		itself, then this should be set to NULL. This lock is not used
@@ -464,7 +463,7 @@ struct vb2_buf_ops {
  * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
  *		V4L2_BUF_FLAG_TSTAMP_SRC_*
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
- *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
+ *		Typically this is 0, but it may be e.g. %GFP_DMA or %__GFP_DMA32
  *		to force the buffer allocation to a specific memory zone.
  * @min_buffers_needed: the minimum number of buffers needed before
  *		@start_streaming can be called. Used when a DMA engine
@@ -491,13 +490,13 @@ struct vb2_buf_ops {
  * @error:	a fatal error occurred on the queue
  * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
  *		buffers. Only set for capture queues if qbuf has not yet been
- *		called since poll() needs to return POLLERR in that situation.
+ *		called since poll() needs to return %POLLERR in that situation.
  * @is_multiplanar: set if buffer type is multiplanar
  * @is_output:	set if buffer type is output
  * @copy_timestamp: set if vb2-core should set timestamps
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
- *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
+ *		when a buffer with the %V4L2_BUF_FLAG_LAST is dequeued.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -569,7 +568,7 @@ struct vb2_queue {
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
+ * @vb:		&vb2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the address is to be returned
  *
  * This function returns a kernel virtual address of a given plane if
@@ -579,7 +578,7 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
 
 /**
  * vb2_plane_cookie() - Return allocator specific cookie for the given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
+ * @vb:		&vb2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the cookie is to be returned
  *
  * This function returns an allocator specific cookie for a given plane if
@@ -644,7 +643,7 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q);
  * @index:	id number of the buffer
  * @pb:		buffer struct passed from userspace
  *
- * Should be called from vidioc_querybuf ioctl handler in driver.
+ * Should be called from &vidioc_querybuf ioctl handler in driver.
  * The passed buffer should have been verified.
  * This function fills the relevant information for the userspace.
  */
@@ -656,7 +655,7 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
  * @memory: memory type
  * @count: requested buffer count
  *
- * Should be called from vidioc_reqbufs ioctl handler of a driver.
+ * Should be called from &vidioc_reqbufs ioctl handler of a driver.
  *
  * This function:
  *
@@ -664,7 +663,7 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
  * #) sets up the queue,
  * #) negotiates number of buffers and planes per buffer with the driver
  *    to be used during streaming,
- * #) allocates internal buffer structures (struct vb2_buffer), according to
+ * #) allocates internal buffer structures (&struct vb2_buffer), according to
  *    the agreed parameters,
  * #) for MMAP memory type, allocates actual video memory, using the
  *    memory handling/allocation routines provided during queue initialization
@@ -779,7 +778,7 @@ int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
  * @type:	buffer type
  * @index:	id number of the buffer
  * @plane:	index of the plane to be exported, 0 for single plane queues
- * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ * @flags:	flags for newly created file, currently only %O_CLOEXEC is
  *		supported, refer to manual of open syscall for more details
  *
  * The return values from this function are intended to be directly returned
@@ -792,7 +791,7 @@ int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
  * vb2_core_queue_init() - initialize a videobuf2 queue
  * @q:		videobuf2 queue; this structure should be allocated in driver
  *
- * The vb2_queue structure should be allocated by the driver. The driver is
+ * The &vb2_queue structure should be allocated by the driver. The driver is
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
  * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
@@ -819,8 +818,8 @@ void vb2_core_queue_release(struct vb2_queue *q);
  * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
  * buffers will return -EIO.
  *
- * The error flag will be cleared when cancelling the queue, either from
- * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
+ * The error flag will be cleared when canceling the queue, either from
+ * vb2_streamoff() or vb2_queue_release(). Drivers should thus not call this
  * function before starting the stream, otherwise the error flag will remain set
  * until the queue is released when closing the device node.
  */
-- 
2.13.5
