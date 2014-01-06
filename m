Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1731 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbaAFOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 23/27] videodev2.h: add new property types.
Date: Mon,  6 Jan 2014 15:21:22 +0100
Message-Id: <1389018086-15903-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for a selection property and for u8 and u16 matrices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index afa335d..1ceaed1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1220,6 +1220,13 @@ struct v4l2_control {
 	__s32		     value;
 };
 
+/* Property types */
+struct v4l2_prop_selection {
+	__u32 flags;
+	struct v4l2_rect r;
+	__u32 reserved[9];
+};
+
 struct v4l2_ext_control {
 	__u32 id;
 	__u32 size;
@@ -1228,6 +1235,9 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		__u8 *p_u8;
+		__u16 *p_u16;
+		struct v4l2_prop_selection *p_sel;
 		void *p;
 	};
 } __attribute__ ((packed));
@@ -1260,6 +1270,9 @@ enum v4l2_ctrl_type {
 
 	/* Property types are >= 0x0100 */
 	V4L2_PROP_TYPES	             = 0x0100,
+	V4L2_PROP_TYPE_U8	     = 0x0100,
+	V4L2_PROP_TYPE_U16	     = 0x0101,
+	V4L2_PROP_TYPE_SELECTION     = 0x0102,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.8.5.2

