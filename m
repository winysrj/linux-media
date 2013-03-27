Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63328 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3C0VGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:37 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so1756106eek.12
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:36 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 7/9] em28xx: add probing procedure for OmniVision sensors
Date: Wed, 27 Mar 2013 22:06:34 +0100
Message-Id: <1364418396-8191-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OmniVision sensors are used as well in Empiatech based cameras such as the
"SpeedLink Vicious And Devine Laplace" webcam (EM2765 + Omnivision OV2640).
With this patch applied, OminiVision sensors with 8 bit address and register
width are detected (recent models have a 16 bit address width and use different
client addresses).
The most commonly used sensors (including the ones listed by Empiatech) are
detected properly, although there is no support for them yet.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |  114 +++++++++++++++++++++++++++++-
 1 Datei geändert, 113 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index d744af6..e8b3322 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -34,6 +34,13 @@ static unsigned short micron_sensor_addrs[] = {
 	I2C_CLIENT_END
 };
 
+/* Possible i2c addresses of Omnivision sensors */
+static unsigned short omnivision_sensor_addrs[] = {
+	0x42 >> 1,   /* OV7725, OV7670/60/48 */
+	0x60 >> 1,   /* OV2640, OV9650/53/55 */
+	I2C_CLIENT_END
+};
+
 
 /* FIXME: Should be replaced by a proper mt9m111 driver */
 static int em28xx_initialize_mt9m111(struct em28xx *dev)
@@ -182,13 +189,118 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 }
 
 /*
- * This method works for webcams with Micron sensors
+ * Probes Omnivision sensors with 8 bit address and register width
  */
+static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
+{
+	int ret, i;
+	char *name;
+	u8 reg;
+	u16 id;
+	struct i2c_client client = dev->i2c_client[dev->def_i2c_bus];
+
+	dev->em28xx_sensor = EM28XX_NOSENSOR;
+	/* NOTE: these devices have the register auto incrementation disabled
+	 * by default, so we have to use single byte reads !              */
+	for (i = 0; omnivision_sensor_addrs[i] != I2C_CLIENT_END; i++) {
+		client.addr = omnivision_sensor_addrs[i];
+		/* Read manufacturer ID from registers 0x1c-0x1d (BE) */
+		reg = 0x1c;
+		ret = i2c_smbus_read_byte_data(&client, reg);
+		if (ret < 0) {
+			if (ret != -ENODEV)
+				em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+					      client.addr << 1, ret);
+			continue;
+		}
+		id = ret << 8;
+		reg = 0x1d;
+		ret = i2c_smbus_read_byte_data(&client, reg);
+		if (ret < 0) {
+			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				      client.addr << 1, ret);
+			continue;
+		}
+		id += ret;
+		/* Check manufacturer ID */
+		if (id != 0x7fa2)
+			continue;
+		/* Read product ID from registers 0x0a-0x0b (BE) */
+		reg = 0x0a;
+		ret = i2c_smbus_read_byte_data(&client, reg);
+		if (ret < 0) {
+			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				      client.addr << 1, ret);
+			continue;
+		}
+		id = ret << 8;
+		reg = 0x0b;
+		ret = i2c_smbus_read_byte_data(&client, reg);
+		if (ret < 0) {
+			em28xx_errdev("couldn't read from i2c device 0x%02x: error %i\n",
+				      client.addr << 1, ret);
+			continue;
+		}
+		id += ret;
+		/* Check product ID */
+		switch (id) {
+		case 0x2642:
+			name = "OV2640";
+			break;
+		case 0x7648:
+			name = "OV7648";
+			break;
+		case 0x7660:
+			name = "OV7660";
+			break;
+		case 0x7673:
+			name = "OV7670";
+			break;
+		case 0x7720:
+			name = "OV7720";
+			break;
+		case 0x7721:
+			name = "OV7725";
+			break;
+		case 0x9648: /* Rev 2 */
+		case 0x9649: /* Rev 3 */
+			name = "OV9640";
+			break;
+		case 0x9650:
+		case 0x9652: /* OV9653 */
+			name = "OV9650";
+			break;
+		case 0x9656: /* Rev 4 */
+		case 0x9657: /* Rev 5 */
+			name = "OV9655";
+			break;
+		default:
+			em28xx_info("unknown OmniVision sensor detected: 0x%04x\n",
+				    id);
+			return 0;
+		}
+
+		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
+			em28xx_info("unsupported sensor detected: %s\n", name);
+		else
+			em28xx_info("sensor %s detected\n", name);
+
+		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
 int em28xx_detect_sensor(struct em28xx *dev)
 {
 	int ret;
 
 	ret = em28xx_probe_sensor_micron(dev);
+
+	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0)
+		ret = em28xx_probe_sensor_omnivision(dev);
+
 	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0) {
 		em28xx_info("No sensor detected\n");
 		return -ENODEV;
-- 
1.7.10.4

