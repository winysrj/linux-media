Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40279 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaIMIvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:51:01 -0400
Received: by mail-lb0-f172.google.com with SMTP id w7so2131098lbi.31
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 01:50:59 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/4] em28xx: get rid of field has_audio in struct em28xx_audio_mode
Date: Sat, 13 Sep 2014 10:52:21 +0200
Message-Id: <1410598342-31094-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Field has_audio in struct em28xx_audio_mode is used together with value
EM28XX_NO_AC97 of field ac97 to determine the internal type of audio (none/i2s/ac97).
This makes the code difficult to understand:

  !dev->audio_mode.has_audio && audio_mode.ac97 == EM28XX_NO_AC97	=> no audio
  !dev->audio_mode.has_audio && audio_mode.ac97 != EM28XX_NO_AC97	=> BUG
  dev->audio_mode.has_audio && dev->audio_mode.ac97 == EM28XX_NO_AC97	=> AC97 audio
  dev->audio_mode.has_audio && dev->audio_mode.ac97 != EM28XX_NO_AC97	=> I2S audio

Simplify the whole thing by introducing an enum em28xx_int_audio_type which
describes the internal audio type (none, ac97, i2s) and is hooked directly to
the device struct.
Then get rid of field has_audio in struct em28xx_audio_mode.

A follow-up patch will then remove struct em28xx_ac97_mode and finally the
whole struct em28xx_audio_mode.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c  | 14 ++++++++------
 drivers/media/usb/em28xx/em28xx-video.c |  6 +++---
 drivers/media/usb/em28xx/em28xx.h       |  8 +++++++-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 16747ca..ed83e4e 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -433,7 +433,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
 	int ret, i;
 	u8 xclk;
 
-	if (!dev->audio_mode.has_audio)
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_NONE)
 		return 0;
 
 	/* It is assumed that all devices use master volume for output.
@@ -512,25 +512,25 @@ int em28xx_audio_setup(struct em28xx *dev)
 	    dev->chip_id == CHIP_ID_EM28174 ||
 	    dev->chip_id == CHIP_ID_EM28178) {
 		/* Digital only device - don't load any alsa module */
-		dev->audio_mode.has_audio = false;
+		dev->int_audio_type = EM28XX_INT_AUDIO_NONE;
 		dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
 		return 0;
 	}
 
-	dev->audio_mode.has_audio = true;
-
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
 	em28xx_info("Config register raw data: 0x%02x\n", cfg);
 	if (cfg < 0) {
 		/* Register read error?  */
 		cfg = EM28XX_CHIPCFG_AC97; /* Be conservative */
+		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) == 0x00) {
 		/* The device doesn't have vendor audio at all */
-		dev->audio_mode.has_audio = false;
+		dev->int_audio_type = EM28XX_INT_AUDIO_NONE;
 		dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
 		return 0;
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
+		dev->int_audio_type = EM28XX_INT_AUDIO_I2S;
 		if (dev->chip_id < CHIP_ID_EM2860 &&
 	            (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
 		    EM2820_CHIPCFG_I2S_1_SAMPRATE)
@@ -546,6 +546,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 		/* Skip the code that does AC97 vendor detection */
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		goto init_audio;
+	} else {
+		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
 	}
 
 	dev->audio_mode.ac97 = EM28XX_AC97_OTHER;
@@ -561,7 +563,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
 		if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
 			dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
-		dev->audio_mode.has_audio = false;
+		dev->int_audio_type = EM28XX_INT_AUDIO_NONE;
 		goto init_audio;
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3642438..3284de9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1720,7 +1720,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	else
 		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
 
-	if (dev->audio_mode.has_audio)
+	if (dev->int_audio_type != EM28XX_INT_AUDIO_NONE)
 		cap->device_caps |= V4L2_CAP_AUDIO;
 
 	if (dev->tuner_type != TUNER_ABSENT)
@@ -2514,7 +2514,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_FREQUENCY);
 		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_FREQUENCY);
 	}
-	if (!dev->audio_mode.has_audio) {
+	if (dev->int_audio_type == EM28XX_INT_AUDIO_NONE) {
 		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_G_AUDIO);
 		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_AUDIO);
 	}
@@ -2544,7 +2544,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_FREQUENCY);
 			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_FREQUENCY);
 		}
-		if (!dev->audio_mode.has_audio) {
+		if (dev->int_audio_type == EM28XX_INT_AUDIO_NONE) {
 			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_AUDIO);
 			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_AUDIO);
 		}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 3fd176f..857ad0c 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -309,7 +309,12 @@ enum em28xx_ac97_mode {
 
 struct em28xx_audio_mode {
 	enum em28xx_ac97_mode ac97;
-	unsigned int has_audio:1;
+};
+
+enum em28xx_int_audio_type {
+	EM28XX_INT_AUDIO_NONE = 0,
+	EM28XX_INT_AUDIO_AC97,
+	EM28XX_INT_AUDIO_I2S,
 };
 
 enum em28xx_usb_audio_type {
@@ -608,6 +613,7 @@ struct em28xx {
 	unsigned char disconnected:1;	/* device has been diconnected */
 	unsigned int has_video:1;
 	unsigned int is_audio_only:1;
+	enum em28xx_int_audio_type int_audio_type;
 	enum em28xx_usb_audio_type usb_audio_type;
 
 	struct em28xx_board board;
-- 
1.8.4.5

