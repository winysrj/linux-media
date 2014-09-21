Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3719 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaIUOsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/11] videodev2.h: add v4l2_ctrl_selection compound control type.
Date: Sun, 21 Sep 2014 16:48:27 +0200
Message-Id: <1411310909-32825-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This will be used by a new selection control.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-ctrls.h     | 2 ++
 include/uapi/linux/videodev2.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 3005d88..c2fd050 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -46,6 +46,7 @@ struct poll_table_struct;
  * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_u32:	Pointer to a 32-bit unsigned value.
  * @p_char:	Pointer to a string.
+ * @p_sel:	Pointer to a struct v4l2_ctrl_selection.
  * @p:		Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -55,6 +56,7 @@ union v4l2_ctrl_ptr {
 	u16 *p_u16;
 	u32 *p_u32;
 	char *p_char;
+	struct v4l2_ctrl_selection *p_sel;
 	void *p;
 };
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fa84070..e956472 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1271,6 +1271,12 @@ struct v4l2_output {
 #define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
 
+struct v4l2_ctrl_selection {
+	__u32 flags;
+	struct v4l2_rect r;
+	__u32 reserved[9];
+};
+
 /*
  *	C O N T R O L S
  */
@@ -1290,6 +1296,7 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_selection __user *p_sel;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1330,6 +1337,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_SELECTION     = 0x0103,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.1.0

