Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4295 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3CKVBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/15] au0828: replace deprecated current_norm by g_std.
Date: Mon, 11 Mar 2013 22:00:40 +0100
Message-Id: <0f95ef379eeae847771cde36fb6d591d69c88513.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   15 +++++++++++++--
 drivers/media/usb/au0828/au0828.h       |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 3c3e4d6..62308fe 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1322,7 +1322,7 @@ out:
 	return rc;
 }
 
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
@@ -1339,10 +1339,20 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
 
 	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
 		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+	dev->std = *norm;
 
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct au0828_fh *fh = priv;
+	struct au0828_dev *dev = fh->dev;
+
+	*norm = dev->std;
+	return 0;
+}
+
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *input)
 {
@@ -1889,6 +1899,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_qbuf                = vidioc_qbuf,
 	.vidioc_dqbuf               = vidioc_dqbuf,
 	.vidioc_s_std               = vidioc_s_std,
+	.vidioc_g_std               = vidioc_g_std,
 	.vidioc_enum_input          = vidioc_enum_input,
 	.vidioc_g_input             = vidioc_g_input,
 	.vidioc_s_input             = vidioc_s_input,
@@ -1913,7 +1924,6 @@ static const struct video_device au0828_video_template = {
 	.release                    = video_device_release,
 	.ioctl_ops 		    = &video_ioctl_ops,
 	.tvnorms                    = V4L2_STD_NTSC_M,
-	.current_norm               = V4L2_STD_NTSC_M,
 };
 
 /**************************************************************************/
@@ -1982,6 +1992,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->bytesperline = dev->width << 1;
 	dev->ctrl_ainput = 0;
 	dev->ctrl_freq = 960;
+	dev->std = V4L2_STD_NTSC_M;
 
 	/* allocate and fill v4l2 video struct */
 	dev->vdev = video_device_alloc();
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index ad40048..ef1f57f 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -222,6 +222,7 @@ struct au0828_dev {
 	int vbi_width;
 	int vbi_height;
 	u32 vbi_read;
+	v4l2_std_id std;
 	u32 field_size;
 	u32 frame_size;
 	u32 bytesperline;
-- 
1.7.10.4

