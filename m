Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:57720 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2KEXO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 18:14:59 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] OV5642: fix VIDIOC_S_GROP ioctl
Date: Tue,  6 Nov 2012 00:14:50 +0100
Message-Id: <1352157290-13201-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_S_GROP ioctl doesn't work, soc-camera driver reports:

soc-camera-pdrv soc-camera-pdrv.0: S_CROP denied: getting current crop failed

The issue is caused by checking for V4L2_BUF_TYPE_VIDEO_CAPTURE type
in driver's g_crop callback. This check should be in s_crop instead,
g_crop should just set the type field to V4L2_BUF_TYPE_VIDEO_CAPTURE
as other drivers do. Move the V4L2_BUF_TYPE_VIDEO_CAPTURE type check
to s_crop callback.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/ov5642.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 8577e0c..19863e5 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -872,6 +872,9 @@ static int ov5642_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	struct v4l2_rect rect = a->c;
 	int ret;
 
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	v4l_bound_align_image(&rect.width, 48, OV5642_MAX_WIDTH, 1,
 			      &rect.height, 32, OV5642_MAX_HEIGHT, 1, 0);
 
@@ -899,9 +902,7 @@ static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct ov5642 *priv = to_ov5642(client);
 	struct v4l2_rect *rect = &a->c;
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	*rect = priv->crop_rect;
 
 	return 0;
-- 
1.7.1

