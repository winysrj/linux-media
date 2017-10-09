Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63999 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754116AbdJIKTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 19/24] media: vb2-core: Improve kernel-doc markups
Date: Mon,  9 Oct 2017 07:19:25 -0300
Message-Id: <acc10ada9169725a9136f9c039fe68cb0f355131.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several issues on the current markups:
- lack of cross-references;
- wrong cross-references;
- lack of a period of the end of several phrases;
- Some descriptions can be enhanced.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 376 ++++++++++++++++++++++-------------------
 1 file changed, 204 insertions(+), 172 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 0308d8439049..e145f1475ffe 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -46,7 +46,7 @@ struct vb2_fileio_data;
 struct vb2_threadio_data;
 
 /**
- * struct vb2_mem_ops - memory handling/memory allocator operations
+ * struct vb2_mem_ops - memory handling/memory allocator operations.
  * @alloc:	allocate video memory and, optionally, allocator private data,
  *		return ERR_PTR() on failure or a pointer to allocator private,
  *		per-buffer data on success; the returned private structure
@@ -146,27 +146,28 @@ struct vb2_mem_ops {
 };
 
 /**
- * struct vb2_plane - plane information
- * @mem_priv:	private data with this plane
- * @dbuf:	dma_buf - shared buffer object
+ * struct vb2_plane - plane information.
+ * @mem_priv:	private data with this plane.
+ * @dbuf:	dma_buf - shared buffer object.
  * @dbuf_mapped:	flag to show whether dbuf is mapped or not
- * @bytesused:	number of bytes occupied by data in the plane (payload)
- * @length:	size of this plane (NOT the payload) in bytes
+ * @bytesused:	number of bytes occupied by data in the plane (payload).
+ * @length:	size of this plane (NOT the payload) in bytes.
  * @min_length:	minimum required size of this plane (NOT the payload) in bytes.
  *		@length is always greater or equal to @min_length.
- * @m:		Union with memtype-specific data
+ * @m:		Union with memtype-specific data.
  * @m.offset:	when memory in the associated struct vb2_buffer is
  *		%VB2_MEMORY_MMAP, equals the offset from the start of
  *		the device memory for this plane (or is a "cookie" that
- *		should be passed to mmap() called on the video node)
+ *		should be passed to mmap() called on the video node).
  * @m.userptr:	when memory is %VB2_MEMORY_USERPTR, a userspace pointer
- *		pointing to this plane
+ *		pointing to this plane.
  * @m.fd:	when memory is %VB2_MEMORY_DMABUF, a userspace file
- *		descriptor associated with this plane
+ *		descriptor associated with this plane.
  * @data_offset:	offset in the plane to the start of data; usually 0,
- *		unless there is a header in front of the data
+ *		unless there is a header in front of the data.
+ *
  * Should contain enough information to be able to cover all the fields
- * of &struct v4l2_plane at videodev2.h
+ * of &struct v4l2_plane at videodev2.h.
  */
 struct vb2_plane {
 	void			*mem_priv;
@@ -184,12 +185,12 @@ struct vb2_plane {
 };
 
 /**
- * enum vb2_io_modes - queue access methods
- * @VB2_MMAP:		driver supports MMAP with streaming API
- * @VB2_USERPTR:	driver supports USERPTR with streaming API
- * @VB2_READ:		driver supports read() style access
- * @VB2_WRITE:		driver supports write() style access
- * @VB2_DMABUF:		driver supports DMABUF with streaming API
+ * enum vb2_io_modes - queue access methods.
+ * @VB2_MMAP:		driver supports MMAP with streaming API.
+ * @VB2_USERPTR:	driver supports USERPTR with streaming API.
+ * @VB2_READ:		driver supports read() style access.
+ * @VB2_WRITE:		driver supports write() style access.
+ * @VB2_DMABUF:		driver supports DMABUF with streaming API.
  */
 enum vb2_io_modes {
 	VB2_MMAP	= BIT(0),
@@ -200,19 +201,19 @@ enum vb2_io_modes {
 };
 
 /**
- * enum vb2_buffer_state - current video buffer state
- * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
- * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
- * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
- * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
- * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver
+ * enum vb2_buffer_state - current video buffer state.
+ * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control.
+ * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf.
+ * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver.
+ * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver.
+ * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver.
  * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
- *				in a hardware operation
+ *				in a hardware operation.
  * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
- *				not yet dequeued to userspace
+ *				not yet dequeued to userspace.
  * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
  *				has ended with an error, which will be reported
- *				to the userspace when it is dequeued
+ *				to the userspace when it is dequeued.
  */
 enum vb2_buffer_state {
 	VB2_BUF_STATE_DEQUEUED,
@@ -228,15 +229,15 @@ enum vb2_buffer_state {
 struct vb2_queue;
 
 /**
- * struct vb2_buffer - represents a video buffer
- * @vb2_queue:		the queue to which this driver belongs
- * @index:		id number of the buffer
- * @type:		buffer type
- * @memory:		the method, in which the actual data is passed
+ * struct vb2_buffer - represents a video buffer.
+ * @vb2_queue:		pointer to &struct vb2_queue with the queue to
+ *			which this driver belongs.
+ * @index:		id number of the buffer.
+ * @type:		buffer type.
+ * @memory:		the method, in which the actual data is passed.
  * @num_planes:		number of planes in the buffer
- *			on an internal driver queue
- * @planes:		private per-plane information; do not change
- * @timestamp:		frame timestamp in ns
+ *			on an internal driver queue.
+ * @timestamp:		frame timestamp in ns.
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -244,7 +245,6 @@ struct vb2_buffer {
 	unsigned int		type;
 	unsigned int		memory;
 	unsigned int		num_planes;
-	struct vb2_plane	planes[VB2_MAX_PLANES];
 	u64			timestamp;
 
 	/* private: internal use only
@@ -254,9 +254,11 @@ struct vb2_buffer {
 	 *			all buffers queued from userspace
 	 * done_entry:		entry on the list that stores all buffers ready
 	 *			to be dequeued to userspace
+	 * vb2_plane:		per-plane information; do not change
 	 */
 	enum vb2_buffer_state	state;
 
+	struct vb2_plane	planes[VB2_MAX_PLANES];
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -292,7 +294,7 @@ struct vb2_buffer {
 };
 
 /**
- * struct vb2_ops - driver-specific callbacks
+ * struct vb2_ops - driver-specific callbacks.
  *
  * @queue_setup:	called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
  *			handlers before memory allocation. It can be called
@@ -356,17 +358,17 @@ struct vb2_buffer {
  *			driver can return an error if hardware fails, in that
  *			case all buffers that have been already given by
  *			the @buf_queue callback are to be returned by the driver
- *			by calling vb2_buffer_done() with %%VB2_BUF_STATE_QUEUED.
+ *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED.
  *			If you need a minimum number of buffers before you can
- *			start streaming, then set @min_buffers_needed in the
- *			vb2_queue structure. If that is non-zero then
+ *			start streaming, then set
+ *			&vb2_queue->min_buffers_needed. If that is non-zero then
  *			@start_streaming won't be called until at least that
  *			many buffers have been queued up by userspace.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from &buf_queue
  *			callback by calling vb2_buffer_done() with either
- *			%VB2_BUF_STATE_DONE or %%VB2_BUF_STATE_ERROR; may use
+ *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
@@ -396,18 +398,18 @@ struct vb2_ops {
 };
 
 /**
- * struct vb2_buf_ops - driver-specific callbacks
+ * struct vb2_buf_ops - driver-specific callbacks.
  *
  * @verify_planes_array: Verify that a given user space structure contains
  *			enough planes for the buffer. This is called
  *			for each dequeued buffer.
  * @fill_user_buffer:	given a &vb2_buffer fill in the userspace structure.
- *			For V4L2 this is a struct v4l2_buffer.
+ *			For V4L2 this is a &struct v4l2_buffer.
  * @fill_vb2_buffer:	given a userspace structure, fill in the &vb2_buffer.
  *			If the userspace structure is invalid, then this op
  *			will return an error.
  * @copy_timestamp:	copy the timestamp from a userspace structure to
- *			the &vb2_buffer struct.
+ *			the &struct vb2_buffer.
  */
 struct vb2_buf_ops {
 	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
@@ -418,12 +420,13 @@ struct vb2_buf_ops {
 };
 
 /**
- * struct vb2_queue - a videobuf queue
+ * struct vb2_queue - a videobuf queue.
  *
  * @type:	private buffer type whose content is defined by the vb2-core
  *		caller. For example, for V4L2, it should match
- *		the types defined on enum &v4l2_buf_type
- * @io_modes:	supported io methods (see vb2_io_modes enum)
+ *		the types defined on &enum v4l2_buf_type.
+ * @io_modes:	supported io methods (see &enum vb2_io_modes).
+ * @alloc_devs:	&struct device memory type/allocator-specific per-plane device
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
  * @dma_attrs:	DMA attributes to use for the DMA.
@@ -443,7 +446,7 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return %POLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
- * @lock:	pointer to a mutex that protects the &vb2_queue struct. The
+ * @lock:	pointer to a mutex that protects the &struct vb2_queue. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
  *		itself, then this should be set to NULL. This lock is not used
@@ -454,15 +457,15 @@ struct vb2_buf_ops {
  *		drivers to easily associate an owner filehandle with the queue.
  * @ops:	driver-specific callbacks
  * @mem_ops:	memory allocator specific callbacks
- * @buf_ops:	callbacks to deliver buffer information
- *		between user-space and kernel-space
- * @drv_priv:	driver private data
+ * @buf_ops:	callbacks to deliver buffer information.
+ *		between user-space and kernel-space.
+ * @drv_priv:	driver private data.
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
- *		structure type. for example, sizeof(struct vb2_v4l2_buffer)
+ *		structure type. for example, ``sizeof(struct vb2_v4l2_buffer)``
  *		will be used for v4l2.
- * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
- *		V4L2_BUF_FLAG_TSTAMP_SRC_*
+ * @timestamp_flags: Timestamp flags; ``V4L2_BUF_FLAG_TIMESTAMP_*`` and
+ *		``V4L2_BUF_FLAG_TSTAMP_SRC_*``
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
  *		Typically this is 0, but it may be e.g. %GFP_DMA or %__GFP_DMA32
  *		to force the buffer allocation to a specific memory zone.
@@ -484,7 +487,6 @@ struct vb2_buf_ops {
  * @done_list:	list of buffers ready to be dequeued to userspace
  * @done_lock:	lock to protect done_list list
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
- * @alloc_devs:	memory type/allocator-specific per-plane device
  * @streaming:	current streaming state
  * @start_streaming_called: @start_streaming was called successfully and we
  *		started streaming.
@@ -525,6 +527,8 @@ struct vb2_queue {
 	gfp_t				gfp_flags;
 	u32				min_buffers_needed;
 
+	struct device			*alloc_devs[VB2_MAX_PLANES];
+
 	/* private: internal use only */
 	struct mutex			mmap_lock;
 	unsigned int			memory;
@@ -540,8 +544,6 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	struct device			*alloc_devs[VB2_MAX_PLANES];
-
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
@@ -568,9 +570,10 @@ struct vb2_queue {
 };
 
 /**
- * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
- * @vb:		&vb2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the address is to be returned
+ * vb2_plane_vaddr() - Return a kernel virtual address of a given plane.
+ * @vb:		pointer to &struct vb2_buffer to which the plane in
+ *		question belongs to.
+ * @plane_no:	plane number for which the address is to be returned.
  *
  * This function returns a kernel virtual address of a given plane if
  * such a mapping exist, NULL otherwise.
@@ -578,9 +581,10 @@ struct vb2_queue {
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
 
 /**
- * vb2_plane_cookie() - Return allocator specific cookie for the given plane
- * @vb:		&vb2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the cookie is to be returned
+ * vb2_plane_cookie() - Return allocator specific cookie for the given plane.
+ * @vb:		pointer to &struct vb2_buffer to which the plane in
+ *		question belongs to.
+ * @plane_no:	plane number for which the cookie is to be returned.
  *
  * This function returns an allocator specific cookie for a given plane if
  * available, NULL otherwise. The allocator should provide some simple static
@@ -591,9 +595,11 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 
 /**
- * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
- * @vb:		vb2_buffer returned from the driver
- * @state:	either %VB2_BUF_STATE_DONE if the operation finished
+ * vb2_buffer_done() - inform videobuf that an operation on a buffer
+ *	is finished.
+ * @vb:		pointer to &struct vb2_buffer to be used.
+ * @state:	state of the buffer, as defined by &enum vb2_buffer_state.
+ *		Either %VB2_BUF_STATE_DONE if the operation finished
  *		successfully, %VB2_BUF_STATE_ERROR if the operation finished
  *		with an error or %VB2_BUF_STATE_QUEUED if the driver wants to
  *		requeue buffers. If start_streaming fails then it should return
@@ -614,8 +620,8 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 
 /**
- * vb2_discard_done() - discard all buffers marked as DONE
- * @q:		videobuf2 queue
+ * vb2_discard_done() - discard all buffers marked as DONE.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * This function is intended to be used with suspend/resume operations. It
  * discards all 'done' buffers as they would be too old to be requested after
@@ -628,35 +634,40 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 
 /**
- * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2
- * @q:		videobuf2 queue
+ * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * This function will wait until all buffers that have been given to the driver
  * by &vb2_ops->buf_queue are given back to vb2 with vb2_buffer_done(). It
- * doesn't call wait_prepare()/wait_finish() pair. It is intended to be called
- * with all locks taken, for example from &vb2_ops->stop_streaming callback.
+ * doesn't call &vb2_ops->wait_prepare/&vb2_ops->wait_finish pair.
+ * It is intended to be called with all locks taken, for example from
+ * &vb2_ops->stop_streaming callback.
  */
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
 /**
- * vb2_core_querybuf() - query video buffer information
- * @q:		videobuf queue
- * @index:	id number of the buffer
- * @pb:		buffer struct passed from userspace
+ * vb2_core_querybuf() - query video buffer information.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @index:	id number of the buffer.
+ * @pb:		buffer struct passed from userspace.
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_querybuf ioctl handler
+ * in driver.
  *
- * Should be called from &vidioc_querybuf ioctl handler in driver.
  * The passed buffer should have been verified.
+ *
  * This function fills the relevant information for the userspace.
  */
 void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
- * vb2_core_reqbufs() - Initiate streaming
- * @q:		videobuf2 queue
- * @memory: memory type
- * @count: requested buffer count
+ * vb2_core_reqbufs() - Initiate streaming.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @memory:	memory type, as defined by &enum vb2_memory.
+ * @count:	requested buffer count.
  *
- * Should be called from &vidioc_reqbufs ioctl handler of a driver.
+ * Should be called from &v4l2_ioctl_ops->vidioc_reqbufs ioctl
+ * handler of a driver.
  *
  * This function:
  *
@@ -670,32 +681,35 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
  *    memory handling/allocation routines provided during queue initialization
  *
  * If req->count is 0, all the memory will be freed instead.
- * If the queue has been allocated previously (by a previous vb2_reqbufs) call
- * and the queue is not busy, memory will be reallocated.
+ *
+ * If the queue has been allocated previously by a previous vb2_core_reqbufs()
+ * call and the queue is not busy, memory will be reallocated.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_reqbufs handler in driver.
+ * from &v4l2_ioctl_ops->vidioc_reqbufs handler in driver.
  */
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count);
 
 /**
  * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
- * @q:		videobuf2 queue
- * @memory: memory type
- * @count: requested buffer count
- * @requested_planes: number of planes requested
- * @requested_sizes: array with the size of the planes
+ * @q: pointer to &struct vb2_queue with videobuf2 queue.
+ * @memory: memory type, as defined by &enum vb2_memory.
+ * @count: requested buffer count.
+ * @requested_planes: number of planes requested.
+ * @requested_sizes: array with the size of the planes.
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_create_bufs ioctl handler
+ * of a driver.
  *
- * Should be called from VIDIOC_CREATE_BUFS() ioctl handler of a driver.
  * This function:
  *
  * #) verifies parameter sanity
- * #) calls the .queue_setup() queue operation
+ * #) calls the &vb2_ops->queue_setup queue operation
  * #) performs any necessary memory allocations
  *
  * Return: the return values from this function are intended to be directly
- * returned from VIDIOC_CREATE_BUFS() handler in driver.
+ * returned from &v4l2_ioctl_ops->vidioc_create_bufs handler in driver.
  */
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 			 unsigned int *count, unsigned int requested_planes,
@@ -703,31 +717,34 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 
 /**
  * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace
- *			to the kernel
- * @q:		videobuf2 queue
- * @index:	id number of the buffer
- * @pb:		buffer structure passed from userspace to vidioc_prepare_buf
- *		handler in driver
+ *			to the kernel.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @index:	id number of the buffer.
+ * @pb:		buffer structure passed from userspace to
+ *		&v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
+ *
+ * Should be called from &v4l2_ioctl_ops->vidioc_prepare_buf ioctl handler
+ * of a driver.
  *
- * Should be called from vidioc_prepare_buf ioctl handler of a driver.
  * The passed buffer should have been verified.
+ *
  * This function calls buf_prepare callback in the driver (if provided),
  * in which driver-specific buffer initialization can be performed,
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_prepare_buf handler in driver.
+ * from v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
  */
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
  * vb2_core_qbuf() - Queue a buffer from userspace
  *
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @index:	id number of the buffer
- * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
- *		in driver
+ * @pb:		buffer structure passed from userspace to
+ *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
  *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * Should be called from v4l2_ioctl_ops->vidioc_qbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
  *
  * This function:
@@ -738,21 +755,21 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  *    &vb2_ops->buf_queue callback for processing.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
+ * from v4l2_ioctl_ops->vidioc_qbuf handler in driver.
  */
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
  * vb2_core_dqbuf() - Dequeue a buffer to the userspace
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue
  * @pindex:	pointer to the buffer index. May be NULL
- * @pb:		buffer structure passed from userspace to vidioc_dqbuf handler
- *		in driver
+ * @pb:		buffer structure passed from userspace to
+ *		v4l2_ioctl_ops->vidioc_dqbuf handler in driver.
  * @nonblocking: if true, this call will not sleep waiting for a buffer if no
  *		 buffers ready for dequeuing are present. Normally the driver
- *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *		 would be passing (file->f_flags & O_NONBLOCK) here.
  *
- * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * Should be called from v4l2_ioctl_ops->vidioc_dqbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
  *
  * This function:
@@ -764,7 +781,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
  *    the userspace.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_dqbuf handler in driver.
+ * from v4l2_ioctl_ops->vidioc_dqbuf handler in driver.
  */
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 		   bool nonblocking);
@@ -773,51 +790,57 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
 
 /**
- * vb2_core_expbuf() - Export a buffer as a file descriptor
- * @q:		videobuf2 queue
- * @fd:		file descriptor associated with DMABUF (set by driver) *
- * @type:	buffer type
- * @index:	id number of the buffer
+ * vb2_core_expbuf() - Export a buffer as a file descriptor.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @fd:		pointer to the file descriptor associated with DMABUF
+ *		(set by driver).
+ * @type:	buffer type.
+ * @index:	id number of the buffer.
  * @plane:	index of the plane to be exported, 0 for single plane queues
- * @flags:	flags for newly created file, currently only %O_CLOEXEC is
- *		supported, refer to manual of open syscall for more details
+ * @flags:	file flags for newly created file, as defined at
+ *		include/uapi/asm-generic/fcntl.h.
+ *		Currently, the only used flag is %O_CLOEXEC.
+ *		is supported, refer to manual of open syscall for more details.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_expbuf handler in driver.
+ * from v4l2_ioctl_ops->vidioc_expbuf handler in driver.
  */
 int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 		unsigned int index, unsigned int plane, unsigned int flags);
 
 /**
  * vb2_core_queue_init() - initialize a videobuf2 queue
- * @q:		videobuf2 queue; this structure should be allocated in driver
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ *		This structure should be allocated in driver
  *
  * The &vb2_queue structure should be allocated by the driver. The driver is
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
- * for more information.
+ *
+ * .. note::
+ *
+ *    The following fields at @q should be set before calling this function:
+ *    &vb2_queue->ops, &vb2_queue->mem_ops, &vb2_queue->type.
  */
 int vb2_core_queue_init(struct vb2_queue *q);
 
 /**
  * vb2_core_queue_release() - stop streaming, release the queue and free memory
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * This function stops streaming and performs necessary clean ups, including
  * freeing video buffer memory. The driver is responsible for freeing
- * the vb2_queue structure itself.
+ * the &struct vb2_queue itself.
  */
 void vb2_core_queue_release(struct vb2_queue *q);
 
 /**
  * vb2_queue_error() - signal a fatal error on the queue
- * @q:		videobuf2 queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * Flag that a fatal unrecoverable error has occurred and wake up all processes
- * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
- * buffers will return -EIO.
+ * waiting on the queue. Polling will now set %POLLERR and queuing and dequeuing
+ * buffers will return %-EIO.
  *
  * The error flag will be cleared when canceling the queue, either from
  * vb2_streamoff() or vb2_queue_release(). Drivers should thus not call this
@@ -827,9 +850,10 @@ void vb2_core_queue_release(struct vb2_queue *q);
 void vb2_queue_error(struct vb2_queue *q);
 
 /**
- * vb2_mmap() - map video buffers into application address space
- * @q:		videobuf2 queue
- * @vma:	vma passed to the mmap file operation handler in the driver
+ * vb2_mmap() - map video buffers into application address space.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @vma:	pointer to &struct vm_area_struct with the vma passed
+ *		to the mmap file operation handler in the driver.
  *
  * Should be called from mmap file operation handler of a driver.
  * This function maps one plane of one of the available video buffers to
@@ -837,8 +861,10 @@ void vb2_queue_error(struct vb2_queue *q);
  * has to be called once per each plane per each buffer previously allocated.
  *
  * When the userspace application calls mmap, it passes to it an offset returned
- * to it earlier by the means of vidioc_querybuf handler. That offset acts as
- * a "cookie", which is then used to identify the plane to be mapped.
+ * to it earlier by the means of &v4l2_ioctl_ops->vidioc_querybuf handler.
+ * That offset acts as a "cookie", which is then used to identify the plane
+ * to be mapped.
+ *
  * This function finds a plane with a matching offset and a mapping is performed
  * by the means of a provided memory operation.
  *
@@ -856,10 +882,12 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 #endif
 
 /**
- * vb2_core_poll() - implements poll userspace operation
- * @q:		videobuf2 queue
- * @file:	file argument passed to the poll file operation handler
- * @wait:	wait argument passed to the poll file operation handler
+ * vb2_core_poll() - implements poll userspace operation.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @file:	&struct file argument passed to the poll
+ *		file operation handler.
+ * @wait:	&poll_table wait argument passed to the poll
+ *		file operation handler.
  *
  * This function implements poll file operation handler for a driver.
  * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
@@ -880,10 +908,10 @@ size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 
 /**
- * typedef vb2_thread_fnc - callback function for use with vb2_thread
+ * typedef vb2_thread_fnc - callback function for use with vb2_thread.
  *
- * @vb: pointer to struct &vb2_buffer
- * @priv: pointer to a private pointer
+ * @vb: pointer to struct &vb2_buffer.
+ * @priv: pointer to a private data.
  *
  * This is called whenever a buffer is dequeued in the thread.
  */
@@ -891,13 +919,13 @@ typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
 
 /**
  * vb2_thread_start() - start a thread for the given queue.
- * @q:		videobuf queue
- * @fnc:	callback function
- * @priv:	priv pointer passed to the callback function
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @fnc:	&vb2_thread_fnc callback function.
+ * @priv:	priv pointer passed to the callback function.
  * @thread_name:the name of the thread. This will be prefixed with "vb2-".
  *
  * This starts a thread that will queue and dequeue until an error occurs
- * or @vb2_thread_stop is called.
+ * or vb2_thread_stop() is called.
  *
  * .. attention::
  *
@@ -910,13 +938,13 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 
 /**
  * vb2_thread_stop() - stop the thread for the given queue.
- * @q:		videobuf queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  */
 int vb2_thread_stop(struct vb2_queue *q);
 
 /**
- * vb2_is_streaming() - return streaming status of the queue
- * @q:		videobuf queue
+ * vb2_is_streaming() - return streaming status of the queue.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  */
 static inline bool vb2_is_streaming(struct vb2_queue *q)
 {
@@ -925,15 +953,16 @@ static inline bool vb2_is_streaming(struct vb2_queue *q)
 
 /**
  * vb2_fileio_is_active() - return true if fileio is active.
- * @q:		videobuf queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * This returns true if read() or write() is used to stream the data
  * as opposed to stream I/O. This is almost never an important distinction,
  * except in rare cases. One such case is that using read() or write() to
- * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
+ * stream a format using %V4L2_FIELD_ALTERNATE is not allowed since there
  * is no way you can pass the field information of each buffer to/from
  * userspace. A driver that supports this field format should check for
- * this in the queue_setup op and reject it if this function returns true.
+ * this in the &vb2_ops->queue_setup op and reject it if this function returns
+ * true.
  */
 static inline bool vb2_fileio_is_active(struct vb2_queue *q)
 {
@@ -941,8 +970,8 @@ static inline bool vb2_fileio_is_active(struct vb2_queue *q)
 }
 
 /**
- * vb2_is_busy() - return busy status of the queue
- * @q:		videobuf queue
+ * vb2_is_busy() - return busy status of the queue.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  *
  * This function checks if queue has any buffers allocated.
  */
@@ -952,8 +981,8 @@ static inline bool vb2_is_busy(struct vb2_queue *q)
 }
 
 /**
- * vb2_get_drv_priv() - return driver private data associated with the queue
- * @q:		videobuf queue
+ * vb2_get_drv_priv() - return driver private data associated with the queue.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  */
 static inline void *vb2_get_drv_priv(struct vb2_queue *q)
 {
@@ -961,10 +990,11 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
 }
 
 /**
- * vb2_set_plane_payload() - set bytesused for the plane plane_no
- * @vb:		buffer for which plane payload should be set
- * @plane_no:	plane number for which payload should be set
- * @size:	payload in bytes
+ * vb2_set_plane_payload() - set bytesused for the plane @plane_no.
+ * @vb:		pointer to &struct vb2_buffer to which the plane in
+ *		question belongs to.
+ * @plane_no:	plane number for which payload should be set.
+ * @size:	payload in bytes.
  */
 static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
@@ -975,8 +1005,9 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 
 /**
  * vb2_get_plane_payload() - get bytesused for the plane plane_no
- * @vb:		buffer for which plane payload should be set
- * @plane_no:	plane number for which payload should be set
+ * @vb:		pointer to &struct vb2_buffer to which the plane in
+ *		question belongs to.
+ * @plane_no:	plane number for which payload should be set.
  */
 static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no)
@@ -987,9 +1018,10 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 }
 
 /**
- * vb2_plane_size() - return plane size in bytes
- * @vb:		buffer for which plane size should be returned
- * @plane_no:	plane number for which size should be returned
+ * vb2_plane_size() - return plane size in bytes.
+ * @vb:		pointer to &struct vb2_buffer to which the plane in
+ *		question belongs to.
+ * @plane_no:	plane number for which size should be returned.
  */
 static inline unsigned long
 vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
