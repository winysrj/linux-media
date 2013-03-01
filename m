Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:44270 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3CAXLu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 18:11:50 -0500
Received: by mail-ea0-f182.google.com with SMTP id a12so422985eaa.41
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2013 15:11:48 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 08/11] em28xx: add helper function for reading data blocks from i2c clients
Date: Sat,  2 Mar 2013 00:12:12 +0100
Message-Id: <1362179535-18929-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362179535-18929-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362179535-18929-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper function for reading data blocks from i2c devices with 8 or 16 bit
address width and 8 bit register width.
This allows us to reduce the size of new code added by the following patches.
Works only for devices with activated register auto incrementation.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   74 ++++++++++++++++++++-------------
 1 Datei geändert, 46 Zeilen hinzugefügt(+), 28 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 7185812..a3e9547 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -366,51 +366,69 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 	return (hash >> (32 - bits)) & 0xffffffffUL;
 }
 
+/* Helper function to read data blocks from i2c clients with 8 or 16 bit
+ * address width, 8 bit register width and auto incrementation been activated */
+static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
+				 u16 len, u8 *data)
+{
+	int remain = len, rsize, rsize_max, ret;
+	u8 buf[2];
+
+	/* Sanity check */
+	if (addr + remain > (256 + addr_w16*256))
+		return -EINVAL;
+	/* Select address */
+	buf[0] = addr >> 8;
+	buf[1] = addr & 0xff;
+	ret = i2c_master_send(&dev->i2c_client, buf + !addr_w16, 1 + addr_w16);
+	if (ret < 0)
+		return ret;
+	/* Read data */
+	if (dev->board.is_em2800)
+		rsize_max = 4;
+	else
+		rsize_max = 64;
+	while (remain > 0) {
+		if (remain > rsize_max)
+			rsize = rsize_max;
+		else
+			rsize = remain;
+
+		ret = i2c_master_recv(&dev->i2c_client, data, rsize);
+		if (ret < 0)
+			return ret;
+
+		remain -= rsize;
+		data += rsize;
+	}
+
+	return len;
+}
+
 static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
 {
-	unsigned char buf[2], *p = eedata;
+	unsigned char buf, *p = eedata;
 	struct em28xx_eeprom *em_eeprom = (void *)eedata;
-	int i, err, size = len, block, block_max;
+	int i, err;
 
 	dev->i2c_client.addr = 0xa0 >> 1;
 
 	/* Check if board has eeprom */
-	err = i2c_master_recv(&dev->i2c_client, buf, 0);
+	err = i2c_master_recv(&dev->i2c_client, &buf, 0);
 	if (err < 0) {
 		em28xx_info("board has no eeprom\n");
 		memset(eedata, 0, len);
 		return -ENODEV;
 	}
 
-	/* Select address memory address 0x00(00) */
-	buf[0] = 0;
-	buf[1] = 0;
-	err = i2c_master_send(&dev->i2c_client, buf, 1 + dev->eeprom_addrwidth_16bit);
-	if (err != 1 + dev->eeprom_addrwidth_16bit) {
+	/* Read EEPROM content */
+	err = em28xx_i2c_read_block(dev, 0x0000, dev->eeprom_addrwidth_16bit,
+				    len, p);
+	if (err != len) {
 		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
 		return err;
 	}
 
-	/* Read eeprom content */
-	if (dev->board.is_em2800)
-		block_max = 4;
-	else
-		block_max = 64;
-	while (size > 0) {
-		if (size > block_max)
-			block = block_max;
-		else
-			block = size;
-
-		if (block !=
-		    (err = i2c_master_recv(&dev->i2c_client, p, block))) {
-			em28xx_errdev("i2c eeprom read error (err=%d)\n", err);
-			return err;
-		}
-		size -= block;
-		p += block;
-	}
-
 	/* Display eeprom content */
 	for (i = 0; i < len; i++) {
 		if (0 == (i % 16)) {
-- 
1.7.10.4

