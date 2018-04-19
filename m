Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65140 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753479AbeDSQdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 12:33:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>
Subject: [PATCH v2 3/4] media: v4l2-compat-ioctl32: simplify casts
Date: Thu, 19 Apr 2018 12:33:31 -0400
Message-Id: <eedc93e0f7b8a2bd6ec940a0057c5ef82820aea4.1524155425.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524155425.git.mchehab@s-opensource.com>
References: <cover.1524155425.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524155425.git.mchehab@s-opensource.com>
References: <cover.1524155425.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Making the cast right for get_user/put_user is not trivial, as
it needs to ensure that the types are the correct ones.

Improve it by using macros.

Tested with vivid with:
	$ sudo modprobe vivid no_error_inj=1
	$ v4l2-compliance-32bits -a -s10 >32bits && v4l2-compliance-64bits -a -s10 > 64bits && diff -U0 32bits 64bits
	--- 32bits	2018-04-17 11:18:29.141240772 -0300
	+++ 64bits	2018-04-17 11:18:40.635282341 -0300
	@@ -1 +1 @@
	-v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce, 32 bits
	+v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce, 64 bits

Using the latest version of v4l-utils with this patch applied:
	https://patchwork.linuxtv.org/patch/48746/

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 680b64c1d69a..d2f0268427c2 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -30,6 +30,24 @@
 	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
 })
 
+#define get_user_cast(__x, __ptr)					\
+({									\
+	get_user(__x, (typeof(*__ptr) __user *)(__ptr));		\
+})
+
+#define put_user_force(__x, __ptr)					\
+({									\
+	put_user((typeof(*__x) __force *)(__x), __ptr);			\
+})
+
+#define assign_in_user_cast(to, from)					\
+({									\
+	typeof(*from) __assign_tmp;					\
+									\
+	get_user_cast(__assign_tmp, from) || put_user(__assign_tmp, to);\
+})
+
+
 static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret = -ENOIOCTLCMD;
@@ -543,8 +561,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *p64,
 			return -EFAULT;
 
 		uplane = aux_buf;
-		if (put_user((__force struct v4l2_plane *)uplane,
-			     &p64->m.planes))
+		if (put_user_force(uplane, &p64->m.planes))
 			return -EFAULT;
 
 		while (num_planes--) {
@@ -682,7 +699,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *p64,
 
 	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
 	    get_user(tmp, &p32->base) ||
-	    put_user((void __force *)compat_ptr(tmp), &p64->base) ||
+	    put_user_force(compat_ptr(tmp), &p64->base) ||
 	    assign_in_user(&p64->capability, &p32->capability) ||
 	    assign_in_user(&p64->flags, &p32->flags) ||
 	    copy_in_user(&p64->fmt, &p32->fmt, sizeof(p64->fmt)))
@@ -831,8 +848,7 @@ static int get_v4l2_ext_controls32(struct file *file,
 	if (aux_space < count * sizeof(*kcontrols))
 		return -EFAULT;
 	kcontrols = aux_buf;
-	if (put_user((__force struct v4l2_ext_control *)kcontrols,
-		     &p64->controls))
+	if (put_user_force(kcontrols, &p64->controls))
 		return -EFAULT;
 
 	for (n = 0; n < count; n++) {
@@ -898,10 +914,9 @@ static int put_v4l2_ext_controls32(struct file *file,
 		unsigned int size = sizeof(*ucontrols);
 		u32 id;
 
-		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||
+		if (get_user_cast(id, &kcontrols->id) ||
 		    put_user(id, &ucontrols->id) ||
-		    assign_in_user(&ucontrols->size,
-				   (unsigned int __user *)&kcontrols->size) ||
+		    assign_in_user_cast(&ucontrols->size, &kcontrols->size) ||
 		    copy_in_user(&ucontrols->reserved2,
 				 (void __user *)&kcontrols->reserved2,
 				 sizeof(ucontrols->reserved2)))
@@ -970,10 +985,9 @@ static int get_v4l2_edid32(struct v4l2_edid __user *p64,
 	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
 	    assign_in_user(&p64->pad, &p32->pad) ||
 	    assign_in_user(&p64->start_block, &p32->start_block) ||
-	    assign_in_user(&p64->blocks,
-			   (u32 __user *)&p32->blocks) ||
+	    assign_in_user_cast(&p64->blocks, &p32->blocks) ||
 	    get_user(tmp, &p32->edid) ||
-	    put_user((void __force *)compat_ptr(tmp), &p64->edid) ||
+	    put_user_force(compat_ptr(tmp), &p64->edid) ||
 	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
 	return 0;
-- 
2.14.3
