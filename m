Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936642AbcIHVhs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 09/15] [media] videobuf2-core.h: improve documentation
Date: Thu,  8 Sep 2016 18:37:35 -0300
Message-Id: <4ca485c3460800b661447cc23f095047e123cb3c.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several small issues with the documentation. Fix them,
in order to avoid producing warnings.

While here, also make checkpatch.pl happy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 143 ++++++++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 58 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 65eeca83687a..9a144f2d9083 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -49,13 +49,13 @@ struct vb2_threadio_data;
  * @alloc:	allocate video memory and, optionally, allocator private data,
  *		return ERR_PTR() on failure or a pointer to allocator private,
  *		per-buffer data on success; the returned private structure
- *		will then be passed as buf_priv argument to other ops in this
+ *		will then be passed as @buf_priv argument to other ops in this
  *		structure. Additional gfp_flags to use when allocating the
  *		are also passed to this operation. These flags are from the
  *		gfp_flags field of vb2_queue.
  * @put:	inform the allocator that the buffer will no longer be used;
  *		usually will result in the allocator freeing the buffer (if
- *		no other users of this buffer are present); the buf_priv
+ *		no other users of this buffer are present); the @buf_priv
  *		argument is the allocator private per-buffer structure
  *		previously returned from the alloc callback.
  * @get_dmabuf: acquire userspace memory for a hardware operation; used for
@@ -65,7 +65,7 @@ struct vb2_threadio_data;
  *		 videobuf layer when queuing a video buffer of USERPTR type;
  *		 should return an allocator private per-buffer structure
  *		 associated with the buffer on success, ERR_PTR() on failure;
- *		 the returned private structure will then be passed as buf_priv
+ *		 the returned private structure will then be passed as @buf_priv
  *		 argument to other ops in this structure.
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
  *		 be used.
@@ -75,7 +75,7 @@ struct vb2_threadio_data;
  *		   allocator private per-buffer structure on success;
  *		   this needs to be used for further accesses to the buffer.
  * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
- *		   buffer is no longer used; the buf_priv argument is the
+ *		   buffer is no longer used; the @buf_priv argument is the
  *		   allocator private per-buffer structure previously returned
  *		   from the attach_dmabuf callback.
  * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
@@ -109,11 +109,13 @@ struct vb2_threadio_data;
  *
  *    #) Required ops for read/write access types: alloc, put, num_users, vaddr.
  *
