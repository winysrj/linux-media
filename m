Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3366 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaBJIsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:48:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 23/34] v4l2-controls.txt: update to the new way of accessing controls.
Date: Mon, 10 Feb 2014 09:46:48 +0100
Message-Id: <1392022019-5519-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The way current and new values are accessed has changed. Update the
document to bring it up to date with the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/video4linux/v4l2-controls.txt | 46 +++++++++++++++++++----------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 1c353c2..f94dcfd 100644
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
@@ -288,24 +288,40 @@ of v4l2_device.
 Accessing Control Values
 ========================
 
-The v4l2_ctrl struct contains these two unions:
+The following union is used inside the control framework to access control
+values:
 
-	/* The current control value. */
-	union {
-		s32 val;
-		s64 val64;
-		char *string;
-	} cur;
+union v4l2_ctrl_ptr {
+	s32 *p_s32;
+	s64 *p_s64;
+	char *p_char;
+	void *p;
+};
+
+The v4l2_ctrl struct contains these fields that can be used to access both
+current and new values:
 
-	/* The new control value. */
 	union {
 		s32 val;
 		s64 val64;
-		char *string;
 	};
+	union v4l2_ctrl_ptr new;
+	union v4l2_ctrl_ptr cur;
+
+If the control has a simple s32 type or s64 type, then:
+
+	&ctrl->val == ctrl->new.p_s32
+
+or:
+
+	&ctrl->val64 == ctrl->new.p_s64
+
+For all other types use ctrl->new.p<something> instead of ctrl->val/val64.
+Basically the val and val64 fields can be considered aliases since these
+are used so often.
 
 Within the control ops you can freely use these. The val and val64 speak for
-themselves. The string pointers point to character buffers of length
+themselves. The p_char pointers point to character buffers of length
 ctrl->maximum + 1, and are always 0-terminated.
 
 In most cases 'cur' contains the current cached control value. When you create
-- 
1.8.5.2

