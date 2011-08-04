Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1HDHOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:31 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 21/21] [staging] tm6000: Remove unnecessary workaround.
Date: Thu,  4 Aug 2011 09:14:19 +0200
Message-Id: <1312442059-23935-22-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implicitly setting the tuner frequency each time the device is opened
seems no longer necessary, so it is removed. This speeds up opening the
device by about 120 ms.

It also avoids excessive firmware reloads because the default will load
the BASE and F8MHZ type firmwares independent of which device, video or
radio, is opened. Before this patch opening the radio device would
automatically trigger a BASE and F8MHZ firmware load only to immediately
replace them by the FM firmware.
---
 drivers/staging/tm6000/tm6000-core.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 58c1399..7bb1d37 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -264,8 +264,6 @@ static void tm6000_set_vbi(struct tm6000_core *dev)
 
 int tm6000_init_analog_mode(struct tm6000_core *dev)
 {
-	struct v4l2_frequency f;
-
 	if (dev->dev_type == TM6010) {
 		u8 active = TM6010_REQ07_RCC_ACTIVE_IF_AUDIO_ENABLE;
 
@@ -304,24 +302,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		/* Disables soft reset */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
 	}
-	msleep(20);
-
-	/* Tuner firmware can now be loaded */
-
-	/*
-	 * FIXME: This is a hack! xc3028 "sleeps" when no channel is detected
-	 * for more than a few seconds. Not sure why, as this behavior does
-	 * not happen on other devices with xc3028. So, I suspect that it
-	 * is yet another bug at tm6000. After start sleeping, decoding
-	 * doesn't start automatically. Instead, it requires some
-	 * I2C commands to wake it up. As we want to have image at the
-	 * beginning, we needed to add this hack. The better would be to
-	 * discover some way to make tm6000 to wake up without this hack.
-	 */
-	f.frequency = dev->freq;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 
-	msleep(100);
 	tm6000_set_standard(dev);
 	tm6000_set_vbi(dev);
 	tm6000_set_audio_bitrate(dev, 48000);
-- 
1.7.6

