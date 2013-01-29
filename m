Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4974 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3A2Qdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 05/20] cx231xx: fix tuner compliance issues.
Date: Tue, 29 Jan 2013 17:32:58 +0100
Message-Id: <9cbe29bfa004c46ce938ee7a2b3334987048140d.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
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
index f043776..b7dcfc1 100644
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

