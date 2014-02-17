Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1785 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaBQJ6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:58:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 04/35] videodev2.h: add initial support for complex controls.
Date: Mon, 17 Feb 2014 10:57:19 +0100
Message-Id: <1392631070-41868-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Complex controls are controls that can be used for compound and array
types. This allows for more complex data structures to be used with the
control framework.

Such controls always have the V4L2_CTRL_FLAG_HIDDEN flag set. Note that
'simple' controls can also set that flag.

The existing V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate controls
that do not have the HIDDEN flag, so a new V4L2_CTRL_FLAG_NEXT_HIDDEN flag
is added to enumerate hidden controls. Set both flags to enumerate any
controls (hidden or not).

Complex control types will start at V4L2_CTRL_COMPLEX_TYPES. In addition, any
control that uses the new 'p' field or the existing 'string' field will have
flag V4L2_CTRL_FLAG_IS_PTR set.

While not strictly necessary, adding that flag makes life for applications
a lot simpler. If the flag is not set, then the control value is set
through the value or value64 fields of struct v4l2_ext_control, otherwise
a pointer points to the value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 include/uapi/linux/videodev2.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe..4d7782a 100644
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
+	/* Complex types are >= 0x0100 */
+	V4L2_CTRL_COMPLEX_TYPES	     = 0x0100,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
@@ -1288,9 +1292,12 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_SLIDER 		0x0020
 #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
 #define V4L2_CTRL_FLAG_VOLATILE		0x0080
+#define V4L2_CTRL_FLAG_HIDDEN		0x0100
+#define V4L2_CTRL_FLAG_IS_PTR		0x0200
 
-/*  Query flag, to be ORed with the control ID */
+/*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
+#define V4L2_CTRL_FLAG_NEXT_HIDDEN	0x40000000
 
 /*  User-class control IDs defined by V4L2 */
 #define V4L2_CID_MAX_CTRLS		1024
-- 
1.8.4.rc3

