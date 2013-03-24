Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62873 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3CXVJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 17:09:12 -0400
Received: by mail-ea0-f179.google.com with SMTP id f15so2034203eak.10
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 14:09:11 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx-i2c: fix coding style of multi line comments
Date: Sun, 24 Mar 2013 22:09:59 +0100
Message-Id: <1364159399-16730-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   52 +++++++++++++++++++++------------
 1 Datei geändert, 34 Zeilen hinzugefügt(+), 18 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index db40835..79ed1da 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -171,8 +171,10 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 
 	if (len < 1 || len > 64)
 		return -EOPNOTSUPP;
-	/* NOTE: limited by the USB ctrl message constraints
-	 * Zero length reads always succeed, even if no device is connected */
+	/*
+	 * NOTE: limited by the USB ctrl message constraints
+	 * Zero length reads always succeed, even if no device is connected
+	 */
 
 	/* Write to i2c device */
 	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
@@ -202,9 +204,11 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 			return ret;
 		}
 		msleep(5);
-		/* NOTE: do we really have to wait for success ?
-		   Never seen anything else than 0x00 or 0x10
-		   (even with high payload) ...			*/
+		/*
+		 * NOTE: do we really have to wait for success ?
+		 * Never seen anything else than 0x00 or 0x10
+		 * (even with high payload) ...
+		 */
 	}
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
 	return -EIO;
@@ -220,8 +224,10 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 
 	if (len < 1 || len > 64)
 		return -EOPNOTSUPP;
-	/* NOTE: limited by the USB ctrl message constraints
-	 * Zero length reads always succeed, even if no device is connected */
+	/*
+	 * NOTE: limited by the USB ctrl message constraints
+	 * Zero length reads always succeed, even if no device is connected
+	 */
 
 	/* Read data from i2c device */
 	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
@@ -230,7 +236,8 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 			    addr, ret);
 		return ret;
 	}
-	/* NOTE: some devices with two i2c busses have the bad habit to return 0
+	/*
+	 * NOTE: some devices with two i2c busses have the bad habit to return 0
 	 * bytes if we are on bus B AND there was no write attempt to the
 	 * specified slave address before AND no device is present at the
 	 * requested slave address.
@@ -366,9 +373,10 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	return num;
 }
 
-/* based on linux/sunrpc/svcauth.h and linux/hash.h
+/*
+ * based on linux/sunrpc/svcauth.h and linux/hash.h
  * The original hash function returns a different value, if arch is x86_64
- *  or i386.
+ * or i386.
  */
 static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 {
@@ -391,8 +399,10 @@ static inline unsigned long em28xx_hash_mem(char *buf, int length, int bits)
 	return (hash >> (32 - bits)) & 0xffffffffUL;
 }
 
-/* Helper function to read data blocks from i2c clients with 8 or 16 bit
- * address width, 8 bit register width and auto incrementation been activated */
+/*
+ * Helper function to read data blocks from i2c clients with 8 or 16 bit
+ * address width, 8 bit register width and auto incrementation been activated
+ */
 static int em28xx_i2c_read_block(struct em28xx *dev, unsigned bus, u16 addr,
 				 bool addr_w16, u16 len, u8 *data)
 {
@@ -434,9 +444,11 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 			     u8 **eedata, u16 *eedata_len)
 {
 	const u16 len = 256;
-	/* FIXME common length/size for bytes to read, to display, hash
+	/*
+	 * FIXME common length/size for bytes to read, to display, hash
 	 * calculation and returned device dataset. Simplifies the code a lot,
-	 * but we might have to deal with multiple sizes in the future !      */
+	 * but we might have to deal with multiple sizes in the future !
+	 */
 	int i, err;
 	struct em28xx_eeprom *dev_config;
 	u8 buf, *data;
@@ -497,7 +509,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		em28xx_info("EEPROM info:\n");
 		em28xx_info("\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
 			    mc_start, data[2]);
-		/* boot configuration (address 0x0002):
+		/*
+		 * boot configuration (address 0x0002):
 		 * [0]   microcode download speed: 1 = 400 kHz; 0 = 100 kHz
 		 * [1]   always selects 12 kb RAM
 		 * [2]   USB device speed: 1 = force Full Speed; 0 = auto detect
@@ -506,8 +519,10 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		 *       characterization
 		 */
 
-		/* Read hardware config dataset offset from address
-		 * (microcode start + 46)			    */
+		/*
+		 * Read hardware config dataset offset from address
+		 * (microcode start + 46)
+		 */
 		err = em28xx_i2c_read_block(dev, bus, mc_start + 46, 1, 2,
 					    data);
 		if (err != 2) {
@@ -520,7 +535,8 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		hwconf_offset = mc_start + data[0] + (data[1] << 8);
 
 		/* Read hardware config dataset */
-		/* NOTE: the microcode copy can be multiple pages long, but
+		/*
+		 * NOTE: the microcode copy can be multiple pages long, but
 		 * we assume the hardware config dataset is the same as in
 		 * the old eeprom and not longer than 256 bytes.
 		 * tveeprom is currently also limited to 256 bytes.
-- 
1.7.10.4

