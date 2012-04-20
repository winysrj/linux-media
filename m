Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20414 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2DTOTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 10:19:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 20 Apr 2012 16:06:08 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv5 01/13] v4l: Add DMABUF as a memory type
In-reply-to: <1334930780-28976-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de, Sumit Semwal <sumit.semwal@linaro.org>
Message-id: <1334930780-28976-2-git-send-email-t.stanislaws@samsung.com>
References: <1334930780-28976-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sumit Semwal <sumit.semwal@ti.com>

Adds DMABUF memory type to v4l framework. Also adds the related file
descriptor in v4l2_plane and v4l2_buffer.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
   [original work in the PoC for buffer sharing]
Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/videodev2.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c9c9a46..d884d4a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -185,6 +185,7 @@ enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
 	V4L2_MEMORY_OVERLAY          = 3,
+	V4L2_MEMORY_DMABUF           = 4,
 };
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
@@ -588,6 +589,8 @@ struct v4l2_requestbuffers {
  *			should be passed to mmap() called on the video node)
  * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
  *			pointing to this plane
+ * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
+ *			descriptor associated with this plane
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *			unless there is a header in front of the data
  *
@@ -602,6 +605,7 @@ struct v4l2_plane {
 	union {
 		__u32		mem_offset;
 		unsigned long	userptr;
+		int		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -624,6 +628,8 @@ struct v4l2_plane {
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
  *		a userspace pointer pointing to this buffer
+ * @fd:		for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
+ *		a userspace file descriptor associated with this buffer
  * @planes:	for multiplanar buffers; userspace pointer to the array of plane
  *		info structs for this buffer
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
@@ -650,6 +656,7 @@ struct v4l2_buffer {
 		__u32           offset;
 		unsigned long   userptr;
 		struct v4l2_plane *planes;
+		int		fd;
 	} m;
 	__u32			length;
 	__u32			input;
-- 
1.7.5.4

