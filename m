Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56861 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936701AbcIHVhs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 07/15] [media] videobuf2-core.h: move function descriptions from c file
Date: Thu,  8 Sep 2016 18:37:33 -0300
Message-Id: <44e695d1f7fc29fa441e9a1f69180e59b08b428e.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several functions that were documented at the .c
file. As we only include the headers, we need to move them to
there, in order to have documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 254 -----------------------------
 include/media/videobuf2-core.h           | 269 +++++++++++++++++++++++++++++++
 2 files changed, 269 insertions(+), 254 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bfe85879c563..21900202ff83 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -528,10 +528,6 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	return 0;
 }
 
-/**
- * vb2_buffer_in_use() - return true if the buffer is in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
- */
 bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
 {
 	unsigned int plane;
@@ -564,16 +560,6 @@ static bool __buffers_in_use(struct vb2_queue *q)
 	return false;
 }
 
-/**
- * vb2_core_querybuf() - query video buffer information
- * @q:		videobuf queue
- * @index:	id number of the buffer
- * @pb:		buffer struct passed from userspace
- *
- * Should be called from vidioc_querybuf ioctl handler in driver.
- * The passed buffer should have been verified.
- * This function fills the relevant information for the userspace.
- */
 void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	call_void_bufop(q, fill_user_buffer, q->bufs[index], pb);
@@ -620,10 +606,6 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
 	return 0;
 }
 
-/**
- * vb2_verify_memory_type() - Check whether the memory type and buffer type
- * passed to a buffer operation are compatible with the queue.
- */
 int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type)
 {
@@ -670,30 +652,6 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 }
 EXPORT_SYMBOL(vb2_verify_memory_type);
 
-/**
- * vb2_core_reqbufs() - Initiate streaming
- * @q:		videobuf2 queue
- * @memory: memory type
- * @count: requested buffer count
- *
- * Should be called from vidioc_reqbufs ioctl handler of a driver.
- * This function:
- * 1) verifies streaming parameters passed from the userspace,
- * 2) sets up the queue,
- * 3) negotiates number of buffers and planes per buffer with the driver
- *    to be used during streaming,
- * 4) allocates internal buffer structures (struct vb2_buffer), according to
- *    the agreed parameters,
- * 5) for MMAP memory type, allocates actual video memory, using the
- *    memory handling/allocation routines provided during queue initialization
- *
- * If req->count is 0, all the memory will be freed instead.
- * If the queue has been allocated previously (by a previous vb2_reqbufs) call
- * and the queue is not busy, memory will be reallocated.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_reqbufs handler in driver.
- */
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count)
 {
@@ -819,22 +777,6 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 }
 EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
-/**
- * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
- * @q:		videobuf2 queue
- * @memory: memory type
- * @count: requested buffer count
- * @parg: parameter passed to device driver
- *
- * Should be called from vidioc_create_bufs ioctl handler of a driver.
- * This function:
- * 1) verifies parameter sanity
- * 2) calls the .queue_setup() queue operation
- * 3) performs any necessary memory allocations
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_create_bufs handler in driver.
- */
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, unsigned requested_planes,
 		const unsigned requested_sizes[])
@@ -924,14 +866,6 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 }
 EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
-/**
- * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the address is to be returned
- *
- * This function returns a kernel virtual address of a given plane if
- * such a mapping exist, NULL otherwise.
- */
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
@@ -942,17 +876,6 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
 
