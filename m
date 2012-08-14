Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:53123 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab2HNPfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:35:24 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R009RI4MXM340@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:35:22 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:35:22 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCHv8 01/26] v4l: Add DMABUF as a memory type
Date: Tue, 14 Aug 2012 17:34:31 +0200
Message-id: <1344958496-9373-2-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
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
 drivers/media/video/v4l2-compat-ioctl32.c |   18 ++++++++++++++++++
 drivers/media/video/v4l2-ioctl.c          |    1 +
 include/linux/videodev2.h                 |    7 +++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 9ebd5c5..a2e0549 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -304,6 +304,7 @@ struct v4l2_plane32 {
 	union {
 		__u32		mem_offset;
 		compat_long_t	userptr;
+		__u32		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -325,6 +326,7 @@ struct v4l2_buffer32 {
 		__u32           offset;
 		compat_long_t   userptr;
 		compat_caddr_t  planes;
+		__u32		fd;
 	} m;
 	__u32			length;
 	__u32			reserved2;
@@ -348,6 +350,9 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 		up_pln = compat_ptr(p);
 		if (put_user((unsigned long)up_pln, &up->m.userptr))
 			return -EFAULT;
+	} else if (memory == V4L2_MEMORY_DMABUF) {
+		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(int)))
+			return -EFAULT;
 	} else {
 		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
 					sizeof(__u32)))
@@ -371,6 +376,11 @@ static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
 					sizeof(__u32)))
 			return -EFAULT;
+	/* For DMABUF, driver might've set up the fd, so copy it back. */
+	if (memory == V4L2_MEMORY_DMABUF)
+		if (copy_in_user(&up32->m.fd, &up->m.fd,
+					sizeof(int)))
+			return -EFAULT;
 
 	return 0;
 }
@@ -453,6 +463,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			if (get_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
+		case V4L2_MEMORY_DMABUF:
+			if (get_user(kp->m.fd, &up->m.fd))
+				return -EFAULT;
+			break;
 		}
 	}
 
@@ -517,6 +531,10 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			if (put_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
+		case V4L2_MEMORY_DMABUF:
+			if (put_user(kp->m.fd, &up->m.fd))
+				return -EFAULT;
+			break;
 		}
 	}
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 6bc47fc..dffd3c9 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -155,6 +155,7 @@ static const char *v4l2_memory_names[] = {
 	[V4L2_MEMORY_MMAP]    = "mmap",
 	[V4L2_MEMORY_USERPTR] = "userptr",
 	[V4L2_MEMORY_OVERLAY] = "overlay",
+	[V4L2_MEMORY_DMABUF] = "dmabuf",
 };
 
 #define prt_names(a, arr) ((((a) >= 0) && ((a) < ARRAY_SIZE(arr))) ? \
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7a147c8..7f918dc 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -186,6 +186,7 @@ enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
 	V4L2_MEMORY_OVERLAY          = 3,
+	V4L2_MEMORY_DMABUF           = 4,
 };
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
@@ -596,6 +597,8 @@ struct v4l2_requestbuffers {
  *			should be passed to mmap() called on the video node)
  * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
  *			pointing to this plane
+ * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
+ *			descriptor associated with this plane
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *			unless there is a header in front of the data
  *
@@ -610,6 +613,7 @@ struct v4l2_plane {
 	union {
 		__u32		mem_offset;
 		unsigned long	userptr;
+		int		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -634,6 +638,8 @@ struct v4l2_plane {
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
  *		a userspace pointer pointing to this buffer
+ * @fd:		for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
+ *		a userspace file descriptor associated with this buffer
  * @planes:	for multiplanar buffers; userspace pointer to the array of plane
  *		info structs for this buffer
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
@@ -660,6 +666,7 @@ struct v4l2_buffer {
 		__u32           offset;
 		unsigned long   userptr;
 		struct v4l2_plane *planes;
+		int		fd;
 	} m;
 	__u32			length;
 	__u32			reserved2;
-- 
1.7.9.5

