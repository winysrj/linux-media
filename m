Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46967 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CCThF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:05 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so3369858eek.10
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:04 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 02/11] em28xx-i2c: get rid of the dprintk2 macro
Date: Sun,  3 Mar 2013 20:37:35 +0100
Message-Id: <1362339464-3373-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is only a single place where the dprintk2 macro is used, so get rid of it.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   17 ++++++-----------
 1 Datei geändert, 6 Zeilen hinzugefügt(+), 11 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 8819b54..f970c29 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -41,14 +41,6 @@ static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
-#define dprintk2(lvl, fmt, args...)			\
-do {							\
-	if (i2c_debug >= lvl) {				\
-		printk(KERN_DEBUG "%s at %s: " fmt,	\
-		       dev->name, __func__ , ##args);	\
-      } 						\
-} while (0)
-
 /*
  * em2800_i2c_send_bytes()
  * send up to 4 bytes to the em2800 i2c device
@@ -295,9 +287,12 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		return 0;
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
-		dprintk2(2, "%s %s addr=%x len=%d:",
-			 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
-			 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
+		if (i2c_debug >= 2)
+			printk(KERN_DEBUG "%s at %s: %s %s addr=%02x len=%d:",
+			       dev->name, __func__ ,
+			       (msgs[i].flags & I2C_M_RD) ? "read" : "write",
+			       i == num - 1 ? "stop" : "nonstop",
+			       addr, msgs[i].len			     );
 		if (!msgs[i].len) { /* no len: check only for device presence */
 			if (dev->board.is_em2800)
 				rc = em2800_i2c_check_for_device(dev, addr);
-- 
1.7.10.4

