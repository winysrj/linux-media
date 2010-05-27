Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41822
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab0E0Qku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:50 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 3/8] dsbr100: only change frequency upon success
Date: Thu, 27 May 2010 12:39:11 -0400
Message-Id: <1274978356-25836-4-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 2f96e13..b62fe40 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -259,11 +259,12 @@ usb_control_msg_failed:
 }
 
 /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
-static int dsbr100_setfreq(struct dsbr100_device *radio)
+static int dsbr100_setfreq(struct dsbr100_device *radio, int freq)
 {
 	int retval;
 	int request;
-	int freq = (radio->curfreq / 16 * 80) / 1000 + 856;
+
+	freq = (freq / 16 * 80) / 1000 + 856;
 
 	BUG_ON(!mutex_is_locked(&radio->lock));
 
@@ -302,6 +303,7 @@ static int dsbr100_setfreq(struct dsbr100_device *radio)
 	}
 
 	radio->stereo = !((radio->transfer_buffer)[0] & 0x01);
+	radio->curfreq = freq;
 	return (radio->transfer_buffer)[0];
 
 usb_control_msg_failed:
@@ -408,11 +410,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
-	int retval;
-
-	radio->curfreq = f->frequency;
+	int retval = dsbr100_setfreq(radio, f->frequency);
 
-	retval = dsbr100_setfreq(radio);
 	if (retval < 0)
 		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
 
-- 
1.7.1