-/**
- * vb2_plane_cookie() - Return allocator specific cookie for the given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the cookie is to be returned
- *
- * This function returns an allocator specific cookie for a given plane if
- * available, NULL otherwise. The allocator should provide some simple static
- * inline function, which would convert this cookie to the allocator specific
- * type that can be used directly by the driver to access the buffer. This can
- * be for example physical address, pointer to scatter list or IOMMU mapping.
- */
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
@@ -962,26 +885,6 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 }
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
-/**
- * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
- * @vb:		vb2_buffer returned from the driver
- * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully,
- *		VB2_BUF_STATE_ERROR if the operation finished with an error or
- *		VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
- *		If start_streaming fails then it should return buffers with state
- *		VB2_BUF_STATE_QUEUED to put them back into the queue.
- *
- * This function should be called by the driver after a hardware operation on
- * a buffer is finished and the buffer may be returned to userspace. The driver
- * cannot use this buffer anymore until it is queued back to it by videobuf
- * by the means of buf_queue callback. Only buffers previously queued to the
- * driver by buf_queue can be passed to this function.
- *
- * While streaming a buffer can only be returned in state DONE or ERROR.
- * The start_streaming op can also return them in case the DMA engine cannot
- * be started for some reason. In that case the buffers should be returned with
- * state QUEUED.
- */
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
@@ -1040,18 +943,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 }
 EXPORT_SYMBOL_GPL(vb2_buffer_done);
 
-/**
- * vb2_discard_done() - discard all buffers marked as DONE
- * @q:		videobuf2 queue
- *
- * This function is intended to be used with suspend/resume operations. It
- * discards all 'done' buffers as they would be too old to be requested after
- * resume.
- *
- * Drivers must stop the hardware and synchronize with interrupt handlers and/or
- * delayed works before calling this function to make sure no buffer will be
- * touched by the driver and/or hardware.
- */
 void vb2_discard_done(struct vb2_queue *q)
 {
 	struct vb2_buffer *vb;
@@ -1384,22 +1275,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
 	return ret;
 }
 
-/**
- * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace
- *			to the kernel
- * @q:		videobuf2 queue
- * @index:	id number of the buffer
- * @pb:		buffer structure passed from userspace to vidioc_prepare_buf
- *		handler in driver
- *
- * Should be called from vidioc_prepare_buf ioctl handler of a driver.
- * The passed buffer should have been verified.
- * This function calls buf_prepare callback in the driver (if provided),
- * in which driver-specific buffer initialization can be performed,
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_prepare_buf handler in driver.
- */
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
@@ -1488,24 +1363,6 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-/**
- * vb2_core_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @index:	id number of the buffer
- * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
- *		in driver
- *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
- * The passed buffer should have been verified.
- * This function:
- * 1) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * 2) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
- */
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
@@ -1686,15 +1543,6 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	return ret;
 }
 
-/**
- * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2
- * @q:		videobuf2 queue
- *
- * This function will wait until all buffers that have been given to the driver
- * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
- * wait_prepare, wait_finish pair. It is intended to be called with all locks
- * taken, for example from stop_streaming() callback.
- */
 int vb2_wait_for_all_buffers(struct vb2_queue *q)
 {
 	if (!q->streaming) {
@@ -1732,28 +1580,6 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-/**
- * vb2_core_dqbuf() - Dequeue a buffer to the userspace
- * @q:		videobuf2 queue
- * @pindex:	pointer to the buffer index. May be NULL
- * @pb:		buffer structure passed from userspace to vidioc_dqbuf handler
- *		in driver
- * @nonblocking: if true, this call will not sleep waiting for a buffer if no
- *		 buffers ready for dequeuing are present. Normally the driver
- *		 would be passing (file->f_flags & O_NONBLOCK) here
- *
- * Should be called from vidioc_dqbuf ioctl handler of a driver.
- * The passed buffer should have been verified.
- * This function:
- * 1) calls buf_finish callback in the driver (if provided), in which
- *    driver can perform any additional operations that may be required before
- *    returning the buffer to userspace, such as cache sync,
- * 2) the buffer struct members are filled with relevant information for
- *    the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_dqbuf handler in driver.
- */
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 		   bool nonblocking)
 {
@@ -1917,19 +1743,6 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 }
 EXPORT_SYMBOL_GPL(vb2_core_streamon);
 
-/**
- * vb2_queue_error() - signal a fatal error on the queue
- * @q:		videobuf2 queue
- *
- * Flag that a fatal unrecoverable error has occurred and wake up all processes
- * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
- * buffers will return -EIO.
- *
- * The error flag will be cleared when cancelling the queue, either from
- * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
- * function before starting the stream, otherwise the error flag will remain set
- * until the queue is released when closing the device node.
- */
 void vb2_queue_error(struct vb2_queue *q)
 {
 	q->error = 1;
@@ -1992,19 +1805,6 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	return -EINVAL;
 }
 
-/**
- * vb2_core_expbuf() - Export a buffer as a file descriptor
- * @q:		videobuf2 queue
- * @fd:		file descriptor associated with DMABUF (set by driver) *
- * @type:	buffer type
- * @index:	id number of the buffer
- * @plane:	index of the plane to be exported, 0 for single plane queues
- * @flags:	flags for newly created file, currently only O_CLOEXEC is
- *		supported, refer to manual of open syscall for more details
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_expbuf handler in driver.
- */
 int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 		unsigned int index, unsigned int plane, unsigned int flags)
 {
@@ -2076,25 +1876,6 @@ int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 }
 EXPORT_SYMBOL_GPL(vb2_core_expbuf);
 
