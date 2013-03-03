Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:36587 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CCThJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:09 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so3369880eek.10
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:08 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 05/11] em28xx: fix eeprom data endianess
Date: Sun,  3 Mar 2013 20:37:38 +0100
Message-Id: <1362339464-3373-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The data is stored as little endian in the eeprom.
Hence the correct data types should be used and the data should be converted
to the machine endianess before using it.
The eeprom id (key) also isn't a 32 bit value but 4 separate bytes instead.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   22 ++++++++++++----------
 drivers/media/usb/em28xx/em28xx.h     |   12 ++++++------
 2 Dateien geändert, 18 Zeilen hinzugefügt(+), 16 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9612086..19f3e4f 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -434,19 +434,21 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 			printk("\n");
 	}
 
-	if (em_eeprom->id != 0x9567eb1a) {
+	if (em_eeprom->id[0] != 0x1a || em_eeprom->id[1] != 0xeb ||
+	    em_eeprom->id[2] != 0x67 || em_eeprom->id[3] != 0x95   ) {
 		em28xx_errdev("Unknown eeprom type or eeprom corrupted !");
 		return -ENODEV;
 	}
 
 	dev->hash = em28xx_hash_mem(eedata, len, 32);
 
-	em28xx_info("EEPROM ID = 0x%08x, EEPROM hash = 0x%08lx\n",
-		    em_eeprom->id, dev->hash);
+	em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
+		    em_eeprom->id[0], em_eeprom->id[1],
+		    em_eeprom->id[2], em_eeprom->id[3], dev->hash);
 
 	em28xx_info("EEPROM info:\n");
 
-	switch (em_eeprom->chip_conf >> 4 & 0x3) {
+	switch (le16_to_cpu(em_eeprom->chip_conf) >> 4 & 0x3) {
 	case 0:
 		em28xx_info("\tNo audio on board.\n");
 		break;
@@ -461,13 +463,13 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 		break;
 	}
 
-	if (em_eeprom->chip_conf & 1 << 3)
+	if (le16_to_cpu(em_eeprom->chip_conf) & 1 << 3)
 		em28xx_info("\tUSB Remote wakeup capable\n");
 
-	if (em_eeprom->chip_conf & 1 << 2)
+	if (le16_to_cpu(em_eeprom->chip_conf) & 1 << 2)
 		em28xx_info("\tUSB Self power capable\n");
 
-	switch (em_eeprom->chip_conf & 0x3) {
+	switch (le16_to_cpu(em_eeprom->chip_conf) & 0x3) {
 	case 0:
 		em28xx_info("\t500mA max power\n");
 		break;
@@ -483,9 +485,9 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 	}
 	em28xx_info("\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
 		    em_eeprom->string_idx_table,
-		    em_eeprom->string1,
-		    em_eeprom->string2,
-		    em_eeprom->string3);
+		    le16_to_cpu(em_eeprom->string1),
+		    le16_to_cpu(em_eeprom->string2),
+		    le16_to_cpu(em_eeprom->string3));
 
 	return 0;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 4160a2a..90266a1 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -405,15 +405,15 @@ struct em28xx_board {
 };
 
 struct em28xx_eeprom {
-	u32 id;			/* 0x9567eb1a */
-	u16 vendor_ID;
-	u16 product_ID;
+	u8 id[4];			/* 1a eb 67 95 */
+	__le16 vendor_ID;
+	__le16 product_ID;
 
-	u16 chip_conf;
+	__le16 chip_conf;
 
-	u16 board_conf;
+	__le16 board_conf;
 
-	u16 string1, string2, string3;
+	__le16 string1, string2, string3;
 
 	u8 string_idx_table;
 };
-- 
1.7.10.4

