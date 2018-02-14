Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:37861 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967538AbeBNL7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:59:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v3.16 09/14] media: v4l2-compat-ioctl32.c: fix ctrl_is_pointer
Date: Wed, 14 Feb 2018 12:59:33 +0100
Message-Id: <20180214115938.28296-10-hverkuil@xs4all.nl>
In-Reply-To: <20180214115938.28296-1-hverkuil@xs4all.nl>
References: <20180214115938.28296-1-hverkuil@xs4all.nl>
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
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 50 +++++++++++++++++----------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 3a72a735a940..69d772d1237d 100644
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
@@ -567,24 +569,32 @@ struct v4l2_ext_control32 {
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
+		return ctrl && ctrl->type == V4L2_CTRL_TYPE_STRING;
 	}
+	return false;
 }
 
-static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
+static int get_v4l2_ext_controls32(struct file *file,
+				   struct v4l2_ext_controls *kp,
+				   struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
 	struct v4l2_ext_control __user *kcontrols;
@@ -612,7 +622,7 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	while (--n >= 0) {
 		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
 			return -EFAULT;
-		if (ctrl_is_pointer(kcontrols->id)) {
+		if (ctrl_is_pointer(file, kcontrols->id)) {
 			void __user *s;
 
 			if (get_user(p, &ucontrols->string))
@@ -627,7 +637,9 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	return 0;
 }
 
-static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
+static int put_v4l2_ext_controls32(struct file *file,
+				   struct v4l2_ext_controls *kp,
+				   struct v4l2_ext_controls32 __user *up)
 {
 	struct v4l2_ext_control32 __user *ucontrols;
 	struct v4l2_ext_control __user *kcontrols = kp->controls;
@@ -655,7 +667,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 		/* Do not modify the pointer when copying a pointer control.
 		   The contents of the pointer was changed, not the pointer
 		   itself. */
-		if (ctrl_is_pointer(kcontrols->id))
+		if (ctrl_is_pointer(file, kcontrols->id))
 			size -= sizeof(ucontrols->value64);
 		if (copy_in_user(ucontrols, kcontrols, size))
 			return -EFAULT;
@@ -869,7 +881,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
+		err = get_v4l2_ext_controls32(file, &karg.v2ecs, up);
 		compatible_arg = 0;
 		break;
 	case VIDIOC_DQEVENT:
@@ -896,7 +908,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS:
-		if (put_v4l2_ext_controls32(&karg.v2ecs, up))
+		if (put_v4l2_ext_controls32(file, &karg.v2ecs, up))
 			err = -EFAULT;
 		break;
 	}
-- 
2.15.1