- *    #) Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf, unmap_dmabuf.
+ *    #) Required ops for DMABUF types: attach_dmabuf, detach_dmabuf,
+ *       map_dmabuf, unmap_dmabuf.
  */
 struct vb2_mem_ops {
 	void		*(*alloc)(struct device *dev, unsigned long attrs,
-				  unsigned long size, enum dma_data_direction dma_dir,
+				  unsigned long size,
+				  enum dma_data_direction dma_dir,
 				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
@@ -126,7 +128,8 @@ struct vb2_mem_ops {
 	void		(*prepare)(void *buf_priv);
 	void		(*finish)(void *buf_priv);
 
-	void		*(*attach_dmabuf)(struct device *dev, struct dma_buf *dbuf,
+	void		*(*attach_dmabuf)(struct device *dev,
+					  struct dma_buf *dbuf,
 					  unsigned long size,
 					  enum dma_data_direction dma_dir);
 	void		(*detach_dmabuf)(void *buf_priv);
@@ -291,7 +294,7 @@ struct vb2_buffer {
 /**
  * struct vb2_ops - driver-specific callbacks
  *
- * @queue_setup:	called from %VIDIOC_REQBUFS and %VIDIOC_CREATE_BUFS
+ * @queue_setup:	called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
  *			handlers before memory allocation. It can be called
  *			twice: if the original number of requested buffers
  *			could not be allocated, then it will be called a
@@ -302,11 +305,11 @@ struct vb2_buffer {
  *			buffer in \*num_planes, the size of each plane should be
  *			set in the sizes\[\] array and optional per-plane
  *			allocator specific device in the alloc_devs\[\] array.
- *			When called from %VIDIOC_REQBUFS, \*num_planes == 0, the
- *			driver has to use the currently configured format to
+ *			When called from VIDIOC_REQBUFS,() \*num_planes == 0,
+ *			the driver has to use the currently configured format to
  *			determine the plane sizes and \*num_buffers is the total
  *			number of buffers that are being allocated. When called
- *			from %VIDIOC_CREATE_BUFS, \*num_planes != 0 and it
+ *			from VIDIOC_CREATE_BUFS,() \*num_planes != 0 and it
  *			describes the requested number of planes and sizes\[\]
  *			contains the requested plane sizes. If either
  *			\*num_planes or the requested sizes are invalid callback
@@ -325,11 +328,11 @@ struct vb2_buffer {
  *			initialization failure (return != 0) will prevent
  *			queue setup from completing successfully; optional.
  * @buf_prepare:	called every time the buffer is queued from userspace
- *			and from the %VIDIOC_PREPARE_BUF ioctl; drivers may
+ *			and from the VIDIOC_PREPARE_BUF() ioctl; drivers may
  *			perform any initialization required before each
  *			hardware operation in this callback; drivers can
  *			access/modify the buffer here as it is still synced for
- *			the CPU; drivers that support %VIDIOC_CREATE_BUFS must
+ *			the CPU; drivers that support VIDIOC_CREATE_BUFS() must
  *			also validate the buffer size; if an error is returned,
  *			the buffer will not be queued in driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
@@ -353,24 +356,25 @@ struct vb2_buffer {
  *			driver can return an error if hardware fails, in that
  *			case all buffers that have been already given by
  *			the @buf_queue callback are to be returned by the driver
- *			by calling @vb2_buffer_done\(%VB2_BUF_STATE_QUEUED\).
+ *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED.
  *			If you need a minimum number of buffers before you can
  *			start streaming, then set @min_buffers_needed in the
  *			vb2_queue structure. If that is non-zero then
- *			start_streaming won't be called until at least that
+ *			@start_streaming won't be called until at least that
  *			many buffers have been queued up by userspace.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from &buf_queue
- *			callback by calling @vb2_buffer_done\(\) with either
+ *			callback by calling vb2_buffer_done() with either
  *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
- *			it is allways called after calling %VIDIOC_STREAMON ioctl;
- *			might be called before start_streaming callback if user
- *			pre-queued buffers before calling %VIDIOC_STREAMON.
+ *			it is allways called after calling VIDIOC_STREAMON()
+ *			ioctl; might be called before @start_streaming callback
+ *			if user pre-queued buffers before calling
+ *			VIDIOC_STREAMON().
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q,
@@ -418,7 +422,7 @@ struct vb2_buf_ops {
  *
  * @type:	private buffer type whose content is defined by the vb2-core
  *		caller. For example, for V4L2, it should match
- *		the V4L2_BUF_TYPE_* in include/uapi/linux/videodev2.h
+ *		the types defined on enum &v4l2_buf_type
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
@@ -453,12 +457,12 @@ struct vb2_buf_ops {
  *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
  *		to force the buffer allocation to a specific memory zone.
  * @min_buffers_needed: the minimum number of buffers needed before
- *		start_streaming() can be called. Used when a DMA engine
+ *		@start_streaming can be called. Used when a DMA engine
  *		cannot be started unless at least this number of buffers
  *		have been queued into the driver.
  */
 /*
- * Private elements (won't appear at the DocBook):
+ * Private elements (won't appear at the uAPI book):
  * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
  * @memory:	current memory type used
  * @bufs:	videobuf buffer structures
@@ -471,7 +475,7 @@ struct vb2_buf_ops {
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
  * @alloc_devs:	memory type/allocator-specific per-plane device
  * @streaming:	current streaming state
- * @start_streaming_called: start_streaming() was called successfully and we
+ * @start_streaming_called: @start_streaming was called successfully and we
  *		started streaming.
  * @error:	a fatal error occurred on the queue
  * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
@@ -576,17 +580,18 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 /**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
  * @vb:		vb2_buffer returned from the driver
- * @state:	either %VB2_BUF_STATE_DONE if the operation finished successfully,
- *		%VB2_BUF_STATE_ERROR if the operation finished with an error or
- *		%VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
- *		If start_streaming fails then it should return buffers with state
- *		%VB2_BUF_STATE_QUEUED to put them back into the queue.
+ * @state:	either %VB2_BUF_STATE_DONE if the operation finished
+ *		successfully, %VB2_BUF_STATE_ERROR if the operation finished
+ *		with an error or %VB2_BUF_STATE_QUEUED if the driver wants to
+ *		requeue buffers. If start_streaming fails then it should return
+ *		buffers with state %VB2_BUF_STATE_QUEUED to put them back into
+ *		the queue.
  *
  * This function should be called by the driver after a hardware operation on
  * a buffer is finished and the buffer may be returned to userspace. The driver
  * cannot use this buffer anymore until it is queued back to it by videobuf
- * by the means of buf_queue callback. Only buffers previously queued to the
- * driver by buf_queue can be passed to this function.
+ * by the means of &vb2_ops->buf_queue callback. Only buffers previously queued
+ * to the driver by &vb2_ops->buf_queue can be passed to this function.
  *
  * While streaming a buffer can only be returned in state DONE or ERROR.
  * The start_streaming op can also return them in case the DMA engine cannot
@@ -614,9 +619,9 @@ void vb2_discard_done(struct vb2_queue *q);
  * @q:		videobuf2 queue
  *
  * This function will wait until all buffers that have been given to the driver
- * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
- * wait_prepare, wait_finish pair. It is intended to be called with all locks
- * taken, for example from stop_streaming() callback.
+ * by &vb2_ops->buf_queue are given back to vb2 with vb2_buffer_done(). It
+ * doesn't call wait_prepare()/wait_finish() pair. It is intended to be called
+ * with all locks taken, for example from &vb2_ops->stop_streaming callback.
  */
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
@@ -639,14 +644,16 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
  * @count: requested buffer count
  *
  * Should be called from vidioc_reqbufs ioctl handler of a driver.
+ *
  * This function:
- * 1) verifies streaming parameters passed from the userspace,
- * 2) sets up the queue,
- * 3) negotiates number of buffers and planes per buffer with the driver
+ *
+ * #) verifies streaming parameters passed from the userspace,
+ * #) sets up the queue,
+ * #) negotiates number of buffers and planes per buffer with the driver
  *    to be used during streaming,
- * 4) allocates internal buffer structures (struct vb2_buffer), according to
+ * #) allocates internal buffer structures (struct vb2_buffer), according to
  *    the agreed parameters,
- * 5) for MMAP memory type, allocates actual video memory, using the
+ * #) for MMAP memory type, allocates actual video memory, using the
  *    memory handling/allocation routines provided during queue initialization
  *
  * If req->count is 0, all the memory will be freed instead.
