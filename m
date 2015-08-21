Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33815 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbbHUNTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 09:19:37 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 02/10] videodev2.h: Extend struct v4l2_ext_controls
Date: Fri, 21 Aug 2015 15:19:21 +0200
Message-Id: <1440163169-18047-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So it can be used to get the default value of a control.

Without this change it is not possible to get  get the
default value of array controls.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 include/uapi/linux/videodev2.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 72fa3e490e30..2e857b19a155 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1461,7 +1461,10 @@ struct v4l2_ext_control {
 } __attribute__ ((packed));
 
 struct v4l2_ext_controls {
-	__u32 ctrl_class;
+	union {
+		__u32 ctrl_class;
+		__u32 which;
+	};
 	__u32 count;
 	__u32 error_idx;
 	__u32 reserved[2];
@@ -1472,6 +1475,8 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
 #define V4L2_CTRL_DRIVER_PRIV(id) (((id) & 0xffff) >= 0x1000)
 #define V4L2_CTRL_MAX_DIMS	  (4)
+#define V4L2_CTRL_WHICH_CUR_VAL   0
+#define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
 
 enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER	     = 1,
-- 
2.5.0

