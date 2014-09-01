Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:59609 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaIAUWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 16:22:41 -0400
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: oravecz@nytud.mta.hu, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH for 3.17] Revert "[media] em28xx: check if a device has audio earlier"
Date: Mon,  1 Sep 2014 22:23:59 +0200
Message-Id: <1409603039-15774-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts

commit b99f0aadd33fad269c8e62b5bec8b5c012a44a56
Author: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date:   Fri Dec 27 00:16:13 2013 -0300

    [media] em28xx: check if a device has audio earlier

    Better to split chipset detection from the audio setup. So, move the
    detection code to em28xx_init_dev().

It broke analog audio of the Hauppauge winTV HVR 900 and very likely many other 
em28xx devices.


Background:
The local variable has_audio in em28xx_usb_probe() describes if the currently 
probed _usb_interface_ has an audio endpoint, while dev->audio_mode.has_audio 
means that the _device_ as a whole provides analog audio.
Hence it is wrong to set dev->audio_mode.has_audio = has_audio in em28xx_usb_probe().
As result, audio support is no longer detected and configured on devices which 
have the audio endpoint on a separate interface, because em28xx_audio_setup() 
bails out immediately at the beginning.


Revert the faulty commit to restore the old audio detection procedure, which checks 
the chip configuration register to determine if the device has analog audio.

Cc: <stable@vger.kernel.org>	# 3.14 to 3.16
Reported-by: Oravecz Csaba <oravecz@nytud.mta.hu>
Tested-by: Oravecz Csaba <oravecz@nytud.mta.hu>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 11 -----------
 drivers/media/usb/em28xx/em28xx-core.c  | 12 +++++++++++-
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a7e24848..912ea1b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3098,16 +3098,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		}
 	}
 
-	if (dev->chip_id == CHIP_ID_EM2870 ||
-	    dev->chip_id == CHIP_ID_EM2874 ||
-	    dev->chip_id == CHIP_ID_EM28174 ||
-	    dev->chip_id == CHIP_ID_EM28178) {
-		/* Digital only device - don't load any alsa module */
-		dev->audio_mode.has_audio = false;
-		dev->has_audio_class = false;
-		dev->has_alsa_audio = false;
-	}
-
 	if (chip_name != default_chip_name)
 		printk(KERN_INFO DRIVER_NAME
 		       ": chip ID is %s\n", chip_name);
@@ -3377,7 +3367,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->alt   = -1;
 	dev->is_audio_only = has_audio && !(has_video || has_dvb);
 	dev->has_alsa_audio = has_audio;
-	dev->audio_mode.has_audio = has_audio;
 	dev->has_video = has_video;
 	dev->ifnum = ifnum;
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 523d7e9..0f6caa4 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -506,8 +506,18 @@ int em28xx_audio_setup(struct em28xx *dev)
 	int vid1, vid2, feat, cfg;
 	u32 vid;
 
-	if (!dev->audio_mode.has_audio)
+	if (dev->chip_id == CHIP_ID_EM2870 ||
+	    dev->chip_id == CHIP_ID_EM2874 ||
+	    dev->chip_id == CHIP_ID_EM28174 ||
+	    dev->chip_id == CHIP_ID_EM28178) {
+		/* Digital only device - don't load any alsa module */
+		dev->audio_mode.has_audio = false;
+		dev->has_audio_class = false;
+		dev->has_alsa_audio = false;
 		return 0;
+	}
+
+	dev->audio_mode.has_audio = true;
 
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
-- 
1.8.4.5

