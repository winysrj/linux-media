Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4635 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaCGKVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:21:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 2/5] v4l2: allow v4l2_subdev_edid to be used with video nodes
Date: Fri,  7 Mar 2014 11:21:16 +0100
Message-Id: <1394187679-7345-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Struct v4l2_subdev_edid and the VIDIOC_SUBDEV_G/S_EDID ioctls were
specific for subdevices, but for hardware with a simple video pipeline
you do not need/want to create subdevice nodes to just get/set the EDID.

Move the v4l2_subdev_edid struct to v4l2-common.h and rename as
v4l2_edid. Add the same ioctls to videodev2.h as well, thus allowing
this API to be used with both video nodes and v4l-subdev nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-common.h |  8 ++++++++
 include/uapi/linux/v4l2-subdev.h | 14 +++++---------
 include/uapi/linux/videodev2.h   |  2 ++
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 4f0667e..270db89 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -68,4 +68,12 @@
 #define V4L2_SUBDEV_SEL_FLAG_SIZE_LE	V4L2_SEL_FLAG_LE
 #define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG V4L2_SEL_FLAG_KEEP_CONFIG
 
+struct v4l2_edid {
+	__u32 pad;
+	__u32 start_block;
+	__u32 blocks;
+	__u32 reserved[5];
+	__u8 __user *edid;
+};
+
 #endif /* __V4L2_COMMON__ */
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index a33c4da..87e0515 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -148,13 +148,8 @@ struct v4l2_subdev_selection {
 	__u32 reserved[8];
 };
 
-struct v4l2_subdev_edid {
-	__u32 pad;
-	__u32 start_block;
-	__u32 blocks;
-	__u32 reserved[5];
-	__u8 __user *edid;
-};
+/* Backwards compatibility define --- to be removed */
+#define v4l2_subdev_edid v4l2_edid
 
 #define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
@@ -174,7 +169,8 @@ struct v4l2_subdev_edid {
 	_IOWR('V', 61, struct v4l2_subdev_selection)
 #define VIDIOC_SUBDEV_S_SELECTION \
 	_IOWR('V', 62, struct v4l2_subdev_selection)
-#define VIDIOC_SUBDEV_G_EDID	_IOWR('V', 40, struct v4l2_subdev_edid)
-#define VIDIOC_SUBDEV_S_EDID	_IOWR('V', 41, struct v4l2_subdev_edid)
+/* These two G/S_EDID ioctls are identical to the ioctls in videodev2.h */
+#define VIDIOC_SUBDEV_G_EDID	_IOWR('V', 40, struct v4l2_edid)
+#define VIDIOC_SUBDEV_S_EDID	_IOWR('V', 41, struct v4l2_edid)
 
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 17acba8..339738a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1913,6 +1913,8 @@ struct v4l2_create_buffers {
 #define VIDIOC_QUERYMENU	_IOWR('V', 37, struct v4l2_querymenu)
 #define VIDIOC_G_INPUT		 _IOR('V', 38, int)
 #define VIDIOC_S_INPUT		_IOWR('V', 39, int)
+#define VIDIOC_G_EDID		_IOWR('V', 40, struct v4l2_edid)
+#define VIDIOC_S_EDID		_IOWR('V', 41, struct v4l2_edid)
 #define VIDIOC_G_OUTPUT		 _IOR('V', 46, int)
 #define VIDIOC_S_OUTPUT		_IOWR('V', 47, int)
 #define VIDIOC_ENUMOUTPUT	_IOWR('V', 48, struct v4l2_output)
-- 
1.9.0

