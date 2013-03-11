Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4364 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3CKVBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 12/15] au0828: simplify i2c_gate_ctrl.
Date: Mon, 11 Mar 2013 22:00:43 +0100
Message-Id: <73e4d5617809d7ed66184533438acf61533af07f.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Turn it into a simple function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index a41e5ae..ac89b2c5 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -59,6 +59,12 @@ do {\
 	} \
   } while (0)
 
+static inline void i2c_gate_ctrl(struct au0828_dev *dev, int val)
+{
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, val);
+}
+
 static inline void print_err_status(struct au0828_dev *dev,
 				    int packet, int status)
 {
@@ -1320,8 +1326,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
-	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
-		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
+	i2c_gate_ctrl(dev, 1);
 
 	/* FIXME: when we support something other than NTSC, we are going to
 	   have to make the au0828 bridge adjust the size of its capture
@@ -1330,8 +1335,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, *norm);
 	dev->std_set_in_tuner_core = 1;
 
-	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
-		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+	i2c_gate_ctrl(dev, 0);
 	dev->std = *norm;
 
 	return 0;
@@ -1517,13 +1521,11 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
-		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
+	i2c_gate_ctrl(dev, 1);
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
 
-	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
-		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+	i2c_gate_ctrl(dev, 0);
 
 	dprintk(1, "VIDIOC_S_TUNER: signal = %x, afc = %x\n", t->signal,
 		t->afc);
@@ -1553,8 +1555,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (freq->tuner != 0)
 		return -EINVAL;
 
-	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
-		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
+	i2c_gate_ctrl(dev, 1);
 
 	if (dev->std_set_in_tuner_core == 0) {
 		/* If we've never sent the standard in tuner core, do so now.
@@ -1570,8 +1571,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, freq);
 	dev->ctrl_freq = freq->frequency;
 
-	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
-		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+	i2c_gate_ctrl(dev, 0);
 
 	au0828_analog_stream_reset(dev);
 
-- 
1.7.10.4