-/**
- * vb2_mmap() - map video buffers into application address space
- * @q:		videobuf2 queue
- * @vma:	vma passed to the mmap file operation handler in the driver
- *
- * Should be called from mmap file operation handler of a driver.
- * This function maps one plane of one of the available video buffers to
- * userspace. To map whole video memory allocated on reqbufs, this function
- * has to be called once per each plane per each buffer previously allocated.
- *
- * When the userspace application calls mmap, it passes to it an offset returned
- * to it earlier by the means of vidioc_querybuf handler. That offset acts as
- * a "cookie", which is then used to identify the plane to be mapped.
- * This function finds a plane with a matching offset and a mapping is performed
- * by the means of a provided memory operation.
- *
- * The return values from this function are intended to be directly returned
- * from the mmap handler in driver.
- */
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
@@ -2196,17 +1977,6 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
 
-/**
- * vb2_core_queue_init() - initialize a videobuf2 queue
- * @q:		videobuf2 queue; this structure should be allocated in driver
- *
- * The vb2_queue structure should be allocated by the driver. The driver is
- * responsible of clearing it's content and setting initial values for some
- * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
- * for more information.
- */
 int vb2_core_queue_init(struct vb2_queue *q)
 {
 	/*
@@ -2236,14 +2006,6 @@ EXPORT_SYMBOL_GPL(vb2_core_queue_init);
 
 static int __vb2_init_fileio(struct vb2_queue *q, int read);
 static int __vb2_cleanup_fileio(struct vb2_queue *q);
-/**
- * vb2_core_queue_release() - stop streaming, release the queue and free memory
- * @q:		videobuf2 queue
- *
- * This function stops streaming and performs necessary clean ups, including
- * freeing video buffer memory. The driver is responsible for freeing
- * the vb2_queue structure itself.
- */
 void vb2_core_queue_release(struct vb2_queue *q)
 {
 	__vb2_cleanup_fileio(q);
@@ -2254,22 +2016,6 @@ void vb2_core_queue_release(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_core_queue_release);
 
-/**
- * vb2_core_poll() - implements poll userspace operation
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
- * The return values from this function are intended to be directly returned
- * from poll handler in driver.
- */
 unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
 		poll_table *wait)
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index b6546db670ca..68f93dacb38f 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -536,35 +536,274 @@ struct vb2_queue {
 #endif
 };
 
+/**
+ * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the address is to be returned
+ *
+ * This function returns a kernel virtual address of a given plane if
+ * such a mapping exist, NULL otherwise.
+ */
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
+
+/**
+ * vb2_plane_cookie() - Return allocator specific cookie for the given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the cookie is to be returned
+ *
+ * This function returns an allocator specific cookie for a given plane if
+ * available, NULL otherwise. The allocator should provide some simple static
+ * inline function, which would convert this cookie to the allocator specific
+ * type that can be used directly by the driver to access the buffer. This can
+ * be for example physical address, pointer to scatter list or IOMMU mapping.
+ */
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 
+/**
+ * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
+ * @vb:		vb2_buffer returned from the driver
+ * @state:	either %VB2_BUF_STATE_DONE if the operation finished successfully,
+ *		%VB2_BUF_STATE_ERROR if the operation finished with an error or
+ *		%VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
+ *		If start_streaming fails then it should return buffers with state
+ *		%VB2_BUF_STATE_QUEUED to put them back into the queue.
+ *
+ * This function should be called by the driver after a hardware operation on
+ * a buffer is finished and the buffer may be returned to userspace. The driver
+ * cannot use this buffer anymore until it is queued back to it by videobuf
+ * by the means of buf_queue callback. Only buffers previously queued to the
+ * driver by buf_queue can be passed to this function.
+ *
+ * While streaming a buffer can only be returned in state DONE or ERROR.
+ * The start_streaming op can also return them in case the DMA engine cannot
+ * be started for some reason. In that case the buffers should be returned with
+ * state QUEUED.
+ */
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+
+/**
+ * vb2_discard_done() - discard all buffers marked as DONE
+ * @q:		videobuf2 queue
+ *
+ * This function is intended to be used with suspend/resume operations. It
+ * discards all 'done' buffers as they would be too old to be requested after
+ * resume.
+ *
+ * Drivers must stop the hardware and synchronize with interrupt handlers and/or
+ * delayed works before calling this function to make sure no buffer will be
+ * touched by the driver and/or hardware.
+ */
 void vb2_discard_done(struct vb2_queue *q);
+
+/**
+ * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2
+ * @q:		videobuf2 queue
+ *
+ * This function will wait until all buffers that have been given to the driver
+ * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
+ * wait_prepare, wait_finish pair. It is intended to be called with all locks
+ * taken, for example from stop_streaming() callback.
+ */
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
+/**
+ * vb2_core_querybuf() - query video buffer information
+ * @q:		videobuf queue
+ * @index:	id number of the buffer
+ * @pb:		buffer struct passed from userspace
+ *
+ * Should be called from vidioc_querybuf ioctl handler in driver.
+ * The passed buffer should have been verified.
+ * This function fills the relevant information for the userspace.
+ */
 void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
+
+/**
+ * vb2_core_reqbufs() - Initiate streaming
+ * @q:		videobuf2 queue
+ * @memory: memory type
+ * @count: requested buffer count
+ *
+ * Should be called from vidioc_reqbufs ioctl handler of a driver.
+ * This function:
+ * 1) verifies streaming parameters passed from the userspace,
+ * 2) sets up the queue,
+ * 3) negotiates number of buffers and planes per buffer with the driver
+ *    to be used during streaming,
+ * 4) allocates internal buffer structures (struct vb2_buffer), according to
+ *    the agreed parameters,
+ * 5) for MMAP memory type, allocates actual video memory, using the
+ *    memory handling/allocation routines provided during queue initialization
+ *
+ * If req->count is 0, all the memory will be freed instead.
+ * If the queue has been allocated previously (by a previous vb2_reqbufs) call
+ * and the queue is not busy, memory will be reallocated.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_reqbufs handler in driver.
+ */
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count);
+
+/**
+ * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
+ * @q:		videobuf2 queue
+ * @memory: memory type
+ * @count: requested buffer count
+ * @parg: parameter passed to device driver
+ *
+ * Should be called from vidioc_create_bufs ioctl handler of a driver.
+ * This function:
+ * 1) verifies parameter sanity
+ * 2) calls the .queue_setup() queue operation
+ * 3) performs any necessary memory allocations
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_create_bufs handler in driver.
+ */
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, unsigned requested_planes,
 		const unsigned int requested_sizes[]);
