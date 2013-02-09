Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2020 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3BIKBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/26] cx231xx: fix frequency clamping.
Date: Sat,  9 Feb 2013 11:00:37 +0100
Message-Id: <391080d7df2d6635e42485098a99d51ec787f21c.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Let the tuner clamp the frequency and store that clamped value.
This fixes a v4l2_compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 90f4510..36ec4bc 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1356,11 +1356,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (f->tuner)
 		return -EINVAL;
 
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->ctl_freq;
 
-	call_all(dev, tuner, g_frequency, f);
-
 	return 0;
 }
 
@@ -1383,16 +1380,12 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (0 != f->tuner)
 		return -EINVAL;
 
-	if (unlikely(0 == fh->radio && f->type != V4L2_TUNER_ANALOG_TV))
-		return -EINVAL;
-	if (unlikely(1 == fh->radio && f->type != V4L2_TUNER_RADIO))
-		return -EINVAL;
-
 	/* set pre channel change settings in DIF first */
 	rc = cx231xx_tuner_pre_channel_change(dev);
 
-	dev->ctl_freq = f->frequency;
 	call_all(dev, tuner, s_frequency, f);
+	call_all(dev, tuner, g_frequency, f);
+	dev->ctl_freq = f->frequency;
 
 	/* set post channel change settings in DIF first */
 	rc = cx231xx_tuner_post_channel_change(dev);
-- 
1.7.10.4

