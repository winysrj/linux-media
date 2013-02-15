Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4233 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161386Ab3BOMzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/10] au0828: fix intendation coding style issue.
Date: Fri, 15 Feb 2013 13:55:07 +0100
Message-Id: <7ed0f341c5106b0280624d1861d9db13f88da9f1.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No code change, just fixing a wrong indentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 25b18d397..e3d8a3c 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1561,12 +1561,12 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
 
 	if (dev->std_set_in_tuner_core == 0) {
-	  /* If we've never sent the standard in tuner core, do so now.  We
-	     don't do this at device probe because we don't want to incur
-	     the cost of a firmware load */
-	  v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
-			       dev->vdev->tvnorms);
-	  dev->std_set_in_tuner_core = 1;
+		/* If we've never sent the standard in tuner core, do so now.
+		   We don't do this at device probe because we don't want to
+		   incur the cost of a firmware load */
+		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
+				     dev->vdev->tvnorms);
+		dev->std_set_in_tuner_core = 1;
 	}
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, freq);
-- 
1.7.10.4

