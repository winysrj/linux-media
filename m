Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:35721 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751819AbeDLM6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 08:58:34 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [PATCH 1/1] videodev2: Mark all user pointers as such
Date: Thu, 12 Apr 2018 15:58:24 +0300
Message-Id: <20180412125824.5667-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A number of uAPI structs have pointers but some lack the __user modifier. 
Add this to the pointers that do not have it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Mauro,

I wonder if this would fix some smatch errors or would allow also cleaning
up the casts in the compat code. Either way, this would still be the correct
thing todo.

 include/uapi/linux/videodev2.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9c65d890a5f2d..a2252d0d7051d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -930,7 +930,7 @@ struct v4l2_buffer {
 	union {
 		__u32           offset;
 		unsigned long   userptr;
-		struct v4l2_plane *planes;
+		struct v4l2_plane __user *planes;
 		__s32		fd;
 	} m;
 	__u32			length;
@@ -1014,7 +1014,7 @@ struct v4l2_framebuffer {
 	__u32			flags;
 /* FIXME: in theory we should pass something like PCI device + memory
  * region + offset instead of some physical address */
-	void                    *base;
+	void __user		*base;
 	struct {
 		__u32		width;
 		__u32		height;
@@ -1602,7 +1602,7 @@ struct v4l2_ext_controls {
 	__u32 error_idx;
 	__s32 request_fd;
 	__u32 reserved[1];
-	struct v4l2_ext_control *controls;
+	struct v4l2_ext_control __user *controls;
 };
 
 #define V4L2_CTRL_ID_MASK	  (0x0fffffff)
-- 
2.11.0
