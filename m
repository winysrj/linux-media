Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:53065 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751466AbeAZMna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 07:43:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/12] v4l2-compat-ioctl32.c: fix the indentation
Date: Fri, 26 Jan 2018 13:43:19 +0100
Message-Id: <20180126124327.16653-5-hverkuil@xs4all.nl>
In-Reply-To: <20180126124327.16653-1-hverkuil@xs4all.nl>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The indentation of this source is all over the place. Fix this.
This patch only changes whitespace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 212 +++++++++++++-------------
 1 file changed, 107 insertions(+), 105 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 76ed43e774dd..83066b21b0b2 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -49,12 +49,12 @@ struct v4l2_window32 {
 static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_window32)) ||
-		copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
-		get_user(kp->field, &up->field) ||
-		get_user(kp->chromakey, &up->chromakey) ||
-		get_user(kp->clipcount, &up->clipcount) ||
-		get_user(kp->global_alpha, &up->global_alpha))
-			return -EFAULT;
+	    copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
+	    get_user(kp->field, &up->field) ||
+	    get_user(kp->chromakey, &up->chromakey) ||
+	    get_user(kp->clipcount, &up->clipcount) ||
+	    get_user(kp->global_alpha, &up->global_alpha))
+		return -EFAULT;
 	if (kp->clipcount > 2048)
 		return -EINVAL;
 	if (kp->clipcount) {
@@ -84,11 +84,11 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
 	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
-		put_user(kp->field, &up->field) ||
-		put_user(kp->chromakey, &up->chromakey) ||
-		put_user(kp->clipcount, &up->clipcount) ||
-		put_user(kp->global_alpha, &up->global_alpha))
-			return -EFAULT;
+	    put_user(kp->field, &up->field) ||
+	    put_user(kp->chromakey, &up->chromakey) ||
+	    put_user(kp->clipcount, &up->clipcount) ||
+	    put_user(kp->global_alpha, &up->global_alpha))
+		return -EFAULT;
 	return 0;
 }
 
@@ -100,7 +100,7 @@ static inline int get_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pi
 }
 
 static inline int get_v4l2_pix_format_mplane(struct v4l2_pix_format_mplane *kp,
-				struct v4l2_pix_format_mplane __user *up)
+					     struct v4l2_pix_format_mplane __user *up)
 {
 	if (copy_from_user(kp, up, sizeof(struct v4l2_pix_format_mplane)))
 		return -EFAULT;
@@ -115,7 +115,7 @@ static inline int put_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pi
 }
 
 static inline int put_v4l2_pix_format_mplane(struct v4l2_pix_format_mplane *kp,
-				struct v4l2_pix_format_mplane __user *up)
+					     struct v4l2_pix_format_mplane __user *up)
 {
 	if (copy_to_user(up, kp, sizeof(struct v4l2_pix_format_mplane)))
 		return -EFAULT;
@@ -238,7 +238,7 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 		return get_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
 	default:
 		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-								kp->type);
+			kp->type);
 		return -EINVAL;
 	}
 }
@@ -287,7 +287,7 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 		return put_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
 	default:
 		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-								kp->type);
+			kp->type);
 		return -EINVAL;
 	}
 }
@@ -321,7 +321,7 @@ static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32
 {
 	/* other fields are not set by the user, nor used by the driver */
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_standard32)) ||
-		get_user(kp->index, &up->index))
+	    get_user(kp->index, &up->index))
 		return -EFAULT;
 	return 0;
 }
@@ -329,13 +329,14 @@ static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32
 static int put_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32 __user *up)
 {
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_standard32)) ||
-		put_user(kp->index, &up->index) ||
-		put_user(kp->id, &up->id) ||
-		copy_to_user(up->name, kp->name, 24) ||
-		copy_to_user(&up->frameperiod, &kp->frameperiod, sizeof(kp->frameperiod)) ||
-		put_user(kp->framelines, &up->framelines) ||
-		copy_to_user(up->reserved, kp->reserved, 4 * sizeof(__u32)))
-			return -EFAULT;
+	    put_user(kp->index, &up->index) ||
+	    put_user(kp->id, &up->id) ||
+	    copy_to_user(up->name, kp->name, 24) ||
+	    copy_to_user(&up->frameperiod, &kp->frameperiod,
+			 sizeof(kp->frameperiod)) ||
+	    put_user(kp->framelines, &up->framelines) ||
+	    copy_to_user(up->reserved, kp->reserved, 4 * sizeof(__u32)))
+		return -EFAULT;
 	return 0;
 }
 
@@ -375,14 +376,14 @@ struct v4l2_buffer32 {
 };
 
 static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __user *up32,
-				enum v4l2_memory memory)
+			    enum v4l2_memory memory)
 {
 	void __user *up_pln;
 	compat_long_t p;
 
 	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
-		copy_in_user(&up->data_offset, &up32->data_offset,
-				sizeof(__u32)))
+	    copy_in_user(&up->data_offset, &up32->data_offset,
+			 sizeof(__u32)))
 		return -EFAULT;
 
 	if (memory == V4L2_MEMORY_USERPTR) {
@@ -396,7 +397,7 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
 			return -EFAULT;
 	} else {
 		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
-					sizeof(__u32)))
+				 sizeof(__u32)))
 			return -EFAULT;
 	}
 