@@ -1000,8 +1032,8 @@ vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 }
 
 /**
- * vb2_start_streaming_called() - return streaming status of driver
- * @q:		videobuf queue
+ * vb2_start_streaming_called() - return streaming status of driver.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  */
 static inline bool vb2_start_streaming_called(struct vb2_queue *q)
 {
@@ -1009,8 +1041,8 @@ static inline bool vb2_start_streaming_called(struct vb2_queue *q)
 }
 
 /**
- * vb2_clear_last_buffer_dequeued() - clear last buffer dequeued flag of queue
- * @q:		videobuf queue
+ * vb2_clear_last_buffer_dequeued() - clear last buffer dequeued flag of queue.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  */
 static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
 {
@@ -1024,10 +1056,10 @@ static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
 
 /**
  * vb2_buffer_in_use() - return true if the buffer is in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
+ * the queue cannot be freed (by the means of VIDIOC_REQBUFS(0)) call.
  *
- * @vb:		buffer for which plane size should be returned
- * @q:		videobuf queue
+ * @vb:		buffer for which plane size should be returned.
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  */
 bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
 
@@ -1035,11 +1067,11 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
  * vb2_verify_memory_type() - Check whether the memory type and buffer type
  * passed to a buffer operation are compatible with the queue.
  *
- * @q:		videobuf queue
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @memory:	memory model, as defined by enum &vb2_memory.
  * @type:	private buffer type whose content is defined by the vb2-core
  *		caller. For example, for V4L2, it should match
- *		the types defined on enum &v4l2_buf_type
+ *		the types defined on enum &v4l2_buf_type.
  */
 int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type);
-- 
2.13.6