+
+/**
+ * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace
+ *			to the kernel
+ * @q:		videobuf2 queue
+ * @index:	id number of the buffer
+ * @pb:		buffer structure passed from userspace to vidioc_prepare_buf
+ *		handler in driver
+ *
+ * Should be called from vidioc_prepare_buf ioctl handler of a driver.
+ * The passed buffer should have been verified.
+ * This function calls buf_prepare callback in the driver (if provided),
+ * in which driver-specific buffer initialization can be performed,
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_prepare_buf handler in driver.
+ */
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
+
+/**
+ * vb2_core_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @index:	id number of the buffer
+ * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * The passed buffer should have been verified.
+ * This function:
+ * 1) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
+ * 2) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
+
+/**
+ * vb2_core_dqbuf() - Dequeue a buffer to the userspace
+ * @q:		videobuf2 queue
+ * @pindex:	pointer to the buffer index. May be NULL
+ * @pb:		buffer structure passed from userspace to vidioc_dqbuf handler
+ *		in driver
+ * @nonblocking: if true, this call will not sleep waiting for a buffer if no
+ *		 buffers ready for dequeuing are present. Normally the driver
+ *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *
+ * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * The passed buffer should have been verified.
+ * This function:
+ * 1) calls buf_finish callback in the driver (if provided), in which
+ *    driver can perform any additional operations that may be required before
+ *    returning the buffer to userspace, such as cache sync,
+ * 2) the buffer struct members are filled with relevant information for
+ *    the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_dqbuf handler in driver.
+ */
 int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 		   bool nonblocking);
 
 int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
 int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
 
