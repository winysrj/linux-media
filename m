Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41691 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967547AbeBNLyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:54:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v4.1 06/14] media: v4l2-compat-ioctl32.c: avoid sizeof(type)
Date: Wed, 14 Feb 2018 12:54:11 +0100
Message-Id: <20180214115419.28156-7-hverkuil@xs4all.nl>
In-Reply-To: <20180214115419.28156-1-hverkuil@xs4all.nl>
References: <20180214115419.28156-1-hverkuil@xs4all.nl>
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
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 74 +++++++++++++--------------
 1 file changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 2a116d671f92..03d1d92a2a8e 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
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
@@ -152,14 +152,14 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 
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
@@ -199,14 +199,14 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 
 static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)))
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)))
 		return -EFAULT;
 	return __put_v4l2_format32(kp, up);
 }
 
 static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format)) ||
 	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
@@ -225,7 +225,7 @@ struct v4l2_standard32 {
 static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32 __user *up)
 {
 	/* other fields are not set by the user, nor used by the driver */
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_standard32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->index, &up->index))
 		return -EFAULT;
 	return 0;
@@ -233,13 +233,13 @@ static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32
 
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
@@ -287,7 +287,7 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
 
 	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
 	    copy_in_user(&up->data_offset, &up32->data_offset,
-			 sizeof(__u32)))
+			 sizeof(up->data_offset)))
 		return -EFAULT;
 
 	if (memory == V4L2_MEMORY_USERPTR) {
@@ -297,11 +297,11 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
 		if (put_user((unsigned long)up_pln, &up->m.userptr))
 			return -EFAULT;
 	} else if (memory == V4L2_MEMORY_DMABUF) {
-		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(int)))
+		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
 			return -EFAULT;
 	} else {
 		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
-				 sizeof(__u32)))
+				 sizeof(up32->m.mem_offset)))
 			return -EFAULT;
 	}
 
@@ -313,19 +313,19 @@ static int put_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
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
 	/* For DMABUF, driver might've set up the fd, so copy it back. */
 	if (memory == V4L2_MEMORY_DMABUF)
 		if (copy_in_user(&up32->m.fd, &up->m.fd,
-				 sizeof(int)))
+				 sizeof(up->m.fd)))
 			return -EFAULT;
 
 	return 0;
@@ -339,7 +339,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	int num_planes;
 	int ret;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_buffer32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->index, &up->index) ||
 	    get_user(kp->type, &up->type) ||
 	    get_user(kp->flags, &up->flags) ||
@@ -351,8 +351,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		if (get_user(kp->bytesused, &up->bytesused) ||
 		    get_user(kp->field, &up->field) ||
 		    get_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-		    get_user(kp->timestamp.tv_usec,
-			     &up->timestamp.tv_usec))
+		    get_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec))
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
@@ -369,13 +368,12 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 
 		uplane32 = compat_ptr(p);
 		if (!access_ok(VERIFY_READ, uplane32,
-			       num_planes * sizeof(struct v4l2_plane32)))
+			       num_planes * sizeof(*uplane32)))
 			return -EFAULT;
 
 		/* We don't really care if userspace decides to kill itself
 		 * by passing a very big num_planes value */
-		uplane = compat_alloc_user_space(num_planes *
-						 sizeof(struct v4l2_plane));
+		uplane = compat_alloc_user_space(num_planes * sizeof(*uplane));
 		kp->m.planes = (__force struct v4l2_plane *)uplane;
 
 		while (--num_planes >= 0) {
@@ -423,7 +421,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	int num_planes;
 	int ret;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_buffer32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->index, &up->index) ||
 	    put_user(kp->type, &up->type) ||
 	    put_user(kp->flags, &up->flags) ||
@@ -434,7 +432,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	    put_user(kp->field, &up->field) ||
 	    put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
 	    put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
-	    copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
+	    copy_to_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
 	    put_user(kp->sequence, &up->sequence) ||
 	    put_user(kp->reserved2, &up->reserved2) ||
 	    put_user(kp->reserved, &up->reserved) ||
@@ -502,7 +500,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 {
 	u32 tmp;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_framebuffer32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(tmp, &up->base) ||
 	    get_user(kp->capability, &up->capability) ||
 	    get_user(kp->flags, &up->flags) ||
@@ -516,7 +514,7 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 {
 	u32 tmp = (u32)((unsigned long)kp->base);
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_framebuffer32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(tmp, &up->base) ||
 	    put_user(kp->capability, &up->capability) ||
 	    put_user(kp->flags, &up->flags) ||
@@ -540,14 +538,14 @@ struct v4l2_input32 {
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
@@ -595,7 +593,7 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	int n;
 	compat_caddr_t p;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_ext_controls32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->ctrl_class, &up->ctrl_class) ||
 	    get_user(kp->count, &up->count) ||
 	    get_user(kp->error_idx, &up->error_idx) ||
@@ -609,10 +607,9 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_READ, ucontrols,
-		       n * sizeof(struct v4l2_ext_control32)))
+	if (!access_ok(VERIFY_READ, ucontrols, n * sizeof(*ucontrols)))
 		return -EFAULT;
-	kcontrols = compat_alloc_user_space(n * sizeof(struct v4l2_ext_control));
+	kcontrols = compat_alloc_user_space(n * sizeof(*kcontrols));
 	kp->controls = (__force struct v4l2_ext_control *)kcontrols;
 	while (--n >= 0) {
 		u32 id;
@@ -644,7 +641,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	int n = kp->count;
 	compat_caddr_t p;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_ext_controls32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->ctrl_class, &up->ctrl_class) ||
 	    put_user(kp->count, &up->count) ||
 	    put_user(kp->error_idx, &up->error_idx) ||
@@ -656,8 +653,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_WRITE, ucontrols,
-		       n * sizeof(struct v4l2_ext_control32)))
+	if (!access_ok(VERIFY_WRITE, ucontrols, n * sizeof(*ucontrols)))
 		return -EFAULT;
 
 	while (--n >= 0) {
@@ -693,7 +689,7 @@ struct v4l2_event32 {
 
 static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_event32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->type, &up->type) ||
 	    copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
 	    put_user(kp->pending, &up->pending) ||
@@ -701,7 +697,7 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 	    put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
 	    put_user(kp->timestamp.tv_nsec, &up->timestamp.tv_nsec) ||
 	    put_user(kp->id, &up->id) ||
-	    copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
+	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -718,7 +714,7 @@ static int get_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 {
 	u32 tmp;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_edid32)) ||
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(kp->pad, &up->pad) ||
 	    get_user(kp->start_block, &up->start_block) ||
 	    get_user(kp->blocks, &up->blocks) ||
@@ -733,7 +729,7 @@ static int put_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 {
 	u32 tmp = (u32)((unsigned long)kp->edid);
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_edid32)) ||
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
 	    put_user(kp->pad, &up->pad) ||
 	    put_user(kp->start_block, &up->start_block) ||
 	    put_user(kp->blocks, &up->blocks) ||
-- 
2.15.1
