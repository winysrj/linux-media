Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:16841 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751471AbeCWVS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org
Subject: [RFC v2 04/10] videodev2.h: add request_fd field to v4l2_ext_controls
Date: Fri, 23 Mar 2018 23:17:38 +0200
Message-Id: <1521839864-10146-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandre Courbot <acourbot@chromium.org>

Allow to specify a request to be used with the S_EXT_CTRLS and
G_EXT_CTRLS operations.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
[Sakari Ailus: reserved no longer an array, add compat32 code]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 9 ++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c          | 2 +-
 include/uapi/linux/videodev2.h                | 3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 61a8bd4..9adb367 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -733,7 +733,8 @@ struct v4l2_ext_controls32 {
 	__u32 which;
 	__u32 count;
 	__u32 error_idx;
-	__u32 reserved[2];
+	__s32 request_fd;
+	__u32 reserved;
 	compat_caddr_t controls; /* actually struct v4l2_ext_control32 * */
 };
 
@@ -808,7 +809,8 @@ static int get_v4l2_ext_controls32(struct file *file,
 	    get_user(count, &up->count) ||
 	    put_user(count, &kp->count) ||
 	    assign_in_user(&kp->error_idx, &up->error_idx) ||
-	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+	    assign_in_user(&kp->request_fd, &up->request_fd) ||
+	    assign_in_user(&kp->reserved, &up->reserved))
 		return -EFAULT;
 
 	if (count == 0)
@@ -866,7 +868,8 @@ static int put_v4l2_ext_controls32(struct file *file,
 	    get_user(count, &kp->count) ||
 	    put_user(count, &up->count) ||
 	    assign_in_user(&up->error_idx, &kp->error_idx) ||
-	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)) ||
+	    assign_in_user(&up->request_fd, &kp->request_fd) ||
+	    assign_in_user(&up->reserved, &kp->reserved) ||
 	    get_user(kcontrols, &kp->controls))
 		return -EFAULT;
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c2671de..85c4bb9 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -870,7 +870,7 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	__u32 i;
 
 	/* zero the reserved fields */
-	c->reserved[0] = c->reserved[1] = 0;
+	c->reserved = 0;
 	for (i = 0; i < c->count; i++)
 		c->controls[i].reserved2[0] = 0;
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index d39932d..e6e68a5 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1593,7 +1593,8 @@ struct v4l2_ext_controls {
 	};
 	__u32 count;
 	__u32 error_idx;
-	__u32 reserved[2];
+	__s32 request_fd;
+	__u32 reserved;
 	struct v4l2_ext_control *controls;
 };
 
-- 
2.7.4