+/**
+ * vb2_core_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @fd:		file descriptor associated with DMABUF (set by driver) *
+ * @type:	buffer type
+ * @index:	id number of the buffer
+ * @plane:	index of the plane to be exported, 0 for single plane queues
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
 int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
 		unsigned int index, unsigned int plane, unsigned int flags);
 
+/**
+ * vb2_core_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ *
+ * The vb2_queue structure should be allocated by the driver. The driver is
+ * responsible of clearing it's content and setting initial values for some
+ * required entries before calling this function.
+ * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * for more information.
+ */
 int vb2_core_queue_init(struct vb2_queue *q);
+
+/**
+ * vb2_core_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
+ */
 void vb2_core_queue_release(struct vb2_queue *q);
 
+/**
+ * vb2_queue_error() - signal a fatal error on the queue
+ * @q:		videobuf2 queue
+ *
+ * Flag that a fatal unrecoverable error has occurred and wake up all processes
+ * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
+ * buffers will return -EIO.
+ *
+ * The error flag will be cleared when cancelling the queue, either from
+ * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
+ * function before starting the stream, otherwise the error flag will remain set
+ * until the queue is released when closing the device node.
+ */
 void vb2_queue_error(struct vb2_queue *q);
 
+/**
+ * vb2_mmap() - map video buffers into application address space
+ * @q:		videobuf2 queue
+ * @vma:	vma passed to the mmap file operation handler in the driver
+ *
+ * Should be called from mmap file operation handler of a driver.
+ * This function maps one plane of one of the available video buffers to
+ * userspace. To map whole video memory allocated on reqbufs, this function
+ * has to be called once per each plane per each buffer previously allocated.
+ *
+ * When the userspace application calls mmap, it passes to it an offset returned
+ * to it earlier by the means of vidioc_querybuf handler. That offset acts as
+ * a "cookie", which is then used to identify the plane to be mapped.
+ * This function finds a plane with a matching offset and a mapping is performed
+ * by the means of a provided memory operation.
+ *
+ * The return values from this function are intended to be directly returned
+ * from the mmap handler in driver.
+ */
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 #ifndef CONFIG_MMU
 unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
@@ -573,6 +812,23 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long pgoff,
 				    unsigned long flags);
 #endif
+
+/**
+ * vb2_core_poll() - implements poll userspace operation
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
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
+ */
 unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
 		poll_table *wait);
 size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
@@ -717,7 +973,20 @@ static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
  * The following functions are not part of the vb2 core API, but are useful
  * functions for videobuf2-*.
  */
+
+/**
+ * vb2_buffer_in_use() - return true if the buffer is in use and
+ * the queue cannot be freed (by the means of REQBUFS(0)) call
+ *
+ * @vb:		buffer for which plane size should be returned
+ * @q:		videobuf queue
+ */
 bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
+
+/**
+ * vb2_verify_memory_type() - Check whether the memory type and buffer type
+ * passed to a buffer operation are compatible with the queue.
+ */
 int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type);
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
2.7.4


