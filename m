Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 15/24] em28xx: check if a device has audio earlier
Date: Sat, 28 Dec 2013 10:16:07 -0200
Message-Id: <1388232976-20061-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Better to split chipset detection from the audio setup.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 11 +++++++++++
 drivers/media/usb/em28xx/em28xx-core.c  | 12 +-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index d1c75e66554c..4fe742429f2c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2930,6 +2930,16 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		}
 	}
 
+	if (dev->chip_id == CHIP_ID_EM2870 ||
+	    dev->chip_id == CHIP_ID_EM2874 ||
+	    dev->chip_id == CHIP_ID_EM28174 ||
+	    dev->chip_id == CHIP_ID_EM28178) {
+		/* Digital only device - don't load any alsa module */
+		dev->audio_mode.has_audio = false;
+		dev->has_audio_class = false;
+		dev->has_alsa_audio = false;
+	}
+
 	if (chip_name != default_chip_name)
 		printk(KERN_INFO DRIVER_NAME
 		       ": chip ID is %s\n", chip_name);
@@ -3196,6 +3206,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->alt   = -1;
 	dev->is_audio_only = has_audio && !(has_video || has_dvb);
 	dev->has_alsa_audio = has_audio;
+	dev->audio_mode.has_audio = has_audio;
 	dev->has_video = has_video;
 	dev->audio_ifnum = ifnum;
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 33cf26e106b5..818248d3fd28 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -505,18 +505,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 	int vid1, vid2, feat, cfg;
 	u32 vid;
 
-	if (dev->chip_id == CHIP_ID_EM2870 ||
-	    dev->chip_id == CHIP_ID_EM2874 ||
-	    dev->chip_id == CHIP_ID_EM28174 ||
-	    dev->chip_id == CHIP_ID_EM28178) {
-		/* Digital only device - don't load any alsa module */
-		dev->audio_mode.has_audio = false;
-		dev->has_audio_class = false;
-		dev->has_alsa_audio = false;
+	if (!dev->audio_mode.has_audio)
 		return 0;
-	}
-
-	dev->audio_mode.has_audio = true;
 
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
-- 
1.8.3.1

