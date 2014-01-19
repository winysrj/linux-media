Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54571 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaASVrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 16:47:43 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so2751724ead.34
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 13:47:42 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/4] em28xx-i2c: fix the i2c error description strings for -ENXIO
Date: Sun, 19 Jan 2014 22:48:34 +0100
Message-Id: <1390168117-2925-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit d845fb3ae5 "em28xx-i2c: add timeout debug information if i2c_debug enabled"
has added wrong error descriptions for -ENXIO.
The strings are also missing terminating newline characters, which breaks the
output format.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   12 ++++++------
 1 Datei geändert, 6 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 7e17240..bd8101d 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -81,7 +81,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			return len;
 		if (ret == 0x94 + len - 1) {
 			if (i2c_debug == 1)
-				em28xx_warn("R05 returned 0x%02x: I2C timeout",
+				em28xx_warn("R05 returned 0x%02x: I2C ACK error\n",
 					    ret);
 			return -ENXIO;
 		}
@@ -128,7 +128,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 			break;
 		if (ret == 0x94 + len - 1) {
 			if (i2c_debug == 1)
-				em28xx_warn("R05 returned 0x%02x: I2C timeout",
+				em28xx_warn("R05 returned 0x%02x: I2C ACK error\n",
 					    ret);
 			return -ENXIO;
 		}
@@ -210,7 +210,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 			return len;
 		if (ret == 0x10) {
 			if (i2c_debug == 1)
-				em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+				em28xx_warn("I2C ACK error on writing to addr 0x%02x\n",
 					    addr);
 			return -ENXIO;
 		}
@@ -274,7 +274,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	}
 	if (ret == 0x10) {
 		if (i2c_debug == 1)
-			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
+			em28xx_warn("I2C ACK error on writing to addr 0x%02x\n",
 				    addr);
 		return -ENXIO;
 	}
@@ -337,7 +337,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		if (i2c_debug == 1)
-			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
+			em28xx_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
 				    ret);
 		return -ENXIO;
 	}
@@ -392,7 +392,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		return len;
 	else if (ret > 0) {
 		if (i2c_debug == 1)
-			em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout",
+			em28xx_warn("Bus B R08 returned 0x%02x: I2C ACK error\n",
 				    ret);
 		return -ENXIO;
 	}
-- 
1.7.10.4

