Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43716 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaAQRo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 12:44:28 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so1502612eek.41
        for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 09:44:27 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/3] em28xx-camera: fix return value checks on sensor probing
Date: Fri, 17 Jan 2014 18:45:31 +0100
Message-Id: <1389980732-8375-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389980732-8375-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389980732-8375-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit e63b009d6e the returned error code in case of not connected/responding
i2c clients is ENXIO isntead of ENODEV, which causes several error messages on
sensor probing.
Fix the i2c return value checks on sensor probing to silence these warnings.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |    4 ++--
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index c29f5c4..505e050 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -120,7 +120,7 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 		reg = 0x00;
 		ret = i2c_master_send(&client, &reg, 1);
 		if (ret < 0) {
-			if (ret != -ENODEV)
+			if (ret != -ENXIO)
 				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
 					      client.addr << 1, ret);
 			continue;
@@ -218,7 +218,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		reg = 0x1c;
 		ret = i2c_smbus_read_byte_data(&client, reg);
 		if (ret < 0) {
-			if (ret != -ENODEV)
+			if (ret != -ENXIO)
 				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
 					      client.addr << 1, ret);
 			continue;
-- 
1.7.10.4

