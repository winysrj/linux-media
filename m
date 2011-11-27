Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33515 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1K0TxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 14:53:03 -0500
Received: by yenl6 with SMTP id l6so2265828yen.19
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2011 11:53:01 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 27 Nov 2011 20:53:01 +0100
Message-ID: <CAF3Vj=ryTyVTUHjAMqJBz8SHoej96ymWjrM8aqQdEJqT9imLRA@mail.gmail.com>
Subject: [PATCH] Support for Sundtek SkyTV Ultimate (USB DVB-S/S2)
From: Alessandro Miceli <angelofsky1980@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the patch to support the Sundtek SkyTV Ultimate device.
It's a USB DVB-S/S2 device based on Empia chipset 28174 + NXP TDA 10071.
Device tested with success on Intel Core i5, Ubuntu 11.10, Kernel
3.0.0, Kaffeine and latest media_build env.
The hardware profile of Sundtek device seems a clone of PCTV 460e
already supported by LinuxTV.

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>

diff -uprN orig/drivers/media/video/em28xx//em28xx-cards.c
linux/drivers/media/video/em28xx//em28xx-cards.c
--- orig/drivers/media/video/em28xx//em28xx-cards.c    2011-11-25
05:45:29.000000000 +0100
+++ linux/drivers/media/video/em28xx//em28xx-cards.c    2011-11-27
20:36:24.626783803 +0100
@@ -1888,6 +1888,14 @@ struct em28xx_board em28xx_boards[] = {
         .has_dvb       = 1,
         .ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
     },
+    [EM2884_BOARD_SUNDTEK_DVBS2] = {
+                .i2c_speed     = EM2874_I2C_SECONDARY_BUS_SELECT |
+                        EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+                .name          = "Sundtek SkyTV Ultimate",
+                .tuner_type    = TUNER_ABSENT,
+                .tuner_gpio    = pctv_460e,
+                .has_dvb       = 1,
+        },
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);

@@ -2027,6 +2035,8 @@ struct usb_device_id em28xx_id_table[] =
             .driver_info = EM28174_BOARD_PCTV_460E },
     { USB_DEVICE(0x2040, 0x1605),
             .driver_info = EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C },
+        { USB_DEVICE(0xeb1a, 0x51be),
+                        .driver_info = EM2884_BOARD_SUNDTEK_DVBS2 },
     { },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff -uprN orig/drivers/media/video/em28xx//em28xx-dvb.c
linux/drivers/media/video/em28xx//em28xx-dvb.c
--- orig/drivers/media/video/em28xx//em28xx-dvb.c    2011-11-25
05:45:29.000000000 +0100
+++ linux/drivers/media/video/em28xx//em28xx-dvb.c    2011-11-27
20:45:08.738805535 +0100
@@ -936,6 +936,11 @@ static int em28xx_dvb_init(struct em28xx
                sizeof(dvb->fe[0]->ops.tuner_ops));

         break;
+    case EM2884_BOARD_SUNDTEK_DVBS2:
+                /* attach demod */
+                dvb->fe[0] = dvb_attach(tda10071_attach,
+                        &em28xx_tda10071_config, &dev->i2c_adap);
+                break;
     case EM28174_BOARD_PCTV_460E:
         /* attach demod */
         dvb->fe[0] = dvb_attach(tda10071_attach,
diff -uprN orig/drivers/media/video/em28xx//em28xx.h
linux/drivers/media/video/em28xx//em28xx.h
--- orig/drivers/media/video/em28xx//em28xx.h    2011-11-25
05:45:29.000000000 +0100
+++ linux/drivers/media/video/em28xx//em28xx.h    2011-11-27
20:35:34.286781718 +0100
@@ -124,6 +124,7 @@
 #define EM28174_BOARD_PCTV_460E                   80
 #define EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C      81
 #define EM2884_BOARD_CINERGY_HTC_STICK          82
+#define EM2884_BOARD_SUNDTEK_DVBS2          84

 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
