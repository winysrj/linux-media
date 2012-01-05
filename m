Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50186 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2AEKmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 05:42:20 -0500
From: Sumit Semwal <sumit.semwal@ti.com>
To: <linaro-mm-sig@lists.linaro.org>, <linux-media@vger.kernel.org>,
	<arnd@arndb.de>
CC: <jesse.barker@linaro.org>, <m.szyprowski@samsung.com>,
	<rob@ti.com>, <daniel@ffwll.ch>, <t.stanislaws@samsung.com>,
	<patches@linaro.org>, Sumit Semwal <sumit.semwal@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFCv1 1/4] v4l: Add DMABUF as a memory type
Date: Thu, 5 Jan 2012 16:11:55 +0530
Message-ID: <1325760118-27997-2-git-send-email-sumit.semwal@ti.com>
In-Reply-To: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds DMABUF memory type to v4l framework. Also adds the related file
descriptor in v4l2_plane and v4l2_buffer.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
   [original work in the PoC for buffer sharing]
Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 include/linux/videodev2.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..3c0ade1 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -185,6 +185,7 @@ enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
 	V4L2_MEMORY_OVERLAY          = 3,
+	V4L2_MEMORY_DMABUF           = 4,
 };
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
@@ -574,6 +575,8 @@ struct v4l2_requestbuffers {
  *			should be passed to mmap() called on the video node)
  * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
  *			pointing to this plane
+ * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
+ *			descriptor associated with this plane
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *			unless there is a header in front of the data
  *
@@ -588,6 +591,7 @@ struct v4l2_plane {
 	union {
 		__u32		mem_offset;
 		unsigned long	userptr;
+		int		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -610,6 +614,9 @@ struct v4l2_plane {
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
  *		a userspace pointer pointing to this buffer
+ * @fd:		for non-multiplanar buffers with
+ * 		memory == V4L2_MEMORY_DMABUF; a userspace file descriptor
+ *		associated with this buffer
  * @planes:	for multiplanar buffers; userspace pointer to the array of plane
  *		info structs for this buffer
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
@@ -636,6 +643,7 @@ struct v4l2_buffer {
 		__u32           offset;
 		unsigned long   userptr;
 		struct v4l2_plane *planes;
+		int		fd;
 	} m;
 	__u32			length;
 	__u32			input;
-- 
1.7.5.4

