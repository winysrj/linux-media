Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 07/36] [media] doc-rst: Convert videobuf documentation to ReST
Date: Sun, 17 Jul 2016 22:55:50 -0300
Message-Id: <1bed13f521fc3d22d1b128999ea2b128aea50728.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The videobuf documentation is almost at rst format: we
just needed to add titles and add some code-blocks there
and that's it.

Also, add a notice that this framework is deprecated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/videobuf.rst | 51 +++++++++++++++++++++++++++++++++--
 Documentation/media/media_drivers.rst |  1 +
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/kapi/videobuf.rst b/Documentation/media/kapi/videobuf.rst
index 3ffe9e960b6f..01156728203c 100644
--- a/Documentation/media/kapi/videobuf.rst
+++ b/Documentation/media/kapi/videobuf.rst
@@ -1,7 +1,18 @@
-An introduction to the videobuf layer
-Jonathan Corbet <corbet@lwn.net>
+Videobuf Framework
+==================
+
+Author: Jonathan Corbet <corbet@lwn.net>
+
 Current as of 2.6.33
 
+.. note::
+
+   The videobuf framework was deprecated in favor of videobuf2. Shouldn't
+   be used on new drivers.
+
+Introduction
+------------
+
 The videobuf layer functions as a sort of glue layer between a V4L2 driver
 and user space.  It handles the allocation and management of buffers for
 the storage of video frames.  There is a set of functions which can be used
@@ -14,6 +25,7 @@ author, but the payback comes in the form of reduced code in the driver and
 a consistent implementation of the V4L2 user-space API.
 
 Buffer types
+------------
 
 Not all video devices use the same kind of buffers.  In fact, there are (at
 least) three common variations:
@@ -48,10 +60,13 @@ the kernel and a description of this technique is currently beyond the
 scope of this document.]
 
 Data structures, callbacks, and initialization
+----------------------------------------------
 
 Depending on which type of buffers are being used, the driver should
 include one of the following files:
 
+.. code-block:: none
+
     <media/videobuf-dma-sg.h>		/* Physically scattered */
     <media/videobuf-vmalloc.h>		/* vmalloc() buffers	*/
     <media/videobuf-dma-contig.h>	/* Physically contiguous */
@@ -65,6 +80,8 @@ the queue.
 The next step is to write four simple callbacks to help videobuf deal with
 the management of buffers:
 
+.. code-block:: none
+
     struct videobuf_queue_ops {
 	int (*buf_setup)(struct videobuf_queue *q,
 			 unsigned int *count, unsigned int *size);
@@ -91,6 +108,8 @@ passed to buf_prepare(), which should set the buffer's size, width, height,
 and field fields properly.  If the buffer's state field is
 VIDEOBUF_NEEDS_INIT, the driver should pass it to:
 
+.. code-block:: none
+
     int videobuf_iolock(struct videobuf_queue* q, struct videobuf_buffer *vb,
 			struct v4l2_framebuffer *fbuf);
 
@@ -110,6 +129,8 @@ Finally, buf_release() is called when a buffer is no longer intended to be
 used.  The driver should ensure that there is no I/O active on the buffer,
 then pass it to the appropriate free routine(s):
 
+.. code-block:: none
+
     /* Scatter/gather drivers */
     int videobuf_dma_unmap(struct videobuf_queue *q,
 			   struct videobuf_dmabuf *dma);
@@ -124,6 +145,8 @@ then pass it to the appropriate free routine(s):
 
 One way to ensure that a buffer is no longer under I/O is to pass it to:
 
+.. code-block:: none
+
     int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr);
 
 Here, vb is the buffer, non_blocking indicates whether non-blocking I/O
@@ -131,12 +154,15 @@ should be used (it should be zero in the buf_release() case), and intr
 controls whether an interruptible wait is used.
 
 File operations
+---------------
 
 At this point, much of the work is done; much of the rest is slipping
 videobuf calls into the implementation of the other driver callbacks.  The
 first step is in the open() function, which must initialize the
 videobuf queue.  The function to use depends on the type of buffer used:
 
