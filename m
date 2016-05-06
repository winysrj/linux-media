Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005AbcEFK4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 09/22] v4l2-subdev.h: Add request field to format and selection structures
Date: Fri,  6 May 2016 13:53:18 +0300
Message-Id: <1462532011-15527-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Let userspace specify a request ID when getting or setting formats or
selection rectangles.

>From a userspace point of view the API change is minimized and doesn't
require any new ioctl.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/v4l2-subdev.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index dbce2b554..dbb7c1d 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -32,10 +32,12 @@
  * enum v4l2_subdev_format_whence - Media bus format type
  * @V4L2_SUBDEV_FORMAT_TRY: try format, for negotiation only
  * @V4L2_SUBDEV_FORMAT_ACTIVE: active format, applied to the device
+ * @V4L2_SUBDEV_FORMAT_REQUEST: format stored in request
  */
 enum v4l2_subdev_format_whence {
 	V4L2_SUBDEV_FORMAT_TRY = 0,
 	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
+	V4L2_SUBDEV_FORMAT_REQUEST = 2,
 };
 
 /**
@@ -43,12 +45,15 @@ enum v4l2_subdev_format_whence {
  * @which: format type (from enum v4l2_subdev_format_whence)
  * @pad: pad number, as reported by the media API
  * @format: media bus format (format code and frame size)
+ * @request: request ID (when which is set to V4L2_SUBDEV_FORMAT_REQUEST)
+ * @reserved: for future use, set to zero for now
  */
 struct v4l2_subdev_format {
 	__u32 which;
 	__u32 pad;
 	struct v4l2_mbus_framefmt format;
-	__u32 reserved[8];
+	__u32 request;
+	__u32 reserved[7];
 };
 
 /**
@@ -139,6 +144,7 @@ struct v4l2_subdev_frame_interval_enum {
  *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r: coordinates of the selection window
+ * @request: request ID (when which is set to V4L2_SUBDEV_FORMAT_REQUEST)
  * @reserved: for future use, set to zero for now
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -151,7 +157,8 @@ struct v4l2_subdev_selection {
 	__u32 target;
 	__u32 flags;
 	struct v4l2_rect r;
-	__u32 reserved[8];
+	__u32 request;
+	__u32 reserved[7];
 };
 
 /* Backwards compatibility define --- to be removed */
-- 
1.9.1

