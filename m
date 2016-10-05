Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:46314 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752437AbcJEMXC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 08:23:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: compat: Prevent allocating excessive amounts of memory
Date: Wed,  5 Oct 2016 15:21:39 +0300
Message-Id: <1475670099-25242-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get_v4l2_ext_controls32() is used to convert the 32-bit compat struct into
native 64-bit representation. The function multiplies the array length by
the entry length before validating size. Perform the size validation
first.

Also use unsigned values for size computation.

Make similar changes to get_v4l2_buffer32() for multi-plane buffers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index bacecbd..7d98624 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -409,7 +409,6 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	struct v4l2_plane32 __user *uplane32;
 	struct v4l2_plane __user *uplane;
 	compat_caddr_t p;
-	int num_planes;
 	int ret;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_buffer32)) ||
@@ -429,12 +428,15 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
-		num_planes = kp->length;
-		if (num_planes == 0) {
+		int num_planes;
+
+		if (kp->length == 0) {
 			kp->m.planes = NULL;
 			/* num_planes == 0 is legal, e.g. when userspace doesn't
 			 * need planes array on DQBUF*/
 			return 0;
+		} else if (kp->length > VIDEO_MAX_PLANES) {
+			return -EINVAL;
 		}
 
 		if (get_user(p, &up->m.planes))
@@ -442,16 +444,16 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 
 		uplane32 = compat_ptr(p);
 		if (!access_ok(VERIFY_READ, uplane32,
-				num_planes * sizeof(struct v4l2_plane32)))
+				kp->length * sizeof(struct v4l2_plane32)))
 			return -EFAULT;
 
 		/* We don't really care if userspace decides to kill itself
 		 * by passing a very big num_planes value */
-		uplane = compat_alloc_user_space(num_planes *
-						sizeof(struct v4l2_plane));
+		uplane = compat_alloc_user_space(kp->length *
+						 sizeof(struct v4l2_plane));
 		kp->m.planes = (__force struct v4l2_plane *)uplane;
 
-		while (--num_planes >= 0) {
+		for (num_planes = kp->length; num_planes >= 0; num_planes--) {
 			ret = get_v4l2_plane32(uplane, uplane32, kp->memory);
 			if (ret)
 				return ret;
@@ -675,20 +677,22 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 		copy_from_user(kp->reserved, up->reserved,
 			       sizeof(kp->reserved)))
 			return -EFAULT;
-	n = kp->count;
-	if (n == 0) {
+	if (kp->count == 0) {
 		kp->controls = NULL;
 		return 0;
+	} else if (kp->count > V4L2_CID_MAX_CTRLS) {
+		return -EINVAL;
 	}
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
 	if (!access_ok(VERIFY_READ, ucontrols,
-			n * sizeof(struct v4l2_ext_control32)))
+			kp->count * sizeof(struct v4l2_ext_control32)))
 		return -EFAULT;
-	kcontrols = compat_alloc_user_space(n * sizeof(struct v4l2_ext_control));
+	kcontrols = compat_alloc_user_space(kp->count *
+					    sizeof(struct v4l2_ext_control));
 	kp->controls = (__force struct v4l2_ext_control *)kcontrols;
-	while (--n >= 0) {
+	for (n = kp->count; n >= 0; n--) {
 		u32 id;
 
 		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
-- 
2.7.4

