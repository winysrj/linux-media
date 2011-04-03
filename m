Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39661 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1DCXjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:39:08 -0400
Received: by iwn34 with SMTP id 34so5252053iwn.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:39:07 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 1/3] [media] vb2: update and fix interface documentation
Date: Sun,  3 Apr 2011 16:38:55 -0700
Message-Id: <1301873937-14146-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Update documentation for videobuf2 driver callbacks and memory operations.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 include/media/videobuf2-core.h |  146 +++++++++++++++++++++++++---------------
 1 files changed, 91 insertions(+), 55 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f87472a..4c1e91f 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -33,8 +33,11 @@ struct vb2_fileio_data;
  *		argument is the allocator private per-buffer structure
  *		previously returned from the alloc callback
  * @get_userptr: acquire userspace memory for a hardware operation; used for
- *		 USERPTR memory types; vaddr is the address passed to the
- *		 videobuf layer when queuing a video buffer of USERPTR type;
+ *		 USERPTR memory types; alloc_ctx is the allocator private data,
+ *		 vaddr is the address passed to the videobuf layer when
+ *		 queuing a video buffer of USERPTR type, size is the size of
+ *		 that buffer and write=1 if the buffer will be written to
+ *		 by kernel/hardware (i.e. is a CAPTURE buffer);
  *		 should return an allocator private per-buffer structure
  *		 associated with the buffer on success, NULL on failure;
  *		 the returned private structure will then be passed as buf_priv
@@ -44,9 +47,14 @@ struct vb2_fileio_data;
  * @vaddr:	return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
  *		such mapping exists
- * @cookie:	return allocator specific cookie for a given memory buffer
- *		associated with the passed private structure or NULL if not
- *		available
+ * @cookie:	return allocator-specific cookie for a given memory buffer,
+ *		associated with the passed private structure, or NULL if not
+ *		available; a cookie is a unique identifier for a buffer that
+ *		driver will be able to use when communicating with hardware;
+ *		for example, for devices accessing physical memory directly via
+ *		physical addresses, it can point to a variable containing
+ *		a physical address for the given buffer, which the driver can
+ *		then pass to the device when setting up a HW operation
  * @num_users:	return the current number of users of a memory buffer;
  *		return 1 if the videobuf layer (or actually the driver using
  *		it) is the only user
