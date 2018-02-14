Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:39539 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754718AbeBNMDZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:03:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v3.2 12/12] media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic
Date: Wed, 14 Feb 2018 13:03:23 +0100
Message-Id: <20180214120323.28778-13-hverkuil@xs4all.nl>
In-Reply-To: <20180214120323.28778-1-hverkuil@xs4all.nl>
References: <20180214120323.28778-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Mentz <danielmentz@google.com>

commit a1dfb4c48cc1e64eeb7800a27c66a6f7e88d075a upstream.

The 32-bit compat v4l2 ioctl handling is implemented based on its 64-bit
equivalent. It converts 32-bit data structures into its 64-bit
equivalents and needs to provide the data to the 64-bit ioctl in user
space memory which is commonly allocated using
compat_alloc_user_space().

However, due to how that function is implemented, it can only be called
a single time for every syscall invocation.

Supposedly to avoid this limitation, the existing code uses a mix of
memory from the kernel stack and memory allocated through
compat_alloc_user_space().

Under normal circumstances, this would not work, because the 64-bit
ioctl expects all pointers to point to user space memory. As a
workaround, set_fs(KERNEL_DS) is called to temporarily disable this
extra safety check and allow kernel pointers. However, this might
introduce a security vulnerability: The result of the 32-bit to 64-bit
conversion is writeable by user space because the output buffer has been
allocated via compat_alloc_user_space(). A malicious user space process
could then manipulate pointers inside this output buffer, and due to the
previous set_fs(KERNEL_DS) call, functions like get_user() or put_user()
no longer prevent kernel memory access.

The new approach is to pre-calculate the total amount of user space
memory that is needed, allocate it using compat_alloc_user_space() and
then divide up the allocated memory to accommodate all data structures
that need to be converted.

An alternative approach would have been to retain the union type karg
that they allocated on the kernel stack in do_video_ioctl(), copy all
data from user space into karg and then back to user space. However, we
decided against this approach because it does not align with other
compat syscall implementations. Instead, we tried to replicate the
get_user/put_user pairs as found in other places in the kernel:

    if (get_user(clipcount, &up->clipcount) ||
        put_user(clipcount, &kp->clipcount)) return -EFAULT;

Notes from hans.verkuil@cisco.com:

This patch was taken from:
    https://github.com/LineageOS/android_kernel_samsung_apq8084/commit/97b733953c06e4f0398ade18850f0817778255f7

