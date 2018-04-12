Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57088 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751870AbeDLNDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 09:03:24 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [PATCH v1.1 1/1] videodev2: Mark all user pointers as such
Date: Thu, 12 Apr 2018 16:03:22 +0300
Message-Id: <20180412130322.24762-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A number of uAPI structs have pointers but some lack the __user modifier.
Add this to the pointers that do not have it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Against the master branch (not Hans's reqv10)

 include/uapi/linux/videodev2.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877be5c22..ac9c65ee4c56 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -929,7 +929,7 @@ struct v4l2_buffer {
 	union {
 		__u32           offset;
 		unsigned long   userptr;
-		struct v4l2_plane *planes;
+		struct v4l2_plane __user *planes;
 		__s32		fd;
 	} m;
 	__u32			length;
@@ -1006,7 +1006,7 @@ struct v4l2_framebuffer {
 	__u32			flags;
 /* FIXME: in theory we should pass something like PCI device + memory
  * region + offset instead of some physical address */
-	void                    *base;
+	void __user		*base;
 	struct {
 		__u32		width;
 		__u32		height;
@@ -1593,7 +1593,7 @@ struct v4l2_ext_controls {
 	__u32 count;
 	__u32 error_idx;
 	__u32 reserved[2];
-	struct v4l2_ext_control *controls;
+	struct v4l2_ext_control __user *controls;
 };
 
 #define V4L2_CTRL_ID_MASK	  (0x0fffffff)
-- 
2.11.0