@@ -74,8 +82,8 @@ struct vb2_mem_ops {
 };
 
 struct vb2_plane {
-	void			*mem_priv;
-	int			mapped:1;
+	void		*mem_priv;
+	int		mapped:1;
 };
 
 /**
@@ -93,10 +101,15 @@ enum vb2_io_modes {
 };
 
 /**
- * enum vb2_fileio_flags - flags for selecting a mode of the file io emulator,
- * by default the 'streaming' style is used by the file io emulator
- * @VB2_FILEIO_READ_ONCE:	report EOF after reading the first buffer
- * @VB2_FILEIO_WRITE_IMMEDIATELY:	queue buffer after each write() call
+ * enum vb2_fileio_flags - flags for selecting file IO (read/write) behavior
+ * @VB2_FILEIO_READ_ONCE:	if set, the userspace will be able to read one
+ * 				full buffer only, an EOF will be reported after
+ * 				the first buffer has been read completely
+ * @VB2_FILEIO_WRITE_IMMEDIATELY: if set, do not wait for the buffer to be
+ * 				  filled completely by userspace (possibly
+ * 				  using multiple write() calls), but send it
+ * 				  to the device immediately after the first
+ * 				  write() call
  */
 enum vb2_fileio_flags {
 	VB2_FILEIO_READ_ONCE		= (1 << 0),
@@ -130,7 +143,10 @@ struct vb2_queue;
  * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
  *			be read by the driver and relevant entries can be
  *			changed by the driver in case of CAPTURE types
- *			(such as timestamp)
+ *			(such as timestamp); NOTE that even for single-planar
+ *			types, the v4l2_planes[0] struct should be used
+ *			instead of v4l2_buf for filling bytesused - drivers
+ *			should use the vb2_set_plane_payload() function for that
  * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
  *			be read by the driver and relevant entries can be
  *			changed by the driver in case of CAPTURE types
@@ -140,14 +156,13 @@ struct vb2_queue;
  *			should use the vb2_set_plane_payload() function for that
  * @vb2_queue:		the queue to which this driver belongs
  * @num_planes:		number of planes in the buffer
- *			on an internal driver queue
- * @state:		current buffer state; do not change
+ * @state:		current buffer state; do not use
  * @queued_entry:	entry on the queued buffers list, which holds all
- *			buffers queued from userspace
+ *			buffers queued from userspace; do not use
  * @done_entry:		entry on the list that stores all buffers ready to
- *			be dequeued to userspace
- * @planes:		private per-plane information; do not change
- * @num_planes_mapped:	number of mapped planes; do not change
+ *			be dequeued to userspace; do not use
+ * @planes:		private per-plane information; do not use
+ * @num_planes_mapped:	number of mapped planes; do not use
  */
 struct vb2_buffer {
 	struct v4l2_buffer	v4l2_buf;
@@ -168,46 +183,67 @@ struct vb2_buffer {
 };
 
 /**
- * struct vb2_ops - driver-specific callbacks
+ * struct vb2_ops - driver-specific callbacks to be implemented by the driver
+ * Required: queue_setup, buf_queue. The rest is optional.
  *
- * @queue_setup:	called from a VIDIOC_REQBUFS handler, before
- *			memory allocation; driver should return the required
- *			number of buffers in num_buffers, the required number
- *			of planes per buffer in num_planes; the size of each
- *			plane should be set in the sizes[] array and optional
- *			per-plane allocator specific context in alloc_ctxs[]
- *			array
- * @wait_prepare:	release any locks taken while calling vb2 functions;
- *			it is called before an ioctl needs to wait for a new
- *			buffer to arrive; required to avoid a deadlock in
- *			blocking access type
- * @wait_finish:	reacquire all locks released in the previous callback;
- *			required to continue operation after sleeping while
- *			waiting for a new buffer to arrive
+ * @queue_setup:	used to negotiate queue parameters between the userspace
+ *			and the driver; called before memory allocation;
+ *			the number of buffers requested by userspace will be
+ *			passed in num_buffers, which the driver can change;
+ *			the driver has to set the required number of planes per
+ *			buffer for the current format in num_planes and put
+ *			the size of each plane in the sizes[] array (sizes[i]
+ *			being the size of i-th plane for all buffers);
+ *			the driver can also put optional, per-plane
+ *			allocator-specific contexts in alloc_ctxs[] array;
+ *			if provided, allocator contexts will be passed to the
+ *			memory allocator when allocating each plane,
+ *			alloc_ctx[i] being passed to the alloc() memory
+ *			operation on allocating i-th plane for each buffer;
+ * @wait_prepare:	asks the driver to release any locks that should not be
+ *			held while sleeping and all locks protecting ioctl calls
+ *			in the driver; it is called before videobuf needs
+ *			to put the driver to sleep, e.g. to wait for new buffers
+ *			to arrive; as new buffers can only arrive via an another
+ *			ioctl call, locks that protect those calls have
+ *			to be released here as well;
+ * @wait_finish:	asks the driver to reacquire locks released in
+ *			wait_prepare; called after waking up;
  * @buf_init:		called once after allocating a buffer (in MMAP case)
  *			or after acquiring a new USERPTR buffer; drivers may
- *			perform additional buffer-related initialization;
- *			initialization failure (return != 0) will prevent
- *			queue setup from completing successfully; optional
- * @buf_prepare:	called every time the buffer is queued from userspace;
- *			drivers may perform any initialization required before
- *			each hardware operation in this callback;
- *			if an error is returned, the buffer will not be queued
- *			in driver; optional
- * @buf_finish:		called before every dequeue of the buffer back to
- *			userspace; drivers may perform any operations required
- *			before userspace accesses the buffer; optional
- * @buf_cleanup:	called once before the buffer is freed; drivers may
- *			perform any additional cleanup; optional
- * @start_streaming:	called once before entering 'streaming' state; enables
- *			driver to receive buffers over buf_queue() callback
- * @stop_streaming:	called when 'streaming' state must be disabled; driver
- *			should stop any DMA transactions or wait until they
- *			finish and give back all buffers it got from buf_queue()
- *			callback; may use vb2_wait_for_all_buffers() function
- * @buf_queue:		passes buffer vb to the driver; driver may start
- *			hardware operation on this buffer; driver should give
- *			the buffer back by calling vb2_buffer_done() function
+ *			perform additional buffer-related initialization here;
+ *			a failure (return != 0) will prevent queue setup from
+ *			completing successfully;
+ * @buf_prepare:	called each time a buffer is queued from userspace;
+ *			drivers may perform any additional initialization steps
+ *			that need to be done before every hardware operation
+ *			in this callback; if an error is returned, the buffer
+ *			will not be queued;
+ * @buf_finish:		a counterpart to buf_prepare; called each time a buffer
+ *			is about to be dequeued back to the userspace; drivers
+ *			may perform any operations required before the buffer
+ *			can be accessed by userspace here;
+ * @buf_cleanup:	a counterpart to buf_init; called once before a buffer
+ *			is freed; drivers may perform any additional cleanup
+ *			here;
+ * @start_streaming:	called once before entering the 'streaming' state;
+ *			can be used to perform any additional steps required by
+ *			the driver before streaming begins (such as enabling
+ *			the device);
+ * @stop_streaming:	called when the 'streaming' state must be disabled;
+ * 			drivers should stop any DMA transactions here (or wait
+ * 			until they are finished) and give back all the buffers
+ * 			received via buf_queue() by calling vb2_buffer_done()
+ * 			for each of them;
+ * 			drivers can use the vb2_wait_for_all_buffers() function
+ * 			here to wait for asynchronous completion events that
+ * 			call vb2_buffer_done(), such as ISRs;
+ * @buf_queue:		passes a buffer to the driver; the driver may start
+ *			a hardware operation on that buffer; this callback
+ *			MUST return immediately, i.e. it may NOT wait for
+ *			the end of a hardware operation; the driver should use
+ *			the vb2_buffer_done() function to give the buffer back
+ *			after an operation is finished;
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
-- 
1.7.4.2

