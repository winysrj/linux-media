Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39678 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2L0XCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:02:42 -0500
Received: by mail-ee0-f50.google.com with SMTP id b45so5084804eek.9
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 15:02:40 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/6] em28xx: IR RC: get rid of function em28xx_get_key_terratec()
Date: Fri, 28 Dec 2012 00:02:46 +0100
Message-Id: <1356649368-5426-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Module "ir-kbd-i2c" already provides this function as IR_KBD_GET_KEY_KNC1.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   30 +-----------------------------
 1 Datei geändert, 1 Zeile hinzugefügt(+), 29 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 631e252..62b6cb7 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -85,34 +85,6 @@ struct em28xx_IR {
  I2C IR based get keycodes - should be used with ir-kbd-i2c
  **********************************************************/
 
-static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
-{
-	unsigned char b;
-
-	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		i2cdprintk("read error\n");
-		return -EIO;
-	}
-
-	/* it seems that 0xFE indicates that a button is still hold
-	   down, while 0xff indicates that no button is hold
-	   down. 0xfe sequences are sometimes interrupted by 0xFF */
-
-	i2cdprintk("key %02x\n", b);
-
-	if (b == 0xff)
-		return 0;
-
-	if (b == 0xfe)
-		/* keep old data */
-		return 1;
-
-	*ir_key = b;
-	*ir_raw = b;
-	return 1;
-}
-
 static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char buf[2];
@@ -476,7 +448,7 @@ static int em28xx_register_i2c_ir(struct em28xx *dev, struct rc_dev *rc_dev)
 	case EM2820_BOARD_TERRATEC_CINERGY_250:
 		dev->init_data.name = "i2c IR (EM28XX Terratec)";
 		dev->init_data.type = RC_BIT_OTHER;
-		dev->init_data.get_key = em28xx_get_key_terratec;
+		dev->init_data.internal_get_key_func = IR_KBD_GET_KEY_KNC1;
 		break;
 	case EM2820_BOARD_PINNACLE_USB_2:
 		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
-- 
1.7.10.4

