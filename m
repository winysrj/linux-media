Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaDQONc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 24/49] v4l: Improve readability by not wrapping ioctl number #define's
Date: Thu, 17 Apr 2014 16:12:55 +0200
Message-Id: <1397744000-23967-25-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wrapping the #define's at a 80 columns boundary just obfuscates the
code. Don't do that.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/v4l2-subdev.h | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 87e0515..db28964 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -151,26 +151,19 @@ struct v4l2_subdev_selection {
 /* Backwards compatibility define --- to be removed */
 #define v4l2_subdev_edid v4l2_edid
 
-#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
-#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
-#define VIDIOC_SUBDEV_G_FRAME_INTERVAL \
-			_IOWR('V', 21, struct v4l2_subdev_frame_interval)
-#define VIDIOC_SUBDEV_S_FRAME_INTERVAL \
-			_IOWR('V', 22, struct v4l2_subdev_frame_interval)
-#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
-			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
-#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
-			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
-#define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
-			_IOWR('V', 75, struct v4l2_subdev_frame_interval_enum)
-#define VIDIOC_SUBDEV_G_CROP	_IOWR('V', 59, struct v4l2_subdev_crop)
-#define VIDIOC_SUBDEV_S_CROP	_IOWR('V', 60, struct v4l2_subdev_crop)
-#define VIDIOC_SUBDEV_G_SELECTION \
-	_IOWR('V', 61, struct v4l2_subdev_selection)
-#define VIDIOC_SUBDEV_S_SELECTION \
-	_IOWR('V', 62, struct v4l2_subdev_selection)
+#define VIDIOC_SUBDEV_G_FMT			_IOWR('V',  4, struct v4l2_subdev_format)
+#define VIDIOC_SUBDEV_S_FMT			_IOWR('V',  5, struct v4l2_subdev_format)
+#define VIDIOC_SUBDEV_G_FRAME_INTERVAL		_IOWR('V', 21, struct v4l2_subdev_frame_interval)
+#define VIDIOC_SUBDEV_S_FRAME_INTERVAL		_IOWR('V', 22, struct v4l2_subdev_frame_interval)
+#define VIDIOC_SUBDEV_ENUM_MBUS_CODE		_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
+#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE		_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
+#define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL	_IOWR('V', 75, struct v4l2_subdev_frame_interval_enum)
+#define VIDIOC_SUBDEV_G_CROP			_IOWR('V', 59, struct v4l2_subdev_crop)
+#define VIDIOC_SUBDEV_S_CROP			_IOWR('V', 60, struct v4l2_subdev_crop)
+#define VIDIOC_SUBDEV_G_SELECTION		_IOWR('V', 61, struct v4l2_subdev_selection)
+#define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct v4l2_subdev_selection)
 /* These two G/S_EDID ioctls are identical to the ioctls in videodev2.h */
-#define VIDIOC_SUBDEV_G_EDID	_IOWR('V', 40, struct v4l2_edid)
-#define VIDIOC_SUBDEV_S_EDID	_IOWR('V', 41, struct v4l2_edid)
+#define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct v4l2_edid)
+#define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct v4l2_edid)
 
 #endif
-- 
1.8.3.2

