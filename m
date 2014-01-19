Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61780 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaASVrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 16:47:46 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so1909730ead.27
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 13:47:45 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/4] em28xx-i2c: do not map -ENXIO errors to -ENODEV for empty i2c transfers
Date: Sun, 19 Jan 2014 22:48:36 +0100
Message-Id: <1390168117-2925-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit e63b009d6e "" changed the error codes i2c ACK errors from -ENODEV to -ENXIO.
But it also introduced a line that maps -ENXIO back to -ENODEV in case of empty i2c
messages, which makes no sense, because
1.) an ACK error is an ACK error no matter what the i2c message content is
2.) -ENXIO is perfectly suited for probing, too
3.) we are loosing the ability to distinguish USB device disconnects

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c |    1 -
 1 Datei geändert, 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index ba6433c..a26d7d4 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -539,7 +539,6 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 				if (rc == -ENXIO) {
 					if (i2c_debug > 1)
 						printk(KERN_CONT " no device\n");
-					rc = -ENODEV;
 				} else {
 					if (i2c_debug > 1)
 						printk(KERN_CONT " ERROR: %i\n", rc);
-- 
1.7.10.4