@@ -664,20 +671,22 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
  * @q:		videobuf2 queue
  * @memory: memory type
  * @count: requested buffer count
- * @parg: parameter passed to device driver
+ * @requested_planes: number of planes requested
+ * @requested_sizes: array with the size of the planes
  *
- * Should be called from vidioc_create_bufs ioctl handler of a driver.
+ * Should be called from VIDIOC_CREATE_BUFS() ioctl handler of a driver.
  * This function:
- * 1) verifies parameter sanity
- * 2) calls the .queue_setup() queue operation
- * 3) performs any necessary memory allocations
  *
- * The return values from this function are intended to be directly returned
- * from vidioc_create_bufs handler in driver.
+ * #) verifies parameter sanity
+ * #) calls the .queue_setup() queue operation
+ * #) performs any necessary memory allocations
+ *
+ * Return: the return values from this function are intended to be directly
+ * returned from VIDIOC_CREATE_BUFS() handler in driver.
  */
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
-		unsigned int *count, unsigned requested_planes,
-		const unsigned int requested_sizes[]);
+			 unsigned int *count, unsigned int requested_planes,
+			 const unsigned int requested_sizes[]);
 
 /**
  * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace
@@ -699,6 +708,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 
 /**
  * vb2_core_qbuf() - Queue a buffer from userspace
+ *
  * @q:		videobuf2 queue
  * @index:	id number of the buffer
  * @pb:		buffer structure passed from userspace to vidioc_qbuf handler
@@ -706,11 +716,13 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
  *
  * Should be called from vidioc_qbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
+ *
  * This function:
- * 1) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *
+ * #) if necessary, calls buf_prepare callback in the driver (if provided), in
  *    which driver-specific buffer initialization can be performed,
- * 2) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
+ * #) if streaming is on, queues the buffer in driver by the means of
+ *    &vb2_ops->buf_queue callback for processing.
  *
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
@@ -729,11 +741,13 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
  *
  * Should be called from vidioc_dqbuf ioctl handler of a driver.
  * The passed buffer should have been verified.
+ *
  * This function:
- * 1) calls buf_finish callback in the driver (if provided), in which
+ *
+ * #) calls buf_finish callback in the driver (if provided), in which
  *    driver can perform any additional operations that may be required before
  *    returning the buffer to userspace, such as cache sync,
- * 2) the buffer struct members are filled with relevant information for
+ * #) the buffer struct members are filled with relevant information for
  *    the userspace.
  *
  * The return values from this function are intended to be directly returned
@@ -819,6 +833,7 @@ void vb2_queue_error(struct vb2_queue *q);
  * from the mmap handler in driver.
  */
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
+
 #ifndef CONFIG_MMU
 unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long addr,
@@ -844,14 +859,18 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
  * from poll handler in driver.
  */
 unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
-		poll_table *wait);
+			   poll_table *wait);
+
 size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 
-/*
- * vb2_thread_fnc - callback function for use with vb2_thread
+/**
+ * typedef vb2_thread_fnc - callback function for use with vb2_thread
+ *
+ * @vb: pointer to struct &vb2_buffer
+ * @priv: pointer to a private pointer
  *
  * This is called whenever a buffer is dequeued in the thread.
  */
@@ -867,9 +886,11 @@ typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
  * This starts a thread that will queue and dequeue until an error occurs
  * or @vb2_thread_stop is called.
  *
- * This function should not be used for anything else but the videobuf2-dvb
- * support. If you think you have another good use-case for this, then please
- * contact the linux-media mailinglist first.
+ * .. attention::
+ *
+ *   This function should not be used for anything else but the videobuf2-dvb
+ *   support. If you think you have another good use-case for this, then please
+ *   contact the linux-media mailing list first.
  */
 int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 		     const char *thread_name);
@@ -1000,6 +1021,12 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
 /**
  * vb2_verify_memory_type() - Check whether the memory type and buffer type
  * passed to a buffer operation are compatible with the queue.
+ *
+ * @q:		videobuf queue
+ * @memory:	memory model, as defined by enum &vb2_memory.
+ * @type:	private buffer type whose content is defined by the vb2-core
+ *		caller. For example, for V4L2, it should match
+ *		the types defined on enum &v4l2_buf_type
  */
 int vb2_verify_memory_type(struct vb2_queue *q,
 		enum vb2_memory memory, unsigned int type);
-- 
2.7.4


