Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50769 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbbBMLam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 06:30:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] v4l2-subdev.h: add 'which' field for the enum structs
Date: Fri, 13 Feb 2015 12:30:01 +0100
Message-Id: <1423827006-32878-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While all other pad ops allow you to select whether to use the 'try' or
the 'active' formats, the enum ops didn't have that option and always used
'try'.

However, this will fail if a simple (e.g. PCI) bridge driver wants to use
the enum pad op of a subdev that's also used in a complex platform driver
like the omap3. Such a bridge driver generally wants to enum formats based
on the active format.

So add a new 'which' field to these structs. Note that V4L2_SUBDEV_FORMAT_TRY
is 0, so the default remains TRY (applications need to set reserved to 0).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-subdev.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index e0a7e3d..dbce2b5 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -69,12 +69,14 @@ struct v4l2_subdev_crop {
  * @pad: pad number, as reported by the media API
  * @index: format index during enumeration
  * @code: format code (MEDIA_BUS_FMT_ definitions)
+ * @which: format type (from enum v4l2_subdev_format_whence)
  */
 struct v4l2_subdev_mbus_code_enum {
 	__u32 pad;
 	__u32 index;
 	__u32 code;
-	__u32 reserved[9];
+	__u32 which;
+	__u32 reserved[8];
 };
 
 /**
@@ -82,6 +84,7 @@ struct v4l2_subdev_mbus_code_enum {
  * @pad: pad number, as reported by the media API
  * @index: format index during enumeration
  * @code: format code (MEDIA_BUS_FMT_ definitions)
+ * @which: format type (from enum v4l2_subdev_format_whence)
  */
 struct v4l2_subdev_frame_size_enum {
 	__u32 index;
@@ -91,7 +94,8 @@ struct v4l2_subdev_frame_size_enum {
 	__u32 max_width;
 	__u32 min_height;
 	__u32 max_height;
-	__u32 reserved[9];
+	__u32 which;
+	__u32 reserved[8];
 };
 
 /**
@@ -113,6 +117,7 @@ struct v4l2_subdev_frame_interval {
  * @width: frame width in pixels
  * @height: frame height in pixels
  * @interval: frame interval in seconds
+ * @which: format type (from enum v4l2_subdev_format_whence)
  */
 struct v4l2_subdev_frame_interval_enum {
 	__u32 index;
@@ -121,7 +126,8 @@ struct v4l2_subdev_frame_interval_enum {
 	__u32 width;
 	__u32 height;
 	struct v4l2_fract interval;
-	__u32 reserved[9];
+	__u32 which;
+	__u32 reserved[8];
 };
 
 /**
-- 
2.1.4

