Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4396 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab3BOMzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/10] au0828: frequency handling fixes.
Date: Fri, 15 Feb 2013 13:55:06 +0100
Message-Id: <2c2948ff61238ff50b99dfa357bb95b6bd0b77cc.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- define an initial frequency
- return an error if g_frequency is called for an invalid tuner index
- get the clamped frequency value after setting it: i.e. the tuner driver
  may clamp the given frequency to a valid frequency range and ctrl_freq
  should get that actual clamped frequency.
- remove obsolete tuner type checks (done by the core).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 4254b2c..25b18d397 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1521,8 +1521,6 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	t->type = V4L2_TUNER_ANALOG_TV;
-
 	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
 		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
 
@@ -1544,7 +1542,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
-	freq->type = V4L2_TUNER_ANALOG_TV;
+	if (freq->tuner != 0)
+		return -EINVAL;
 	freq->frequency = dev->ctrl_freq;
 	return 0;
 }
@@ -1557,10 +1556,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	if (freq->tuner != 0)
 		return -EINVAL;
-	if (freq->type != V4L2_TUNER_ANALOG_TV)
-		return -EINVAL;
-
-	dev->ctrl_freq = freq->frequency;
 
 	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
 		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
@@ -1575,6 +1570,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	}
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, freq);
+	/* Get the actual set (and possibly clamped) frequency */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, freq);
+	dev->ctrl_freq = freq->frequency;
 
 	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
 		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
@@ -1978,6 +1976,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->frame_size = dev->field_size << 1;
 	dev->bytesperline = dev->width << 1;
 	dev->ctrl_ainput = 0;
+	dev->ctrl_freq = 960;
 
 	/* allocate and fill v4l2 video struct */
 	dev->vdev = video_device_alloc();
-- 
1.7.10.4

