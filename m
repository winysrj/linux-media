Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2HGCsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:10 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:09 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 22/24] au0828: fix a couple of missed edge cases for i2c gate with analog
Date: Mon,  6 Aug 2012 22:47:12 -0400
Message-Id: <1344307634-11673-23-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch addresses a couple of cases where I forgot to pop open the gate
when in analog mode (a correlary to fix the change made in patch
1c58d5b4a5fca42dce5428bd79b9405878017735).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-video.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 4d5b670..fa0fa9a 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1325,12 +1325,19 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
+
 	/* FIXME: when we support something other than NTSC, we are going to
 	   have to make the au0828 bridge adjust the size of its capture
 	   buffer, which is currently hardcoded at 720x480 */
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, *norm);
 	dev->std_set_in_tuner_core = 1;
+
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+
 	return 0;
 }
 
@@ -1510,9 +1517,18 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	t->type = V4L2_TUNER_ANALOG_TV;
+
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
+
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
+
+	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
+		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 0);
+
 	dprintk(1, "VIDIOC_S_TUNER: signal = %x, afc = %x\n", t->signal,
 		t->afc);
+
 	return 0;
 
 }
-- 
1.7.1

