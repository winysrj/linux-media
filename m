Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46213 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbeDQNKQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 09:10:16 -0400
Date: Tue, 17 Apr 2018 10:10:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/5] media: v4l2-compat-ioctl32: fix several __user
 annotations
Message-ID: <20180417101009.71d98c63@vento.lan>
In-Reply-To: <20180417100131.3add7f67@vento.lan>
References: <cover.1523960171.git.mchehab@s-opensource.com>
        <510d0652872c612db21be8b846755f80e3cc4588.1523960171.git.mchehab@s-opensource.com>
        <a150928f-c236-4751-b704-7ce71fd56bc2@cisco.com>
        <20180417075358.61a878c8@vento.lan>
        <b3ed6478-9cf5-478d-067b-5d325dfeaadd@cisco.com>
        <20180417100131.3add7f67@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Apr 2018 10:01:31 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> > >> ->blocks is a u32, so this should be a u32 cast as well.    
> > 
> > Be aware that the unsigned char * cast is actually a bug: it will clamp the
> > u32 'blocks' value to a u8.
> > 
> > Regards,
> > 
> > 	Hans
> 
> What about this approach (code untested)?

Even better:

[PATCH] media: v4l2-compat-ioctl32: simplify casts

Making the cast right for get_user/put_user is not trivial, as
it needs to ensure that the types are the correct ones.

Improve it by using macros.

PS.: Patch untested

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8c05dd9660d3..d2f0268427c2 100644
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
@@ -898,12 +914,11 @@ static int put_v4l2_ext_controls32(struct file *file,
 		unsigned int size = sizeof(*ucontrols);
 		u32 id;
 
-		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||
+		if (get_user_cast(id, &kcontrols->id) ||
 		    put_user(id, &ucontrols->id) ||
-		    assign_in_user(&ucontrols->size,
-				   (unsigned int __user *)&kcontrols->size) ||
+		    assign_in_user_cast(&ucontrols->size, &kcontrols->size) ||
 		    copy_in_user(&ucontrols->reserved2,
-				 (unsigned int __user *)&kcontrols->reserved2,
+				 (void __user *)&kcontrols->reserved2,
 				 sizeof(ucontrols->reserved2)))
 			return -EFAULT;
 
@@ -916,7 +931,7 @@ static int put_v4l2_ext_controls32(struct file *file,
 			size -= sizeof(ucontrols->value64);
 
 		if (copy_in_user(ucontrols,
-			         (unsigned int __user *)kcontrols, size))
+			         (void __user *)kcontrols, size))
 			return -EFAULT;
 
 		ucontrols++;
@@ -970,10 +985,9 @@ static int get_v4l2_edid32(struct v4l2_edid __user *p64,
 	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
 	    assign_in_user(&p64->pad, &p32->pad) ||
 	    assign_in_user(&p64->start_block, &p32->start_block) ||
-	    assign_in_user(&p64->blocks,
-			   (unsigned char __user *)&p32->blocks) ||
+	    assign_in_user_cast(&p64->blocks, &p32->blocks) ||
 	    get_user(tmp, &p32->edid) ||
-	    put_user((void __force *)compat_ptr(tmp), &p64->edid) ||
+	    put_user_force(compat_ptr(tmp), &p64->edid) ||
 	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
 	return 0;


Thanks,
Mauro
