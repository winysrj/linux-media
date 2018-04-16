Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52013 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeDPPLS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 11:11:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>
Subject: [PATCH] media: v4l2-compat-ioctl32: better name userspace pointers
Date: Mon, 16 Apr 2018 11:11:10 -0400
Message-Id: <eb0a0899d1763de662cd5d58257d2f29a14f501b.1523891464.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, "up" were an acronym for "user pointer" and "kp" for
"kernel pointer". However, since a1dfb4c48cc1 ("media:
v4l2-compat-ioctl32.c: refactor compat ioctl32 logic"), both
are now __user pointers.

So, the usage of "kp" is really misleading there. So, rename
both to just "p32" and "p64" everywhere it occurs, in order to
make peace with this file's namespace.

There are two exceptions to "up/kp" nomenclature: at
alloc_userspace() and at do_video_ioctl().

There, a new userspace pointer were allocated, in order to store
the 64 bits version of the ioctl. Those were called as "up_native",
with is, IMHO, an even worse name, as "native" could mislead of
being the arguments that were filled from userspace. I almost
renamed it to just "p64", but, after thinking more about that,
it sounded better to call it as "new_p64", as this makes clearer
that this is the data structure that was allocated inside this
file in order to be used to pass/retrieve data when calling the
64-bit ready file->f_op->unlocked_ioctl() function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 578 +++++++++++++-------------
 1 file changed, 289 insertions(+), 289 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 5c3408bdfd89..064e4a2bdba3 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -56,8 +56,8 @@ struct v4l2_window32 {
 	__u8                    global_alpha;
 };
 
-static int get_v4l2_window32(struct v4l2_window __user *kp,
-			     struct v4l2_window32 __user *up,
+static int get_v4l2_window32(struct v4l2_window __user *p64,
+			     struct v4l2_window32 __user *p32,
 			     void __user *aux_buf, u32 aux_space)
 {
 	struct v4l2_clip32 __user *uclips;
@@ -65,26 +65,26 @@ static int get_v4l2_window32(struct v4l2_window __user *kp,
 	compat_caddr_t p;
 	u32 clipcount;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    copy_in_user(&kp->w, &up->w, sizeof(up->w)) ||
-	    assign_in_user(&kp->field, &up->field) ||
-	    assign_in_user(&kp->chromakey, &up->chromakey) ||
-	    assign_in_user(&kp->global_alpha, &up->global_alpha) ||
-	    get_user(clipcount, &up->clipcount) ||
-	    put_user(clipcount, &kp->clipcount))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    copy_in_user(&p64->w, &p32->w, sizeof(p32->w)) ||
+	    assign_in_user(&p64->field, &p32->field) ||
+	    assign_in_user(&p64->chromakey, &p32->chromakey) ||
+	    assign_in_user(&p64->global_alpha, &p32->global_alpha) ||
+	    get_user(clipcount, &p32->clipcount) ||
+	    put_user(clipcount, &p64->clipcount))
 		return -EFAULT;
 	if (clipcount > 2048)
 		return -EINVAL;
 	if (!clipcount)
-		return put_user(NULL, &kp->clips);
+		return put_user(NULL, &p64->clips);
 
-	if (get_user(p, &up->clips))
+	if (get_user(p, &p32->clips))
 		return -EFAULT;
 	uclips = compat_ptr(p);
 	if (aux_space < clipcount * sizeof(*kclips))
 		return -EFAULT;
 	kclips = aux_buf;
-	if (put_user(kclips, &kp->clips))
+	if (put_user(kclips, &p64->clips))
 		return -EFAULT;
 
 	while (clipcount--) {
@@ -98,27 +98,27 @@ static int get_v4l2_window32(struct v4l2_window __user *kp,
 	return 0;
 }
 
-static int put_v4l2_window32(struct v4l2_window __user *kp,
-			     struct v4l2_window32 __user *up)
+static int put_v4l2_window32(struct v4l2_window __user *p64,
+			     struct v4l2_window32 __user *p32)
 {
 	struct v4l2_clip __user *kclips;
 	struct v4l2_clip32 __user *uclips;
 	compat_caddr_t p;
 	u32 clipcount;
 
-	if (copy_in_user(&up->w, &kp->w, sizeof(kp->w)) ||
-	    assign_in_user(&up->field, &kp->field) ||
-	    assign_in_user(&up->chromakey, &kp->chromakey) ||
-	    assign_in_user(&up->global_alpha, &kp->global_alpha) ||
-	    get_user(clipcount, &kp->clipcount) ||
-	    put_user(clipcount, &up->clipcount))
+	if (copy_in_user(&p32->w, &p64->w, sizeof(p64->w)) ||
+	    assign_in_user(&p32->field, &p64->field) ||
+	    assign_in_user(&p32->chromakey, &p64->chromakey) ||
+	    assign_in_user(&p32->global_alpha, &p64->global_alpha) ||
+	    get_user(clipcount, &p64->clipcount) ||
+	    put_user(clipcount, &p32->clipcount))
 		return -EFAULT;
 	if (!clipcount)
 		return 0;
 
-	if (get_user(kclips, &kp->clips))
+	if (get_user(kclips, &p64->clips))
 		return -EFAULT;
-	if (get_user(p, &up->clips))
+	if (get_user(p, &p32->clips))
 		return -EFAULT;
 	uclips = compat_ptr(p);
 	while (clipcount--) {
@@ -161,11 +161,11 @@ struct v4l2_create_buffers32 {
 	__u32			reserved[8];
 };
 
-static int __bufsize_v4l2_format(struct v4l2_format32 __user *up, u32 *size)
+static int __bufsize_v4l2_format(struct v4l2_format32 __user *p32, u32 *size)
 {
 	u32 type;
 
-	if (get_user(type, &up->type))
+	if (get_user(type, &p32->type))
 		return -EFAULT;
 
 	switch (type) {
@@ -173,7 +173,7 @@ static int __bufsize_v4l2_format(struct v4l2_format32 __user *up, u32 *size)
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY: {
 		u32 clipcount;
 
-		if (get_user(clipcount, &up->fmt.win.clipcount))
+		if (get_user(clipcount, &p32->fmt.win.clipcount))
 			return -EFAULT;
 		if (clipcount > 2048)
 			return -EINVAL;
@@ -186,141 +186,141 @@ static int __bufsize_v4l2_format(struct v4l2_format32 __user *up, u32 *size)
 	}
 }
 
-static int bufsize_v4l2_format(struct v4l2_format32 __user *up, u32 *size)
+static int bufsize_v4l2_format(struct v4l2_format32 __user *p32, u32 *size)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)))
 		return -EFAULT;
-	return __bufsize_v4l2_format(up, size);
+	return __bufsize_v4l2_format(p32, size);
 }
 
-static int __get_v4l2_format32(struct v4l2_format __user *kp,
-			       struct v4l2_format32 __user *up,
+static int __get_v4l2_format32(struct v4l2_format __user *p64,
+			       struct v4l2_format32 __user *p32,
 			       void __user *aux_buf, u32 aux_space)
 {
 	u32 type;
 
-	if (get_user(type, &up->type) || put_user(type, &kp->type))
+	if (get_user(type, &p32->type) || put_user(type, &p64->type))
 		return -EFAULT;
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		return copy_in_user(&kp->fmt.pix, &up->fmt.pix,
-				    sizeof(kp->fmt.pix)) ? -EFAULT : 0;
+		return copy_in_user(&p64->fmt.pix, &p32->fmt.pix,
+				    sizeof(p64->fmt.pix)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		return copy_in_user(&kp->fmt.pix_mp, &up->fmt.pix_mp,
-				    sizeof(kp->fmt.pix_mp)) ? -EFAULT : 0;
+		return copy_in_user(&p64->fmt.pix_mp, &p32->fmt.pix_mp,
+				    sizeof(p64->fmt.pix_mp)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		return get_v4l2_window32(&kp->fmt.win, &up->fmt.win,
+		return get_v4l2_window32(&p64->fmt.win, &p32->fmt.win,
 					 aux_buf, aux_space);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		return copy_in_user(&kp->fmt.vbi, &up->fmt.vbi,
-				    sizeof(kp->fmt.vbi)) ? -EFAULT : 0;
+		return copy_in_user(&p64->fmt.vbi, &p32->fmt.vbi,
+				    sizeof(p64->fmt.vbi)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		return copy_in_user(&kp->fmt.sliced, &up->fmt.sliced,
-				    sizeof(kp->fmt.sliced)) ? -EFAULT : 0;
+		return copy_in_user(&p64->fmt.sliced, &p32->fmt.sliced,
+				    sizeof(p64->fmt.sliced)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		return copy_in_user(&kp->fmt.sdr, &up->fmt.sdr,
-				    sizeof(kp->fmt.sdr)) ? -EFAULT : 0;
+		return copy_in_user(&p64->fmt.sdr, &p32->fmt.sdr,
+				    sizeof(p64->fmt.sdr)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		return copy_in_user(&kp->fmt.meta, &up->fmt.meta,
-				    sizeof(kp->fmt.meta)) ? -EFAULT : 0;
+		return copy_in_user(&p64->fmt.meta, &p32->fmt.meta,
+				    sizeof(p64->fmt.meta)) ? -EFAULT : 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int get_v4l2_format32(struct v4l2_format __user *kp,
-			     struct v4l2_format32 __user *up,
+static int get_v4l2_format32(struct v4l2_format __user *p64,
+			     struct v4l2_format32 __user *p32,
 			     void __user *aux_buf, u32 aux_space)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)))
 		return -EFAULT;
-	return __get_v4l2_format32(kp, up, aux_buf, aux_space);
+	return __get_v4l2_format32(p64, p32, aux_buf, aux_space);
 }
 
-static int bufsize_v4l2_create(struct v4l2_create_buffers32 __user *up,
+static int bufsize_v4l2_create(struct v4l2_create_buffers32 __user *p32,
 			       u32 *size)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)))
 		return -EFAULT;
-	return __bufsize_v4l2_format(&up->format, size);
+	return __bufsize_v4l2_format(&p32->format, size);
 }
 
-static int get_v4l2_create32(struct v4l2_create_buffers __user *kp,
-			     struct v4l2_create_buffers32 __user *up,
+static int get_v4l2_create32(struct v4l2_create_buffers __user *p64,
+			     struct v4l2_create_buffers32 __user *p32,
 			     void __user *aux_buf, u32 aux_space)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    copy_in_user(kp, up,
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    copy_in_user(p64, p32,
 			 offsetof(struct v4l2_create_buffers32, format)))
 		return -EFAULT;
-	return __get_v4l2_format32(&kp->format, &up->format,
+	return __get_v4l2_format32(&p64->format, &p32->format,
 				   aux_buf, aux_space);
 }
 
-static int __put_v4l2_format32(struct v4l2_format __user *kp,
-			       struct v4l2_format32 __user *up)
+static int __put_v4l2_format32(struct v4l2_format __user *p64,
+			       struct v4l2_format32 __user *p32)
 {
 	u32 type;
 
-	if (get_user(type, &kp->type))
+	if (get_user(type, &p64->type))
 		return -EFAULT;
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		return copy_in_user(&up->fmt.pix, &kp->fmt.pix,
-				    sizeof(kp->fmt.pix)) ? -EFAULT : 0;
+		return copy_in_user(&p32->fmt.pix, &p64->fmt.pix,
+				    sizeof(p64->fmt.pix)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		return copy_in_user(&up->fmt.pix_mp, &kp->fmt.pix_mp,
-				    sizeof(kp->fmt.pix_mp)) ? -EFAULT : 0;
+		return copy_in_user(&p32->fmt.pix_mp, &p64->fmt.pix_mp,
+				    sizeof(p64->fmt.pix_mp)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		return put_v4l2_window32(&kp->fmt.win, &up->fmt.win);
+		return put_v4l2_window32(&p64->fmt.win, &p32->fmt.win);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		return copy_in_user(&up->fmt.vbi, &kp->fmt.vbi,
-				    sizeof(kp->fmt.vbi)) ? -EFAULT : 0;
+		return copy_in_user(&p32->fmt.vbi, &p64->fmt.vbi,
+				    sizeof(p64->fmt.vbi)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		return copy_in_user(&up->fmt.sliced, &kp->fmt.sliced,
-				    sizeof(kp->fmt.sliced)) ? -EFAULT : 0;
+		return copy_in_user(&p32->fmt.sliced, &p64->fmt.sliced,
+				    sizeof(p64->fmt.sliced)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		return copy_in_user(&up->fmt.sdr, &kp->fmt.sdr,
-				    sizeof(kp->fmt.sdr)) ? -EFAULT : 0;
+		return copy_in_user(&p32->fmt.sdr, &p64->fmt.sdr,
+				    sizeof(p64->fmt.sdr)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		return copy_in_user(&up->fmt.meta, &kp->fmt.meta,
-				    sizeof(kp->fmt.meta)) ? -EFAULT : 0;
+		return copy_in_user(&p32->fmt.meta, &p64->fmt.meta,
+				    sizeof(p64->fmt.meta)) ? -EFAULT : 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int put_v4l2_format32(struct v4l2_format __user *kp,
-			     struct v4l2_format32 __user *up)
+static int put_v4l2_format32(struct v4l2_format __user *p64,
+			     struct v4l2_format32 __user *p32)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)))
 		return -EFAULT;
-	return __put_v4l2_format32(kp, up);
+	return __put_v4l2_format32(p64, p32);
 }
 
-static int put_v4l2_create32(struct v4l2_create_buffers __user *kp,
-			     struct v4l2_create_buffers32 __user *up)
+static int put_v4l2_create32(struct v4l2_create_buffers __user *p64,
+			     struct v4l2_create_buffers32 __user *p32)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    copy_in_user(up, kp,
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    copy_in_user(p32, p64,
 			 offsetof(struct v4l2_create_buffers32, format)) ||
-	    copy_in_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
+	    copy_in_user(p32->reserved, p64->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
-	return __put_v4l2_format32(&kp->format, &up->format);
+	return __put_v4l2_format32(&p64->format, &p32->format);
 }
 
 struct v4l2_standard32 {
@@ -332,27 +332,27 @@ struct v4l2_standard32 {
 	__u32		     reserved[4];
 };
 
-static int get_v4l2_standard32(struct v4l2_standard __user *kp,
-			       struct v4l2_standard32 __user *up)
+static int get_v4l2_standard32(struct v4l2_standard __user *p64,
+			       struct v4l2_standard32 __user *p32)
 {
 	/* other fields are not set by the user, nor used by the driver */
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    assign_in_user(&kp->index, &up->index))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    assign_in_user(&p64->index, &p32->index))
 		return -EFAULT;
 	return 0;
 }
 
-static int put_v4l2_standard32(struct v4l2_standard __user *kp,
-			       struct v4l2_standard32 __user *up)
+static int put_v4l2_standard32(struct v4l2_standard __user *p64,
+			       struct v4l2_standard32 __user *p32)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    assign_in_user(&up->index, &kp->index) ||
-	    assign_in_user(&up->id, &kp->id) ||
-	    copy_in_user(up->name, kp->name, sizeof(up->name)) ||
-	    copy_in_user(&up->frameperiod, &kp->frameperiod,
-			 sizeof(up->frameperiod)) ||
-	    assign_in_user(&up->framelines, &kp->framelines) ||
-	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    assign_in_user(&p32->index, &p64->index) ||
+	    assign_in_user(&p32->id, &p64->id) ||
+	    copy_in_user(p32->name, p64->name, sizeof(p32->name)) ||
+	    copy_in_user(&p32->frameperiod, &p64->frameperiod,
+			 sizeof(p32->frameperiod)) ||
+	    assign_in_user(&p32->framelines, &p64->framelines) ||
+	    copy_in_user(p32->reserved, p64->reserved, sizeof(p32->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -392,31 +392,31 @@ struct v4l2_buffer32 {
 	__u32			reserved;
 };
 
-static int get_v4l2_plane32(struct v4l2_plane __user *up,
+static int get_v4l2_plane32(struct v4l2_plane __user *p32,
 			    struct v4l2_plane32 __user *up32,
 			    enum v4l2_memory memory)
 {
 	compat_ulong_t p;
 
-	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
-	    copy_in_user(&up->data_offset, &up32->data_offset,
-			 sizeof(up->data_offset)))
+	if (copy_in_user(p32, up32, 2 * sizeof(__u32)) ||
+	    copy_in_user(&p32->data_offset, &up32->data_offset,
+			 sizeof(p32->data_offset)))
 		return -EFAULT;
 
 	switch (memory) {
 	case V4L2_MEMORY_MMAP:
 	case V4L2_MEMORY_OVERLAY:
-		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
+		if (copy_in_user(&p32->m.mem_offset, &up32->m.mem_offset,
 				 sizeof(up32->m.mem_offset)))
 			return -EFAULT;
 		break;
 	case V4L2_MEMORY_USERPTR:
 		if (get_user(p, &up32->m.userptr) ||
-		    put_user((unsigned long)compat_ptr(p), &up->m.userptr))
+		    put_user((unsigned long)compat_ptr(p), &p32->m.userptr))
 			return -EFAULT;
 		break;
 	case V4L2_MEMORY_DMABUF:
-		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
+		if (copy_in_user(&p32->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
 			return -EFAULT;
 		break;
 	}
@@ -424,32 +424,32 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up,
 	return 0;
 }
 
-static int put_v4l2_plane32(struct v4l2_plane __user *up,
+static int put_v4l2_plane32(struct v4l2_plane __user *p32,
 			    struct v4l2_plane32 __user *up32,
 			    enum v4l2_memory memory)
 {
 	unsigned long p;
 
-	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
-	    copy_in_user(&up32->data_offset, &up->data_offset,
-			 sizeof(up->data_offset)))
+	if (copy_in_user(up32, p32, 2 * sizeof(__u32)) ||
+	    copy_in_user(&up32->data_offset, &p32->data_offset,
+			 sizeof(p32->data_offset)))
 		return -EFAULT;
 
 	switch (memory) {
 	case V4L2_MEMORY_MMAP:
 	case V4L2_MEMORY_OVERLAY:
-		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
-				 sizeof(up->m.mem_offset)))
+		if (copy_in_user(&up32->m.mem_offset, &p32->m.mem_offset,
+				 sizeof(p32->m.mem_offset)))
 			return -EFAULT;
 		break;
 	case V4L2_MEMORY_USERPTR:
-		if (get_user(p, &up->m.userptr)||
+		if (get_user(p, &p32->m.userptr)||
 		    put_user((compat_ulong_t)ptr_to_compat((void __user *)p),
 			     &up32->m.userptr))
 			return -EFAULT;
 		break;
 	case V4L2_MEMORY_DMABUF:
-		if (copy_in_user(&up32->m.fd, &up->m.fd, sizeof(up->m.fd)))
+		if (copy_in_user(&up32->m.fd, &p32->m.fd, sizeof(p32->m.fd)))
 			return -EFAULT;
 		break;
 	}
@@ -457,14 +457,14 @@ static int put_v4l2_plane32(struct v4l2_plane __user *up,
 	return 0;
 }
 
-static int bufsize_v4l2_buffer(struct v4l2_buffer32 __user *up, u32 *size)
+static int bufsize_v4l2_buffer(struct v4l2_buffer32 __user *p32, u32 *size)
 {
 	u32 type;
 	u32 length;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    get_user(type, &up->type) ||
-	    get_user(length, &up->length))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    get_user(type, &p32->type) ||
+	    get_user(length, &p32->length))
 		return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
@@ -482,8 +482,8 @@ static int bufsize_v4l2_buffer(struct v4l2_buffer32 __user *up, u32 *size)
 	return 0;
 }
 
-static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
-			     struct v4l2_buffer32 __user *up,
+static int get_v4l2_buffer32(struct v4l2_buffer __user *p64,
+			     struct v4l2_buffer32 __user *p32,
 			     void __user *aux_buf, u32 aux_space)
 {
 	u32 type;
@@ -494,24 +494,24 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
 	compat_caddr_t p;
 	int ret;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    assign_in_user(&kp->index, &up->index) ||
-	    get_user(type, &up->type) ||
-	    put_user(type, &kp->type) ||
-	    assign_in_user(&kp->flags, &up->flags) ||
-	    get_user(memory, &up->memory) ||
-	    put_user(memory, &kp->memory) ||
-	    get_user(length, &up->length) ||
-	    put_user(length, &kp->length))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    assign_in_user(&p64->index, &p32->index) ||
+	    get_user(type, &p32->type) ||
+	    put_user(type, &p64->type) ||
+	    assign_in_user(&p64->flags, &p32->flags) ||
+	    get_user(memory, &p32->memory) ||
+	    put_user(memory, &p64->memory) ||
+	    get_user(length, &p32->length) ||
+	    put_user(length, &p64->length))
 		return -EFAULT;
 
 	if (V4L2_TYPE_IS_OUTPUT(type))
-		if (assign_in_user(&kp->bytesused, &up->bytesused) ||
-		    assign_in_user(&kp->field, &up->field) ||
-		    assign_in_user(&kp->timestamp.tv_sec,
-				   &up->timestamp.tv_sec) ||
-		    assign_in_user(&kp->timestamp.tv_usec,
-				   &up->timestamp.tv_usec))
+		if (assign_in_user(&p64->bytesused, &p32->bytesused) ||
+		    assign_in_user(&p64->field, &p32->field) ||
+		    assign_in_user(&p64->timestamp.tv_sec,
+				   &p32->timestamp.tv_sec) ||
+		    assign_in_user(&p64->timestamp.tv_usec,
+				   &p32->timestamp.tv_usec))
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
@@ -522,12 +522,12 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
 			 * num_planes == 0 is legal, e.g. when userspace doesn't
 			 * need planes array on DQBUF
 			 */
-			return put_user(NULL, &kp->m.planes);
+			return put_user(NULL, &p64->m.planes);
 		}
 		if (num_planes > VIDEO_MAX_PLANES)
 			return -EINVAL;
 
-		if (get_user(p, &up->m.planes))
+		if (get_user(p, &p32->m.planes))
 			return -EFAULT;
 
 		uplane32 = compat_ptr(p);
@@ -544,7 +544,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
 
 		uplane = aux_buf;
 		if (put_user((__force struct v4l2_plane *)uplane,
-			     &kp->m.planes))
+			     &p64->m.planes))
 			return -EFAULT;
 
 		while (num_planes--) {
@@ -558,20 +558,20 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
 		switch (memory) {
 		case V4L2_MEMORY_MMAP:
 		case V4L2_MEMORY_OVERLAY:
-			if (assign_in_user(&kp->m.offset, &up->m.offset))
+			if (assign_in_user(&p64->m.offset, &p32->m.offset))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_USERPTR: {
 			compat_ulong_t userptr;
 
-			if (get_user(userptr, &up->m.userptr) ||
+			if (get_user(userptr, &p32->m.userptr) ||
 			    put_user((unsigned long)compat_ptr(userptr),
-				     &kp->m.userptr))
+				     &p64->m.userptr))
 				return -EFAULT;
 			break;
 		}
 		case V4L2_MEMORY_DMABUF:
-			if (assign_in_user(&kp->m.fd, &up->m.fd))
+			if (assign_in_user(&p64->m.fd, &p32->m.fd))
 				return -EFAULT;
 			break;
 		}
@@ -580,8 +580,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
 	return 0;
 }
 
-static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
-			     struct v4l2_buffer32 __user *up)
+static int put_v4l2_buffer32(struct v4l2_buffer __user *p64,
+			     struct v4l2_buffer32 __user *p32)
 {
 	u32 type;
 	u32 length;
@@ -591,25 +591,25 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
 	compat_caddr_t p;
 	int ret;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    assign_in_user(&up->index, &kp->index) ||
-	    get_user(type, &kp->type) ||
-	    put_user(type, &up->type) ||
-	    assign_in_user(&up->flags, &kp->flags) ||
-	    get_user(memory, &kp->memory) ||
-	    put_user(memory, &up->memory))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    assign_in_user(&p32->index, &p64->index) ||
+	    get_user(type, &p64->type) ||
+	    put_user(type, &p32->type) ||
+	    assign_in_user(&p32->flags, &p64->flags) ||
+	    get_user(memory, &p64->memory) ||
+	    put_user(memory, &p32->memory))
 		return -EFAULT;
 
-	if (assign_in_user(&up->bytesused, &kp->bytesused) ||
-	    assign_in_user(&up->field, &kp->field) ||
-	    assign_in_user(&up->timestamp.tv_sec, &kp->timestamp.tv_sec) ||
-	    assign_in_user(&up->timestamp.tv_usec, &kp->timestamp.tv_usec) ||
-	    copy_in_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
-	    assign_in_user(&up->sequence, &kp->sequence) ||
-	    assign_in_user(&up->reserved2, &kp->reserved2) ||
-	    assign_in_user(&up->reserved, &kp->reserved) ||
-	    get_user(length, &kp->length) ||
-	    put_user(length, &up->length))
+	if (assign_in_user(&p32->bytesused, &p64->bytesused) ||
+	    assign_in_user(&p32->field, &p64->field) ||
+	    assign_in_user(&p32->timestamp.tv_sec, &p64->timestamp.tv_sec) ||
+	    assign_in_user(&p32->timestamp.tv_usec, &p64->timestamp.tv_usec) ||
+	    copy_in_user(&p32->timecode, &p64->timecode, sizeof(p64->timecode)) ||
+	    assign_in_user(&p32->sequence, &p64->sequence) ||
+	    assign_in_user(&p32->reserved2, &p64->reserved2) ||
+	    assign_in_user(&p32->reserved, &p64->reserved) ||
+	    get_user(length, &p64->length) ||
+	    put_user(length, &p32->length))
 		return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
@@ -626,9 +626,9 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
 		 * So, instead, declare it as ks, and pass it as an userspace
 		 * pointer to put_v4l2_plane32().
 		 */
-		if (get_user(uplane, &kp->m.planes))
+		if (get_user(uplane, &p64->m.planes))
 			return -EFAULT;
-		if (get_user(p, &up->m.planes))
+		if (get_user(p, &p32->m.planes))
 			return -EFAULT;
 		uplane32 = compat_ptr(p);
 
@@ -643,15 +643,15 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
 		switch (memory) {
 		case V4L2_MEMORY_MMAP:
 		case V4L2_MEMORY_OVERLAY:
-			if (assign_in_user(&up->m.offset, &kp->m.offset))
+			if (assign_in_user(&p32->m.offset, &p64->m.offset))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_USERPTR:
-			if (assign_in_user(&up->m.userptr, &kp->m.userptr))
+			if (assign_in_user(&p32->m.userptr, &p64->m.userptr))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_DMABUF:
-			if (assign_in_user(&up->m.fd, &kp->m.fd))
+			if (assign_in_user(&p32->m.fd, &p64->m.fd))
 				return -EFAULT;
 			break;
 		}
@@ -676,32 +676,32 @@ struct v4l2_framebuffer32 {
 	} fmt;
 };
 
