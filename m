Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48944 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbbEUMhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 08:37:16 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: modin@yuri.at, Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 2/4] add frame size/frame rate query functions
Date: Thu, 21 May 2015 14:29:40 +0200
Message-Id: <1432211382-5155-3-git-send-email-floe@butterbrot.org>
In-Reply-To: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
References: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index e707b8d..d860d05 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -778,6 +778,33 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 	return 0;
 }
 
+static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
+					struct v4l2_frmsizeenum *f)
+{
+	if ((f->index != 0) || (f->pixel_format != V4L2_PIX_FMT_GREY))
+		return -EINVAL;
+
+	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	f->discrete.width  = sur40_video_format.width;
+	f->discrete.height = sur40_video_format.height;
+	return 0;
+}
+
+static int sur40_vidioc_enum_frameintervals(struct file *file, void *priv,
+					    struct v4l2_frmivalenum *f)
+{
+	if ((f->index > 1) || (f->pixel_format != V4L2_PIX_FMT_GREY)
+		|| (f->width  != sur40_video_format.width)
+		|| (f->height != sur40_video_format.height))
+			return -EINVAL;
+
+	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	f->discrete.denominator  = 60/(f->index+1);
+	f->discrete.numerator = 1;
+	return 0;
+}
+
+
 static const struct usb_device_id sur40_table[] = {
 	{ USB_DEVICE(ID_MICROSOFT, ID_SUR40) },  /* Samsung SUR40 */
 	{ }                                      /* terminating null entry */
@@ -829,6 +856,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap	= sur40_vidioc_fmt,
 	.vidioc_g_fmt_vid_cap	= sur40_vidioc_fmt,
 
+	.vidioc_enum_framesizes = sur40_vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = sur40_vidioc_enum_frameintervals,
+
 	.vidioc_enum_input	= sur40_vidioc_enum_input,
 	.vidioc_g_input		= sur40_vidioc_g_input,
 	.vidioc_s_input		= sur40_vidioc_s_input,
-- 
1.9.1

