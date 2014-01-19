Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50052 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaASVrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 16:47:47 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so3019431eek.4
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 13:47:46 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/4] em28xx-i2c: remove duplicate error printing code from em28xx_i2c_xfer()
Date: Sun, 19 Jan 2014 22:48:37 +0100
Message-Id: <1390168117-2925-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   11 +++--------
 1 Datei geändert, 3 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index a26d7d4..1a514ca 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -535,14 +535,9 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 			 * This code is only called during device probe.
 			 */
 			rc = i2c_check_for_device(i2c_bus, addr);
-			if (rc < 0) {
-				if (rc == -ENXIO) {
-					if (i2c_debug > 1)
-						printk(KERN_CONT " no device\n");
-				} else {
-					if (i2c_debug > 1)
-						printk(KERN_CONT " ERROR: %i\n", rc);
-				}
+			if (rc == -ENXIO) {
+				if (i2c_debug > 1)
+					printk(KERN_CONT " no device\n");
 				rt_mutex_unlock(&dev->i2c_bus_lock);
 				return rc;
 			}
-- 
1.7.10.4

