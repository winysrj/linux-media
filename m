Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33731 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753485AbcHVQMf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 12:12:35 -0400
Received: by mail-qk0-f182.google.com with SMTP id z190so86830243qkc.0
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 09:12:35 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] media: tw686x: Support frame sizes and frame intervals enumeration
Date: Mon, 22 Aug 2016 13:12:24 -0300
Message-Id: <20160822161224.20035-1-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds support for VIDIOC_ENUM_FRAMESIZES
and VIDIOC_ENUM_FRAMEINTERVALS enumeration ioctls.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/tw686x-video.c | 38 +++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index be257d0257a6..e89560d42d16 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -906,6 +906,42 @@ static int tw686x_g_std(struct file *file, void *priv, v4l2_std_id *id)
 	return 0;
 }
 
+static int tw686x_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct tw686x_video_channel *vc = video_drvdata(file);
+
+	if (fsize->index)
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.max_width = TW686X_VIDEO_WIDTH;
+	fsize->stepwise.min_width = fsize->stepwise.max_width / 2;
+	fsize->stepwise.step_width = fsize->stepwise.min_width;
+	fsize->stepwise.max_height = TW686X_VIDEO_HEIGHT(vc->video_standard);
+	fsize->stepwise.min_height = fsize->stepwise.max_height / 2;
+	fsize->stepwise.step_height = fsize->stepwise.min_height;
+	return 0;
+}
+
+static int tw686x_enum_frameintervals(struct file *file, void *priv,
+				      struct v4l2_frmivalenum *ival)
+{
+	struct tw686x_video_channel *vc = video_drvdata(file);
+	int max_fps = TW686X_MAX_FPS(vc->video_standard);
+	int max_rates = DIV_ROUND_UP(max_fps, 2);
+
+	if (ival->index >= max_rates)
+		return -EINVAL;
+
+	ival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	ival->discrete.numerator = 1;
+	if (ival->index < (max_rates - 1))
+		ival->discrete.denominator = (ival->index + 1) * 2;
+	else
+		ival->discrete.denominator = max_fps;
+	return 0;
+}
+
 static int tw686x_g_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *sp)
 {
@@ -1034,6 +1070,8 @@ static const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
 
 	.vidioc_g_parm			= tw686x_g_parm,
 	.vidioc_s_parm			= tw686x_s_parm,
+	.vidioc_enum_framesizes		= tw686x_enum_framesizes,
+	.vidioc_enum_frameintervals	= tw686x_enum_frameintervals,
 
 	.vidioc_enum_input		= tw686x_enum_input,
 	.vidioc_g_input			= tw686x_g_input,
-- 
2.9.0

