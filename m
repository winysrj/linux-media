Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3179 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3DNP1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 28/30] cx25821: add output format ioctls.
Date: Sun, 14 Apr 2013 17:27:24 +0200
Message-Id: <1365953246-8972-29-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |   46 +++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index dca3391..70e33b1 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -851,6 +851,48 @@ static int cx25821_vidioc_s_output(struct file *file, void *priv, unsigned int o
 	return o ? -EINVAL : 0;
 }
 
+static int cx25821_vidioc_try_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_format *f)
+{
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
+	const struct cx25821_fmt *fmt;
+
+	fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
+	if (NULL == fmt)
+		return -EINVAL;
+	f->fmt.pix.width = 720;
+	f->fmt.pix.height = (dev->tvnorm & V4L2_STD_625_50) ? 576 : 480;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct cx25821_channel *chan = video_drvdata(file);
+	int err;
+
+	err = cx25821_vidioc_try_fmt_vid_out(file, priv, f);
+
+	if (0 != err)
+		return err;
+
+	chan->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
+	chan->vidq.field = f->fmt.pix.field;
+	chan->width = f->fmt.pix.width;
+	chan->height = f->fmt.pix.height;
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
+		chan->pixel_formats = PIXEL_FRMT_411;
+	else
+		chan->pixel_formats = PIXEL_FRMT_422;
+	return 0;
+}
+
 static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
 	.s_ctrl = cx25821_s_ctrl,
 };
@@ -905,6 +947,10 @@ static const struct v4l2_file_operations video_out_fops = {
 
 static const struct v4l2_ioctl_ops video_out_ioctl_ops = {
 	.vidioc_querycap = cx25821_vidioc_querycap,
+	.vidioc_enum_fmt_vid_out = cx25821_vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_out = cx25821_vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_out = cx25821_vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out = vidioc_s_fmt_vid_out,
 	.vidioc_g_std = cx25821_vidioc_g_std,
 	.vidioc_s_std = cx25821_vidioc_s_std,
 	.vidioc_enum_output = cx25821_vidioc_enum_output,
-- 
1.7.10.4

