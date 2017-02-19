Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32771 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdBSS3K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 13:29:10 -0500
Received: by mail-wm0-f66.google.com with SMTP id v77so10799650wmv.0
        for <linux-media@vger.kernel.org>; Sun, 19 Feb 2017 10:29:09 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, arnd@arndb.de,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/2] em28xx: simplify ID-reading from Micron sensors
Date: Sun, 19 Feb 2017 19:29:18 +0100
Message-Id: <20170219182918.4978-2-fschaefer.oss@googlemail.com>
In-Reply-To: <20170219182918.4978-1-fschaefer.oss@googlemail.com>
References: <20170219182918.4978-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use i2c_smbus_read_word_data() instead of i2c_master_send() and
i2c_master_recv() for reading the ID of Micorn sensors.
Bytes need to be swapped afterwards, because i2c_smbus_read_word_data()
assumes that the received bytes are little-endian byte order (as specified
by smbus), while Micron sensors with 16 bit register width use big endian
byte order.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 7b4129ab1cf9..4839479624e7 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -106,8 +106,6 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 {
 	int ret, i;
 	char *name;
-	u8 reg;
-	__be16 id_be;
 	u16 id;
 
 	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
@@ -115,10 +113,8 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 	dev->em28xx_sensor = EM28XX_NOSENSOR;
 	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
 		client->addr = micron_sensor_addrs[i];
-		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
 		/* Read chip ID from register 0x00 */
-		reg = 0x00;
-		ret = i2c_master_send(client, &reg, 1);
+		ret = i2c_smbus_read_word_data(client, 0x00); /* assumes LE */
 		if (ret < 0) {
 			if (ret != -ENXIO)
 				dev_err(&dev->intf->dev,
@@ -126,24 +122,9 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 				       client->addr << 1, ret);
 			continue;
 		}
-		ret = i2c_master_recv(client, (u8 *)&id_be, 2);
-		if (ret < 0) {
-			dev_err(&dev->intf->dev,
-				"couldn't read from i2c device 0x%02x: error %i\n",
-				client->addr << 1, ret);
-			continue;
-		}
-		id = be16_to_cpu(id_be);
+		id = swab16(ret); /* LE -> BE */
 		/* Read chip ID from register 0xff */
-		reg = 0xff;
-		ret = i2c_master_send(client, &reg, 1);
-		if (ret < 0) {
-			dev_err(&dev->intf->dev,
-				"couldn't read from i2c device 0x%02x: error %i\n",
-				client->addr << 1, ret);
-			continue;
-		}
-		ret = i2c_master_recv(client, (u8 *)&id_be, 2);
+		ret = i2c_smbus_read_word_data(client, 0xff);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"couldn't read from i2c device 0x%02x: error %i\n",
@@ -151,10 +132,9 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 			continue;
 		}
 		/* Validate chip ID to be sure we have a Micron device */
-		if (id != be16_to_cpu(id_be))
+		if (id != swab16(ret))
 			continue;
 		/* Check chip ID */
-		id = be16_to_cpu(id_be);
 		switch (id) {
 		case 0x1222:
 			name = "MT9V012"; /* MI370 */ /* 640x480 */
-- 
2.11.0
