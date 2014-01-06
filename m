Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2994 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaAFOVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 04/27] videodev2.h: add initial support for properties.
Date: Mon,  6 Jan 2014 15:21:03 +0100
Message-Id: <1389018086-15903-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Properties are controls that are not shown in GUIs and can be used for
compound and array types.

This allows for more complex datastructures to be used with the
control framework.

Properties will have the V4L2_CTRL_FLAG_PROPERTY flag set. The existing
V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate controls, so a new
V4L2_CTRL_FLAG_NEXT_PROP flag is added to enumerate properties. Set both
flags to enumerate both controls and properties.

Property-specific types will start at V4L2_PROP_TYPES. In addition, any
control or property that uses the new 'p' field (or the existing 'string'
field) will have flag V4L2_CTRL_FLAG_IS_PTR set.

While not strictly necessary, adding that flag makes life for applications
a lot simpler. If the flag is not set, then the control value is set
through the value or value64 fields of struct v4l2_ext_control, otherwise
a pointer points to the value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..c8e2259 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1228,6 +1228,7 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		void *p;
 	};
 } __attribute__ ((packed));
 
@@ -1252,7 +1253,10 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
 	V4L2_CTRL_TYPE_BITMASK       = 8,
-	V4L2_CTRL_TYPE_INTEGER_MENU = 9,
+	V4L2_CTRL_TYPE_INTEGER_MENU  = 9,
+
+	/* Property types are >= 0x0100 */
+	V4L2_PROP_TYPES	             = 0x0100,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
@@ -1288,9 +1292,12 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_SLIDER 		0x0020
 #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
 #define V4L2_CTRL_FLAG_VOLATILE		0x0080
+#define V4L2_CTRL_FLAG_PROPERTY		0x0100
+#define V4L2_CTRL_FLAG_IS_PTR		0x0200
 
-/*  Query flag, to be ORed with the control ID */
+/*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
+#define V4L2_CTRL_FLAG_NEXT_PROP	0x40000000
 
 /*  User-class control IDs defined by V4L2 */
 #define V4L2_CID_MAX_CTRLS		1024
-- 
1.8.5.2