-static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
-				  struct v4l2_framebuffer32 __user *up)
+static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *p64,
+				  struct v4l2_framebuffer32 __user *p32)
 {
 	compat_caddr_t tmp;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    get_user(tmp, &up->base) ||
-	    put_user((void __force *)compat_ptr(tmp), &kp->base) ||
-	    assign_in_user(&kp->capability, &up->capability) ||
-	    assign_in_user(&kp->flags, &up->flags) ||
-	    copy_in_user(&kp->fmt, &up->fmt, sizeof(kp->fmt)))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    get_user(tmp, &p32->base) ||
+	    put_user((void __force *)compat_ptr(tmp), &p64->base) ||
+	    assign_in_user(&p64->capability, &p32->capability) ||
+	    assign_in_user(&p64->flags, &p32->flags) ||
+	    copy_in_user(&p64->fmt, &p32->fmt, sizeof(p64->fmt)))
 		return -EFAULT;
 	return 0;
 }
 
-static int put_v4l2_framebuffer32(struct v4l2_framebuffer __user *kp,
-				  struct v4l2_framebuffer32 __user *up)
+static int put_v4l2_framebuffer32(struct v4l2_framebuffer __user *p64,
+				  struct v4l2_framebuffer32 __user *p32)
 {
 	void *base;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    get_user(base, &kp->base) ||
-	    put_user(ptr_to_compat((void __user *)base), &up->base) ||
-	    assign_in_user(&up->capability, &kp->capability) ||
-	    assign_in_user(&up->flags, &kp->flags) ||
-	    copy_in_user(&up->fmt, &kp->fmt, sizeof(kp->fmt)))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    get_user(base, &p64->base) ||
+	    put_user(ptr_to_compat((void __user *)base), &p32->base) ||
+	    assign_in_user(&p32->capability, &p64->capability) ||
+	    assign_in_user(&p32->flags, &p64->flags) ||
+	    copy_in_user(&p32->fmt, &p64->fmt, sizeof(p64->fmt)))
 		return -EFAULT;
 	return 0;
 }
