Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8574 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab0G3Itz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 04:49:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L6D00I4G4J08H10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Jul 2010 09:49:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6D001HS4IZCV@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Jul 2010 09:49:48 +0100 (BST)
Date: Fri, 30 Jul 2010 10:49:43 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v5 3/3] v4l: Add compat functions for the multi-planar API
In-reply-to: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1280479783-23945-4-git-send-email-p.osciak@samsung.com>
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add multi-planar ioctl handling to the 32bit compatibility layer.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |  221 +++++++++++++++++++++++++----
 1 files changed, 190 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 9004a5f..90bf865 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -303,6 +303,14 @@ static inline int get_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pi
 	return 0;
 }
 
+static inline int get_v4l2_pix_format_mplane(struct v4l2_pix_format_mplane *kp,
+				struct v4l2_pix_format_mplane __user *up)
+{
+	if (copy_from_user(kp, up, sizeof(struct v4l2_pix_format_mplane)))
+		return -EFAULT;
+	return 0;
+}
+
 static inline int put_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pix_format __user *up)
 {
 	if (copy_to_user(up, kp, sizeof(struct v4l2_pix_format)))
@@ -310,6 +318,14 @@ static inline int put_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pi
 	return 0;
 }
 
+static inline int put_v4l2_pix_format_mplane(struct v4l2_pix_format_mplane *kp,
+				struct v4l2_pix_format_mplane __user *up)
+{
+	if (copy_to_user(up, kp, sizeof(struct v4l2_pix_format_mplane)))
+		return -EFAULT;
+	return 0;
+}
+
 static inline int get_v4l2_vbi_format(struct v4l2_vbi_format *kp, struct v4l2_vbi_format __user *up)
 {
 	if (copy_from_user(kp, up, sizeof(struct v4l2_vbi_format)))
@@ -342,6 +358,7 @@ struct v4l2_format32 {
 	enum v4l2_buf_type type;
 	union {
 		struct v4l2_pix_format	pix;
+		struct v4l2_pix_format_mplane	pix_mp;
 		struct v4l2_window32	win;
 		struct v4l2_vbi_format	vbi;
 		struct v4l2_sliced_vbi_format	sliced;
@@ -358,6 +375,10 @@ static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		return get_v4l2_pix_format(&kp->fmt.pix, &up->fmt.pix);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		return get_v4l2_pix_format_mplane(&kp->fmt.pix_mp,
+						  &up->fmt.pix_mp);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		return get_v4l2_window32(&kp->fmt.win, &up->fmt.win);
@@ -389,6 +410,10 @@ static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		return put_v4l2_pix_format(&kp->fmt.pix, &up->fmt.pix);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		return put_v4l2_pix_format_mplane(&kp->fmt.pix_mp,
+						  &up->fmt.pix_mp);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		return put_v4l2_window32(&kp->fmt.win, &up->fmt.win);
@@ -442,6 +467,17 @@ static int put_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32
 	return 0;
 }
 
+struct v4l2_plane32 {
+	__u32			bytesused;
+	__u32			length;
+	union {
+		__u32		mem_offset;
+		compat_long_t	userptr;
+	} m;
+	__u32			data_offset;
+	__u32			reserved[11];
+};
+
 struct v4l2_buffer32 {
 	__u32			index;
 	enum v4l2_buf_type      type;
@@ -457,14 +493,64 @@ struct v4l2_buffer32 {
 	union {
 		__u32           offset;
 		compat_long_t   userptr;
+		compat_caddr_t  planes;
 	} m;
 	__u32			length;
 	__u32			input;
 	__u32			reserved;
 };
 
+static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
+				enum v4l2_memory memory)
+{
+	void __user *up_pln;
+	compat_long_t p;
+
+	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
+		copy_in_user(&up->data_offset, &up32->data_offset,
+				sizeof(__u32)))
+		return -EFAULT;
+
+	if (memory == V4L2_MEMORY_USERPTR) {
+		if (get_user(p, &up32->m.userptr))
+			return -EFAULT;
+		up_pln = compat_ptr(p);
+		if (put_user((unsigned long)up_pln, &up->m.userptr))
+			return -EFAULT;
+	} else {
+		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
+					sizeof(__u32)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
+				enum v4l2_memory memory)
+{
+	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
+		copy_in_user(&up32->data_offset, &up->data_offset,
+				sizeof(__u32)))
+		return -EFAULT;
+
+	/* For MMAP, driver might've set up the offset, so copy it back.
+	 * USERPTR stays the same (was userspace-provided), so no copying. */
+	if (memory == V4L2_MEMORY_MMAP)
+		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
+					sizeof(__u32)))
+			return -EFAULT;
+
+	return 0;
+}
+
 static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user *up)
 {
+	struct v4l2_plane32 __user *uplane32;
+	struct v4l2_plane __user *uplane;
+	compat_caddr_t p;
+	int num_planes;
+	int ret;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_buffer32)) ||
 		get_user(kp->index, &up->index) ||
@@ -473,33 +559,84 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		get_user(kp->memory, &up->memory) ||
 		get_user(kp->input, &up->input))
 			return -EFAULT;
