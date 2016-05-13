Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:37636 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbcEMW1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 18:27:41 -0400
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Florian Echtler <floe@butterbrot.org>,
	Martin Kaltenbrunner <modin@yuri.at>
Subject: [PATCH 1/3] properly report a single frame rate of 60 FPS
Date: Fri, 13 May 2016 15:19:15 -0700
Message-Id: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device hardware is always running at 60 FPS, so report this both via
PARM_IOCTL and ENUM_FRAMEINTERVALS.

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 880c40b..fcc5934 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -788,6 +788,16 @@ static int sur40_vidioc_fmt(struct file *file, void *priv,
 	return 0;
 }
 
+static int sur40_ioctl_parm(struct file *file, void *priv,
+			    struct v4l2_streamparm *p)
+{
+	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		p->parm.capture.timeperframe.numerator = 1;
+		p->parm.capture.timeperframe.denominator = 60;
+	}
+	return 0;
+}
+
 static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 				 struct v4l2_fmtdesc *f)
 {
@@ -814,13 +824,13 @@ static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
 static int sur40_vidioc_enum_frameintervals(struct file *file, void *priv,
 					    struct v4l2_frmivalenum *f)
 {
-	if ((f->index > 1) || (f->pixel_format != V4L2_PIX_FMT_GREY)
+	if ((f->index > 0) || (f->pixel_format != V4L2_PIX_FMT_GREY)
 		|| (f->width  != sur40_video_format.width)
 		|| (f->height != sur40_video_format.height))
 			return -EINVAL;
 
 	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
-	f->discrete.denominator  = 60/(f->index+1);
+	f->discrete.denominator  = 60;
 	f->discrete.numerator = 1;
 	return 0;
 }
@@ -880,6 +890,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
 	.vidioc_enum_framesizes = sur40_vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = sur40_vidioc_enum_frameintervals,
 
+	.vidioc_g_parm = sur40_ioctl_parm,
+	.vidioc_s_parm = sur40_ioctl_parm,
+
 	.vidioc_enum_input	= sur40_vidioc_enum_input,
 	.vidioc_g_input		= sur40_vidioc_g_input,
 	.vidioc_s_input		= sur40_vidioc_s_input,
-- 
1.9.1