@@ -722,18 +722,18 @@ struct v4l2_input32 {
  * The 64-bit v4l2_input struct has extra padding at the end of the struct.
  * Otherwise it is identical to the 32-bit version.
  */
-static inline int get_v4l2_input32(struct v4l2_input __user *kp,
-				   struct v4l2_input32 __user *up)
+static inline int get_v4l2_input32(struct v4l2_input __user *p64,
+				   struct v4l2_input32 __user *p32)
 {
-	if (copy_in_user(kp, up, sizeof(*up)))
+	if (copy_in_user(p64, p32, sizeof(*p32)))
 		return -EFAULT;
 	return 0;
 }
 
-static inline int put_v4l2_input32(struct v4l2_input __user *kp,
-				   struct v4l2_input32 __user *up)
+static inline int put_v4l2_input32(struct v4l2_input __user *p64,
+				   struct v4l2_input32 __user *p32)
 {
-	if (copy_in_user(up, kp, sizeof(*up)))
+	if (copy_in_user(p32, p64, sizeof(*p32)))
 		return -EFAULT;
 	return 0;
 }
@@ -787,13 +787,13 @@ static inline bool ctrl_is_pointer(struct file *file, u32 id)
 		(qec.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD);
 }
 
-static int bufsize_v4l2_ext_controls(struct v4l2_ext_controls32 __user *up,
+static int bufsize_v4l2_ext_controls(struct v4l2_ext_controls32 __user *p32,
 				     u32 *size)
 {
 	u32 count;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    get_user(count, &up->count))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    get_user(count, &p32->count))
 		return -EFAULT;
 	if (count > V4L2_CID_MAX_CTRLS)
 		return -EINVAL;
