Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:48274 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754707AbeBNMDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:03:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v3.2 05/12] media: v4l2-compat-ioctl32.c: avoid sizeof(type)
Date: Wed, 14 Feb 2018 13:03:16 +0100
Message-Id: <20180214120323.28778-6-hverkuil@xs4all.nl>
In-Reply-To: <20180214120323.28778-1-hverkuil@xs4all.nl>
References: <20180214120323.28778-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 333b1e9f96ce05f7498b581509bb30cde03018bf upstream.

Instead of doing sizeof(struct foo) use sizeof(*up). There even were
cases where 4 * sizeof(__u32) was used instead of sizeof(kp->reserved),
which is very dangerous when the size of the reserved array changes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c | 65 +++++++++++++++----------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 4d0901573860..e2dee29eaaa5 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -47,7 +47,7 @@ struct v4l2_window32 {
 
 static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_window32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
 	    get_user(kp->field, &up->field) ||
 	    get_user(kp->chromakey, &up->chromakey) ||
@@ -64,7 +64,7 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 		if (get_user(p, &up->clips))
 			return -EFAULT;
 		uclips = compat_ptr(p);
-		kclips = compat_alloc_user_space(n * sizeof(struct v4l2_clip));
+		kclips = compat_alloc_user_space(n * sizeof(*kclips));
 		kp->clips = kclips;
 		while (--n >= 0) {
 			if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
@@ -156,14 +156,14 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 
 static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)))
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
 		return -EFAULT;
 	return __get_v4l2_format32(kp, up);
 }
 
 static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format)))
 		return -EFAULT;
 	return __get_v4l2_format32(&kp->format, &up->format);
@@ -204,7 +204,7 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 
 static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->type, &up->type))
 		return -EFAULT;
 	return __put_v4l2_format32(kp, up);
@@ -212,7 +212,7 @@ static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
 
 static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format.fmt)))
 		return -EFAULT;
 	return __put_v4l2_format32(&kp->format, &up->format);
@@ -230,7 +230,7 @@ struct v4l2_standard32 {
 static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32 __user *up)
 {
 	/* other fields are not set by the user, nor used by the driver */
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_standard32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->index, &up->index))
 		return -EFAULT;
 	return 0;
@@ -238,13 +238,13 @@ static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32
 
 static int put_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_standard32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->index, &up->index) ||
 	    copy_to_user(up->id, &kp->id, sizeof(__u64)) ||
-	    copy_to_user(up->name, kp->name, 24) ||
+	    copy_to_user(up->name, kp->name, sizeof(up->name)) ||
 	    copy_to_user(&up->frameperiod, &kp->frameperiod, sizeof(kp->frameperiod)) ||
 	    put_user(kp->framelines, &up->framelines) ||
-	    copy_to_user(up->reserved, kp->reserved, 4 * sizeof(__u32)))
+	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -290,7 +290,7 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 
 	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
 	    copy_in_user(&up->data_offset, &up32->data_offset,
-			 sizeof(__u32)))
+			 sizeof(up->data_offset)))
 		return -EFAULT;
 
 	if (memory == V4L2_MEMORY_USERPTR) {
@@ -301,7 +301,7 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 			return -EFAULT;
 	} else {
 		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
-				 sizeof(__u32)))
+				 sizeof(up32->m.mem_offset)))
 			return -EFAULT;
 	}
 
@@ -313,14 +313,14 @@ static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 {
 	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
 	    copy_in_user(&up32->data_offset, &up->data_offset,
-			 sizeof(__u32)))
+			 sizeof(up->data_offset)))
 		return -EFAULT;
 
 	/* For MMAP, driver might've set up the offset, so copy it back.
 	 * USERPTR stays the same (was userspace-provided), so no copying. */
 	if (memory == V4L2_MEMORY_MMAP)
 		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
-				 sizeof(__u32)))
+				 sizeof(up->m.mem_offset)))
 			return -EFAULT;
 
 	return 0;
@@ -334,7 +334,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	int num_planes;
 	int ret;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_buffer32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->index, &up->index) ||
 	    get_user(kp->type, &up->type) ||
 	    get_user(kp->flags, &up->flags) ||
