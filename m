Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33150 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756567AbdDPRmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:42:11 -0400
Received: by mail-wr0-f195.google.com with SMTP id l28so18012736wre.0
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:42:11 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, arnd@arndb.de,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2] em28xx: simplify ID-reading from Micron sensors
Date: Sun, 16 Apr 2017 19:41:52 +0200
Message-Id: <20170416174152.4416-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use i2c_smbus_read_word_data() instead of i2c_master_send() and
i2c_master_recv() for reading the ID of Micorn sensors.

i2c_smbus_read_word_data() assumes that byes are in little-endian,
so, it uses:
	data->word = msgbuf1[0] | (msgbuf1[1] << 8);

However, Micron datasheet describes the ID as if they were read
in big-endian. So, we need to change the byte order in order to
match the ID number as described on their datasheets.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 95eaa55356a9..ae87dd3e671f 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -97,8 +97,6 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 {
 	int ret, i;
 	char *name;
-	u8 reg;
-	__be16 id_be;
 	u16 id;
 
 	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
@@ -106,10 +104,8 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
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
@@ -117,24 +113,9 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
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
@@ -142,10 +123,9 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
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
2.12.2