@@ -802,8 +802,8 @@ static int bufsize_v4l2_ext_controls(struct v4l2_ext_controls32 __user *up,
 }
 
 static int get_v4l2_ext_controls32(struct file *file,
-				   struct v4l2_ext_controls __user *kp,
-				   struct v4l2_ext_controls32 __user *up,
+				   struct v4l2_ext_controls __user *p64,
+				   struct v4l2_ext_controls32 __user *p32,
 				   void __user *aux_buf, u32 aux_space)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
@@ -812,19 +812,19 @@ static int get_v4l2_ext_controls32(struct file *file,
 	u32 n;
 	compat_caddr_t p;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    assign_in_user(&kp->which, &up->which) ||
-	    get_user(count, &up->count) ||
-	    put_user(count, &kp->count) ||
-	    assign_in_user(&kp->error_idx, &up->error_idx) ||
-	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    assign_in_user(&p64->which, &p32->which) ||
+	    get_user(count, &p32->count) ||
+	    put_user(count, &p64->count) ||
+	    assign_in_user(&p64->error_idx, &p32->error_idx) ||
+	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
 
 	if (count == 0)
-		return put_user(NULL, &kp->controls);
+		return put_user(NULL, &p64->controls);
 	if (count > V4L2_CID_MAX_CTRLS)
 		return -EINVAL;
-	if (get_user(p, &up->controls))
+	if (get_user(p, &p32->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
 	if (!access_ok(VERIFY_READ, ucontrols, count * sizeof(*ucontrols)))
@@ -833,7 +833,7 @@ static int get_v4l2_ext_controls32(struct file *file,
 		return -EFAULT;
 	kcontrols = aux_buf;
 	if (put_user((__force struct v4l2_ext_control *)kcontrols,
-		     &kp->controls))
+		     &p64->controls))
 		return -EFAULT;
 
 	for (n = 0; n < count; n++) {
@@ -861,8 +861,8 @@ static int get_v4l2_ext_controls32(struct file *file,
 }
 
 static int put_v4l2_ext_controls32(struct file *file,
-				   struct v4l2_ext_controls __user *kp,
-				   struct v4l2_ext_controls32 __user *up)
+				   struct v4l2_ext_controls __user *p64,
+				   struct v4l2_ext_controls32 __user *p32)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
 	struct v4l2_ext_control *kcontrols;
@@ -879,18 +879,18 @@ static int put_v4l2_ext_controls32(struct file *file,
 	 * So, instead, declare it as ks, and pass it as an userspace
 	 * pointer where needed.
 	 */
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    assign_in_user(&up->which, &kp->which) ||
-	    get_user(count, &kp->count) ||
-	    put_user(count, &up->count) ||
-	    assign_in_user(&up->error_idx, &kp->error_idx) ||
-	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)) ||
-	    get_user(kcontrols, &kp->controls))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    assign_in_user(&p32->which, &p64->which) ||
+	    get_user(count, &p64->count) ||
+	    put_user(count, &p32->count) ||
+	    assign_in_user(&p32->error_idx, &p64->error_idx) ||
+	    copy_in_user(p32->reserved, p64->reserved, sizeof(p32->reserved)) ||
+	    get_user(kcontrols, &p64->controls))
 		return -EFAULT;
 
 	if (!count || count > (U32_MAX/sizeof(*ucontrols)))
 		return 0;