@@ -346,8 +346,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		if (get_user(kp->bytesused, &up->bytesused) ||
 		    get_user(kp->field, &up->field) ||
 		    get_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-		    get_user(kp->timestamp.tv_usec,
-			     &up->timestamp.tv_usec))
+		    get_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec))
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
@@ -367,13 +366,13 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 
 		uplane32 = compat_ptr(p);
 		if (!access_ok(VERIFY_READ, uplane32,
-			       num_planes * sizeof(struct v4l2_plane32)))
+			       num_planes * sizeof(*uplane32)))
 			return -EFAULT;
 
 		/* We don't really care if userspace decides to kill itself
 		 * by passing a very big num_planes value */
 		uplane = compat_alloc_user_space(num_planes *
-						 sizeof(struct v4l2_plane));
+						 sizeof(*uplane));
 		kp->m.planes = uplane;
 
 		while (--num_planes >= 0) {
@@ -419,7 +418,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	int num_planes;
 	int ret;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_buffer32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->index, &up->index) ||
 	    put_user(kp->type, &up->type) ||
 	    put_user(kp->flags, &up->flags) ||
@@ -431,7 +430,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	    put_user(kp->field, &up->field) ||
 	    put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
 	    put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
-	    copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
+	    copy_to_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
 	    put_user(kp->sequence, &up->sequence) ||
 	    put_user(kp->reserved, &up->reserved))
 		return -EFAULT;
@@ -486,7 +485,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 {
 	u32 tmp;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_framebuffer32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(tmp, &up->base) ||
 	    get_user(kp->capability, &up->capability) ||
 	    get_user(kp->flags, &up->flags) ||
@@ -500,7 +499,7 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 {
 	u32 tmp = (u32)((unsigned long)kp->base);
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_framebuffer32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(tmp, &up->base) ||
 	    put_user(kp->capability, &up->capability) ||
 	    put_user(kp->flags, &up->flags) ||
@@ -524,14 +523,14 @@ struct v4l2_input32 {
    Otherwise it is identical to the 32-bit version. */
 static inline int get_v4l2_input32(struct v4l2_input *kp, struct v4l2_input32 __user *up)
 {
-	if (copy_from_user(kp, up, sizeof(struct v4l2_input32)))
+	if (copy_from_user(kp, up, sizeof(*up)))
 		return -EFAULT;
 	return 0;
 }
 
 static inline int put_v4l2_input32(struct v4l2_input *kp, struct v4l2_input32 __user *up)
 {
-	if (copy_to_user(up, kp, sizeof(struct v4l2_input32)))
+	if (copy_to_user(up, kp, sizeof(*up)))
 		return -EFAULT;
 	return 0;
 }
@@ -579,7 +578,7 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	int n;
 	compat_caddr_t p;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_ext_controls32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->ctrl_class, &up->ctrl_class) ||
 	    get_user(kp->count, &up->count) ||
 	    get_user(kp->error_idx, &up->error_idx) ||
@@ -593,10 +592,9 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_READ, ucontrols,
-		       n * sizeof(struct v4l2_ext_control32)))
+	if (!access_ok(VERIFY_READ, ucontrols, n * sizeof(*ucontrols)))
 		return -EFAULT;
-	kcontrols = compat_alloc_user_space(n * sizeof(struct v4l2_ext_control));
+	kcontrols = compat_alloc_user_space(n * sizeof(*kcontrols));
 	kp->controls = kcontrols;
 	while (--n >= 0) {
 		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
@@ -623,7 +621,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	int n = kp->count;
 	compat_caddr_t p;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_ext_controls32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->ctrl_class, &up->ctrl_class) ||
 	    put_user(kp->count, &up->count) ||
 	    put_user(kp->error_idx, &up->error_idx) ||
@@ -635,8 +633,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_WRITE, ucontrols,
-		       n * sizeof(struct v4l2_ext_control32)))
+	if (!access_ok(VERIFY_WRITE, ucontrols, n * sizeof(*ucontrols)))
 		return -EFAULT;
 
 	while (--n >= 0) {
@@ -669,14 +666,14 @@ struct v4l2_event32 {
 
 static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_event32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->type, &up->type) ||
 	    copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
 	    put_user(kp->pending, &up->pending) ||
 	    put_user(kp->sequence, &up->sequence) ||
 	    put_compat_timespec(&kp->timestamp, &up->timestamp) ||
 	    put_user(kp->id, &up->id) ||
-	    copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
+	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
 	return 0;
 }
-- 
2.15.1
