Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1057 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3BIKBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/26] cx231xx: fix tuner compliance issues.
Date: Sat,  9 Feb 2013 11:00:35 +0100
Message-Id: <832806a4f8564a8e74b5a7dfee2d7a5fc9841b2f.1360403309.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The g_tuner call wasn't passed on to the subdevices, g_frequency didn't
check for invalid tuners and a low-level function that was expected to
return 0 or a negative error returned a positive number instead, causing
s_frequency to return bogus errors.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 7222079..4706ed3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2133,7 +2133,7 @@ int cx231xx_tuner_post_channel_change(struct cx231xx *dev)
 
 	status = vid_blk_write_word(dev, DIF_AGC_IF_REF, dwval);
 
-	return status;
+	return status == sizeof(dwval) ? 0 : -EIO;
 }
 
 /******************************************************************************
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index f4243c6..8e0703c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1322,6 +1322,7 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh = 0xffffffffUL;
 	t->signal = 0xffff;	/* LOCKED */
+	call_all(dev, tuner, g_tuner, t);
 
 	return 0;
 }
@@ -1350,6 +1351,9 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
+	if (f->tuner)
+		return -EINVAL;
+
 	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->ctl_freq;
 
-- 
1.7.10.4

