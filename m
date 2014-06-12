Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1323 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268AbaFLLzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:55:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 22/34] v4l2-controls.txt: update to the new way of accessing controls.
Date: Thu, 12 Jun 2014 13:52:54 +0200
Message-Id: <9b7abc6a3594af24e2762d4bdbed631585a62342.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The way current and new values are accessed has changed. Update the
document to bring it up to date with the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/video4linux/v4l2-controls.txt | 61 ++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index c9ee9a7..0f84ce8 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -77,9 +77,9 @@ Basic usage for V4L2 and sub-device drivers
 
   Where foo->v4l2_dev is of type struct v4l2_device.
 
-  Finally, remove all control functions from your v4l2_ioctl_ops:
-  vidioc_queryctrl, vidioc_querymenu, vidioc_g_ctrl, vidioc_s_ctrl,
-  vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
+  Finally, remove all control functions from your v4l2_ioctl_ops (if any):
+  vidioc_queryctrl, vidioc_query_ext_ctrl, vidioc_querymenu, vidioc_g_ctrl,
+  vidioc_s_ctrl, vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
   Those are now no longer needed.
 
 1.3.2) For sub-device drivers do this:
@@ -258,8 +258,8 @@ The new control value has already been validated, so all you need to do is
 to actually update the hardware registers.
 
 You're done! And this is sufficient for most of the drivers we have. No need
-to do any validation of control values, or implement QUERYCTRL/QUERYMENU. And
-G/S_CTRL as well as G/TRY/S_EXT_CTRLS are automatically supported.
+to do any validation of control values, or implement QUERYCTRL, QUERY_EXT_CTRL
+and QUERYMENU. And G/S_CTRL as well as G/TRY/S_EXT_CTRLS are automatically supported.
 
 
 ==============================================================================
@@ -288,30 +288,45 @@ of v4l2_device.
 Accessing Control Values
 ========================
 
-The v4l2_ctrl struct contains these two unions:
+The following union is used inside the control framework to access control
+values:
 
-	/* The current control value. */
-	union {
+union v4l2_ctrl_ptr {
+	s32 *p_s32;
+	s64 *p_s64;
+	char *p_char;
+	void *p;
+};
+
+The v4l2_ctrl struct contains these fields that can be used to access both
+current and new values:
+
+	s32 val;
+	struct {
 		s32 val;
-		s64 val64;
-		char *string;
 	} cur;
 
-	/* The new control value. */
-	union {
-		s32 val;
-		s64 val64;
-		char *string;
-	};
 
-Within the control ops you can freely use these. The val and val64 speak for
-themselves. The string pointers point to character buffers of length
+	union v4l2_ctrl_ptr p_new;
+	union v4l2_ctrl_ptr p_cur;
+
+If the control has a simple s32 type type, then:
+
+	&ctrl->val == ctrl->p_new.p_s32
+	&ctrl->cur.val == ctrl->p_cur.p_s32
+
+For all other types use ctrl->p_cur.p<something>. Basically the val
+and cur.val fields can be considered an alias since these are used so often.
+
+Within the control ops you can freely use these. The val and cur.val speak for
+themselves. The p_char pointers point to character buffers of length
 ctrl->maximum + 1, and are always 0-terminated.
 
-In most cases 'cur' contains the current cached control value. When you create
-a new control this value is made identical to the default value. After calling
-v4l2_ctrl_handler_setup() this value is passed to the hardware. It is generally
-a good idea to call this function.
+Unless the control is marked volatile the p_cur field points to the the
+current cached control value. When you create a new control this value is made
+identical to the default value. After calling v4l2_ctrl_handler_setup() this
+value is passed to the hardware. It is generally a good idea to call this
+function.
 
 Whenever a new value is set that new value is automatically cached. This means
 that most drivers do not need to implement the g_volatile_ctrl() op. The
@@ -363,7 +378,7 @@ You can also take the handler lock yourself:
 
 	mutex_lock(&state->ctrl_handler.lock);
 	pr_info("String value is '%s'\n", ctrl1->p_cur.p_char);
-	printk(KERN_INFO "Integer value is '%s'\n", ctrl2->cur.val);
+	pr_info("Integer value is '%s'\n", ctrl2->cur.val);
 	mutex_unlock(&state->ctrl_handler.lock);
 
 
-- 
2.0.0.rc0

