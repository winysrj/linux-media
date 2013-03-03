Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44774 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CCThT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:19 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so669023eaa.3
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:17 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 10/11] em28xx: extract the device configuration dataset from eeproms with 16 bit address width
Date: Sun,  3 Mar 2013 20:37:43 +0100
Message-Id: <1362339464-3373-11-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new eeproms with 16 address width still have the the device config dataset
(the content of the old 8 bit eeproms) embedded.
Hauppauge also continues to include the tveeprom data structure inside this
dataset in their devices.
The start address of the dataset depends on the start address of the microcode
and a variable additional offset.

It should be mentioned that Camera devices seem to use a different dataset type,
which is not yet supported.

Tested with devices "Hauppauge HVR-930C". I've also checked the USB-log from the
"MSI Digivox ATSC" and it works the same way.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |  117 +++++++++++++++++++++++----------
 drivers/media/usb/em28xx/em28xx.h     |    4 +-
 2 Dateien geändert, 85 Zeilen hinzugefügt(+), 36 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index dfbc22e..44bef43 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -405,13 +405,18 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 	return len;
 }
 
-static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len)
+static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
 {
-	u8 buf, *data;
-	struct em28xx_eeprom *em_eeprom;
+	const u16 len = 256;
+	/* FIXME common length/size for bytes to read, to display, hash
+	 * calculation and returned device dataset. Simplifies the code a lot,
+	 * but we might have to deal with multiple sizes in the future !      */
 	int i, err;
+	struct em28xx_eeprom *dev_config;
+	u8 buf, *data;
 
 	*eedata = NULL;
+	*eedata_len = 0;
 
 	dev->i2c_client.addr = 0xa0 >> 1;
 
@@ -431,8 +436,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len
 				    len, data);
 	if (err != len) {
 		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
-		kfree(data);
-		return err;
+		goto error;
 	}
 
 	/* Display eeprom content */
@@ -447,15 +451,25 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len
 		if (15 == (i % 16))
 			printk("\n");
 	}