Clearly nobody could be bothered to upstream this patch or at minimum
tell us :-( We only heard about this a week ago.

This patch was rebased and cleaned up. Compared to the original I
also swapped the order of the convert_in_user arguments so that they
matched copy_in_user. It was hard to review otherwise. I also replaced
the ALLOC_USER_SPACE/ALLOC_AND_GET by a normal function.

Fixes: 6b5a9492ca ("v4l: introduce string control support.")

Signed-off-by: Daniel Mentz <danielmentz@google.com>
Co-developed-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/video/Makefile              |   7 +-
 drivers/media/video/v4l2-compat-ioctl32.c | 738 +++++++++++++++++++-----------
 2 files changed, 481 insertions(+), 264 deletions(-)

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 117f9c4b4cb9..aa1e164cfb87 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -13,12 +13,13 @@ omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
 			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
 
+ifeq ($(CONFIG_COMPAT),y)
+  videodev-objs += v4l2-compat-ioctl32.o
+endif
+
 # V4L2 core modules
 
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
-ifeq ($(CONFIG_COMPAT),y)
-  obj-$(CONFIG_VIDEO_DEV) += v4l2-compat-ioctl32.o
-endif
 
 obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
 
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 7f0eeb8a4d3f..b4f19238c746 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -23,6 +23,14 @@
 
 #ifdef CONFIG_COMPAT
 
+/* Use the same argument order as copy_in_user */
+#define assign_in_user(to, from)					\
+({									\
+	typeof(*from) __assign_tmp;					\
+									\
+	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
+})
+
 static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret = -ENOIOCTLCMD;
@@ -36,12 +44,12 @@ static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 struct v4l2_clip32 {
 	struct v4l2_rect        c;
-	compat_caddr_t 		next;
+	compat_caddr_t		next;
 };
 
 struct v4l2_window32 {
 	struct v4l2_rect        w;
-	enum v4l2_field  	field;
+	__u32			field;	/* enum v4l2_field */
 	__u32			chromakey;
 	compat_caddr_t		clips; /* actually struct v4l2_clip32 * */
 	__u32			clipcount;
@@ -49,37 +57,41 @@ struct v4l2_window32 {
 	__u8                    global_alpha;
 };
 
-static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
+static int get_v4l2_window32(struct v4l2_window __user *kp,
+			     struct v4l2_window32 __user *up,
+			     void __user *aux_buf, u32 aux_space)
 {
 	struct v4l2_clip32 __user *uclips;
 	struct v4l2_clip __user *kclips;
 	compat_caddr_t p;
-	u32 n;
+	u32 clipcount;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
-	    get_user(kp->field, &up->field) ||
-	    get_user(kp->chromakey, &up->chromakey) ||
-	    get_user(kp->clipcount, &up->clipcount) ||
-	    get_user(kp->global_alpha, &up->global_alpha))
+	    copy_in_user(&kp->w, &up->w, sizeof(up->w)) ||
+	    assign_in_user(&kp->field, &up->field) ||
+	    assign_in_user(&kp->chromakey, &up->chromakey) ||
+	    assign_in_user(&kp->global_alpha, &up->global_alpha) ||
+	    get_user(clipcount, &up->clipcount) ||
+	    put_user(clipcount, &kp->clipcount))
 		return -EFAULT;
-	if (kp->clipcount > 2048)
+	if (clipcount > 2048)
 		return -EINVAL;
-	if (!kp->clipcount) {
-		kp->clips = NULL;
-		return 0;
-	}
+	if (!clipcount)
+		return put_user(NULL, &kp->clips);
 
-	n = kp->clipcount;
 	if (get_user(p, &up->clips))
 		return -EFAULT;
 	uclips = compat_ptr(p);
-	kclips = compat_alloc_user_space(n * sizeof(*kclips));
-	kp->clips = kclips;
-	while (n--) {
+	if (aux_space < clipcount * sizeof(*kclips))
+		return -EFAULT;
+	kclips = aux_buf;
+	if (put_user(kclips, &kp->clips))
+		return -EFAULT;
+
+	while (clipcount--) {
 		if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
 			return -EFAULT;
-		if (put_user(n ? kclips + 1 : NULL, &kclips->next))
+		if (put_user(clipcount ? kclips + 1 : NULL, &kclips->next))
 			return -EFAULT;
 		uclips++;
 		kclips++;
@@ -87,27 +99,28 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 	return 0;
 }
 
-static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
+static int put_v4l2_window32(struct v4l2_window __user *kp,
+			     struct v4l2_window32 __user *up)
 {
 	struct v4l2_clip __user *kclips = kp->clips;
 	struct v4l2_clip32 __user *uclips;
-	u32 n = kp->clipcount;
 	compat_caddr_t p;
-
-	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
-	    put_user(kp->field, &up->field) ||
-	    put_user(kp->chromakey, &up->chromakey) ||
-	    put_user(kp->clipcount, &up->clipcount) ||
-	    put_user(kp->global_alpha, &up->global_alpha))
+	u32 clipcount;
+
+	if (copy_in_user(&up->w, &kp->w, sizeof(kp->w)) ||
+	    assign_in_user(&up->field, &kp->field) ||
+	    assign_in_user(&up->chromakey, &kp->chromakey) ||
+	    assign_in_user(&up->global_alpha, &kp->global_alpha) ||
+	    get_user(clipcount, &kp->clipcount) ||
+	    put_user(clipcount, &up->clipcount))
 		return -EFAULT;
-
-	if (!kp->clipcount)
+	if (!clipcount)
 		return 0;
 
 	if (get_user(p, &up->clips))
 		return -EFAULT;
 	uclips = compat_ptr(p);
-	while (n--) {
+	while (clipcount--) {
 		if (copy_in_user(&uclips->c, &kclips->c, sizeof(uclips->c)))
 			return -EFAULT;
 		uclips++;
@@ -145,98 +158,150 @@ struct v4l2_create_buffers32 {
 	__u32			reserved[8];
 };
 
-static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+static int __bufsize_v4l2_format(struct v4l2_format32 __user *up, u32 *size)
+{
+	u32 type;
+
+	if (get_user(type, &up->type))
+		return -EFAULT;
+
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY: {
+		u32 clipcount;
+
+		if (get_user(clipcount, &up->fmt.win.clipcount))
+			return -EFAULT;
+		if (clipcount > 2048)
+			return -EINVAL;
+		*size = clipcount * sizeof(struct v4l2_clip);
+		return 0;
+	}
+	default:
+		*size = 0;
+		return 0;
+	}
+}
+
+static int bufsize_v4l2_format(struct v4l2_format32 __user *up, u32 *size)
 {
-	if (get_user(kp->type, &up->type))
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
 		return -EFAULT;
+	return __bufsize_v4l2_format(up, size);
+}
+
+static int __get_v4l2_format32(struct v4l2_format __user *kp,
+			       struct v4l2_format32 __user *up,
+			       void __user *aux_buf, u32 aux_space)
+{
+	u32 type;
 
-	switch (kp->type) {
+	if (get_user(type, &up->type) || put_user(type, &kp->type))
+		return -EFAULT;
+
+	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		return copy_from_user(&kp->fmt.pix, &up->fmt.pix,
-				      sizeof(kp->fmt.pix)) ? -EFAULT : 0;
+		return copy_in_user(&kp->fmt.pix, &up->fmt.pix,
+				    sizeof(kp->fmt.pix)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		return copy_from_user(&kp->fmt.pix_mp, &up->fmt.pix_mp,
-				      sizeof(kp->fmt.pix_mp)) ? -EFAULT : 0;
+		return copy_in_user(&kp->fmt.pix_mp, &up->fmt.pix_mp,
+				    sizeof(kp->fmt.pix_mp)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
- 		return get_v4l2_window32(&kp->fmt.win, &up->fmt.win);
+		return get_v4l2_window32(&kp->fmt.win, &up->fmt.win,
+					 aux_buf, aux_space);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		return copy_from_user(&kp->fmt.vbi, &up->fmt.vbi,
-				      sizeof(kp->fmt.vbi)) ? -EFAULT : 0;
+		return copy_in_user(&kp->fmt.vbi, &up->fmt.vbi,
+				    sizeof(kp->fmt.vbi)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		return copy_from_user(&kp->fmt.sliced, &up->fmt.sliced,
-				      sizeof(kp->fmt.sliced)) ? -EFAULT : 0;
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (copy_from_user(kp, up, sizeof(kp->fmt.raw_data)))
-			return -EFAULT;
-		return 0;
+		return copy_in_user(&kp->fmt.sliced, &up->fmt.sliced,
+				    sizeof(kp->fmt.sliced)) ? -EFAULT : 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+static int get_v4l2_format32(struct v4l2_format __user *kp,
+			     struct v4l2_format32 __user *up,
+			     void __user *aux_buf, u32 aux_space)
+{
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
+		return -EFAULT;
+	return __get_v4l2_format32(kp, up, aux_buf, aux_space);
+}
+
+static int bufsize_v4l2_create(struct v4l2_create_buffers32 __user *up,
+			       u32 *size)
 {
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
 		return -EFAULT;
-	return __get_v4l2_format32(kp, up);
+	return __bufsize_v4l2_format(&up->format, size);
 }
 
-static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
+static int get_v4l2_create32(struct v4l2_create_buffers __user *kp,
+			     struct v4l2_create_buffers32 __user *up,
+			     void __user *aux_buf, u32 aux_space)
 {
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format)))
+	    copy_in_user(kp, up,
+			 offsetof(struct v4l2_create_buffers32, format)))
 		return -EFAULT;
-	return __get_v4l2_format32(&kp->format, &up->format);
+	return __get_v4l2_format32(&kp->format, &up->format,
+				   aux_buf, aux_space);
 }
 
-static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+static int __put_v4l2_format32(struct v4l2_format __user *kp,
+			       struct v4l2_format32 __user *up)
 {
-	switch (kp->type) {
+	u32 type;
+
+	if (get_user(type, &kp->type))
+		return -EFAULT;
+
+	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		return copy_to_user(&up->fmt.pix, &kp->fmt.pix,
-				    sizeof(kp->fmt.pix)) ?  -EFAULT : 0;
+		return copy_in_user(&up->fmt.pix, &kp->fmt.pix,
+				    sizeof(kp->fmt.pix)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		return copy_to_user(&up->fmt.pix_mp, &kp->fmt.pix_mp,
-				    sizeof(kp->fmt.pix_mp)) ?  -EFAULT : 0;
+		return copy_in_user(&up->fmt.pix_mp, &kp->fmt.pix_mp,
+				    sizeof(kp->fmt.pix_mp)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		return put_v4l2_window32(&kp->fmt.win, &up->fmt.win);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		return copy_to_user(&up->fmt.vbi, &kp->fmt.vbi,
-				    sizeof(kp->fmt.vbi)) ?  -EFAULT : 0;
+		return copy_in_user(&up->fmt.vbi, &kp->fmt.vbi,
+				    sizeof(kp->fmt.vbi)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		return copy_to_user(&up->fmt.sliced, &kp->fmt.sliced,
-				    sizeof(kp->fmt.sliced)) ?  -EFAULT : 0;
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (copy_to_user(up, kp, sizeof(up->fmt.raw_data)))
-			return -EFAULT;
-		return 0;
+		return copy_in_user(&up->fmt.sliced, &kp->fmt.sliced,
+				    sizeof(kp->fmt.sliced)) ? -EFAULT : 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+static int put_v4l2_format32(struct v4l2_format __user *kp,
+			     struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    put_user(kp->type, &up->type))
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)))
 		return -EFAULT;
 	return __put_v4l2_format32(kp, up);
 }
 
-static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
+static int put_v4l2_create32(struct v4l2_create_buffers __user *kp,
+			     struct v4l2_create_buffers32 __user *up)
 {
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format.fmt)))
+	    copy_in_user(up, kp,
+			 offsetof(struct v4l2_create_buffers32, format)) ||
+	    copy_in_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
 	return __put_v4l2_format32(&kp->format, &up->format);
 }
@@ -250,24 +315,27 @@ struct v4l2_standard32 {
 	__u32		     reserved[4];
 };
 
-static int get_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32 __user *up)
+static int get_v4l2_standard32(struct v4l2_standard __user *kp,
+			       struct v4l2_standard32 __user *up)
 {
 	/* other fields are not set by the user, nor used by the driver */
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    get_user(kp->index, &up->index))
+	    assign_in_user(&kp->index, &up->index))
 		return -EFAULT;
 	return 0;
 }
 
