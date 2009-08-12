Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:7946 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZHLXVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 19:21:44 -0400
Received: by an-out-0708.google.com with SMTP id d40so303932and.1
        for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 16:21:44 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 12 Aug 2009 16:21:44 -0700
Message-ID: <3ca13d320908121621u725d7c7bl8d22d571bbfb1996@mail.gmail.com>
Subject: [PATCH] adds webcam for Micron device MT9M111 0x143A to em28xx
From: Steve Gotthardt <gotthardt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

diff -r d2843f5f8fde linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Tue Aug 11
13:58:54 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Wed Aug 12
15:32:41 2009 -0700
@@ -1797,16 +1797,35 @@ static inline void em28xx_set_model(stru
               dev->board.xclk = EM28XX_XCLK_IR_RC5_MODE |
                                 EM28XX_XCLK_FREQUENCY_12MHZ;

       if (!dev->board.i2c_speed)
               dev->board.i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
                                      EM28XX_I2C_FREQ_100_KHZ;
 }

+
+/* FIXME: Should be replaced by a proper mt9m111 driver */
+static int em28xx_initialize_mt9m111(struct em28xx *dev)
+{
+       int i;
+       unsigned char regs[][3] = {
+               { 0x0d, 0x00, 0x01, },  /* reset and use defaults */
+               { 0x0d, 0x00, 0x00, },
+               { 0x0a, 0x00, 0x21, },
+               { 0x21, 0x04, 0x00, },  /* full readout speed, no
row/col skipping */
+       };
+
+       for (i = 0; i < ARRAY_SIZE(regs); i++)
+               i2c_master_send(&dev->i2c_client, &regs[i][0], 3);
+
+       return 0;
+}
+
+
 /* FIXME: Should be replaced by a proper mt9m001 driver */
 static int em28xx_initialize_mt9m001(struct em28xx *dev)
 {
       int i;
       unsigned char regs[][3] = {
               { 0x0d, 0x00, 0x01, },
               { 0x0d, 0x00, 0x00, },
               { 0x04, 0x05, 0x00, },  /* hres = 1280 */
@@ -1825,17 +1844,17 @@ static int em28xx_initialize_mt9m001(str
       for (i = 0; i < ARRAY_SIZE(regs); i++)
               i2c_master_send(&dev->i2c_client, &regs[i][0], 3);

       return 0;
 }

 /* HINT method: webcam I2C chips
 *
- * This method work for webcams with Micron sensors
+ * This method works for webcams with Micron sensors
 */
 static int em28xx_hint_sensor(struct em28xx *dev)
 {
       int rc;
       char *sensor_name;
       unsigned char cmd;
       __be16 version_be;
       u16 version;
@@ -1871,16 +1890,33 @@ static int em28xx_hint_sensor(struct em2
               dev->board.xclk = EM28XX_XCLK_FREQUENCY_4_3MHZ;
               dev->sensor_xtal = 4300000;

               /* probably means GRGB 16 bit bayer */
               dev->vinmode = 0x0d;
               dev->vinctl = 0x00;

               break;
+
+       case 0x143A:    /* MT9M111 as found in the ECS G200 */
+               dev->model = EM2750_BOARD_UNKNOWN;
+               em28xx_set_model(dev);
+
+               sensor_name = "mt9m111";
+               dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
+               dev->em28xx_sensor = EM28XX_MT9M111;
+               em28xx_initialize_mt9m111(dev);
+               dev->sensor_xres = 640;
+               dev->sensor_yres = 512;
+
+               dev->vinmode = 0x0A;
+               dev->vinctl = 0x00;
+
+               break;
+
 #if 0
       case 0x8411:
       case 0x8421:
 #endif
       case 0x8431:
               dev->model = EM2750_BOARD_UNKNOWN;
               em28xx_set_model(dev);

@@ -1891,17 +1927,17 @@ static int em28xx_hint_sensor(struct em2
               dev->sensor_yres = 1024;

               /* probably means BGGR 16 bit bayer */
               dev->vinmode = 0x0c;
               dev->vinctl = 0x00;

               break;
       default:
-               printk("Unknown Micron Sensor 0x%04x\n", be16_to_cpu(version));
+               printk("Unknown Micron Sensor 0x%04x\n", version);
               return -EINVAL;
       }

       /* Setup webcam defaults */
       em28xx_pre_card_setup(dev);

       em28xx_errdev("Sensor is %s, using model %s entry.\n",
                     sensor_name, em28xx_boards[dev->model].name);
diff -r d2843f5f8fde linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h Tue Aug 11 13:58:54 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx.h Wed Aug 12 15:32:41 2009 -0700
@@ -363,16 +363,17 @@ enum em28xx_decoder {
       EM28XX_TVP5150,
       EM28XX_SAA711X,
 };

 enum em28xx_sensor {
       EM28XX_NOSENSOR = 0,
       EM28XX_MT9V011,
       EM28XX_MT9M001,
+       EM28XX_MT9M111,
 };

 enum em28xx_adecoder {
       EM28XX_NOADECODER = 0,
       EM28XX_TVAUDIO,
 };

 struct em28xx_board {



signed off by: Steve Gotthardt <gotthardt@xxxxxxx>
