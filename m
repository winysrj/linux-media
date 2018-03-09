Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56568 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbeCIXtZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 18:49:25 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org
Subject: [RFC 6/8] videodev2.h: add request_fd field to v4l2_ext_controls
Date: Sat, 10 Mar 2018 01:48:50 +0200
Message-Id: <1520639332-19190-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 6c623e5..b58018b 100644
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
index 4fd46ae..ac502ad 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1592,7 +1592,8 @@ struct v4l2_ext_controls {
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
