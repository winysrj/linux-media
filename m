Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3166 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3CKVBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/15] au0828: fix intendation coding style issue.
Date: Mon, 11 Mar 2013 22:00:35 +0100
Message-Id: <32d23b2d3624420dc13f560195d5f5bde7763f5a.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
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