@@ -404,23 +405,23 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
 }
 
 static int put_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __user *up32,
-				enum v4l2_memory memory)
+			    enum v4l2_memory memory)
 {
 	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
-		copy_in_user(&up32->data_offset, &up->data_offset,
-				sizeof(__u32)))
+	    copy_in_user(&up32->data_offset, &up->data_offset,
+			 sizeof(__u32)))
 		return -EFAULT;
 
 	/* For MMAP, driver might've set up the offset, so copy it back.
 	 * USERPTR stays the same (was userspace-provided), so no copying. */
 	if (memory == V4L2_MEMORY_MMAP)
 		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
-					sizeof(__u32)))
+				 sizeof(__u32)))
 			return -EFAULT;
 	/* For DMABUF, driver might've set up the fd, so copy it back. */
 	if (memory == V4L2_MEMORY_DMABUF)
 		if (copy_in_user(&up32->m.fd, &up->m.fd,
-					sizeof(int)))
+				 sizeof(int)))
 			return -EFAULT;
 
 	return 0;
@@ -434,19 +435,19 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	int ret;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_buffer32)) ||
-		get_user(kp->index, &up->index) ||
-		get_user(kp->type, &up->type) ||
-		get_user(kp->flags, &up->flags) ||
-		get_user(kp->memory, &up->memory) ||
-		get_user(kp->length, &up->length))
-			return -EFAULT;
+	    get_user(kp->index, &up->index) ||
+	    get_user(kp->type, &up->type) ||
+	    get_user(kp->flags, &up->flags) ||
+	    get_user(kp->memory, &up->memory) ||
+	    get_user(kp->length, &up->length))
+		return -EFAULT;
 
 	if (V4L2_TYPE_IS_OUTPUT(kp->type))
 		if (get_user(kp->bytesused, &up->bytesused) ||
-			get_user(kp->field, &up->field) ||
-			get_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-			get_user(kp->timestamp.tv_usec,
-					&up->timestamp.tv_usec))
+		    get_user(kp->field, &up->field) ||
+		    get_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
+		    get_user(kp->timestamp.tv_usec,
+			     &up->timestamp.tv_usec))
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
@@ -466,7 +467,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 
 		uplane32 = compat_ptr(p);
 		if (!access_ok(VERIFY_READ, uplane32,
-				kp->length * sizeof(struct v4l2_plane32)))
+			       kp->length * sizeof(struct v4l2_plane32)))
 			return -EFAULT;
 
 		/* We don't really care if userspace decides to kill itself
@@ -490,12 +491,12 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			break;
 		case V4L2_MEMORY_USERPTR:
 			{
-			compat_long_t tmp;
+				compat_long_t tmp;
 
-			if (get_user(tmp, &up->m.userptr))
-				return -EFAULT;
+				if (get_user(tmp, &up->m.userptr))
+					return -EFAULT;
 
-			kp->m.userptr = (unsigned long)compat_ptr(tmp);
+				kp->m.userptr = (unsigned long)compat_ptr(tmp);
 			}
 			break;
 		case V4L2_MEMORY_OVERLAY:
@@ -521,22 +522,23 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	int ret;
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_buffer32)) ||
-		put_user(kp->index, &up->index) ||
-		put_user(kp->type, &up->type) ||
-		put_user(kp->flags, &up->flags) ||
-		put_user(kp->memory, &up->memory))
-			return -EFAULT;
+	    put_user(kp->index, &up->index) ||
+	    put_user(kp->type, &up->type) ||
+	    put_user(kp->flags, &up->flags) ||
+	    put_user(kp->memory, &up->memory))
+		return -EFAULT;
 
 	if (put_user(kp->bytesused, &up->bytesused) ||
-		put_user(kp->field, &up->field) ||
-		put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
-		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
-		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->reserved2, &up->reserved2) ||
-		put_user(kp->reserved, &up->reserved) ||
-		put_user(kp->length, &up->length))
-			return -EFAULT;
+	    put_user(kp->field, &up->field) ||
+	    put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
+	    put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
+	    copy_to_user(&up->timecode, &kp->timecode,
+			 sizeof(struct v4l2_timecode)) ||
+	    put_user(kp->sequence, &up->sequence) ||
+	    put_user(kp->reserved2, &up->reserved2) ||
+	    put_user(kp->reserved, &up->reserved) ||
+	    put_user(kp->length, &up->length))
+		return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
 		num_planes = kp->length;
@@ -600,11 +602,11 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 	u32 tmp;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_framebuffer32)) ||
-		get_user(tmp, &up->base) ||
-		get_user(kp->capability, &up->capability) ||
-		get_user(kp->flags, &up->flags) ||
-		copy_from_user(&kp->fmt, &up->fmt, sizeof(up->fmt)))
-			return -EFAULT;
+	    get_user(tmp, &up->base) ||
+	    get_user(kp->capability, &up->capability) ||
+	    get_user(kp->flags, &up->flags) ||
+	    copy_from_user(&kp->fmt, &up->fmt, sizeof(up->fmt)))
+		return -EFAULT;
 	kp->base = (__force void *)compat_ptr(tmp);
 	return 0;
 }
@@ -614,11 +616,11 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 	u32 tmp = (u32)((unsigned long)kp->base);
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_framebuffer32)) ||
-		put_user(tmp, &up->base) ||
-		put_user(kp->capability, &up->capability) ||
-		put_user(kp->flags, &up->flags) ||
-		copy_to_user(&up->fmt, &kp->fmt, sizeof(up->fmt)))
-			return -EFAULT;
+	    put_user(tmp, &up->base) ||
+	    put_user(kp->capability, &up->capability) ||
+	    put_user(kp->flags, &up->flags) ||
+	    copy_to_user(&up->fmt, &kp->fmt, sizeof(up->fmt)))
+		return -EFAULT;
 	return 0;
 }
 
@@ -694,12 +696,12 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	compat_caddr_t p;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_ext_controls32)) ||
-		get_user(kp->which, &up->which) ||
-		get_user(kp->count, &up->count) ||
-		get_user(kp->error_idx, &up->error_idx) ||
-		copy_from_user(kp->reserved, up->reserved,
-			       sizeof(kp->reserved)))
-			return -EFAULT;
+	    get_user(kp->which, &up->which) ||
+	    get_user(kp->count, &up->count) ||
+	    get_user(kp->error_idx, &up->error_idx) ||
+	    copy_from_user(kp->reserved, up->reserved,
+			   sizeof(kp->reserved)))
+		return -EFAULT;
 	if (kp->count == 0) {
 		kp->controls = NULL;
 		return 0;
@@ -710,7 +712,7 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
 	if (!access_ok(VERIFY_READ, ucontrols,
-			kp->count * sizeof(struct v4l2_ext_control32)))
+		       kp->count * sizeof(struct v4l2_ext_control32)))
 		return -EFAULT;
 	kcontrols = compat_alloc_user_space(kp->count *
 					    sizeof(struct v4l2_ext_control));
@@ -746,11 +748,11 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	compat_caddr_t p;
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_ext_controls32)) ||
-		put_user(kp->which, &up->which) ||
-		put_user(kp->count, &up->count) ||
-		put_user(kp->error_idx, &up->error_idx) ||
-		copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
-			return -EFAULT;
+	    put_user(kp->which, &up->which) ||
+	    put_user(kp->count, &up->count) ||
+	    put_user(kp->error_idx, &up->error_idx) ||
+	    copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+		return -EFAULT;
 	if (!kp->count)
 		return 0;
 
@@ -758,7 +760,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
 	if (!access_ok(VERIFY_WRITE, ucontrols,
-			n * sizeof(struct v4l2_ext_control32)))
+		       n * sizeof(struct v4l2_ext_control32)))
 		return -EFAULT;
 
 	while (--n >= 0) {
@@ -796,15 +798,15 @@ struct v4l2_event32 {
 static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
 {
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_event32)) ||
-		put_user(kp->type, &up->type) ||
-		copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
-		put_user(kp->pending, &up->pending) ||
-		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-		put_user(kp->timestamp.tv_nsec, &up->timestamp.tv_nsec) ||
-		put_user(kp->id, &up->id) ||
-		copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
-			return -EFAULT;
+	    put_user(kp->type, &up->type) ||
+	    copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
+	    put_user(kp->pending, &up->pending) ||
+	    put_user(kp->sequence, &up->sequence) ||
+	    put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
+	    put_user(kp->timestamp.tv_nsec, &up->timestamp.tv_nsec) ||
+	    put_user(kp->id, &up->id) ||
+	    copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
+		return -EFAULT;
 	return 0;
 }
 
@@ -821,12 +823,12 @@ static int get_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 	u32 tmp;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_edid32)) ||
-		get_user(kp->pad, &up->pad) ||
-		get_user(kp->start_block, &up->start_block) ||
-		get_user(kp->blocks, &up->blocks) ||
-		get_user(tmp, &up->edid) ||
-		copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
-			return -EFAULT;
+	    get_user(kp->pad, &up->pad) ||
+	    get_user(kp->start_block, &up->start_block) ||
+	    get_user(kp->blocks, &up->blocks) ||
+	    get_user(tmp, &up->edid) ||
+	    copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+		return -EFAULT;
 	kp->edid = (__force u8 *)compat_ptr(tmp);
 	return 0;
 }
@@ -836,12 +838,12 @@ static int put_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 	u32 tmp = (u32)((unsigned long)kp->edid);
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_edid32)) ||
-		put_user(kp->pad, &up->pad) ||
-		put_user(kp->start_block, &up->start_block) ||
-		put_user(kp->blocks, &up->blocks) ||
-		put_user(tmp, &up->edid) ||
-		copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
-			return -EFAULT;
+	    put_user(kp->pad, &up->pad) ||
+	    put_user(kp->start_block, &up->start_block) ||
+	    put_user(kp->blocks, &up->blocks) ||
+	    put_user(tmp, &up->edid) ||
+	    copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.15.1
