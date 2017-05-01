Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41868
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S939368AbdEALiS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 May 2017 07:38:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] em28xx: allow setting the eeprom bus at cards struct
Date: Mon,  1 May 2017 08:38:10 -0300
Message-Id: <05c4899146e7f2cfa1d0bc7a5118e3f2294ede40.1493638682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, all devices use bus 0 for eeprom. However, newer
versions of Terratec H6 use a different buffer for eeprom.

So, add support to use a different I2C address for eeprom.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 1 +
 drivers/media/usb/em28xx/em28xx-i2c.c   | 5 +----
 drivers/media/usb/em28xx/em28xx.h       | 4 +++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a12b599a1fa2..c7754303e88e 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2669,6 +2669,7 @@ static inline void em28xx_set_model(struct em28xx *dev)
 
 	/* Should be initialized early, for I2C to work */
 	dev->def_i2c_bus = dev->board.def_i2c_bus;
+	dev->eeprom_i2c_bus = dev->board.eeprom_i2c_bus;
 }
 
 /* Wait until AC97_RESET reports the expected value reliably before proceeding.
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 8c472d5adb50..df0ab4b6f18f 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -665,8 +665,6 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 	*eedata = NULL;
 	*eedata_len = 0;
 
-	/* EEPROM is always on i2c bus 0 on all known devices. */
-
 	dev->i2c_client[bus].addr = 0xa0 >> 1;
 
 	/* Check if board has eeprom */
@@ -975,8 +973,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
 	dev->i2c_client[bus] = em28xx_client_template;
 	dev->i2c_client[bus].adapter = &dev->i2c_adap[bus];
 
-	/* Up to now, all eeproms are at bus 0 */
-	if (!bus) {
+	if (bus == dev->eeprom_i2c_bus) {
 		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
 		if ((retval < 0) && (retval != -ENODEV)) {
 			dev_err(&dev->intf->dev,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e8d97d5ec161..8117536343ab 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -440,7 +440,8 @@ struct em28xx_board {
 	int vchannels;
 	int tuner_type;
 	int tuner_addr;
-	unsigned def_i2c_bus;	/* Default I2C bus */
+	unsigned def_i2c_bus;		/* Default I2C bus */
+	unsigned eeprom_i2c_bus;	/* EEPROM I2C bus */
 
 	/* i2c flags */
 	unsigned int tda9887_conf;
@@ -643,6 +644,7 @@ struct em28xx {
 
 	unsigned char eeprom_addrwidth_16bit:1;
 	unsigned def_i2c_bus;	/* Default I2C bus */
+	unsigned eeprom_i2c_bus;/* EEPROM I2C bus */
 	unsigned cur_i2c_bus;	/* Current I2C bus */
 	struct rt_mutex i2c_bus_lock;
 
-- 
2.9.3