-static int put_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32 __user *up)
+static int put_v4l2_standard32(struct v4l2_standard __user *kp,
+			       struct v4l2_standard32 __user *up)
 {
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    put_user(kp->index, &up->index) ||
-	    copy_to_user(up->id, &kp->id, sizeof(__u64)) ||
-	    copy_to_user(up->name, kp->name, sizeof(up->name)) ||
-	    copy_to_user(&up->frameperiod, &kp->frameperiod, sizeof(kp->frameperiod)) ||
-	    put_user(kp->framelines, &up->framelines) ||
-	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
+	    assign_in_user(&up->index, &kp->index) ||
+	    copy_in_user(&up->id, &kp->id, sizeof(up->id)) ||
+	    copy_in_user(up->name, kp->name, sizeof(up->name)) ||
+	    copy_in_user(&up->frameperiod, &kp->frameperiod,
+			 sizeof(up->frameperiod)) ||
+	    assign_in_user(&up->framelines, &kp->framelines) ||
+	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -305,11 +373,11 @@ struct v4l2_buffer32 {
 	__u32			reserved;
 };
 
-static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
+static int get_v4l2_plane32(struct v4l2_plane __user *up,
+			    struct v4l2_plane32 __user *up32,
 			    enum v4l2_memory memory)
 {
-	void __user *up_pln;
-	compat_long_t p;
+	compat_ulong_t p;
 
 	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
 	    copy_in_user(&up->data_offset, &up32->data_offset,
@@ -324,10 +392,8 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 			return -EFAULT;
 		break;
 	case V4L2_MEMORY_USERPTR:
-		if (get_user(p, &up32->m.userptr))
-			return -EFAULT;
-		up_pln = compat_ptr(p);
-		if (put_user((unsigned long)up_pln, &up->m.userptr))
+		if (get_user(p, &up32->m.userptr) ||
+		    put_user((unsigned long)compat_ptr(p), &up->m.userptr))
 			return -EFAULT;
 		break;
 	}
@@ -335,7 +401,8 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 	return 0;
 }
 
-static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
+static int put_v4l2_plane32(struct v4l2_plane __user *up,
+			    struct v4l2_plane32 __user *up32,
 			    enum v4l2_memory memory)
 {
 	unsigned long p;
@@ -363,40 +430,75 @@ static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 	return 0;
 }
 
-static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user *up)
+static int bufsize_v4l2_buffer(struct v4l2_buffer32 __user *up, u32 *size)
 {
+	u32 type;
+	u32 length;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
+	    get_user(type, &up->type) ||
+	    get_user(length, &up->length))
+		return -EFAULT;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
+		if (length > VIDEO_MAX_PLANES)
+			return -EINVAL;
+
+		/*
+		 * We don't really care if userspace decides to kill itself
+		 * by passing a very big length value
+		 */
+		*size = length * sizeof(struct v4l2_plane);
+	} else {
+		*size = 0;
+	}
+	return 0;
+}
+
+static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
+			     struct v4l2_buffer32 __user *up,
+			     void __user *aux_buf, u32 aux_space)
+{
+	u32 type;
+	u32 length;
+	enum v4l2_memory memory;
 	struct v4l2_plane32 __user *uplane32;
 	struct v4l2_plane __user *uplane;
 	compat_caddr_t p;
-	int num_planes;
 	int ret;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    get_user(kp->index, &up->index) ||
-	    get_user(kp->type, &up->type) ||
-	    get_user(kp->flags, &up->flags) ||
-	    get_user(kp->memory, &up->memory) ||
-	    get_user(kp->input, &up->input))
+	    assign_in_user(&kp->index, &up->index) ||
+	    get_user(type, &up->type) ||
+	    put_user(type, &kp->type) ||
+	    assign_in_user(&kp->flags, &up->flags) ||
+	    get_user(memory, &up->memory) ||
+	    put_user(memory, &kp->memory) ||
+	    get_user(length, &up->length) ||
+	    put_user(length, &kp->length))
 		return -EFAULT;
 
