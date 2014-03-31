Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbaCaIXB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 04:23:01 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 89E8F20228
	for <linux-media@vger.kernel.org>; Mon, 31 Mar 2014 11:22:58 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Check pad arguments for [gs]_frame_interval
Date: Mon, 31 Mar 2014 11:23:08 +0300
Message-Id: <1396254188-7277-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_SUBDEV_[GS]_FRAME_INTERVAL IOCTLs argument structs contain the pad
field but the validity check was missing. There should be no implications
security-wise from this since no driver currently uses the pad field in the
struct.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index aea84ac..0ed4c5b 100644
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