-	if (get_user(p, &up->controls))
+	if (get_user(p, &p32->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
 	if (!access_ok(VERIFY_WRITE, ucontrols, count * sizeof(*ucontrols)))
@@ -940,18 +940,18 @@ struct v4l2_event32 {
 	__u32				reserved[8];
 };
 
-static int put_v4l2_event32(struct v4l2_event __user *kp,
-			    struct v4l2_event32 __user *up)
+static int put_v4l2_event32(struct v4l2_event __user *p64,
+			    struct v4l2_event32 __user *p32)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    assign_in_user(&up->type, &kp->type) ||
-	    copy_in_user(&up->u, &kp->u, sizeof(kp->u)) ||
-	    assign_in_user(&up->pending, &kp->pending) ||
-	    assign_in_user(&up->sequence, &kp->sequence) ||
-	    assign_in_user(&up->timestamp.tv_sec, &kp->timestamp.tv_sec) ||
-	    assign_in_user(&up->timestamp.tv_nsec, &kp->timestamp.tv_nsec) ||
-	    assign_in_user(&up->id, &kp->id) ||
-	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    assign_in_user(&p32->type, &p64->type) ||
+	    copy_in_user(&p32->u, &p64->u, sizeof(p64->u)) ||
+	    assign_in_user(&p32->pending, &p64->pending) ||
+	    assign_in_user(&p32->sequence, &p64->sequence) ||
+	    assign_in_user(&p32->timestamp.tv_sec, &p64->timestamp.tv_sec) ||
+	    assign_in_user(&p32->timestamp.tv_nsec, &p64->timestamp.tv_nsec) ||
+	    assign_in_user(&p32->id, &p64->id) ||
+	    copy_in_user(p32->reserved, p64->reserved, sizeof(p32->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -964,35 +964,35 @@ struct v4l2_edid32 {
 	compat_caddr_t edid;
 };
 
-static int get_v4l2_edid32(struct v4l2_edid __user *kp,
-			   struct v4l2_edid32 __user *up)
+static int get_v4l2_edid32(struct v4l2_edid __user *p64,
+			   struct v4l2_edid32 __user *p32)
 {
 	compat_uptr_t tmp;
 
-	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
-	    assign_in_user(&kp->pad, &up->pad) ||
-	    assign_in_user(&kp->start_block, &up->start_block) ||
-	    assign_in_user(&kp->blocks,
-			   (unsigned char __user *)&up->blocks) ||
-	    get_user(tmp, &up->edid) ||
-	    put_user((void __force *)compat_ptr(tmp), &kp->edid) ||
-	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    assign_in_user(&p64->pad, &p32->pad) ||
+	    assign_in_user(&p64->start_block, &p32->start_block) ||
+	    assign_in_user(&p64->blocks,
+			   (unsigned char __user *)&p32->blocks) ||
+	    get_user(tmp, &p32->edid) ||
+	    put_user((void __force *)compat_ptr(tmp), &p64->edid) ||
+	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
 	return 0;
 }
 
-static int put_v4l2_edid32(struct v4l2_edid __user *kp,
-			   struct v4l2_edid32 __user *up)
+static int put_v4l2_edid32(struct v4l2_edid __user *p64,
+			   struct v4l2_edid32 __user *p32)
 {
 	void *edid;
 
-	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)) ||
-	    assign_in_user(&up->pad, &kp->pad) ||
-	    assign_in_user(&up->start_block, &kp->start_block) ||
-	    assign_in_user(&up->blocks, &kp->blocks) ||
-	    get_user(edid, &kp->edid) ||
-	    put_user(ptr_to_compat((void __user *)edid), &up->edid) ||
-	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    assign_in_user(&p32->pad, &p64->pad) ||
+	    assign_in_user(&p32->start_block, &p64->start_block) ||
+	    assign_in_user(&p32->blocks, &p64->blocks) ||
+	    get_user(edid, &p64->edid) ||
+	    put_user(ptr_to_compat((void __user *)edid), &p32->edid) ||
+	    copy_in_user(p32->reserved, p64->reserved, sizeof(p32->reserved)))
 		return -EFAULT;
 	return 0;
 }
@@ -1026,20 +1026,20 @@ static int put_v4l2_edid32(struct v4l2_edid __user *kp,
 #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
 
 static int alloc_userspace(unsigned int size, u32 aux_space,
-			   void __user **up_native)
+			   void __user **new_p64)
 {
-	*up_native = compat_alloc_user_space(size + aux_space);
-	if (!*up_native)
+	*new_p64 = compat_alloc_user_space(size + aux_space);
+	if (!*new_p64)
 		return -ENOMEM;
-	if (clear_user(*up_native, size))
+	if (clear_user(*new_p64, size))
 		return -EFAULT;
 	return 0;
 }
 
 static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	void __user *up = compat_ptr(arg);
-	void __user *up_native = NULL;
+	void __user *p32 = compat_ptr(arg);
+	void __user *new_p64 = NULL;
 	void __user *aux_buf;
 	u32 aux_space;
 	int compatible_arg = 1;
@@ -1080,50 +1080,50 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_STREAMOFF:
 	case VIDIOC_S_INPUT:
 	case VIDIOC_S_OUTPUT:
-		err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
-		if (!err && assign_in_user((unsigned int __user *)up_native,
-					   (compat_uint_t __user *)up))
+		err = alloc_userspace(sizeof(unsigned int), 0, &new_p64);
+		if (!err && assign_in_user((unsigned int __user *)new_p64,
+					   (compat_uint_t __user *)p32))
 			err = -EFAULT;
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_INPUT:
 	case VIDIOC_G_OUTPUT:
-		err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
+		err = alloc_userspace(sizeof(unsigned int), 0, &new_p64);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_EDID:
 	case VIDIOC_S_EDID:
-		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &up_native);
+		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &new_p64);
 		if (!err)
