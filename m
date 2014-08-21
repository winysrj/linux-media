Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1150 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaHUUT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/12] v4l2-compat-ioctl32: fix sparse warnings
Date: Thu, 21 Aug 2014 22:19:36 +0200
Message-Id: <1408652376-39525-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A lot of these warnings are caused by the fact that we don't generally use
__user in videodev2.h. Normally the video_usercopy function will copy anything
pointed to by pointers into kernel space, so having __user in the struct will only
cause lots of warnings in the drivers. But the flip side of that is that you
need to add __force casts here.

drivers/media/v4l2-core/v4l2-compat-ioctl32.c:337:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:337:30: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:338:31: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:338:49: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:343:21: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:346:21: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:349:35: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:349:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:352:35: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:352:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:363:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:363:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:364:31: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:364:51: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:371:35: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:371:56: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:376:35: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:376:48: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:430:30: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:433:48: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:433:56: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:501:24: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:507:48: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:507:56: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:565:18: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:670:22: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:680:29: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:692:55: warning: incorrect type in initializer (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:773:18: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:786:30: warning: incorrect type in argument 1 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:786:44: warning: incorrect type in argument 2 (different address spaces)
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:674:37: warning: dereference of noderef expression
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:718:37: warning: dereference of noderef expression

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 30 +++++++++++++++++----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index cca6c2f..e502a5f 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -328,7 +328,7 @@ struct v4l2_buffer32 {
 	__u32			reserved;
 };
 
-static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
+static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __user *up32,
 				enum v4l2_memory memory)
 {
 	void __user *up_pln;
@@ -357,7 +357,7 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 	return 0;
 }
 
-static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
+static int put_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __user *up32,
 				enum v4l2_memory memory)
 {
 	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
@@ -427,7 +427,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		 * by passing a very big num_planes value */
 		uplane = compat_alloc_user_space(num_planes *
 						sizeof(struct v4l2_plane));
-		kp->m.planes = uplane;
+		kp->m.planes = (__force struct v4l2_plane *)uplane;
 
 		while (--num_planes >= 0) {
 			ret = get_v4l2_plane32(uplane, uplane32, kp->memory);
@@ -498,7 +498,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		if (num_planes == 0)
 			return 0;
 
-		uplane = kp->m.planes;
+		uplane = (__force struct v4l2_plane __user *)kp->m.planes;
 		if (get_user(p, &up->m.planes))
 			return -EFAULT;
 		uplane32 = compat_ptr(p);
@@ -562,7 +562,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 		get_user(kp->flags, &up->flags) ||
 		copy_from_user(&kp->fmt, &up->fmt, sizeof(up->fmt)))
 			return -EFAULT;
-	kp->base = compat_ptr(tmp);
+	kp->base = (__force void *)compat_ptr(tmp);
 	return 0;
 }
 
@@ -667,11 +667,15 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 			n * sizeof(struct v4l2_ext_control32)))
 		return -EFAULT;
 	kcontrols = compat_alloc_user_space(n * sizeof(struct v4l2_ext_control));
-	kp->controls = kcontrols;
+	kp->controls = (__force struct v4l2_ext_control *)kcontrols;
 	while (--n >= 0) {
+		u32 id;
+
 		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
 			return -EFAULT;
-		if (ctrl_is_pointer(kcontrols->id)) {
+		if (get_user(id, &kcontrols->id))
+			return -EFAULT;
+		if (ctrl_is_pointer(id)) {
 			void __user *s;
 
 			if (get_user(p, &ucontrols->string))
@@ -689,7 +693,8 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
-	struct v4l2_ext_control __user *kcontrols = kp->controls;
+	struct v4l2_ext_control __user *kcontrols =
+		(__force struct v4l2_ext_control __user *)kp->controls;
 	int n = kp->count;
 	compat_caddr_t p;
 
@@ -711,11 +716,14 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 
 	while (--n >= 0) {
 		unsigned size = sizeof(*ucontrols);
+		u32 id;
 
+		if (get_user(id, &kcontrols->id))
+			return -EFAULT;
 		/* Do not modify the pointer when copying a pointer control.
 		   The contents of the pointer was changed, not the pointer
 		   itself. */
-		if (ctrl_is_pointer(kcontrols->id))
+		if (ctrl_is_pointer(id))
 			size -= sizeof(ucontrols->value64);
 		if (copy_in_user(ucontrols, kcontrols, size))
 			return -EFAULT;
@@ -770,7 +778,7 @@ static int get_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 		get_user(tmp, &up->edid) ||
 		copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
 			return -EFAULT;
-	kp->edid = compat_ptr(tmp);
+	kp->edid = (__force u8 *)compat_ptr(tmp);
 	return 0;
 }
 
@@ -783,7 +791,7 @@ static int put_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 		put_user(kp->start_block, &up->start_block) ||
 		put_user(kp->blocks, &up->blocks) ||
 		put_user(tmp, &up->edid) ||
-		copy_to_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+		copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
 			return -EFAULT;
 	return 0;
 }
-- 
2.1.0.rc1

