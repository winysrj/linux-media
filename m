Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:50760 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaASVrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 16:47:45 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3071817eek.23
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 13:47:44 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/4] em28xx-i2c: fix the error code for unknown errors
Date: Sun, 19 Jan 2014 22:48:35 +0100
Message-Id: <1390168117-2925-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit e63b009d6e "em28xx-i2c: Fix error code for I2C error transfers" changed
the code to return -ETIMEDOUT on all unknown errors.
But the proper error code for unknown errors is -EIO.
So only report -ETIMEDOUT in case of the errors 0x02 and 0x04, which are according
to Mauro Carvalho Chehabs tests related to i2c clock stretching and return -EIO
for the rest.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |   29 +++++++++++++++++++++++------
 1 Datei geändert, 23 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index bd8101d..ba6433c 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -226,10 +226,18 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		 * (even with high payload) ...
 		 */
 	}
-	if (i2c_debug)
-		em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
-			    addr, ret);
-	return -ETIMEDOUT;
+
+	if (ret == 0x02 || ret == 0x04) {
+		/* NOTE: these errors seem to be related to clock stretching */
+		if (i2c_debug)
+			em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
+				    addr, ret);
+		return -ETIMEDOUT;
+	}
+
+	em28xx_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
+		    addr, ret);
+	return -EIO;
 }
 
 /*
@@ -279,8 +287,17 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		return -ENXIO;
 	}
 
-	em28xx_warn("unknown i2c error (status=%i)\n", ret);
-	return -ETIMEDOUT;
+	if (ret == 0x02 || ret == 0x04) {
+		/* NOTE: these errors seem to be related to clock stretching */
+		if (i2c_debug)
+			em28xx_warn("write to i2c device at 0x%x timed out (status=%i)\n",
+				    addr, ret);
+		return -ETIMEDOUT;
+	}
+
+	em28xx_warn("write to i2c device at 0x%x failed with unknown error (status=%i)\n",
+		    addr, ret);
+	return -EIO;
 }
 
 /*
-- 
1.7.10.4