-	if (V4L2_TYPE_IS_OUTPUT(kp->type))
-		if (get_user(kp->bytesused, &up->bytesused) ||
-		    get_user(kp->field, &up->field) ||
-		    get_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-		    get_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec))
+	if (V4L2_TYPE_IS_OUTPUT(type))
+		if (assign_in_user(&kp->bytesused, &up->bytesused) ||
+		    assign_in_user(&kp->field, &up->field) ||
+		    assign_in_user(&kp->timestamp.tv_sec,
+				   &up->timestamp.tv_sec) ||
+		    assign_in_user(&kp->timestamp.tv_usec,
+				   &up->timestamp.tv_usec))
 			return -EFAULT;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
-		if (get_user(kp->length, &up->length))
-			return -EFAULT;
+	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
+		u32 num_planes = length;
 
-		num_planes = kp->length;
 		if (num_planes == 0) {
-			kp->m.planes = NULL;
-			/* num_planes == 0 is legal, e.g. when userspace doesn't
-			 * need planes array on DQBUF*/
-			return 0;
+			/*
+			 * num_planes == 0 is legal, e.g. when userspace doesn't
+			 * need planes array on DQBUF
+			 */
+			return put_user(NULL, &kp->m.planes);
 		}
+		if (num_planes > VIDEO_MAX_PLANES)
+			return -EINVAL;
 
 		if (get_user(p, &up->m.planes))
 			return -EFAULT;
@@ -406,103 +508,107 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			       num_planes * sizeof(*uplane32)))
 			return -EFAULT;
 
-		/* We don't really care if userspace decides to kill itself
-		 * by passing a very big num_planes value */
-		uplane = compat_alloc_user_space(num_planes *
-						 sizeof(*uplane));
-		kp->m.planes = uplane;
+		/*
+		 * We don't really care if userspace decides to kill itself
+		 * by passing a very big num_planes value
+		 */
+		if (aux_space < num_planes * sizeof(*uplane))
+			return -EFAULT;
+
+		uplane = aux_buf;
+		if (put_user((__force struct v4l2_plane *)uplane,
+			     &kp->m.planes))
+			return -EFAULT;
 
