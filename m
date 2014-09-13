Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37911 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaIMIu7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:50:59 -0400
Received: by mail-lb0-f181.google.com with SMTP id z11so2096998lbi.40
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 01:50:57 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/4] em28xx: remove some unnecessary fields from struct em28xx_audio_mode
Date: Sat, 13 Sep 2014 10:52:19 +0200
Message-Id: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fields "ac97_feat", "ac97_vendor_id" and "i2s_samplerates" of struct
em28xx_audio_mode are used nowhere, except in function em28xx_audio_setup().
So get rid of them and use local variables instead.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 14 ++++++--------
 drivers/media/usb/em28xx/em28xx.h      |  6 ------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 2f82e92..0fe05ff 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -505,6 +505,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 {
 	int vid1, vid2, feat, cfg;
 	u32 vid;
+	u8 i2s_samplerates;
 
 	if (dev->chip_id == CHIP_ID_EM2870 ||
 	    dev->chip_id == CHIP_ID_EM2874 ||
@@ -534,15 +535,15 @@ int em28xx_audio_setup(struct em28xx *dev)
 		if (dev->chip_id < CHIP_ID_EM2860 &&
 	            (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
 		    EM2820_CHIPCFG_I2S_1_SAMPRATE)
-			dev->audio_mode.i2s_samplerates = 1;
+			i2s_samplerates = 1;
 		else if (dev->chip_id >= CHIP_ID_EM2860 &&
 			 (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
 			 EM2860_CHIPCFG_I2S_5_SAMPRATES)
-			dev->audio_mode.i2s_samplerates = 5;
+			i2s_samplerates = 5;
 		else
-			dev->audio_mode.i2s_samplerates = 3;
+			i2s_samplerates = 3;
 		em28xx_info("I2S Audio (%d sample rate(s))\n",
-					       dev->audio_mode.i2s_samplerates);
+					       i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		goto init_audio;
@@ -569,15 +570,12 @@ int em28xx_audio_setup(struct em28xx *dev)
 		goto init_audio;
 
 	vid = vid1 << 16 | vid2;
-
-	dev->audio_mode.ac97_vendor_id = vid;
 	em28xx_warn("AC97 vendor ID = 0x%08x\n", vid);
 
 	feat = em28xx_read_ac97(dev, AC97_RESET);
 	if (feat < 0)
 		goto init_audio;
 
-	dev->audio_mode.ac97_feat = feat;
 	em28xx_warn("AC97 features = 0x%04x\n", feat);
 
 	/* Try to identify what audio processor we have */
@@ -597,7 +595,7 @@ init_audio:
 		break;
 	case EM28XX_AC97_SIGMATEL:
-		em28xx_info("Sigmatel audio processor detected(stac 97%02x)\n",
-			    dev->audio_mode.ac97_vendor_id & 0xff);
+		em28xx_info("Sigmatel audio processor detected (stac 97%02x)\n",
+			    vid & 0xff);
 		break;
 	case EM28XX_AC97_OTHER:
 		em28xx_warn("Unknown AC97 audio processor detected!\n");
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 84ef8ef..1f38163 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -309,13 +309,7 @@ enum em28xx_ac97_mode {
 
 struct em28xx_audio_mode {
 	enum em28xx_ac97_mode ac97;
-
-	u16 ac97_feat;
-	u32 ac97_vendor_id;
-
 	unsigned int has_audio:1;
-
-	u8 i2s_samplerates;
 };
 
 /* em28xx has two audio inputs: tuner and line in.
-- 
1.8.4.5

