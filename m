Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:38954 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaIMIzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:55:25 -0400
Received: by mail-la0-f46.google.com with SMTP id el20so2229632lab.19
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 01:55:24 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: remove dead code line from em28xx_audio_setup()
Date: Sat, 13 Sep 2014 10:56:46 +0200
Message-Id: <1410598606-889-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting the value of the chip config register to EM28XX_CHIPCFG_AC97 in case of
a read error is a leftover from the past which is no longer needed.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 91ea3e4..bfe0726 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -516,9 +516,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 	/* See how this device is configured */
 	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
 	em28xx_info("Config register raw data: 0x%02x\n", cfg);
-	if (cfg < 0) {
-		/* Register read error?  */
-		cfg = EM28XX_CHIPCFG_AC97; /* Be conservative */
+	if (cfg < 0) { /* Register read error */
+		/* Be conservative */
 		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) == 0x00) {
 		/* The device doesn't have vendor audio at all */
-- 
1.8.4.5