-			err = get_v4l2_edid32(up_native, up);
+			err = get_v4l2_edid32(new_p64, p32);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
-		err = bufsize_v4l2_format(up, &aux_space);
+		err = bufsize_v4l2_format(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_format),
-					      aux_space, &up_native);
+					      aux_space, &new_p64);
 		if (!err) {
-			aux_buf = up_native + sizeof(struct v4l2_format);
-			err = get_v4l2_format32(up_native, up,
+			aux_buf = new_p64 + sizeof(struct v4l2_format);
+			err = get_v4l2_format32(new_p64, p32,
 						aux_buf, aux_space);
 		}
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_CREATE_BUFS:
-		err = bufsize_v4l2_create(up, &aux_space);
+		err = bufsize_v4l2_create(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_create_buffers),
-					      aux_space, &up_native);
+					      aux_space, &new_p64);
 		if (!err) {
-			aux_buf = up_native + sizeof(struct v4l2_create_buffers);
-			err = get_v4l2_create32(up_native, up,
+			aux_buf = new_p64 + sizeof(struct v4l2_create_buffers);
+			err = get_v4l2_create32(new_p64, p32,
 						aux_buf, aux_space);
 		}
 		compatible_arg = 0;
@@ -1133,13 +1133,13 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF:
-		err = bufsize_v4l2_buffer(up, &aux_space);
+		err = bufsize_v4l2_buffer(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_buffer),
-					      aux_space, &up_native);
+					      aux_space, &new_p64);
 		if (!err) {
-			aux_buf = up_native + sizeof(struct v4l2_buffer);
-			err = get_v4l2_buffer32(up_native, up,
+			aux_buf = new_p64 + sizeof(struct v4l2_buffer);
+			err = get_v4l2_buffer32(new_p64, p32,
 						aux_buf, aux_space);
 		}
 		compatible_arg = 0;
@@ -1147,49 +1147,49 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 	case VIDIOC_S_FBUF:
 		err = alloc_userspace(sizeof(struct v4l2_framebuffer), 0,
-				      &up_native);
+				      &new_p64);
 		if (!err)