-		while (--num_planes >= 0) {
-			ret = get_v4l2_plane32(uplane, uplane32, kp->memory);
+		while (num_planes--) {
+			ret = get_v4l2_plane32(uplane, uplane32, memory);
 			if (ret)
 				return ret;
-			++uplane;
-			++uplane32;
+			uplane++;
+			uplane32++;
 		}
 	} else {
-		switch (kp->memory) {
+		switch (memory) {
 		case V4L2_MEMORY_MMAP:
-			if (get_user(kp->length, &up->length) ||
-			    get_user(kp->m.offset, &up->m.offset))
+		case V4L2_MEMORY_OVERLAY:
+			if (assign_in_user(&kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
-		case V4L2_MEMORY_USERPTR:
-			{
-				compat_long_t tmp;
+		case V4L2_MEMORY_USERPTR: {
+			compat_ulong_t userptr;
 
-				if (get_user(kp->length, &up->length) ||
-				    get_user(tmp, &up->m.userptr))
-					return -EFAULT;
-
-				kp->m.userptr = (unsigned long)compat_ptr(tmp);
-			}
-			break;
-		case V4L2_MEMORY_OVERLAY:
-			if (get_user(kp->m.offset, &up->m.offset))
+			if (get_user(userptr, &up->m.userptr) ||
+			    put_user((unsigned long)compat_ptr(userptr),
+				     &kp->m.userptr))
 				return -EFAULT;
 			break;
 		}
+ 		}
 	}
 
 	return 0;
 }
 
-static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user *up)
+static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
+			     struct v4l2_buffer32 __user *up)
 {
+	u32 type;
+	u32 length;
+	enum v4l2_memory memory;
 	struct v4l2_plane32 __user *uplane32;
 	struct v4l2_plane __user *uplane;
 	compat_caddr_t p;
-	int num_planes;
 	int ret;
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    put_user(kp->index, &up->index) ||
-	    put_user(kp->type, &up->type) ||
-	    put_user(kp->flags, &up->flags) ||
-	    put_user(kp->memory, &up->memory) ||
-	    put_user(kp->input, &up->input))
+	    assign_in_user(&up->index, &kp->index) ||
+	    get_user(type, &kp->type) ||
+	    put_user(type, &up->type) ||
+	    assign_in_user(&up->flags, &kp->flags) ||
+	    get_user(memory, &kp->memory) ||
+	    put_user(memory, &up->memory))
 		return -EFAULT;
 
-	if (put_user(kp->bytesused, &up->bytesused) ||
-	    put_user(kp->field, &up->field) ||
-	    put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
-	    put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
-	    copy_to_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
-	    put_user(kp->sequence, &up->sequence) ||
-	    put_user(kp->reserved, &up->reserved))
+	if (assign_in_user(&up->bytesused, &kp->bytesused) ||
+	    assign_in_user(&up->field, &kp->field) ||
+	    assign_in_user(&up->timestamp.tv_sec, &kp->timestamp.tv_sec) ||
+	    assign_in_user(&up->timestamp.tv_usec, &kp->timestamp.tv_usec) ||
+	    copy_in_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
+	    assign_in_user(&up->sequence, &kp->sequence) ||
+	    assign_in_user(&up->input, &kp->input) ||
+	    assign_in_user(&up->reserved, &kp->reserved) ||
+	    get_user(length, &kp->length) ||
+	    put_user(length, &up->length))
 		return -EFAULT;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
-		num_planes = kp->length;
+	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
+		u32 num_planes = length;
+
 		if (num_planes == 0)
 			return 0;
 
-		uplane = kp->m.planes;
+		if (get_user(uplane, ((__force struct v4l2_plane __user **)&kp->m.planes)))
+			return -EFAULT;
 		if (get_user(p, &up->m.planes))
 			return -EFAULT;
 		uplane32 = compat_ptr(p);
 
-		while (--num_planes >= 0) {
-			ret = put_v4l2_plane32(uplane, uplane32, kp->memory);
+		while (num_planes--) {
+			ret = put_v4l2_plane32(uplane, uplane32, memory);
 			if (ret)
 				return ret;
 			++uplane;
 			++uplane32;
 		}
 	} else {
-		switch (kp->memory) {
+		switch (memory) {
 		case V4L2_MEMORY_MMAP:
-			if (put_user(kp->length, &up->length) ||
-			    put_user(kp->m.offset, &up->m.offset))
+		case V4L2_MEMORY_OVERLAY:
+			if (assign_in_user(&up->m.offset, &kp->m.offset))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_USERPTR:
-			if (put_user(kp->length, &up->length) ||
-			    put_user(kp->m.userptr, &up->m.userptr))
-				return -EFAULT;
-			break;
-		case V4L2_MEMORY_OVERLAY:
-			if (put_user(kp->m.offset, &up->m.offset))
+			if (assign_in_user(&up->m.userptr, &kp->m.userptr))
 				return -EFAULT;
 			break;
 		}
@@ -514,33 +620,45 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 struct v4l2_framebuffer32 {
 	__u32			capability;
 	__u32			flags;
-	compat_caddr_t 		base;
-	struct v4l2_pix_format	fmt;
+	compat_caddr_t		base;
+	struct {
+		__u32		width;
+		__u32		height;
+		__u32		pixelformat;
+		__u32		field;
+		__u32		bytesperline;
+		__u32		sizeimage;
+		__u32		colorspace;
+		__u32		priv;
+	} fmt;
 };
 
-static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_framebuffer32 __user *up)
+static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
+				  struct v4l2_framebuffer32 __user *up)
 {
-	u32 tmp;
+	compat_caddr_t tmp;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    get_user(tmp, &up->base) ||
-	    get_user(kp->capability, &up->capability) ||
-	    get_user(kp->flags, &up->flags) ||
-	    copy_from_user(&kp->fmt, &up->fmt, sizeof(up->fmt)))
+	    put_user((__force void *)compat_ptr(tmp), &kp->base) ||
+	    assign_in_user(&kp->capability, &up->capability) ||
+	    assign_in_user(&kp->flags, &up->flags) ||
+	    copy_in_user(&kp->fmt, &up->fmt, sizeof(kp->fmt)))
 		return -EFAULT;
-	kp->base = compat_ptr(tmp);
 	return 0;
 }
 
