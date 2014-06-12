Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3880 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbaFLLyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 03/34] videodev2.h: add initial support for compound controls.
Date: Thu, 12 Jun 2014 13:52:35 +0200
Message-Id: <f04e680dfdbbe16892b9f57e0e1805df145105ed.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Compound controls are controls that can be used for compound and array
types. This allows for more compound data structures to be used with the
control framework.

The existing V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate non-compound
controls, so a new V4L2_CTRL_FLAG_NEXT_COMPOUND flag is added to enumerate
compound controls. Set both flags to enumerate any control (compound or not).

Compound control types will start at V4L2_CTRL_COMPOUND_TYPES. In addition, any
control that uses the new 'ptr' field or the existing 'string' field will have
flag V4L2_CTRL_FLAG_HAS_PAYLOAD set.

While not strictly necessary, adding that flag makes life for applications
a lot simpler. If the flag is not set, then the control value is set
through the value or value64 fields of struct v4l2_ext_control, otherwise
a pointer points to the value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 include/uapi/linux/videodev2.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 168ff50..438c4a6 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1254,6 +1254,7 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		void *ptr;
 	};
 } __attribute__ ((packed));
 
@@ -1278,7 +1279,10 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
 	V4L2_CTRL_TYPE_BITMASK       = 8,
-	V4L2_CTRL_TYPE_INTEGER_MENU = 9,
+	V4L2_CTRL_TYPE_INTEGER_MENU  = 9,
+
+	/* Compound types are >= 0x0100 */
+	V4L2_CTRL_COMPOUND_TYPES     = 0x0100,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
@@ -1314,9 +1318,11 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_SLIDER 		0x0020
 #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
 #define V4L2_CTRL_FLAG_VOLATILE		0x0080
+#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
 
-/*  Query flag, to be ORed with the control ID */
+/*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
+#define V4L2_CTRL_FLAG_NEXT_COMPOUND	0x40000000
 
 /*  User-class control IDs defined by V4L2 */
 #define V4L2_CID_MAX_CTRLS		1024
-- 
2.0.0.rc0

