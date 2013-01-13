Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38178 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3AMOUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:25 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so1161534eek.15
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:24 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/7] em28xx: remove i2cdprintk() messages
Date: Sun, 13 Jan 2013 15:20:40 +0100
Message-Id: <1358086845-6989-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't report any key/scan codes or errors inside the key polling functions
for internal IR RC devices, just in the key handling fucntions.
Do the same for external devices.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   29 +++++------------------------
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 24 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index f554a52..edcd697 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -40,11 +40,6 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
 #define MODULE_NAME "em28xx"
 
-#define i2cdprintk(fmt, arg...) \
-	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
-	}
-
 #define dprintk(fmt, arg...) \
 	if (ir_debug) { \
 		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
@@ -86,17 +81,13 @@ static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		i2cdprintk("read error\n");
+	if (1 != i2c_master_recv(ir->c, &b, 1))
 		return -EIO;
-	}
 
 	/* it seems that 0xFE indicates that a button is still hold
 	   down, while 0xff indicates that no button is hold
 	   down. 0xfe sequences are sometimes interrupted by 0xFF */
 
-	i2cdprintk("key %02x\n", b);
-
 	if (b == 0xff)
 		return 0;
 
@@ -147,9 +138,6 @@ static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		 ((buf[1] & 0x40) ? 0x0200 : 0) | /* 0000 0010		  */
 		 ((buf[1] & 0x80) ? 0x0100 : 0);  /* 0000 0001		  */
 
-	i2cdprintk("ir hauppauge (em2840): code=0x%02x (rcv=0x%02x%02x)\n",
-			code, buf[1], buf[0]);
-
 	/* return key */
 	*ir_key = code;
 	*ir_raw = code;
@@ -163,12 +151,9 @@ static int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
 
 	/* poll IR chip */
 
-	if (3 != i2c_master_recv(ir->c, buf, 3)) {
-		i2cdprintk("read error\n");
+	if (3 != i2c_master_recv(ir->c, buf, 3))
 		return -EIO;
-	}
 
-	i2cdprintk("key %02x\n", buf[2]&0x3f);
 	if (buf[0] != 0x00)
 		return 0;
 
@@ -188,19 +173,15 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32 *ir_key,
 				{ .addr = ir->c->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
 
 	subaddr = 0x10;
-	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
-		i2cdprintk("read error\n");
+	if (2 != i2c_transfer(ir->c->adapter, msg, 2))
 		return -EIO;
-	}
 	if (keydetect == 0x00)
 		return 0;
 
 	subaddr = 0x00;
 	msg[1].buf = &key;
-	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
-		i2cdprintk("read error\n");
-	return -EIO;
-	}
+	if (2 != i2c_transfer(ir->c->adapter, msg, 2))
+		return -EIO;
 	if (key == 0x00)
 		return 0;
 
-- 
1.7.10.4