-			err = get_v4l2_framebuffer32(up_native, up);
+			err = get_v4l2_framebuffer32(new_p64, p32);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_FBUF:
 		err = alloc_userspace(sizeof(struct v4l2_framebuffer), 0,
-				      &up_native);
+				      &new_p64);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_ENUMSTD:
 		err = alloc_userspace(sizeof(struct v4l2_standard), 0,
-				      &up_native);
+				      &new_p64);
 		if (!err)
-			err = get_v4l2_standard32(up_native, up);
+			err = get_v4l2_standard32(new_p64, p32);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_ENUMINPUT:
-		err = alloc_userspace(sizeof(struct v4l2_input), 0, &up_native);
+		err = alloc_userspace(sizeof(struct v4l2_input), 0, &new_p64);
 		if (!err)
-			err = get_v4l2_input32(up_native, up);
+			err = get_v4l2_input32(new_p64, p32);
 		compatible_arg = 0;
 		break;
 
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		err = bufsize_v4l2_ext_controls(up, &aux_space);
+		err = bufsize_v4l2_ext_controls(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_ext_controls),
-					      aux_space, &up_native);
+					      aux_space, &new_p64);
 		if (!err) {
-			aux_buf = up_native + sizeof(struct v4l2_ext_controls);
-			err = get_v4l2_ext_controls32(file, up_native, up,
+			aux_buf = new_p64 + sizeof(struct v4l2_ext_controls);
+			err = get_v4l2_ext_controls32(file, new_p64, p32,
 						      aux_buf, aux_space);
 		}
 		compatible_arg = 0;
 		break;
 	case VIDIOC_DQEVENT:
-		err = alloc_userspace(sizeof(struct v4l2_event), 0, &up_native);
+		err = alloc_userspace(sizeof(struct v4l2_event), 0, &new_p64);
 		compatible_arg = 0;
 		break;
 	}