+	if (dev->eeprom_addrwidth_16bit)
+		em28xx_info("i2c eeprom %04x: ... (skipped)\n", i);
 
 	if (dev->eeprom_addrwidth_16bit &&
 	    data[0] == 0x26 && data[3] == 0x00) {
 		/* new eeprom format; size 4-64kb */
+		u16 mc_start;
+		u16 hwconf_offset;
+
 		dev->hash = em28xx_hash_mem(data, len, 32);
-		em28xx_info("EEPROM hash = 0x%08lx\n", dev->hash);
-		em28xx_info("EEPROM info: boot page address = 0x%02x04, "
+		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
+
+		em28xx_info("EEPROM ID = %02x %02x %02x %02x, "
+			    "EEPROM hash = 0x%08lx\n",
+			    data[0], data[1], data[2], data[3], dev->hash);
+		em28xx_info("EEPROM info:\n");
+		em28xx_info("\tmicrocode start address = 0x%04x, "
 			    "boot configuration = 0x%02x\n",
-			    data[1], data[2]);
+			    mc_start, data[2]);
 		/* boot configuration (address 0x0002):
 		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
 		 * [1]   always selects 12 kb RAM
@@ -465,32 +479,61 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len
 		 *       characterization
 		 */
 
-		/* FIXME:
-		 * - read more than 256 bytes / addresses above 0x00ff
-		 * - find offset for device config dataset and extract it
-		 * - decrypt eeprom data for camera bridges (em25xx, em276x+)
-		 * - use separate/different eeprom hashes (not yet used)
+		/* Read hardware config dataset offset from address
+		 * (microcode start + 46)			    */
+		err = em28xx_i2c_read_block(dev, mc_start + 46, 1, 2, data);
+		if (err != 2) {
+			em28xx_errdev("failed to read hardware configuration data from eeprom (err=%d)\n",
+				      err);
+			goto error;
+		}
+
+		/* Calculate hardware config dataset start address */
+		hwconf_offset = mc_start + data[0] + (data[1] << 8);
+
+		/* Read hardware config dataset */
+		/* NOTE: the microcode copy can be multiple pages long, but
+		 * we assume the hardware config dataset is the same as in
+		 * the old eeprom and not longer than 256 bytes.
+		 * tveeprom is currently also limited to 256 bytes.
 		 */
+		err = em28xx_i2c_read_block(dev, hwconf_offset, 1, len, data);
+		if (err != len) {
+			em28xx_errdev("failed to read hardware configuration data from eeprom (err=%d)\n",
+				      err);
+			goto error;
+		}
 
-		return 0;
-	} else if (data[0] != 0x1a || data[1] != 0xeb ||
-		   data[2] != 0x67 || data[3] != 0x95   ) {
+		/* Verify hardware config dataset */
+		/* NOTE: not all devices provide this type of dataset */
+		if (data[0] != 0x1a || data[1] != 0xeb ||
+		    data[2] != 0x67 || data[3] != 0x95    ) {
+			em28xx_info("\tno hardware configuration dataset found in eeprom\n");
+			kfree(data);
+			return 0;
+		}
+
+		/* TODO: decrypt eeprom data for camera bridges (em25xx, em276x+) */
+
+	} else if (!dev->eeprom_addrwidth_16bit &&
+		   data[0] == 0x1a && data[1] == 0xeb &&
+		   data[2] == 0x67 && data[3] == 0x95   ) {
+		dev->hash = em28xx_hash_mem(data, len, 32);
+		em28xx_info("EEPROM ID = %02x %02x %02x %02x, "
+			    "EEPROM hash = 0x%08lx\n",
+			    data[0], data[1], data[2], data[3], dev->hash);
+		em28xx_info("EEPROM info:\n");
+	} else {
 		em28xx_info("unknown eeprom format or eeprom corrupted !\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto error;
 	}
 
 	*eedata = data;
-	em_eeprom = (void *)eedata;
+	*eedata_len = len;
+	dev_config = (void *)eedata;
 
-	dev->hash = em28xx_hash_mem(data, len, 32);
-
-	em28xx_info("EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
-		    em_eeprom->id[0], em_eeprom->id[1],
-		    em_eeprom->id[2], em_eeprom->id[3], dev->hash);
-
-	em28xx_info("EEPROM info:\n");
-
-	switch (le16_to_cpu(em_eeprom->chip_conf) >> 4 & 0x3) {
+	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
 	case 0:
 		em28xx_info("\tNo audio on board.\n");
 		break;
@@ -505,13 +548,13 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len
 		break;
 	}
 
-	if (le16_to_cpu(em_eeprom->chip_conf) & 1 << 3)
+	if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
 		em28xx_info("\tUSB Remote wakeup capable\n");
 
-	if (le16_to_cpu(em_eeprom->chip_conf) & 1 << 2)
+	if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
 		em28xx_info("\tUSB Self power capable\n");
 
-	switch (le16_to_cpu(em_eeprom->chip_conf) & 0x3) {
+	switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
 	case 0:
 		em28xx_info("\t500mA max power\n");
 		break;
@@ -526,12 +569,16 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char **eedata, int len
 		break;
 	}
 	em28xx_info("\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
-		    em_eeprom->string_idx_table,
-		    le16_to_cpu(em_eeprom->string1),
-		    le16_to_cpu(em_eeprom->string2),
-		    le16_to_cpu(em_eeprom->string3));
+		    dev_config->string_idx_table,
+		    le16_to_cpu(dev_config->string1),
+		    le16_to_cpu(dev_config->string2),
+		    le16_to_cpu(dev_config->string3));
 
 	return 0;
+
+error:
+	kfree(data);
+	return err;
 }
 
 /* ----------------------------------------------------------- */
@@ -640,7 +687,7 @@ int em28xx_i2c_register(struct em28xx *dev)
 	dev->i2c_client = em28xx_client_template;
 	dev->i2c_client.adapter = &dev->i2c_adap;
 
-	retval = em28xx_i2c_eeprom(dev, &dev->eedata, 256);
+	retval = em28xx_i2c_eeprom(dev, &dev->eedata, &dev->eedata_len);
 	if ((retval < 0) && (retval != -ENODEV)) {
 		em28xx_errdev("%s: em28xx_i2_eeprom failed! retval [%d]\n",
 			__func__, retval);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 77f600d..2d6d31a 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -562,7 +562,9 @@ struct em28xx {
 	/* resources in use */
 	unsigned int resources;
 
-	u8 *eedata;	/* currently always 256 bytes */
+	/* eeprom content */
+	u8 *eedata;
+	u16 eedata_len;
 
 	/* Isoc control struct */
 	struct em28xx_dmaqueue vidq;
-- 
1.7.10.4

