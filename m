Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50786 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3JQIOw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 04:14:52 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id E42D8200D2
	for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 11:14:49 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: subdev: Check for pads in [gs]_frame_interval
Date: Thu, 17 Oct 2013 11:15:54 +0300
Message-Id: <1381997754-3348-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The validity of the pad field in struct v4l2_subdev_frame_interval was not
ensured by the V4L2 subdev IOCTL helper. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..3fa1907 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -305,11 +305,23 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					fse);
 	}
 
-	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
+	case VIDIOC_SUBDEV_G_FRAME_INTERVAL: {
+		struct v4l2_subdev_frame_interval *fi = arg;
+
+		if (fi->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
 		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
+	}
+
+	case VIDIOC_SUBDEV_S_FRAME_INTERVAL: {
+		struct v4l2_subdev_frame_interval *fi = arg;
+
+		if (fi->pad >= sd->entity.num_pads)
+			return -EINVAL;
 
-	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
 		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
+	}
 
 	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL: {
 		struct v4l2_subdev_frame_interval_enum *fie = arg;
-- 
1.8.3.2

