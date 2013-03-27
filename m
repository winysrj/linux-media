Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59211 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3C0VGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:35 -0400
Received: by mail-ea0-f174.google.com with SMTP id m14so1530127eaj.33
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:34 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/9] em28xx: move the probing of Micron sensors to a separate function
Date: Wed, 27 Mar 2013 22:06:33 +0100
Message-Id: <1364418396-8191-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Other sensors like the ones from OmniVision need a different probing procedure,
so it makes sense have separate functions for each manufacturer/sensor type.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |   23 +++++++++++++++++++----
 1 Datei geändert, 19 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 2e4856a..d744af6 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -83,9 +83,9 @@ static int em28xx_initialize_mt9m001(struct em28xx *dev)
 
 
 /*
- * This method works for webcams with Micron sensors
+ * Probes Micron sensors with 8 bit address and 16 bit register width
  */
-int em28xx_detect_sensor(struct em28xx *dev)
+static int em28xx_probe_sensor_micron(struct em28xx *dev)
 {
 	int ret, i;
 	char *name;
@@ -96,7 +96,6 @@ int em28xx_detect_sensor(struct em28xx *dev)
 	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
 
 	dev->em28xx_sensor = EM28XX_NOSENSOR;
-	/* Probe Micron sensors with 8 bit address and 16 bit register width */
 	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
 		client.addr = micron_sensor_addrs[i];
 		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
@@ -167,7 +166,7 @@ int em28xx_detect_sensor(struct em28xx *dev)
 		default:
 			em28xx_info("unknown Micron sensor detected: 0x%04x\n",
 				    id);
-			return -EINVAL;
+			return 0;
 		}
 
 		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
@@ -182,6 +181,22 @@ int em28xx_detect_sensor(struct em28xx *dev)
 	return -ENODEV;
 }
 
+/*
+ * This method works for webcams with Micron sensors
+ */
+int em28xx_detect_sensor(struct em28xx *dev)
+{
+	int ret;
+
+	ret = em28xx_probe_sensor_micron(dev);
+	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0) {
+		em28xx_info("No sensor detected\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 int em28xx_init_camera(struct em28xx *dev)
 {
 	switch (dev->em28xx_sensor) {
-- 
1.7.10.4

