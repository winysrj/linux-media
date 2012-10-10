Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60873 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2JJOrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:47:48 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00M72MFJE160@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:47:47 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:47:47 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCHv10 01/26] v4l: Add DMABUF as a memory type
Date: Wed, 10 Oct 2012 16:46:20 +0200
Message-id: <1349880405-26049-2-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   18 ++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c          |    1 +
 include/linux/videodev2.h                     |    7 +++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 83ffb64..cc5998b 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -297,6 +297,7 @@ struct v4l2_plane32 {
 	union {
 		__u32		mem_offset;
 		compat_long_t	userptr;
+		__s32		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -318,6 +319,7 @@ struct v4l2_buffer32 {
 		__u32           offset;
 		compat_long_t   userptr;
 		compat_caddr_t  planes;
+		__s32		fd;
 	} m;
 	__u32			length;
 	__u32			reserved2;
@@ -341,6 +343,9 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 		up_pln = compat_ptr(p);
 		if (put_user((unsigned long)up_pln, &up->m.userptr))
 			return -EFAULT;
+	} else if (memory == V4L2_MEMORY_DMABUF) {
+		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(int)))
+			return -EFAULT;
 	} else {
 		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
 					sizeof(__u32)))
@@ -364,6 +369,11 @@ static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
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
@@ -446,6 +456,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			if (get_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
+		case V4L2_MEMORY_DMABUF:
+			if (get_user(kp->m.fd, &up->m.fd))
+				return -EFAULT;
+			break;
 		}
 	}
 
@@ -510,6 +524,10 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			if (put_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
+		case V4L2_MEMORY_DMABUF:
+			if (put_user(kp->m.fd, &up->m.fd))
+				return -EFAULT;
+			break;
 		}
 	}
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8f388ff..530a67e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -155,6 +155,7 @@ static const char *v4l2_memory_names[] = {
 	[V4L2_MEMORY_MMAP]    = "mmap",
 	[V4L2_MEMORY_USERPTR] = "userptr",
 	[V4L2_MEMORY_OVERLAY] = "overlay",
+	[V4L2_MEMORY_DMABUF] = "dmabuf",
 };
 
 #define prt_names(a, arr) (((unsigned)(a)) < ARRAY_SIZE(arr) ? arr[a] : "unknown")
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 873adbe..07bc5d6 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -188,6 +188,7 @@ enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
 	V4L2_MEMORY_OVERLAY          = 3,
+	V4L2_MEMORY_DMABUF           = 4,
 };
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
@@ -604,6 +605,8 @@ struct v4l2_requestbuffers {
  *			should be passed to mmap() called on the video node)
  * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
  *			pointing to this plane
+ * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
+ *			descriptor associated with this plane
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *			unless there is a header in front of the data
  *
@@ -618,6 +621,7 @@ struct v4l2_plane {
 	union {
 		__u32		mem_offset;
 		unsigned long	userptr;
+		__s32		fd;
 	} m;
 	__u32			data_offset;
 	__u32			reserved[11];
@@ -642,6 +646,8 @@ struct v4l2_plane {
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
  *		a userspace pointer pointing to this buffer
+ * @fd:		for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
+ *		a userspace file descriptor associated with this buffer
  * @planes:	for multiplanar buffers; userspace pointer to the array of plane
  *		info structs for this buffer
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
@@ -668,6 +674,7 @@ struct v4l2_buffer {
 		__u32           offset;
 		unsigned long   userptr;
 		struct v4l2_plane *planes;
+		__s32		fd;
 	} m;
 	__u32			length;
 	__u32			reserved2;
-- 
1.7.9.5

