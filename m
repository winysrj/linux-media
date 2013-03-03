Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63657 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3CCThH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:07 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so3534756eei.3
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:05 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 03/11] em28xx-i2c: also print debug messages at debug level 1
Date: Sun,  3 Mar 2013 20:37:36 +0100
Message-Id: <1362339464-3373-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code uses only a single debug level and all debug messages are
printed for i2c_debug >= 2 only. So debug level 1 is actually the same as
level 0, which is odd.
Users expect debugging messages to become enabled for anything else than
debug level 0.

Fix it and simplify the code a bit by printing the debug messages also at debug
level 1;

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   12 ++++++------
 1 Datei geändert, 6 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index f970c29..d765567 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -287,7 +287,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		return 0;
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
-		if (i2c_debug >= 2)
+		if (i2c_debug)
 			printk(KERN_DEBUG "%s at %s: %s %s addr=%02x len=%d:",
 			       dev->name, __func__ ,
 			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
@@ -299,7 +299,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			else
 				rc = em28xx_i2c_check_for_device(dev, addr);
 			if (rc == -ENODEV) {
-				if (i2c_debug >= 2)
+				if (i2c_debug)
 					printk(" no device\n");
 				return rc;
 			}
@@ -313,13 +313,13 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 				rc = em28xx_i2c_recv_bytes(dev, addr,
 							   msgs[i].buf,
 							   msgs[i].len);
-			if (i2c_debug >= 2) {
+			if (i2c_debug) {
 				for (byte = 0; byte < msgs[i].len; byte++)
 					printk(" %02x", msgs[i].buf[byte]);
 			}
 		} else {
 			/* write bytes */
-			if (i2c_debug >= 2) {
+			if (i2c_debug) {
 				for (byte = 0; byte < msgs[i].len; byte++)
 					printk(" %02x", msgs[i].buf[byte]);
 			}
@@ -334,11 +334,11 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 							   i == num - 1);
 		}
 		if (rc < 0) {
-			if (i2c_debug >= 2)
+			if (i2c_debug)
 				printk(" ERROR: %i\n", rc);
 			return rc;
 		}
-		if (i2c_debug >= 2)
+		if (i2c_debug)
 			printk("\n");
 	}
 
-- 
1.7.10.4

