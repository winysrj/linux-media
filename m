Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4596 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaB1Rmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 12:42:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 07/17] vb2: consistent usage of periods in videobuf2-core.h
Date: Fri, 28 Feb 2014 18:42:05 +0100
Message-Id: <1393609335-12081-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Sometimes sentences in comments ended with a period, and sometimes they
didn't. Add periods. No other changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 3cb0bcf..06efa4a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -34,49 +34,49 @@ struct vb2_fileio_data;
  *		usually will result in the allocator freeing the buffer (if
  *		no other users of this buffer are present); the buf_priv
  *		argument is the allocator private per-buffer structure
- *		previously returned from the alloc callback
+ *		previously returned from the alloc callback.
  * @get_userptr: acquire userspace memory for a hardware operation; used for
  *		 USERPTR memory types; vaddr is the address passed to the
  *		 videobuf layer when queuing a video buffer of USERPTR type;
  *		 should return an allocator private per-buffer structure
  *		 associated with the buffer on success, NULL on failure;
  *		 the returned private structure will then be passed as buf_priv
- *		 argument to other ops in this structure
+ *		 argument to other ops in this structure.
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
- *		 be used
+ *		 be used.
  * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
  *		   used for DMABUF memory types; alloc_ctx is the alloc context
  *		   dbuf is the shared dma_buf; returns NULL on failure;
  *		   allocator private per-buffer structure on success;
- *		   this needs to be used for further accesses to the buffer
+ *		   this needs to be used for further accesses to the buffer.
  * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
  *		   buffer is no longer used; the buf_priv argument is the
  *		   allocator private per-buffer structure previously returned
- *		   from the attach_dmabuf callback
+ *		   from the attach_dmabuf callback.
  * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
  *		of dmabuf is informed that this driver is going to use the
- *		dmabuf
+ *		dmabuf.
  * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
- *		  that this driver is done using the dmabuf for now
+ *		  that this driver is done using the dmabuf for now.
  * @prepare:	called every time the buffer is passed from userspace to the
- *		driver, useful for cache synchronisation, optional
+ *		driver, useful for cache synchronisation, optional.
  * @finish:	called every time the buffer is passed back from the driver
- *		to the userspace, also optional
+ *		to the userspace, also optional.
  * @vaddr:	return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
- *		such mapping exists
+ *		such mapping exists.
  * @cookie:	return allocator specific cookie for a given memory buffer
  *		associated with the passed private structure or NULL if not
- *		available
+ *		available.
  * @num_users:	return the current number of users of a memory buffer;
  *		return 1 if the videobuf layer (or actually the driver using
- *		it) is the only user
+ *		it) is the only user.
  * @mmap:	setup a userspace mapping for a given memory buffer under
- *		the provided virtual memory region
+ *		the provided virtual memory region.
  *
  * Required ops for USERPTR types: get_userptr, put_userptr.
  * Required ops for MMAP types: alloc, put, num_users, mmap.
- * Required ops for read/write access types: alloc, put, num_users, vaddr
+ * Required ops for read/write access types: alloc, put, num_users, vaddr.
  * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
  *				  unmap_dmabuf.
  */
@@ -258,22 +258,22 @@ struct vb2_buffer {
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
  *			buffer to arrive; required to avoid a deadlock in
- *			blocking access type
+ *			blocking access type.
  * @wait_finish:	reacquire all locks released in the previous callback;
  *			required to continue operation after sleeping while
- *			waiting for a new buffer to arrive
+ *			waiting for a new buffer to arrive.
  * @buf_init:		called once after allocating a buffer (in MMAP case)
  *			or after acquiring a new USERPTR buffer; drivers may
  *			perform additional buffer-related initialization;
  *			initialization failure (return != 0) will prevent
- *			queue setup from completing successfully; optional
+ *			queue setup from completing successfully; optional.
  * @buf_prepare:	called every time the buffer is queued from userspace
  *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
  *			perform any initialization required before each hardware
  *			operation in this callback; drivers that support
  *			VIDIOC_CREATE_BUFS must also validate the buffer size;
  *			if an error is returned, the buffer will not be queued
- *			in driver; optional
+ *			in driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; drivers may perform any operations required
  *			before userspace accesses the buffer; optional. The
@@ -286,7 +286,7 @@ struct vb2_buffer {
  *			all other cases the buffer contents will be ignored
  *			anyway.
  * @buf_cleanup:	called once before the buffer is freed; drivers may
- *			perform any additional cleanup; optional
+ *			perform any additional cleanup; optional.
  * @start_streaming:	called once to enter 'streaming' state; the driver may
  *			receive buffers with @buf_queue callback before
  *			@start_streaming is called; the driver gets the number
@@ -307,7 +307,7 @@ struct vb2_buffer {
  *			the buffer back by calling vb2_buffer_done() function;
  *			it is allways called after calling STREAMON ioctl;
  *			might be called before start_streaming callback if user
- *			pre-queued buffers before calling STREAMON
+ *			pre-queued buffers before calling STREAMON.
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
-- 
1.9.rc1

