Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37262 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3AMOUb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:31 -0500
Received: by mail-ee0-f49.google.com with SMTP id c4so1535258eek.8
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:30 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/7] em28xx: fix a comment and a small coding style issue
Date: Sun, 13 Jan 2013 15:20:43 +0100
Message-Id: <1358086845-6989-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |    6 ++----
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index e49d290..f4d0df8 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -89,8 +89,7 @@ static int em28xx_get_key_terratec(struct i2c_client *i2c_dev, u32 *ir_key)
 		return -EIO;
 
 	/* it seems that 0xFE indicates that a button is still hold
-	   down, while 0xff indicates that no button is hold
-	   down. 0xfe sequences are sometimes interrupted by 0xFF */
+	   down, while 0xff indicates that no button is hold down. */
 
 	if (b == 0xff)
 		return 0;
@@ -170,8 +169,7 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
 	unsigned char subaddr, keydetect, key;
 
 	struct i2c_msg msg[] = { { .addr = i2c_dev->addr, .flags = 0, .buf = &subaddr, .len = 1},
-
-				{ .addr = i2c_dev->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
+				 { .addr = i2c_dev->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
 
 	subaddr = 0x10;
 	if (2 != i2c_transfer(i2c_dev->adapter, msg, 2))
-- 
1.7.10.4