-	switch (kp->memory) {
-	case V4L2_MEMORY_MMAP:
-		if (get_user(kp->length, &up->length) ||
-			get_user(kp->m.offset, &up->m.offset))
+
+	if (V4L2_TYPE_IS_OUTPUT(kp->type))
+		if (get_user(kp->bytesused, &up->bytesused) ||
+			get_user(kp->field, &up->field) ||
+			get_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
+			get_user(kp->timestamp.tv_usec,
+					&up->timestamp.tv_usec))
 			return -EFAULT;
-		break;
-	case V4L2_MEMORY_USERPTR:
-		{
-		compat_long_t tmp;
 
-		if (get_user(kp->length, &up->length) ||
-		    get_user(tmp, &up->m.userptr))
+	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
+		if (get_user(kp->length, &up->length))
 			return -EFAULT;
 
-		kp->m.userptr = (unsigned long)compat_ptr(tmp);
+		num_planes = kp->length;
+		if (num_planes == 0) {
+			kp->m.planes = NULL;
+			/* num_planes == 0 is legal, e.g. when userspace doesn't
+			 * need planes array on DQBUF*/
+			return 0;
 		}
-		break;
-	case V4L2_MEMORY_OVERLAY:
-		if (get_user(kp->m.offset, &up->m.offset))
+
+		if (get_user(p, &up->m.planes))
 			return -EFAULT;
-		break;
+
+		uplane32 = compat_ptr(p);
+		if (!access_ok(VERIFY_READ, uplane32,
+				num_planes * sizeof(struct v4l2_plane32)))
+			return -EFAULT;
+
+		/* We don't really care if userspace decides to kill itself
+		 * by passing a very big num_planes value */
+		uplane = compat_alloc_user_space(num_planes *
+						sizeof(struct v4l2_plane));
+		kp->m.planes = uplane;
+
+		while (--num_planes >= 0) {
+			ret = get_v4l2_plane32(uplane, uplane32, kp->memory);
+			if (ret)
+				return ret;
+			++uplane;
+			++uplane32;
+		}
+	} else {
+		switch (kp->memory) {
+		case V4L2_MEMORY_MMAP:
+			if (get_user(kp->length, &up->length) ||
+				get_user(kp->m.offset, &up->m.offset))
+				return -EFAULT;
+			break;
+		case V4L2_MEMORY_USERPTR:
+			{
+			compat_long_t tmp;
+
+			if (get_user(kp->length, &up->length) ||
+			    get_user(tmp, &up->m.userptr))
+				return -EFAULT;
+
+			kp->m.userptr = (unsigned long)compat_ptr(tmp);
+			}
+			break;
+		case V4L2_MEMORY_OVERLAY:
+			if (get_user(kp->m.offset, &up->m.offset))
+				return -EFAULT;
+			break;
+		}
 	}
+
 	return 0;
 }
 
 static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user *up)
 {
+	struct v4l2_plane32 __user *uplane32;
+	struct v4l2_plane __user *uplane;
+	compat_caddr_t p;
+	int num_planes;
+	int ret;
+
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_buffer32)) ||
 		put_user(kp->index, &up->index) ||
 		put_user(kp->type, &up->type) ||
@@ -507,22 +644,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->memory, &up->memory) ||
 		put_user(kp->input, &up->input))
 			return -EFAULT;
-	switch (kp->memory) {
-	case V4L2_MEMORY_MMAP:
-		if (put_user(kp->length, &up->length) ||
-			put_user(kp->m.offset, &up->m.offset))
-			return -EFAULT;
-		break;
-	case V4L2_MEMORY_USERPTR:
-		if (put_user(kp->length, &up->length) ||
-			put_user(kp->m.userptr, &up->m.userptr))
-			return -EFAULT;
-		break;
-	case V4L2_MEMORY_OVERLAY:
-		if (put_user(kp->m.offset, &up->m.offset))
-			return -EFAULT;
-		break;
-	}
+
 	if (put_user(kp->bytesused, &up->bytesused) ||
 		put_user(kp->field, &up->field) ||
 		put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
@@ -531,6 +653,43 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->sequence, &up->sequence) ||
 		put_user(kp->reserved, &up->reserved))
 			return -EFAULT;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
+		num_planes = kp->length;
+		if (num_planes == 0)
+			return 0;
+
+		uplane = kp->m.planes;
+		if (get_user(p, &up->m.planes))
+			return -EFAULT;
+		uplane32 = compat_ptr(p);
+
+		while (--num_planes >= 0) {
+			ret = put_v4l2_plane32(uplane, uplane32, kp->memory);
+			if (ret)
+				return ret;
+			++uplane;
+			++uplane32;
+		}
+	} else {
+		switch (kp->memory) {
+		case V4L2_MEMORY_MMAP:
+			if (put_user(kp->length, &up->length) ||
+				put_user(kp->m.offset, &up->m.offset))
+				return -EFAULT;
+			break;
+		case V4L2_MEMORY_USERPTR:
+			if (put_user(kp->length, &up->length) ||
+				put_user(kp->m.userptr, &up->m.userptr))
+				return -EFAULT;
+			break;
+		case V4L2_MEMORY_OVERLAY:
+			if (put_user(kp->m.offset, &up->m.offset))
+				return -EFAULT;
+			break;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.1.569.g6f426

