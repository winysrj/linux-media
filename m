Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35435 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1LONzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 08:55:50 -0500
Received: by wgbds13 with SMTP id ds13so1164737wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 05:55:49 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: tvp5150: Add mbus_fmt callbacks.
Date: Thu, 15 Dec 2011 14:48:45 +0100
Message-Id: <1323956925-2984-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These callbacks allow a host video driver
to poll video formats supported by tvp5150.

---
Changes since v1:
 Fix standard handling in tvp5150_mbus_fmt()

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/tvp5150.c |   67 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 26cc75b..c58c8d5 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -778,6 +778,70 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
+static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
+{
+	int val = tvp5150_read(sd, TVP5150_STATUS_REG_5);
+
+	switch (val & 0x0F) {
+	case 0x01:
+		return V4L2_STD_NTSC;
+	case 0x03:
+		return V4L2_STD_PAL;
+	case 0x05:
+		return V4L2_STD_PAL_M;
+	case 0x07:
+		return V4L2_STD_PAL_N | V4L2_STD_PAL_Nc;
+	case 0x09:
+		return V4L2_STD_NTSC_443;
+	case 0xb:
+		return V4L2_STD_SECAM;
+	default:
+		return V4L2_STD_UNKNOWN;
+	}
+}
+
+static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
+						enum v4l2_mbus_pixelcode *code)
+{
+	if (index)
+		return -EINVAL;
+
+	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+	return 0;
+}
+
+static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_mbus_framefmt *f)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
+	if (f == NULL)
+		return -EINVAL;
+
+	tvp5150_reset(sd, 0);
+
+	/* Calculate height and width based on current standard */
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	f->width = 720;
+	if (std & V4L2_STD_525_60)
+		f->height = 480;
+	else
+		f->height = 576;
+
+	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	f->field = V4L2_FIELD_SEQ_TB;
+	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
+			f->height);
+	return 0;
+}
+
 /****************************************************************************
 			I2C Command
  ****************************************************************************/
@@ -930,6 +994,9 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_routing = tvp5150_s_routing,
+	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
+	.s_mbus_fmt = tvp5150_mbus_fmt,
+	.try_mbus_fmt = tvp5150_mbus_fmt,
 };
 
 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
-- 
1.7.0.4

