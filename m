Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab2HGCrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:55 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:55 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 09/24] au0828: make sure video standard is setup in tuner-core
Date: Mon,  6 Aug 2012 22:46:59 -0400
Message-Id: <1344307634-11673-10-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the user performs a tuning attempt without explicitly calling the s_std
ioctl(), a value of zero is sent from tuner-core to xc5000.  This causes
the xc5000 driver to leave the standard unchanged.  The problem was masked
by the fact that the xc5000 driver defaulted to NTSC, but if you happened to
perform an ATSC/ClearQAM tuning attempt and then do an analog tune, the net
effect is an analog tune with the standard still set to DTV6.

Keep track of whether the standard has ever been sent to tuner-core.  We
don't make an s_std subdev call explicitly during probe because that will
cause a firmware load (which is very time consuming on the 950q).  With the
logic in this patch, the s_std call will occur automatically on the s_freq
call if it hasn't already been set.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-video.c |   10 ++++++++++
 drivers/media/video/au0828/au0828.h       |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index b1f8d18..f3e6e3f 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1330,6 +1330,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id * norm)
 	   buffer, which is currently hardcoded at 720x480 */
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, *norm);
+	dev->std_set_in_tuner_core = 1;
 	return 0;
 }
 
@@ -1540,6 +1541,15 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	dev->ctrl_freq = freq->frequency;
 
+	if (dev->std_set_in_tuner_core == 0) {
+	  /* If we've never sent the standard in tuner core, do so now.  We
+	     don't do this at device probe because we don't want to incur
+	     the cost of a firmware load */
+	  v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
+			       dev->vdev->tvnorms);
+	  dev->std_set_in_tuner_core = 1;
+	}
+
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, freq);
 
 	au0828_analog_stream_reset(dev);
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/video/au0828/au0828.h
index 61cd63e..66a56ef 100644
--- a/drivers/media/video/au0828/au0828.h
+++ b/drivers/media/video/au0828/au0828.h
@@ -225,6 +225,7 @@ struct au0828_dev {
 	unsigned int frame_count;
 	int ctrl_freq;
 	int input_type;
+	int std_set_in_tuner_core;
 	unsigned int ctrl_input;
 	enum au0828_dev_state dev_state;
 	enum au0828_stream_state stream_state;
-- 
1.7.1

