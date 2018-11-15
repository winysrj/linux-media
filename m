Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45889 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbeKPCGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 21:06:01 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v4] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
Date: Thu, 15 Nov 2018 16:57:16 +0100
Message-Id: <20181115155716.4010-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: John Sheu <sheu@chromium.org>

Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
considered "in use".  This is different behavior than for other memory
types and prevents us from deallocating buffers in following two cases:

1) There are outstanding mmap()ed views on the buffer. However even if
   we put the buffer in reqbufs(0), there will be remaining references,
   due to vma .open/close() adjusting vb2 buffer refcount appropriately.
   This means that the buffer will be in fact freed only when the last
   mmap()ed view is unmapped.

2) Buffer has been exported as a DMABUF. Refcount of the vb2 buffer
   is managed properly by VB2 DMABUF ops, i.e. incremented on DMABUF
   get and decremented on DMABUF release. This means that the buffer
   will be alive until all importers release it.

Considering both cases above, there does not seem to be any need to
prevent reqbufs(0) operation, because buffer lifetime is already
properly managed by both mmap() and DMABUF code paths. Let's remove it
and allow userspace freeing the queue (and potentially allocating a new
one) even though old buffers might be still in processing.

To let userspace know that the kernel now supports orphaning buffers
that are still in use, add a new V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
to be set by reqbufs and create_bufs.

Signed-off-by: John Sheu <sheu@chromium.org>
Reviewed-by: Pawel Osciak <posciak@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
[p.zabel@pengutronix.de: added V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS,
 updated documentation, and added back debug message]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v3:
 - Rephrased documentation
 - Added debug message
---
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst | 16 +++++++++++++---
 drivers/media/common/videobuf2/videobuf2-core.c |  8 +++-----
 drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 +-
 include/uapi/linux/videodev2.h                  |  1 +
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index d4bbbb0c60e8..fb1e643fda5f 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -59,9 +59,14 @@ When the I/O method is not supported the ioctl returns an ``EINVAL`` error
 code.
 
 Applications can call :ref:`VIDIOC_REQBUFS` again to change the number of
-buffers, however this cannot succeed when any buffers are still mapped.
-A ``count`` value of zero frees all buffers, after aborting or finishing
-any DMA in progress, an implicit
+buffers. Note that if any buffers are still mapped or exported via DMABUF,
+then :ref:`VIDIOC_REQBUFS` can only succeed if the
+``V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS`` capability is set. Otherwise
+:ref:`VIDIOC_REQBUFS` will return the ``EBUSY`` error code.
+If ``V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS`` is set, then these buffers are
+orphaned and will be freed when they are unmapped or when the exported DMABUF
+fds are closed. A ``count`` value of zero frees or orphans all buffers, after
+aborting or finishing any DMA in progress, an implicit
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`.
 
 
@@ -132,6 +137,11 @@ any DMA in progress, an implicit
     * - ``V4L2_BUF_CAP_SUPPORTS_REQUESTS``
       - 0x00000008
       - This buffer type supports :ref:`requests <media-request-api>`.
+    * - ``V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS``
+      - 0x00000010
+      - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
+        mapped or exported via DMABUF. These orphaned buffers will be freed
+        when they are unmapped or when the exported DMABUF fds are closed.
 
 Return Value
 ============
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 975ff5669f72..7329cafc080a 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -679,11 +679,9 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		 * are not in use and can be freed.
 		 */
 		mutex_lock(&q->mmap_lock);
-		if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
-			mutex_unlock(&q->mmap_lock);
-			dprintk(1, "memory in use, cannot free\n");
-			return -EBUSY;
-		}
+		if (debug && q->memory == VB2_MEMORY_MMAP &&
+		    __buffers_in_use(q))
+			dprintk(1, "memory in use, orphaning buffers\n");
 
 		/*
 		 * Call queue_cancel to clean up any buffers in the
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index a17033ab2c22..f02d452ceeb9 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -624,7 +624,7 @@ EXPORT_SYMBOL(vb2_querybuf);
 
 static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
 {
-	*caps = 0;
+	*caps = V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS;
 	if (q->io_modes & VB2_MMAP)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_MMAP;
 	if (q->io_modes & VB2_USERPTR)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c8e8ff810190..2a223835214c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -879,6 +879,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
-- 
2.19.1
