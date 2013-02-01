Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39062 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab3BAXCO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Feb 2013 18:02:14 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 4/8] saa7134: v4l2-compliance: return real frequency
Date: Sat,  2 Feb 2013 00:01:17 +0100
Message-Id: <1359759681-27549-5-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359759681-27549-1-git-send-email-linux@rainbow-software.org>
References: <1359759681-27549-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: don't cache frequency in
s_frequency/g_frequency but return real one instead

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    6 ++++--
 drivers/media/pci/saa7134/saa7134.h       |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index cd4959e..c8d3180 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2051,8 +2051,11 @@ static int saa7134_g_frequency(struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 
+	if (0 != f->tuner)
+		return -EINVAL;
+
 	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	f->frequency = dev->ctl_freq;
+	saa_call_all(dev, tuner, g_frequency, f);
 
 	return 0;
 }
@@ -2070,7 +2073,6 @@ static int saa7134_s_frequency(struct file *file, void *priv,
 	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
 		return -EINVAL;
 	mutex_lock(&dev->lock);
-	dev->ctl_freq = f->frequency;
 
 	saa_call_all(dev, tuner, s_frequency, f);
 
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 2ffe069..d0ee05e 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -604,7 +604,6 @@ struct saa7134_dev {
 	int                        ctl_contrast;
 	int                        ctl_hue;
 	int                        ctl_saturation;
-	int                        ctl_freq;
 	int                        ctl_mute;             /* audio */
 	int                        ctl_volume;
 	int                        ctl_invert;           /* private */
-- 
Ondrej Zary

