Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2336 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161452Ab3BOMze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/10] au0828: replace deprecated current_norm by g_std.
Date: Fri, 15 Feb 2013 13:55:12 +0100
Message-Id: <4f7455a49b7443c8cdb325f571591e1c81dea6be.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   15 +++++++++++++--
 drivers/media/usb/au0828/au0828.h       |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 17635e5..cb7418e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1323,7 +1323,7 @@ out:
 	return rc;
 }
 
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
@@ -1340,10 +1340,20 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
 
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
@@ -1890,6 +1900,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_qbuf                = vidioc_qbuf,
 	.vidioc_dqbuf               = vidioc_dqbuf,
 	.vidioc_s_std               = vidioc_s_std,
+	.vidioc_g_std               = vidioc_g_std,
 	.vidioc_enum_input          = vidioc_enum_input,
 	.vidioc_g_input             = vidioc_g_input,
 	.vidioc_s_input             = vidioc_s_input,
@@ -1914,7 +1925,6 @@ static const struct video_device au0828_video_template = {
 	.release                    = video_device_release,
 	.ioctl_ops 		    = &video_ioctl_ops,
 	.tvnorms                    = V4L2_STD_NTSC_M,
-	.current_norm               = V4L2_STD_NTSC_M,
 };
 
 /**************************************************************************/
@@ -1983,6 +1993,7 @@ int au0828_analog_register(struct au0828_dev *dev,
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

