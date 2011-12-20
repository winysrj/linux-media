Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57571 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1LTVp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 16:45:26 -0500
Received: by werm1 with SMTP id m1so2291560wer.19
        for <linux-media@vger.kernel.org>; Tue, 20 Dec 2011 13:45:25 -0800 (PST)
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] Fixed detection of EMP202 audio chip. Some versions have an id of 0x83847650 instead of 0xffffffff.
Date: Tue, 20 Dec 2011 21:45:18 +0000
Message-ID: <3535794.dt3qgLM7n9@kubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gareth Williams <gareth@garethwilliams.me.uk>

Honestech Vidbox NW03 has a EMP202 audio chip with a different Vendor ID.

Apparently, it is the same with the Gadmei ITV380:
http://linuxtv.org/wiki/index.php/Gadmei_USB_TVBox_UTV380

---
 linux/drivers/media/video/em28xx/em28xx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/linux/drivers/media/video/em28xx/em28xx-core.c b/linux/drivers/media/video/em28xx/em28xx-core.c
index 804a4ab..2982a06 100644
--- a/linux/drivers/media/video/em28xx/em28xx-core.c
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c
@@ -568,7 +568,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 	em28xx_warn("AC97 features = 0x%04x\n", feat);
 
 	/* Try to identify what audio processor we have */
-	if ((vid == 0xffffffff) && (feat == 0x6a90))
+	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
 		dev->audio_mode.ac97 = EM28XX_AC97_EM202;
 	else if ((vid >> 8) == 0x838476)
 		dev->audio_mode.ac97 = EM28XX_AC97_SIGMATEL;
-- 

