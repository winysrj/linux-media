Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39459 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3AMOU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:28 -0500
Received: by mail-ee0-f49.google.com with SMTP id c4so1539819eek.22
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:27 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/7] em28xx: remove unused parameter ir_raw from i2c RC key polling functions
Date: Sun, 13 Jan 2013 15:20:42 +0100
Message-Id: <1358086845-6989-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   20 +++++++-------------
 1 Datei geändert, 7 Zeilen hinzugefügt(+), 13 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index a8f3636..e49d290 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -72,7 +72,7 @@ struct em28xx_IR {
 	/* external device (if used) */
 	struct i2c_client *i2c_dev;
 
-	int  (*get_key_i2c)(struct i2c_client *, u32 *, u32 *);
+	int  (*get_key_i2c)(struct i2c_client *, u32 *);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
 };
 
@@ -80,8 +80,7 @@ struct em28xx_IR {
  I2C IR based get keycodes - should be used with ir-kbd-i2c
  **********************************************************/
 
-static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
-				   u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_terratec(struct i2c_client *i2c_dev, u32 *ir_key)
 {
 	unsigned char b;
 
@@ -101,12 +100,10 @@ static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
 		return 1;
 
 	*ir_key = b;
-	*ir_raw = b;
 	return 1;
 }
 
-static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
-				  u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev, u32 *ir_key)
 {
 	unsigned char buf[2];
 	u16 code;
@@ -146,12 +143,11 @@ static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
 
 	/* return key */
 	*ir_key = code;
-	*ir_raw = code;
 	return 1;
 }
 
 static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
-					    u32 *ir_key, u32 *ir_raw)
+					    u32 *ir_key)
 {
 	unsigned char buf[3];
 
@@ -164,13 +160,12 @@ static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
 		return 0;
 
 	*ir_key = buf[2]&0x3f;
-	*ir_raw = buf[2]&0x3f;
 
 	return 1;
 }
 
 static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
-					       u32 *ir_key, u32 *ir_raw)
+					       u32 *ir_key)
 {
 	unsigned char subaddr, keydetect, key;
 
@@ -192,7 +187,6 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
 		return 0;
 
 	*ir_key = key;
-	*ir_raw = key;
 	return 1;
 }
 
@@ -288,10 +282,10 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
-	static u32 ir_key, ir_raw;
+	static u32 ir_key;
 	int rc;
 
-	rc = ir->get_key_i2c(ir->i2c_dev, &ir_key, &ir_raw);
+	rc = ir->get_key_i2c(ir->i2c_dev, &ir_key);
 	if (rc < 0) {
 		dprintk("ir->get_key_i2c() failed: %d\n", rc);
 		return rc;
-- 
1.7.10.4

