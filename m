Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65228 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaIMIvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:51:02 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so2114426lbv.10
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 01:51:00 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/4] em28xx: get rid of structs em28xx_ac97_mode and em28xx_audio_mode
Date: Sat, 13 Sep 2014 10:52:22 +0200
Message-Id: <1410598342-31094-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have enum em28xx_int_audio (none/i2s/ac97), it is no longer
necessary to check dev->audio_mode.ac97 to determine the type of internal audio connection.
There is also no need to save the type of the detected AC97 chip.

So replce the remaining checks of dev->audio_mode.ac97 with equivalent checks
of dev->int_audio_type and get rid of struct em28xx_ac97_mode and finally the
whole struct em28xx_audio_mode.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |  2 +-
 drivers/media/usb/em28xx/em28xx-core.c  | 36 ++++++---------------------------
 drivers/media/usb/em28xx/em28xx-video.c |  2 +-
 drivers/media/usb/em28xx/em28xx.h       | 13 ------------
 4 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 90c7a83..c3a4224 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -933,7 +933,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	INIT_WORK(&adev->wq_trigger, audio_trigger);
 
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_AC97) {
 		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO);
 		em28xx_cvol_new(card, dev, "Line In", AC97_LINE);
 		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE);
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index ed83e4e..7464e70 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -405,12 +405,8 @@ static int em28xx_set_audio_source(struct em28xx *dev)
 		return ret;
 	msleep(5);
 
-	switch (dev->audio_mode.ac97) {
-	case EM28XX_NO_AC97:
-		break;
-	default:
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_AC97)
 		ret = set_ac97_input(dev);
-	}
 
 	return ret;
 }
@@ -439,7 +435,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	/* It is assumed that all devices use master volume for output.
 	   It would be possible to use also line output.
 	 */
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_AC97) {
 		/* Mute all outputs */
 		for (i = 0; i < ARRAY_SIZE(outputs); i++) {
 			ret = em28xx_write_ac97(dev, outputs[i].reg, 0x8000);
@@ -462,7 +458,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	ret = em28xx_set_audio_source(dev);
 
 	/* Sets volume */
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_AC97) {
 		int vol;
 
 		em28xx_write_ac97(dev, AC97_POWERDOWN, 0x4200);
@@ -544,14 +540,11 @@ int em28xx_audio_setup(struct em28xx *dev)
 		em28xx_info("I2S Audio (%d sample rate(s))\n",
 					       i2s_samplerates);
 		/* Skip the code that does AC97 vendor detection */
-		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		goto init_audio;
 	} else {
 		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
 	}
 
-	dev->audio_mode.ac97 = EM28XX_AC97_OTHER;
-
 	vid1 = em28xx_read_ac97(dev, AC97_VENDOR_ID1);
 	if (vid1 < 0) {
 		/*
@@ -560,7 +553,6 @@ int em28xx_audio_setup(struct em28xx *dev)
 		 *	 CHIPCFG register, even not having an AC97 chip
 		 */
 		em28xx_warn("AC97 chip type couldn't be determined\n");
-		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
 			dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
 		dev->int_audio_type = EM28XX_INT_AUDIO_NONE;
@@ -582,30 +574,14 @@ int em28xx_audio_setup(struct em28xx *dev)
 
 	/* Try to identify what audio processor we have */
 	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
-		dev->audio_mode.ac97 = EM28XX_AC97_EM202;
-	else if ((vid >> 8) == 0x838476)
-		dev->audio_mode.ac97 = EM28XX_AC97_SIGMATEL;
-
-init_audio:
-	/* Reports detected AC97 processor */
-	switch (dev->audio_mode.ac97) {
-	case EM28XX_NO_AC97:
-		em28xx_info("No AC97 audio processor\n");
-		break;
-	case EM28XX_AC97_EM202:
 		em28xx_info("Empia 202 AC97 audio processor detected\n");
-		break;
-	case EM28XX_AC97_SIGMATEL:
+	else if ((vid >> 8) == 0x838476)
 		em28xx_info("Sigmatel audio processor detected (stac 97%02x)\n",
 			    vid & 0xff);
-		break;
-	case EM28XX_AC97_OTHER:
+	else
 		em28xx_warn("Unknown AC97 audio processor detected!\n");
-		break;
-	default:
-		break;
-	}
 
+init_audio:
 	return em28xx_audio_analog_set(dev);
 }
 EXPORT_SYMBOL_GPL(em28xx_audio_setup);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3284de9..c4e1364 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2384,7 +2384,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			__func__, ret);
 		goto unregister_dev;
 	}
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_AC97) {
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 857ad0c..3108eee 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -300,17 +300,6 @@ enum enum28xx_itype {
 	EM28XX_RADIO,
 };
 
-enum em28xx_ac97_mode {
-	EM28XX_NO_AC97 = 0,
-	EM28XX_AC97_EM202,
-	EM28XX_AC97_SIGMATEL,
-	EM28XX_AC97_OTHER,
-};
-
-struct em28xx_audio_mode {
-	enum em28xx_ac97_mode ac97;
-};
-
 enum em28xx_int_audio_type {
 	EM28XX_INT_AUDIO_NONE = 0,
 	EM28XX_INT_AUDIO_AC97,
@@ -627,8 +616,6 @@ struct em28xx {
 
 	u32 i2s_speed;		/* I2S speed for audio digital stream */
 
-	struct em28xx_audio_mode audio_mode;
-
 	int tuner_type;		/* type of the tuner */
 
 	/* i2c i/o */
-- 
1.8.4.5

