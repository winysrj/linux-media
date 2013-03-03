Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41139 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3CCThI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:08 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so3529951eek.28
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:07 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 04/11] em28xx: do not interpret eeprom content if eeprom key is invalid
Date: Sun,  3 Mar 2013 20:37:37 +0100
Message-Id: <1362339464-3373-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the eeprom key isn't valid, either a different (currently unknown) format
is used or the eeprom is corrupted.
In both cases it doesn't make sense to interpret the data.
Also print an error message.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |    8 ++++++--
 1 Datei geändert, 6 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index d765567..9612086 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -434,8 +434,12 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 			printk("\n");
 	}
 
-	if (em_eeprom->id == 0x9567eb1a)
-		dev->hash = em28xx_hash_mem(eedata, len, 32);
+	if (em_eeprom->id != 0x9567eb1a) {
+		em28xx_errdev("Unknown eeprom type or eeprom corrupted !");
+		return -ENODEV;
+	}
+
+	dev->hash = em28xx_hash_mem(eedata, len, 32);
 
 	em28xx_info("EEPROM ID = 0x%08x, EEPROM hash = 0x%08lx\n",
 		    em_eeprom->id, dev->hash);
-- 
1.7.10.4

