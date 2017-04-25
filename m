Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51224
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1176912AbdDYKGa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 06:06:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [RFC] em28xx: allow setting the eeprom bus at cards struct
Date: Tue, 25 Apr 2017 07:06:23 -0300
Message-Id: <8eebabc95ea53e817597a3d546cd8809e369dda8.1493114780.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, all devices use bus 0 for eeprom. However,
it seems that newer versions of Terratec H6 uses a different
buffer for eeprom.

So, add support to use a different I2C address for eeprom and
add a new card ID for the board described at:
	http://forum.kodi.tv/showthread.php?tid=312902

PS.: This patch was meant to allow testing the device. It may
be wrong or incomplete, as it doesn't attempt to set GPIOs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 20 ++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-i2c.c   |  5 +----
 drivers/media/usb/em28xx/em28xx.h       |  5 ++++-
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a12b599a1fa2..b788ae0d5646 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1193,6 +1193,23 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	[EM2884_BOARD_TERRATEC_H6] = {
+		.name         = "Terratec Cinergy H6",
+		.has_dvb      = 1,
+		.ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+#if 0
+		.tuner_type   = TUNER_PHILIPS_TDA8290,
+		.tuner_addr   = 0x41,
+		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
+		.tuner_gpio   = terratec_h5_gpio,
+#else
+		.tuner_type   = TUNER_ABSENT,
+#endif
+		.def_i2c_bus  = 1,
+		.eeprom_i2c_bus  = 1,
+		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 	[EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C] = {
 		.name         = "Hauppauge WinTV HVR 930C",
 		.has_dvb      = 1,
@@ -2496,6 +2513,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0x0ccd, 0x10b6),	/* H5 Rev. 3 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+	{ USB_DEVICE(0x0ccd, 0x10b2),	/* H6 */
+			.driver_info = EM2884_BOARD_TERRATEC_H6 },
 	{ USB_DEVICE(0x0ccd, 0x0084),
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
 	{ USB_DEVICE(0x0ccd, 0x0096),
@@ -2669,6 +2688,7 @@ static inline void em28xx_set_model(struct em28xx *dev)
 
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
index e8d97d5ec161..a333ca954129 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -148,6 +148,7 @@
 #define EM28178_BOARD_PLEX_PX_BCUD                98
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
+#define EM2884_BOARD_TERRATEC_H6		  101
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
@@ -440,7 +441,8 @@ struct em28xx_board {
 	int vchannels;
 	int tuner_type;
 	int tuner_addr;
-	unsigned def_i2c_bus;	/* Default I2C bus */
+	unsigned def_i2c_bus;		/* Default I2C bus */
+	unsigned eeprom_i2c_bus;	/* EEPROM I2C bus */
 
 	/* i2c flags */
 	unsigned int tda9887_conf;
@@ -643,6 +645,7 @@ struct em28xx {
 
 	unsigned char eeprom_addrwidth_16bit:1;
 	unsigned def_i2c_bus;	/* Default I2C bus */
+	unsigned eeprom_i2c_bus;/* EEPROM I2C bus */
 	unsigned cur_i2c_bus;	/* Current I2C bus */
 	struct rt_mutex i2c_bus_lock;
 
-- 
2.9.3
