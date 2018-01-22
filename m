Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34966 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbeAVKTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:19:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 8/9] v4l2-subdev.h: remove obsolete g/s_parm
Date: Mon, 22 Jan 2018 11:18:56 +0100
Message-Id: <20180122101857.51401-9-hverkuil@xs4all.nl>
In-Reply-To: <20180122101857.51401-1-hverkuil@xs4all.nl>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 include/media/v4l2-subdev.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 980a86c08fce..457917e9237f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -393,10 +393,6 @@ struct v4l2_mbus_frame_desc {
  *
  * @g_pixelaspect: callback to return the pixelaspect ratio.
  *
- * @g_parm: callback for VIDIOC_G_PARM() ioctl handler code.
- *
- * @s_parm: callback for VIDIOC_S_PARM() ioctl handler code.
- *
  * @g_frame_interval: callback for VIDIOC_SUBDEV_G_FRAME_INTERVAL()
  *		      ioctl handler code.
  *
@@ -434,8 +430,6 @@ struct v4l2_subdev_video_ops {
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 	int (*g_pixelaspect)(struct v4l2_subdev *sd, struct v4l2_fract *aspect);
-	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
-	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*g_frame_interval)(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *interval);
 	int (*s_frame_interval)(struct v4l2_subdev *sd,
-- 
2.15.1