@@ -1197,9 +1197,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		return err;
 
 	if (compatible_arg)
-		err = native_ioctl(file, cmd, (unsigned long)up);
+		err = native_ioctl(file, cmd, (unsigned long)p32);
 	else
-		err = native_ioctl(file, cmd, (unsigned long)up_native);
+		err = native_ioctl(file, cmd, (unsigned long)new_p64);
 
 	if (err == -ENOTTY)
 		return err;
@@ -1213,11 +1213,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		if (put_v4l2_ext_controls32(file, up_native, up))
+		if (put_v4l2_ext_controls32(file, new_p64, p32))
 			err = -EFAULT;
 		break;
 	case VIDIOC_S_EDID:
-		if (put_v4l2_edid32(up_native, up))
+		if (put_v4l2_edid32(new_p64, p32))
 			err = -EFAULT;
 		break;
 	}
@@ -1229,46 +1229,46 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_S_OUTPUT:
 	case VIDIOC_G_INPUT:
 	case VIDIOC_G_OUTPUT:
-		if (assign_in_user((compat_uint_t __user *)up,
-				   ((unsigned int __user *)up_native)))
+		if (assign_in_user((compat_uint_t __user *)p32,
+				   ((unsigned int __user *)new_p64)))
 			err = -EFAULT;
 		break;
 
 	case VIDIOC_G_FBUF:
-		err = put_v4l2_framebuffer32(up_native, up);
+		err = put_v4l2_framebuffer32(new_p64, p32);
 		break;
 
 	case VIDIOC_DQEVENT:
-		err = put_v4l2_event32(up_native, up);
+		err = put_v4l2_event32(new_p64, p32);
 		break;
 
 	case VIDIOC_G_EDID:
-		err = put_v4l2_edid32(up_native, up);
+		err = put_v4l2_edid32(new_p64, p32);
 		break;
 
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
-		err = put_v4l2_format32(up_native, up);
+		err = put_v4l2_format32(new_p64, p32);
 		break;
 
 	case VIDIOC_CREATE_BUFS:
-		err = put_v4l2_create32(up_native, up);
+		err = put_v4l2_create32(new_p64, p32);
 		break;
 
 	case VIDIOC_PREPARE_BUF:
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF:
-		err = put_v4l2_buffer32(up_native, up);
+		err = put_v4l2_buffer32(new_p64, p32);
 		break;
 
 	case VIDIOC_ENUMSTD:
-		err = put_v4l2_standard32(up_native, up);
+		err = put_v4l2_standard32(new_p64, p32);
 		break;
 
 	case VIDIOC_ENUMINPUT:
-		err = put_v4l2_input32(up_native, up);
+		err = put_v4l2_input32(new_p64, p32);
 		break;
 	}
 	return err;
-- 
2.14.3
