Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35460 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdBSS3G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 13:29:06 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so10765027wmu.2
        for <linux-media@vger.kernel.org>; Sun, 19 Feb 2017 10:29:05 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, arnd@arndb.de,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/2] em28xx: reduce stack usage in sensor probing functions
Date: Sun, 19 Feb 2017 19:29:17 +0100
Message-Id: <20170219182918.4978-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's no longer necessary to keep the i2c_client in the device struct
unmodified until a sensor is found, so reduce stack usage in
em28xx_probe_sensor_micron() and em28xx_probe_sensor_omnivision() by using
a pointer to the client instead of a local copy.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 42 +++++++++++++++-----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 89c890ba7dd6..7b4129ab1cf9 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -110,44 +110,44 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 	__be16 id_be;
 	u16 id;
 
-	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
+	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
 
 	dev->em28xx_sensor = EM28XX_NOSENSOR;
 	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
-		client.addr = micron_sensor_addrs[i];
+		client->addr = micron_sensor_addrs[i];
 		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
 		/* Read chip ID from register 0x00 */
 		reg = 0x00;
-		ret = i2c_master_send(&client, &reg, 1);
+		ret = i2c_master_send(client, &reg, 1);
 		if (ret < 0) {
 			if (ret != -ENXIO)
 				dev_err(&dev->intf->dev,
 					"couldn't read from i2c device 0x%02x: error %i\n",
-				       client.addr << 1, ret);
+				       client->addr << 1, ret);
 			continue;
 		}
-		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
+		ret = i2c_master_recv(client, (u8 *)&id_be, 2);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
-				client.addr << 1, ret);
+				client->addr << 1, ret);
 			continue;
 		}
 		id = be16_to_cpu(id_be);
 		/* Read chip ID from register 0xff */
 		reg = 0xff;
-		ret = i2c_master_send(&client, &reg, 1);
+		ret = i2c_master_send(client, &reg, 1);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
-				client.addr << 1, ret);
+				client->addr << 1, ret);
 			continue;
 		}
-		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
+		ret = i2c_master_recv(client, (u8 *)&id_be, 2);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
-				client.addr << 1, ret);
+				client->addr << 1, ret);
 			continue;
 		}
 		/* Validate chip ID to be sure we have a Micron device */
@@ -197,7 +197,6 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 			dev_info(&dev->intf->dev,
 				 "sensor %s detected\n", name);
 
-		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
 		return 0;
 	}
 
@@ -213,30 +212,30 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 	char *name;
 	u8 reg;
 	u16 id;
-	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
+	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
 
 	dev->em28xx_sensor = EM28XX_NOSENSOR;
 	/* NOTE: these devices have the register auto incrementation disabled
 	 * by default, so we have to use single byte reads !              */
 	for (i = 0; omnivision_sensor_addrs[i] != I2C_CLIENT_END; i++) {
-		client.addr = omnivision_sensor_addrs[i];
+		client->addr = omnivision_sensor_addrs[i];
 		/* Read manufacturer ID from registers 0x1c-0x1d (BE) */
 		reg = 0x1c;
-		ret = i2c_smbus_read_byte_data(&client, reg);
+		ret = i2c_smbus_read_byte_data(client, reg);
 		if (ret < 0) {
 			if (ret != -ENXIO)
 				dev_err(&dev->intf->dev,
 					"couldn't read from i2c device 0x%02x: error %i\n",
-					client.addr << 1, ret);
+					client->addr << 1, ret);
 			continue;
 		}
 		id = ret << 8;
 		reg = 0x1d;
-		ret = i2c_smbus_read_byte_data(&client, reg);
+		ret = i2c_smbus_read_byte_data(client, reg);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
-				client.addr << 1, ret);
+				client->addr << 1, ret);
 			continue;
 		}
 		id += ret;
@@ -245,20 +244,20 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 			continue;
 		/* Read product ID from registers 0x0a-0x0b (BE) */
 		reg = 0x0a;
-		ret = i2c_smbus_read_byte_data(&client, reg);
+		ret = i2c_smbus_read_byte_data(client, reg);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
-				client.addr << 1, ret);
+				client->addr << 1, ret);
 			continue;
 		}
 		id = ret << 8;
 		reg = 0x0b;
-		ret = i2c_smbus_read_byte_data(&client, reg);
+		ret = i2c_smbus_read_byte_data(client, reg);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
-				client.addr << 1, ret);
+				client->addr << 1, ret);
 			continue;
 		}
 		id += ret;
@@ -309,7 +308,6 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 			dev_info(&dev->intf->dev,
 				 "sensor %s detected\n", name);
 
-		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
 		return 0;
 	}
 
-- 
2.11.0