-static int put_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_framebuffer32 __user *up)
+static int put_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
+				  struct v4l2_framebuffer32 __user *up)
 {
-	u32 tmp = (u32)((unsigned long)kp->base);
+	void *base;
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    put_user(tmp, &up->base) ||
-	    put_user(kp->capability, &up->capability) ||
-	    put_user(kp->flags, &up->flags) ||
-	    copy_to_user(&up->fmt, &kp->fmt, sizeof(up->fmt)))
+	    get_user(base, &kp->base) ||
+	    put_user(ptr_to_compat(base), &up->base) ||
+	    assign_in_user(&up->capability, &kp->capability) ||
+	    assign_in_user(&up->flags, &kp->flags) ||
+	    copy_in_user(&up->fmt, &kp->fmt, sizeof(kp->fmt)))
 		return -EFAULT;
 	return 0;
 }
@@ -553,21 +671,26 @@ struct v4l2_input32 {
 	__u32        tuner;             /*  Associated tuner */
 	v4l2_std_id  std;
 	__u32	     status;
-	__u32	     reserved[4];
+	__u32	     capabilities;
+	__u32	     reserved[3];
 } __attribute__ ((packed));
 
-/* The 64-bit v4l2_input struct has extra padding at the end of the struct.
-   Otherwise it is identical to the 32-bit version. */
-static inline int get_v4l2_input32(struct v4l2_input *kp, struct v4l2_input32 __user *up)
+/*
+ * The 64-bit v4l2_input struct has extra padding at the end of the struct.
+ * Otherwise it is identical to the 32-bit version.
+ */
+static inline int get_v4l2_input32(struct v4l2_input __user *kp,
+				   struct v4l2_input32 __user *up)
 {
-	if (copy_from_user(kp, up, sizeof(*up)))
+	if (copy_in_user(kp, up, sizeof(*up)))
 		return -EFAULT;
 	return 0;
 }
 
-static inline int put_v4l2_input32(struct v4l2_input *kp, struct v4l2_input32 __user *up)
+static inline int put_v4l2_input32(struct v4l2_input __user *kp,
+				   struct v4l2_input32 __user *up)
 {
-	if (copy_to_user(up, kp, sizeof(*up)))
+	if (copy_in_user(up, kp, sizeof(*up)))
 		return -EFAULT;
 	return 0;
 }
@@ -614,37 +737,65 @@ static inline bool ctrl_is_pointer(struct file *file, u32 id)
 	return false;
 }
 
+static int bufsize_v4l2_ext_controls(struct v4l2_ext_controls32 __user *up,
+				     u32 *size)
+{
+	u32 count;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
+	    get_user(count, &up->count))
+		return -EFAULT;
+	if (count > V4L2_CID_MAX_CTRLS)
+		return -EINVAL;
+	*size = count * sizeof(struct v4l2_ext_control);
+	return 0;
+}
+
 static int get_v4l2_ext_controls32(struct file *file,
-				   struct v4l2_ext_controls *kp,
-				   struct v4l2_ext_controls32 __user *up)
+				   struct v4l2_ext_controls __user *kp,
+				   struct v4l2_ext_controls32 __user *up,
+				   void __user *aux_buf, u32 aux_space)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
 	struct v4l2_ext_control __user *kcontrols;
-	int n;
+	u32 count;
+	u32 n;
 	compat_caddr_t p;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    get_user(kp->ctrl_class, &up->ctrl_class) ||
-	    get_user(kp->count, &up->count) ||
-	    get_user(kp->error_idx, &up->error_idx) ||
-	    copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+	    assign_in_user(&kp->ctrl_class, &up->ctrl_class) ||
+	    get_user(count, &up->count) ||
+	    put_user(count, &kp->count) ||
+	    assign_in_user(&kp->error_idx, &up->error_idx) ||
+	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
-	n = kp->count;
-	if (n == 0) {
-		kp->controls = NULL;
-		return 0;
-	}
+
+	if (count == 0)
+		return put_user(NULL, &kp->controls);
+	if (count > V4L2_CID_MAX_CTRLS)
+		return -EINVAL;
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_READ, ucontrols, n * sizeof(*ucontrols)))
+	if (!access_ok(VERIFY_READ, ucontrols, count * sizeof(*ucontrols)))
 		return -EFAULT;
-	kcontrols = compat_alloc_user_space(n * sizeof(*kcontrols));
-	kp->controls = kcontrols;
-	while (--n >= 0) {
+	if (aux_space < count * sizeof(*kcontrols))
+		return -EFAULT;
+	kcontrols = aux_buf;
+	if (put_user((__force struct v4l2_ext_control *)kcontrols,
+		     &kp->controls))
+		return -EFAULT;
+
+	for (n = 0; n < count; n++) {
+		u32 id;
+
 		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
 			return -EFAULT;
-		if (ctrl_is_pointer(file, kcontrols->id)) {
+
+		if (get_user(id, &kcontrols->id))
+			return -EFAULT;
+
+		if (ctrl_is_pointer(file, id)) {
 			void __user *s;
 
 			if (get_user(p, &ucontrols->string))
@@ -660,39 +811,54 @@ static int get_v4l2_ext_controls32(struct file *file,
 }
 
 static int put_v4l2_ext_controls32(struct file *file,
-				   struct v4l2_ext_controls *kp,
+				   struct v4l2_ext_controls __user *kp,
 				   struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
-	struct v4l2_ext_control __user *kcontrols = kp->controls;
-	int n = kp->count;
+	struct v4l2_ext_control __user *kcontrols;
+	u32 count;
+	u32 n;
 	compat_caddr_t p;
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    put_user(kp->ctrl_class, &up->ctrl_class) ||
-	    put_user(kp->count, &up->count) ||
-	    put_user(kp->error_idx, &up->error_idx) ||
-	    copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+	    assign_in_user(&up->ctrl_class, &kp->ctrl_class) ||
+	    get_user(count, &kp->count) ||
+	    put_user(count, &up->count) ||
+	    assign_in_user(&up->error_idx, &kp->error_idx) ||
+	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)) ||
+	    get_user(kcontrols, &kp->controls))
 		return -EFAULT;
-	if (!kp->count)
-		return 0;
 
+	if (!count)
+		return 0;
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_WRITE, ucontrols, n * sizeof(*ucontrols)))
+	if (!access_ok(VERIFY_WRITE, ucontrols, count * sizeof(*ucontrols)))
 		return -EFAULT;
 