+.. code-block:: none
+
     void videobuf_queue_sg_init(struct videobuf_queue *q,
 				struct videobuf_queue_ops *ops,
 				struct device *dev,
@@ -182,6 +208,8 @@ applications have a chance of working with the device.  Videobuf makes it
 easy to do that with the same code.  To implement read(), the driver need
 only make a call to one of:
 
+.. code-block:: none
+
     ssize_t videobuf_read_one(struct videobuf_queue *q,
 			      char __user *data, size_t count,
 			      loff_t *ppos, int nonblocking);
@@ -201,6 +229,8 @@ anticipation of another read() call happening in the near future).
 
 The poll() function can usually be implemented with a direct call to:
 
+.. code-block:: none
+
     unsigned int videobuf_poll_stream(struct file *file,
 				      struct videobuf_queue *q,
 				      poll_table *wait);
@@ -213,6 +243,8 @@ the mmap() system call to enable user space to access the data.  In many
 V4L2 drivers, the often-complex mmap() implementation simplifies to a
 single call to:
 
+.. code-block:: none
+
     int videobuf_mmap_mapper(struct videobuf_queue *q,
 			     struct vm_area_struct *vma);
 
@@ -220,6 +252,8 @@ Everything else is handled by the videobuf code.
 
 The release() function requires two separate videobuf calls:
 
+.. code-block:: none
+
     void videobuf_stop(struct videobuf_queue *q);
     int videobuf_mmap_free(struct videobuf_queue *q);
 
@@ -233,12 +267,15 @@ buffers are still mapped, but every driver in the 2.6.32 kernel cheerfully
 ignores its return value.
 
 ioctl() operations
+------------------
 
 The V4L2 API includes a very long list of driver callbacks to respond to
 the many ioctl() commands made available to user space.  A number of these
 - those associated with streaming I/O - turn almost directly into videobuf
 calls.  The relevant helper functions are:
 
+.. code-block:: none
+
     int videobuf_reqbufs(struct videobuf_queue *q,
 			 struct v4l2_requestbuffers *req);
     int videobuf_querybuf(struct videobuf_queue *q, struct v4l2_buffer *b);
@@ -259,6 +296,7 @@ complex, of course, since they will also need to deal with starting and
 stopping the capture engine.
 
 Buffer allocation
+-----------------
 
 Thus far, we have talked about buffers, but have not looked at how they are
 allocated.  The scatter/gather case is the most complex on this front.  For
@@ -272,11 +310,15 @@ If the driver needs to do its own memory allocation, it should be done in
 the vidioc_reqbufs() function, *after* calling videobuf_reqbufs().  The
 first step is a call to:
 
+.. code-block:: none
+
     struct videobuf_dmabuf *videobuf_to_dma(struct videobuf_buffer *buf);
 
 The returned videobuf_dmabuf structure (defined in
 <media/videobuf-dma-sg.h>) includes a couple of relevant fields:
 
+.. code-block:: none
+
     struct scatterlist  *sglist;
     int                 sglen;
 
@@ -300,6 +342,7 @@ kernel drivers, or those contained within huge pages, will work with these
 drivers.
 
 Filling the buffers
+-------------------
 
 The final part of a videobuf implementation has no direct callback - it's
 the portion of the code which actually puts frame data into the buffers,
@@ -331,10 +374,14 @@ For scatter/gather drivers, the needed memory pointers will be found in the
 scatterlist structure described above.  Drivers using the vmalloc() method
 can get a memory pointer with:
 
+.. code-block:: none
+
     void *videobuf_to_vmalloc(struct videobuf_buffer *buf);
 
 For contiguous DMA drivers, the function to use is:
 
+.. code-block:: none
+
     dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf);
 
 The contiguous DMA API goes out of its way to hide the kernel-space address
diff --git a/Documentation/media/media_drivers.rst b/Documentation/media/media_drivers.rst
index 5941fea2607e..8e0f455ff6e0 100644
--- a/Documentation/media/media_drivers.rst
+++ b/Documentation/media/media_drivers.rst
@@ -19,6 +19,7 @@ License".
 
     kapi/v4l2-framework
     kapi/v4l2-controls
+    kapi/videobuf
     kapi/v4l2-core
     kapi/dtv-core
     kapi/rc-core
-- 
2.7.4

