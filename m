Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:57174 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3C0VGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:34 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so1533216eei.20
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:33 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/9] em28xx: detect further Micron sensors
Date: Wed, 27 Mar 2013 22:06:32 +0100
Message-Id: <1364418396-8191-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add further Micron chip IDs to be able to identify all Micron sensors listed
by Empiatech.
Also probe the two alternate i2c addresses used by Micron sensors with 8 bit
address and 16 bit register width.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |  126 ++++++++++++++++++++++--------
 1 Datei geändert, 95 Zeilen hinzugefügt(+), 31 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 28dd848..2e4856a 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -26,6 +26,15 @@
 #include "em28xx.h"
 
 
+/* Possible i2c addresses of Micron sensors */
+static unsigned short micron_sensor_addrs[] = {
+	0xb8 >> 1,   /* MT9V111, MT9V403 */
+	0xba >> 1,   /* MT9M001/011/111/112, MT9V011/012/112, MT9D011 */
+	0x90 >> 1,   /* MT9V012/112, MT9D011 (alternative address) */
+	I2C_CLIENT_END
+};
+
+
 /* FIXME: Should be replaced by a proper mt9m111 driver */
 static int em28xx_initialize_mt9m111(struct em28xx *dev)
 {
@@ -78,44 +87,99 @@ static int em28xx_initialize_mt9m001(struct em28xx *dev)
  */
 int em28xx_detect_sensor(struct em28xx *dev)
 {
-	int ret;
+	int ret, i;
 	char *name;
 	u8 reg;
 	__be16 id_be;
 	u16 id;
 
-	/* Micron sensor detection */
-	dev->i2c_client[dev->def_i2c_bus].addr = 0xba >> 1;
-	reg = 0;
-	i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &reg, 1);
-	ret = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus],
-			      (char *)&id_be, 2);
-	if (ret != 2)
-		return -EINVAL;
-
-	id = be16_to_cpu(id_be);
-	switch (id) {
-	case 0x8232:		/* mt9v011 640x480 1.3 Mpix sensor */
-	case 0x8243:		/* mt9v011 rev B 640x480 1.3 Mpix sensor */
-		name = "mt9v011";
-		dev->em28xx_sensor = EM28XX_MT9V011;
-		break;
-	case 0x143a:    /* MT9M111 as found in the ECS G200 */
-		name = "mt9m111";
-		dev->em28xx_sensor = EM28XX_MT9M111;
-		break;
-	case 0x8431:
-		name = "mt9m001";
-		dev->em28xx_sensor = EM28XX_MT9M001;
-		break;
-	default:
-		em28xx_info("unknown Micron sensor detected: 0x%04x\n", id);
-		return -EINVAL;
+	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
+
+	dev->em28xx_sensor = EM28XX_NOSENSOR;
+	/* Probe Micron sensors with 8 bit address and 16 bit register width */
+	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
+		client.addr = micron_sensor_addrs[i];
+		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
+		/* Read chip ID from register 0x00 */
+		reg = 0x00;
+		ret = i2c_master_send(&client, &reg, 1);
+		if (ret < 0) {
+			if (ret != -ENODEV)
+				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+					      client.addr << 1, ret);
+			continue;
+		}
+		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
+		if (ret < 0) {
+			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				      client.addr << 1, ret);
+			continue;
+		}
+		id = be16_to_cpu(id_be);
+		/* Read chip ID from register 0xff */
+		reg = 0xff;
+		ret = i2c_master_send(&client, &reg, 1);
+		if (ret < 0) {
+			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				      client.addr << 1, ret);
+			continue;
+		}
+		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
+		if (ret < 0) {
+			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				      client.addr << 1, ret);
+			continue;
+		}
+		/* Validate chip ID to be sure we have a Micron device */
+		if (id != be16_to_cpu(id_be))
+			continue;
+		/* Check chip ID */
+		id = be16_to_cpu(id_be);
+		switch (id) {
+		case 0x1222:
+			name = "MT9V012"; /* MI370 */ /* 640x480 */
+			break;
+		case 0x1229:
+			name = "MT9V112"; /* 640x480 */
+			break;
+		case 0x1433:
+			name = "MT9M011"; /* 1280x1024 */
+			break;
+		case 0x143a:    /* found in the ECS G200 */
+			name = "MT9M111"; /* MI1310 */ /* 1280x1024 */
+			dev->em28xx_sensor = EM28XX_MT9M111;
+			break;
+		case 0x148c:
+			name = "MT9M112"; /* MI1320 */ /* 1280x1024 */
+			break;
+		case 0x1511:
+			name = "MT9D011"; /* MI2010 */ /* 1600x1200 */
+			break;
+		case 0x8232:
+		case 0x8243:	/* rev B */
+			name = "MT9V011"; /* MI360 */ /* 640x480 */
+			dev->em28xx_sensor = EM28XX_MT9V011;
+			break;
+		case 0x8431:
+			name = "MT9M001"; /* 1280x1024 */
+			dev->em28xx_sensor = EM28XX_MT9M001;
+			break;
+		default:
+			em28xx_info("unknown Micron sensor detected: 0x%04x\n",
+				    id);
+			return -EINVAL;
+		}
+
+		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
+			em28xx_info("unsupported sensor detected: %s\n", name);
+		else
+			em28xx_info("sensor %s detected\n", name);
+
+		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
+		return 0;
 	}
 
-	em28xx_info("sensor %s detected\n", name);
-
-	return 0;
+	return -ENODEV;
 }
 
 int em28xx_init_camera(struct em28xx *dev)
-- 
1.7.10.4

