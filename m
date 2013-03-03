Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49631 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CCThO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:14 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so3380044eek.24
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:13 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 07/11] em28xx: add basic support for eeproms with 16 bit address width
Date: Sun,  3 Mar 2013 20:37:40 +0100
Message-Id: <1362339464-3373-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer devices (em2874, em2884, em28174, em25xx, em27[6,7,8]x) use eeproms with
16 bit instead of 8 bit address width.
The used eeprom type depends on the chip type, which makes sure eeproms can't
be damaged.

This patch adds basic support for 16 bit eeproms only, which includes
- reading the content
- calculating the eeprom hash
- displaying the content

The eeprom content uses a different format, for which support will be added with
subsequent patches.

Tested with the "Hauppauge HVR-930C" and the "Speedlink VAD Laplace webcam"
(with additional experimental patches).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    4 ++
 drivers/media/usb/em28xx/em28xx-i2c.c   |   69 ++++++++++++++++++++-----------
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geändert, 49 Zeilen hinzugefügt(+), 25 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 0d74734..fa51f81 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2187,6 +2187,7 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
 	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
 	{0x6b800080, EM2874_BOARD_LEADERSHIP_ISDBT, TUNER_ABSENT},
 };
+/* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
 static unsigned short saa711x_addrs[] = {
@@ -3023,11 +3024,13 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			chip_name = "em2874";
 			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
+			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		case CHIP_ID_EM28174:
 			chip_name = "em28174";
 			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
+			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		case CHIP_ID_EM2883:
 			chip_name = "em2882/3";
@@ -3037,6 +3040,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			chip_name = "em2884";
 			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
+			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		default:
 			printk(KERN_INFO DRIVER_NAME
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index ebe4b20..7185812 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -368,46 +368,34 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 
 static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 {
-	unsigned char buf, *p = eedata;
+	unsigned char buf[2], *p = eedata;
 	struct em28xx_eeprom *em_eeprom = (void *)eedata;
 	int i, err, size = len, block, block_max;
 
-	if (dev->chip_id == CHIP_ID_EM2874 ||
-	    dev->chip_id == CHIP_ID_EM28174 ||
-	    dev->chip_id == CHIP_ID_EM2884) {
-		/* Empia switched to a 16-bit addressable eeprom in newer
-		   devices.  While we could certainly write a routine to read
-		   the eeprom, there is nothing of use in there that cannot be
-		   accessed through registers, and there is the risk that we
-		   could corrupt the eeprom (since a 16-bit read call is
-		   interpreted as a write call by 8-bit eeproms).
-		*/
-		return 0;
-	}
-
 	dev->i2c_client.addr = 0xa0 >> 1;
 
 	/* Check if board has eeprom */
-	err = i2c_master_recv(&dev->i2c_client, &buf, 0);
+	err = i2c_master_recv(&dev->i2c_client, buf, 0);
 	if (err < 0) {
 		em28xx_info("board has no eeprom\n");
 		memset(eedata, 0, len);
 		return -ENODEV;
 	}
 
-	buf = 0;
-
-	err = i2c_master_send(&dev->i2c_client, &buf, 1);
-	if (err != 1) {
+	/* Select address memory address 0x00(00) */
+	buf[0] = 0;
+	buf[1] = 0;
+	err = i2c_master_send(&dev->i2c_client, buf, 1 + dev->eeprom_addrwidth_16bit);
+	if (err != 1 + dev->eeprom_addrwidth_16bit) {
 		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
 		return err;
 	}
 
+	/* Read eeprom content */
 	if (dev->board.is_em2800)
 		block_max = 4;
 	else
 		block_max = 64;
-
 	while (size > 0) {
 		if (size > block_max)
 			block = block_max;
@@ -422,17 +410,48 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 		size -= block;
 		p += block;
 	}
+
+	/* Display eeprom content */
 	for (i = 0; i < len; i++) {
-		if (0 == (i % 16))
-			em28xx_info("i2c eeprom %02x:", i);
+		if (0 == (i % 16)) {
+			if (dev->eeprom_addrwidth_16bit)
+				em28xx_info("i2c eeprom %04x:", i);
+			else
+				em28xx_info("i2c eeprom %02x:", i);
+		}
 		printk(" %02x", eedata[i]);
 		if (15 == (i % 16))
 			printk("\n");
 	}
 
-	if (em_eeprom->id[0] != 0x1a || em_eeprom->id[1] != 0xeb ||
-	    em_eeprom->id[2] != 0x67 || em_eeprom->id[3] != 0x95   ) {
-		em28xx_errdev("Unknown eeprom type or eeprom corrupted !");
+	if (dev->eeprom_addrwidth_16bit &&
+	    eedata[0] == 0x26 && eedata[3] == 0x00) {
+		/* new eeprom format; size 4-64kb */
+		dev->hash = em28xx_hash_mem(eedata, len, 32);
+		em28xx_info("EEPROM hash = 0x%08lx\n", dev->hash);
+		em28xx_info("EEPROM info: boot page address = 0x%02x04, "
+			    "boot configuration = 0x%02x\n",
+			    eedata[1], eedata[2]);
+		/* boot configuration (address 0x0002):
+		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
+		 * [1]   always selects 12 kb RAM
+		 * [2]   USB device speed: 1 = force Full Speed; 0 = auto detect
+		 * [4]   1 = force fast mode and no suspend for device testing
+		 * [5:7] USB PHY tuning registers; determined by device
+		 *       characterization
+		 */
+
+		/* FIXME:
+		 * - read more than 256 bytes / addresses above 0x00ff
+		 * - find offset for device config dataset and extract it
+		 * - decrypt eeprom data for camera bridges (em25xx, em276x+)
+		 * - use separate/different eeprom hashes (not yet used)
+		 */
+
+		return 0;
+	} else if (em_eeprom->id[0] != 0x1a || em_eeprom->id[1] != 0xeb ||
+		   em_eeprom->id[2] != 0x67 || em_eeprom->id[3] != 0x95   ) {
+		em28xx_info("unknown eeprom format or eeprom corrupted !\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 90266a1..139dfe5 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -510,6 +510,7 @@ struct em28xx {
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
 	struct i2c_client i2c_client;
+	unsigned char eeprom_addrwidth_16bit:1;
 	/* video for linux */
 	int users;		/* user count for exclusive use */
 	int streaming_users;    /* Number of actively streaming users */
-- 
1.7.10.4