-	while (--n >= 0) {
-		unsigned size = sizeof(*ucontrols);
+	for (n = 0; n < count; n++) {
+		unsigned int size = sizeof(*ucontrols);
+		u32 id;
 
-		/* Do not modify the pointer when copying a pointer control.
-		   The contents of the pointer was changed, not the pointer
-		   itself. */
-		if (ctrl_is_pointer(file, kcontrols->id))
+		if (get_user(id, &kcontrols->id) ||
+		    put_user(id, &ucontrols->id) ||
+		    assign_in_user(&ucontrols->size, &kcontrols->size) ||
+		    copy_in_user(&ucontrols->reserved2, &kcontrols->reserved2,
+				 sizeof(ucontrols->reserved2)))
+			return -EFAULT;
+
+		/*
+		 * Do not modify the pointer when copying a pointer control.
+		 * The contents of the pointer was changed, not the pointer
+		 * itself.
+		 */
+		if (ctrl_is_pointer(file, id))
 			size -= sizeof(ucontrols->value64);
+
 		if (copy_in_user(ucontrols, kcontrols, size))
 			return -EFAULT;
+
 		ucontrols++;
 		kcontrols++;
 	}
@@ -711,16 +877,18 @@ struct v4l2_event32 {
 	__u32				reserved[8];
 };
 
-static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
+static int put_v4l2_event32(struct v4l2_event __user *kp,
+			    struct v4l2_event32 __user *up)
 {
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    put_user(kp->type, &up->type) ||
-	    copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
-	    put_user(kp->pending, &up->pending) ||
-	    put_user(kp->sequence, &up->sequence) ||
-	    put_compat_timespec(&kp->timestamp, &up->timestamp) ||
-	    put_user(kp->id, &up->id) ||
-	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
+	    assign_in_user(&up->type, &kp->type) ||
+	    copy_in_user(&up->u, &kp->u, sizeof(kp->u)) ||
+	    assign_in_user(&up->pending, &kp->pending) ||
+	    assign_in_user(&up->sequence, &kp->sequence) ||
+	    assign_in_user(&up->timestamp.tv_sec, &kp->timestamp.tv_sec) ||
+	    assign_in_user(&up->timestamp.tv_nsec, &kp->timestamp.tv_nsec) ||
+	    assign_in_user(&up->id, &kp->id) ||
+	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -734,7 +902,7 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 #define VIDIOC_DQBUF32		_IOWR('V', 17, struct v4l2_buffer32)
 #define VIDIOC_ENUMSTD32	_IOWR('V', 25, struct v4l2_standard32)
 #define VIDIOC_ENUMINPUT32	_IOWR('V', 26, struct v4l2_input32)
-#define VIDIOC_TRY_FMT32      	_IOWR('V', 64, struct v4l2_format32)
+#define VIDIOC_TRY_FMT32	_IOWR('V', 64, struct v4l2_format32)
 #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
 #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
 #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
@@ -750,21 +918,23 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 #define VIDIOC_G_OUTPUT32	_IOR ('V', 46, s32)
 #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
 
+static int alloc_userspace(unsigned int size, u32 aux_space,
+			   void __user **up_native)
+{
+	*up_native = compat_alloc_user_space(size + aux_space);
+	if (!*up_native)
+		return -ENOMEM;
+	if (clear_user(*up_native, size))
+		return -EFAULT;
+	return 0;
+}
+
 static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	union {
-		struct v4l2_format v2f;
-		struct v4l2_buffer v2b;
-		struct v4l2_framebuffer v2fb;
-		struct v4l2_input v2i;
-		struct v4l2_standard v2s;
-		struct v4l2_ext_controls v2ecs;
-		struct v4l2_event v2ev;
-		struct v4l2_create_buffers v2crt;
-		unsigned long vx;
-		int vi;
-	} karg;
 	void __user *up = compat_ptr(arg);
+	void __user *up_native = NULL;
+	void __user *aux_buf;
+	u32 aux_space;
 	int compatible_arg = 1;
 	long err = 0;
 
@@ -801,24 +971,44 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_STREAMOFF:
 	case VIDIOC_S_INPUT:
 	case VIDIOC_S_OUTPUT:
-		err = get_user(karg.vi, (s32 __user *)up);
+		err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
+		if (!err && assign_in_user((unsigned int __user *)up_native,
+					   (compat_uint_t __user *)up))
+			err = -EFAULT;
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_INPUT:
 	case VIDIOC_G_OUTPUT:
+		err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
-		err = get_v4l2_format32(&karg.v2f, up);
+		err = bufsize_v4l2_format(up, &aux_space);
+		if (!err)
+			err = alloc_userspace(sizeof(struct v4l2_format),
+					      aux_space, &up_native);
+		if (!err) {
+			aux_buf = up_native + sizeof(struct v4l2_format);
+			err = get_v4l2_format32(up_native, up,
+						aux_buf, aux_space);
+		}
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_CREATE_BUFS:
-		err = get_v4l2_create32(&karg.v2crt, up);
+		err = bufsize_v4l2_create(up, &aux_space);
+		if (!err)
+			err = alloc_userspace(sizeof(struct v4l2_create_buffers),
+					      aux_space, &up_native);
+		if (!err) {
+			aux_buf = up_native + sizeof(struct v4l2_create_buffers);
+			err = get_v4l2_create32(up_native, up,
+						aux_buf, aux_space);
+		}
 		compatible_arg = 0;
 		break;
 
@@ -826,36 +1016,63 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF:
-		err = get_v4l2_buffer32(&karg.v2b, up);
+		err = bufsize_v4l2_buffer(up, &aux_space);
+		if (!err)
+			err = alloc_userspace(sizeof(struct v4l2_buffer),
+					      aux_space, &up_native);
+		if (!err) {
+			aux_buf = up_native + sizeof(struct v4l2_buffer);
+			err = get_v4l2_buffer32(up_native, up,
+						aux_buf, aux_space);
+		}
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_S_FBUF:
-		err = get_v4l2_framebuffer32(&karg.v2fb, up);
+		err = alloc_userspace(sizeof(struct v4l2_framebuffer), 0,
+				      &up_native);
+		if (!err)
+			err = get_v4l2_framebuffer32(up_native, up);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_FBUF:
+		err = alloc_userspace(sizeof(struct v4l2_framebuffer), 0,
+				      &up_native);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_ENUMSTD:
-		err = get_v4l2_standard32(&karg.v2s, up);
+		err = alloc_userspace(sizeof(struct v4l2_standard), 0,
+				      &up_native);
+		if (!err)
+			err = get_v4l2_standard32(up_native, up);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_ENUMINPUT:
-		err = get_v4l2_input32(&karg.v2i, up);
+		err = alloc_userspace(sizeof(struct v4l2_input), 0, &up_native);
+		if (!err)
+			err = get_v4l2_input32(up_native, up);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		err = get_v4l2_ext_controls32(file, &karg.v2ecs, up);
+		err = bufsize_v4l2_ext_controls(up, &aux_space);
+		if (!err)
+			err = alloc_userspace(sizeof(struct v4l2_ext_controls),
+					      aux_space, &up_native);
+		if (!err) {
+			aux_buf = up_native + sizeof(struct v4l2_ext_controls);
+			err = get_v4l2_ext_controls32(file, up_native, up,
+						      aux_buf, aux_space);
+		}
 		compatible_arg = 0;
 		break;
 	case VIDIOC_DQEVENT:
+		err = alloc_userspace(sizeof(struct v4l2_event), 0, &up_native);
 		compatible_arg = 0;
 		break;
 	}
@@ -864,25 +1081,22 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 	if (compatible_arg)
 		err = native_ioctl(file, cmd, (unsigned long)up);
-	else {
-		mm_segment_t old_fs = get_fs();
-
-		set_fs(KERNEL_DS);
-		err = native_ioctl(file, cmd, (unsigned long)&karg);
-		set_fs(old_fs);
-	}
+	else
+		err = native_ioctl(file, cmd, (unsigned long)up_native);
 
 	if (err == -ENOTTY)
 		return err;
 
-	/* Special case: even after an error we need to put the
-	   results back for these ioctls since the error_idx will
-	   contain information on which control failed. */
+	/*
+	 * Special case: even after an error we need to put the
+	 * results back for these ioctls since the error_idx will
+	 * contain information on which control failed.
+	 */
 	switch (cmd) {
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		if (put_v4l2_ext_controls32(file, &karg.v2ecs, up))
+		if (put_v4l2_ext_controls32(file, up_native, up))
 			err = -EFAULT;
 		break;
 	}
@@ -894,40 +1108,42 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_S_OUTPUT:
 	case VIDIOC_G_INPUT:
 	case VIDIOC_G_OUTPUT:
-		err = put_user(((s32)karg.vi), (s32 __user *)up);
+		if (assign_in_user((compat_uint_t __user *)up,
+				   ((unsigned int __user *)up_native)))
+			err = -EFAULT;
 		break;
 
 	case VIDIOC_G_FBUF:
-		err = put_v4l2_framebuffer32(&karg.v2fb, up);
+		err = put_v4l2_framebuffer32(up_native, up);
 		break;
 
 	case VIDIOC_DQEVENT:
-		err = put_v4l2_event32(&karg.v2ev, up);
+		err = put_v4l2_event32(up_native, up);
 		break;
 
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
-		err = put_v4l2_format32(&karg.v2f, up);
+		err = put_v4l2_format32(up_native, up);
 		break;
 
 	case VIDIOC_CREATE_BUFS:
-		err = put_v4l2_create32(&karg.v2crt, up);
+		err = put_v4l2_create32(up_native, up);
 		break;
 
 	case VIDIOC_PREPARE_BUF:
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF:
-		err = put_v4l2_buffer32(&karg.v2b, up);
+		err = put_v4l2_buffer32(up_native, up);
 		break;
 
 	case VIDIOC_ENUMSTD:
-		err = put_v4l2_standard32(&karg.v2s, up);
+		err = put_v4l2_standard32(up_native, up);
 		break;
 
 	case VIDIOC_ENUMINPUT:
-		err = put_v4l2_input32(&karg.v2i, up);
+		err = put_v4l2_input32(up_native, up);
 		break;
 	}
 	return err;
-- 
2.15.1
