Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45970 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752796AbeC1SNL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 14:13:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH for v3.18 08/18] media: v4l2-compat-ioctl32.c: fix ctrl_is_pointer
Date: Wed, 28 Mar 2018 15:12:27 -0300
Message-Id: <63df92f6981785c5e31c1d8e796e827344cc75f3.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit b8c601e8af2d08f733d74defa8465303391bb930 upstream.

ctrl_is_pointer just hardcoded two known string controls, but that
caused problems when using e.g. custom controls that use a pointer
for the payload.

Reimplement this function: it now finds the v4l2_ctrl (if the driver
uses the control framework) or it calls vidioc_query_ext_ctrl (if the
driver implements that directly).

In both cases it can now check if the control is a pointer control
or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 57 ++++++++++++++++++---------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index a27fd9105948..c78462e79a0a 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -18,6 +18,8 @@
 #include <linux/videodev2.h>
 #include <linux/v4l2-subdev.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-ioctl.h>
 
 static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -575,24 +577,39 @@ struct v4l2_ext_control32 {
 	};
 } __attribute__ ((packed));
 
-/* The following function really belong in v4l2-common, but that causes
-   a circular dependency between modules. We need to think about this, but
-   for now this will do. */
-
-/* Return non-zero if this control is a pointer type. Currently only
-   type STRING is a pointer type. */
-static inline int ctrl_is_pointer(u32 id)
+/* Return true if this control is a pointer type. */
+static inline bool ctrl_is_pointer(struct file *file, u32 id)
 {
-	switch (id) {
-	case V4L2_CID_RDS_TX_PS_NAME:
-	case V4L2_CID_RDS_TX_RADIO_TEXT:
-		return 1;
-	default:
-		return 0;
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_fh *fh = NULL;
+	struct v4l2_ctrl_handler *hdl = NULL;
+	struct v4l2_query_ext_ctrl qec = { id };
+	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags))
+		fh = file->private_data;
+
+	if (fh && fh->ctrl_handler)
+		hdl = fh->ctrl_handler;
+	else if (vdev->ctrl_handler)
+		hdl = vdev->ctrl_handler;
+
+	if (hdl) {
+		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, id);
+
+		return ctrl && ctrl->is_ptr;
 	}
+
+	if (!ops->vidioc_query_ext_ctrl)
+		return false;
+
+	return !ops->vidioc_query_ext_ctrl(file, fh, &qec) &&
+		(qec.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD);
 }
 
-static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
+static int get_v4l2_ext_controls32(struct file *file,
+				   struct v4l2_ext_controls *kp,
+				   struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
 	struct v4l2_ext_control __user *kcontrols;
@@ -624,7 +641,7 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 			return -EFAULT;
 		if (get_user(id, &kcontrols->id))
 			return -EFAULT;
-		if (ctrl_is_pointer(id)) {
+		if (ctrl_is_pointer(file, id)) {
 			void __user *s;
 
 			if (get_user(p, &ucontrols->string))
@@ -639,7 +656,9 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	return 0;
 }
 
-static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
+static int put_v4l2_ext_controls32(struct file *file,
+				   struct v4l2_ext_controls *kp,
+				   struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
 	struct v4l2_ext_control __user *kcontrols =
@@ -671,7 +690,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 		/* Do not modify the pointer when copying a pointer control.
 		   The contents of the pointer was changed, not the pointer
 		   itself. */
-		if (ctrl_is_pointer(id))
+		if (ctrl_is_pointer(file, id))
 			size -= sizeof(ucontrols->value64);
 		if (copy_in_user(ucontrols, kcontrols, size))
 			return -EFAULT;
@@ -884,7 +903,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
+		err = get_v4l2_ext_controls32(file, &karg.v2ecs, up);
 		compatible_arg = 0;
 		break;
 	case VIDIOC_DQEVENT:
@@ -911,7 +930,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		if (put_v4l2_ext_controls32(&karg.v2ecs, up))
+		if (put_v4l2_ext_controls32(file, &karg.v2ecs, up))
 			err = -EFAULT;
 		break;
 	}
-- 
2.14.3
